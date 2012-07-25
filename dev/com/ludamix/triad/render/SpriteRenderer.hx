package com.ludamix.triad.render;

import nme.display.BitmapData;
import nme.display.Graphics;
import nme.display.Tilesheet;

#if flash11
import flash.display3D.Context3D;
import com.ludamix.triad.render.Stage3DScene;
#end

typedef SpriteDef = {name:String, sheet:XTilesheet, idx:Int, frames:Int, xoff:Int, yoff:Int, w:Int, h:Int};

class SpriteXYZ
{
	public var x : Float;
	public var y : Float;
	public var z : Int;
	public var sheet : XTilesheet;
	public var idx : Int;
	public var alpha : Float;
	public var red : Float;
	public var green : Float;
	public var blue : Float;
	public var rotation : Float;
	public var scale : Float;
	
	public function new(x, y, z, sheet, idx, alpha, red, green, blue, rotation, scale)
	{
		this.x = x; this.y = y; this.z = z; this.sheet = sheet; this.idx = idx;
		this.alpha = alpha; this.red = red; this.green = green; this.blue = blue;
		this.rotation = rotation; this.scale = scale;
	}
}

class SpriteRenderer
{

	public var defs : Array<SpriteDef>;
	public var defs_names : Hash<SpriteDef>;
	public var aliases : Hash<{def:SpriteDef,frame:Int}>;
	public var sheets : Array<XTilesheet>;
	public var sprite_queue : Array<SpriteXYZ>;
	private var queue_ptr : Int;
	private var clear_buffer : Array<{flags:Int,sheet:XTilesheet,data:Array<Float>}>;

	public function new(defs : Array<SpriteDef>, ?poolsize=0)
	{
		this.defs = defs;
		this.sheets = new Array();
		defs_names = new Hash();
		for (n in defs)
		{
			defs_names.set(n.name, n);
			this.sheets.remove(n.sheet); this.sheets.push(n.sheet);
		}
		this.aliases = new Hash();
		sprite_queue = new Array();
		clear_buffer = new Array();
		queue_ptr = 0;
		for (n in 0...poolsize)
		{
			sprite_queue.push(new SpriteXYZ(0., 0., 0, null, 0, 1.0, 1.0, 1.0, 1.0, 0., 1.0));
		}
	}
	
	public inline function addName(x, y, z, name, ?frame = 0, ?alpha = 1.0, 
		?red = 1.0, ?green = 1.0, ?blue = 1.0, ?rotation=0.,?scale=1.0) 
	{ 
		var def = defs_names.get(name);
		_addRaw(x, y, z, def.sheet, def.idx + frame, alpha, red, green, blue, rotation, scale); 
	}
	
	public inline function addAlias(x, y, z, name, ?alpha = 1.0, 
		?red = 1.0, ?green = 1.0, ?blue = 1.0, ?rotation=0.,?scale=1.0) 
	{ 
		var a = aliases.get(name);
		_addRaw(x, y, z, a.def.sheet, a.def.idx + a.frame, alpha, red, green, blue, rotation, scale); 
	}
	
	public inline function addIdx(x, y, z, idx, ?frame = 0, ?alpha = 1.0, 
		?red = 1.0, ?green = 1.0, ?blue = 1.0, ?rotation=0.,?scale=1.0)
	{ 
		var def = defs[idx];
		_addRaw(x, y, z, def.sheet, def.idx + frame, alpha, red, green, blue, rotation, scale); 
	}
	
	public inline function addRaw(x, y, z, sheet, idx, ?frame = 0, ?alpha = 1.0, 
		?red = 1.0, ?green = 1.0, ?blue = 1.0, ?rotation=0.,?scale=1.0)
	{ 
		_addRaw(x, y, z, sheet, idx + frame, alpha, red, green, blue, rotation, scale); 
	}
	
	public inline function getFrames(name) { return defs_names.get(name).frames;  }
	public inline function getSheet(name) { return defs_names.get(name).sheet;  }
	public inline function getIdx(name) { return defs_names.get(name).idx;  }
	public inline function getDef(name) { return defs_names.get(name);  }
	
	public inline function _addRaw(x:Float, y:Float, z:Int, sheet:XTilesheet, idx:Int, alpha:Float,
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
			spr.sheet = sheet;
		}
		else
		{
			sprite_queue.push(new SpriteXYZ(x, y, z, sheet, idx, alpha, red, green, blue, rotation, scale));
		}
		queue_ptr++;
	}
	
	private function zsort(a : SpriteXYZ, b : SpriteXYZ) {return Std.int(b.z - a.z);}
	
	public inline function calcTileData(add_offsets : Bool) : Array<{data:Array<Float>,sheet:XTilesheet,flags:Int}>
	{
		// 1: make runs from sorted data
		sprite_queue.sort(zsort);
		var runs = new Array<{flags:Int,sheet:XTilesheet,run:Array<SpriteXYZ>}>();
		var cur_sheet = null;
		var run_type = 0;
		var cur_run = new Array<SpriteXYZ>();
		for (i in 0...queue_ptr)
		{
			var n = sprite_queue[i];
			var spr_type = 0;
			if (n.alpha != 1.) spr_type += Tilesheet.TILE_ALPHA;
			if (n.red != 1. || n.green != 1. || n.blue != 1.) spr_type += Tilesheet.TILE_RGB;
			if (n.scale != 1.) spr_type += Tilesheet.TILE_SCALE;
			if (n.rotation != 0.) spr_type += Tilesheet.TILE_ROTATION;
			if (spr_type != run_type || cur_sheet != n.sheet )
			{
				if (cur_run.length > 0) 
				{ 
					runs.push( { flags:run_type, sheet:cur_sheet, run:cur_run } );  cur_run = new Array(); 
				}
				run_type = spr_type;
				cur_sheet = n.sheet;
			}
			cur_run.push(n);
		}
		if (cur_run.length > 0) { runs.push( { flags:run_type, sheet:cur_sheet, run:cur_run } ); }
		queue_ptr = 0;
		// 2: translate SpriteXYZ+sheet+flag runs to float+sheet+flag runs
		// This could be optimized with macros someday to avoid the inner-loop ifs
		var result = new Array<{flags:Int,sheet:XTilesheet,data:Array<Float>}>();
		for (r in runs)
		{
			var draw_buffer = new Array<Float>();
			result.push( { flags:r.flags, sheet:r.sheet, data:draw_buffer } );
			
			if ((r.flags & Tilesheet.TILE_SCALE) > 0 || (r.flags & Tilesheet.TILE_ROTATION) > 0 ||
				(r.flags & Tilesheet.TILE_RGB) > 0 || (r.flags & Tilesheet.TILE_ALPHA) > 0)
			{
				for (spr in r.run)
				{
					if (add_offsets)
					{
						draw_buffer.push(spr.x - spr.sheet.points[spr.idx].x);
						draw_buffer.push(spr.y - spr.sheet.points[spr.idx].y);
					}
					else
					{
						draw_buffer.push(spr.x);
						draw_buffer.push(spr.y);
					}
					draw_buffer.push(spr.idx);
					
					if ((r.flags & Tilesheet.TILE_SCALE)>0) draw_buffer.push(spr.scale);
					if ((r.flags & Tilesheet.TILE_ROTATION)>0) draw_buffer.push(spr.rotation);
					if ((r.flags & Tilesheet.TILE_RGB)>0) 
						{ draw_buffer.push(spr.red); draw_buffer.push(spr.green); draw_buffer.push(spr.blue); }
					if ((r.flags & Tilesheet.TILE_ALPHA)>0) draw_buffer.push(spr.alpha);			
				}
				
			}
			else // optimize for the basic blit case
			{
				if (add_offsets)
				{
					for (spr in r.run)
					{
						draw_buffer.push(spr.x - spr.sheet.points[spr.idx].x);
						draw_buffer.push(spr.y - spr.sheet.points[spr.idx].y);
						draw_buffer.push(spr.idx);
					}
				}
				else
				{
					for (spr in r.run)
					{
						draw_buffer.push(spr.x);
						draw_buffer.push(spr.y);
						draw_buffer.push(spr.idx);
					}
				}			
			}
			
		}
		return result;
	}
	
	public inline function draw_blitter(bd : BitmapData, bg_color : Int, ?smooth : Bool)
	{
		for (r in clear_buffer)
			r.sheet.clear(bd, r.data, r.flags, bg_color);
		clear_buffer = calcTileData(true);
		for (r in clear_buffer)
			r.sheet.blit(bd, r.data, smooth, r.flags);
	}

	#if flash11
	public inline function draw_stage3d(c : Stage3DScene, ?smooth : Bool)
	{
		sprite_queue.sort(zsort);
		clear_buffer = calcTileData(false);
		for (r in clear_buffer)
			r.sheet.drawStage3D(c, r.data, smooth, r.flags);
	}
	#end

	public inline function draw_tiles(gfx : Graphics, ?smooth : Bool)
	{
		sprite_queue.sort(zsort);
		clear_buffer = calcTileData(false);
		for (r in clear_buffer)
			r.sheet.drawTiles(gfx, r.data, smooth, r.flags);
	}
	
}