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
import com.ludamix.triad.audio.SampleMipMap;
import com.ludamix.triad.audio.SoundSample;
import nme.Assets;
import nme.utils.ByteArray;
import nme.utils.CompressionAlgorithm;
import com.ludamix.triad.audio.Sequencer;
import com.ludamix.triad.audio.VoiceCommon;
import com.ludamix.triad.audio.Interpolator;
import nme.Vector;

// Some notes for our SF2 loader:
// Its hierarchy is:
// Preset -> Instrument -> Zone(s) -> Generator(s), Modulator(s)
// Zones map to SFZ groups.
// The generator and modulator enumerations more or less map to the SFZ opcodes.
// Each generator points to an Instrument and to a sample header...
// Which is wierd and stupid! But it means that I can assume instruments are treated as a consistent whole,
// and if they aren't the file is dumb and corrupt.

// To get the most basic SF2 sound loaded, we take the Instrument, load the first zone and first generator, and
// take the sample header of that one.
// To get all samples playing, we need to acknowledge that the generators map to different sample headers.
// Fuck, why did you make this so complex, Creative??
// Mmm. What we can do is create an internal representation/cache of each Zone, I guess.
// Before proceeding further I need to inspect my test file and see how it set up the zones and generators.
// Once the test file plays, I can "fix it up" later.

typedef SamplerPatch = {
	sample : SoundSample,
	tuning : SampleTuning,
	loops : Array<LoopInfo>,
	pan : Float,
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
 * better implementation of sfz filter types
 * implementation of more sfz opcodes (up to the limits of the current architecture)
 * 
 * */
 
class SamplerSynth implements SoftSynth
{
	
	public var common : VoiceCommon;
	
	public var resample_method : Int;
	
	public static inline var MIP_LEVELS = 8;
	
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
	
	public static function ofWAVE(tuning : MIDITuning, wav : WAVE, name : String)
	{
		
		var sample = SoundSample.ofWAVE(tuning, wav, name, MIP_LEVELS);
		
		var loops = new Array<LoopInfo>();
		for (n in sample.loops)
			loops.push(Reflect.copy(n));
		
		return new PatchGenerator(
			{
			sample:sample,
			tuning: { base_frequency:sample.tuning.base_frequency, sample_rate:sample.tuning.sample_rate },	
			loops:loops,
			pan:0.5,
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
		
		for (n in 0...44100) samples.push(Math.sin(n / 44100 * Math.PI * 2));
		
		var sample = SoundSample.ofVector(samples, samples, 44100, 1., "default", MIP_LEVELS);
		sample.loops[0].loop_mode = SoundSample.LOOP_FORWARD;
		
		var loops = new Array<LoopInfo>();
		for (n in sample.loops)
			loops.push(Reflect.copy(n));		
		
		return {		
				sample:sample,
				tuning: { base_frequency:sample.tuning.base_frequency, sample_rate:sample.tuning.sample_rate },
				loops:loops,
				pan:0.5,
				volume:1.0,
				envelope_profiles:[Envelope2.ADSR(function(i:Float) { return i; },0.,0.0,1.0,0.0,[VoiceCommon.AS_VOLUME_ADD])],
				lfos:[{frequency:6.,depth:0.5,delay:0.05,attack:0.05,assigns:[VoiceCommon.AS_PITCH_ADD]}],
				modulation_lfo:1.0,
				arpeggiation_rate:0.0,
				filter_mode:VoiceCommon.FILTER_OFF,
				cutoff_frequency:0.,
				resonance_level:0.,
				name:"default"
			};
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
			var sample : SoundSample = patch.sample;
			var buffer = common.buffer;
			
			var sampleset : Array<RawSample> = sample.mip_levels;
			var sample_rate = patch.tuning.sample_rate;
			var base_frequency = patch.tuning.base_frequency;
			
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
			if (!sample.stereo) sample_right = sample_left;
			
			// we are assuming the sample rate is the mono rate.
			
			var base_wl = sample_rate / base_frequency;
			if (wl < 1) wl = 1;
			var inc_samples : Float = base_wl / wl;
			
			switch(patch.loops[0].loop_mode)
			{
				// FIXME: Find samples that test sustain so that it can be implemented properly
				case LOOP_FORWARD, LOOP_BACKWARD, SUSTAIN_FORWARD, SUSTAIN_BACKWARD, LOOP_PINGPONG, SUSTAIN_PINGPONG: 
					runLoop(cur_follower, buffer, inc_samples, left, right, sample_left, sample_right, rate_mult, write);
				case ONE_SHOT, NO_LOOP:
					runUnlooped(cur_follower, buffer, inc_samples, left, right, sample_left, sample_right, write);
			}
			
			// kill the voice quickly when the settings allow it
			if (cur_follower.loop_pos > sample_left.length+inc_samples && 
				(patch.loops[0].loop_mode == ONE_SHOT || cur_follower.env[0].releasing()))
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
				if (patch.loops[0].loop_mode == ONE_SHOT && cur_follower.loop_pos < 1.)
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
		
		var patch : SamplerPatch = cur_follower.patch_event.patch;
		var sample : SoundSample = patch.sample;
		
		var loop_start : Float = (patch.loops[0].loop_start * rate_mult);
		var loop_end : Float = (patch.loops[0].loop_end * rate_mult);
		var loop_len : Float = (loop_end - loop_start) + 1;
		
		var loop_mode = patch.loops[0].loop_mode;
		
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
		var loop_end : Int = sample_left.length - 1 - SampleMipMap.PAD_INTERP;
		
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
		
		var len = (sample_left.length - SampleMipMap.PAD_INTERP);
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
						CopyLoop.copyLoop(1, "mirror", [], "loop");
					else if (common.filter_mode == VoiceCommon.FILTER_LP)
						CopyLoop.copyLoop(1, "mirror", ["lowpass_filter"], "loop");
					else if (common.filter_mode == VoiceCommon.FILTER_HP)
						CopyLoop.copyLoop(1, "mirror", ["highpass_filter"], "loop");
					else if (common.filter_mode == VoiceCommon.FILTER_BP)
						CopyLoop.copyLoop(1, "mirror", ["bandpass_filter"], "loop");
					else if (common.filter_mode == VoiceCommon.FILTER_BR)
						CopyLoop.copyLoop(1, "mirror", ["bandreject_filter"], "loop");
				}
				else if (resample_method == RESAMPLE_CUBIC) // cubic mono
				{
					if (common.filter_mode == VoiceCommon.FILTER_OFF)
						CopyLoop.copyLoop(4, "mirror", ["Interpolator.interp_cubic"], "loop");
					else if (common.filter_mode == VoiceCommon.FILTER_LP)
						CopyLoop.copyLoop(4, "mirror", ["lowpass_filter","Interpolator.interp_cubic"], "loop");
					else if (common.filter_mode == VoiceCommon.FILTER_HP)
						CopyLoop.copyLoop(4, "mirror", ["highpass_filter","Interpolator.interp_cubic"], "loop");
					else if (common.filter_mode == VoiceCommon.FILTER_BP)
						CopyLoop.copyLoop(4, "mirror", ["bandpass_filter","Interpolator.interp_cubic"], "loop");
					else if (common.filter_mode == VoiceCommon.FILTER_BR)
						CopyLoop.copyLoop(4, "mirror", ["bandreject_filter","Interpolator.interp_cubic"], "loop");
				}
				else // linear mono
				{
					if (common.filter_mode == VoiceCommon.FILTER_OFF)
						CopyLoop.copyLoop(2, "mirror", ["Interpolator.interp_linear"], "loop");
					else if (common.filter_mode == VoiceCommon.FILTER_LP)
						CopyLoop.copyLoop(2, "mirror", ["lowpass_filter","Interpolator.interp_linear"], "loop");
					else if (common.filter_mode == VoiceCommon.FILTER_HP)
						CopyLoop.copyLoop(2, "mirror", ["highpass_filter","Interpolator.interp_linear"], "loop");
					else if (common.filter_mode == VoiceCommon.FILTER_BP)
						CopyLoop.copyLoop(2, "mirror", ["bandpass_filter","Interpolator.interp_linear"], "loop");
					else if (common.filter_mode == VoiceCommon.FILTER_BR)
						CopyLoop.copyLoop(2, "mirror", ["bandreject_filter","Interpolator.interp_linear"], "loop");
				}
			}
			else
			{
				if (inc == 1. || resample_method == RESAMPLE_DROP) // drop stereo
				{
					if (common.filter_mode == VoiceCommon.FILTER_OFF)
						CopyLoop.copyLoop(1, "split", [], "loop");
					else if (common.filter_mode == VoiceCommon.FILTER_LP)
						CopyLoop.copyLoop(1, "split", ["lowpass_filter"], "loop");
					else if (common.filter_mode == VoiceCommon.FILTER_HP)
						CopyLoop.copyLoop(1, "split", ["highpass_filter"], "loop");
					else if (common.filter_mode == VoiceCommon.FILTER_BP)
						CopyLoop.copyLoop(1, "split", ["bandpass_filter"], "loop");
					else if (common.filter_mode == VoiceCommon.FILTER_BR)
						CopyLoop.copyLoop(1, "split", ["bandreject_filter"], "loop");
				}
				else if (resample_method == RESAMPLE_CUBIC) // cubic stereo
				{
					if (common.filter_mode == VoiceCommon.FILTER_OFF)
						CopyLoop.copyLoop(4, "split", ["Interpolator.interp_cubic"], "loop");
					else if (common.filter_mode == VoiceCommon.FILTER_LP)
						CopyLoop.copyLoop(4, "split", ["lowpass_filter","Interpolator.interp_cubic"], "loop");
					else if (common.filter_mode == VoiceCommon.FILTER_HP)
						CopyLoop.copyLoop(4, "split", ["highpass_filter","Interpolator.interp_cubic"], "loop");
					else if (common.filter_mode == VoiceCommon.FILTER_BP)
						CopyLoop.copyLoop(4, "split", ["bandpass_filter","Interpolator.interp_cubic"], "loop");
					else if (common.filter_mode == VoiceCommon.FILTER_BR)
						CopyLoop.copyLoop(4, "split", ["bandreject_filter","Interpolator.interp_cubic"], "loop");
				}
				else // linear stereo
				{
					if (common.filter_mode == VoiceCommon.FILTER_OFF)
						CopyLoop.copyLoop(2, "split", ["Interpolator.interp_linear"], "loop");
					else if (common.filter_mode == VoiceCommon.FILTER_LP)
						CopyLoop.copyLoop(2, "split", ["lowpass_filter","Interpolator.interp_linear"], "loop");
					else if (common.filter_mode == VoiceCommon.FILTER_HP)
						CopyLoop.copyLoop(2, "split", ["highpass_filter","Interpolator.interp_linear"], "loop");
					else if (common.filter_mode == VoiceCommon.FILTER_BP)
						CopyLoop.copyLoop(2, "split", ["bandpass_filter","Interpolator.interp_linear"], "loop");
					else if (common.filter_mode == VoiceCommon.FILTER_BR)
						CopyLoop.copyLoop(2, "split", ["bandreject_filter","Interpolator.interp_linear"], "loop");
				}
			}
			return pos;
		}
	}
	
	private inline function runSegment2(buffer : FastFloatBuffer, 
		pos : Float, inc : Float, left : Float, right : Float, 
		sample_left : FastFloatBuffer, sample_right : FastFloatBuffer, 
		samples_requested : Int, write : Bool)
	{
		// As runSegment, but allows bleedover (for the "pre" loop segment)
		
		var len = (sample_left.length - SampleMipMap.PAD_INTERP);
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
						CopyLoop.copyLoop(1, "mirror", [], "cut");
					else if (common.filter_mode == VoiceCommon.FILTER_LP)
						CopyLoop.copyLoop(1, "mirror", ["lowpass_filter"], "cut");
					else if (common.filter_mode == VoiceCommon.FILTER_HP)
						CopyLoop.copyLoop(1, "mirror", ["highpass_filter"], "cut");
					else if (common.filter_mode == VoiceCommon.FILTER_BP)
						CopyLoop.copyLoop(1, "mirror", ["bandpass_filter"], "cut");
					else if (common.filter_mode == VoiceCommon.FILTER_BR)
						CopyLoop.copyLoop(1, "mirror", ["bandreject_filter"], "cut");
				}
				else if (resample_method == RESAMPLE_CUBIC) // cubic mono
				{
					if (common.filter_mode == VoiceCommon.FILTER_OFF)
						CopyLoop.copyLoop(4, "mirror", ["Interpolator.interp_cubic"], "cut");
					else if (common.filter_mode == VoiceCommon.FILTER_LP)
						CopyLoop.copyLoop(4, "mirror", ["lowpass_filter","Interpolator.interp_cubic"], "cut");
					else if (common.filter_mode == VoiceCommon.FILTER_HP)
						CopyLoop.copyLoop(4, "mirror", ["highpass_filter","Interpolator.interp_cubic"], "cut");
					else if (common.filter_mode == VoiceCommon.FILTER_BP)
						CopyLoop.copyLoop(4, "mirror", ["bandpass_filter","Interpolator.interp_cubic"], "cut");
					else if (common.filter_mode == VoiceCommon.FILTER_BR)
						CopyLoop.copyLoop(4, "mirror", ["bandreject_filter","Interpolator.interp_cubic"], "cut");
				}
				else // linear mono
				{
					if (common.filter_mode == VoiceCommon.FILTER_OFF)
						CopyLoop.copyLoop(2, "mirror", ["Interpolator.interp_linear"], "cut");
					else if (common.filter_mode == VoiceCommon.FILTER_LP)
						CopyLoop.copyLoop(2, "mirror", ["lowpass_filter","Interpolator.interp_linear"], "cut");
					else if (common.filter_mode == VoiceCommon.FILTER_HP)
						CopyLoop.copyLoop(2, "mirror", ["highpass_filter","Interpolator.interp_linear"], "cut");
					else if (common.filter_mode == VoiceCommon.FILTER_BP)
						CopyLoop.copyLoop(2, "mirror", ["bandpass_filter","Interpolator.interp_linear"], "cut");
					else if (common.filter_mode == VoiceCommon.FILTER_BR)
						CopyLoop.copyLoop(2, "mirror", ["bandreject_filter","Interpolator.interp_linear"], "cut");
				}
			}
			else
			{
				if (inc == 1. || resample_method == RESAMPLE_DROP) // drop stereo
				{
					if (common.filter_mode == VoiceCommon.FILTER_OFF)
						CopyLoop.copyLoop(1, "split", [], "cut");
					else if (common.filter_mode == VoiceCommon.FILTER_LP)
						CopyLoop.copyLoop(1, "split", ["lowpass_filter"], "cut");
					else if (common.filter_mode == VoiceCommon.FILTER_HP)
						CopyLoop.copyLoop(1, "split", ["highpass_filter"], "cut");
					else if (common.filter_mode == VoiceCommon.FILTER_BP)
						CopyLoop.copyLoop(1, "split", ["bandpass_filter"], "cut");
					else if (common.filter_mode == VoiceCommon.FILTER_BR)
						CopyLoop.copyLoop(1, "split", ["bandreject_filter"], "cut");
				}
				else if (resample_method == RESAMPLE_CUBIC) // cubic stereo
				{
					if (common.filter_mode == VoiceCommon.FILTER_OFF)
						CopyLoop.copyLoop(4, "split", ["Interpolator.interp_cubic"], "cut");
					else if (common.filter_mode == VoiceCommon.FILTER_LP)
						CopyLoop.copyLoop(4, "split", ["lowpass_filter","Interpolator.interp_cubic"], "cut");
					else if (common.filter_mode == VoiceCommon.FILTER_HP)
						CopyLoop.copyLoop(4, "split", ["highpass_filter","Interpolator.interp_cubic"], "cut");
					else if (common.filter_mode == VoiceCommon.FILTER_BP)
						CopyLoop.copyLoop(4, "split", ["bandpass_filter","Interpolator.interp_cubic"], "cut");
					else if (common.filter_mode == VoiceCommon.FILTER_BR)
						CopyLoop.copyLoop(4, "split", ["bandreject_filter","Interpolator.interp_cubic"], "cut");
				}
				else // linear stereo
				{
					if (common.filter_mode == VoiceCommon.FILTER_OFF)
						CopyLoop.copyLoop(2, "split", ["Interpolator.interp_linear"], "cut");
					else if (common.filter_mode == VoiceCommon.FILTER_LP)
						CopyLoop.copyLoop(2, "split", ["lowpass_filter","Interpolator.interp_linear"], "cut");
					else if (common.filter_mode == VoiceCommon.FILTER_HP)
						CopyLoop.copyLoop(2, "split", ["highpass_filter","Interpolator.interp_linear"], "cut");
					else if (common.filter_mode == VoiceCommon.FILTER_BP)
						CopyLoop.copyLoop(2, "split", ["bandpass_filter","Interpolator.interp_linear"], "cut");
					else if (common.filter_mode == VoiceCommon.FILTER_BR)
						CopyLoop.copyLoop(2, "split", ["bandreject_filter","Interpolator.interp_linear"], "cut");
				}
			}
			return pos;
		}
	}
	
	public inline function lowpass_filter(a : Float) { return common.filter.getLP(a); }
	public inline function highpass_filter(a : Float) { return common.filter.getHP(a); }
	public inline function bandpass_filter(a : Float) { return common.filter.getBP(a); }
	public inline function bandreject_filter(a : Float) { return common.filter.getBR(a); }
	
}
