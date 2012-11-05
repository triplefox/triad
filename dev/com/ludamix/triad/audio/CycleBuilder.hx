package com.ludamix.triad.audio;

import nme.Vector;
import com.ludamix.triad.tools.FastFloatBuffer;
import com.ludamix.triad.audio.SoundSample;

class CycleBuilder
{

	public static var CUTOFF = 1 / 12.; // require at least 12 points to render a sine

	public static function buildWave(wavelengths : Array<Int>, param : Dynamic,
		alg : Dynamic->Int->Int->Float, name : String, result : SoundSample->Void, ?run_length=100)
	{
		// return an array of loops that will slice up the algorithm processing for each wavelength into runs
		// that call "alg" with (param, cycle_offset, cycle_len) : result_sample_at_offset
		
		// 3. display and play generated waves
		//		we want to swap between tablesynth for reference
		// 4. fill out saw, tri, and resonance generators
		
		var queue = new Array<Dynamic>();
		
		var mips = new Array<{vec:Vector<Float>,rate_multiplier:Float}>();
		
		var highest = wavelengths[0];
		for (wl in wavelengths) { if (wl > highest) highest = wl; }
		
		for (wl in wavelengths)
		{
			var cur = { vec:new Vector<Float>(), rate_multiplier:highest/wl };
			mips.push( cur );
			var offset = 0;
			while (offset < wl)
			{
				var run = Std.int(Math.min(run_length, wl - offset));
				var temp_offset = offset;
				queue.push(function(){
					for (n in 0...run)
					{
						cur.vec.push(alg(param, temp_offset+n, wl));
					}
				});
				offset += run;
			}
		}
		queue.push(function() { 
			var final = new SoundSample();
			final.mip_levels = new Array<RawSample>();
			var INTERP_PAD = 8;
			var wl = mips[0].vec.length;
			for (n in mips) 
			{
				for (m in 0...INTERP_PAD)
					n.vec.push(n.vec[m]);
				var ffb = FastFloatBuffer.fromVector(n.vec);
				final.mip_levels.push({sample_left:ffb,sample_right:ffb,rate_multiplier:n.rate_multiplier});
			}
			final.tuning = { sample_rate:wl, base_frequency:1. / wl };
			final.stereo = false;
			final.mono_mode = SoundSample.MONOMODE_BOTH;
			final.loops = [ { loop_mode:SoundSample.LOOP_FORWARD, loop_start:0, loop_end:wl } ];
			final.name = name;
			result(final);
		} );
		
		return queue;
	}
	
	public static inline function resonance(octave : Float, max_octave : Float, q : Float, pluck : Float)
	{
		// very simple "baked" LPF resonance. 
		// With a positive q, each octave becomes progressively more powerful using an exponential curve.
		// With a q between 0 and -1, it rolls off the octave power at the high end instead, adding a filtered feel.		
		// pluck parameter makes each octave fade along a linear function(max pluck ~= max octaves)
		return Math.max(0., 1. + q * Math.pow(octave / max_octave, 5) - pluck * octave / max_octave);
	}
	
	public static function pulseBuilder(param : Dynamic, pos : Int, tablesize : Int) : Float
	{
		// derived from wikipedia entry
		
		// params: pulse_width, octaves, resonance, pluck
		
		var pw : Float = param.pulse_width;
		pw *= tablesize;
		var ofreq = 1. / tablesize;
		var half_pw = pw / 2;
		var result = 0.;
		
		var oo = 1;
		while (oo < param.octaves) 
		{
			var oo_pi = oo * Math.PI;
			var oo_pi_ofreq = oo_pi * ofreq;
			result = result + 2. / (oo_pi) * Math.sin(pw * oo_pi_ofreq) * 
				Math.cos(2 * (pos - half_pw) * oo_pi_ofreq) * resonance(oo, param.octaves, param.resonance, param.pluck);
			oo += 2;
			if (oo * ofreq > CUTOFF) break; // cut off octaves too high to render accurately
		}
		return result * 0.75;
	}
	
	public static function sawBuilder(param : Dynamic, pos : Int, tablesize : Int) : Float
	{
		// derived from wikipedia entry
		
		// params: octaves, resonance, pluck
		
		var result = 0.;
		var sign = -1;
		var ofreq = 1 / tablesize;
		var i = pos / tablesize * Math.PI * 2;
		
		var oo = 1;
		while (oo < param.octaves) 
		{
			result = result + Math.sin(i * oo) * sign / oo * resonance(oo,param.octaves, param.resonance, param.pluck);
			sign = -sign;
			oo++;
			if (oo * ofreq > CUTOFF) break; // cut off octaves too high to render accurately
		}
		return result * 2 / Math.PI * 0.45;
	}
	
	public static function triBuilder(param : Dynamic, pos : Int, tablesize : Int) : Float
	{
		// derived from wikipedia entry
		
		// params: octaves, resonance, pluck
		
		var result = 0.;
		var sign = -1;
		var ofreq = 1. / tablesize;
		var i = pos / tablesize * Math.PI * 2;
		
		var oo = 0;
		
		while (oo < param.octaves) 
		{
			var oodb = (2 * oo + 1);
			result = result + Math.sin(oodb * i) * sign / (oodb * oodb) * 
				resonance(oo, param.octaves, param.resonance, param.pluck);
			sign = -sign;
			oo += 1;
			if (oo * ofreq > CUTOFF) break; // cut off octaves too high to render accurately
		}
		return result * 8/(Math.PI*Math.PI) * 0.59;
	}
	
	public static function bellBuilder(param : Dynamic, pos : Int, tablesize : Int) : Float
	{
		// params: octaves, resonance, pluck
		
		var result = 0.;
		var ofreq = 1 / tablesize;
		var pct = pos / tablesize;
		var i = pct * Math.PI * 2;
		
		var oo : Float = 1.;
		while (oo < param.octaves)
		{
			// composite algorithm:
			// we add semitone harmonics, with a slightly superlinear falloff
			// This means that the resulting cycle isn't cleanly looped at the fundamental.
			// To get around this we do a CZ-style "linear ramp hard-sync" across the result.
			result = result + Math.sin(i * oo) / Math.pow(oo,1.25) * (1. - pct) * 
				resonance(oo, param.octaves, param.resonance, param.pluck);
			oo *= 1.1111111111;
			if (oo * ofreq > CUTOFF) break; // rendering accuracy limit
		}
		return result * 0.125;
	}
	
}