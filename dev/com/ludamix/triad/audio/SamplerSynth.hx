package com.ludamix.triad.audio;

import com.ludamix.triad.tools.MathTools;
import com.ludamix.triad.format.wav.Data;
import com.ludamix.triad.audio.SFZ;
import nme.Assets;
import nme.utils.ByteArray;
import nme.utils.CompressionAlgorithm;
import nme.Vector;
import com.ludamix.triad.audio.Sequencer;
import nme.Vector;
import nme.Vector;
import nme.Vector;

// I think I need a polymorphic sample format;
// as it is, there's a lot of overlap

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
	volume : Float,
	attack_envelope : Array<Float>,
	sustain_envelope : Array<Float>,
	release_envelope : Array<Float>,
	vibrato_frequency : Float, // hz
	vibrato_depth : Float, // midi notes
	vibrato_delay : Float, // seconds
	vibrato_attack : Float, // seconds
	modulation_vibrato : Float, // multiplier if greater than 0
	envelope_quantization : Int, // 0 = off, lower values produce "chippier" envelope character
	arpeggiation_rate : Float, // 0 = off, hz value
};

class SamplerSynth implements SoftSynth
{
	
	public var buffer : Vector<Float>;
	public var followers : Array<EventFollower>;
	public var sequencer : Sequencer;
	
	public var freq : Float;
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
		bufptr = 0;
		master_volume = 0.1;
		velocity = 1.0;
		vibrato = 0.;
		arpeggio = 0.;
		
	}
	
	public static inline var LOOP_FORWARD = 0;
	public static inline var LOOP_BACKWARD = 1;
	public static inline var LOOP_PINGPONG = 2;
	public static inline var SUSTAIN_FORWARD = 3;
	public static inline var SUSTAIN_BACKWARD = 4;
	public static inline var SUSTAIN_PINGPONG = 5;
	public static inline var ONE_SHOT = 6;
	public static inline var NO_LOOP = 7;
	
	public static function ofWAVE(tuning : MIDITuning, wav : WAVE, ?wav_data : Array<Vector<Float>> = null)
	{
		if (wav_data == null) { wav_data = Codec.WAV(wav); }
		
		var loop_type = SamplerSynth.ONE_SHOT;
		var midi_unity_note = 0;
		var midi_pitch_fraction = 0;
		var loop_start = 0;
		var loop_end = wav_data.length - 1;
		
		if (wav.header.smpl != null)
		{
			if (wav.header.smpl.loop_data!=null && wav.header.smpl.loop_data.length>0)
			{
				switch(wav.header.smpl.loop_data[0].type)
				{
					case 0: loop_type = SamplerSynth.LOOP_FORWARD;
					case 1: loop_type = SamplerSynth.LOOP_PINGPONG;
					case 2: loop_type = SamplerSynth.LOOP_BACKWARD;
				}
			}
			
			midi_unity_note = wav.header.smpl.midi_unity_note;
			midi_pitch_fraction = wav.header.smpl.midi_pitch_fraction;
			loop_start = wav.header.smpl.loop_data[0].start;
			loop_end = wav.header.smpl.loop_data[0].end;
			
		}
		return new PatchGenerator(
			{
			sample: {
				sample_left:wav_data[0],
				sample_right:wav_data[1],
				sample_rate:wav.header.samplingRate,
				base_frequency:tuning.midiNoteToFrequency( midi_unity_note + midi_pitch_fraction/0xFFFFFFFF),
				},
			stereo:false,
			pan:0.5,
			loop_start:loop_start,
			loop_end:loop_end,
			loop_mode:loop_type,
			attack_envelope:[1.0],
			sustain_envelope:[1.0],
			release_envelope:[1.0],
			volume:1.0,
			vibrato_frequency:3.,
			vibrato_depth:0.5,
			vibrato_delay:0.05,
			vibrato_attack:0.05,
			modulation_vibrato:1.0,
			envelope_quantization:0,
			arpeggiation_rate:0.0,
			},
			function(settings, seq, ev) : Array<PatchEvent> { return [new PatchEvent(ev,settings)]; }
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
				volume:1.0,
				loop_start:0,
				loop_end:samples.length-1,
				loop_mode:LOOP_FORWARD,
				attack_envelope:[1.0],
				sustain_envelope:[1.0],
				release_envelope:[1.0],
				vibrato_frequency:3.,
				vibrato_depth:0.5,
				vibrato_delay:0.05,
				vibrato_attack:0.05,
				modulation_vibrato:1.0,
				envelope_quantization:0,
				arpeggiation_rate:0.0,
				}
				;
	}
	
	public function init(sequencer : Sequencer)
	{
		
		this.sequencer = sequencer;
		this.buffer = sequencer.buffer;
		this.followers = new Array();		
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
		while (followers.length > 0 && followers[followers.length - 1].env_state == OFF) followers.pop();
		if (followers.length < 1) { return false; }
		
		var cur_follower : EventFollower = followers[followers.length - 1];		
		var patch : SamplerPatch = cur_follower.patch_event.patch;
		if (patch.arpeggiation_rate>0.0)
		{
			var available = Lambda.array(Lambda.filter(followers, function(a) { return a.env_state != OFF; } ));
			cur_follower = available[Std.int(((arpeggio) % 1) * available.length)];
			patch = cur_follower.patch_event.patch;
			arpeggio += sequencer.secondsToFrames(1.0) / (patch.arpeggiation_rate);
		}
		
		progress_follower(cur_follower, true);
		
		for (other_follower in followers)
		{
			if (other_follower != cur_follower) // force silenced followers to progress
			{
				progress_follower(other_follower, false);
			}
		}
		
		return true;
	}
	
	public inline function progress_follower(cur_follower : EventFollower, ?write : Bool)
	{
		var cur_channel = sequencer.channels[cur_follower.patch_event.sequencer_event.channel];
		var patch : SamplerPatch = cur_follower.patch_event.patch;
		
		var pitch_bend = cur_channel.pitch_bend;
		var channel_volume = cur_channel.channel_volume;
		var pan = cur_channel.pan;
		
		var seq_event = cur_follower.patch_event.sequencer_event;
		
		freq = seq_event.data.freq;
		
		var wl = Std.int(sequencer.waveLengthOfBentFrequency(freq, 
					pitch_bend + Std.int((updateVibrato(patch, cur_channel) * 8192 / sequencer.tuning.bend_semitones))));
					
		freq = sequencer.frequency(wl);
		
		velocity = seq_event.data.velocity / 128;
		
		var attack_envelope = patch.attack_envelope;
		var sustain_envelope = patch.sustain_envelope;
		var release_envelope = patch.release_envelope;
		var envelopes = [attack_envelope, sustain_envelope, release_envelope];
		
		// new envelope feature: release should multiply against the MOR(moment of release) volume instead of its own
		// thingy. This resolves the issue with having a sustain-of-0.
		
		if (cur_follower.env_state != OFF)
		{
			var env_val = envelopes[cur_follower.env_state][cur_follower.env_ptr];
			if (cur_follower.env_state == RELEASE) // apply the release envelope on top of the release level
				env_val *= cur_follower.release_level;
			if (patch.envelope_quantization != 0)
				env_val = (Math.round(env_val * patch.envelope_quantization) / patch.envelope_quantization);	
			var curval = patch.volume * master_volume * channel_volume * cur_channel.velocityCurve(velocity) * 
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
			if (wl < 1) wl = 1;
			var inc : Float = base_wl / wl;
			var sample_length : Int = sample.sample_left.length;
			var loop_idx = patch.loop_end;
			var loop_len = (loop_idx - patch.loop_start)+1;
			
			var total_length = buffer.length >> 1;
			var total_inc : Float = inc * total_length;
			
			if (write)
			{
				switch(patch.loop_mode)
				{
					// LOOP - repeat loop until envelope reaches OFF
					case LOOP_FORWARD, LOOP_BACKWARD, LOOP_PINGPONG: 
						while (cur_follower.pos >= loop_idx) cur_follower.pos -= loop_len;
						for (n in 0...total_length)
						{
							copy_samples(buffer, bufptr, cur_follower.pos, inc, left, right, sample_left, sample_right, freq);
							cur_follower.pos += inc; while (cur_follower.pos >= loop_idx) cur_follower.pos -= loop_len;
							bufptr = (bufptr + 2) % buffer.length;
						}
					// SUSTAIN - loop until release, then play to the first of envelope OFF or sample endpoint
					case SUSTAIN_FORWARD, SUSTAIN_BACKWARD, SUSTAIN_PINGPONG: 				
						if (cur_follower.env_state < RELEASE) 
						{
							while (cur_follower.pos >= loop_idx) cur_follower.pos -= loop_len;
							for (n in 0...total_length)
							{
								copy_samples(buffer, bufptr, cur_follower.pos, inc, left, right, sample_left, sample_right, freq);
								cur_follower.pos += inc; while (cur_follower.pos >= loop_idx) cur_follower.pos -= loop_len;
								bufptr = (bufptr + 2) % buffer.length;
							}
						}
						else
						{
							for (n in 0...total_length)
							{
								copy_samples(buffer, bufptr, cur_follower.pos, inc, left, right, sample_left, sample_right, freq);
								cur_follower.pos += inc;
								bufptr = (bufptr + 2) % buffer.length;
							}
						}
					// ONE_SHOT - play until the sample endpoint, do not respect note off
					// NO_LOOP - play until the sample endpoint, cut on note off
					case ONE_SHOT, NO_LOOP:
						for (n in 0...total_length)
						{
							copy_samples(buffer, bufptr, cur_follower.pos, inc, left, right, sample_left, sample_right, freq);
							cur_follower.pos += inc;
							bufptr = (bufptr + 2) % buffer.length;
						}
						if (cur_follower.pos >= sample_length) { cur_follower.env_state = OFF; }
				}		
			}
			else
			{
				cur_follower.pos += total_inc;
				if (cur_follower.pos > sample_length && (patch.loop_mode == ONE_SHOT || cur_follower.env_state == RELEASE))
					cur_follower.env_state = OFF;
			}
			
			// envelope advancement
			
			cur_follower.env_ptr++;
			
			if (cur_follower.env_state!=OFF && cur_follower.env_ptr >= envelopes[cur_follower.env_state].length)
			{
				// advance to next state if not sustaining
				if (cur_follower.env_state != SUSTAIN || patch.loop_mode == ONE_SHOT || patch.loop_mode == NO_LOOP)
					{cur_follower.env_state += 1; if (cur_follower.env_state == SUSTAIN && 
						sustain_envelope.length < 1) cur_follower.env_state++; }
				// allow one shots to play through, ignoring their envelope tail
				if (patch.loop_mode == ONE_SHOT && cur_follower.env_state == OFF && cur_follower.pos < sample_length)
				{
					cur_follower.env_state = RELEASE;
					cur_follower.env_ptr = release_envelope.length - 1;
				}
				else
					cur_follower.env_ptr = 0;
			}
			// set release level
			if (cur_follower.env_state < RELEASE)
			{
				cur_follower.release_level = envelopes[cur_follower.env_state][cur_follower.env_ptr];
			}
			
		}
			
	}
	
	/*public inline function copy_samples(buffer : Vector<Float>, bufptr : Int, 
								pos : Float, inc : Float, 
								left : Float, right : Float, 
								sample_left : Vector<Float>, sample_right : Vector<Float>, freq : Float)
	{
		// Nearest
		var a : Int = Math.round(Math.min(pos + inc*0.5, sample_left.length - 1));
		buffer[bufptr] += left * (sample_left[a]);
		buffer[bufptr + 1] += right * (sample_right[a]);
	}*/
	
	public inline function copy_samples(buffer : Vector<Float>, bufptr : Int, 
								pos : Float, inc : Float, 
								left : Float, right : Float, 
								sample_left : Vector<Float>, sample_right : Vector<Float>, freq : Float)
	{
		// Linear interpolator(unfiltered)
		var a : Int = Std.int(Math.min(pos, sample_left.length - 1));
		var b : Int = Std.int(Math.min(pos + inc, sample_left.length - 1));
		buffer[bufptr] += left * ((sample_left[a]+sample_left[b])*0.5);
		buffer[bufptr + 1] += right * ((sample_right[a] + sample_right[b])*0.5);
	}
	
	public function event(patch_ev : PatchEvent, channel : SequencerChannel)
	{
		var ev = patch_ev.sequencer_event;
		switch(ev.type)
		{
			case SequencerEvent.NOTE_ON: 
				followers.push(new EventFollower(patch_ev));
				vibrato = 0.;
			case SequencerEvent.NOTE_OFF: 
				for (n in followers) 
				{ 
					if (n.patch_event.sequencer_event.id == ev.id) 
					{
						if (n.patch_event.patch.release_envelope.length>0)
							{ if (n.env_state!=RELEASE) {n.env_state = RELEASE; n.env_ptr = 0;} }
						else
						{
							if (n.patch_event.patch.loop_mode != ONE_SHOT)
								n.env_state = OFF;
						}
					}
				}
		}
		
		for (n in followers) 
		{	
			if (n.patch_event.sequencer_event.channel == channel.id)
				return true; 
		}
		return false;
	}
	
	public function getEvents()
	{
		var result = new Array<SequencerEvent>();
		for ( n in followers )
		{
			result.push(n.patch_event.sequencer_event);
		}
		return result;
	}
	
}
