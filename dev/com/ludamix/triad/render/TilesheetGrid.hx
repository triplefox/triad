package com.ludamix.triad.render;

import com.ludamix.triad.grid.IntGrid;
import com.ludamix.triad.render.XTilesheet;
import nme.geom.Matrix;
import nme.geom.ColorTransform;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.Graphics;
import nme.display.Tilesheet;
import nme.geom.Point;
import nme.geom.Rectangle;
import nme.Vector;

#if flash11
import com.ludamix.triad.render.Stage3DScene;
#end

class TilesheetGrid
{
	
	// a very basic DrawTiles 2d grid renderer.
	
	public var sheet : XTilesheet;
	public var grid : IntGrid;
	public var alpha(default,setAlpha) : Float;
	public var red(default,setRed) : Float;
	public var green(default,setGreen) : Float;
	public var blue(default,setBlue) : Float;
	public var flags_changed : Bool;
	public var scale : Float;
	public var off_x : Float;
	public var off_y : Float;
	private var cache : Array<Float>;
	private var cache_bitmap : Array<Float>;
	private var temp_bitmap : Bitmap;
	
	#if flash11
	private var s3dbuffer : Stage3DBuffer;
	#end
	
	public function setAlpha(n:Float) { if (alpha!=n) {alpha = n; flags_changed = true;} return alpha; }
	public function setRed(n:Float) { if (red!=n) {red = n; flags_changed = true;} return red; }
	public function setGreen(n:Float) { if (green!=n) {green = n; flags_changed = true;} return green; }
	public function setBlue(n:Float) { if (blue!=n) {blue = n; flags_changed = true;} return blue; }
	
	public function new(sheet : XTilesheet, worldw : Int, worldh : Int, twidth : Int, theight : Int, populate : Array<Int>,
		?useBlitter=false, ?useStage3D=false)
	{
		grid = new IntGrid(worldw, worldh, twidth, theight, populate);
		this.sheet = sheet;
		this.alpha = 1.0;
		this.red = 1.0;
		this.green = 1.0;
		this.blue = 1.0;
		scale = 1.;
		off_x = 0.;
		off_y = 0.;
		flags_changed = true;
		temp_bitmap = new Bitmap(sheet.nmeBitmap);
		
		#if flash11
		if (useStage3D)
			recacheStage3D();
		else
		#end
		{
			if (useBlitter)
				recacheBitmap();
			else
				recacheDrawtiles();
		}
	}
	
	#if flash11
	public function recacheStage3D()
	{
		if (s3dbuffer == null) s3dbuffer = new Stage3DBuffer();
		s3dbuffer.resetCounts();
		var offset : Point;
		var rect : Rectangle;
		var rect_uv : Vector<Float>;
		var idx = 0;
		
		for (y in 0...grid.worldH)
		{
			for (x in 0...grid.worldW)
			{
				var frame = grid.c1t(idx);
				var stw = grid.twidth * scale;
				var sth = grid.theight * scale;
				if (frame >= 0)
				{
					rect = sheet.rects[frame];
					rect_uv = sheet.rects_uv[frame];
					var px = off_x + x * stw; var py = off_y + y * sth;
					var pr = px + rect.width * scale; var pb = py + rect.height * scale;
					s3dbuffer.writeQuad(px, py, pr, py, px, pb, pr, pb, rect_uv[0], rect_uv[1],
						rect_uv[2], rect_uv[1], rect_uv[0], rect_uv[3], rect_uv[2], rect_uv[3]);
				}
				idx++;
			}
		}
		return;
	}
	#end
	
	public function recacheBitmap():Void
	{
		cache_bitmap = new Array<Float>();
		var idx = 0;
		
		if (useDraw())
		{
			for (y in 0...grid.worldH)
			{
				for (x in 0...grid.worldW)
				{
					cache_bitmap.push(off_x + x*grid.twidth);
					cache_bitmap.push(off_y + y*grid.theight);
					cache_bitmap.push(grid.c1t(idx));
					cache_bitmap.push(red);
					cache_bitmap.push(green);
					cache_bitmap.push(blue);
					cache_bitmap.push(alpha);
					idx++;
				}
			}	
		}
		else
		{
			for (y in 0...grid.worldH)
			{
				for (x in 0...grid.worldW)
				{
					cache_bitmap.push(off_x + x*grid.twidth);
					cache_bitmap.push(off_y + y*grid.theight);
					cache_bitmap.push(grid.c1t(idx));
					idx++;
				}
			}
		}
	}
	
	public function recacheDrawtiles():Void 
	{
		cache = new Array<Float>();
		
		var idx = 0;
		
		var stw = grid.twidth * scale;
		var sth = grid.theight * scale;
		if (useDraw())
		{
			if (scale != 1.)
			{
				for (y in 0...grid.worldH)
				{
					for (x in 0...grid.worldW)
					{
						var frame = grid.c1t(idx);
						if (frame >= 0)
						{
							cache.push(off_x + x*stw);
							cache.push(off_y + y*sth);
							cache.push(frame);
							cache.push(scale);
							cache.push(red);
							cache.push(green);
							cache.push(blue);
							cache.push(alpha);
						}
						idx++;
					}
				}				
			}
			else
			{
				for (y in 0...grid.worldH)
				{
					for (x in 0...grid.worldW)
					{
						var frame = grid.c1t(idx);
						if (frame >= 0)
						{
							cache.push(off_x + x*stw);
							cache.push(off_y + y*sth);
							cache.push(frame);
							cache.push(red);
							cache.push(green);
							cache.push(blue);
							cache.push(alpha);
						}
						idx++;
					}
				}				
			}
		}
		else
		{
			if (scale != 1.)
			{
				for (y in 0...grid.worldH)
				{
					for (x in 0...grid.worldW)
					{
						var frame = grid.c1t(idx);
						if (frame >= 0)
						{
							cache.push(off_x + x*stw);
							cache.push(off_y + y*sth);
							cache.push(frame);
							cache.push(scale);
						}
						idx++;
					}
				}			
			}
			else
			{
				for (y in 0...grid.worldH)
				{
					for (x in 0...grid.worldW)
					{
						var frame = grid.c1t(idx);
						if (frame >= 0)
						{
							cache.push(off_x + x*stw);
							cache.push(off_y + y*sth);
							cache.push(frame);
						}
						idx++;
					}
				}	
			}
		}
	}
	
	public inline function set1(idx, val) { grid.world[idx] = val; }
	public inline function set2(x, y, val) { var idx = grid.c21(x, y); set1(idx,val); }
	public inline function setff(x, y, val) { var idx = grid.cff1(x, y); set1(idx,val); }
	
	#if flash11
	public inline function stage3DFromGrid(input_grid : IntGrid, c : Stage3DScene, partialUpdate=true)
	{
		var idx = 0;
		
		if (flags_changed || grid.worldW!=input_grid.worldW || grid.worldH!=input_grid.worldH) partialUpdate = false;
		
		if (partialUpdate)
		{
			var doRecache = false;
			for (n in input_grid.world)
			{
				if (n != grid.world[idx])
				{
					set1(idx, n);
					doRecache = true;
				}
				idx++;
			}
			if (doRecache) recacheStage3D();
		}
		else
		{
			grid.worldW = input_grid.worldW;
			grid.worldH = input_grid.worldH;
			grid.world.length = input_grid.world.length;
			for (n in input_grid.world)
			{
				grid.world[idx] = n;
				idx++;
			}
			recacheStage3D();
		}
		c.runShader(sheet, s3dbuffer);
		
		flags_changed = false;
	}
	#end
	
	public inline function renderFromGrid(input_grid : IntGrid, gfx : Graphics, partialUpdate=true)
	{
		var idx = 0;
		
		if (flags_changed || grid.worldW!=input_grid.worldW || grid.worldH!=input_grid.worldH) partialUpdate = false;
		
		if (partialUpdate)
		{
			var doRecache = false;
			for (n in input_grid.world)
			{
				if (n != grid.world[idx])
				{
					set1(idx, n);
					doRecache = true;
				}
				idx++;
			}
			if (doRecache) recacheDrawtiles();
		}
		else
		{
			grid.worldW = input_grid.worldW;
			grid.worldH = input_grid.worldH;
			#if flash11
			grid.world.length = input_grid.world.length;
			#end
			for (n in input_grid.world)
			{
				grid.world[idx] = n;
				idx++;
			}
			recacheDrawtiles();
		}
		
		var useScale = scale != 1. ? Tilesheet.TILE_SCALE : 0;
		if (useDraw())
			sheet.drawTiles(gfx, cache, false, Tilesheet.TILE_RGB+Tilesheet.TILE_ALPHA+useScale);
		else sheet.drawTiles(gfx, cache, false, useScale);
		flags_changed = false;
	}
	
	private function useDraw() { return alpha != 1. || red != 1. || green != 1. || blue != 1.; }
	
	public function blitFromGrid(input_grid : IntGrid, gfx : BitmapData, partialUpdate=true, doErase=true)
	{
		// note: the blitter will ignore scale
		
		var idx = 0;
		var src = sheet.nmeBitmap;
		
		if (flags_changed || grid.worldW!=input_grid.worldW || grid.worldH!=input_grid.worldH) partialUpdate = false;
		
		if (partialUpdate)
		{
			if (useDraw())
			{
				var tb = temp_bitmap;
				tb.bitmapData = src;
				for (n in input_grid.world)
				{
					if (n != grid.world[idx])
					{
						set1(idx, n);
						var cidx = idx * 7;
						cache_bitmap[cidx + 2] = n;
						var pt = new Point(cache_bitmap[cidx], cache_bitmap[cidx + 1]);
						var frame = cache_bitmap[cidx + 2];
						if (frame >= 0)
						{
							var rect = sheet.rects[Std.int(cache_bitmap[cidx+2])];
							tb.scrollRect = rect;
							if (doErase) gfx.fillRect(new Rectangle(pt.x, pt.y, rect.width, rect.height), 0);
							var ct = new ColorTransform(red, green, blue, alpha);
							var mtx = new Matrix();
							mtx.translate(pt.x, pt.y);
							gfx.draw(tb, mtx, ct);
						}
						else
						{
							if (doErase) gfx.fillRect(new Rectangle(pt.x, pt.y, grid.twidth, grid.theight), 0);						
						}
					}
					idx++;
				}
			}
			else
			{
				for (n in input_grid.world)
				{
					if (n != grid.world[idx])
					{
						set1(idx, n);
						var cidx = idx * 3;
						cache_bitmap[cidx + 2] = n;
						var pt = new Point(cache_bitmap[cidx], cache_bitmap[cidx + 1]); 
						var frame = Std.int(cache_bitmap[cidx + 2]);
						if (frame >= 0)
						{
							var rect = sheet.rects[frame];
							var a = cache_bitmap[cidx + 3]; 
							var r = cache_bitmap[cidx + 4]; var g = cache_bitmap[cidx + 5]; var b = cache_bitmap[cidx + 6];
							if (doErase) gfx.fillRect(new Rectangle(pt.x, pt.y, rect.width, rect.height), 0);
							gfx.copyPixels(src, rect, pt);
						}
						else
						{
							if (doErase) gfx.fillRect(new Rectangle(pt.x, pt.y, grid.twidth, grid.theight), 0);
						}
					}
					idx++;
				}
			}
		}
		else
		{
			grid.worldW = input_grid.worldW;
			grid.worldH = input_grid.worldH;
			#if flash11
			grid.world.length = input_grid.world.length;
			#end
			for (n in input_grid.world)
			{
				grid.world[idx] = n;
				idx++;				
			}
			recacheBitmap();
			if (doErase) gfx.fillRect(gfx.rect, 0);
			if (useDraw())
			{
				var tb = new Bitmap(src);
				for (n in (0...Std.int(cache_bitmap.length/7)))
				{
					var idx = Std.int(n * 7);
					var pt = new Point(cache_bitmap[idx], cache_bitmap[idx + 1]); 
					var frame = Std.int(cache_bitmap[idx + 2]);
					if (frame >= 0)
					{
						var rect = sheet.rects[frame];
						var a = cache_bitmap[idx + 3]; 
						var r = cache_bitmap[idx + 4]; var g = cache_bitmap[idx + 5]; var b = cache_bitmap[idx + 6];
						tb.scrollRect = rect;
						var ct = new ColorTransform(red, green, blue, alpha);
						var mtx = new Matrix();
						mtx.translate(pt.x, pt.y);
						gfx.draw(tb,mtx,ct);
					}
				}
			}
			else
			{
				for (n in (0...Std.int(cache_bitmap.length/3)))
				{
					var idx = Std.int(n * 3);
					var pt = new Point(cache_bitmap[idx], cache_bitmap[idx + 1]);
					var frame = Std.int(cache_bitmap[idx + 2]);
					if (frame>=0)
						gfx.copyPixels(src, sheet.rects[frame], pt);
				}
			}
		}		
		flags_changed = false;
	}	
	
	public function resize(worldw : Int, worldh : Int, tilew : Int, tileh : Int, pop : Array<Int>)
	{
		grid.worldW = worldw;
		grid.worldH = worldh;
		grid.twidth = tilew;
		grid.theight = tileh;
		#if flash11
		grid.world = Vector.ofArray(pop);
		#else
		grid.world = pop;
		#end
		cache = null;
		cache_bitmap = null;
		flags_changed = true;
	}
	
}