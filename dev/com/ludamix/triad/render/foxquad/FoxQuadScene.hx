package com.ludamix.triad.render.foxquad;

#if flash11

import com.ludamix.triad.render.XTilesheet;
import flash.Lib;
import flash.Vector;
import flash.geom.Vector3D;
import flash.geom.Matrix3D;
import flash.geom.Point;
import flash.display.Stage;
import flash.display.Stage3D;
import flash.display3D.Context3D;
import flash.display3D.Context3DBlendFactor;
import flash.display3D.Context3DCompareMode;
import flash.display3D.Context3DRenderMode;
import flash.display3D.Context3DTextureFormat;
import flash.display3D.IndexBuffer3D;
import flash.display3D.VertexBuffer3D;
import flash.display3D.textures.Texture;
import format.agal.Tools;
import nme.display.StageScaleMode;
import nme.utils.ByteArray;
import nme.utils.Endian;

/*
 * 
 * This is a Stage3D low-level framework, still primarily focused on 2D applications.
 * 
 * Unlike the Stage3D classes in triad.render - which aim for some general NME compatibility,
 * this one is trying to push the featureset of the API. Pick one or the other as needs warrant.
 * 
 * */

typedef VFloat = Vector<Float>;

typedef FQBytesInfo = { floats_per_vertex:Int, vert_count:Int, index_count:Int };

class FoxQuadBuffer
{

	// A single vertex/index pairing with bytearray access, automatically cached on the GPU.
	// User defines what type of buffers they are.

	private var buf_vert : VertexBuffer3D;
	private var buf_idx : IndexBuffer3D;
	private var bytebuf_vert : ByteArray;
	private var bytebuf_idx : ByteArray;
	public var context : Context3D;
	public var cached_vert : Bool;
	public var cached_idx : Bool;
	
	public function new(context)
	{
		bytebuf_vert = new ByteArray();
		bytebuf_idx = new ByteArray();
		bytebuf_vert.endian = Endian.LITTLE_ENDIAN;
		bytebuf_idx.endian = Endian.LITTLE_ENDIAN;
		this.context = context;
		cached_vert = false;
		cached_idx = false;
	}
	
	// we make a certain assumption here - if you are going to look at these buffers, you also intend to
	// manipulate them, and thus invalidate the cache.
	
	public inline function getVertexBuffer() { cached_vert = false; return bytebuf_vert; }
	public inline function getIndexBuffer() { cached_idx = false; return bytebuf_idx; }
	
	public function runShader(shader : Dynamic, shader_vertex : Dynamic, shader_fragment : Dynamic, 
		bytes_info : FQBytesInfo)
	{
		var index_count = bytes_info.index_count;
		var floats_per_vertex = bytes_info.floats_per_vertex;
		var num_verts = bytes_info.vert_count;
		if (num_verts == 0) return;
		
		shader.init(shader_vertex, shader_fragment);
		
		bytebuf_idx.position = 0;
		bytebuf_vert.position = 0;
		
		if (!cached_idx)
		{
			if (buf_idx != null) buf_idx.dispose();
			buf_idx = context.createIndexBuffer(index_count);
			buf_idx.uploadFromByteArray(bytebuf_idx, 0, 0, index_count);
			cached_idx = true;
		}
		if (!cached_vert)
		{
			if (buf_vert != null) buf_vert.dispose();
			buf_vert = context.createVertexBuffer(num_verts, floats_per_vertex);
			buf_vert.uploadFromByteArray(bytebuf_vert, 0, 0, num_verts);
			cached_vert = true;
		}
		
		shader.bind(buf_vert);
		context.drawTriangles(buf_idx);
		shader.unbind();
		
	}
	
	public function dispose()
	{
		if (buf_vert != null) buf_vert.dispose();
		if (buf_idx != null) buf_idx.dispose();
		buf_vert = null;
		buf_idx = null;
	}
	
}

class FoxQuadScene
{

	public var stage : flash.display.Stage;
	public var s : flash.display.Stage3D;
	public var c : flash.display3D.Context3D;
	public var tilesheets : Array<XTilesheet>;
	
	public function new(stage : Stage, ?callWhenReady : flash.events.Event->Void)
	{
		this.stage = stage;
		s = stage.stage3Ds[0];
		s.addEventListener( flash.events.Event.CONTEXT3D_CREATE, onReady );
		if (callWhenReady!=null)
			s.addEventListener( flash.events.Event.CONTEXT3D_CREATE, callWhenReady );
		s.requestContext3D("auto");
		
		tilesheets = new Array();
		
	}
	
	function onReady( _ ) 
	{
		c = s.context3D;
		c.enableErrorChecking = false;
		c.configureBackBuffer( stage.stageWidth, stage.stageHeight, 0, true );		
	}
	
	public function addTilesheet(ts : XTilesheet)
	{
		tilesheets.push(ts);
		ts.texture = c.createTexture(ts.nmeBitmap.width, ts.nmeBitmap.height,
			flash.display3D.Context3DTextureFormat.BGRA, false);
		ts.texture.uploadFromBitmapData(ts.nmeBitmap);
	}
	
	public inline function clear(r=0.,g=0.,b=0.,a=1.,depth=1.,stencil:UInt=0,mask:UInt=0xFFFFFFFF)
	{
		c.clear(r, g, b, a, depth, stencil, mask);		
		c.setDepthTest( true, flash.display3D.Context3DCompareMode.LESS_EQUAL );
		c.setCulling(flash.display3D.Context3DTriangleFace.BACK );
		c.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
	}
	
	public inline function present()
	{
		c.present();
	}
	
	public function createOrthographicProjectionMatrix(viewWidth : Float, viewHeight : Float, 
		near : Float, far : Float):Matrix3D
	{
		var left = 0.;
		var top = 0.;
		var right = viewWidth;
		var bottom = viewHeight;
		var add_rl = right + left;
		var sub_rl = right - left;
		var add_tb = top + bottom;
		var sub_tb = top - bottom;
		var add_fn = far + near;
		var sub_fn = far - near;
		var mtx = new Matrix3D(
		(VFloat.ofArray([
			2 / sub_rl, 0, 0,  0,
			0,  2 / sub_tb, 0, 0,
			0,  0, 1 / sub_fn,   0,
			-add_rl/sub_rl, -add_tb/sub_tb, -add_fn/sub_fn, 1
		])));
		return mtx;
	}
	
}

#end