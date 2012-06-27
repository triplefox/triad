package com.ludamix.triad.render;

import nme.display.BitmapData;
import nme.display.Graphics;
import nme.display.Tilesheet;
typedef SpriteDef = {name:String, idx:Int, frames:Int, xoff:Int, yoff:Int, w:Int, h:Int};

class SpriteXYZ
{
	public var x : Float;
	public var y : Float;
	public var z : Int;
	public var idx : Int;
	public var alpha : Float;
	public var red : Float;
	public var green : Float;
	public var blue : Float;
	public var rotation : Float;
	public var scale : Float;
	
	public function new(x, y, z, idx, alpha, red, green, blue, rotation, scale)
	{
		this.x = x; this.y = y; this.z = z; this.idx = idx;
		this.alpha = alpha; this.red = red; this.green = green; this.blue = blue;
		this.rotation = rotation; this.scale = scale;
	}
}

class SpriteRenderer
{

	public var defs : Array<SpriteDef>;
	public var defs_names : Hash<SpriteDef>;
	public var sheet : XTilesheet;
	public var sprite_queue : Array<SpriteXYZ>;
	private var queue_ptr : Int;
	private var backbuffer : Array<Float>;

	public function new(defs : Array<SpriteDef>, sheet : XTilesheet, ?poolsize=0)
	{
		this.defs = defs;
		this.sheet = sheet;
		defs_names = new Hash();
		for (n in defs)
			defs_names.set(n.name, n);
		sprite_queue = new Array();
		backbuffer = new Array();
		queue_ptr = 0;
		for (n in 0...poolsize)
		{
			sprite_queue.push(new SpriteXYZ(0., 0., 0, 0, 1.0, 1.0, 1.0, 1.0, 0., 1.0));
		}
	}
	
	public inline function addName(x, y, z, name, ?frame = 0, ?alpha = 1.0, 
		?red = 1.0, ?green = 1.0, ?blue = 1.0, ?rotation=0.,?scale=1.0) 
	{ 
		_addRaw(x, y, z, defs_names.get(name).idx + frame, alpha, red, green, blue, rotation, scale); 
	}
	
	public inline function addIdx(x, y, z, idx, ?frame = 0, ?alpha = 1.0, 
		?red = 1.0, ?green = 1.0, ?blue = 1.0, ?rotation=0.,?scale=1.0)
	{ 
		_addRaw(x, y, z, defs[idx].idx + frame, alpha, red, green, blue, rotation, scale); 
	}
	
	public inline function getFrames(name) { return defs_names.get(name).frames;  }
	
	public inline function _addRaw(x:Float, y:Float, z:Int, idx:Int, alpha:Float,
		red:Float,green:Float,blue:Float,rotation:Float,scale:Float)
	{
		if (queue_ptr<sprite_queue.length)
		{
			var spr = sprite_queue[queue_ptr];
			spr.x = x;
			spr.y = y;
			spr.z = z;
			spr.alpha = alpha;
			spr.red = red;
			spr.green = green;
			spr.blue = blue;
			spr.rotation = rotation;
			spr.scale = scale;
			spr.idx = idx;
		}
		else
		{
			sprite_queue.push(new SpriteXYZ(x, y, z, idx, alpha, red, green, blue, rotation, scale));
		}
		queue_ptr++;
	}
	
	private function zsort(a : SpriteXYZ, b : SpriteXYZ) {return Std.int(b.z - a.z);}
	
	public inline function calcTileData(flags : Int) : Array<Float>
	{
		backbuffer = new Array<Float>();
		for (n in 0...queue_ptr)
		{
			var spr = sprite_queue[n];
			backbuffer.push(spr.x);
			backbuffer.push(spr.y);
			backbuffer.push(spr.idx);
			if ((flags & Tilesheet.TILE_SCALE)>0) backbuffer.push(spr.scale);
			if ((flags & Tilesheet.TILE_ROTATION)>0) backbuffer.push(spr.rotation);
			if ((flags & Tilesheet.TILE_RGB)>0) 
				{ backbuffer.push(spr.red); backbuffer.push(spr.green); backbuffer.push(spr.blue); }
			if ((flags & Tilesheet.TILE_ALPHA)>0) backbuffer.push(spr.alpha);			
		}
		queue_ptr = 0;
		return backbuffer;		
	}
	
	public inline function draw_blitter(bd : BitmapData, bg_color : Int, ?smooth : Bool, ?flags : Int=0)
	{
		sprite_queue.sort(zsort);
		// TODO: rather than pass in flags, we should derive them from each sprite instance...
		// ...and then create an optimal run for each group.
		sheet.clear(bd, backbuffer, flags, bg_color);
		sheet.blit(bd, calcTileData(flags), smooth, flags);
	}

	public inline function draw_tiles(gfx : Graphics, ?smooth : Bool, ?flags : Int=0)
	{
		sprite_queue.sort(zsort);
		sheet.drawTiles(gfx, calcTileData(flags), smooth, flags);
	}
	
}