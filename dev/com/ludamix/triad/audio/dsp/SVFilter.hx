package com.ludamix.triad.audio.dsp;

/*
  
	State-variable filter design derived from the ZynAddSubFX SVFilter.
	This filter asks for interpolation when swept quickly; 
	For triad's implementation, we can have VoiceCommon simply slow down the sweep rate.

*/
class SVFilter
{

	public static inline var MAX_FILTER_STAGES = 5;
	public static inline var MAX_RATE = 2.5;
	
	public var low1 : Float; 
	public var low2 : Float;
	public var low3 : Float;
	public var low4 : Float;
	public var low5 : Float;

	public var high1 : Float; 
	public var high2 : Float;
	public var high3 : Float;
	public var high4 : Float;
	public var high5 : Float;
	
	public var band1 : Float; 
	public var band2 : Float;
	public var band3 : Float;
	public var band4 : Float;
	public var band5 : Float;
	
	public var notch1 : Float; 
	public var notch2 : Float;
	public var notch3 : Float;
	public var notch4 : Float;
	public var notch5 : Float;
	
	public var par_f : Float;
	public var par_q : Float;
	public var par_q_sqrt : Float;
	
	public var freq : Float;
	public var freq_to : Float;
	public var q : Float;
	public var gain : Float;
	
	public var samplerate : Int;
	
	private var ring_cutoff : Float;
	private var ring_offset : Float;
	
	public inline function getRap()
	{
		var rap = freq / freq_to;
		if(rap < 1.0)
			rap = 1.0 / rap;
		return rap;
	}
	
	public inline function aboveNyquist()
	{
		var nq : Float = (samplerate * 0.5) - 500.0;
		return (freq > nq || freq_to > nq);
	}
	
	public inline function needsInterpolation()
	{
		return getRap() > MAX_RATE || aboveNyquist();
	}
	
	public function new(frequency : Float, resonance : Float, samplerate : Int)
	{
		this.ring_offset = 0.;
		this.samplerate = samplerate;
		cleanup();
		set(frequency, resonance);
	}

	public function cleanup()
	{
		low1 = 0.;
		low2 = 0.;
		low3 = 0.;
		low4 = 0.;
		low5 = 0.;
		high1 = 0.;
		high2 = 0.;
		high3 = 0.;
		high4 = 0.;
		high5 = 0.;
		band1 = 0.;
		band2 = 0.;
		band3 = 0.;
		band4 = 0.;
		band5 = 0.;
		notch1 = 0.;
		notch2 = 0.;
		notch3 = 0.;
		notch4 = 0.;
		notch5 = 0.;
	}

	public function calcCoefficients()
	{
		par_f = freq / samplerate * 4.0;
		if(par_f > 0.99999)
			par_f = 0.99999;
		par_q      = 1.0 - Math.atan(Math.sqrt(q)) * 2.0 / Math.PI;
		par_q      = Math.pow(par_q, 1.0 / (MAX_FILTER_STAGES + 1));
		par_q_sqrt = Math.sqrt(par_q);
		
		this.ring_cutoff = (freq_to * Math.PI * 2) / (this.samplerate);
		
		antiDenormal();
	}

	public function setFrequency(frequency : Float)
	{
		if(frequency < 0.1)
			frequency = 0.1;
		
		if (frequency != this.freq)
		{
			if (needsInterpolation())
				freq = freq * MAX_RATE;
			else
				freq = frequency;
			freq_to = frequency;
			
			calcCoefficients();
		}	
	}

	public function setResonance(resonance : Float)
	{
		this.q = resonance;
		calcCoefficients();
	}
	
	public function set(frequency : Float, resonance : Float)
	{
		this.q = resonance;
		setFrequency(frequency);
	}

	public inline function update1(i : Float)
	{
		low1 = low1 + par_f * band1;
		high1 = par_q_sqrt * i - low1 - par_q * band1;
		band1 = par_f * high1 + band1;
		notch1 = high1 + low1;
	}
		
	public inline function update2(i : Float)
	{
		low2 = low2 + par_f * band2;
		high2 = par_q_sqrt * i - low2 - par_q * band2;
		band2 = par_f * high2 + band2;
		notch2 = high2 + low2;
	}
		
	public inline function update3(i : Float)
	{
		low3 = low3 + par_f * band3;
		high3 = par_q_sqrt * i - low3 - par_q * band3;
		band3 = par_f * high3 + band3;
		notch3 = high3 + low3;
	}
		
	public inline function update4(i : Float)
	{
		low4 = low4 + par_f * band4;
		high4 = par_q_sqrt * i - low4 - par_q * band4;
		band4 = par_f * high4 + band4;
		notch4 = high4 + low4;
	}
		
	public inline function update5(i : Float)
	{
		low5 = low5 + par_f * band5;
		high5 = par_q_sqrt * i - low5 - par_q * band5;
		band5 = par_f * high5 + band5;
		notch5 = high5 + low5;
		
	}

	public inline function getLP(smp : Float) 
	{ 
		update1(smp); smp = low1;  
		update2(smp); smp = low2;
		update3(smp); smp = low3;
		update4(smp); smp = low4;
		update5(smp); return low5; 
	}
	
	public inline function getHP(smp : Float)
	{ 
		update1(smp); smp = high1;
		update2(smp); smp = high2;
		update3(smp); smp = high3;
		update4(smp); smp = high4;
		update5(smp); return high5; 
	}
	
	public inline function getBP(smp : Float)
	{ 
		update1(smp); smp = band1;
		update2(smp); smp = band2;
		update3(smp); smp = band3;
		update4(smp); smp = band4;
		update5(smp); return band5; 
	}
	
	public inline function getBR(smp : Float)
	{ 
		update1(smp); smp = notch1;
		update2(smp); smp = notch2;
		update3(smp); smp = notch3;
		update4(smp); smp = notch4;
		update5(smp); return notch5; 
	}
	
	public inline function getRingMod(input : Float)
	{
		this.ring_offset += this.ring_cutoff;
		return input * Math.sin(this.ring_offset);
	}
	
	public inline function antiDenormal()
	{
		if (Math.abs(this.band1) < 0.0000001) 
		{
			this.band1 = 0.;
			this.band2 = 0.;
			this.band3 = 0.;
			this.band4 = 0.;
			this.band5 = 0.;
		}
	}
	
}
