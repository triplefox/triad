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
import nme.Vector;
import nme.Vector;

typedef RawSample = {
	sample_left : FastFloatBuffer, // only this side is used for mono
	sample_right : FastFloatBuffer,
	multiplier : Float
};

typedef MipData = {
	left:Vector<Float>,
	right:Vector<Float>,
	multiplier: Float
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
	
	public static inline var PAD_INTERP = 1; // pad each sample for interpolation purposes
	
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

	private static function _mip2_spline(sample : Vector<Float>) : Vector<Float>
	{
		// four point spline interpolator
		var true_len = (sample.length - PAD_INTERP) >> 1;
		var out = new Vector<Float>();
		for (i in 0...true_len)
		{
			var y0 = sample[(i << 1) % sample.length];
			var y1 = sample[((i << 1) + 1) % sample.length];
			var y2 = sample[((i << 1) + 2) % sample.length];
			var y3 = sample[((i << 1) + 3) % sample.length];
			var x = 0.5;
			// lifted from OpenMPT
			var Xo = y1;
			var Xa = y0 - Xo;
			var Xb = y2 - Xo;
	        var Ux = (Xb-Xa)/2;
	        var Vx = (y3 - Xo)/2;
	        var a = Vx+Ux-2*Xb;
	        var b = 3 * Xb - 2 * Ux - Vx;
			out.push((((a * x + b) * x) + Ux) * x + Xo);
		}
		for (i in 0...PAD_INTERP)
			out.push(0.);
		return out;
	}
	
	public static function mipx2(mip_in : MipData): MipData
	{
		var result_l = mip_in.left;
		var result_r = mip_in.right;
		
		result_l = _mip2_spline(result_l);
		if (mip_in.left == mip_in.right)
			result_r = result_l;
		else result_r = _mip2_spline(result_r);
		
		return { left:result_l, right:result_r, multiplier:mip_in.multiplier*2 };
	}
	
	public static function genMips(left : Vector<Float>, right : Vector<Float>) : 
			Array<{left:Vector<Float>,right:Vector<Float>,multiplier:Float}>
	{
		var mips = new Array<{left:Vector<Float>,right:Vector<Float>,multiplier:Float}>();
		mips.push( { left:left, right:right, multiplier:1. } );
		for (n in 0...PAD_INTERP)
			{ left.push(0.); right.push(0.); }
		for (n in 0...13)
		{
			//mips.push(mipx2(mips[mips.length - 1]));
		}
		return mips;
	}
	
	public static function genRaw(mips : Array<MipData>) : Array<RawSample>
	{
		var result = new Array<RawSample>();
		for (m in mips)
		{
			if (m.left == m.right)
			{
				var buf = FastFloatBuffer.fromVector(m.left);
				result.push({sample_left:buf,sample_right:buf,multiplier:m.multiplier});
			}
			else
			{
				var buf_l = FastFloatBuffer.fromVector(m.left);
				var buf_r = FastFloatBuffer.fromVector(m.right);
				result.push({sample_left:buf_l,sample_right:buf_r,multiplier:m.multiplier});
			}
		}
		return result;
	}
	
	public static function ofWAVE(tuning : MIDITuning, wav : WAVE)
	{
		var wav_data = wav.data;
		
		var loop_type = SamplerSynth.ONE_SHOT;
		var midi_unity_note = 0;
		var midi_pitch_fraction = 0;
		var loop_start = 0;
		var loop_end = wav_data.length - 1;
		
		var mips : Array<MipData> = genMips(wav.data[0], wav.data[1]);
		
		if (wav.header.smpl != null)
		{
				
			if (wav.header.smpl.loop_data!=null && wav.header.smpl.loop_data.length>0)
			{
				loop_start = wav.header.smpl.loop_data[0].start;
				loop_end = wav.header.smpl.loop_data[0].end;
			}
			
			midi_unity_note = wav.header.smpl.midi_unity_note;
			midi_pitch_fraction = wav.header.smpl.midi_pitch_fraction;
		}
		
		return new PatchGenerator(
			{
			mips: genRaw(mips),
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
		var samples = new Vector<Float>();
		for (n in 0...44100)
		{
			samples.push(Math.sin(n / 44100 * Math.PI * 2));
		}
		
		var loop_start = 0;
		var loop_end = samples.length-1;
		var mips = genRaw(genMips(samples,samples));
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
			if (env.state < OFF)
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
		
		for (follower in followers)
		{
			progress_follower(follower, follower==cur_follower);
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
			
			var sampleset : Array<RawSample> = patch.mips;
			var sample_rate = patch.sample_rate;
			var base_frequency = patch.base_frequency;
			
			var ptr = 0;
			var freq_mult = 1;
			while (ptr < sampleset.length - 1 && freq > sample_rate*freq_mult)
				{ freq_mult *= 2; ptr++; }
			
			sample_rate *= freq_mult;
			base_frequency *= freq_mult;
			
			var sample_left : FastFloatBuffer = sampleset[ptr].sample_left;
			var sample_right : FastFloatBuffer = sampleset[ptr].sample_right;
			if (!patch.stereo) sample_right = sample_left;
			
			// we are assuming the sample rate is the mono rate.
			
			var base_wl = sample_rate / base_frequency;
			if (wl < 1) wl = 1;
			var inc_samples : Float = base_wl / wl;
			
			switch(patch.loop_mode)
			{
				case LOOP_FORWARD, LOOP_BACKWARD, LOOP_PINGPONG: 
					runLoop(cur_follower, buffer, inc_samples, left, right, sample_left, sample_right, write);
				// FIXME: Find samples that test sustain so that it can be implemented properly
				case SUSTAIN_FORWARD, SUSTAIN_BACKWARD, SUSTAIN_PINGPONG:
					runLoop(cur_follower, buffer, inc_samples, left, right, sample_left, sample_right, write);
				case ONE_SHOT, NO_LOOP:
					runUnlooped(cur_follower, buffer, inc_samples, left, right, sample_left, sample_right, write);
			}
			
			if (cur_follower.loop_pos >= sample_left.length && 
				(patch.loop_mode == ONE_SHOT || cur_follower.env[0].state == RELEASE))
			{
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
	
	private inline function runLoop(cur_follower : EventFollower, buffer : FastFloatBuffer, inc : Float, 
		left : Float, right : Float, sample_left : FastFloatBuffer, sample_right : FastFloatBuffer, write : Bool)
	{
		// LOOP - repeat loop until envelope reaches OFF
		buffer.playhead = 0;
		
		// now we reintroduce the loop points, bringing it back to where it "used" to be but a little faster
		// then we add backwards and forwards runs, and then bidi.
		// lastly, we turn this stuff into macros to get the line count down a little more and make the concept generic.
		
		var temp_pos = cur_follower.loop_pos * sample_left.length;
		var loop_end = sample_left.length - 1 - PAD_INTERP;
		while (buffer.playhead < buffer.length)
		{
			if (cur_follower.loop_state == EventFollower.LOOP_PRE)
			{
				var ll = getLoopLen(temp_pos, buffer, inc, loop_end);
				var next_pos = runSegment(buffer, temp_pos, inc, left, right, sample_left, sample_right, ll, write);
				if (next_pos > loop_end) // we crossed the threshold into the loop
					cur_follower.loop_state = EventFollower.LOOP;
				temp_pos = next_pos;
			}
			else
			{
				temp_pos = divisorModulo(temp_pos, loop_end);
				var ll = getLoopLen(temp_pos, buffer, inc, loop_end);
				temp_pos = runSegment(buffer, temp_pos, inc, left, right, sample_left, sample_right, ll, write);
			}
		}
		cur_follower.loop_pos = temp_pos / sample_left.length;
	}
	
	private inline function runUnlooped(cur_follower : EventFollower, buffer : FastFloatBuffer, inc : Float, 
		left : Float, right : Float, sample_left : FastFloatBuffer, sample_right : FastFloatBuffer, write : Bool)
	{
		// ONE_SHOT - play until the sample endpoint, do not respect note off
		// NO_LOOP - play until the sample endpoint, cut on note off
		
		buffer.playhead = 0;
		cur_follower.loop_state = EventFollower.LOOP_POST;
		var temp_pos = cur_follower.loop_pos * sample_left.length;
		var loop_end = sample_left.length - 1 - PAD_INTERP;
		while (buffer.playhead < buffer.length)
		{
			if (temp_pos >= loop_end)
			{
				temp_pos = temp_pos + inc * (buffer.length-buffer.playhead);
				buffer.playhead = buffer.length;
			}
			else
			{
				var ll = getLoopLen(temp_pos, buffer, inc, loop_end);
				temp_pos = runSegment(buffer, temp_pos, inc, left, right, sample_left, sample_right, ll, write);
				if (ll == 0)
					buffer.playhead = buffer.length;
			}
		}
		cur_follower.loop_pos = temp_pos / sample_left.length;
	}
	
	private inline function getLoopLen(loop_pos : Float, buffer : FastFloatBuffer, inc : Float, loop_end : Int) : Int
	{
		
		// Calculates a single loop, starting from the buffer's playhead
		
		var len = buffer.length - buffer.playhead;
		var samples = Std.int(Math.min(len, (loop_end - loop_pos) / inc));
		
		// Cut samples in half to account for stereo. Then do some corrections.
		samples >>= 1;
		while ((samples) * inc + loop_pos > loop_end + inc) samples--;
		if (samples == 0 ) samples = 1;
		
		return samples;
		
	}
	
	private inline function divisorModulo(val : Float, mod : Float) : Float
	{
		return val < 0 ? mod - ( -val % mod) : val % mod;
	}
	
	private inline function runSegment(buffer : FastFloatBuffer, 
		pos : Float, inc : Float, left, right, sample_left : FastFloatBuffer, sample_right : FastFloatBuffer,
		samples_requested : Int, write : Bool)
	{
		// Copy exactly the number of samples requested for the buffer.
		// Callee has to figure out how to fill buffer correctly.
		
		var len = (sample_left.length - PAD_INTERP);
		if (!write)
		{
			buffer.playhead += samples_requested * 2;
			pos = pos + (inc * samples_requested);
			return pos;
		}
		else
		{
			var total_inc = inc * (samples_requested);
			
			sample_left.playback_rate = 1;
			sample_right.playback_rate = 1;
			
			if (sample_left == sample_right)
			{
				if (inc == 1.) // drop mono
				{
					for (n in 0...samples_requested)
					{
						sample_left.playhead = Std.int(pos);
						var a = sample_left.read();
						copy_samples_drop(buffer, a, left);
						buffer.advancePlayheadUnbounded();
						copy_samples_drop(buffer, a, right);
						buffer.advancePlayheadUnbounded();
						pos += inc;
					}
				}
				else // linear mono
				{
					for (n in 0...samples_requested)
					{
						sample_left.playhead = Std.int(pos);
						var x = pos - sample_left.playhead;
						var a = sample_left.read(); sample_left.advancePlayheadUnbounded();
						var b = sample_left.read();
						copy_samples_lin(buffer, a, b, x, left);
						buffer.advancePlayheadUnbounded();
						copy_samples_lin(buffer, a, b, x, right);
						buffer.advancePlayheadUnbounded();
						pos += inc;
					}				
				}
			}
			else
			{
				if (inc == 1.) // drop stereo
				{
					for (n in 0...samples_requested)
					{
						sample_left.playhead = Std.int(pos);
						sample_right.playhead = sample_left.playhead;
						copy_samples_drop(buffer, sample_left.read(), left);
						buffer.advancePlayheadUnbounded();
						copy_samples_drop(buffer, sample_right.read(), right);
						buffer.advancePlayheadUnbounded();
						pos += inc;
					}
				}
				else // linear stereo
				{
					for (n in 0...samples_requested)
					{
						sample_left.playhead = Std.int(pos);
						var x = pos - sample_left.playhead;
						var a = sample_left.read(); sample_left.advancePlayheadUnbounded();
						var b = sample_left.read();
						copy_samples_lin(buffer, a, b, x, left);
						buffer.advancePlayheadUnbounded();
						a = sample_right.read(); sample_right.advancePlayheadUnbounded();
						b = sample_right.read();
						copy_samples_lin(buffer, a, b, x, right);
						buffer.advancePlayheadUnbounded();
						pos += inc;
					}				
				}
			}
			return pos;
		}
	}
	
	public inline function copy_samples_drop(buffer : FastFloatBuffer, a : Float, level : Float)
	{
		// Drop
		buffer.add(level * a);
	}
	
	public inline function copy_samples_lin(buffer : FastFloatBuffer, a : Float, b : Float, x : Float, level : Float)
	{
		// Linear
		buffer.add(level * (a * (1. -x) + b * x));
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
	
	public function getEvents() : Array<PatchEvent>
	{
		var result = new Array<PatchEvent>();
		for ( n in followers )
		{
			result.push(n.patch_event);
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
