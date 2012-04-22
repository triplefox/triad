package com.ludamix.triad.audio;

import flash.events.SampleDataEvent;
import nme.media.Sound;
import nme.media.SoundChannel;
import nme.utils.ByteArray;
import nme.Vector;
import haxe.Timer;
import com.ludamix.triad.tools.MathTools;
import com.ludamix.triad.audio.MIDITuning;

class SequencerEvent
{
	
	public var channel : Int; // channel we will pipe to
	public var id : Int; // id of related sequence (e.g. on-off, pitch bend) - use CHANNEL_EVENT to go to all
	public var type : Int; // data type
	public var data : Dynamic; // payload
	public var frame : Int; // frame that this event occurs on
	public var priority : Int; // priority of event (for note-stealing purposes)
	
	public function new(type : Int, data : Dynamic, channel : Int, id : Int, frame : Int, priority : Int) 
	{ this.channel = channel; this.id = id; this.type = type;  this.data = data; 
	  this.frame = frame; this.priority = priority; }
	
	public function toString() { return ["ch",channel,"id",id,"t",type,"d",data,"@",frame,"p",priority].join(" ");  }
	
	public static inline var CHANNEL_EVENT = -102;
	
	public static inline var NOTE_ON = 1;
	public static inline var NOTE_OFF = 2;
	public static inline var PITCH_BEND = 3; // normalized around 0
	public static inline var VOLUME = 4;
	public static inline var MODULATION = 5;
	public static inline var PAN = 6;
	public static inline var SET_PATCH = 7;
	
}

class PatchEvent
{
	
	public var sequencer_event : SequencerEvent;
	public var patch : Dynamic;
	
	public function new(ev : SequencerEvent, patch : Dynamic)
	{
		this.sequencer_event = ev;
		this.patch = patch;
	}
	
}

class PatchGenerator
{
	
	public var settings : Dynamic;	
	public var generator : Dynamic->Sequencer->SequencerEvent->Array<PatchEvent>;
	
	public function new(settings : Dynamic, generator : Dynamic->Sequencer->SequencerEvent->Array<PatchEvent>)
	{
		this.settings = settings;
		this.generator = generator;
	}
}

class SequencerChannel
{	
	public var id : Int; 
	public var outputs : Array<SoftSynth>;
	
	public var pitch_bend : Int;
	public var channel_volume : Float;
	public var modulation : Float;
	public var pan : Float;	
	public var patch_id : Int;	
	
	public var patch_generator : PatchGenerator;
	
	public var velocity_mapping : Int;
	
	public function new(id, outputs, patch_generator : PatchGenerator, velocity_mapping) 
	{ 
		this.id = id; this.outputs = outputs; this.velocity_mapping = velocity_mapping;
		this.patch_generator = patch_generator;
		patch_id = 0;
		var ct = 0;
		pitch_bend = 0;
		channel_volume = 1.0;
		modulation = 0.;
		pan = 0.5;
	}
	
	public function priority(synth : SoftSynth) : Int
	{
		return MathTools.bestOf(synth.getEvents(), 
			function(inp) { return inp; }, 
			function(a, b) { return a.priority > b.priority; }, {priority:-1} ).priority;
	}
	
	public function hasEvent(synth : SoftSynth, id : Int)
	{
		return Lambda.exists(synth.getEvents(), function(ev) { return ev.id == id; } );
	}
	
	public function pipe(ev : SequencerEvent, seq : Sequencer)
	{
		
		if (ev.id == SequencerEvent.CHANNEL_EVENT)
		{
			switch(ev.type)
			{
				case SequencerEvent.PITCH_BEND:
					pitch_bend = ev.data;
				case SequencerEvent.VOLUME:
					channel_volume = ev.data;
				case SequencerEvent.MODULATION:
					modulation = ev.data;
				case SequencerEvent.PAN:
					pan = ev.data;
				case SequencerEvent.SET_PATCH:
					patch_id = ev.data;
			}
			return;
		}
		else
		{
			var patched_events = patch_generator.generator(patch_generator.settings, seq, ev);
			if (patched_events == null) return;
			for (patched_ev in patched_events)
			{
				// overlapping behavior
				for (synth in outputs)
				{
					if (hasEvent(synth, patched_ev.sequencer_event.id))
					{
						synth.event(patched_ev, this);
						return;
					}
				}
				// stealing behavior
				var best : {priority:Int,synth:SoftSynth} = MathTools.bestOf(outputs, 
					function(synth : SoftSynth) { return {synth:synth, priority:priority(synth) }; } ,
					function(a, b) { return a.priority < b.priority; }, outputs[0] );
				if (best.priority <= ev.priority)
					best.synth.event(patched_ev, this);
			}
		}
		
	}
	
	public inline function velocityCurve(velocity : Float) : Float
	{		
		// remaps note velocity to exaggerate or compress dynamics as needed by the source input.	
		return SynthTools.curve(velocity, velocity_mapping);		
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
	public var buffer : Vector<Float>;
	public var onFrame : Sequencer->Void;
	public var onBeat : Sequencer->Void;
	
	private static inline var RATE = 44100;
	private var FRAMESIZE : Int; // buffer size of mono frame
	private var DIVISIONS : Int; // to increase the framerate we slice the buffer by this number of divisions
	
	public var bpm : Float;
	public var cur_beat : Float;
	
	public inline function sampleRate() { return RATE; }
	public inline function monoSize() { return Std.int(FRAMESIZE/DIVISIONS); }
	public inline function stereoSize() { return Std.int(FRAMESIZE*2/DIVISIONS); }
	public inline function frameRate() { return RATE / (FRAMESIZE/DIVISIONS); }
	
	public inline function secondsToFrames(secs : Float) : Float { return secs * frameRate(); }
	public inline function BPMToFrames(beat : Float, bpm : Float) : Float
		{ return (beat / (bpm / 60) * frameRate()); }
	public inline function framesToBeats(frames : Int, bpm : Float) : Float
		{ return frames / BPMToFrames(1., bpm); }
	
	public inline function waveLength(frequency : Float) { return sampleRate() / frequency; }
	public inline function waveLengthOfBentNote(note : Float, pitch_bend : Int) 
	{ 
		return waveLength(tuning.midiNoteBentToFrequency(note, pitch_bend));
	}
	public inline function waveLengthOfBentFrequency(frequency : Float, pitch_bend : Int) 
	{ 
		return waveLengthOfBentNote(tuning.frequencyToMidiNote(frequency), pitch_bend);
	}
	
	// we should really be using a priority queue but for now I'll sort the array each time we add events...
	public function pushEvent(event : SequencerEvent, ?now = true)
	{
		if (now) 
			events.push(new SequencerEvent(event.type, event.data, event.channel, event.id, 
				event.frame + this.frame, event.priority));
		else
			events.push(event);
		sortEvents();
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
		sortEvents();
	}
	
	public function sortEvents()
	{
		events.sort(function(a, b) { 
			if (a.frame == b.frame) { return (a.type - b.type); } // this favors note ends, lowering stuck likelihood
			else return a.frame - b.frame; } );		
	}
	
	public inline function addSynth(synth : SoftSynth) : SoftSynth 
		{ synths.push(synth); synth.init(this);  return synth; }
	
	public inline function addChannel(synths : Array<SoftSynth>, 
			patch : PatchGenerator, ?velocity_mapping = SynthTools.CURVE_SQR) : SequencerChannel
		{ 
			var channel = new SequencerChannel(channels.length, synths, patch, velocity_mapping); 
			channels.push(channel); 
			return channel; 
		}
	
	public function setBPM(bpm : Float, ?preserve_beats = false)
	{
		this.bpm = bpm;
		if (!preserve_beats)
			this.cur_beat = 0.;
	}
	
	public function onSamples(event : SampleDataEvent) 
	{
		
		for (count in 0...DIVISIONS)
		{
			
			if (onFrame != null) onFrame(this);
			
			cur_beat = cur_beat + framesToBeats(1, this.bpm);
			while (cur_beat > 1)
			{
				cur_beat -= 1; if (onBeat != null) onBeat(this);
			}
			
			// process the current frame
			while (events.length > 0 && events[0].frame <= this.frame)
			{
				var e = events.shift();
				channels[e.channel].pipe(e, this);
			}
			if (events.length < 1)
				{}
			else
				{} //trace([events[0].frame, this.frame]);
			
			// clear buffer
			for (i in 0 ... monoSize()) 
			{
				var i2 = i << 1;
				buffer[i2] = 0.;
				buffer[i2+1] = 0.;
			}
			
			// sum buffer
			for (n in synths) { n.write(); }
			
			// vector -> bytearray
			var sumL = 0.;
			var sumR = 0.;
			for (i in 0 ... monoSize()) 
			{
				var i2 = i << 1;
				event.data.writeFloat(buffer[i2]);
				event.data.writeFloat(buffer[i2+1]);
			}
			
			frame++;
		}
		
	}
	
	public function new(?framesize : Int = 4096, ?divisions : Int = 4, ?tuning : MIDITuning = null)
	{
		setBPM(120.0);
		this.FRAMESIZE = framesize;
		this.DIVISIONS = divisions;
		if (tuning == null) tuning = new EvenTemperament(); this.tuning = tuning;
        sound = new Sound();
		sound.addEventListener(SampleDataEvent.SAMPLE_DATA, onSamples);
		events = new Array();
		channels = new Array();
		synths = new Array();
      #if flash
		buffer = new Vector(stereoSize(), true);
      #else
		buffer = new Vector();
      #end
	}
	
	public function play(soundname : String, mixgroup : String) 
	{ 
		channel = sound.play(); 
		Audio.channels.set(soundname, 
			{vol:1.0,snd:soundname,mixgroup:mixgroup,instance:channel,timestamp:Timer.stamp()});
	}
	
	public function stop() { if (channel!=null) channel.stop(); }
	
}
