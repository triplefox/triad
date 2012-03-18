package com.ludamix.triad.geom;
import nme.geom.Point;

class SubIPoint
{
	
	// a "sub-pixel" point.
	
	public var x : SubPixel;
	public var y : SubPixel;
	
	public static inline var BITS = 8;
	
	public function new(x=0,y=0)
	{
		this.x = x;
		this.y = y;
	}
	
	public function toString() { return Std.string([xf(),yf()]); }
	
	public static inline function fromInt(x:Int, y:Int)
	{
		return new SubIPoint(shift(x), shift(y));
	}
	
	public static inline function fromFloat(x:Float, y:Float)
	{
		return new SubIPoint(shiftF(x), shiftF(y));
	}
	
	public static inline function fromIPoint(ip : IPoint)
	{
		return fromInt(ip.x, ip.y);
	}
	
	public static inline function fromFPoint(fp : Point)
	{
		return fromFloat(fp.x, fp.y);
	}
	
	public inline function xi() { return unshift(x); }
	public inline function yi() { return unshift(y); }
	public inline function xf() { return unshiftF(x); }
	public inline function yf() { return unshiftF(y); }
	
	public inline function clone()
	{
		return new SubIPoint(x,y);
	}
	
	public inline function paste(sp : SubIPoint)
	{
		this.x = sp.x;
		this.y = sp.y;
	}
	
	public inline function add(p : SubIPoint)
	{
		x += p.x;
		y += p.y;
	}
	
	public inline function sub(p : SubIPoint)
	{
		x -= p.x;
		y -= p.y;
	}
	
	public inline function mul(p : SubIPoint)
	{
		x *= p.x;
		y *= p.y;
	}
	
	public inline function div(p : SubIPoint)
	{
		x = Std.int(x/p.x);
		y = Std.int(y/p.y);
	}
	
	public inline function eqX(p : SubIPoint)
	{
		return this.x == p.x;
	}
	
	public inline function eqY(p : SubIPoint)
	{
		return this.y == p.y;
	}
	
	public inline function eq(p : SubIPoint)
	{
		return eqX(p) && eqY(p);
	}
	
	public inline function addI(p : IPoint)
	{
		x += shift(p.x);
		y += shift(p.y);
	}
	
	public inline function subI(p : IPoint)
	{
		x -= shift(p.x);
		y -= shift(p.y);
	}
	
	public inline function mulI(p : IPoint)
	{
		x *= shift(p.x);
		y *= shift(p.y);
	}
	
	public inline function divI(p : IPoint)
	{
		x = Std.int(x/shift(p.x));
		y = Std.int(y/shift(p.y));
	}
	
	public inline function eqXI(p : IPoint)
	{
		return this.x == shift(p.x);
	}
	
	public inline function eqYI(p : IPoint)
	{
		return this.y == shift(p.y);
	}
	
	public inline function eqI(p : IPoint)
	{
		return eqXI(p) && eqYI(p);
	}
	
	public inline function addF(p : Point)
	{
		x += shiftF(p.x);
		y += shiftF(p.y);
	}
	
	public inline function subF(p : Point)
	{
		x -= shiftF(p.x);
		y -= shiftF(p.y);
	}
	
	public inline function mulF(p : Point)
	{
		x *= shiftF(p.x);
		y *= shiftF(p.y);
	}
	
	public inline function divF(p : Point)
	{
		x = Std.int(x/shiftF(p.x));
		y = Std.int(y/shiftF(p.y));
	}
	
	public inline function eqXF(p : Point)
	{
		return this.x == shiftF(p.x);
	}
	
	public inline function eqYF(p : Point)
	{
		return this.y == shiftF(p.y);
	}
	
	public inline function eqF(p : Point)
	{
		return eqXF(p) && eqYF(p);
	}
	
	public inline function genIPoint() { return new IPoint(unshift(x),unshift(y)); }
	public inline function genFPoint() { return new Point(unshiftF(x),unshiftF(y)); }
	
	public static inline function shiftF(val : Float) { return Std.int(val * (1 << BITS)); }
	public static inline function shift(val : Int) { return val << BITS; }
	public static inline function unshift(val : Int) { return val >> BITS; }
	public static inline function unshiftF(val : Int) { return val / (1 << BITS); }
	
}
