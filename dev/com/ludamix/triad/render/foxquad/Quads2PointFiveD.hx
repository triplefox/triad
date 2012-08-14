package com.ludamix.triad.render.foxquad;
import com.ludamix.triad.grid.AutotileBoard;
import com.ludamix.triad.render.SpriteRenderer;
import com.ludamix.triad.render.GraphicsResource;
import com.ludamix.triad.render.XTilesheet;
import com.ludamix.triad.tools.FloatPlayhead;
import flash.display3D.textures.Texture;
import flash.geom.Matrix;
import nme.geom.Point;
import nme.geom.Rectangle;
import nme.utils.ByteArray;

/*
 * 2D textured quads, with the ability to specify an independent z coordinate on each vertex.
 * Useful for views with simulated perspective.
 * */
class Quads2PointFiveD
{

	public var buffer : FoxQuadBuffer;
	public var texture : Texture;
	public var vert_count : Int;
	public var idx_count : Int;
	public var quad_count : Int;
	public var mtx : Matrix;
	public var tl : Point;
	public var tr : Point;
	public var bl : Point;
	public var br : Point;

	public function new(context)
	{
		buffer = new FoxQuadBuffer(context);
		mtx = new Matrix();
		tl = new Point(0., 0.); tr = new Point(0., 0.);
		bl = new Point(0., 0.); br = new Point(0., 0.);
	}
	
	public function dispose()
	{
		buffer.dispose();
	}
	
	public static inline var BYTES_PER_VERTEX = 5;
	
	public inline function bytesInfo() : FQBytesInfo
	{
		return {floats_per_vertex:FLOATS_PER_VERTEX, vert_count:vert_count, index_count:idx_count};
	}
	
	public inline function runShader(shader : Dynamic, shader_vertex : Dynamic, shader_fragment : Dynamic)
	{
		buffer.runShader(shader, shader_vertex, shader_fragment, bytesInfo());
	}
	
	public inline function reset()
	{
		vert_count = 0;
		idx_count = 0;
		quad_count = 0;
		var bytebuf_vert = buffer.getVertexBuffer();
		var bytebuf_idx = buffer.getIndexBuffer();
		bytebuf_vert.position = 0;
		bytebuf_idx.position = 0;
	}
	
	@:extern private inline function writeVertex(bytebuf_vert : ByteArray, x : Float, y :Float, 
		z : Float, u : Float, v : Float)
	{
		bytebuf_vert.writeFloat(x);
		bytebuf_vert.writeFloat(y);
		bytebuf_vert.writeFloat(z);
		bytebuf_vert.writeFloat(u);
		bytebuf_vert.writeFloat(v);	
	}
	
	@:extern public inline function writeQuadPoints(
		tl_x : Float, tl_y : Float, tl_z : Float, tr_x : Float, tr_y : Float, tr_z : Float,
		bl_x : Float, bl_y : Float, bl_z : Float, br_x : Float, br_y : Float, br_z : Float,
		tluv_x : Float, tluv_y : Float, truv_x : Float, truv_y : Float,
		bluv_x : Float, bluv_y : Float, bruv_x : Float, bruv_y : Float
	)
	{
		var bytebuf_vert = buffer.getVertexBuffer();
		var bytebuf_idx = buffer.getIndexBuffer();
		writeVertex(bytebuf_vert, tl_x, tl_y, tl_z, tluv_x, truv_y); // 0
		writeVertex(bytebuf_vert, tr_x, tr_y, tr_z, truv_x, truv_y); // 1
		writeVertex(bytebuf_vert, br_x, br_y, br_z, bruv_x, bruv_y); // 2
		writeVertex(bytebuf_vert, bl_x, bl_y, bl_z, bluv_x, bluv_y); // 3
		
		bytebuf_idx.writeShort(vert_count);
		bytebuf_idx.writeShort(vert_count + 1);		
		bytebuf_idx.writeShort(vert_count + 2);		
		bytebuf_idx.writeShort(vert_count);		
		bytebuf_idx.writeShort(vert_count + 2);		
		bytebuf_idx.writeShort(vert_count + 3);		
		
		vert_count += 4;
		idx_count += 6;		
		quad_count++;		
	}
	
	// how do we deal with the additional coordinate on these functions?
	// z per vert is one way, I guess.
	
	@:extern public inline function writeRect(pos : Rectangle, tlz : Float, trz : Float, blz : Float, brz : Float, 
		uv : Rectangle, offset : Point)
	{
		writeQuadPoints(pos.left - offset.x, pos.top - offset.y, tlz,
						pos.right - offset.x, pos.top - offset.y, trz,
						pos.left - offset.x, pos.bottom - offset.y, blz,
						pos.right - offset.x, pos.bottom - offset.y, brz,
						uv.left, uv.top,   uv.right,  uv.top,  uv.left,  uv.bottom,  uv.right,  uv.bottom);		
	}
	
	@:extern public inline function writeTransformedRect(pos : Rectangle, 
		tlz : Float, trz : Float, blz : Float, brz : Float,
		uv : Rectangle, offset : Point, radians : Float, scaleX : Float, scaleY : Float)
	{
		tl.x = 0.;       tl.y = 0.;
		tr.x = pos.width; tr.y = 0.;
		bl.x = 0.;       bl.y = pos.height;
		br.x = pos.width; br.y = pos.height;
		
		mtx.identity();
		mtx.translate(-offset.x, -offset.y);
		mtx.scale(scaleX, scaleY);
		mtx.rotate(radians);
		mtx.translate(pos.x, pos.y);
		
		tl = mtx.transformPoint(tl);
		tr = mtx.transformPoint(tr); 
		bl = mtx.transformPoint(bl);
		br = mtx.transformPoint(br);
		
		writeQuadPoints(tl.x, tl.y, tlz, tr.x, tr.y, trz,
						bl.x, bl.y, blz, br.x, br.y, brz,
						uv.left, uv.top, uv.right, uv.top,
						uv.left, uv.bottom, uv.right, uv.bottom);
	}
	
	@:extern public inline function writeSprite(pos : Point, rect : Rectangle,
		tlz : Float, trz : Float, blz : Float, brz : Float,
		uv : Rectangle, offset : Point)
	{
		writeQuadPoints(pos.x - offset.x,            pos.y - offset.y, tlz, 
						pos.x + rect.width - offset.x, pos.y - offset.y, trz, 
						pos.x - offset.x,            pos.y + rect.height - offset.y, blz,
						pos.x + rect.width - offset.x, pos.y + rect.height - offset.y, brz,				
						uv.left, uv.top,   uv.right,  uv.top,  uv.left,  uv.bottom,  uv.right,  uv.bottom);		
	}
	
	@:extern public inline function writeTransformedSprite(pos : Point, rect : Rectangle,
		tlz : Float, trz : Float, blz : Float, brz : Float,	
		uv : Rectangle, offset : Point, 
		radians : Float, scaleX : Float, scaleY : Float)
	{
		tl.x = 0.;       tl.y = 0.;
		tr.x = rect.width; tr.y = 0.;
		bl.x = 0.;       bl.y = rect.height;
		br.x = rect.width; br.y = rect.height;
		
		mtx.identity();
		mtx.translate(-offset.x, -offset.y);
		mtx.scale(scaleX, scaleY);
		mtx.rotate(radians);
		mtx.translate(pos.x, pos.y);
		
		tl = mtx.transformPoint(tl);
		tr = mtx.transformPoint(tr); 
		bl = mtx.transformPoint(bl);
		br = mtx.transformPoint(br);
		
		writeQuadPoints(tl.x, tl.y, tlz, tr.x, tr.y, trz,
						bl.x, bl.y, blz, br.x, br.y, brz,
						uv.left, uv.top, uv.right, uv.top,
						uv.left, uv.bottom, uv.right, uv.bottom);
	}
	
	@:extern public inline function writeXTile(pos : Point,
		tlz : Float, trz : Float, blz : Float, brz : Float, 
		tile : XTile)
	{
		writeSprite(pos, tlz, trz, blz, brz, tile.rect, tile.uv, tile.offset);
	}
	
	@:extern public inline function writeTransformedXTile(pos : Point, 
		tlz : Float, trz : Float, blz : Float, brz : Float, 
		tile : XTile, radians : Float, 
		scaleX : Float, scaleY : Float)
	{
		writeTransformedSprite(pos, tlz, trz, blz, brz, tile.rect, tile.uv, tile.offset, radians, scaleX, scaleY);
	}

}

