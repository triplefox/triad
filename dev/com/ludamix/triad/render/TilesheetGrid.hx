package com.ludamix.triad.render;

import com.ludamix.triad.grid.IntGrid;
import com.ludamix.triad.render.XTilesheet;
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
	private var cache : Array<Float>;
	
	public function new(sheet : XTilesheet, worldw : Int, worldh : Int, twidth : Int, theight : Int, populate : Array<Int>)
	{		
		grid = new IntGrid(worldw, worldh, twidth, theight, populate);
		this.sheet = sheet;
		
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
			g.copyPixels(src, sheet.rects[Std.int(cache[idx + 2])], pt);
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
					gfx.copyPixels(src, sheet.rects[Std.int(cache[idx + 2])], pt);
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