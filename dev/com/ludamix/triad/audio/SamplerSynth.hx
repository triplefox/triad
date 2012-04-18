package com.ludamix.triad.audio;

import com.ludamix.triad.tools.MathTools;
import com.ludamix.triad.format.wav.Data;
import nme.Assets;
import nme.utils.ByteArray;
import nme.utils.CompressionAlgorithm;
import nme.Vector;
import com.ludamix.triad.audio.Sequencer;
import nme.Vector;

// this patch format will need some changes to add multisampling, keyranges, etc.

typedef RawSample = {
	sample_left : Vector<Float>, // only this side is used for mono
	sample_right : Vector<Float>,
	sample_rate : Int, // mono rate
	base_frequency : Float // hz
};

typedef SamplerPatch = {
	sample : RawSample,
	stereo : Bool,
	pan : Float,
	loop_start : Int,
	loop_end : Int,
	loop_mode : Int,
	attack_envelope : Array<Float>,
	sustain_envelope : Array<Float>,
	release_envelope : Array<Float>,
	vibrato_frequency : Float, // hz
	vibrato_depth : Float, // midi notes
	vibrato_delay : Float, // seconds
	vibrato_attack : Float, // seconds
	modulation_vibrato : Float, // multiplier if greater than 0
	envelope_quantization : Int, // 0 = off, lower values produce "chippier" envelope character
	arpeggiation_rate : Float // 0 = off, hz value
};

class SamplerSynth implements SoftSynth
{
	
	public var buffer : Vector<Float>;
	public var events : Array<EventFollower>;
	public var sequencer : Sequencer;
	
	public var freq : Float;
	public var pos : Float;
	public var bufptr : Int;
	
	public var master_volume : Float;
	public var velocity : Float;
	
	public var vibrato : Float;	
	public var arpeggio : Float;
	
	public static inline var ATTACK = 0;
	public static inline var SUSTAIN = 1;
	public static inline var RELEASE = 2;
	public static inline var OFF = 3;
	
	public function new()
	{
		freq = 440.;
		pos = 0.;
		bufptr = 0;
		master_volume = 0.1;
		velocity = 1.0;
		vibrato = 0.;
		arpeggio = 0.;
		
	}
	
	public static inline var LOOP_FORWARD = 0;
	public static inline var LOOP_BACKWARD = 1;
	public static inline var LOOP_PINGPONG = 2;
	public static inline var ONE_SHOT = 3;
	
	public static function ofWAVE(tuning : MIDITuning, wav : WAVE, ?wav_data : Array<Vector<Float>> = null)
	{
		if (wav_data == null) { wav_data = Codec.WAV(wav); }
		
		var loop_type = SamplerSynth.ONE_SHOT;
		switch(wav.header.smpl.loop_data[0].type)
		{
			case 0: loop_type = SamplerSynth.LOOP_FORWARD;
			case 1: loop_type = SamplerSynth.LOOP_PINGPONG;
			case 2: loop_type = SamplerSynth.LOOP_BACKWARD;
		}
		
		return new PatchGenerator(
			{
			sample: {
				sample_left:wav_data[0],
				sample_right:wav_data[1],
				sample_rate:wav.header.samplingRate,
				base_frequency:tuning.midiNoteToFrequency(wav.header.smpl.midi_unity_note + 
											wav.header.smpl.midi_pitch_fraction/0xFFFFFFFF),
				},
			stereo:false,
			pan:0.5,
			loop_start:wav.header.smpl.loop_data[0].start,
			loop_end:wav.header.smpl.loop_data[0].end,
			loop_mode:loop_type,
			attack_envelope:[1.0],
			sustain_envelope:[1.0],
			release_envelope:[1.0],
			vibrato_frequency:6.,
			vibrato_depth:0.5,
			vibrato_delay:0.05,
			vibrato_attack:0.05,
			modulation_vibrato:1.0,
			envelope_quantization:0,
			arpeggiation_rate:0.0				
			},
			function(settings, ev) : Array<SequencerEvent> { ev.patch = settings; return [ev]; }
		);				
	}
	
	public static function defaultPatch() : SamplerPatch
	{
		var samples = new Vector<Float>();
		for (n in 0...44100)
		{
			samples.push(Math.sin(n / 44100 * Math.PI * 2));
		}
		
		return { 
				sample: {
					sample_left:samples,
					sample_right:samples,
					sample_rate:44100,
					base_frequency:1.0,
					},
				stereo:false,
				pan:0.5,
				loop_start:0,
				loop_end:samples.length-1,
				loop_mode:LOOP_FORWARD,
				attack_envelope:[1.0],
				sustain_envelope:[1.0],
				release_envelope:[1.0],
				vibrato_frequency:6.,
				vibrato_depth:0.5,
				vibrato_delay:0.05,
				vibrato_attack:0.05,
				modulation_vibrato:1.0,
				envelope_quantization:0,
				arpeggiation_rate:0.0
				}
				;
	}
	
	public function init(sequencer : Sequencer, buffersize : Int)
	{
		this.sequencer = sequencer;
		this.buffer = new Vector(buffersize, true);
		this.events = new Array();		
	}
	
	public inline function updateVibrato(patch : SamplerPatch, channel : SequencerChannel) : Float
	{
		var cycle_length = sequencer.secondsToFrames(1. / patch.vibrato_frequency);
		var delay_length = sequencer.secondsToFrames(patch.vibrato_delay);
		var attack_length = sequencer.secondsToFrames(patch.vibrato_attack);
		var modulation_amount = patch.modulation_vibrato>0 ? patch.modulation_vibrato * channel.modulation : 1.0;
 		var mvibrato = vibrato - delay_length;
		vibrato += 1;
		if (mvibrato > 0)
		{
			if (mvibrato > attack_length)
			{
				return Math.sin(2 * Math.PI * mvibrato / cycle_length) * patch.vibrato_depth * modulation_amount;
			}
			else // ramp up vibrato
			{
				return Math.sin(2 * Math.PI * mvibrato / cycle_length) * modulation_amount * 
					(patch.vibrato_depth * (mvibrato/attack_length));
			}
		}
		else return 0.;
	}
	
	public function write()
	{	
		while (events.length > 0 && events[events.length - 1].env_state == OFF) events.pop();
		if (events.length < 1) { pos = 0; return false; }
		
		var cur_event : EventFollower = events[events.length - 1];		
		var cur_channel = sequencer.channels[cur_event.event.channel];
		var patch : SamplerPatch = cur_event.event.patch;
		if (patch.arpeggiation_rate>0.0)
		{
			var available = Lambda.array(Lambda.filter(events, function(a) { return a.env_state != OFF; } ));
			cur_event = available[Std.int(((arpeggio) % 1) * available.length)];
			cur_channel = sequencer.channels[cur_event.event.channel];
			patch = cur_event.event.patch;
			arpeggio += sequencer.secondsToFrames(1.0) / (patch.arpeggiation_rate);
		}
		var pitch_bend = cur_channel.pitch_bend;
		var channel_volume = cur_channel.channel_volume;
		var pan = cur_channel.pan;
		
		freq = Std.int(cur_event.event.data.note);
		var wl = Std.int(sequencer.waveLengthOfBentFrequency(freq, 
					pitch_bend + Std.int((updateVibrato(patch, cur_channel) * 8192 / sequencer.tuning.bend_semitones))));
		
		velocity = cur_event.event.data.velocity / 128;
		
		// update envelopes and vol+envelope state
		var attack_envelope = patch.attack_envelope;
		var sustain_envelope = patch.sustain_envelope;
		var release_envelope = patch.release_envelope;
		var envelopes = [attack_envelope, sustain_envelope, release_envelope];
		var env_val = envelopes[cur_event.env_state][cur_event.env_ptr];
		if (patch.envelope_quantization != 0)
			env_val = (Math.round(env_val * patch.envelope_quantization) / patch.envelope_quantization);	
		var curval = master_volume * channel_volume * cur_channel.velocityCurve(velocity) * 
					env_val;
		
		// get sample and volume data
		var pan_sum = MathTools.limit(0., 1., pan + 2 * (patch.pan - 0.5));
		var left = curval * pan_sum * 2;
		var right = curval * (1. - pan_sum) * 2;
		var sample : RawSample = patch.sample;
		var sample_left : Vector<Float> = sample.sample_left;
		var sample_right : Vector<Float> = sample.sample_right;
		if (!patch.stereo) sample_right = sample_left;
		
		// we are assuming the sample rate is the mono rate.
		
		var base_wl = sample.sample_rate / sample.base_frequency;
		var inc = base_wl / wl;
		var sample_length : Int = sample.sample_left.length;
		var loop_idx : Int = sustain_envelope.length > 0 ? patch.loop_end : sample_length-1;
		var loop_len = (loop_idx - patch.loop_start)+1;
		
		// inner loop
		if (cur_event.env_state < RELEASE) // use the loop points as we sustain
		{
			
			// TODO: all loop modes (wait until after I have an actual sample working)
			
			for (i in 0 ... buffer.length >> 1)
			{
				var round : Int = Math.round(pos);
				while (round > loop_idx)
					{ round -= loop_len; pos -= loop_len; }
				buffer[bufptr] = left * sample_left[round];
				buffer[bufptr+1] = right * sample_right[round];
				pos+=inc;
				bufptr = (bufptr + 2) % buffer.length;
			}
		}
		else // play to the end and then force the note off
		{
			for (i in 0 ... buffer.length >> 1)
			{
				var round : Int = Math.round(pos) % sample_length;
				if (round > sample_length)
					{ round = sample_length-1; cur_event.env_state = OFF; cur_event.env_ptr = 0; }
				buffer[bufptr] = left * sample_left[round];
				buffer[bufptr+1] = right * sample_right[round];
				pos+=inc;
				bufptr = (bufptr+2) % buffer.length;
			}
		}
		//
		
		for (ev in events)
		{
			ev.env_ptr++;
			if (ev.env_state!=OFF && ev.env_ptr >= envelopes[ev.env_state].length)
			{
				if (ev.env_state != SUSTAIN)
					{ev.env_state += 1; if (ev.env_state == SUSTAIN && sustain_envelope.length < 1) ev.env_state++; }
				ev.env_ptr = 0;
			}
		}
		return true;
	}
	
	public function event(ev : SequencerEvent, channel : SequencerChannel)
	{
		switch(ev.type)
		{
			case SequencerEvent.NOTE_ON: 
				events.push(new EventFollower(ev));
				vibrato = 0.;
				pos = 0;
			case SequencerEvent.NOTE_OFF: 
				for (n in events) 
				{ 
					if (n.event.id == ev.id) 
					{
						if (n.event.patch.release_envelope.length>0)
							{ if (n.env_state!=RELEASE) {n.env_state = RELEASE; n.env_ptr = 0;} }
						else
							n.env_state = OFF;
					}
				}
		}
	}
	
	public function getEvents()
	{
		var result = new Array<SequencerEvent>();
		for ( n in events )
		{
			result.push(n.event);
		}
		return result;
	}
	
}
