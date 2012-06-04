package com.ludamix.triad.audio;

class SynthTools
{
	
	public static inline var CURVE_LINEAR = 0;
	public static inline var CURVE_SQR = 1;
	public static inline var CURVE_CUBE = 2;
	public static inline var CURVE_POW = 3;

	public static inline function curve(value : Float, mapping : Int)
	{
		switch(mapping)
		{
			case CURVE_LINEAR:
				return value;
			case CURVE_SQR:
				return value * value;
			case CURVE_CUBE:
				return value * value * value;
			case CURVE_POW:
				return Math.pow(value, 1.0 - value);
			default:
				return value;
		}
	}
	
	// sustainToRelease governs whether we expect to multiply against release level, or fade from the sustain level
	
	public static inline function interpretADSR(secondsToFrames : Float->Float, a : Float, d : Float, s : Float, r : Float,
		a_curve : Int, d_curve : Int, r_curve : Int, ?sustainToRelease = false) : 
			{attack:Array<Float>,release:Array<Float>,sustain:Array<Float>}
	{
		var af = Math.ceil(secondsToFrames(a));
		var df = Math.ceil(secondsToFrames(d));
		var rf = Math.ceil(secondsToFrames(r));
		
		if (af == 0) af = 1;
		if (df == 0) df = 1;
		if (rf == 0) rf = 1;
		
		var attack_envelope = new Array<Float>();
		for (n in 0...af)
			attack_envelope.push(curve(com.ludamix.triad.tools.MathTools.rescale(0,af,0.,1.0,n),a_curve));
		for (n in 0...df)
			attack_envelope.push(curve(com.ludamix.triad.tools.MathTools.rescale(0,df,s,1.0,df-n),d_curve));
		var sustain_envelope = [s];
		var release_envelope = new Array<Float>();
		if (sustainToRelease)
		{
			for (n in 0...rf)
				release_envelope.push(curve(com.ludamix.triad.tools.MathTools.rescale(0, rf, 0., s, rf - n),r_curve));
		}
		else
		{
			for (n in 0...rf)
				release_envelope.push(curve(com.ludamix.triad.tools.MathTools.rescale(0, rf, 0., 1.0, rf - n), r_curve));
		}
		
		return {attack:attack_envelope,sustain:sustain_envelope,release:release_envelope};
	}	
	
	public static inline function interpretDSAHDSHR(secondsToFrames : Float->Float, delay : Float, start : Float, 
		a : Float, hold_attack : Float, 
		decay : Float,  s : Float, hold_release : Float, r : Float, a_curve : Int, d_curve : Int, r_curve : Int,
		?sustainToRelease = false,?multiplier:Float=1.0) : {attack:Array<Float>,release:Array<Float>,sustain:Array<Float>}
	{
		var delayf = Math.ceil(secondsToFrames(delay));
		var af = Math.ceil(secondsToFrames(a));
		var hold_af = Math.ceil(secondsToFrames(hold_attack));
		var hold_rf = Math.ceil(secondsToFrames(hold_release));
		var decayf = Math.ceil(secondsToFrames(decay));
		var rf = Math.ceil(secondsToFrames(r));
		
		s *= multiplier;
		
		if (af == 0) af = 1;
		if (decayf == 0) decayf = 1;
		if (rf == 0) rf = 1;
		
		var attack_envelope = new Array<Float>();
		for (n in 0...delayf)
			attack_envelope.push(0.);
		for (n in 0...af)
			attack_envelope.push(curve(com.ludamix.triad.tools.MathTools.rescale(0, af, start, multiplier, n), a_curve));
		for (n in 0...hold_af)
			attack_envelope.push(multiplier);
		for (n in 0...decayf)
			attack_envelope.push(curve(com.ludamix.triad.tools.MathTools.rescale(0, decayf, s, multiplier, decayf - n), d_curve));
		
		var sustain_envelope = [s];
		var release_envelope = new Array<Float>();
		if (sustainToRelease)
		{
			for (n in 0...hold_rf)
				release_envelope.push(s);
			for (n in 0...rf)
				release_envelope.push(curve(com.ludamix.triad.tools.MathTools.rescale(0, rf, 0., s, rf - n),r_curve));
		}
		else
		{
			for (n in 0...hold_rf)
				release_envelope.push(multiplier);
			for (n in 0...rf)
				release_envelope.push(curve(com.ludamix.triad.tools.MathTools.rescale(0, rf, 0., multiplier, rf - n), r_curve));
		}
		
		return {attack:attack_envelope,sustain:sustain_envelope,release:release_envelope};
	}
	
}