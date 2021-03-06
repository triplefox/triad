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
	
	public var chunks : Array<Quads2PointFiveD>;
	public var sheet : XTilesheet;
	public var grid : IntGrid;
	public var chunk_dimensions : Int;
	public var inv_chunk_dimensions : Float;
	public var chunks_width : Int;
	public var chunks_height : Int;
	public var z_multiplier : Float; // modifies z depth of each tile based on some multiple of the tile_y coordinate.
	
	public function new(sheet : XTilesheet, 
		worldw : Int, worldh : Int, twidth : Int, theight : Int, populate : Array<Int>, 
		?chunk_dimensions : Int = 96, ?z_multiplier : Float = -0.00001)
	{
		grid = new IntGrid(worldw, worldh, twidth, theight, populate);
		this.sheet = sheet;
		chunks = new Array();
		
		this.chunk_dimensions = chunk_dimensions;
		this.z_multiplier = z_multiplier;
		
	}
	
	public inline function chunk(x) { return Std.int(x * inv_chunk_dimensions); }

	public function updateChunkRect(tile_x, tile_y, tile_w, tile_h)
	{
		var cx = Std.int(tile_x / chunk_dimensions);
		var cy = Std.int(tile_y / chunk_dimensions);
		var cw = Std.int((tile_x+tile_w) / chunk_dimensions) - cx + 1;
		var ch = Std.int((tile_y+tile_h) / chunk_dimensions) - cy + 1;
		
		for (y in cy...(cy+ch))
		{
			for (x in cx...(cx+cw))
			{
				updateChunk(x, y);
			}
		}
		
	}
	
	public function updateChunk(ck_x : Int, ck_y : Int)
	{
		
		var ck = chunks[Std.int(ck_x + ck_y * chunks_width)];
		ck.reset();
		
		var tx = ck_x * chunk_dimensions;
		var ty = ck_y * chunk_dimensions;
		
		var pt = new Point(0., 0.);
		var offset = new Point(0., 0.);
		var uv = new Rectangle(0., 0., 1., 1.);
		var stw = grid.twidth;
		var sth = grid.theight;
		
		for (y in ty...(ty+chunk_dimensions))
		{
			var z = y * z_multiplier;
			var z1 = z + z_multiplier;
			for (x in tx...(tx+chunk_dimensions))
			{
				var frame = grid.c2t(x,y);
				if (frame >= 0)
				{
					pt.x = x * stw; pt.y = y * sth;
					ck.writeSprite(pt, sheet.tiles[frame].rect, z, z, z1, z1, sheet.tiles[frame].uv, offset);
				}
			}
		}
	}
	
	public function resize(width, height, context : Context3D)
	{
		grid.worldW = width;
		grid.worldH = height;
		while (Std.int(grid.world.length) < width * height)
			grid.world.push(0);
		while (Std.int(grid.world.length) > width * height)
			grid.world.pop();
		recache(context);
	}

	public function recache(context : Context3D)
	{
		this.inv_chunk_dimensions = 1./chunk_dimensions;
		
		chunks_width = Math.ceil(grid.worldW * inv_chunk_dimensions);
		chunks_height = Math.ceil(grid.worldH * inv_chunk_dimensions);
		while (chunks.length < chunks_width * chunks_height)		
		{
			chunks.push(new Quads2PointFiveD(context));
		}
		while (chunks.length > chunks_width * chunks_height)
		{
			var ck = chunks.shift();
			ck.dispose();
		}
		
		for (y in 0...chunks_height)
		{
			for (x in 0...chunks_width)
			{
				updateChunk(x, y);
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
	
	public inline function zOfY(ypixels : Float, ytiles : Float)
	{
		return ((ypixels / grid.theight) + ytiles) * z_multiplier;
	}
	
}