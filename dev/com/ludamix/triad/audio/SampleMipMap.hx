package com.ludamix.triad.audio;

import com.ludamix.triad.audio.dsp.SVFilter;
import nme.Vector;
import com.ludamix.triad.audio.SoundSample;
import com.ludamix.triad.tools.FastFloatBuffer;
import nme.Vector;

typedef MipData = {
	left:Vector<Float>,
	right:Vector<Float>,
	rate_multiplier: Float
};

class SampleMipMap
{

	// FIXME: The lowest mip level should also get filtered if the samplerate is above the target sequencer rate.

	public static inline var PAD_INTERP = 3; // pad each sample for interpolation purposes
											 // use 1 for linear, 3 for cubic

	private static function _mip2_hermite6(sample : Vector<Float>, pow2:Int, rate:Int) : Vector<Float>
	{
		var iir = new SVFilter(rate / pow2, 0., rate);
		
		var filtered = new Vector<Float>();
		for (s in sample)
			filtered.push(iir.getLP(s));
		
		// six point hermite spline interpolator
		var true_len = (filtered.length - PAD_INTERP) >> pow2;
		var out = new Vector<Float>();
		var y0 = 0.;
		var y1 = 0.;
		var y2 = 0.;
		var y3 = 0.;
		var y4 = 0.;
		var y5 = 0.;
		var sl = Std.int(filtered.length);
		for (i in 0...true_len)
		{
			var ip2 = i << pow2;
			if ((ip2) < sl-6)
			{
				y0 = filtered[(ip2)];
				y1 = filtered[((ip2) + 1)];
				y2 = filtered[((ip2) + 2)];
				y3 = filtered[((ip2) + 3)];
				y4 = filtered[((ip2) + 4)];
				y5 = filtered[((ip2) + 5)];
			}
			else
			{
				y0 = filtered[(ip2) % sl];
				y1 = filtered[((ip2) + 1) % sl];
				y2 = filtered[((ip2) + 2) % sl];
				y3 = filtered[((ip2) + 3) % sl];
				y4 = filtered[((ip2) + 4) % sl];
				y5 = filtered[((ip2) + 5) % sl];
			}
			out.push(Interpolator.interp_hermite6p(y0,y1,y2,y3,y4,y5,0.));
		}
		for (i in 0...PAD_INTERP)
			out.push(0.);
		return out;
	}
	
	public static function mippow2(mip_in : MipData, pow2 : Int, rate): MipData
	{
		var result_l = mip_in.left;
		var result_r = mip_in.right;
		
		result_l = _mip2_hermite6(result_l,pow2,rate);
		if (mip_in.left == mip_in.right)
			result_r = result_l;
		else result_r = _mip2_hermite6(result_r,pow2,rate);
		
		return { left:result_l, right:result_r, rate_multiplier:mip_in.rate_multiplier/(1<<pow2)};
	}

	public static function genMips(
		left : Vector<Float>, 
		right : Vector<Float>, 
		mip_levels : Int,
		rate : Int) : Array<MipData>
	{
		var mips = new Array<MipData>();
		mips.push( { left:left, right:right, rate_multiplier:1. } );
		for (n in 0...PAD_INTERP)
			{ left.push(0.); right.push(0.); }
		for (n in 0...mip_levels)
			mips.push(mippow2(mips[0],n+1,rate));
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
	
}