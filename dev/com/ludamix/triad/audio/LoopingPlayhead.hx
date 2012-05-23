package com.ludamix.triad.audio;

class LoopingPlayhead
{
	
	public var pos : Float;
	public var rate : Float;
	public var wl : Int;
	
	public var run_start : Float;
	public var run_full : Int;
	public var run_last : Float;
	
	public function new(?wl = 44100)
	{
		pos = 0.;
		this.wl = wl;
		rate = 1/wl;
	}
	
	public inline function getSamplePos()
	{ return Std.int(pos * wl); }
	
	public inline function setSamplePos(p : Int) { pos = p / wl; }
	
	public inline function advance()
	{ pos = (pos + rate) % 1.; }
	
	public inline function advanceUnbounded()
	{ pos = pos + rate; }
	
	public inline function window()
	{ pos = pos % 1; }
	
	public inline function getRunsOfPct(pct : Float)
	{  
		if (pct + pos < 1.) { run_start = pct; run_full = 0; run_last = 0.; }
		else
		{
			run_start = 1. - pos;
			pct -= run_start;
			run_last = pct % 1.;
			pct -= run_last;
			run_full = Math.round(pct);
		}
	}
	
	public inline function getRunsOfSamples(samples : Int)
	{ getRunsOfPct(samples / wl); }
	
}