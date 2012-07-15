package com.ludamix.triad.math;

import com.ludamix.triad.geom.IPoint;
import com.ludamix.triad.geom.SubIPoint;
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
	
	public static inline function normalizeRad(rad : Float) : Float
	{
		// return range within 0 - 2pi
		while (rad < 0.) rad += Math.PI * 2;
		while (rad > Math.PI * 2) rad -= Math.PI * 2;
		return rad;
	}
	
	public static inline function normalizeRad2(rad : Float) : Float
	{
		// return range within -pi - pi
		return normalizeRad(rad-Math.PI);
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

	public static function perpendicular(a : Point)
	{
		return new nme.geom.Point(a.y, -a.x);
	}
	
	public static function circleLineTriangle(ox : Float, oy : Float, cx : Float, 
		cy : Float, radius : Float) : {a:Point,b:Point,c:Point}
	{
		// given an origin point(ox,oy) and circle(cx,cy,radius)
		// calculates the triangle covering all rays that intersect between the two
		var a = new nme.geom.Point(ox - cx, oy - cy);
		var b = perpendicular(a);
		var dist = MathTools.dist(b.x, b.y, 0., 0.);
		b.x = b.x / dist;
		b.y = b.y / dist;
		var c = new Point(b.x, b.y);
		b.x *= radius; b.x += cx;
		b.y *= radius; b.y += cy;
		c.x *= -radius; c.x += cx;
		c.y *= -radius; c.y += cy;
		return {a:new Point(ox,oy),b:b,c:c};
	}
	
	public static function triangleToArc(tri : { a:Point, b:Point, c:Point } ) : {left:Float,right:Float}
	{
		// given a triangle, return the radian angles of a-b and b-c
		var a = tri.a; var b = tri.b; var c = tri.c;
		var left = Trig.normalizeRad(Trig.vec2rad(b.x - a.x, b.y - a.y));
		var right = Trig.normalizeRad(Trig.vec2rad(c.x - a.x, c.y - a.y));
		if (left<right)
			return { left:left, right:right };
		else
			return { left:right, right:left };
	}

}