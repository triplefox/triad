package com.ludamix.triad.geom;
import nme.geom.Point;

class IPoint
{
	
	public var x : Int;
	public var y : Int;
	
	public function new(x=0,y=0)
	{
		this.x = x;
		this.y = y;
	}
	
	public inline function clone()
	{
		return new IPoint(x,y);
	}
	
	public inline function add(p : IPoint)
	{
		x += p.x;
		y += p.y;
	}
	
	public inline function sub(p : IPoint)
	{
		x -= p.x;
		y -= p.y;
	}
	
	public inline function mul(p : IPoint)
	{
		x *= p.x;
		y *= p.y;
	}
	
	public inline function div(p : IPoint)
	{
		x = Std.int(x/p.x);
		y = Std.int(y/p.y);
	}
	
	public inline function eqX(p : IPoint)
	{
		return this.x == p.x;
	}
	
	public inline function eqY(p : IPoint)
	{
		return this.y == p.y;
	}
	
	public inline function eq(p : IPoint)
	{
		return eqX(p) && eqY(p);
	}
	
	public inline function genSubIPoint() { return new SubIPoint(SubIPoint.shift(x),SubIPoint.shift(y)); }
	public inline function genFPoint() { return new Point(x,y); }
	
}
