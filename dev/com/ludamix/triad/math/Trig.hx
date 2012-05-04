package com.ludamix.triad.math;

import com.ludamix.triad.geom.IPoint;
import com.ludamix.triad.geom.SubIPoint;
import flash.geom.Point;
import nme.geom.Point;

class Trig
{
	
	public static inline function xRadian(rad : Float) {return Math.cos(rad);}
	public static inline function yRadian(rad : Float) {return Math.sin(rad);}
	
	public static inline function xDegree(deg : Float) {return Math.cos(deg2rad(deg));}
	public static inline function yDegree(deg : Float) { return Math.sin(deg2rad(deg)); }
	
	public static inline function deg2rad(ang : Float) { return ang * 0.0174532925; }
	public static inline function rad2deg(ang : Float) { return ang * 57.2957795; }

	public static inline function nearestCardinal(deg : Float) : Float
	{
		while (deg < 0) deg += 360;
		deg = deg % 360;
		if (deg<=45 || deg > 360-45)
			return 0.;
		else if (deg<=90+45 || deg > 90-45)
			return 90.;
		else if (deg<=180+45 || deg > 180-45)
			return 180.;
		else
			return 270.;
	}
	
	public static inline function vec2rad(x : Float, y : Float) : Float
	{
		return Math.atan2(y, x);
	}
	
	public static inline function polarPoint(p : Point)
	{
		return { ang : vec2rad(p.x, p.y), dist : com.ludamix.triad.tools.MathTools.dist(0., 0., p.x, p.y) };
	}
	
	public static inline function polarIPoint(p : IPoint)
	{
		return { ang : vec2rad(p.x, p.y), dist : com.ludamix.triad.tools.MathTools.dist(0., 0., p.x, p.y) };
	}
	
	public static inline function polarSubIPoint(p : SubIPoint)
	{
		return { ang : vec2rad(p.x, p.y), dist : com.ludamix.triad.tools.MathTools.dist(0., 0., p.xf(), p.yf()) };
	}
	
	public static inline function pointOfPolar(p : { ang:Float, dist:Float } ) : Point
	{
		return new Point(xRadian(p.ang) * p.dist, yRadian(p.ang) * p.dist);
	}
	
	public static inline function iPointOfPolar(p : { ang:Float, dist:Float } ) : IPoint
	{
		return new IPoint(Std.int(xRadian(p.ang) * p.dist), Std.int(yRadian(p.ang) * p.dist));
	}

	public static inline function subIPointOfPolar(p : { ang:Float, dist:Float } ) : SubIPoint
	{
		return SubIPoint.fromFloat(xRadian(p.ang) * p.dist, yRadian(p.ang) * p.dist);
	}

}