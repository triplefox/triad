package com.ludamix.triad.grid;
import haxe.Serializer;
import haxe.Unserializer;
import nme.Vector;

class IntGrid
{

	public var world : Vector<Int>;
	public var worldW : Int;
	public var worldH : Int;
	
	public var twidth : Float;
	public var theight : Float;
	
	// conversion functions: c<input><output>
	// types are:
	// 1 - one integer referencing array
	// 2 - two integers at tile scale
	// p - point object at tile scale {x:Int,y:Int}
	// t - tile object
	// x - point object at pixel scale {x:Float,y:Float}
	// ff - two floats at pixel scale
	
	// U - unsafe(uses flat array and doesn't bounds-check before conversion)
	
	public inline function c21(x:Int, y:Int) : Int
	{ return y * worldW + x; }
	
	public inline function c1p(idx:Int) : {x : Int, y : Int}
	{ var x = idx % worldW;  return {y : Std.int((idx - x)/worldW), x: x }; }
	
	public inline function c1x(idx:Int) : {x : Float, y : Float}
	{ var p = c1p(idx); return {x:0.+p.x*twidth, y:0.+p.y*theight }; }
	
	public inline function c1t(idx:Int) : Int
	{ return world[idx]; }
	
	public inline function c2tU(x:Int, y:Int) : Int
	{ return world[c21(x,y)]; }
	
	public inline function c2t(x:Int, y:Int) : Int
	{ if (x >= 0 && x < worldW && y>=0 && y<worldH) return world[c21(x, y)]; else return -1;  }
	
	public inline function cp1(p : { x:Int, y:Int } ) : Int
	{ return c21(p.x, p.y); }
	
	public inline function cptU(p : { x:Int, y:Int } ) : Int
	{ return world[cp1(p)]; }
	
	public inline function cpt(p : { x:Int, y:Int } ) : Int
	{ return c2t(p.x, p.y);  }
	
	public inline function cffp(x:Float, y:Float) : { x:Int, y:Int }
	{ return { x:Std.int(x/twidth), y:Std.int(y/theight) }; }
	
	public inline function cxp(p : { x:Float, y:Float } ) : { x:Int, y:Int }
	{ return cffp(p.x,p.y); }
	
	public inline function cpx(p : { x:Int, y:Int } ) : { x:Float, y:Float}
	{ return { x:p.x * twidth, y:p.y * theight }; }
	
	public inline function c2x(x:Int, y:Int) : { x:Float, y:Float}
	{ return { x:0.+x * twidth, y:0.+y * theight }; }
	
	public inline function cff1(x:Float, y:Float) : Int
	{ return c21(Std.int(x/twidth),Std.int(y/theight)); }

	public inline function cx1(p : { x:Float, y:Float } ) : Int
	{ return cff1(p.x,p.y); }

	public inline function cfft(x:Float, y:Float) : Int
	{ return world[cff1(x, y)]; }
	
	public inline function cxt(p : { x:Float, y:Float } ) : Int
	{ return cfft(p.x, p.y); }
	
	public function new(worldw : Int, worldh : Int, twidth : Float, theight : Float, populate : Array<Int>)
	{
		this.twidth = twidth;
		this.theight = theight;
		
		this.worldW = worldw;
		this.worldH = worldh;
		
		world = new Vector();
		var pop = populate.copy();
		
		var ct = 0;
		for (ct in 0...worldH*worldW)
		{
			world.push(pop[ct]);
		}
		
	}
	
	public inline function rotW(x) { return x >= 0 ? x % worldW : x + worldW; }	
	public inline function rotH(y) { return y >= 0 ? y % worldH : y + worldH; }
	
	public function shiftL()
	{
		for (icol in 0...worldW)
		{
			var x = (worldW-1) - icol;
			for (y in 0...worldH)
			{
				copyTo(c2t(rotW(x-1), y),c21(x,y));
			}
		}		
	}
	
	public function shiftR()
	{
		for (x in 0...worldW)
		{
			for (y in 0...worldH)
			{
				copyTo(c2t(rotW(x+1), y), c21(x, y));
			}
		}		
	}
	
	public function shiftU()
	{
		for (y in 0...worldH)
		{
			for (x in 0...worldW)
			{
				copyTo(c2t(x, rotH(y+1)), c21(x, y));
			}
		}		
	}
	
	public function shiftD()
	{
		for (irow in 0...worldH)
		{
			var y = (worldH-1) - irow;
			for (x in 0...worldW)
			{
				copyTo(c2t(x, rotH(y - 1)), c21(x, y));
			}
		}		
	}
	
	public inline function tileInBounds(x : Float, y : Float)
	{
		return (x >= 0 && y >= 0 && x < worldW && y < worldH);
	}
	
	public inline function pixelInBounds(x : Float, y : Float)
	{
		return (x >= 0 && y >= 0 && x < worldW*twidth && y < worldH*theight);
	}
	
	public inline function copyTo(prev: Int, idx : Int) 
	{
		world[idx] = prev;
	}
	
	public inline function s2(x : Int, y : Int, v : Int)
	{
		world[c21(x, y)] = v;
	}
	
	public inline function pxAABBtileAABB(px : Float, py : Float, pw : Float, ph : Float)
	{
		var tp = cffp(px, py);
		var tr = (px+pw) / twidth; var ttw = Math.ceil(tr)-tp.x;
		var tb = (py+ph) / theight; var tth = Math.ceil(tb)-tp.y;
		return {x:tp.x,y:tp.y,w:ttw,h:tth};
	}
	
	function hxSerialize(s : Serializer)
	{
		var world_ar = new Array<Int>();
		for (n in world) world_ar.push(n);
		s.serialize(world_ar);
		s.serialize(worldW);
		s.serialize(worldH);
		s.serialize(twidth);
		s.serialize(theight);
	}
	
	function hxUnserialize(s : Unserializer)
	{
		var world_ar : Array<Int> = s.unserialize();
		worldW = s.unserialize();
		worldH = s.unserialize();
		twidth = s.unserialize();
		theight = s.unserialize();
		world = new Vector();
		for (n in world_ar) world.push(n);
	}
	
}