package com.ludamix.triad.tools;
import nme.geom.Point;

class MathTools
{
	
	public static inline function wraparound(counter : Int, low : Int, high : Int) : Int
	{
		var dist = high - low;
		while (counter < low)
			counter += dist;
		while (counter >= high)
			counter -= dist;
		return counter;
	}
	
	public static inline function dist(ax : Float, ay : Float, bx : Float, by : Float)
	{
		return Math.sqrt(sqrDist(ax,ay,bx,by));
	}
	
	public static inline function distPt(a : { x : Float, y : Float }, b : { x : Float, y : Float } )
	{
		return dist(a.x,a.y,b.x,b.y);
	}
	
	public static inline function sqrDist(ax : Float, ay : Float, bx : Float, by : Float)
	{
		var x = ax - bx;
		var y = ay - by;
		return (x*x + y*y);		
	}

	public static inline function sqrDistPt(a : { x : Float, y : Float }, b : { x : Float, y : Float } )
	{
		return sqrDist(a.x,a.y,b.x,b.y);
	}
	
	public static inline function fequals(a:Float, b:Float) { return Math.abs(a - b) < 0.000001; }
	
	public static inline function lerp(fromI : Float, toI : Float, pct : Float) : Float { return fromI+(toI-fromI)*pct; }
	
	public static inline function nearestOf(positions:Array<Dynamic>, x:Float, y:Float) : {idx:Int,instance:Dynamic,dist:Float}
	{
		var best = 99999999999999.; // yeah....
		var bestpos = 0;
		for (n in 0...positions.length)
		{
			var pos = positions[n];
			var cur = sqrDist(pos.x, pos.y, x, y);
			if (cur < best)
			{
				best = cur;
				bestpos = n;
			}
		}
		return { idx:bestpos, instance:positions[bestpos], dist:Math.sqrt(best) };
	}
	
	public static inline function limit(min : Float, max : Float, val : Float)
	{
		return Math.max(min, Math.min(max, val));
	}
	
	public static inline function bestOf(vals : Iterable<Dynamic>, makecomparable : Dynamic->Dynamic,
		compare : Dynamic->Dynamic->Bool, start : Dynamic) : Dynamic
	{
		var best = makecomparable(start);
		for (n in vals)
		{
			var test = makecomparable(n);
			if (compare(test, best))
				best = test;
		}
		return best;
	}
	
	public static inline function rescale(amin : Float, amax : Float, bmin : Float, bmax : Float, aval : Float) : Float
	{
		var adist = amax - amin;
		var bdist = bmax - bmin;
		var ratio = bdist / adist;
		return bmin + (aval - amin) * ratio;
	}
		
}