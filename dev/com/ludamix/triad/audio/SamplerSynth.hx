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
	envelopes : Array<Envelope>,
	lfos : Array<LFO>,
	modulation_lfo : Float, // multiplier if greater than 0
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
	
	public var frame_pitch_adjust : Float;
	public var frame_vol_adjust : Float;
	
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
	
	public static inline var AS_PITCH_ADD = 0;
	public static inline var AS_PITCH_MUL = 1;
	public static inline var AS_VOLUME_ADD = 2;
	public static inline var AS_VOLUME_MUL = 3;
	
	// heuristic to ramp down priority when releasing
	public static inline var PRIORITY_RAMPDOWN = 0.95;
	// and ramp up priority when sustaining
	public static inline var PRIORITY_RAMPUP = 1;
	
	public static function ofWAVE(tuning : MIDITuning, wav : WAVE, ?wav_data : Array<Vector<Float>> = null,
		?oversample = 1)
	{
		if (wav_data == null) { 
			
			wav_data = Codec.WAV(wav);
			
			var initial_rate = wav.header.samplingRate;
			
			wav.header.samplingRate = Std.int(wav.header.samplingRate * oversample);
			wav.header.byteRate = Std.int(wav.header.byteRate * oversample);
			if (wav.header.smpl != null && wav.header.smpl.loop_data != null)
			for (loop in wav.header.smpl.loop_data)
			{
				loop.start = Std.int(loop.start * oversample);
				loop.end = Std.int(loop.end * oversample);
			}
			
			if (oversample > 1)
			{
				
				var rounds = oversample;
				
				var idx = 0;
				
				// Convolving low-pass filter.
				
				// Oversampling adds a ton of overhead to sample load times and memory consumption,
				// But the oversampled data is pre-filtered, improving resampling quality.
				// I may need to turn this into an FFT implementation in order to get decent load times.
				
				// Some good files to test with this: SNUCKEY3.MID, Snuckey4.mid (sam and max)
				// 								 	  ULTIMA10.MID (ultima 7)
				
				var table = new Array<Float>();
				var LIM = 32; // below around 24, the quality is too low to bother with.
				
				// Windowed sinc
				for (n in 0...LIM)
				{
					if (n == 0 ) table.push(1.) // removable singularity at 0
					else
					{
						var pos = (2 * n / (LIM - 1));
						table.push((
							Math.sin(pos*Math.PI)/(pos * Math.PI)
							  )
						);
					}
				}
				var lut = new Vector<Float>();
				for (n in table)
					lut.push(n);
				for (n in 0...table.length - 1) // mirror
				{
					var pos = table.length - n - 2;
					lut.push(table[pos]);
				}
				
				for (samples in wav_data)
				{
					
					var convolve = new Vector<Float>();
					for (n in 0...table.length)
						convolve.push(0.);
					var tw = new Vector<Float>();
						
					var j = 0.;
					var i = 0.;
					
					for (idx in 0...samples.length+convolve.length)
					{
						var s = idx < cast(samples.length,Int) ? samples[idx] : 0.;
						
						i = 0.;
						for (c in 0...convolve.length-1)
						{
							convolve[c] = convolve[c + 1];
							i += lut[c] * convolve[c]; 
						}
						convolve[convolve.length - 1] = s;
						tw.push(i);
						
						// then 0-pad
						
						for (r in 0...rounds-1)
						{
							i = 0.;
							for (c in 0...convolve.length-1)
							{
								convolve[c] = convolve[c + 1];
								i += lut[c] * convolve[c]; 
							}
							convolve[convolve.length - 1] = 0.;
							tw.push(i);
						}
						
					}
					
					wav_data[idx] = tw;
					idx++;
				}
			}
		}
		
		
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
			envelopes:[{attack:[1.0],sustain:[1.0],release:[1.0],quantization:0,assigns:[AS_VOLUME_ADD]}],
			volume:1.0,
			lfos:[{frequency:6.,depth:0.5,delay:0.05,attack:0.05,assigns:[AS_PITCH_ADD]}],
			modulation_lfo:1.0,
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
				envelopes:[{attack:[1.0],sustain:[1.0],release:[1.0],quantization:0,assigns:[AS_VOLUME_ADD]}],
				lfos:[{frequency:6.,depth:0.5,delay:0.05,attack:0.05,assigns:[AS_PITCH_ADD]}],
				modulation_lfo:1.0,
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
	
	public inline function pipeAdjustment(qty : Float, assigns : Array<Int>)
	{
		for (assign in assigns)
		{
			switch(assign)
			{
				case AS_PITCH_ADD: frame_pitch_adjust += qty;
				case AS_PITCH_MUL: frame_pitch_adjust *= qty;
				case AS_VOLUME_ADD: frame_vol_adjust += qty;
				case AS_VOLUME_MUL: frame_vol_adjust *= qty;
			}
		}
	}
	
	public inline function updateEnvelope(patch : SamplerPatch, channel : SequencerChannel, cur_follower : EventFollower)
	{
		var env_num = 0;
		for (env in cur_follower.env)
		{
			if (env.state < 3)
			{
				var patch_env = patch.envelopes[env_num];
				var env_val = env.getTable(patch_env)[env.ptr];
				if (patch_env.quantization != 0)
					env_val = (Math.round(env_val * patch_env.quantization) / patch_env.quantization);	
				pipeAdjustment(env_val, patch_env.assigns);
			}
			env_num++;
		}		
	}
	
	public inline function updateLFO(patch : SamplerPatch, channel : SequencerChannel, cur_follower : EventFollower)
	{
		var lfo_num = 0;
		for (n in patch.lfos)
		{
			var cycle_length = sequencer.secondsToFrames(1. / n.frequency);
			var delay_length = sequencer.secondsToFrames(n.delay);
			var attack_length = sequencer.secondsToFrames(n.attack);
			var modulation_amount = (lfo_num == 0 && patch.modulation_lfo > 0) ? 
				patch.modulation_lfo * channel.modulation : 1.0;
			var mpos = cur_follower.lfo_pos - delay_length;
			if (mpos > 0)
			{
				if (mpos > attack_length)
				{
					pipeAdjustment(Math.sin(2 * Math.PI * mpos / cycle_length) * n.depth * modulation_amount, n.assigns);
				}
				else // ramp up
				{
					pipeAdjustment(Math.sin(2 * Math.PI * mpos / cycle_length) * modulation_amount * 
						(n.depth * (mpos/attack_length)), n.assigns);
				}
			}
			lfo_num++;
		}
		cur_follower.lfo_pos += 1;
	}
	
	public function write()
	{	
		while (followers.length > 0 && followers[followers.length - 1].isOff()) followers.pop();
		if (followers.length < 1) { return false; }
		
		var cur_follower : EventFollower = followers[followers.length - 1];		
		var patch : SamplerPatch = cur_follower.patch_event.patch;
		if (patch.arpeggiation_rate>0.0)
		{
			var available = Lambda.array(Lambda.filter(followers, function(a) { return !a.isOff(); } ));
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
		
		frame_pitch_adjust = 0.;
		frame_vol_adjust = 0.;
		
		updateEnvelope(patch, cur_channel, cur_follower);
		updateLFO(patch, cur_channel, cur_follower);
		
		freq = seq_event.data.freq;
		
		var wl = Std.int(sequencer.waveLengthOfBentFrequency(freq, 
					pitch_bend + Std.int((frame_pitch_adjust * 8192 / sequencer.tuning.bend_semitones))));
		
		freq = sequencer.frequency(wl);
		
		velocity = seq_event.data.velocity / 128;
		
		if (!cur_follower.isOff())
		{
			
			if (cur_follower.env[0].state == RELEASE) // apply the release envelope on top of the release level
				frame_vol_adjust *= cur_follower.release_level;
			var curval = patch.volume * master_volume * channel_volume * cur_channel.velocityCurve(velocity) * 
				frame_vol_adjust;
			
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
						if (cur_follower.env[0].state < RELEASE) 
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
						if (cur_follower.pos >= sample_length) { cur_follower.env[0].state = OFF; }
				}		
			}
			else
			{
				cur_follower.pos += total_inc;
				if (cur_follower.pos > sample_length && (patch.loop_mode == ONE_SHOT || cur_follower.env[0].state == RELEASE))
					cur_follower.env[0].state = OFF;
			}
			
			// Envelope advancement. We judge the length of the note based on the master envelope.
			
			var ct = 0;
			for (e in cur_follower.env)
			{
				e.ptr++;
				if (ct == 0) // master envelope treatment
				{
					var master_env : Array<Float> = cur_follower.env[0].getTable(patch.envelopes[0]);
					var master_state = cur_follower.env[0].state;
					var master_ptr = cur_follower.env[0].ptr;
					
					if (master_state!=OFF && master_ptr >= master_env.length)
					{
						// advance to next state if not sustaining
						if (master_state != SUSTAIN || patch.loop_mode == ONE_SHOT || patch.loop_mode == NO_LOOP)
							{master_state += 1; if (master_state == SUSTAIN && 
								patch.envelopes[0].sustain.length < 1) master_state++; }
						else if (master_state == SUSTAIN) // encourage sustains to be retained
							cur_follower.patch_event.sequencer_event.priority += PRIORITY_RAMPUP;
						// allow one shots to play through, ignoring their envelope tail
						if (patch.loop_mode == ONE_SHOT && master_state == OFF && cur_follower.pos < sample_length)
						{
							master_state = RELEASE;
							master_ptr = patch.envelopes[0].release.length - 1;
						}
						else
							master_ptr = 0;
						cur_follower.env[0].state = master_state;
						cur_follower.env[0].ptr = master_ptr;
					}
					// set release level
					if (master_state < RELEASE)
					{
						cur_follower.release_level = frame_vol_adjust;
					}
					else
					{
						cur_follower.patch_event.sequencer_event.priority = 
							Std.int(cur_follower.patch_event.sequencer_event.priority * PRIORITY_RAMPDOWN);
					}
				}
				else // other envelopes are simple...
				{
					if (e.state!=OFF && e.state!=SUSTAIN && e.ptr >= e.getTable(patch.envelopes[ct]).length)
					{ 
						e.state++; e.ptr = 0; 
					}
				}
				ct++;
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
		// linear interpolator
		var ideal = Math.min(pos, sample_left.length - 1);
		var a : Int = Std.int(ideal);
		var b : Int = Std.int(Math.min(pos + 1, sample_left.length - 1));
		var interpolation_factor : Float = ideal - a;
		buffer[bufptr] += left * (sample_left[a] * (1. -interpolation_factor) + sample_left[b] * interpolation_factor);	
		buffer[bufptr + 1] += right * (sample_right[a] * (1. -interpolation_factor) + sample_right[b] * interpolation_factor);
	}
	
	public function event(patch_ev : PatchEvent, channel : SequencerChannel)
	{
		var ev = patch_ev.sequencer_event;
		switch(ev.type)
		{
			case SequencerEvent.NOTE_ON: 
				followers.push(new EventFollower(patch_ev, patch_ev.patch.envelopes.length));
			case SequencerEvent.NOTE_OFF: 
				for (n in followers) 
				{ 
					if (n.patch_event.sequencer_event.id == ev.id)
					{
						n.setRelease();
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
	
	public function allOff()
	{
		while (followers.length>0) followers.pop();
	}
	
	public function allRelease()
	{
		for (f in followers) { f.setRelease(); }
	}
	
}
