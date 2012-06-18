package com.ludamix.triad.grid;

import com.ludamix.triad.grid.IntGrid;
import nme.display.BitmapData;
import nme.display.Graphics;
import nme.display.Tilesheet;
import nme.geom.Point;
import nme.geom.Rectangle;

class TilesheetGrid
{
	
	// a very basic DrawTiles 2d grid renderer.
	
	public var sheet : Tilesheet;
	public var rects : Array<Rectangle>;
	public var grid : IntGrid;
	private var cache : Array<Float>;
	
	public function new(bd : BitmapData, worldw : Int, worldh : Int, twidth : Int, theight : Int, populate : Array<Int>)
	{
		var tw = Std.int(bd.width / twidth);
		var th = Std.int(bd.height / theight);
		sheet = new Tilesheet(bd);
		rects = new Array();
		for (y in 0...th)
		{
			for (x in 0...tw)
			{
				var r = new Rectangle(x * twidth, y * theight, twidth, theight);
				sheet.addTileRect(r);
				rects.push(r);
			}
		}
		
		grid = new IntGrid(worldw, worldh, twidth, theight, populate);
		
		recache();		
	}
	
	public function recache():Void 
	{
		cache = new Array<Float>();
		
		var idx = 0;
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
	
	public inline function recachePartial(idx : Int)
	{
		cache[(idx * 3) + 2] = grid.c1t(idx);
	}
	
	public inline function set1(idx, val) { grid.world[idx] = val; recachePartial(idx); }
	public inline function set2(x, y, val) { var idx = grid.c21(x, y); set1(idx,val); }
	public inline function setff(x, y, val) { var idx = grid.cff1(x, y); set1(idx,val); }

	public inline function render(g : Graphics)
	{
		sheet.drawTiles(g, cache);
	}
	
	public inline function renderFromGrid(input_grid : IntGrid, gfx : Graphics, partialUpdate=true)
	{
		var idx = 0;
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
		render(gfx);
	}
	
	public inline function blit(g : BitmapData)
	{
		var src = sheet.nmeBitmap;
		for (n in (0...Std.int(cache.length/3)))
		{
			var idx = Std.int(n * 3);
			var pt = new Point(cache[idx], cache[idx + 1]);
			g.copyPixels(src, rects[Std.int(cache[idx + 2])], pt, src, new Point(0., 0.), true);
		}
	}
	
	public function blitFromGrid(input_grid : IntGrid, gfx : BitmapData, partialUpdate=true)
	{
		var idx = 0;
		var src = sheet.nmeBitmap;
		if (partialUpdate)
		{
			for (n in input_grid.world)
			{
				if (n != grid.world[idx])
				{
					set1(idx, n);
					var pt = new Point(cache[idx], cache[idx + 1]);
					gfx.copyPixels(src, rects[Std.int(cache[idx + 2])], pt, src, new Point(0., 0.), true);
				}
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
			blit(gfx);
		}		
	}	
	
}