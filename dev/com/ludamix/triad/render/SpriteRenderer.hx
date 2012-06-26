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
	public function new(x, y, z, idx)
	{
		this.x = x; this.y = y; this.z = z; this.idx = idx;
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
			sprite_queue.push(new SpriteXYZ(0., 0., 0, 0));
		}
	}
	
	public inline function addName(x, y, z, name, ?frame = 0) { _addRaw(x, y, z, defs_names.get(name).idx + frame); }
	public inline function addIdx(x, y, z, idx, ?frame=0) { _addRaw(x,y,z,defs[idx].idx+frame); }
	
	public inline function getFrames(name) { return defs_names.get(name).frames;  }
	
	public inline function _addRaw(x,y,z,idx)
	{
		if (queue_ptr<sprite_queue.length)
		{
			var spr = sprite_queue[queue_ptr];
			spr.x = x;
			spr.y = y;
			spr.z = z;
			spr.idx = idx;
		}
		else
		{
			sprite_queue.push(new SpriteXYZ(x, y, z, idx));
		}
		queue_ptr++;
	}
	
	private function zsort(a : SpriteXYZ, b : SpriteXYZ) {return Std.int(b.z - a.z);}
	
	public inline function calcTileData() : Array<Float>
	{
		backbuffer = new Array<Float>();
		for (n in 0...queue_ptr)
		{
			var spr = sprite_queue[n];
			backbuffer.push(spr.x);
			backbuffer.push(spr.y);
			backbuffer.push(spr.idx);
		}
		queue_ptr = 0;
		return backbuffer;		
	}
	
	public inline function draw_blitter(bd : BitmapData, bg_color : Int)
	{
		sprite_queue.sort(zsort);
		sheet.clear(bd, backbuffer, bg_color);
		sheet.blit(bd, calcTileData());
	}

	public inline function draw_tiles(gfx : Graphics)
	{
		sprite_queue.sort(zsort);
		sheet.drawTiles(gfx, calcTileData());
	}
	
}