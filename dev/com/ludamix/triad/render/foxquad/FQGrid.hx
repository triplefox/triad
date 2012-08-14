package com.ludamix.triad.render.foxquad;

import com.ludamix.triad.grid.IntGrid;
import com.ludamix.triad.render.foxquad.FoxQuadScene;
import com.ludamix.triad.render.foxquad.Quads2D;
import com.ludamix.triad.render.XTilesheet;
import flash.display3D.Context3D;
import nme.geom.Matrix;
import nme.geom.ColorTransform;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.Graphics;
import nme.display.Tilesheet;
import nme.geom.Point;
import nme.geom.Rectangle;
import nme.Vector;

class FQGrid
{
	
	// A basic 2d grid renderer,
	// intended for large maps of finite size.
	
	public var chunks : Array<Quads2D>;
	public var sheet : XTilesheet;
	public var grid : IntGrid;
	public var chunk_dimensions : Int;
	public var inv_chunk_dimensions : Float;
	public var chunks_width : Int;
	public var chunks_height : Int;
	
	public function new(sheet : XTilesheet, 
		worldw : Int, worldh : Int, twidth : Int, theight : Int, populate : Array<Int>, 
		?chunk_dimensions : Int = 96)
	{
		grid = new IntGrid(worldw, worldh, twidth, theight, populate);
		this.sheet = sheet;
		chunks = new Array();
		
		this.chunk_dimensions = chunk_dimensions;
		
	}
	
	public inline function chunk(x) { return Std.int(x * inv_chunk_dimensions); }
	
	public function recache(context : Context3D)
	{
		for (q in chunks)
			q.reset();
		
		this.inv_chunk_dimensions = 1./chunk_dimensions;
		
		chunks_width = Math.ceil(grid.worldW * inv_chunk_dimensions);
		chunks_height = Math.ceil(grid.worldH * inv_chunk_dimensions);
		while (chunks.length < chunks_width * chunks_height)		
		{
			chunks.push(new Quads2D(context));
		}
		while (chunks.length > chunks_width * chunks_height)
		{
			var ck = chunks.shift();
			ck.dispose();
		}
		
		var pt = new Point(0., 0.);
		var offset = new Point(0., 0.);
		var uv = new Rectangle(0., 0., 1., 1.);
		
		var idx = 0;
		for (y in 0...grid.worldH)
		{
			var chunk_y = chunk(y) * chunks_width;
			for (x in 0...grid.worldW)
			{
				var frame = grid.c1t(idx);
				var stw = grid.twidth;
				var sth = grid.theight;
				var chunk_x = chunk(x);
				if (frame >= 0)
				{
				try {
					pt.x = x * stw; pt.y = y * sth;
					chunks[chunk_x + chunk_y].writeSprite(pt, 
						sheet.tiles[frame].rect, sheet.tiles[frame].uv, offset);
				} catch (d:Dynamic) { trace([chunk_x,chunk_y,chunks_width,chunks_height,chunks.length]); }
				}
				idx++;
			}
		}		
		
	}
	
	public inline function set1(idx, val) { grid.world[idx] = val; }
	public inline function set2(x, y, val) { var idx = grid.c21(x, y); set1(idx,val); }
	public inline function setff(x, y, val) { var idx = grid.cff1(x, y); set1(idx, val); }
	
	public inline function runShader(shader : Dynamic, shader_vertex : Dynamic, shader_fragment : Dynamic)
	{
		for (q in chunks)
			q.runShader(shader, shader_vertex, shader_fragment);
	}
	
}