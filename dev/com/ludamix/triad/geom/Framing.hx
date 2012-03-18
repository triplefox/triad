package com.ludamix.triad.geom;

typedef FramingDef = { tlrects:Array<{name:String,x:Float,y:Float,w:Float,h:Float}>,
					   crects:Array<{name:String,x:Float,y:Float,w:Float,h:Float}>,
					   points:Array<{name:String,x:Float,y:Float}>};

class Framing
{
	
	// a semi-static definition of a object with various points and bounds related to an implied center.
	
	public var hotpoints : Hash<SubIPoint>;
	public var rects : Hash<AABB>;
	
	public inline function hotpoint(fp : SubIPoint, name : String) 
	{ 
		var hp = hotpoints.get(name);
		fp.x = hp.x; 
		fp.y = hp.y; 
	}
	
	public inline function rect(aabb : AABB, id : name : String) 
	{ 
		var r = rects.get(name);
		aabb.x = r.x;
		aabb.y = r.y;
		aabb.w = r.w;
		aabb.h = r.h;
	}
	
	public function new()
	{
		this.hotpoints = new Hash();
		this.rects = new Hash();
	}
	
	public static function fromDef(def : FramingDef)
	{
		var f = new Framing();
		if (def.hotpoints != null)
		{
			for (hp in def.hotpoints)
			{
				f.hotpoints.set(hp.name, SubIPoint.fromFloats(hp.x, hp.y));
			}
		}
		if (def.tlrects != null)
		{
			for (r in def.tlrects)
			{
				f.rects.set(r.name, AABB.fromFloats(r.x, r.y, r.w, r.h));
			}
		}
		if (def.crects != null)
		{
			for (r in def.crects)
			{
				f.rects.set(r.name, AABB.centerFromFloats(r.w, r.h, r.x, r.y));				
			}
		}
	}
	
}
