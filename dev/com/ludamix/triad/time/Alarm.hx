class Alarm
{
	
	public var time : Int;
	public var startTime : Int;
	public var repeat : Bool;
	public var cback : Alarm->Dynamic->Void;
	public var cbackEvery : Alarm->Dynamic->Void;
	
	public function new(time : Int, repeat : Bool, cbackEvery : Alarm->Dynamic->Void, cback : Alarm->Dynamic->Void)
	{
		this.time = time;
		this.startTime = time;
		this.repeat = repeat;
		this.cback = cback;
		this.cbackEvery = cbackEvery;
	}
	
	public function restart()
	{
		time = startTime;
	}
	
	public function tick(data : Dynamic)
	{
		if (time > 0)
		{
			time--;
			if (cbackEvery!=null) {cbackEvery(this, data);}
			if (time == 0)
			{
				if (cback!=null) cback(this, data);
				if (repeat) restart();
			}
		}
	}
	
}