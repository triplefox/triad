package com.ludamix.triad.audio;

import com.ludamix.triad.audio.dsp.Biquad;
import com.ludamix.triad.audio.dsp.FFT;
import com.ludamix.triad.audio.dsp.IIRFilter;
import com.ludamix.triad.audio.dsp.IIRFilter2;
import com.ludamix.triad.audio.dsp.DSP;
import com.ludamix.triad.audio.dsp.WindowFunction;
import com.ludamix.triad.tools.MathTools;
import com.ludamix.triad.tools.FastFloatBuffer;
import com.ludamix.triad.format.WAV;
import com.ludamix.triad.audio.SFZ;
import nme.Assets;
import nme.utils.ByteArray;
import nme.utils.CompressionAlgorithm;
import com.ludamix.triad.audio.Sequencer;

// I think I need a polymorphic sample format;
// as it is, there's a lot of overlap

typedef RawSample = {
	sample_left : FastFloatBuffer, // only this side is used for mono
	sample_right : FastFloatBuffer,
};

typedef SamplerPatch = {
	mips : Array<RawSample>,
	sample_rate : Int, // mono rate
	base_frequency : Float, // hz
	stereo : Bool,
	pan : Float,
	loop_mode : Int,
	loop_start : Int,
	loop_end : Int,
	volume : Float,
	envelopes : Array<Envelope>,
	lfos : Array<LFO>,
	modulation_lfo : Float, // multiplier if greater than 0
	arpeggiation_rate : Float, // 0 = off, hz value
};

typedef CopySamples = FastFloatBuffer->Int->Float->Float->Float->Float->FastFloatBuffer->FastFloatBuffer->Float->Float->Float->Float->Void;

class SamplerSynth implements SoftSynth
{
	
	public var buffer : FastFloatBuffer;
	public var followers : Array<EventFollower>;
	public var sequencer : Sequencer;
	
	public var freq : Float;
	public var bufptr : Int;
	
	public var master_volume : Float;
	public var velocity : Float;
	
	public var frame_pitch_adjust : Float;
	public var frame_vol_adjust : Float;
	
	public var arpeggio : Float;
	
	// # of octaves before increasing the interpolation factor; ideal is 1.
	// below 1 it will start filtering the percieved results
	// above 1 cpu usage will be lower but more pitch artifacts may occur
	public var interpolation_tolerance : Float; 
	
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
	// and ramp down priority this much each time a new voice is added to the channel
	public static inline var PRIORITY_VOICE = 0.95;

	private static function _mip2_linear(sample : FastFloatBuffer) : FastFloatBuffer
	{
		var out = new FastFloatBuffer(sample.length >> 1);
		for (i in 0...sample.length >> 1)
		{
			out.set(i, (sample.get(i << 1) + sample.get((i << 1) + 1))*0.5);
		}
		return out;
	}
	
	private static function _mip2_cubic(sample : FastFloatBuffer) : FastFloatBuffer
	{
		var out = new FastFloatBuffer(sample.length >> 1);
		for (i in 2...(sample.length >> 1)+2)
		{
			var y0 = sample.get((i << 1) % sample.length);
			var y1 = sample.get(((i << 1) + 1) % sample.length);
			var y2 = sample.get(((i << 1) + 2) % sample.length);
			var y3 = sample.get(((i << 1) + 3) % sample.length);
			var mu2 = 0.25;
			var a0 = y3 - y2 - y0 + y1;
			var a1 = y0 - y1 - a0;
			var a2 = y2 - y0;
			var a3 = y1;
			out.set(i-2, a0*0.5*mu2+a1*mu2+a2*0.5+a3);
		}
		return out;
	}
	
	private static function _mip2_catmull(sample : FastFloatBuffer) : FastFloatBuffer
	{
		var out = new FastFloatBuffer(sample.length >> 1);
		for (i in 2...(sample.length >> 1)+2)
		{
			var y0 = sample.get((i << 1) % sample.length);
			var y1 = sample.get(((i << 1) + 1) % sample.length);
			var y2 = sample.get(((i << 1) + 2) % sample.length);
			var y3 = sample.get(((i << 1) + 3) % sample.length);
			var mu2 = 0.25;
			// catmull-rom coefficients
			var a0 = -0.5*y0 + 1.5*y1 - 1.5*y2 + 0.5*y3;
			var a1 = y0 - 2.5*y1 + 2*y2 - 0.5*y3;
			var a2 = -0.5*y0 + 0.5*y2;
			var a3 = y1;
			out.set(i-2, a0*0.5*mu2+a1*mu2+a2*0.5+a3);
		}
		return out;
	}
	
	public static function mipMap(raw : RawSample, times : Int): RawSample
	{
		var result_l : FastFloatBuffer = raw.sample_left;
		var result_r : FastFloatBuffer = raw.sample_right;
		
		var count = 1;
		while (count < times)
		{
			result_l = _mip2_catmull(result_l);
			if (raw.sample_left == raw.sample_right)
				result_r = result_l;
			else result_r = _mip2_catmull(result_r);
			count *= 2;
		}
		
		return { sample_left:result_l, sample_right:result_r };
	}
	
	public static function ofWAVE(tuning : MIDITuning, wav : WAVE)
	{
		var wav_data = wav.data;
		
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
		var sample_left = FastFloatBuffer.fromVector(wav_data[0]);
		var sample_right = FastFloatBuffer.fromVector(wav_data[1]);
		var raw = { sample_left:sample_left, sample_right:sample_right };
		var mips = new Array<RawSample>();
		mips.push(raw);
		for (n in 0...13)
			mips.push(mipMap(mips[mips.length-1],2));
		return new PatchGenerator(
			{
			mips: mips,
			stereo:false,
			pan:0.5,
			loop_mode:loop_type,
			loop_start:loop_start,
			loop_end:loop_end,
			sample_rate:wav.header.samplingRate,
			base_frequency:tuning.midiNoteToFrequency( midi_unity_note + midi_pitch_fraction/0xFFFFFFFF),
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
		var samples = new FastFloatBuffer(44100);
		for (n in 0...44100)
		{
			samples.set(n, Math.sin(n / 44100 * Math.PI * 2));
		}
		
		var loop_start = 0;
		var loop_end = samples.length-1;
		var raw = { sample_left:samples, sample_right:samples};
		var mips = new Array<RawSample>();
		mips.push(raw);
		for (n in 0...13)
			mips.push(mipMap(mips[mips.length-1],2));
		return { 
				mips: mips,
				stereo:false,
				pan:0.5,
				volume:1.0,
				loop_mode:LOOP_FORWARD,
				loop_start:loop_start,
				loop_end:loop_end,
				sample_rate:44100,
				base_frequency:1.,
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
		interpolation_tolerance = 1.02 / sequencer.RATE_MULTIPLE;
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
			var left = curval * Math.sin(pan_sum * 2);
			var right = curval * Math.cos(1. - pan_sum) * 2;
			
			var sample : RawSample = patch.mips[0];
			var loop_start = patch.loop_start;
			var loop_end = patch.loop_end;
			var sample_rate = patch.sample_rate;
			var base_frequency = patch.base_frequency;
			
			var ptr = 0;
			var freq_mult = 1;
			while (ptr < patch.mips.length - 1 && freq > sample_rate*freq_mult)
				{ freq_mult *= 2; ptr++; }
			
			sample = patch.mips[ptr];
			loop_start *= freq_mult;
			loop_end *= freq_mult;
			sample_rate *= freq_mult;
			base_frequency *= freq_mult;
				
			var sample_left : FastFloatBuffer = sample.sample_left;
			var sample_right : FastFloatBuffer = sample.sample_right;
			if (!patch.stereo) sample_right = sample_left;
			
			// we are assuming the sample rate is the mono rate.
			
			var base_wl = sample_rate / base_frequency;
			if (wl < 1) wl = 1;
			var inc : Float = base_wl / wl;
			var sample_length : Int = sample.sample_left.length;
			var loop_len = (loop_end - loop_start)+1;
			
			var total_length = buffer.length >> 1;
			var total_inc : Float = inc * total_length;
			
			if (write)
			{
				// TODO: cleanup the function calls so I'm not passing in a gazillion useless arguments
				//		 actually implement all loop modes...
				
				var RESAMPLE_DROP = 0;
				var RESAMPLE_LIN = 1;
				var RESAMPLE_LIN_MONO = 2;
				var RESAMPLE_COS = 3;
				var RESAMPLE_COS_MONO = 4;
				var RESAMPLE_OPT = 3;
				var resample_type = RESAMPLE_DROP;
				if (inc != 1) 
				{
					if (sample_left == sample_right) 
						resample_type = RESAMPLE_LIN_MONO;
					else 
						resample_type = RESAMPLE_LIN;
				}
				switch(patch.loop_mode)
				{
					// LOOP - repeat loop until envelope reaches OFF
					case LOOP_FORWARD, LOOP_BACKWARD, LOOP_PINGPONG: 
						switch(resample_type)
						{
							case RESAMPLE_DROP: loopForward(copy_samples_drop, cur_follower, loop_end, loop_len, buffer, bufptr, inc, left, right,
								sample_left, sample_right, freq, total_length, sample_length);
							case RESAMPLE_LIN: loopForward(copy_samples_lin, cur_follower, loop_end, loop_len, buffer, bufptr, inc, left, right,
								sample_left, sample_right, freq, total_length, sample_length);
							case RESAMPLE_LIN_MONO: loopForward(copy_samples_lin_mono, cur_follower, loop_end, loop_len, buffer, bufptr, inc, left, right,
								sample_left, sample_right, freq, total_length, sample_length);
							case RESAMPLE_COS: loopForward(copy_samples_cos, cur_follower, loop_end, loop_len, buffer, bufptr, inc, left, right,
								sample_left, sample_right, freq, total_length, sample_length);
							case RESAMPLE_COS_MONO: loopForward(copy_samples_cos_mono, cur_follower, loop_end, loop_len, buffer, bufptr, inc, left, right,
								sample_left, sample_right, freq, total_length, sample_length);
							case RESAMPLE_OPT: loopForward(copy_samples_opt2, cur_follower, loop_end, loop_len, buffer, bufptr, inc, left, right,
								sample_left, sample_right, freq, total_length, sample_length);
						}
					// SUSTAIN - loop until release, then play to the first of envelope OFF or sample endpoint
					case SUSTAIN_FORWARD, SUSTAIN_BACKWARD, SUSTAIN_PINGPONG:
						switch(resample_type)
						{
							case RESAMPLE_DROP: loopSustain(copy_samples_drop, cur_follower, loop_end, loop_len, buffer, bufptr, inc, left, right,
								sample_left, sample_right, freq, total_length, sample_length);
							case RESAMPLE_LIN: loopSustain(copy_samples_lin, cur_follower, loop_end, loop_len, buffer, bufptr, inc, left, right,
								sample_left, sample_right, freq, total_length, sample_length);
							case RESAMPLE_LIN_MONO: loopSustain(copy_samples_lin_mono, cur_follower, loop_end, loop_len, buffer, bufptr, inc, left, right,
								sample_left, sample_right, freq, total_length, sample_length);
							case RESAMPLE_COS: loopSustain(copy_samples_cos, cur_follower, loop_end, loop_len, buffer, bufptr, inc, left, right,
								sample_left, sample_right, freq, total_length, sample_length);
							case RESAMPLE_COS_MONO: loopSustain(copy_samples_cos_mono, cur_follower, loop_end, loop_len, buffer, bufptr, inc, left, right,
								sample_left, sample_right, freq, total_length, sample_length);
							case RESAMPLE_OPT: loopSustain(copy_samples_opt2, cur_follower, loop_end, loop_len, buffer, bufptr, inc, left, right,
								sample_left, sample_right, freq, total_length, sample_length);
						}
					// ONE_SHOT - play until the sample endpoint, do not respect note off
					// NO_LOOP - play until the sample endpoint, cut on note off
					case ONE_SHOT, NO_LOOP:
						switch(resample_type)
						{
							case RESAMPLE_DROP: runUnlooped(copy_samples_drop, cur_follower, loop_end, loop_len, buffer, bufptr, inc, left, right,
								sample_left, sample_right, freq, total_length, sample_length);
							case RESAMPLE_LIN: runUnlooped(copy_samples_lin, cur_follower, loop_end, loop_len, buffer, bufptr, inc, left, right,
								sample_left, sample_right, freq, total_length, sample_length);
							case RESAMPLE_LIN_MONO: runUnlooped(copy_samples_lin_mono, cur_follower, loop_end, loop_len, buffer, bufptr, inc, left, right,
								sample_left, sample_right, freq, total_length, sample_length);
							case RESAMPLE_COS: runUnlooped(copy_samples_cos, cur_follower, loop_end, loop_len, buffer, bufptr, inc, left, right,
								sample_left, sample_right, freq, total_length, sample_length);
							case RESAMPLE_COS_MONO: runUnlooped(copy_samples_cos_mono, cur_follower, loop_end, loop_len, buffer, bufptr, inc, left, right,
								sample_left, sample_right, freq, total_length, sample_length);
							case RESAMPLE_OPT: runUnlooped(copy_samples_opt2, cur_follower, loop_end, loop_len, buffer, bufptr, inc, left, right,
								sample_left, sample_right, freq, total_length, sample_length);
						}
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
	
	private inline function loopForward(copy_samples : CopySamples, cur_follower : EventFollower , loop_end:Int, loop_len, buffer, bufptr, inc, left, right,
		sample_left, sample_right, freq,total_length, sample_length)
	{
		var loop_start = loop_end - loop_len;
		if (cur_follower.pos>loop_end)
			cur_follower.pos = ((cur_follower.pos - loop_start) % loop_len) + loop_start;
		for (n in 0...total_length)
		{
			copy_samples(buffer, bufptr, cur_follower.pos, inc, left, right, sample_left, sample_right, freq,
				loop_start, loop_len, loop_end);
			cur_follower.pos += inc; if (cur_follower.pos >= loop_end) 
				cur_follower.pos = ((cur_follower.pos - loop_start) % loop_len)+loop_start;
			bufptr = (bufptr + 2) % buffer.length;
		}		
	}
	
	private inline function loopSustain(copy_samples : CopySamples, cur_follower: EventFollower, loop_end:Int, 
		loop_len, buffer, bufptr, inc, left, right,
		sample_left, sample_right, freq,total_length, sample_length)
	{
		var loop_start = loop_end - loop_len;
		if (cur_follower.env[0].state < RELEASE) 
		{
			if (cur_follower.pos>loop_end)
				cur_follower.pos = ((cur_follower.pos - loop_start) % loop_len)+loop_start;
			for (n in 0...total_length)
			{
				copy_samples(buffer, bufptr, cur_follower.pos, inc, left, right, sample_left, sample_right, freq,
					loop_start, loop_len, loop_end);
				cur_follower.pos += inc; if (cur_follower.pos >= loop_end) 
					cur_follower.pos = ((cur_follower.pos - loop_start) % loop_len)+loop_start;
				bufptr = (bufptr + 2) % buffer.length;
			}
		}
		else
		{
			for (n in 0...total_length)
			{
				copy_samples(buffer, bufptr, cur_follower.pos, inc, left, right, sample_left, sample_right, freq,
					loop_start, loop_len, loop_end);
				cur_follower.pos += inc;
				bufptr = (bufptr + 2) % buffer.length;
			}
		}
	}
	
	private inline function runUnlooped(copy_samples : CopySamples, cur_follower: EventFollower, loop_end:Int, loop_len, buffer, bufptr, inc, left, right,
		sample_left, sample_right, freq,total_length, sample_length)
	{
		var loop_start = loop_end - loop_len;
		for (n in 0...total_length)
		{
			copy_samples(buffer, bufptr, cur_follower.pos, inc, left, right, sample_left, sample_right, freq,
				loop_start, loop_len, loop_end);
			cur_follower.pos += inc;
			bufptr = (bufptr + 2) % buffer.length;
		}
		if (cur_follower.pos >= sample_length) { cur_follower.env[0].state = OFF; }		
	}
	
	public inline function copy_samples_drop(buffer : FastFloatBuffer, bufptr : Int, 
								pos : Float, inc : Float, 
								left : Float, right : Float, 
								sample_left : FastFloatBuffer, sample_right : FastFloatBuffer, freq : Float,
								loop_start : Float, loop_end : Float, loop_len : Float)
	{
		// Drop
		var a : Int = Std.int(Math.min(pos, sample_left.length - 1));
		buffer.set(bufptr, buffer.get(bufptr) + left * (sample_left.get(a)));
		buffer.set(bufptr + 1, buffer.get(bufptr+1) +  right * (sample_right.get(a)));
	}
	
	/*public inline function copy_samples_nearest(buffer : FastFloatBuffer, bufptr : Int, 
								pos : Float, inc : Float, 
								left : Float, right : Float, 
								sample_left : FastFloatBuffer, sample_right : FastFloatBuffer, freq : Float,
								loop_start : Float, loop_end : Float, loop_len : Float)
	{
		// Nearest
		var a : Int = Math.round(Math.min(pos + inc*0.5, sample_left.length - 1));
		buffer.set(bufptr, buffer.get(bufptr) + left * (sample_left.get(a)));
		buffer.set(bufptr + 1, buffer.get(bufptr + 1) + right * (sample_right.get(a)));
	}*/
	
	public inline function copy_samples_lin(buffer : FastFloatBuffer, bufptr : Int, 
								pos : Float, inc : Float, 
								left : Float, right : Float, 
								sample_left : FastFloatBuffer, sample_right : FastFloatBuffer, freq : Float,
								loop_start : Float, loop_end : Float, loop_len : Float)
	{
		// linear interpolator
		var ideal = Math.min(pos, sample_left.length - 1);
		var a : Int = Std.int(ideal);
		var b : Int = Std.int(Math.min(pos + 1, sample_left.length - 1));
		var interpolation_factor : Float = pos - a;
		buffer.set(bufptr, 
			buffer.get(bufptr) + left * (sample_left.get(a) * (1. -interpolation_factor) + 
				sample_left.get(b) * interpolation_factor));	
		buffer.set(bufptr + 1, 
			buffer.get(bufptr + 1) + right * (sample_right.get(a) * (1. -interpolation_factor) + 
				sample_right.get(b) * interpolation_factor));
	}

	public inline function copy_samples_lin_mono(buffer : FastFloatBuffer, bufptr : Int, 
								pos : Float, inc : Float, 
								left : Float, right : Float, 
								sample_left : FastFloatBuffer, sample_right : FastFloatBuffer, freq : Float,
								loop_start : Float, loop_end : Float, loop_len : Float)
	{
		// linear interpolator(mono sample)
		var ideal = Math.min(pos, sample_left.length - 1);
		var a : Int = Std.int(ideal);
		var b : Int = Std.int(Math.min(pos + 1, sample_left.length - 1));
		var interpolation_factor : Float = pos - a;
		var sd = (sample_left.get(a) * (1. -interpolation_factor) + 
				sample_left.get(b) * interpolation_factor);
		buffer.set(bufptr, buffer.get(bufptr) + left * sd);	
		buffer.set(bufptr + 1, buffer.get(bufptr + 1) + right * sd);
	}
	
	public inline function copy_samples_cos(buffer : FastFloatBuffer, bufptr : Int, 
								pos : Float, inc : Float, 
								left : Float, right : Float, 
								sample_left : FastFloatBuffer, sample_right : FastFloatBuffer, freq : Float,
								loop_start : Float, loop_end : Float, loop_len : Float)
	{
		// cosine interpolator
		var ideal = Math.min(pos, sample_left.length - 1);
		var a : Int = Std.int(ideal);
		var b : Int = Std.int(Math.min(pos + 1, sample_left.length - 1));
		var interpolation_factor : Float = (1 - Math.cos((pos - a) * Math.PI)) * 0.5;
		buffer.set(bufptr, 
			buffer.get(bufptr) + left * (sample_left.get(a) * (1. -interpolation_factor) + 
				sample_left.get(b) * interpolation_factor));	
		buffer.set(bufptr + 1, 
			buffer.get(bufptr + 1) + right * (sample_right.get(a) * (1. -interpolation_factor) + 
				sample_right.get(b) * interpolation_factor));
	}
	
	public inline function copy_samples_cos_mono(buffer : FastFloatBuffer, bufptr : Int, 
								pos : Float, inc : Float, 
								left : Float, right : Float, 
								sample_left : FastFloatBuffer, sample_right : FastFloatBuffer, freq : Float,
								loop_start : Float, loop_end : Float, loop_len : Float)
	{
		// cosine interpolator(mono sample)
		var ideal = Math.min(pos, sample_left.length - 1);
		var a : Int = Std.int(ideal);
		var b : Int = Std.int(Math.min(pos + 1, sample_left.length - 1));
		var interpolation_factor : Float = (1 - Math.cos((pos - a) * Math.PI)) * 0.5;
		var sd = (sample_left.get(a) * (1. -interpolation_factor) + 
				sample_left.get(b) * interpolation_factor);
		buffer.set(bufptr, buffer.get(bufptr) + left * sd);	
		buffer.set(bufptr + 1, buffer.get(bufptr + 1) + right * sd);
	}
	
	public inline function copy_samples_opt2(buffer : FastFloatBuffer, bufptr : Int, 
								pos : Float, inc : Float, 
								left : Float, right : Float, 
								sample_left : FastFloatBuffer, sample_right : FastFloatBuffer, freq : Float,
								loop_start : Float, loop_end : Float, loop_len : Float)
	{
		// optimal 2x - 4p 4o - experimental. Accurate pitches!!!
		// from http://www.student.oulu.fi/~oniemita/dsp/deip.pdf
		var ideal = Math.min(pos, sample_left.length - 1);
		pos = pos + inc * 0.5;
		if (pos > loop_end)
			pos = ((pos - loop_start) % loop_len) + loop_start;
		var ideal2 = Math.min(pos, sample_left.length - 1);
		
		// this is not correct - we need a real filter to cut the MASSIVE high-freq gain
		left *= 0.0000005;
		right *= 0.0000005;
		
		var x = ideal - Std.int(ideal);
		var z = x - 0.5;
		
		var ym1 = 0.;
		var y0 = sample_left.get(Std.int(ideal));
		var y1 = 0.;
		var y2 = sample_left.get(Std.int(ideal2));
		
		var even1 = y1+y0, odd1 = y1-y0;
		var even2 = y2+ym1, odd2 = y2-ym1;
		var c0 = even1*0.45645918406487612 + even2*0.04354173901996461;
		var c1 = odd1*0.47236675362442071 + odd2*0.17686613581136501;
		var c2 = even1*-0.253674794204558521 + even2*0.25371918651882464;
		var c3 = odd1*-0.37917091811631082 + odd2*0.11952965967158000;
		var c4 = even1 * 0.04252164479749607 + even2 * -0.04289144034653719;
		buffer.set(bufptr, buffer.get(bufptr) + (left * (((c4*z+c3)*z+c2)*z+c1)*z+c0));
		
		var ym1 = 0.;
		var y0 = sample_right.get(Std.int(ideal));
		var y1 = 0.;
		var y2 = sample_right.get(Std.int(ideal2));
		
		var even1 = y1+y0, odd1 = y1-y0;
		var even2 = y2+ym1, odd2 = y2-ym1;
		var c0 = even1*0.45645918406487612 + even2*0.04354173901996461;
		var c1 = odd1*0.47236675362442071 + odd2*0.17686613581136501;
		var c2 = even1*-0.253674794204558521 + even2*0.25371918651882464;
		var c3 = odd1*-0.37917091811631082 + odd2*0.11952965967158000;
		var c4 = even1 * 0.04252164479749607 + even2 * -0.04289144034653719;
		buffer.set(bufptr+1, buffer.get(bufptr+1) + (right * (((c4*z+c3)*z+c2)*z+c1)*z+c0));
	}
	
	public function event(patch_ev : PatchEvent, channel : SequencerChannel)
	{
		var ev = patch_ev.sequencer_event;
		switch(ev.type)
		{
			case SequencerEvent.NOTE_ON: 
				// as the channel adds more voices, the priority of its notes gets squashed.
				// doing this on note ons naturally favors squashing of repetitive drum hits and stacattos,
				// which have plenty of release tails, instead of held notes.
				followers.push(new EventFollower(patch_ev, patch_ev.patch.envelopes.length));
				for (f in channel.allocated)
				{
					patch_ev.sequencer_event.priority = Std.int((patch_ev.sequencer_event.priority * PRIORITY_VOICE));
				}
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
