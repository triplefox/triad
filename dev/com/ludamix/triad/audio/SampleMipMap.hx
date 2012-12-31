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

	public static inline var PAD_INTERP = 32; // pad each sample for interpolation purposes

	private static function _mipup_hermite6(sample : Vector<Float>, pow2:Int, rate:Int) : Vector<Float>
	{
		var iir = new SVFilter(rate / pow2, 0., rate);
		
		var filtered = new Vector<Float>();
		for (s in sample)
			filtered.push(iir.getLP(s));
		
		// six point hermite spline interpolator
		var true_len = (filtered.length) >> pow2;
		var out = new Vector<Float>();
		var y0 = 0.; var y1 = 0.; var y2 = 0.; var y3 = 0.; var y4 = 0.; var y5 = 0.;
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
		return out;
	}
	
	public static function mipup(mip_in : MipData, pow2 : Int, rate): MipData
	{
		var result_l = mip_in.left;
		var result_r = mip_in.right;
		
		result_l = _mipup_hermite6(result_l,pow2,rate);
		if (mip_in.left == mip_in.right)
			result_r = result_l;
		else result_r = _mipup_hermite6(result_r,pow2,rate);
		
		return { left:result_l, right:result_r, rate_multiplier:mip_in.rate_multiplier*(1<<pow2)};
	}
	
	public static function _mip_down_hermite6(sample : Vector<Float>, down : Int, rate : Int) : Vector<Float>
	{
		var result = new Vector<Float>();
		var pow2 = 1 << down;
		var iir = new SVFilter(Std.int((rate / 2) * 0.95), 0., rate * pow2);
		
		// Although this method is _very_ close to good enough for mipmapping, 
		// it will still alias enough in usage to detune.
		// I don't recommend using it, or at most 1 octave only.
		
		var out = new Vector<Float>();
		var sl = Std.int(sample.length);
		var y0 = 0.; var y1 = 0.; var y2 = 0.; var y3 = 0.; var y4 = 0.; var y5 = 0.;
		for (s in 0...sl)
		{
			if ((s) < sl-6)
			{
				y0 = sample[(s)];
				y1 = sample[((s) + 1)];
				y2 = sample[((s) + 2)];
				y3 = sample[((s) + 3)];
				y4 = sample[((s) + 4)];
				y5 = sample[((s) + 5)];
			}
			else
			{
				y0 = sample[(s) % sl];
				y1 = sample[((s) + 1) % sl];
				y2 = sample[((s) + 2) % sl];
				y3 = sample[((s) + 3) % sl];
				y4 = sample[((s) + 4) % sl];
				y5 = sample[((s) + 5) % sl];
			}
			for (i in 0...pow2)
			{
				out.push(iir.getLP(Interpolator.interp_hermite6p(y0,y1,y2,y3,y4,y5,i/pow2)));
			}
		}
		
		return out;
	}
	
	public static function mipdown(mip_in : MipData, down : Int, rate):MipData
	{
		var result_l = mip_in.left;
		var result_r = mip_in.right;
		
		result_l = _mip_down_hermite6(result_l,down,rate);
		if (mip_in.left == mip_in.right)
			result_r = result_l;
		else result_r = _mip_down_hermite6(result_r,down,rate);
		
		return { left:result_l, right:result_r, rate_multiplier:mip_in.rate_multiplier/(1<<down)};
	}

	public static function genMips(
		left : Vector<Float>, 
		right : Vector<Float>, 
		mip_up : Int,
		mip_down : Int,
		rate : Int, ?filter_basemip = true) : Array<MipData>
	{
		var mips = new Array<MipData>();
		
		var basemip = { left:left, right:right, rate_multiplier:1. };
		
		for (n in 0...mip_down)
			mips.push(mipdown(basemip, n + 1, rate));
		
		mips.push(basemip);
		
		for (n in 0...mip_up)
			mips.push(mipup(basemip, n + 1, rate));
		
		for (m in mips)
		{
			for (n in 0...PAD_INTERP)
				{ m.left.push(0.); }
			if (m.right != m.left)
			{
				for (n in 0...PAD_INTERP)
					{ m.right.push(0.); }
			}
		}
		
		if (filter_basemip)
		{
			var iir = new SVFilter(rate / 2, 0., rate);
			for (i in 0...basemip.left.length)
				basemip.left[i] = (iir.getLP(basemip.left[i]));
			if (basemip.left != basemip.right)
			{
				for (i in 0...basemip.right.length)
					basemip.right[i] = (iir.getLP(basemip.right[i]));
			}
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