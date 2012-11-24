package com.ludamix.triad.format;
import nme.utils.ByteArray;
import nme.utils.Endian;
using com.ludamix.triad.tools.ByteArrayTools;

class SMFEvent
{
	public var tick:Int; 	
	public var type:Int; 	
	public var channel:Int; 
	public var data:Dynamic;
	public function new(tick : Int, type : Int, channel : Int, data : Dynamic) 
	{ this.tick = tick; this.type = type; this.channel = channel; this.data = data; }
}

class SMF
{
	
	// Things to do:
	//    Better support for signature meta events
	//    Test more obscure things like sysex and smpte
	
	public var signature_sf : Int;
	public var signature_mi : Int;	
	public var signature_n : Int;
	public var signature_d : Int;
	public var resolution : Int;
	
	public var tracks:Array<Array<SMFEvent>>;		
	public var track_texts:Array<Array<{tick:Int,message:String,type:Int}>>;
	public var tempos : Array<{tick:Int,tempo:Int,bpm:Float}>;
	
	public static function read(bytes : ByteArray)
	{
		bytes.position = 0;
		var smf = new SMF(0, 0, 0, 0, 0);
		var len:Int = 0;
		var num_tracks = 1;
		var format = 0;
		while (bytes.bytesAvailable > 4) { // don't know if it's correct, but some files seem to be padding their ending
			var type:String = bytes.readASCII(4);
			switch(type) {
			case "MThd": // MIDI header
				bytes.position += 4;
				format = bytes.readUnsignedShort(); // Type-0, Type-1, Type-2
				num_tracks = bytes.readUnsignedShort();
				smf.resolution = bytes.readUnsignedShort();
				// resolution tells us how our delta times relate to time signature
				if ((smf.resolution & 0x800) == 0) // we're using "ticks per beat" aka "pulses per quarter note" method
				{
					//trace(resolution);
				}
				else // we're using "frames per second" method.
				{
					var fps = Math.abs(smf.resolution >> 8);
					var frame_subdivisions = smf.resolution & 0xFF;
				}
			case "MTrk": // start of track data
				len = bytes.readUnsignedInt();
				var tk = smf.getTrack(bytes);
				smf.tracks.push(tk.track);
				smf.track_texts.push(tk.text);
			default:
				len = bytes.readUnsignedInt();
				bytes.position += len;
			}
		}
		return smf;
	}

	private inline function trackEvent(track : Array<SMFEvent>, tick : Int, type : Int, channel : Int, data : Dynamic)
		{ track.push( new SMFEvent(tick, type, channel, data)); }
		
	private inline function getTrack(bytes : ByteArray)
	{
		
		var track = new Array<SMFEvent>();
		var track_text = new Array<{tick:Int,type:Int,message:String}>();
		
		var cont = true;
		
		var delta_time = 0;
		var time = 0;		
		
		var oldstatus = 0;
		var status = 0;
		
		while (bytes.bytesAvailable > 0 && cont) 
		{
			delta_time = readVariableLength(bytes);
			time += delta_time;
			
			// status byte reusage rules:
			// if the last status was between 0x80 and 0xEF, we
			// can reuse it when we see an upcoming data byte.
			// status bytes above 0xEF have other rules.
			
			if (status>=0x80 && status<=0xEF) // reusable
			{
				oldstatus = status;
			}
			else if (status >= 0xF0 && status <= 0xF7) // System Common Category messages - CLEAR the status.
			{
				oldstatus = 0;
			}
			// else we have a Real Time Category message, which doesn't get reused but also doesn't clear
			
			status = bytes.readUnsignedByte();
			if (status < 0x80) // we got a data byte
			{
				status = oldstatus;
				bytes.position -= 1;
			}
			
			// now we have to discern if this is a meta/sysex event or a regular track status.
			
			if (status == META)
			{
				var metaEventType:Int = bytes.readUnsignedByte() | 0xff00;
				var len = readVariableLength(bytes);				
				if ((metaEventType & 0x00f0) == 0) {
					var text = bytes.readASCII(len);
					track_text.push({tick:time,message:text,type:metaEventType});
				} else {
					switch (metaEventType) {
					case META_KEY_SIGNATURE:
						this.signature_sf = bytes.readUnsignedByte();
						this.signature_mi = bytes.readUnsignedByte();
					case META_TEMPO:
						var tempo = ((bytes.readUnsignedByte() << 16) | bytes.readUnsignedShort());
						var bpm = 60000000 / tempo;
						this.tempos.push({ tick:time, tempo:tempo, bpm:bpm});
					case META_TIME_SIGNATURE:
						var value = (bytes.readUnsignedByte() << 16) | (1 << bytes.readUnsignedByte());
						this.signature_n = value>>16;
						this.signature_d = value & 0xffff;
						bytes.position += 2;
					case META_PORT:
						var value = bytes.readUnsignedByte();
					case META_TRACK_END:  
						cont = false;
					default:
						bytes.position += len;
					}
				}
			}
			else if (status == SYSTEM_EXCLUSIVE || status == SYSTEM_EXCLUSIVE_SHORT)
			{
				// walk through sysex data
				status = 0;
				while (status != SYSTEM_EXCLUSIVE_SHORT) { status = bytes.readUnsignedByte(); }
			}
			else
			{
				var status_base = status & 0xf0;
				var channel = status & 0x0f;
				switch (status_base) 
				{
					case PROGRAM_CHANGE:
						trackEvent(track, delta_time, status_base, channel, bytes.readUnsignedByte());
					case CHANNEL_PRESSURE:
						trackEvent(track, delta_time, status_base, channel, bytes.readUnsignedByte());
					case NOTE_OFF:
						trackEvent(track, delta_time, status_base, channel, 
							{note:bytes.readUnsignedByte(),velocity:bytes.readUnsignedByte()});
					case NOTE_ON:
						trackEvent(track, delta_time, status_base, channel, 
							{note:bytes.readUnsignedByte(),velocity:bytes.readUnsignedByte()});
					case KEY_PRESSURE:
						trackEvent(track, delta_time, status_base, channel, 
							{note:bytes.readUnsignedByte(),pressure:bytes.readUnsignedByte()});
					case CONTROL_CHANGE:
						trackEvent(track, delta_time, status_base, channel, 
							{ controller:bytes.readUnsignedByte(), value:bytes.readUnsignedByte() } );
					case PITCH_BEND:
						var lsb = bytes.readUnsignedByte();
						var msb = bytes.readUnsignedByte();
						trackEvent(track, delta_time, status_base, channel, 
							lsb | (msb << 7));
					default:
						throw "error: bad status("+Std.string(status)+") " + Std.string(status_base) +
							" on channel "+Std.string(channel)+" at "+Std.string(bytes.position);
				}
			
			}
		}
		
		return {track:track,text:track_text};
		
	}
	
	private static function readVariableLength(bytes:ByteArray, ?time:Int = 0) : Int
	{
		var t : Int = bytes.readUnsignedByte();
		time += t & 0x7F;
		return (t & 0x80)>0 ? readVariableLength(bytes, time<<7) : time;
	}
	
	public static inline var NOTE_OFF = 0x80;
	public static inline var NOTE_ON = 0x90;
	public static inline var KEY_PRESSURE = 0xa0;
	public static inline var CONTROL_CHANGE = 0xb0;
	public static inline var PROGRAM_CHANGE = 0xc0;
	public static inline var CHANNEL_PRESSURE = 0xd0;
	public static inline var PITCH_BEND = 0xe0;
	public static inline var SYSTEM_EXCLUSIVE = 0xf0;
	public static inline var SYSTEM_EXCLUSIVE_SHORT = 0xf7;
	public static inline var META = 0xff;
		
	public static inline var META_SEQNUM = 0xff00;
	public static inline var META_TEXT = 0xff01;
	public static inline var META_AUTHOR = 0xff02;
	public static inline var META_TITLE = 0xff03;
	public static inline var META_INSTRUMENT = 0xff04;
	public static inline var META_LYRICS = 0xff05;
	public static inline var META_MARKER = 0xff06;
	public static inline var META_CUE = 0xff07;
	public static inline var META_PROGRAM_NAME = 0xff08;
	public static inline var META_DEVICE_NAME = 0xff09;
	public static inline var META_CHANNEL = 0xff20;
	public static inline var META_PORT = 0xff21;
	public static inline var META_TRACK_END = 0xff2f;
	public static inline var META_TEMPO = 0xff51;
	public static inline var META_SMPTE_OFFSET = 0xff54;
	public static inline var META_TIME_SIGNATURE = 0xff58;
	public static inline var META_KEY_SIGNATURE = 0xff59;
	public static inline var META_SEQUENCER_SPEC = 0xff7f;
	
	public static inline var CC_BANK_SELECT_MSB = 0;
	public static inline var CC_BANK_SELECT_LSB = 32;
	public static inline var CC_MODULATION = 1;
	public static inline var CC_PORTAMENTO_TIME = 5;
	public static inline var CC_DATA_ENTRY_MSB = 6;
	public static inline var CC_DATA_ENTRY_LSB = 38;
	public static inline var CC_VOLUME = 7;
	public static inline var CC_BALANCE = 8;
	public static inline var CC_PAN = 10;
	public static inline var CC_EXPRESSION = 11;
	public static inline var CC_SUSTAIN_PEDAL = 64;
	public static inline var CC_PORTAMENTO = 65;
	public static inline var CC_SOSTENUTO_PEDAL = 66;
	public static inline var CC_SOFT_PEDAL = 67;
	public static inline var CC_RESONANCE = 71;
	public static inline var CC_RELEASE_TIME = 72;
	public static inline var CC_ATTACK_TIME = 73;
	public static inline var CC_CUTOFF_FREQ = 74;
	public static inline var CC_DECAY_TIME = 75;
	public static inline var CC_PROTAMENTO_CONTROL = 84;
	public static inline var CC_REBERV_SEND = 91;
	public static inline var CC_CHORUS_SEND = 93;
	public static inline var CC_DELAY_SEND = 94;
	public static inline var CC_NRPN_LSB = 98;
	public static inline var CC_NRPN_MSB = 99;
	public static inline var CC_RPN_LSB = 100;
	public static inline var CC_RPN_MSB = 101;	
	public static inline var CC_ALL_SOUND_OFF = 120;
	public static inline var CC_ALL_CONTROLLERS_OFF = 121;
	public static inline var CC_LOCAL_KEYBOARD_OFF = 122;
	public static inline var CC_ALL_NOTES_OFF = 123;
	
	public static inline var RPN_PITCHBEND_SENCE = 0;
	public static inline var RPN_FINE_TUNE = 1;
	public static inline var RPN_COARSE_TUNE = 2;

	public function new(signature_n, signature_d, signature_sf, signature_mi, resolution)
	{
		this.signature_n = signature_n;
		this.signature_d = signature_d;
		this.signature_sf = signature_sf;
		this.signature_mi = signature_mi;
		this.resolution = resolution;
		this.tracks = new Array();
		this.track_texts = new Array();
		this.tempos = new Array();
	}
	
	public function toByteArray(?ticks_stored_as_delta = true)
	{
		if (tracks.length == 0) throw "no tracks available!";
		
		var bytes = new ByteArray();
		bytes.endian = Endian.BIG_ENDIAN;
		bytes.writeASCII("MThd");
		bytes.writeInt(6);
		
		var prepped_tracks = new Array<Array<SMFEvent>>();
		
		// copy tracks and convert to absolute timing (so that we can inject the meta and tempo a bit more easily)
		if (ticks_stored_as_delta)
		{
			for (t in tracks)
			{
				var cur_tick = 0;
				var prep = new Array<SMFEvent>();
				for (e in t) 
				{
					cur_tick += e.tick;
					var e_abs = new SMFEvent(cur_tick, e.type, e.channel, e.data);
					prep.push(e_abs);
				}
				
				prepped_tracks.push(prep);
			}			
		}
		else
		{
			for (t in tracks)
			{
				var prep = new Array<SMFEvent>();
				for (e in t) 
				{
					prep.push(new SMFEvent(e.tick, e.type, e.channel, e.data));
				}
				
				prepped_tracks.push(prep);
			}			
		}
		
		for (n in 0...track_texts.length)
		{
			var t = prepped_tracks[n];
			var tt = track_texts[n];
			for (text in tt)
			{
				t.push(new SMFEvent(text.tick, text.type, 0, text.message));
				trace([text.tick, text.message]);
			}
		}
		
		var meta_track : Array<SMFEvent> = null;
		if (prepped_tracks.length>0)
			meta_track = prepped_tracks[0];
		else { meta_track = new Array<SMFEvent>(); prepped_tracks.push(meta_track); }
		meta_track.push(new SMFEvent(0, META_KEY_SIGNATURE, 0, {sf:signature_sf,mi:signature_mi}));
		for (n in 0...tempos.length)
		{
			meta_track.push(new SMFEvent(tempos[n].tick, META_TEMPO, 0, tempos[n].tempo)); 
		}
		
		for (t in prepped_tracks) t.sort(function(a, b) { if (a.tick == b.tick) return b.type - a.type;
			else return a.tick - b.tick; } );
		
		// finish header
		if (prepped_tracks.length==1)
			bytes.writeShort(0);
		else
			bytes.writeShort(1);
		bytes.writeShort(prepped_tracks.length);
		bytes.writeShort(resolution);
		
		var cur_track = 0;
		for (track in prepped_tracks)
		{
			var cur_tick = 0;
			
			bytes.writeASCII("MTrk");
			var tl_pos = bytes.position;
			bytes.writeUnsignedInt(0xDEADBEEF); // placeholder
			
			var l_e : SMFEvent = null;
			for (e in track)
			{			
				writeEvent(bytes, e, l_e, cur_tick);
				l_e = e;
				
				cur_tick = e.tick;
			}
			
			writeEvent(bytes, new SMFEvent(cur_tick, META_TRACK_END, 0, null), null, cur_tick);
			
			// rewrite header
			var end_pos = bytes.position;
			bytes.position = tl_pos;
			bytes.writeUnsignedInt(end_pos - tl_pos - 4);
			bytes.position = end_pos;
			
			cur_track++;
		}
		
		return bytes;
	}
	
	private inline function writeEvent(bytes : ByteArray, ev : SMFEvent, last_ev : SMFEvent, cur_tick : Int)
	{
		if (bytes.position < 120) trace([ev.type,ev.channel,ev.data,ev.tick,bytes.position]);
		writeVariableLength(bytes, ev.tick-cur_tick);
		if (ev.type >= META)
		{
			bytes.writeShort(ev.type);
			switch(ev.type)
			{
				case META_TEXT, META_AUTHOR, META_LYRICS, META_CUE, META_MARKER, META_TITLE, 
					META_INSTRUMENT, META_PROGRAM_NAME, META_DEVICE_NAME:
					writeVariableLength(bytes, ev.data.length);
					bytes.writeASCII(ev.data);
				case META_SEQNUM: // the seq number for type 2 MIDI
					writeVariableLength(bytes, 2);
					bytes.writeShort(ev.data);
				case META_TIME_SIGNATURE:
					writeVariableLength(bytes, 4);
					bytes.writeByte(ev.data.numerator); 
					bytes.writeByte(ev.data.denominator);
					bytes.writeByte(ev.data.ticks_per_quarter); // MIDI ticks
					bytes.writeByte(ev.data.notated_32nds_per_quarter); // Notated values
					// FF 58 04 06 03 24 08 = TS (4 bytes) 4/6, 24 clocks per quarter, 8 32nds per quarter
				case META_KEY_SIGNATURE:
					writeVariableLength(bytes, 2);
					bytes.writeByte(ev.data.sf); // sharps and flats, 0 = C, 1 = 1 sharp, -1 = 1 flat, etc.
					bytes.writeByte(ev.data.mi); // major/minor: 0 = major, 1 = minor
				case META_TRACK_END:
					writeVariableLength(bytes, 0);
				case META_TEMPO:
					writeVariableLength(bytes, 3);
					bytes.writeByte(ev.data >> 16); 
					bytes.writeByte((ev.data >> 8) & 0xFF); 
					bytes.writeByte(ev.data & 0xFF); 
				case META_CHANNEL, META_PORT:
					writeVariableLength(bytes, 1);
					bytes.writeByte(ev.data);
				case META_SMPTE_OFFSET:
					writeVariableLength(bytes, 5);
					bytes.writeByte(ev.data.hours);
					bytes.writeByte(ev.data.minutes);
					bytes.writeByte(ev.data.seconds);
					bytes.writeByte(ev.data.frames);
					bytes.writeByte(ev.data.frame_fractions);
				default:
					throw "wrote a meta i didn't cover";
			}
		}
		else if (ev.type == SYSTEM_EXCLUSIVE || ev.type == SYSTEM_EXCLUSIVE_SHORT)
		{
			bytes.writeShort(ev.type);
			writeVariableLength(bytes, ev.data.length);
			bytes.writeASCII(ev.data);
		}
		else
		{
			
			if (ev.type == NOTE_OFF && ev.data.velocity == 0)
				{ ev.type = NOTE_ON; }
			if (last_ev == null || last_ev.type != ev.type || last_ev.channel != ev.channel)
				bytes.writeByte(ev.type | ev.channel);
			switch(ev.type)
			{
				case NOTE_ON: bytes.writeByte(ev.data.note); bytes.writeByte(ev.data.velocity);
				case NOTE_OFF: bytes.writeByte(ev.data.note); bytes.writeByte(ev.data.velocity);
				case KEY_PRESSURE: bytes.writeByte(ev.data.note); bytes.writeByte(ev.data.pressure);
				case CONTROL_CHANGE: bytes.writeByte(ev.data.controller); bytes.writeByte(ev.data.value);
				case PROGRAM_CHANGE: bytes.writeByte(ev.data);
				case CHANNEL_PRESSURE: bytes.writeByte(ev.data);
				case PITCH_BEND: bytes.writeByte(ev.data & 0x7F); bytes.writeByte((ev.data & 0x7F00) >> 7);
				default: throw "wrote a midi code i don't cover";
			}
		}
	}
	
	public function setTimeSignature(numerator : Int, denominator : Int)
	{
		signature_n = numerator;
		signature_d = denominator;
	}
	
	public function addEvent(event : SMFEvent, ?track = 0)
	{
		while (tracks.length - 1 < track) { tracks.push(new Array()); track_texts.push(new Array()); }
		tracks[track].push(event);
	}
	
	public function addTempo(tick : Int, bpm : Float):Void 
	{
		tempos.push({tick:tick, bpm:bpm, tempo:Std.int(60000000/bpm)});
	}

	public function addText(tick : Int, track : Int, text : String, meta_type : Int):Void 
	{
		while (tracks.length - 1 < track) { tracks.push(new Array()); track_texts.push(new Array()); }
		track_texts[track].push({tick:tick,message:text,type:meta_type});
	}
	
	private static function writeVariableLength(bytes:ByteArray, value:Int)
	{
        var buffer = value & 0x7f;
        while ((value >>= 7) >0)
        {
            buffer <<=  8; 
            buffer |= 0x80;
            buffer += (value & 0x7f);
        }
        while (true)
        {
			bytes.writeByte(buffer);
            if (buffer & 0x80 != 0)
                buffer >>= 8;
            else
                break;
        }
	}
	
}