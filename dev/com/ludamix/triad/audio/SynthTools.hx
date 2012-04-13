package com.ludamix.triad.audio;

class SynthTools
{
	
	public static inline var CURVE_LINEAR = 0;
	public static inline var CURVE_SQR = 1;
	public static inline var CURVE_POW = 2;

	public static inline function curve(value : Float, mapping : Int)
	{
		switch(mapping)
		{
			case CURVE_LINEAR:
				return value;
			case CURVE_SQR:
				return value * value;
			case CURVE_POW:
				return Math.pow(value, 1.0 - value);
			default:
				return value;
		}
	}
		
	public static inline function interpretADSR(sequencer : Sequencer, a : Float, d : Float, s : Float, r : Float,
		a_curve : Int, d_curve : Int, r_curve : Int)
	{
		var af = Math.ceil(sequencer.secondsToFrames(a));
		var df = Math.ceil(sequencer.secondsToFrames(d));
		var rf = Math.ceil(sequencer.secondsToFrames(r));
		
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
		for (n in 0...rf)
			release_envelope.push(curve(com.ludamix.triad.tools.MathTools.rescale(0, rf, 0., s, rf - n),r_curve));
		
		return {attack_envelope:attack_envelope,sustain_envelope:sustain_envelope,release_envelope:release_envelope};
	}	
	
}