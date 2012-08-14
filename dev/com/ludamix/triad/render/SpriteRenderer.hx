package com.ludamix.triad.render;

import nme.display.BitmapData;
import nme.display.Graphics;
import nme.display.Tilesheet;
import com.ludamix.triad.render.GraphicsResource;
import com.ludamix.triad.render.XTilesheet;

#if flash11
import flash.display3D.Context3D;
import com.ludamix.triad.render.Stage3DScene;
import flash.geom.Point;
import flash.geom.Matrix;
import flash.geom.Rectangle;
import flash.Vector;
#end

typedef SpriteRun = { flags:Int, sheet:XTilesheet, run:Array<SpriteXYZ> };

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
	public var run_pre : Array<SpriteRun>;
	public var run_post : Array<SpriteRun>;

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
	
	private function zsort(a : SpriteXYZ, b : SpriteXYZ) { return Std.int(b.z - a.z); }
	
	private inline function calcRuns() : Array<SpriteRun>
	{
		sprite_queue.sort(zsort);
		var runs = new Array<SpriteRun>();
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
		// add user-driven run data
		if (run_pre != null) runs = run_pre.concat(runs);
		if (run_post != null) runs = runs.concat(run_post);
		return runs;
	}
	
	public inline function calcTileData(add_offsets : Bool) : Array<{data:Array<Float>,sheet:XTilesheet,flags:Int}>
	{
		// 1: make runs from sorted data
		var runs = calcRuns();
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
						draw_buffer.push(spr.x - spr.sheet.tiles[spr.idx].offset.x);
						draw_buffer.push(spr.y - spr.sheet.tiles[spr.idx].offset.y);
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
						draw_buffer.push(spr.x - spr.sheet.tiles[spr.idx].offset.x);
						draw_buffer.push(spr.y - spr.sheet.tiles[spr.idx].offset.y);
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
		var runs = calcRuns();
		for (r in runs)
			_stage3D(c, r, smooth);
	}
	
	private var buffer : Stage3DBuffer;
	
	private inline function _stage3D(scene : Stage3DScene, 
		r : SpriteRun, ?smooth : Bool = false)
	{
		var texture = r.sheet.texture;
		var tiles = r.sheet.tiles;
		
		if (texture == null)
			throw "Texture is null, add this XTilesheet to the scene first";
		var src : BitmapData = r.sheet.nmeBitmap;
		
		var flags = r.flags;
		
		var useAlpha = (flags & Tilesheet.TILE_ALPHA) > 0;
		var useRGB = (flags & Tilesheet.TILE_RGB) > 0;
		var useScale = (flags & Tilesheet.TILE_SCALE) > 0;
		var useRotate = (flags & Tilesheet.TILE_ROTATION) > 0;
		
		var ptr = 0;	
		var tl = new Point(0., 0.);
		var tr = new Point(0., 0.);
		var bl = new Point(0., 0.);
		var br = new Point(0., 0.);
		var pt = new Point(0., 0.);
		var offset : Point;
		var rect_uv : Rectangle;
		var rect : Rectangle;
		var scale : Float;
		var rotation : Float;
		var red : Float;
		var green : Float;
		var blue : Float;
		var alpha : Float;
		var tile : XTile;
		var mtx = new Matrix();
		
		if (buffer == null) buffer = new Stage3DBuffer();
		
		for (sprite in r.run)
		{
			pt.x = sprite.x;
			pt.y = sprite.y;
			var uv_pos = sprite.idx;
			tile = tiles[uv_pos];
			offset = tile.offset;
			rect_uv = tile.uv;
			rect = tile.rect;
			scale = 1.;
			rotation = 0.;
			red = 1.;
			green = 1.;
			blue = 1.;
			alpha = 1.;
			
			tl.x = 0.; tl.y = 0.;
			tr.x = rect.width; tr.y = 0.;
			bl.x = 0.; bl.y = rect.height;
			br.x = rect.width; br.y = rect.height;
			
			if (useScale || useRotate) 
			{ 
				
				scale = sprite.scale; 
				rotation = sprite.rotation; 			
				mtx.identity();
				mtx.translate(-offset.x, -offset.y);
				mtx.scale(scale, scale);
				mtx.rotate(rotation);
				mtx.translate(pt.x, pt.y);
				
				tl = mtx.transformPoint(tl);
				tr = mtx.transformPoint(tr); 
				bl = mtx.transformPoint(bl);
				br = mtx.transformPoint(br);
				
			
			}
			else
			{
				pt.x -= offset.x; pt.y -= offset.y;
				tl.x += pt.x; tl.y += pt.y;
				tr.x += pt.x; tr.y += pt.y;
				bl.x += pt.x; bl.y += pt.y;
				br.x += pt.x; br.y += pt.y;
			}
			
			if (useRGB || useAlpha) { 
				red = sprite.red; green = sprite.green; blue = sprite.blue;
				alpha = sprite.alpha;
				buffer.writeColorQuad(tl.x, tl.y, tr.x, tr.y, bl.x, bl.y, br.x, br.y,
				rect_uv.left, rect_uv.top, rect_uv.right, rect_uv.top, 
				rect_uv.left, rect_uv.bottom, rect_uv.right, rect_uv.bottom,
				red,green,blue,alpha);
			}
			else
			buffer.writeQuad(tl.x, tl.y, tr.x, tr.y, bl.x, bl.y, br.x, br.y,
				rect_uv.left, rect_uv.top, rect_uv.right, rect_uv.top, 
				rect_uv.left, rect_uv.bottom, rect_uv.right, rect_uv.bottom
				);
			
		}
		
		if (useRGB || useAlpha)
			scene.runColorShader(r.sheet, buffer);
		else
			scene.runShader(r.sheet, buffer);
		buffer.resetCounts();
		
	}
	#end

	public inline function draw_tiles(gfx : Graphics, ?smooth : Bool)
	{
		clear_buffer = calcTileData(false);
		for (r in clear_buffer)
			r.sheet.drawTiles(gfx, r.data, smooth, r.flags);
	}
	
}