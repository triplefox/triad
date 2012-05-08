package com.ludamix.triad.audio;

import haxe.io.Bytes;
import haxe.io.BytesInput;
import haxe.io.Input;
import nme.utils.ByteArray;
import haxe.Timer;
import com.ludamix.triad.audio.Sequencer;

typedef SMFEvent = { tick:Int, type:Int, channel:Int, data:Dynamic };

/* TODO: Understand more events.
   TODO: Make a streamable MIDI implementation? Main reason to do so is for more dynamic tracks.
 */

class SMFData
{
	
	public var signature_n : Int;
	public var signature_d : Int;
	public var format : Int;
	public var num_tracks : Int;
	public var resolution : Int;
	public var tracks:Array<Array<SMFEvent>>;		
	public var tempos : Array<{tick:Int,tempo:Int,bpm:Float}>;
	
	public function new() 
	{
		tempos = new Array();
		tracks = new Array(); 
		format = 0;
		num_tracks = 0;
		resolution = 0;		
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
	
}

class SMFReader
{
	
	// Reads SMF bytes and returns a SMFData.
	
	public var i : Input;
	
	public function new(i : Input) { this.i = i; }
	
	public function readContent() : SMFData
	{
		var smf = new SMFData();
		
      #if flash
		var bytes = i.readAll().getData();
      #else
		var bytes = ByteArray.fromBytes(i.readAll());
      #end
		
		var len:Int = 0;
		while (bytes.bytesAvailable > 4) { // don't know if it's correct, but some files seem to be padding their ending
			var type:String = bytes.readMultiByte(4, "us-ascii");
			switch(type) {
			case "MThd": // MIDI header
				bytes.position += 4;
				smf.format = bytes.readUnsignedShort(); // Type-0, Type-1, Type-2
				smf.num_tracks = bytes.readUnsignedShort();
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
				smf.tracks.push(getTrack(bytes, smf));
			default:
				len = bytes.readUnsignedInt();
				bytes.position += len;
			}
		}
		smf.tempos.sort(function(a, b) { return a.tick - b.tick;  } );
		
		return smf;
	}
	
	private function trackEvent(track : Array<SMFEvent>, tick : Int, type : Int, channel : Int, data : Dynamic)
		{ track.push( { tick:tick, type:type, channel:channel, data:data }); }
	
	private inline function getTrack(bytes:ByteArray, smf : SMFData)
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
			
			if (status == SMFData.META)
			{
				var event:{type:Int, value:Int} = null; 
				var metaEventType:Int = bytes.readUnsignedByte() | 0xff00;
				var len = readVariableLength(bytes);				
				if ((metaEventType & 0x00f0) == 0) {
					// meta text data - ignore
					var text = bytes.readMultiByte(len, "Shift-JIS");
				} else {
					switch (metaEventType) {
					case SMFData.META_TEMPO:
						var tempo = ((bytes.readUnsignedByte() << 16) | bytes.readUnsignedShort());
						var bpm = 60000000 / tempo;
						smf.tempos.push({ tick:time, tempo:tempo, bpm:bpm});
					case SMFData.META_TIME_SIGNATURE:
						// not properly implemented yet... it should be like tempo changes.
						var value = (bytes.readUnsignedByte() << 16) | (1 << bytes.readUnsignedByte());
						smf.signature_n = value>>16;
						smf.signature_d = value & 0xffff;
						bytes.position += 2;
					case SMFData.META_PORT:
						var value = bytes.readUnsignedByte();
					case SMFData.META_TRACK_END:  
						cont = false;
					default:
						bytes.position += len;
					}
				}
			}
			else if (status == SMFData.SYSTEM_EXCLUSIVE || status == SMFData.SYSTEM_EXCLUSIVE_SHORT)
			{
				// walk through sysex data
				status = 0;
				while (status != SMFData.SYSTEM_EXCLUSIVE_SHORT) { status = bytes.readUnsignedByte(); }
			}
			else
			{
				var status_base = status & 0xf0;
				var channel = status & 0x0f;
				switch (status_base) 
				{
					case SMFData.PROGRAM_CHANGE:
						trackEvent(track, delta_time, status_base, channel, bytes.readUnsignedByte());
					case SMFData.CHANNEL_PRESSURE:
						trackEvent(track, delta_time, status_base, channel, bytes.readUnsignedByte());
					case SMFData.NOTE_OFF:
						trackEvent(track, delta_time, status_base, channel, 
							{note:bytes.readUnsignedByte(),velocity:bytes.readUnsignedByte()});
					case SMFData.NOTE_ON:
						trackEvent(track, delta_time, status_base, channel, 
							{note:bytes.readUnsignedByte(),velocity:bytes.readUnsignedByte()});
					case SMFData.KEY_PRESSURE:
						trackEvent(track, delta_time, status_base, channel, 
							{note:bytes.readUnsignedByte(),pressure:bytes.readUnsignedByte()});
					case SMFData.CONTROL_CHANGE:
						trackEvent(track, delta_time, status_base, channel, 
							{ controller:bytes.readUnsignedByte(), value:bytes.readUnsignedByte() } );
					case SMFData.PITCH_BEND:
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
	
}

class SMFParser
{
	
	// SMF parser based in part upon the code in SiON, as well as a variety of online tutorials and references.
	// Should read type 0 and type 1 SMF, and allows a custom filtering function to be used to translate the raw events
	// however you like.
	
	// This is, at present, not a streaming parser. 
	// It reads the SMF as one batch and translates it to Triad sequencer events directly.
	
	// Example in https://github.com/triplefox/triad/blob/master/examples/Source/SynthTest.hx
	
	public static function load(sequencer : Sequencer, bytes:ByteArray, ?filter = null, 
		?init_filter = null) : Array<SequencerEvent>
	{
		
		if (filter == null) filter = defaultFilter;
		if (init_filter == null) init_filter = defaultInit;
		
		var parser = new SMFParser(sequencer, bytes, filter, init_filter);
		
		return parser.run();
		
	}
	
	public function new(sequencer, ?bytes, ?filter, ?init_filter) 
		{ this.sequencer = sequencer;  this.bytes = bytes; this.filter = filter; this.init_filter = init_filter; }

	public var smf : SMFData;
	
	public var events:Array<SequencerEvent>;
	public var filter : SMFEvent->Int->Float->Sequencer->Dynamic->SequencerEvent;
	public var init_filter : Void->Dynamic;
	public var bytes : ByteArray;
	public var sequencer : Sequencer;

	public function run()
	{
		
		// Read SMF headers and track chunks.
		
		bytes.position = 0;
      #if flash
		var reader = new SMFReader(new BytesInput(Bytes.ofData(bytes)));
      #else
		var reader = new SMFReader(new BytesInput(bytes));
      #end
		smf = reader.readContent();
		
		events = new Array();
		
		// now we use the tick delta timings and tempo mapping to convert into sequencer frames, and
		// do the final filtering.
		
		var filter_persistent : Dynamic = init_filter();
		
		for (track in smf.tracks)
		{
			var tempos_future = smf.tempos.copy();
			if (tempos_future.length == 0) // uh oh...fill in a default
				{tempos_future = [ { tick:0, tempo:120 * 60000000, bpm:120.0 } ]; trace("no tempo found");}
			var tempos_past = new Array<{tick:Int,tempo:Int,bpm:Float}>();
			var ticks = 0;
			var frames = 0.;
			tempos_past.push(tempos_future.shift());
			for (n in track)
			{
				
				
				var tick_delta = n.tick;
				
				while (tempos_future.length > 0 && (ticks+tick_delta) > tempos_future[0].tick)
				{
					// rewrite the tick delta as we traverse over any number of tempos
					var lt = tempos_past[tempos_past.length - 1];
					tempos_past.push(tempos_future.shift());
					var ct = tempos_past[tempos_past.length - 1];
					tick_delta = ticks + tick_delta - ct.tick;
					frames += (ct.tick - ticks) * framesOfTempo(lt.bpm, smf, sequencer);
					ticks = ct.tick;
				}
				
				ticks += tick_delta;
				frames += tick_delta * framesOfTempo(tempos_past[tempos_past.length-1].bpm, smf, sequencer);
				
				var result = filter(n, ticks, frames, sequencer, filter_persistent);
				if (result != null) events.push(result);
				
			}
		}
		
		return events;
		
	}
	
	public static inline function framesOfTempo(bpm : Float, smf : SMFData, sequencer : Sequencer)
	{
		return sequencer.BPMToFrames(1 / smf.resolution, bpm);
	}
	
	public static function defaultFilter(smf:SMFEvent, ticks : Int, frames : Float, 
		sequencer : Sequencer, persistent : Dynamic)
	{
		if (smf.type == SMFData.NOTE_ON && smf.data.velocity == 0) // optimize - part of specced behavior
			smf.type = SMFData.NOTE_OFF;
		
		switch(smf.type)
		{
			case SMFData.NOTE_ON:
				var unique_calc = smf.data.note + (smf.channel << 16);
				var note_id = persistent.note_uniques.get(unique_calc);
				return (new SequencerEvent(SequencerEvent.NOTE_ON,
					{freq:sequencer.tuning.midiNoteToFrequency(smf.data.note),velocity:smf.data.velocity},
												smf.channel,
												note_id,
												frames,
												Std.int(frames)));
			case SMFData.NOTE_OFF:
				var unique_calc = smf.data.note + (smf.channel << 16);
				var note_id = persistent.note_uniques.get(unique_calc);
				persistent.id_ct++;
				persistent.note_uniques.set(unique_calc, persistent.id_ct);
				return (new SequencerEvent(SequencerEvent.NOTE_OFF,
					{freq:sequencer.tuning.midiNoteToFrequency(smf.data.note),velocity:smf.data.velocity},
												smf.channel,
												note_id,
												frames,
												Std.int(frames)));
			case SMFData.PITCH_BEND:
				return (new SequencerEvent(SequencerEvent.PITCH_BEND,
												smf.data - 8192,
												smf.channel,
												SequencerEvent.CHANNEL_EVENT,
												frames,
												-1));
			case SMFData.PROGRAM_CHANGE:
				return (new SequencerEvent(SequencerEvent.SET_PATCH,
												smf.data,
												smf.channel,
												SequencerEvent.CHANNEL_EVENT,
												frames,
												-1));
			case SMFData.CONTROL_CHANGE:
				switch(smf.data.controller)
				{
					case SMFData.CC_VOLUME:
						return (new SequencerEvent(SequencerEvent.VOLUME,
														smf.data.value/128,
														smf.channel,
														SequencerEvent.CHANNEL_EVENT,
														frames,
														-1));			
					case SMFData.CC_MODULATION:
						return (new SequencerEvent(SequencerEvent.MODULATION,
														smf.data.value/128,
														smf.channel,
														SequencerEvent.CHANNEL_EVENT,
														frames,
														-1));			
					case SMFData.CC_PAN:
						return (new SequencerEvent(SequencerEvent.PAN,
														smf.data.value/128,
														smf.channel,
														SequencerEvent.CHANNEL_EVENT,
														frames,
														-1));
					case SMFData.CC_BANK_SELECT_LSB: // we assume this is the same as program change...
						return (new SequencerEvent(SequencerEvent.SET_PATCH,
												smf.data,
												smf.channel,
												SequencerEvent.CHANNEL_EVENT,
												frames,
												-1));
					case SMFData.CC_SUSTAIN_PEDAL:
						return (new SequencerEvent(SequencerEvent.SUSTAIN_PEDAL,
												smf.data,
												smf.channel,
												SequencerEvent.CHANNEL_EVENT,
												frames,
												-1));
					case SMFData.CC_ALL_NOTES_OFF:
						return (new SequencerEvent(SequencerEvent.ALL_NOTES_OFF,
												smf.data,
												smf.channel,
												SequencerEvent.CHANNEL_EVENT,
												frames,
												-1));
					default:
						trace(["unimplemented cc", smf.data]);
						return null;
				}
			default:
				trace(["unimplemented", smf.type]);
				return null;
		}
	}
	
	public static function defaultInit() : Dynamic
	{
		// we assign a unique id for each on-off pattern in each note and channel.
		var t = { note_uniques:new IntHash<Int>(), id_ct : 0 };
		for ( n in 0...128 )
		{
			for (c in 0...16)
			{
				t.note_uniques.set(n + (c << 16 ), t.id_ct);
				t.id_ct++;
			}
		}
		return t;
	}
		
}
