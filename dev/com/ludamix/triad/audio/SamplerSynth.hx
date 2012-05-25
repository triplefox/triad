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
import nme.Vector;

typedef RawSample = {
	sample_left : FastFloatBuffer, // only this side is used for mono
	sample_right : FastFloatBuffer,
};

typedef SamplerPatch = {
	mips_pre_loop : Array<RawSample>,
	mips_loop : Array<RawSample>,
	mips_post_loop : Array<RawSample>,
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

typedef CopySamples = FastFloatBuffer->Float->FastFloatBuffer->Void;

/*
 * Rewrites in progress:
 * 
 * done:
 * 		generate discrete mipmapped sample objects for pre-loop, loop, post-loop
 * 		reduced capability to only the looping part of the sample for now(ignoring other stages)
 * 		alchemy memory supported(minus effects)
 * todo:
 * 			introduce loop transitions
 * 				the "buffer size" written should not be the entire buffer...we have three possibilities:
 * 					1. pre-loop + any amount of the loop
 * 					2. loop only
 * 					3. post-loop + any amount of 0
 * 			allow sample length padding to accomodate interpolators (up to 4 samples out) - subtract from FFB length value
 * 			integrate the interpolators again
 * 			use more playheads?
 * 			effects are alchemy-safe - have them steal some oversized, reusable temp buffers
 * 
 * */

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
	
	public static function genMips(raw : RawSample) : Array<RawSample>
	{
		if (raw == null) return null;
		var mips = new Array<RawSample>();
		mips.push(raw);
		for (n in 0...13)
			mips.push(mipMap(mips[mips.length - 1], 2));
		return mips;
	}
	
	public static function loopForward(v : Vector<Float>, start : Int, end : Int) : Vector<Float> 
	{ 
		if (start==0 && (end==Std.int(v.length)))
			return v;
		else
		{
			var len = end - start;
			var rv = new Vector<Float>(len);
			for (n in 0...len)
				rv[n] = v[n + start];
			return rv;
		}
	}
	
	public static function loopBackward(v : Vector<Float>, start : Int, end : Int) : Vector<Float> 
	{ 
		var len = end - start;
		var rv = new Vector<Float>(len);
		for (n in 0...len)
			rv[len-n] = v[n + start];
		return rv;
	}
	
	public static function loopPingpong(v : Vector<Float>, start : Int, end : Int) : Vector<Float> 
	{ 
		var len = end - start;
		var rv = new Vector<Float>(len*2);
		for (n in 0...len)
		{
			rv[n] = v[n + start];
			rv[len + len - n] = v[n + start];
		}
		return rv;
	}
	
	public static function genRaw(wav_data : Array<Vector<Float>>, loop_method : Vector<Float>->Int->Int->Vector<Float>, 
		start : Int, end : Int) : RawSample
	{
		if (wav_data[0] == wav_data[1])
		{
			var buf = FastFloatBuffer.fromVector(loop_method(wav_data[0], start, end));
			return {sample_left:buf,sample_right:buf};
		}
		else
		{
			return { sample_left: FastFloatBuffer.fromVector(loop_method(wav_data[0], start, end)),
					sample_right: FastFloatBuffer.fromVector(loop_method(wav_data[1], start, end))};
		}
	}
	
	public static function ofWAVE(tuning : MIDITuning, wav : WAVE)
	{
		var wav_data = wav.data;
		
		var loop_type = SamplerSynth.ONE_SHOT;
		var midi_unity_note = 0;
		var midi_pitch_fraction = 0;
		var loop_start = 0;
		var loop_end = wav_data.length - 1;
		
		var raw_pre_loop : RawSample = null;
		var raw_loop : RawSample = null;
		var raw_post_loop : RawSample = null;
		
		if (wav.header.smpl != null)
		{
			
			if (wav.header.smpl.loop_data!=null && wav.header.smpl.loop_data.length>0)
			{
				loop_start = wav.header.smpl.loop_data[0].start;
				loop_end = wav.header.smpl.loop_data[0].end;
				
				switch(wav.header.smpl.loop_data[0].type)
				{
					case 0: loop_type = SamplerSynth.LOOP_FORWARD; 
						raw_loop = genRaw(wav_data,loopForward,loop_start,loop_end);
					case 1: loop_type = SamplerSynth.LOOP_PINGPONG;
						raw_loop = genRaw(wav_data,loopPingpong,loop_start,loop_end);
					case 2: loop_type = SamplerSynth.LOOP_BACKWARD;
						raw_loop = genRaw(wav_data,loopBackward,loop_start,loop_end);
				}
				raw_pre_loop = genRaw(wav_data,loopForward,0,loop_start);
				raw_post_loop = genRaw(wav_data,loopForward,loop_end,wav_data[0].length);
			}
			else
				raw_pre_loop = genRaw(wav_data,loopForward,0,wav_data[0].length);
			
			midi_unity_note = wav.header.smpl.midi_unity_note;
			midi_pitch_fraction = wav.header.smpl.midi_pitch_fraction;
		}
		else
		{
			raw_pre_loop = genRaw(wav_data,loopForward,0,wav_data[0].length);
		}
		return new PatchGenerator(
			{
			mips_pre_loop: genMips(raw_pre_loop),
			mips_loop: genMips(raw_loop),
			mips_post_loop: genMips(raw_post_loop),
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
		var raw = { sample_left:samples, sample_right:samples };
		return { 
				mips_pre_loop: null,
				mips_loop: genMips(raw),
				mips_post_loop: null,
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
			
			var sampleset : Array<RawSample> = null;
			if (patch.mips_loop != null)
				sampleset = patch.mips_loop;
			else if (patch.mips_pre_loop != null)
				sampleset = patch.mips_pre_loop;
			else if (patch.mips_post_loop != null)
				sampleset = patch.mips_post_loop;
			var sample_rate = patch.sample_rate;
			var base_frequency = patch.base_frequency;
			
			var ptr = 0;
			var freq_mult = 1;
			while (ptr < sampleset.length - 1 && freq > sample_rate*freq_mult)
				{ freq_mult *= 2; ptr++; }
			
			sample_rate *= freq_mult;
			base_frequency *= freq_mult;
			
			var sample_left_pre : FastFloatBuffer = null;
			var sample_right_pre : FastFloatBuffer = null;
			var sample_left_post : FastFloatBuffer = null;
			var sample_right_post : FastFloatBuffer = null;
			var sample_left_loop : FastFloatBuffer = null;
			var sample_right_loop : FastFloatBuffer = null;
			
			if (patch.mips_pre_loop != null)
			{
				var sample_pre = patch.mips_pre_loop[ptr];
				sample_left_pre = sample_pre.sample_left;
				sample_right_pre = sample_pre.sample_right;
				if (!patch.stereo) sample_right_pre = sample_left_pre;
			}
			if (patch.mips_loop != null)
			{
				var sample_loop = patch.mips_loop[ptr];
				sample_left_loop = sample_loop.sample_left;
				sample_right_loop = sample_loop.sample_right;
				if (!patch.stereo) sample_right_loop = sample_left_loop;
			}
			if (patch.mips_post_loop != null)
			{
				var sample_post = patch.mips_post_loop[ptr];
				sample_left_post = sample_post.sample_left;
				sample_right_post = sample_post.sample_right;
				if (!patch.stereo) sample_right_post = sample_left_post;
			}
			
			// we are assuming the sample rate is the mono rate.
			
			var base_wl = sample_rate / base_frequency;
			if (wl < 1) wl = 1;
			var inc_samples : Float = base_wl / wl;
			
			switch(patch.loop_mode)
			{
				case LOOP_FORWARD, LOOP_BACKWARD, LOOP_PINGPONG: 
					runLoop(cur_follower, buffer, inc_samples, left, right, 
							sample_left_pre, sample_right_pre, sample_left_loop, sample_right_loop,
							write);
				case SUSTAIN_FORWARD, SUSTAIN_BACKWARD, SUSTAIN_PINGPONG:
					runSustain(cur_follower, buffer, inc_samples, 
							left, right, sample_left_pre, sample_right_pre, 
							sample_left_loop, sample_right_loop,
							sample_left_post, sample_right_post,
							write);
				case ONE_SHOT, NO_LOOP:
					runUnlooped(cur_follower, buffer, inc_samples, 
							left, right, sample_left_pre, sample_right_pre,
							write);
			}
			
			if (cur_follower.loop_pos > 1. && (patch.loop_mode == ONE_SHOT || cur_follower.env[0].state == RELEASE))
			{
				cur_follower.env[0].state = OFF;
				cur_follower.loop_pos = 0.;
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
						if (patch.loop_mode == ONE_SHOT && master_state == OFF && 
							cur_follower.loop_pos < 1.)
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
	
	private inline function runLoop(cur_follower : EventFollower, buffer : FastFloatBuffer, sample_inc : Float, 
		left : Float, right : Float, 
		sample_left_pre : FastFloatBuffer, sample_right_pre : FastFloatBuffer,
		sample_left_loop : FastFloatBuffer, sample_right_loop : FastFloatBuffer,
		write : Bool
		)
	{
		// LOOP - repeat loop until envelope reaches OFF
		buffer.playhead = 0;
		if (cur_follower.loop_state == EventFollower.LOOP_PRE)
		{
			var inc = sample_inc / sample_left_pre.length;
			var ll = getLoopLen(cur_follower, buffer, inc, sample_left_pre);
			if (write) cur_follower.loop_pos = 
				runSegment(cur_follower, buffer, inc, left, right, sample_left_pre, sample_right_pre, ll);
			else cur_follower.loop_pos = 
				fakeSegment(cur_follower, inc, ll);
			if (buffer.playhead < buffer.length) cur_follower.loop_state = EventFollower.LOOP;
		}
		while (buffer.playhead < buffer.length)
		{
			var inc = sample_inc / sample_left_loop.length;
			if (write) cur_follower.loop_pos = 
				runSegment(cur_follower, buffer, inc, left, right, sample_left_loop, sample_right_loop,
				getLoopLen(cur_follower, buffer, inc, sample_left_loop));
			else cur_follower.loop_pos = 
				fakeSegment(cur_follower, inc, getLoopLen(cur_follower, buffer, inc, sample_left_loop));
		}
	}
	
	private inline function runSustain(cur_follower : EventFollower, buffer : FastFloatBuffer, sample_inc : Float, 
		left : Float, right : Float, 
		sample_left_pre : FastFloatBuffer, sample_right_pre : FastFloatBuffer,
		sample_left_loop : FastFloatBuffer, sample_right_loop : FastFloatBuffer,
		sample_left_post : FastFloatBuffer, sample_right_post : FastFloatBuffer,
		write : Bool
		)
	{
		// SUSTAIN - loop until release, then play to the first of envelope OFF or sample endpoint
		buffer.playhead = 0;
		if (cur_follower.loop_state == EventFollower.LOOP_PRE)
		{
			var inc = sample_inc / sample_left_pre.length;
			var ll = getLoopLen(cur_follower, buffer, inc, sample_left_pre);
			if (write) cur_follower.loop_pos = 
				runSegment(cur_follower, buffer, inc, left, right, sample_left_pre, sample_right_pre, ll);
			else cur_follower.loop_pos = 
				fakeSegment(cur_follower, inc, ll);
			if (buffer.playhead < buffer.length) cur_follower.loop_state = EventFollower.LOOP;
		}
		else if (cur_follower.loop_state == EventFollower.LOOP_POST)
		{
			var inc = sample_inc / sample_left_post.length;
			if (write) cur_follower.loop_pos = 
				runSegment(cur_follower, buffer, inc, left, right, sample_left_post, sample_right_post,
				getLoopLen(cur_follower, buffer, inc, sample_left_post));
			else cur_follower.loop_pos = 
				fakeSegment(cur_follower, inc, getLoopLen(cur_follower, buffer, inc, sample_left_post));
		}
		else
		{
			var inc = sample_inc / sample_left_loop.length;
			while (buffer.playhead < buffer.length)
			{
				if (write) cur_follower.loop_pos = 
					runSegment(cur_follower, buffer, inc, left, right, sample_left_loop, sample_right_loop,
					getLoopLen(cur_follower, buffer, inc, sample_left_loop));
				else cur_follower.loop_pos = 
					fakeSegment(cur_follower, inc, getLoopLen(cur_follower, buffer, inc, sample_left_loop));
			}
		}
	}
	
	private inline function runUnlooped(cur_follower : EventFollower, buffer : FastFloatBuffer, sample_inc : Float, 
		left : Float, right : Float, 
		sample_left_pre : FastFloatBuffer, sample_right_pre : FastFloatBuffer,
		write : Bool
		)
	{
		// ONE_SHOT - play until the sample endpoint, do not respect note off
		// NO_LOOP - play until the sample endpoint, cut on note off
		buffer.playhead = 0;
		var inc = sample_inc / sample_left_pre.length;
		if (cur_follower.loop_pos < 1.)
		{
			if (write) cur_follower.loop_pos = 
				runSegment(cur_follower, buffer, inc, left, right, sample_left_pre, sample_right_pre,
				getLoopLen(cur_follower, buffer, inc, sample_left_pre));
			else cur_follower.loop_pos = 
				fakeSegment(cur_follower, inc, getLoopLen(cur_follower, buffer, inc, sample_left_pre));
		}
	}
	
	private inline function getLoopLen(cur_follower : EventFollower, buffer : FastFloatBuffer, 
		inc : Float, loop_sample : FastFloatBuffer) : Int
	{
		
		// Calculates a single loop, starting from the buffer's playhead
		
		var len = buffer.length - buffer.playhead;
		
		var buffer_sample_in_loop_samples = MathTools.rescale(0, buffer.length, 0, loop_sample.length, 1);
		var loop_sample_in_buffer_samples = MathTools.rescale(0, loop_sample.length, 0, buffer.length, 1);
		
		// Find the lower of (remaining buffer samples, remaining loop samples)
		var samples = len;
		var buffers_in_loop = (loop_sample.length) * buffer_sample_in_loop_samples * (1. - cur_follower.loop_pos);
		
		// Cut samples in half to account for stereo. Then do some corrections.
		samples >>= 1;			
		while ((samples) * inc + cur_follower.loop_pos >= 1.) samples--;
		if (samples < 1) samples = 1;
		
		samples = 1;
		
		// Hooray! We know how much to copy.
		return samples;
		
	}
	
	private inline function fakeSegment(cur_follower : EventFollower, inc : Float, samples_requested : Int)
	{
		buffer.playhead += samples_requested;
		return (cur_follower.loop_pos + (inc * samples_requested)) % 1.;
	}
	
	private inline function runSegment(cur_follower : EventFollower, 
		buffer : FastFloatBuffer, inc : Float, left, right, sample_left : FastFloatBuffer, sample_right : FastFloatBuffer,
		samples_requested : Int)
	{
		// Copy exactly the number of samples requested for the buffer.
		// Callee has to figure out how to fill buffer correctly.
		
		var resample_type = copy_samples_drop;
		/*if (inc != 1)
		{
			if (sample_left == sample_right) 
				resample_type = copy_samples_lin;
			else 
				resample_type = copy_samples_lin_mono;
		}*/		
		
		var total_inc = inc * (samples_requested);
		
		sample_left.playback_rate = 1;
		sample_right.playback_rate = 1;
		
		var pos = cur_follower.loop_pos % 1.;
		var len = sample_left.length;
		
		if (sample_left == sample_right)
		{
			for (n in 0...samples_requested)
			{
				sample_left.playhead = Std.int(pos * len);
				resample_type(buffer, left, sample_left);
				buffer.advancePlayheadUnbounded();
				resample_type(buffer, right, sample_left);
				buffer.advancePlayheadUnbounded();
				pos += inc;
			}
		}
		else
		{
			for (n in 0...samples_requested)
			{
				sample_left.playhead = Std.int(pos * len);
				sample_right.playhead = sample_left.playhead;
				resample_type(buffer, left, sample_left);
				buffer.advancePlayheadUnbounded();
				resample_type(buffer, right, sample_right);
				buffer.advancePlayheadUnbounded();
				pos += inc;
			}
		}
		return pos;
	}
	
	/*private inline function loopSustain(copy_samples : CopySamples, cur_follower: EventFollower, loop_end:Int, 
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
	}*/
	
	public inline function copy_samples_drop(buffer : FastFloatBuffer, level : Float, sample : FastFloatBuffer)
	{
		// Drop
		buffer.add(level * (sample.read()));
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
	
	/*public inline function copy_samples_lin(buffer : FastFloatBuffer, bufptr : Int, 
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
	}*/

	/*public inline function copy_samples_lin_mono(buffer : FastFloatBuffer, bufptr : Int, 
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
	}*/
	
	/*public inline function copy_samples_cos(buffer : FastFloatBuffer, bufptr : Int, 
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
	}*/
	
	/*public inline function copy_samples_cos_mono(buffer : FastFloatBuffer, bufptr : Int, 
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
	}*/
	
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
