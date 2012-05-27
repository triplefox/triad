package com.ludamix.triad.audio;

typedef Envelope = {
	attack:Array<Float>,
	sustain:Array<Float>,
	release:Array<Float>,
	quantization : Int, // 0 = off, lower values produce "chippier" envelope character
	assigns : Array<Int> // codes for the "meaning" of envelope values
};

class EnvelopeState
{
	
	public var ptr : Int;
	public var state : Int;
	
	public function new()
	{
		ptr = 0;
		state = 0;
	}
	
	public inline function getTable(env : Envelope)
	{
		switch(state)
		{
			case 0: return env.attack;
			case 1: return env.sustain;
			case 2: return env.release;
			default: return null;
		}
	}
	
	public inline function length(env : Envelope) : Int
	{
		switch(state)
		{
			case 0: return env.attack.length;
			case 1: return env.sustain.length;
			case 2: return env.release.length;
			default: return 0;
		}
	}
	
}