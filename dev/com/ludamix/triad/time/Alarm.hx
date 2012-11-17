package com.ludamix.triad.time;

class Alarm
{
	
	public var time : Float;
	public var startTime : Float;
	public var repeat_on_end : Bool;
	public var preserve_remainder : Bool;
	public var cback : Alarm->Dynamic->Void;
	public var cbackEvery : Alarm->Dynamic->Void;
	
	public function new(time : Float, repeat_on_end : Bool, preserve_remainder : Bool,
		cbackEvery : Alarm->Dynamic->Void, cback : Alarm->Dynamic->Void)
	{
		this.time = time;
		this.startTime = time;
		this.repeat_on_end = repeat_on_end;
		this.preserve_remainder = preserve_remainder;
		this.cback = cback;
		this.cbackEvery = cbackEvery;
	}
	
	public function restart()
	{
		time = startTime;
	}
	
	public function repeat()
	{
		if (preserve_remainder)
			time += startTime;
		else
			time = startTime;
	}
	
	public function tick(dT : Float, data : Dynamic)
	{
		if (time > 0)
		{
			time-=dT;
			if (cbackEvery!=null) {cbackEvery(this, data);}
			while (time <= 0)
			{
				if (cback!=null) cback(this, data);
				if (repeat_on_end) repeat();
			}
		}
	}
	
}