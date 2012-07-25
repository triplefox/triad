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
	private var cache : Array<Float>;
	private var temp_bitmap : Bitmap;
	
	public function setAlpha(n:Float) { if (alpha!=n) {alpha = n; flags_changed = true;} return alpha; }
	public function setRed(n:Float) { if (red!=n) {red = n; flags_changed = true;} return red; }
	public function setGreen(n:Float) { if (green!=n) {green = n; flags_changed = true;} return green; }
	public function setBlue(n:Float) { if (blue!=n) {blue = n; flags_changed = true;} return blue; }
	
	public function new(sheet : XTilesheet, worldw : Int, worldh : Int, twidth : Int, theight : Int, populate : Array<Int>)
	{		
		grid = new IntGrid(worldw, worldh, twidth, theight, populate);
		this.sheet = sheet;
		this.alpha = 1.0;
		this.red = 1.0;
		this.green = 1.0;
		this.blue = 1.0;
		flags_changed = true;
		temp_bitmap = new Bitmap(sheet.nmeBitmap);
		
		recache();		
	}
	
	public function recache():Void 
	{
		cache = new Array<Float>();
		
		var idx = 0;
		
		if (useDraw())
		{
			for (y in 0...grid.worldH)
			{
				for (x in 0...grid.worldW)
				{
					cache.push(x*grid.twidth);
					cache.push(y*grid.theight);
					cache.push(grid.c1t(idx));
					cache.push(red);
					cache.push(green);
					cache.push(blue);
					cache.push(alpha);
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
					cache.push(x*grid.twidth);
					cache.push(y*grid.theight);
					cache.push(grid.c1t(idx));
					idx++;
				}
			}	
		}
	}
	
	public inline function recachePartial(idx : Int)
	{
		if (useDraw())
		{
			cache[(idx * 7) + 2] = grid.c1t(idx);
		}
		else
		{
			cache[(idx * 3) + 2] = grid.c1t(idx);
		}
	}
	
	public inline function set1(idx, val) { grid.world[idx] = val; recachePartial(idx); }
	public inline function set2(x, y, val) { var idx = grid.c21(x, y); set1(idx,val); }
	public inline function setff(x, y, val) { var idx = grid.cff1(x, y); set1(idx,val); }
	
	#if flash11
	public inline function stage3DFromGrid(input_grid : IntGrid, c : Stage3DScene, partialUpdate=true)
	{
		var idx = 0;
		if (flags_changed) partialUpdate = false;
		
		if (partialUpdate)
		{
			for (n in input_grid.world)
			{
				if (n != grid.world[idx])
					set1(idx, n);
				idx++;
			}
		}
		else
		{
			for (n in input_grid.world)
			{
				grid.world[idx] = n;
				idx++;
			}
			recache();
		}
		if (useDraw())
			sheet.drawStage3D(c, cache, false, Tilesheet.TILE_RGB+Tilesheet.TILE_ALPHA);
		else sheet.drawStage3D(c, cache);
		flags_changed = false;
	}
	#end
	
	public inline function renderFromGrid(input_grid : IntGrid, gfx : Graphics, partialUpdate=true)
	{
		var idx = 0;
		if (flags_changed) partialUpdate = false;
		partialUpdate = false;
		
		if (partialUpdate) // when using Flash DrawTiles, this does not work correctly for idx 0.
		{
			for (n in input_grid.world)
			{
				if (n != grid.world[idx])
					set1(idx, n);
				idx++;
			}
		}
		else
		{
			for (n in input_grid.world)
			{
				grid.world[idx] = n;
				idx++;
			}
			recache();
		}
		if (useDraw())
			sheet.drawTiles(gfx, cache, false, Tilesheet.TILE_RGB+Tilesheet.TILE_ALPHA);
		else sheet.drawTiles(gfx, cache);
		flags_changed = false;
	}
	
	private function useDraw() { return alpha != 1. || red != 1. || green != 1. || blue != 1.; }
	
	public function blitFromGrid(input_grid : IntGrid, gfx : BitmapData, partialUpdate=true, doErase=true)
	{
		var idx = 0;
		var src = sheet.nmeBitmap;
		
		if (flags_changed) partialUpdate = false;
		
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
						var pt = new Point(cache[cidx], cache[cidx + 1]);
						var rect = sheet.rects[Std.int(cache[cidx+2])];
						tb.scrollRect = rect;
						if (doErase) gfx.fillRect(new Rectangle(pt.x, pt.y, rect.width, rect.height), 0);
						var ct = new ColorTransform(red, green, blue, alpha);
						var mtx = new Matrix();
						mtx.translate(pt.x, pt.y);
						gfx.draw(tb, mtx, ct);
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
						var pt = new Point(cache[cidx], cache[cidx + 1]); var rect = sheet.rects[Std.int(cache[cidx + 2])];
						var a = cache[cidx + 3]; 
						var r = cache[cidx + 4]; var g = cache[cidx + 5]; var b = cache[cidx + 6];
						if (doErase) gfx.fillRect(new Rectangle(pt.x, pt.y, rect.width, rect.height), 0);
						gfx.copyPixels(src, rect, pt);
					}
					idx++;
				}
			}
		}
		else
		{
			for (n in input_grid.world)
			{
				grid.world[idx] = n;
				idx++;
			}
			recache();
			if (doErase) gfx.fillRect(gfx.rect, 0);
			if (useDraw())
			{
				var tb = new Bitmap(src);
				for (n in (0...Std.int(cache.length/7)))
				{
					var idx = Std.int(n * 7);
					var pt = new Point(cache[idx], cache[idx + 1]); var rect = sheet.rects[Std.int(cache[idx + 2])];
					var a = cache[idx + 3]; 
					var r = cache[idx + 4]; var g = cache[idx + 5]; var b = cache[idx + 6];
					tb.scrollRect = rect;
					var ct = new ColorTransform(red, green, blue, alpha);
					var mtx = new Matrix();
					mtx.translate(pt.x, pt.y);
					gfx.draw(tb,mtx,ct);
				}
			}
			else
			{
				for (n in (0...Std.int(cache.length/3)))
				{
					var idx = Std.int(n * 3);
					var pt = new Point(cache[idx], cache[idx + 1]);
					gfx.copyPixels(src, sheet.rects[Std.int(cache[idx + 2])], pt);
				}
			}
		}		
		flags_changed = false;
	}	
	
}