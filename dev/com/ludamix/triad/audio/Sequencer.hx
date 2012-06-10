package com.ludamix.triad.audio;

import com.ludamix.triad.audio.dsp.Reverb;
import com.ludamix.triad.tools.FastFloatBuffer;
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
	public var frame : Float; // frame that this event occurs on
	public var priority : Int; // priority of event (for note-stealing purposes)
	
	public function new(type : Int, data : Dynamic, channel : Int, id : Int, frame : Float, priority : Int) 
	{ this.channel = channel; this.id = id; this.type = type;  this.data = data; 
	  this.frame = frame; this.priority = priority; }
	
	public function toString() { return ["ch",channel,"id",id,"t",type,"d",data,"@",frame,"p",priority].join(" ");  }
	
	public static inline var CHANNEL_EVENT = -102;
	
	public static inline var SET_PATCH = 0;
	public static inline var NOTE_ON = 1;
	public static inline var NOTE_OFF = 2;
	public static inline var PITCH_BEND = 3; // normalized around 0
	public static inline var VOLUME = 4;
	public static inline var MODULATION = 5;
	public static inline var PAN = 6;
	public static inline var SUSTAIN_PEDAL = 7;
	public static inline var ALL_NOTES_OFF = 8;
	public static inline var SET_BPM = 9;
	
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

class VoiceGroup
{
	
	// Each voice group contains a set of voices that can be allocated(e.g. sampler, wavetable)
	// according to some desired polyphony.
	
	public var voices : Array<SoftSynth>;
	public var allocated : Array<SoftSynth>;
	public var channel : SequencerChannel;
	public var polyphony : Int;
	
	public function new(voices : Array<SoftSynth>, polyphony : Int)
	{
		this.voices = voices;
		this.allocated = new Array();
		this.polyphony = polyphony;
	}
	
	public function priority(synth : SoftSynth) : Int
	{
		// this is fairly horrible at this point, and could probably stand a custom optimized version.
		return MathTools.bestOf(synth.getEvents(), 
			function(inp) { return inp; }, 
			function(a, b) 
			{ return a.sequencer_event.priority > b.sequencer_event.priority; }, 
				{sequencer_event:{priority:-1}} ).sequencer_event.priority;
	}
	
	public function hasEvent(synth : SoftSynth, patchevent : PatchEvent)
	{
		return Lambda.exists(synth.getEvents(), function(ev : PatchEvent) { 
			return ev.patch == patchevent.patch && ev.sequencer_event.id == patchevent.sequencer_event.id ; } );
	}	
	
	public function sendPatchEvents(type : Int, event_priority : Int, patched_events : Array<PatchEvent>)
	{
		if (type == SequencerEvent.NOTE_OFF && !channel.sustain)
		{
			for (patched_ev in patched_events)
			{
				for (voice in voices)
				{
					if (hasEvent(voice, patched_ev))
						voiceEvent(voice, patched_ev);
				}		
			}
		}
		else
		{
			for (patched_ev in patched_events)
			{
				var usable = voices;
				if (allocated.length >= polyphony)
					usable = allocated;
				// overlapping behavior
				for (voice in usable)
				{
					if (hasEvent(voice, patched_ev))
					{
						allocated.remove(voice);
						if (voiceEvent(voice, patched_ev))
							allocated.push(voice);
						return;
					}
				}
				// stealing behavior
				var best : {priority:Int,synth:SoftSynth} = MathTools.bestOf(usable, 
					function(synth : SoftSynth) { return {synth:synth, priority:priority(synth) }; } ,
					function(a, b) { return a.priority < b.priority; }, usable[0] );
				if (best.priority <= event_priority)
				{
					allocated.remove(best.synth);
					if (voiceEvent(best.synth, patched_ev))
						allocated.push(best.synth);
				}
			}
		}
	}
	
	// ramp down priority this much each time a new voice is added to the channel
	public static inline var PRIORITY_VOICE = 0.95;
	
	private function voiceEvent(voice : SoftSynth, patch_ev : PatchEvent)
	{
		var ev = patch_ev.sequencer_event;
		switch(ev.type)
		{
			case SequencerEvent.NOTE_ON: 
				// as the channel adds more voices, the priority of its notes gets squashed.
				// doing this on note ons naturally favors squashing of repetitive drum hits and stacattos,
				// which have plenty of release tails, instead of held notes.
				voice.followers.push(new EventFollower(patch_ev));
				for (f in allocated)
				{
					patch_ev.sequencer_event.priority = Std.int((patch_ev.sequencer_event.priority * PRIORITY_VOICE));
				}
			case SequencerEvent.NOTE_OFF: 
				for (n in voice.followers) 
				{ 
					if (n.patch_event.sequencer_event.id == ev.id)
					{
						n.setRelease();
					}
				}
		}
		for (n in voice.followers) 
		{	
			if (n.patch_event.sequencer_event.channel == channel.id)
				return true; 
		}
		return false;
	}
	
}

class SequencerChannel
{	
	public var id : Int; 
	public var voice_groups : Array<VoiceGroup>;
	
	public var pitch_bend : Int;
	public var channel_volume : Float;
	public var modulation : Float;
	public var pan : Float;	
	public var patch_id : Int;	
	public var sustain : Bool;
	
	public var patch_generator : PatchGenerator;
	
	public var velocity_curve : Float;
	
	public function new(id, voicegroups : Array<VoiceGroup>, patch_generator : PatchGenerator, velocity_curve) 
	{
		this.id = id; 
		this.voice_groups = voicegroups; 
		for (n in voicegroups) n.channel = this;
		this.velocity_curve = velocity_curve;
		this.patch_generator = patch_generator;
		patch_id = 0;
		var ct = 0;
		pitch_bend = 0;
		channel_volume = 1.0;
		modulation = 0.;
		pan = 0.5;
		sustain = false;
	}
	
	public function pipe(ev : SequencerEvent, seq : Sequencer)
	{
		
		if (ev.id == SequencerEvent.CHANNEL_EVENT)
		{
			switch(ev.type)
			{
				case SequencerEvent.SET_BPM:
					seq.setBPM(ev.data, true);
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
				case SequencerEvent.SUSTAIN_PEDAL:
					sustain = (ev.data > 63);
					if (!sustain)
					{
						for (g in voice_groups)
						{
							for (n in g.allocated)
								n.allRelease();
						}
					}
				case SequencerEvent.ALL_NOTES_OFF:
					for (g in voice_groups)
					{
						for (n in g.allocated)
							n.allOff();
					}
			}
			return;
		}
		else
		{
			var patched_events = patch_generator.generator(patch_generator.settings, seq, ev);
			if (patched_events == null) return;
			for (vgroup in voice_groups)
				vgroup.sendPatchEvents(ev.type, ev.priority, patched_events);
		}
		
	}
	
	public inline function velocityCurve(velocity : Float) : Float
	{		
		return Math.pow(velocity, velocity_curve);	
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
	public var buffer : FastFloatBuffer;
	public var onFrame : Sequencer->Void;
	public var onBeat : Sequencer->Void;
	public var postFrame : Sequencer->FastFloatBuffer->Void;
	public var reverb : Reverb;
	
	private static inline var DC_OFFSET = 0.;
	private static inline var NATURAL_RATE = 44100;
	private var RATE : Int;
	public var RATE_MULTIPLE : Float;
	private var FRAMESIZE : Int; // buffer size of mono frame
	private var DIVISIONS : Int; // to increase the framerate we slice the buffer by this number of divisions
	
	public var bpm : Float;
	public var cur_beat : Float;
	
	private var last_l : Float;
	private var last_r : Float;
	
	public inline function sampleRate() { return RATE; }
	public inline function monoSize() { return Std.int(FRAMESIZE/DIVISIONS); }
	public inline function stereoSize() { return Std.int(FRAMESIZE*2/DIVISIONS); }
	public inline function frameRate() { return RATE / (FRAMESIZE/DIVISIONS); }
	
	public inline function secondsToFrames(secs : Float) : Float { return secs * frameRate(); }
	public inline function BPMToFrames(beat : Float, bpm : Float) : Float
		{ return (beat / (bpm / 60) * frameRate()); }
	public inline function framesToBeats(frames : Int, bpm : Float) : Float
		{ return frames / BPMToFrames(1., bpm); }
	public inline function framesToMidiTicks(frames : Int, resolution : Int) : Float
		{ return framesToBeats(frames, bpm) * resolution; }
	public inline function beatsToMidiTicks(beats : Float, resolution : Int) : Float
		{ return beats * resolution; }
	public inline function beatsToSeconds(beats : Float) : Float { return beats / (bpm / 60); }
	
	public inline function waveLength(frequency : Float) { return sampleRate() / frequency; }
	public inline function frequency(wavelength : Float) { return wavelength / sampleRate(); }
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
			else { return (a.frame - b.frame)>0. ? 1 : -1; }});	// comparing float frame values
	}
	
	public inline function addSynth(synth : SoftSynth) : SoftSynth 
		{ synths.push(synth); synth.init(this);  return synth; }
	
	public inline function addChannel(voicegroups : Array<VoiceGroup>, 
			patch : PatchGenerator, ?velocity_curve = 2.0) : SequencerChannel
		{ 
			var channel = new SequencerChannel(channels.length, voicegroups, patch, velocity_curve); 
			channels.push(channel); 
			return channel; 
		}
	
	public function setBPM(bpm : Float, ?preserve_beats = false)
	{
		this.bpm = bpm;
		if (!preserve_beats)
			this.cur_beat = 0.;
	}
	
	public inline function executeFrame()
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
			if (channels.length-1>=e.channel)
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
			buffer.set(i2, DC_OFFSET);
			buffer.set(i2+1, DC_OFFSET);
		}
		
		// sum buffer
		for (n in synths) { n.write(); }		
	}
	
	public function onSamples(event : SampleDataEvent) 
	{
		
		for (count in 0...DIVISIONS)
		{
			
			executeFrame();
			
			if (postFrame != null)
				postFrame(this, buffer);
			
			var fx_buffer : FastFloatBuffer = buffer;
			if (reverb != null)
			{
				fx_buffer = reverb.process(fx_buffer);
			}
			
			// vector -> bytearray
			
			if (RATE_MULTIPLE == 1)
			{
				for (i in 0 ... monoSize()) 
				{
					var i2 = i << 1;
					event.data.writeFloat(fx_buffer.get(i2));
					event.data.writeFloat(fx_buffer.get(i2+1));
				}
			}
			else if (RATE_MULTIPLE == 2)
			{
				for (i in 0 ... monoSize()) 
				{
					var i2 = i << 1;
					var l = fx_buffer.get(i2);
					var r = fx_buffer.get(i2+1);
					event.data.writeFloat(l * 0.5 + last_l * 0.5);
					event.data.writeFloat(r * 0.5 + last_r * 0.5);
					event.data.writeFloat(l);
					event.data.writeFloat(r);
					last_l = l;
					last_r = r;
				}
			}
			else if (RATE_MULTIPLE == 3)
			{
				for (i in 0 ... monoSize()) 
				{
					var i2 = i << 1;
					var l = fx_buffer.get(i2);
					var r = fx_buffer.get(i2+1);
					event.data.writeFloat(l * 0.33 + last_l * 0.66);
					event.data.writeFloat(r * 0.33 + last_r * 0.66);
					event.data.writeFloat(l * 0.66 + last_l * 0.33);
					event.data.writeFloat(r * 0.66 + last_r * 0.33);
					event.data.writeFloat(l);
					event.data.writeFloat(r);
					last_l = l;
					last_r = r;
				}
			}
			else if (RATE_MULTIPLE == 4)
			{
				for (i in 0 ... monoSize()) 
				{
					var i2 = i << 1;
					var l = fx_buffer.get(i2);
					var r = fx_buffer.get(i2+1);
					event.data.writeFloat(l * 0.25 + last_l * 0.75);
					event.data.writeFloat(r * 0.25 + last_r * 0.75);
					event.data.writeFloat(l * 0.5 + last_l * 0.5);
					event.data.writeFloat(r * 0.5 + last_r * 0.5);
					event.data.writeFloat(l * 0.75 + last_l * 0.25);
					event.data.writeFloat(r * 0.75 + last_r * 0.25);
					event.data.writeFloat(l);
					event.data.writeFloat(r);
					last_l = l;
					last_r = r;
				}
			}
			else if (RATE_MULTIPLE == 0.5)
			{
				for (i in 0 ... monoSize()>>1) 
				{
					var i2 = i << 2;
					event.data.writeFloat((fx_buffer.get(i2) * 0.5 + fx_buffer.get(i2+2) * 0.5));
					event.data.writeFloat(fx_buffer.get(i2+1) * 0.5 + fx_buffer.get(i2+3) * 0.5);
				}
			}
			
			frame++;
		}
		
	}
	
	public function new(?rate : Int = 22050, ?framesize : Int = 4096, ?divisions : Int = 4, 
		?tuning : MIDITuning = null, ?reverb : Reverb = null)
	{
		last_l = 0.;
		last_r = 0.;
		this.RATE = rate;
		if (this.RATE == NATURAL_RATE)
			RATE_MULTIPLE = 1;
		else if (this.RATE == NATURAL_RATE/2)
			RATE_MULTIPLE = 2;
		else if (this.RATE == NATURAL_RATE/3)
			RATE_MULTIPLE = 3;
		else if (this.RATE == NATURAL_RATE/4)
			RATE_MULTIPLE = 4;
		else if (this.RATE == NATURAL_RATE * 2)
			RATE_MULTIPLE = 0.5;
		else
			throw "rate should be equal to, 1/2, 1/3, or 1/4 the natural rate (" + Std.string(NATURAL_RATE) + ")";
		setBPM(120.0);
		this.FRAMESIZE = framesize;
		this.DIVISIONS = divisions;
		if (tuning == null) tuning = new EvenTemperament(); this.tuning = tuning;
        sound = new Sound();
		sound.addEventListener(SampleDataEvent.SAMPLE_DATA, onSamples);
		events = new Array();
		channels = new Array();
		synths = new Array();
		buffer = new FastFloatBuffer(stereoSize());
		this.reverb = reverb;
	}
	
	public function play(soundname : String, mixgroup : String) 
	{ 
		// if you get "invalid parameters" you may have made your frames too large relative to the samplerate.
		channel = sound.play(); 
		Audio.channels.set(soundname, 
			{vol:1.0,snd:soundname,mixgroup:mixgroup,instance:channel,timestamp:Timer.stamp()});
	}
	
	public function stop() { if (channel!=null) channel.stop(); }
	
}
