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
	
}

class SequencerChannel
{	
	public var id : Int; 
	public var outputs : Array<SoftSynth>;
	
	public var pitch_bend : Int;
	public var channel_volume : Float;
	public var modulation : Float;
	
	public var patch : Dynamic;
	
	public var velocity_mapping : Int;
	
	public function new(id, outputs, patch, velocity_mapping) 
	{ 
		this.id = id; this.outputs = outputs; this.patch = patch; this.velocity_mapping = velocity_mapping;
		var ct = 0;
		pitch_bend = 0;
		channel_volume = 1.0;
		modulation = 0.;
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
	
	public function pipe(ev : SequencerEvent)
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
	
	public static inline var VELOCITY_LINEAR = 0;
	public static inline var VELOCITY_SQR = 1;
	public static inline var VELOCITY_POW = 2;
	
	public inline function velocityCurve(velocity : Float) : Float
	{
		
		// remaps note velocity to exaggerate or compress dynamics as needed by the source input.
		
		switch(velocity_mapping)
		{
			case VELOCITY_LINEAR:
				return velocity;
			case VELOCITY_SQR:
				return velocity * velocity;
			case VELOCITY_POW:
				return Math.pow(velocity, 1.0 - velocity);
			default:
				return velocity;
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
	
	public inline function sampleRate() { return RATE; }
	public inline function monoSize() { return Std.int(FRAMESIZE/DIVISIONS); }
	public inline function stereoSize() { return Std.int(FRAMESIZE*2/DIVISIONS); }
	public inline function frameRate() { return RATE / (FRAMESIZE/DIVISIONS); }
	
	public inline function secondsToFrames(secs : Float) : Float { return secs * frameRate(); }
	public inline function BPMToFrames(beat : Float, bpm : Float) : Float
		{ return (beat / (bpm / 60) * frameRate()); }
		
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
		{ synths.push(synth); synth.init(this, stereoSize());  return synth; }
	
	public inline function addChannel(synths : Array<SoftSynth>, 
			patch : Dynamic, ?velocity_mapping = SequencerChannel.VELOCITY_SQR) : SequencerChannel
		{ 
			var channel = new SequencerChannel(channels.length, synths, patch, velocity_mapping); 
			channels.push(channel); 
			return channel; 
		}
		
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
			for (i in 0 ... monoSize()) 
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