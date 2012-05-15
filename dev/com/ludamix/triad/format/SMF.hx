package com.ludamix.triad.format;
import nme.utils.ByteArray;

class SMFEvent
{
	public var tick:Int; 	
	public var type:Int; 	
	public var channel:Int; 
	public var data:Dynamic;
	public function new(tick, type, channel, data) 
	{ this.tick = tick; this.type = type; this.channel = channel; this.data = data; }
}

class SMF
{
	
	public var signature_n : Int;
	public var signature_d : Int;
	public var resolution : Int;
	public var tracks:Array<Array<SMFEvent>>;		
	public var tempos : Array<{tick:Int,tempo:Int,bpm:Float}>;
	
	public static function read(bytes : ByteArray)
	{
		var smf = new SMF(0, 0, 0);
		var len:Int = 0;
		var num_tracks = 1;
		var format = 0;
		while (bytes.bytesAvailable > 4) { // don't know if it's correct, but some files seem to be padding their ending
			var type:String = bytes.readMultiByte(4, "us-ascii");
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
				else // we're using "frames per second" method - not implemented yet
				{
				}
			case "MTrk": // start of track data
				len = bytes.readUnsignedInt();
				smf.tracks.push(smf.getTrack(bytes));
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
				var event:{type:Int, value:Int} = null; 
				var metaEventType:Int = bytes.readUnsignedByte() | 0xff00;
				var len = readVariableLength(bytes);				
				if ((metaEventType & 0x00f0) == 0) {
					// meta text data - ignore
					var text = bytes.readMultiByte(len, "us-ascii");
				} else {
					switch (metaEventType) {
					case META_TEMPO:
						var tempo = ((bytes.readUnsignedByte() << 16) | bytes.readUnsignedShort());
						var bpm = 60000000 / tempo;
						this.tempos.push({ tick:time, tempo:tempo, bpm:bpm});
					case META_TIME_SIGNATURE:
						// not properly implemented yet... it should be like tempo changes.
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
		
		return track;
		
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

	public function new(signature_n, signature_d, resolution)
	{
		this.signature_n = signature_n;
		this.signature_d = signature_d;
		this.resolution = resolution;
		this.tracks = new Array();
		this.tempos = new Array();
	}
	
	public function toByteArray()
	{
		// for now we'll save only type 0
	}
	
}