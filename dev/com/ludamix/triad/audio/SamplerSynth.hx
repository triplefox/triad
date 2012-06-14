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
import com.ludamix.triad.audio.Envelope;
import nme.Assets;
import nme.utils.ByteArray;
import nme.utils.CompressionAlgorithm;
import com.ludamix.triad.audio.Sequencer;
import com.ludamix.triad.audio.VoiceCommon;
import nme.Vector;

typedef RawSample = {
	sample_left : FastFloatBuffer, // only this side is used for mono
	sample_right : FastFloatBuffer,
	rate_multiplier : Float
};

typedef MipData = {
	left:Vector<Float>,
	right:Vector<Float>,
	rate_multiplier: Float
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
	envelope_profiles : Array<EnvelopeProfile>,
	lfos : Array<LFO>,
	modulation_lfo : Float, // multiplier if greater than 0
	arpeggiation_rate : Float, // 0 = off, hz value	
	cutoff_frequency : Float,
	filter_mode : Int,
	resonance_level : Float,
	name : String
};

/*
 * Things that would be nice to see:
 * 
 * per-sample envelopes (this will fix a few "clicking" artifacts, but mostly can be covered in data)
 * make the pingpong loop not suck(this means getting the edge samples exact, right now they are really "meh",
 * 	and only work on very forgiving material).
 * macroified implementation of the sample copiers so that source code size is small and maintainable
 * implementation of all sfz filter types (IIRFilter2's lowpass is just a starting point)
 * implementation of more sfz opcodes (up to the limits of the current architecture)
 * optimize to not use the filter _all_ the time (probably after macroifying)
 * 
 * */
 
class SamplerSynth implements SoftSynth
{
	
	public var common : VoiceCommon;
	
	public var resample_method : Int;
	
	public static inline var RESAMPLE_DROP = 0;
	public static inline var RESAMPLE_LINEAR = 1;
	public static inline var RESAMPLE_CUBIC = 2;
	
	public static inline var ATTACK = 0;
	public static inline var SUSTAIN = 1;
	public static inline var RELEASE = 2;
	public static inline var OFF = 3;
	
	public function new()
	{
		common = new VoiceCommon();
		resample_method = RESAMPLE_LINEAR;
	}
	
	public static inline var PAD_INTERP = 3; // pad each sample for interpolation purposes
											 // use 1 for linear, 3 for cubic
	
	public static inline var LOOP_FORWARD = 0;
	public static inline var LOOP_BACKWARD = 1;
	public static inline var LOOP_PINGPONG = 2;
	public static inline var SUSTAIN_FORWARD = 3;
	public static inline var SUSTAIN_BACKWARD = 4;
	public static inline var SUSTAIN_PINGPONG = 5;
	public static inline var ONE_SHOT = 6;
	public static inline var NO_LOOP = 7;
	
	// heuristic to ramp down priority when releasing
	public static inline var PRIORITY_RAMPDOWN = 0.95;
	// and ramp up priority when sustaining
	public static inline var PRIORITY_RAMPUP = 1;

	private static function _mip2_hermite6(sample : Vector<Float>) : Vector<Float>
	{
		// six point hermite spline interpolator
		var true_len = (sample.length - PAD_INTERP) >> 1;
		var out = new Vector<Float>();
		for (i in 0...true_len)
		{
			var y0 = sample[(i << 1) % sample.length];
			var y1 = sample[((i << 1) + 1) % sample.length];
			var y2 = sample[((i << 1) + 2) % sample.length];
			var y3 = sample[((i << 1) + 3) % sample.length];
			var y4 = sample[((i << 1) + 4) % sample.length];
			var y5 = sample[((i << 1) + 5) % sample.length];
			var z = 0. - 0.5;
			var even1 = y0 + y5; var odd1 = y0 - y5;
			var even2 = y1 + y4; var odd2 = y1 - y4;
			var even3 = y2 + y1; var odd3 = y2 - y3;
			var c0 = 3/256.0*even1 - 25/256.0*even2 + 75/128.0*even3;
			var c1 = -3/128.0*odd1 + 61/384.0*odd2 - 87/64.0*odd3;
			var c2 = -5/96.0*even1 + 13/32.0*even2 - 17/48.0*even3;
			var c3 = 5/48.0*odd1 - 11/16.0*odd2 + 37/24.0*odd3;
			var c4 = 1/48.0*even1 - 1/16.0*even2 + 1/24.0*even3;
			var c5 = -1/24.0*odd1 + 5/24.0*odd2 - 5/12.0*odd3;
			out.push(((((c5 * z + c4) * z + c3) * z + c2) * z + c1) * z + c0);
		}
		for (i in 0...PAD_INTERP)
			out.push(0.);
		return out;
	}
	
	private static function _mip2_hermite6_2(sample : Vector<Float>) : Vector<Float>
	{
		// six point hermite spline interpolator (half-rate)
		var true_len = (sample.length - PAD_INTERP);
		var out = new Vector<Float>();
		for (i in 0...true_len)
		{
			var y0 = sample[(i ) % sample.length];
			var y1 = sample[((i + 1)) % sample.length];
			var y2 = sample[((i) + 2) % sample.length];
			var y3 = sample[((i) + 3) % sample.length];
			var y4 = sample[((i) + 4) % sample.length];
			var y5 = sample[((i) + 5) % sample.length];
			var z = 0. - 0.5;
			var even1 = y0 + y5; var odd1 = y0 - y5;
			var even2 = y1 + y4; var odd2 = y1 - y4;
			var even3 = y2 + y1; var odd3 = y2 - y3;
			var c0 = 3/256.0*even1 - 25/256.0*even2 + 75/128.0*even3;
			var c1 = -3/128.0*odd1 + 61/384.0*odd2 - 87/64.0*odd3;
			var c2 = -5/96.0*even1 + 13/32.0*even2 - 17/48.0*even3;
			var c3 = 5/48.0*odd1 - 11/16.0*odd2 + 37/24.0*odd3;
			var c4 = 1/48.0*even1 - 1/16.0*even2 + 1/24.0*even3;
			var c5 = -1/24.0*odd1 + 5/24.0*odd2 - 5/12.0*odd3;
			out.push(((((c5 * z + c4) * z + c3) * z + c2) * z + c1) * z + c0);
			z = 0.5 - 0.5;
			out.push(((((c5 * z + c4) * z + c3) * z + c2) * z + c1) * z + c0);
		}
		for (i in 0...PAD_INTERP)
			out.push(0.);
		return out;
	}
	
	public static function mipx2(mip_in : MipData): MipData
	{
		var result_l = mip_in.left;
		var result_r = mip_in.right;
		
		result_l = _mip2_hermite6(result_l);
		if (mip_in.left == mip_in.right)
			result_r = result_l;
		else result_r = _mip2_hermite6(result_r);
		
		return { left:result_l, right:result_r, rate_multiplier:mip_in.rate_multiplier/2};
	}
	
	public static function miph2(mip_in : MipData): MipData
	{
		var result_l = mip_in.left;
		var result_r = mip_in.right;
		
		result_l = _mip2_hermite6_2(result_l);
		if (mip_in.left == mip_in.right)
			result_r = result_l;
		else result_r = _mip2_hermite6_2(result_r);
		
		return { left:result_l, right:result_r, rate_multiplier:mip_in.rate_multiplier*2};
	}
	
	public static function genMips(left : Vector<Float>, right : Vector<Float>) : 
			Array<MipData>
	{
		var mips = new Array<MipData>();
		mips.push( { left:left, right:right, rate_multiplier:1. } );
		for (n in 0...PAD_INTERP)
			{ left.push(0.); right.push(0.); }
		for (n in 0...4)
			mips.push(mipx2(mips[mips.length - 1]));
		// FIXME: Trying to make a downsampled mip actually sounds worse in some material. 
		// It could be the interpolation, the mipmapping, or loop setting at fault...or just the general concept :p
		// for testing I recommend removing all other mips(including original)
		//for (n in 0...1)
		//	mips.insert(0, miph2(mips[0]));
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
				result.push( { sample_left:buf, sample_right:buf,rate_multiplier:m.rate_multiplier});
			}
			else
			{
				var buf_l = FastFloatBuffer.fromVector(m.left);
				var buf_r = FastFloatBuffer.fromVector(m.right);
				result.push( { sample_left:buf_l, sample_right:buf_r, rate_multiplier:m.rate_multiplier});
			}
		}
		return result;
	}
	
	public static function ofWAVE(tuning : MIDITuning, wav : WAVE, name : String)
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
				loop_type = wav.header.smpl.loop_data[0].type;
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
			envelope_profiles:[Envelope2.ADSR(function(i:Float) { return i; },0.,0.0,1.0,0.0,[VoiceCommon.AS_VOLUME_ADD])],
			volume:1.0,
			lfos:[{frequency:6.,depth:0.5,delay:0.05,attack:0.05,assigns:[VoiceCommon.AS_PITCH_ADD]}],
			modulation_lfo:1.0,
			arpeggiation_rate:0.0,
			cutoff_frequency:0.,
			filter_mode:VoiceCommon.FILTER_OFF,
			resonance_level:0.,
			name:name
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
				envelope_profiles:[Envelope2.ADSR(function(i:Float) { return i; },0.,0.0,1.0,0.0,[VoiceCommon.AS_VOLUME_ADD])],
				lfos:[{frequency:6.,depth:0.5,delay:0.05,attack:0.05,assigns:[VoiceCommon.AS_PITCH_ADD]}],
				modulation_lfo:1.0,
				arpeggiation_rate:0.0,
				filter_mode:VoiceCommon.FILTER_OFF,
				cutoff_frequency:0.,
				resonance_level:0.,
				name:"default"
				}
				;
	}
	
	public inline function write()
	{	
		return common.updateFollowers(progress_follower);
	}
	
	public function progress_follower(infos : VoiceFrameInfos,
		cur_follower : EventFollower, ?write : Bool)
	{
		
		var freq = infos.frequency;
		var wl = infos.wavelength;
		var left = infos.volume_left;
		var right = infos.volume_right;
		
		if (!cur_follower.isOff())
		{
			
			var patch : SamplerPatch = cur_follower.patch_event.patch;
			var buffer = common.buffer;
			
			var sampleset : Array<RawSample> = patch.mips;
			var sample_rate = patch.sample_rate;
			var base_frequency = patch.base_frequency;
			
			// select an appropriate mipmap
			var ptr = 0;
			var best_dist = 99999999999.;
			for (n in 0...sampleset.length)
			{
				var dist = Math.abs(wl - (sample_rate / base_frequency) * sampleset[n].rate_multiplier);
				if (dist < best_dist)
					{ best_dist = dist; ptr = n; }
			}
			
			var rate_mult = sampleset[ptr].rate_multiplier;
			
			sample_rate = Std.int(sample_rate * rate_mult);
			
			var sample_left : FastFloatBuffer = sampleset[ptr].sample_left;
			var sample_right : FastFloatBuffer = sampleset[ptr].sample_right;
			if (!patch.stereo) sample_right = sample_left;
			
			// we are assuming the sample rate is the mono rate.
			
			var base_wl = sample_rate / base_frequency;
			if (wl < 1) wl = 1;
			var inc_samples : Float = base_wl / wl;
			
			switch(patch.loop_mode)
			{
				// FIXME: Find samples that test sustain so that it can be implemented properly
				case LOOP_FORWARD, LOOP_BACKWARD, SUSTAIN_FORWARD, SUSTAIN_BACKWARD, LOOP_PINGPONG, SUSTAIN_PINGPONG: 
					runLoop(cur_follower, buffer, inc_samples, left, right, sample_left, sample_right, rate_mult, write);
				case ONE_SHOT, NO_LOOP:
					runUnlooped(cur_follower, buffer, inc_samples, left, right, sample_left, sample_right, write);
			}
			
			// kill the voice quickly when the settings allow it
			if (cur_follower.loop_pos > sample_left.length+inc_samples && 
				(patch.loop_mode == ONE_SHOT || cur_follower.env[0].releasing()))
			{
				cur_follower.setOff();
			}
			
			// Priority calculations.
			
			var ct = 0;
			var master = cur_follower.env[0];
			
			if (!master.isOff())
			{
				if (master.sustaining()) // encourage sustains to be retained
					cur_follower.patch_event.sequencer_event.priority += PRIORITY_RAMPUP;
				// allow one shots to play through, ignoring their envelope tail
				if (patch.loop_mode == ONE_SHOT && cur_follower.loop_pos < 1.)
					cur_follower.setRelease();
			}
			if (master.releasing()) // ramp down on release
			{
				cur_follower.patch_event.sequencer_event.priority = 
					Std.int(cur_follower.patch_event.sequencer_event.priority * PRIORITY_RAMPDOWN);
			}
			
		}
			
	}
	
	private inline function runLoop(cur_follower : EventFollower, buffer : FastFloatBuffer, inc : Float, 
		left : Float, right : Float, sample_left : FastFloatBuffer, sample_right : FastFloatBuffer, rate_mult : Float, 
		write : Bool)
	{
		// LOOP - repeat loop until envelope reaches OFF
		buffer.playhead = 0;
		
		var temp_pos = cur_follower.loop_pos * sample_left.length;
		var loop_start : Float = (cur_follower.patch_event.patch.loop_start * rate_mult);
		var loop_end : Float = (cur_follower.patch_event.patch.loop_end * rate_mult);
		var loop_len : Float = (loop_end - loop_start) + 1;
		
		var loop_mode = cur_follower.patch_event.patch.loop_mode;
		
		while (buffer.playhead < buffer.length)
		{
			if (cur_follower.loop_state == EventFollower.LOOP_PRE)
			{
				var ll = getLoopLen(temp_pos, buffer, inc, loop_start);
				temp_pos = runSegment2(buffer, temp_pos, inc, left, right, sample_left, 
					sample_right, ll, write);
				if (temp_pos >= loop_start) // we crossed the threshold into the loop
				{
					switch(loop_mode)
					{
						case LOOP_BACKWARD, SUSTAIN_BACKWARD:
							cur_follower.loop_state = EventFollower.LOOP_BACKWARD;
						case LOOP_PINGPONG, SUSTAIN_PINGPONG:
							cur_follower.loop_state = EventFollower.LOOP_PING;
						default:
							cur_follower.loop_state = EventFollower.LOOP_FORWARD;
					}
				}
			}
			else 
			{ 
				if (cur_follower.loop_state == EventFollower.LOOP_FORWARD || 
					cur_follower.loop_state == EventFollower.LOOP_PING)
				{
					// forward
					var lt = temp_pos;
					temp_pos = ((temp_pos - loop_start) % loop_len) + loop_start;
					var ll = getLoopLen(temp_pos, buffer, inc, loop_end);
					temp_pos = runSegment(buffer, temp_pos, inc, left, right, sample_left, 
						sample_right, ll, loop_end, loop_len, write);
					if (cur_follower.loop_state == EventFollower.LOOP_PING && temp_pos < lt)
					{
						cur_follower.loop_state = EventFollower.LOOP_PONG;
					}
				}
				else 
				{
					// backward
					var lt = temp_pos;
					temp_pos = ((temp_pos - loop_start) % loop_len) + loop_start;
					var temp_pos_b = loop_end - temp_pos;
					var ll = getLoopLen(temp_pos, buffer, inc, loop_end);
					runSegment(buffer, temp_pos_b, -inc, 
						left, right, sample_left, sample_right, ll, loop_end, loop_len, write);
					temp_pos += ll * inc;
					if (cur_follower.loop_state == EventFollower.LOOP_PONG && temp_pos < lt)
					{
						cur_follower.loop_state = EventFollower.LOOP_PING;
					}
				}
			}
		}		
		cur_follower.loop_pos = temp_pos / sample_left.length;
	}
	
	private inline function runUnlooped(cur_follower : EventFollower, buffer : FastFloatBuffer, inc : Float, 
		left : Float, right : Float, sample_left : FastFloatBuffer, sample_right : FastFloatBuffer, 
		write : Bool)
	{
		// ONE_SHOT - play until the sample endpoint, do not respect note off
		// NO_LOOP - play until the sample endpoint, cut on note off
		
		buffer.playhead = 0;
		cur_follower.loop_state = EventFollower.LOOP_POST;
		var temp_pos = cur_follower.loop_pos * sample_left.length;
		var loop_end : Int = sample_left.length - 1 - PAD_INTERP;
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
				temp_pos = runSegment2(buffer, temp_pos, inc, left, 
					right, sample_left, sample_right, ll, write);
				if (ll < 1)
					buffer.playhead = buffer.length;
			}
		}
		cur_follower.loop_pos = temp_pos / sample_left.length;
	}
	
	private inline function getLoopLen(loop_pos : Float, buffer : FastFloatBuffer, inc : Float, loop_end : Float) : Int
	{
		
		// Calculates a single loop, starting from the buffer's playhead
		
		var len = buffer.length - buffer.playhead;
		
		var samples = Std.int(Math.min(len, (loop_end - loop_pos) / inc));
		
		// Cut samples in half to account for stereo. Then do some corrections.
		samples >>= 1;
		while ((samples) * inc + loop_pos > loop_end) samples--;
		if (samples < 1 ) samples = 1;
		
		return samples;
		
	}
	
	private inline function divisorModulo(val : Float, mod : Float) : Float
	{
		return val < 0 ? negativeModulo(val, mod) : val % mod;
	}
	
	private inline function negativeModulo(val : Float, mod : Float) : Float
	{
		return mod - ( -val % mod);
	}
	
	private inline function runSegment(buffer : FastFloatBuffer, 
		pos : Float, inc : Float, left : Float, right : Float, sample_left : FastFloatBuffer, sample_right : FastFloatBuffer,
		samples_requested : Int, loop_end : Float, loop_len : Float, write : Bool)
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
				if (inc == 1. || resample_method == RESAMPLE_DROP) // drop mono
				{
					if (common.filter_mode == VoiceCommon.FILTER_OFF)
						CopyLoop.copyLoop(1, "mirror", ["interp_drop"], "loop");
					else
						CopyLoop.copyLoop(1, "mirror", ["lowpass_filter","interp_drop"], "loop");
				}
				else if (resample_method == RESAMPLE_CUBIC) // cubic mono
				{
					if (common.filter_mode == VoiceCommon.FILTER_OFF)
						CopyLoop.copyLoop(4, "mirror", ["interp_cubic"], "loop");
					else
						CopyLoop.copyLoop(4, "mirror", ["lowpass_filter","interp_cubic"], "loop");
				}
				else // linear mono
				{
					if (common.filter_mode == VoiceCommon.FILTER_OFF)
						CopyLoop.copyLoop(2, "mirror", ["interp_linear"], "loop");
					else
						CopyLoop.copyLoop(2, "mirror", ["lowpass_filter","interp_linear"], "loop");
				}
			}
			else
			{
				if (inc == 1. || resample_method == RESAMPLE_DROP) // drop stereo
				{
					if (common.filter_mode == VoiceCommon.FILTER_OFF)
						CopyLoop.copyLoop(1, "split", ["interp_drop"], "loop");
					else
						CopyLoop.copyLoop(1, "split", ["lowpass_filter","interp_drop"], "loop");
				}
				else if (resample_method == RESAMPLE_CUBIC) // cubic stereo
				{
					if (common.filter_mode == VoiceCommon.FILTER_OFF)
						CopyLoop.copyLoop(4, "split", ["interp_cubic"], "loop");
					else
						CopyLoop.copyLoop(4, "split", ["lowpass_filter","interp_cubic"], "loop");
				}
				else // linear stereo
				{
					if (common.filter_mode == VoiceCommon.FILTER_OFF)
						CopyLoop.copyLoop(2, "split", ["interp_linear"], "loop");
					else
						CopyLoop.copyLoop(2, "split", ["lowpass_filter","interp_linear"], "loop");
				}
			}
			return pos;
		}
	}
	
	private inline function runSegment2(buffer : FastFloatBuffer, 
		pos : Float, inc : Float, left : Float, right : Float, sample_left : FastFloatBuffer, sample_right : FastFloatBuffer,
		samples_requested : Int, write : Bool)
	{
		// As runSegment, but allows bleedover (for the "pre" loop segment)
		
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
				if (inc == 1. || resample_method == RESAMPLE_DROP) // drop mono
				{
					if (common.filter_mode == VoiceCommon.FILTER_OFF)
						CopyLoop.copyLoop(1, "mirror", ["interp_drop"], "cut");
					else
						CopyLoop.copyLoop(1, "mirror", ["lowpass_filter","interp_drop"], "cut");
				}
				else if (resample_method == RESAMPLE_CUBIC) // cubic mono
				{
					if (common.filter_mode == VoiceCommon.FILTER_OFF)
						CopyLoop.copyLoop(4, "mirror", ["interp_cubic"], "cut");
					else
						CopyLoop.copyLoop(4, "mirror", ["lowpass_filter","interp_cubic"], "cut");
				}
				else // linear mono
				{
					if (common.filter_mode == VoiceCommon.FILTER_OFF)
						CopyLoop.copyLoop(2, "mirror", ["interp_linear"], "cut");
					else
						CopyLoop.copyLoop(2, "mirror", ["lowpass_filter","interp_linear"], "cut");
				}
			}
			else
			{
				if (inc == 1. || resample_method == RESAMPLE_DROP) // drop stereo
				{
					if (common.filter_mode == VoiceCommon.FILTER_OFF)
						CopyLoop.copyLoop(1, "split", ["interp_drop"], "cut");
					else
						CopyLoop.copyLoop(1, "split", ["lowpass_filter","interp_drop"], "cut");
				}
				else if (resample_method == RESAMPLE_CUBIC) // cubic stereo
				{
					if (common.filter_mode == VoiceCommon.FILTER_OFF)
						CopyLoop.copyLoop(4, "split", ["interp_cubic"], "cut");
					else
						CopyLoop.copyLoop(4, "split", ["lowpass_filter","interp_cubic"], "cut");
				}
				else // linear stereo
				{
					if (common.filter_mode == VoiceCommon.FILTER_OFF)
						CopyLoop.copyLoop(2, "split", ["interp_linear"], "cut");
					else
						CopyLoop.copyLoop(2, "split", ["lowpass_filter","interp_linear"], "cut");
				}
			}
			return pos;
		}
	}
	
	public inline function lowpass_filter(a : Float) { return common.filter.getLP(a); }
	
	public inline function interp_drop(a : Float) { return a; }
	
	public inline function interp_linear(a : Float, b : Float, x : Float)
	{ return (a * (1. -x) + b * x); }
	
	public inline function interp_cubic(y0 : Float, y1 : Float, y2 : Float, y3 : Float, x : Float)
	{
		var x2 = x*x;
		var a0 = y3 - y2 - y0 + y1;
		var a1 = y0 - y1 - a0;
		var a2 = y2 - y0;
		var a3 = y1;
		return (a0*x*x2+a1*x2+a2*x+a3);
	}
	
}
