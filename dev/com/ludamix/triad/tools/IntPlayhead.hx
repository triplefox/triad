package com.ludamix.triad.tools;

class IntPlayhead
{
	
	public var pos : Int;
	public var rate : Int;
	public var wl : Int;
	
	public var run_start : Int;
	public var run_full : Int;
	public var run_last : Int;
	
	public function new(?wl = 44100)
	{
		pos = 0.;
		this.wl = wl;
		rate = 1;
	}
	
	public inline function getPctPos()
	{ return pos / wl; }
	
	public inline function setPctPos(p : Float) { pos = Std.int(p * wl); }
	
	public inline function advance()
	{ pos = (pos + rate) % wl; }
	
	public inline function advanceUnbounded()
	{ pos = pos + rate; }
	
	public inline function window()
	{ pos = pos % wl; }
	
	public inline function getRunsOfSamples(samples : Int)
	{  
		if (pct + pos < wl) { run_start = samples; run_full = 0; run_last = 0; }
		else
		{
			run_start = wl - pos;
			samples -= run_start;
			run_last = samples % wl;
			samples -= run_last;
			run_full = Math.round(samples/wl);
		}
	}
	
	public inline function getRunsOfPct(pct : Float)
	{ getRunsOfSamples(Std.int(pct * wl)); }
	
}