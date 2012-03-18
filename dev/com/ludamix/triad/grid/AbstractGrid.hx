class AbstractGrid<T>
{
	
	public var world : Array<T>;
	public var worldW : Int;
	public var worldH : Int;
	
	// FOR OVERRIDE:
	public function copyTo(prev: T, idx : Int) {}
	
	public var TSIZE : Float;
	
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
	{ var p = c1p(idx); return {x:0.+p.x*TSIZE, y:0.+p.y*TSIZE }; }
	
	public inline function c1t(idx:Int) : Null<T>
	{ return world[idx]; }
	
	public inline function c2tU(x:Int, y:Int) : Null<T>
	{ return world[c21(x,y)]; }
	
	public inline function c2t(x:Int, y:Int) : Null<T>
	{ if (x >= 0 && x < worldW && y>=0 && y<worldH) return world[c21(x, y)]; else return null;  }
	
	public inline function cp1(p : { x:Int, y:Int } ) : Int
	{ return c21(p.x, p.y); }
	
	public inline function cptU(p : { x:Int, y:Int } ) : Null<T>
	{ return world[cp1(p)]; }
	
	public inline function cpt(p : { x:Int, y:Int } ) : Null<T>
	{ return c2t(p.x, p.y);  }
	
	public inline function cffp(x:Float, y:Float) : { x:Int, y:Int }
	{ return { x:Std.int(x/TSIZE), y:Std.int(y/TSIZE) }; }
	
	public inline function cxp(p : { x:Float, y:Float } ) : { x:Int, y:Int }
	{ return cffp(p.x,p.y); }
	
	public inline function cpx(p : { x:Int, y:Int } ) : { x:Float, y:Float}
	{ return { x:p.x * TSIZE, y:p.y * TSIZE }; }
	
	public inline function c2x(x:Int, y:Int) : { x:Float, y:Float}
	{ return { x:0.+x * TSIZE, y:0.+y * TSIZE }; }
	
	public inline function cff1(x:Float, y:Float) : Int
	{ return c21(Std.int(x/TSIZE),Std.int(y/TSIZE)); }

	public inline function cx1(p : { x:Float, y:Float } ) : Int
	{ return cff1(p.x,p.y); }

	public inline function cfft(x:Float, y:Float) : Null<T>
	{ return world[cff1(x, y)]; }
	
	public inline function cxt(p : { x:Float, y:Float } ) : Null<T>
	{ return cfft(p.x, p.y); }
	
	public function new(worldw : Int, worldh : Int, TSIZE : Float, populate : Array<T>)
	{
		this.TSIZE = TSIZE;
		
		this.worldW = worldw;
		this.worldH = worldh;
		
		world = new Array();
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
		return (x >= 0 && y >= 0 && x < worldW*TSIZE && y < worldH*TSIZE);
	}
	
}