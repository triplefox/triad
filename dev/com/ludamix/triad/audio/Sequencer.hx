package com.ludamix.triad.audio;

import flash.events.SampleDataEvent;
import nme.media.Sound;
import nme.media.SoundChannel;
import nme.utils.ByteArray;
import nme.Vector;
import haxe.Timer;
import com.ludamix.triad.tools.MathTools;
import com.ludamix.triad.audio.MIDITuning;

// TODO: Upgrade the synth, understand more MIDI events, be able to load an instrument spec.

// I am still not 100% sure about tempo changes, however they seem pretty stable in my current tests.
// 		(I need to upgrade the synth quality to tell what's going on in the wing commander track)

typedef SMFEvent = { tick:Int, type:Int, channel:Int, data:Dynamic };

class SMFParser
{
	
	// SMF parser based in part upon the code in SiON, as well as a variety of online tutorials and references.
	// Should read type 0 and type 1 SMF, and allows a custom filtering function to be used to translate the raw events
	// however you like.
	
	// To emulate the MIDI style on-off, we default id to == midi note number, and we include velocity with on events.
	// Our on-off is a bit more flexible, which is fine.
	
	// Currently only does on and off, and ignores velocity, pitch, etc.
	
	// Example in https://github.com/triplefox/triad/blob/master/examples/Source/SynthTest.hx
	
	public static function load(sequencer : Sequencer, bytes:ByteArray, ?filter = null) : Array<SequencerEvent>
	{
		
		if (filter == null) filter = default_filter;
		
		var parser = new SMFParser(sequencer, bytes, filter);
		
		return parser.run();
		
	}
	
	public function new(sequencer, ?bytes, ?filter) 
		{ this.sequencer = sequencer;  this.bytes = bytes; this.filter = filter; }
	
	public var deltaTime : Int;
	public var time : Int;
	public var signature_n : Int;
	public var signature_d : Int;
	public var format : Int;
	public var numTracks : Int;
	public var resolution : Int;
	public var tempos : Array<{tick:Int,tempo:Int,bpm:Float,frames:Float}>;
	public var tracks:Array<Array<SMFEvent>>;
	public var events:Array<SequencerEvent>;
	public var filter : SMFEvent->Int->Float->Sequencer->SequencerEvent;
	public var bytes : ByteArray;
	public var sequencer : Sequencer;

	public function run()
	{
		
		// Read SMF headers and track chunks.
		
		bytes.position = 0;
		
		format = 0;
		numTracks = 0;
		resolution = 0;
		events = new Array();
		tracks = new Array();
		tempos = new Array();
		
		var len:Int = 0;
		while (bytes.bytesAvailable > 4) { // don't know if it's correct, but some files seem to be padding their ending
			var type:String = bytes.readMultiByte(4, "us-ascii");
			switch(type) {
			case "MThd": // MIDI header
				bytes.position += 4;
				format = bytes.readUnsignedShort(); // Type-0, Type-1, Type-2
				numTracks = bytes.readUnsignedShort();
				resolution = bytes.readUnsignedShort();
				// resolution tells us how our delta times relate to time signature
				if ((resolution & 0x800) == 0) // we're using "ticks per beat" aka "pulses per quarter note" method
				{
					//trace(resolution);
				}
				else // we're using "frames per second" method - not implemented yet
				{
				}
			case "MTrk": // start of track data
				len = bytes.readUnsignedInt();
				tracks.push(get_track(bytes));
			default:
				len = bytes.readUnsignedInt();
				bytes.position += len;
			}
		}
		
		// now we use the tick delta timings and tempo mapping to convert into sequencer frames, and
		// do the final filtering.
		
		tempos.sort(function(a, b) { return a.tick - b.tick;  } );
		
		for (track in tracks)
		{
			var tempos_future = tempos.copy();
			var tempos_past = new Array<{tick:Int,tempo:Int,bpm:Float,frames:Float}>();
			var ticks = 0;
			var frames = 0.;
			var tempos_traversed = 0;
			tempos_past.push(tempos_future.shift());
			for (n in track)
			{
				tempos_traversed = 0;
				
				// The most difficult part of this conversion is the possibility of any number of tempo changes
				// within an event delta.
				
				// To deal with these we check to see how many tempo boundaries we have crossed.
				// Then we iterate through the previous tempos, until we've advanced enough ticks to
				// resume "normal" operation.
				
				while (tempos_future.length>0 && (ticks + n.tick) > tempos_future[0].tick)
				{
					tempos_past.push(tempos_future.shift());
					tempos_traversed += 1;
				}
				if (tempos_traversed > 0)
				{
					var tick_traversed = 0;
					for (ct in 0...tempos_traversed)
					{
						
						var ptr = tempos_past.length - 1 - (tempos_traversed - ct);
						var ticks_advance = 0;
						var frames_advance = 0.;
						
						if (ticks < tempos_past[ptr].tick)
						{
							ticks_advance = tempos_past[ptr].tick - ticks;
						}
						else
						{
							ticks_advance = tempos_past[ptr].tick - tempos_past[ptr + 1].tick;
						}
						
						frames_advance = ticks_advance * tempos_past[ptr].frames;
						tick_traversed += ticks_advance;
						ticks += ticks_advance;
						frames += frames_advance;
						
					}
					ticks += n.tick - tick_traversed;
					frames += (n.tick - tick_traversed) * tempos_past[tempos_past.length-1].frames;
				}
				else
				{
					ticks += n.tick;
					frames += n.tick * tempos_past[tempos_past.length-1].frames;
				}
				
				var result = filter(n, ticks, frames, sequencer);
				if (result != null) events.push(result);
				
			}
		}
		
		return events;
		
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
	public static inline var CC_PANPOD = 10;
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
	
	public static inline var RPN_PITCHBEND_SENCE = 0;
	public static inline var RPN_FINE_TUNE = 1;
	public static inline var RPN_COARSE_TUNE = 2;
	
	public static function default_filter(smf:SMFEvent, ticks : Int, frames : Float, sequencer : Sequencer)
	{
		if (smf.type == NOTE_ON && smf.data.velocity == 0) // optimize - part of specced behavior
			smf.type = NOTE_OFF;
		
		switch(smf.type)
		{
			case NOTE_ON:
				return (new SequencerEvent(SequencerEvent.NOTE_ON,
					sequencer.waveLengthOfMidiNote(smf.data.note),
												smf.channel,
												smf.data.note,
												Std.int(frames),
												smf.channel));
			case NOTE_OFF:
				return (new SequencerEvent(SequencerEvent.NOTE_OFF,
					sequencer.waveLengthOfMidiNote(smf.data.note),
												smf.channel,
												smf.data.note,
												Std.int(frames),
												smf.channel));
			default:
				return null;
		}
	}
	
	private function trackEvent(track : Array<SMFEvent>, tick : Int, type : Int, channel : Int, data : Dynamic)
		{ track.push( { tick:tick, type:type, channel:channel, data:data }); }
	
	private function get_track(bytes:ByteArray)
	{
		
		var track = new Array<SMFEvent>();
		
		var cont = true;
		
		deltaTime = 0;
		time = 0;		
		signature_n = 0;
		signature_d = 0;
		
		var oldstatus = 0;
		var status = 0;
		
		while (bytes.bytesAvailable > 0 && cont) 
		{
			deltaTime = readVariableLength(bytes);
			time += deltaTime;
			
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
					var text = bytes.readMultiByte(len, "Shift-JIS");
				} else {
					switch (metaEventType) {
					case META_TEMPO:
						var tempo = ((bytes.readUnsignedByte() << 16) | bytes.readUnsignedShort());
						var bpm = 60000000 / tempo;
						tempos.push({ tick:time, tempo:tempo, bpm:bpm, frames:sequencer.BPMToFrames(1/resolution,bpm)});
					case META_TIME_SIGNATURE:
						// not properly implemented yet...
						var value = (bytes.readUnsignedByte() << 16) | (1 << bytes.readUnsignedByte());
						signature_n = value>>16;
						signature_d = value & 0xffff;
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
						trackEvent(track, deltaTime, status_base, channel, bytes.readUnsignedByte());
					case CHANNEL_PRESSURE:
						trackEvent(track, deltaTime, status_base, channel, bytes.readUnsignedByte());
					case NOTE_OFF:
						trackEvent(track, deltaTime, status_base, channel, 
							{note:bytes.readUnsignedByte(),velocity:bytes.readUnsignedByte()});
					case NOTE_ON:
						trackEvent(track, deltaTime, status_base, channel, 
							{note:bytes.readUnsignedByte(),velocity:bytes.readUnsignedByte()});
					case KEY_PRESSURE:
						trackEvent(track, deltaTime, status_base, channel, 
							{note:bytes.readUnsignedByte(),pressure:bytes.readUnsignedByte()});
					case CONTROL_CHANGE:
						trackEvent(track, deltaTime, status_base, channel, 
							(bytes.readUnsignedByte()<<16) | bytes.readUnsignedByte());
					case PITCH_BEND:
						trackEvent(track, deltaTime, status_base, channel, 
							bytes.readUnsignedByte() | (bytes.readUnsignedByte() << 8));
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

class FrameFXParser
{
	
	// someday we'll add some fun effects like auto-arpeggiation etc.
	
	// compiles Array<SequencerEvent>->Array<SequencerEvent> - uses channel values to direct most mappings
	
}

class SequencerEvent
{
	
	public var channel : Int; // channel we will pipe to
	public var id : Int; // id of related sequence (e.g. on-off, pitch bend) - use UNISON_ID to go to all
	public var type : Int; // data type
	public var data : Dynamic; // payload
	public var frame : Int; // frame that this event occurs on
	public var priority : Int; // priority of event (for note-stealing purposes)
	
	public function new(type : Int, data : Dynamic, channel : Int, id : Int, frame : Int, priority : Int) 
	{ this.channel = channel; this.id = id; this.type = type;  this.data = data; 
	  this.frame = frame; this.priority = priority; }
	
	public function toString() { return ["ch",channel,"id",id,"t",type,"d",data,"@",frame,"p",priority].join(" ");  }
	
	public static inline var UNISON_ID = -102;
	
	public static inline var NOTE_ON = 1;
	public static inline var NOTE_OFF = 2;
	
}

class SequencerChannel
{	
	public var id : Int; public var outputs : Array<SoftSynth>;
	
	public function new(id, outputs) 
	{ 
		this.id = id; this.outputs = outputs; 
		var ct = 0;
	}
	
	public function priority(synth : SoftSynth) : Int
	{
		return MathTools.bestOf(synth.events, 
			function(inp) { return inp; }, 
			function(a, b) { return a.priority > b.priority; }, {priority:-1} ).priority;
	}
	
	public function hasEvent(synth : SoftSynth, id : Int)
	{
		return Lambda.exists(synth.events, function(ev) { return ev.id == id; } );
	}
	
	public function pipe(ev : SequencerEvent)
	{
		
		if (ev.id == SequencerEvent.UNISON_ID)
		{
			// unison behavior
			for (synth in outputs)
			{
				synth.event(ev, this);
			}
			return;
		}
		else
		{
			// overlapping behavior
			for (synth in outputs)
			{
				if (hasEvent(synth, ev.id))
				{
					synth.event(ev, this);
					return;
				}
			}
			// stealing behavior
			var best : {priority:Int,synth:SoftSynth} = MathTools.bestOf(outputs, 
				function(synth : SoftSynth) { return {synth:synth, priority:priority(synth) }; } ,
				function(a, b) { return a.priority < b.priority; }, outputs[0] );
			if (best.priority <= ev.priority)			
				best.synth.event(ev, this);
		}
		
	}
	
}

interface SoftSynth
{	
	
	// SoftSynth responsibilities:
	// 1. Initialize with the given buffer size and sequencer
	// 2. Write bytes to the buffer when requested with write() - if synth has no activity, can return False
	// 3. Recieve events and maintain their state: The event array should be used so that channels
	//    can make a decision on how to assign voicing. However, the synth is free to change event population
	//    at write() time.
	
	public var buffer : Vector<Float>;
	public var sequencer : Sequencer;
	public var events : Array<SequencerEvent>;
	
	public function init(sequencer : Sequencer, buffersize : Int):Void;
	public function write():Bool;
	public function event(data : SequencerEvent, channel : SequencerChannel):Void;
	
}

class SquareWave implements SoftSynth
{
	
	public var buffer : Vector<Float>;
	public var events : Array<SequencerEvent>;
	public var sequencer : Sequencer;
	
	public var wl : Int;
	public var pos : Int;
	public var bufptr : Int;
	
	public function new()
	{
		wl = 400;
		pos = 0;
		bufptr = 0;
	}
	
	public function init(sequencer : Sequencer, buffersize : Int)
	{
		this.sequencer = sequencer;
		this.buffer = new Vector(buffersize, true);
		this.events = new Array();
	}
	
	public function write()
	{
		if (events.length < 1)
			return false;
		var hw = wl >> 1;
		for (i in 0 ... buffer.length>>1) {
			if (pos % wl < hw)
			{
				buffer[bufptr] = 0.1; // left
				buffer[bufptr+1] = 0.1; // right
			}
			else
			{
				buffer[bufptr] = 0.; // left
				buffer[bufptr+1] = 0.; // right
			}
			pos = (pos+2) % wl;
			bufptr = (bufptr+2) % buffer.length;
		}
		return true;
	}
	
	public function event(ev : SequencerEvent, channel : SequencerChannel)
	{
		switch(ev.type)
		{
			case SequencerEvent.NOTE_ON: 
				{ events.push(ev); wl = Std.int(ev.data); }
			case SequencerEvent.NOTE_OFF: 
				{for (n in events.copy()) {if (n.id==ev.id) events.remove(n); }}
		}
	}
	
}

class Sequencer
{
	
	public var events : Array<SequencerEvent>;
	public var frame : Int;
	public var channels : Array<SequencerChannel>;
	public var synths : Array<SoftSynth>;
	public var sound : Sound;
	public var channel : SoundChannel;
	public var tuning : MIDITuning;
	
	private static inline var RATE = 44100;
	private var FRAMESIZE : Int; // buffer size of mono frame
	private var DIVISIONS : Int; // to increase the framerate we slice the buffer by this number of divisions
	
	public inline function samplerate() { return RATE; }
	public inline function monosize() { return Std.int(FRAMESIZE/DIVISIONS); }
	public inline function stereosize() { return Std.int(FRAMESIZE*2/DIVISIONS); }
	public inline function framerate() { return RATE / (FRAMESIZE/DIVISIONS); }
	
	public inline function secondsToFrames(secs : Float) : Float { return secs * framerate(); }
	public inline function BPMToFrames(beat : Float, bpm : Float) : Float
		{ return (beat / (bpm / 60) * framerate()); }
		
	public inline function waveLength(frequency : Float) { return samplerate() / frequency; }
	public inline function waveLengthOfMidiNote(note : Float) { return samplerate() / tuning.midiNoteToFrequency(note); }
	
	// we should really be using a priority queue but for now I'll sort the array each time we add events...
	public function pushEvent(event : SequencerEvent, ?now = true)
	{
		if (now) 
			events.push(new SequencerEvent(event.type, event.data, event.channel, event.id, 
				event.frame + this.frame, event.priority));
		else
			events.push(event);
		events.sort(function(a, b) { return a.frame-b.frame; } );
	}
	
	public function pushEvents(events : Array<SequencerEvent>, ?now = true)
	{
		if (now) 
		{
			for (event in events)
			this.events.push(new SequencerEvent(event.type, event.data, event.channel, event.id, 
				event.frame + this.frame, event.priority));
		}
		else
		{
			for (n in events) this.events.push(n);
		}
		this.events.sort(function(a, b) { return a.frame-b.frame; } );
	}
	
	public inline function addSynth(synth : SoftSynth) : SoftSynth 
		{ synths.push(synth); synth.init(this, stereosize());  return synth; }
	
	public inline function addChannel(synths : Array<SoftSynth>) : SequencerChannel
		{ var channel = new SequencerChannel(channels.length, synths); channels.push(channel); return channel; }
		
	public function onSamples(event : SampleDataEvent) 
	{
		
		for (count in 0...DIVISIONS)
		{
				
			// process the current frame
			while (events.length > 0 && events[0].frame <= this.frame)
			{
				var e = events.shift();
				channels[e.channel].pipe(e);
			}
			if (events.length < 1)
				{}
			else
				{} //trace([events[0].frame, this.frame]);
			
			// figure out who's writing
			var bufferQueue = new Array<Vector<Float>>();
			for (n in synths)
			{
				if (n.write())
					bufferQueue.push(n.buffer);
			}
			
			// actually write to the buffer
			var sumL = 0.;
			var sumR = 0.;
			for (i in 0 ... monosize()) 
			{
				sumL = 0.;
				sumR = 0.;
				for (n in bufferQueue)
				{
					sumL += n[(i<<1)];
					sumR += n[(i<<1)+1];
				}
				event.data.writeFloat(sumL);
				event.data.writeFloat(sumR);
			}
			
			frame++;
		}
		
	}
	
	public function new(?framesize : Int = 2048, ?divisions : Int = 8, ?tuning : MIDITuning = null)
	{
		this.FRAMESIZE = framesize;
		this.DIVISIONS = divisions;
		if (tuning == null) tuning = new EvenTemperament(); this.tuning = tuning;
        sound = new Sound();
		sound.addEventListener(SampleDataEvent.SAMPLE_DATA, onSamples);
		events = new Array();
		channels = new Array();
		synths = new Array();
	}
	
	public function play(soundname : String, mixgroup : String) 
	{ 
		channel = sound.play(); 
		Audio.channels.set(soundname, 
			{vol:1.0,snd:soundname,mixgroup:mixgroup,instance:channel,timestamp:Timer.stamp()});
	}
	
	public function stop() { if (channel!=null) channel.stop(); }
	
}