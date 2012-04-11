package com.ludamix.triad.audio;

class SynthTools
{
	
	public static inline function interpretADSR(sequencer : Sequencer, a : Float, d : Float, s : Float, r : Float)
	{
		var af = Math.ceil(sequencer.secondsToFrames(a));
		var df = Math.ceil(sequencer.secondsToFrames(d));
		var rf = Math.ceil(sequencer.secondsToFrames(r));
		
		if (af == 0) af = 1;
		if (df == 0) df = 1;
		if (rf == 0) rf = 1;
		
		var attack_envelope = new Array<Float>();
		for (n in 0...af)
			attack_envelope.push(com.ludamix.triad.tools.MathTools.rescale(0,af,0.,1.0,n));
		for (n in 0...df)
			attack_envelope.push(com.ludamix.triad.tools.MathTools.rescale(0,df,s,1.0,df-n));
		var sustain_envelope = [s];
		var release_envelope = new Array<Float>();
		for (n in 0...rf)
			release_envelope.push(com.ludamix.triad.tools.MathTools.rescale(0, rf, 0., s, rf - n));
		
		return {attack_envelope:attack_envelope,sustain_envelope:sustain_envelope,release_envelope:release_envelope};
	}	
	
}