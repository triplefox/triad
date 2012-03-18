import flash.Lib;

class Clock
{

	public var lT : Int; // lastTime
	public var dT : Float; // deltaTime, smoothed, limited
	public var dTUnlimited : Float; // deltaTime, smoothed
	public var truedT : Int; // deltaTime
	public var dTHistory : List<Int>;
	public var curFPS : Float;

	public var max_timestep : Int;
	
	public static var inst = new Clock();

	public function new(?max_timestep : Int = 30)
	{
		lT = 0;
		dT = 0.;
		truedT = 0;
		this.max_timestep = max_timestep;
		dTHistory = new List();		
	}

	public inline function doTimeStep()
	{
		var cT = Lib.getTimer(); // currentTime
		while (cT<lT) // if we wrap around to negative land, this pushes both cT and lT back into a correct delta. 
		{
			lT+=max_timestep;
			cT+=max_timestep;
		}
		truedT = cT-lT;
		lT = cT;

		dTHistory.add(truedT);
		if (dTHistory.length>4) // this array smooths over the given number of frames, to lower spikiness/jittering
			dTHistory.pop();
		
		dT = 0.;
		for (n in dTHistory)
			dT+=n;
		dT = dT/dTHistory.length;

		dTUnlimited = dT;
		if (dT>max_timestep)
			dT = max_timestep;
		
		curFPS = 1000./dTUnlimited;
		
	}

}
