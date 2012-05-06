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
	
}