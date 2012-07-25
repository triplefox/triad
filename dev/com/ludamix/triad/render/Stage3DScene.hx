package com.ludamix.triad.render;

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
import flash.display3D.textures.Texture;
import format.agal.Tools;
import nme.display.StageScaleMode;
import nme.utils.ByteArray;
import nme.utils.Endian;

typedef VFloat = Vector<Float>;

class Stage3DBuffer
{

	public var bytebuf_vert : ByteArray;
	public var bytebuf_idx : ByteArray;
	public var idx_count : Int;
	public var idx_max : Int;
	public var quad_count : Int;
	public var quad_max : Int;
	
	public function new()
	{
		bytebuf_vert = new ByteArray();
		bytebuf_idx = new ByteArray();
		bytebuf_vert.endian = Endian.LITTLE_ENDIAN;
		bytebuf_idx.endian = Endian.LITTLE_ENDIAN;
	}
	
	public inline function resetCounts()
	{
		idx_count = 0;
		idx_max = 0;
		quad_count = 0;
		quad_max = 0;
		bytebuf_idx.position = 0;
		bytebuf_vert.position = 0;
	}
	
	public inline function writeVert(x : Float, y :Float, u : Float, v : Float)
	{
		bytebuf_vert.writeFloat(x);
		bytebuf_vert.writeFloat(y);
		bytebuf_vert.writeFloat(u);
		bytebuf_vert.writeFloat(v);
		bytebuf_idx.writeShort(idx_count);
		++idx_count;
	}
	
	public inline function writeColorVert(x : Float, y :Float, u : Float, v : Float, 
		r : Float, g : Float, b : Float, a :Float)
	{
		bytebuf_vert.writeFloat(x);
		bytebuf_vert.writeFloat(y);
		bytebuf_vert.writeFloat(u);
		bytebuf_vert.writeFloat(v);
		bytebuf_vert.writeFloat(r);
		bytebuf_vert.writeFloat(g);
		bytebuf_vert.writeFloat(b);
		bytebuf_vert.writeFloat(a);
		bytebuf_idx.writeShort(idx_count);
		++idx_count;
	}
	
	public inline function seekQuad(n : Int)
	{
		if (idx_count > idx_max) idx_max = idx_count;
		idx_count = n;
		bytebuf_idx.position = 6 * 2 * n;
		bytebuf_vert.position = 6 * 4 * n;
	}
	
	public inline function seekColorQuad(n : Int)
	{
		if (idx_count > idx_max) idx_max = idx_count;
		idx_count = n;
		bytebuf_idx.position = 6 * 2 * n;
		bytebuf_vert.position = 6 * 8 * n;
	}
	
	public inline function writeQuad(
		tl_x : Float, tl_y : Float, tr_x : Float, tr_y : Float, 
		bl_x : Float, bl_y : Float, br_x : Float, br_y : Float,
		tluv_x : Float, tluv_y : Float, truv_x : Float, truv_y : Float,
		bluv_x : Float, bluv_y : Float, bruv_x : Float, bruv_y : Float
		)
	{
		
		writeVert(tl_x, tl_y, tluv_x, truv_y);
		writeVert(tr_x, tr_y, truv_x, truv_y);
		writeVert(br_x, br_y, bruv_x, bruv_y);
		writeVert(tl_x, tl_y, tluv_x, tluv_y);
		writeVert(br_x, br_y, bruv_x, bruv_y);
		writeVert(bl_x, bl_y, bluv_x, bluv_y);
		
		quad_count++;
		
	}
	
	public inline function writeColorQuad(
		tl_x : Float, tl_y : Float, tr_x : Float, tr_y : Float, 
		bl_x : Float, bl_y : Float, br_x : Float, br_y : Float,
		tluv_x : Float, tluv_y : Float, truv_x : Float, truv_y : Float,
		bluv_x : Float, bluv_y : Float, bruv_x : Float, bruv_y : Float,
		r : Float, g : Float, b : Float, a : Float
		)
	{
		
		writeColorVert(tl_x, tl_y, tluv_x, truv_y, r, g, b, a);
		writeColorVert(tr_x, tr_y, truv_x, truv_y, r, g, b, a);
		writeColorVert(br_x, br_y, bruv_x, bruv_y, r, g, b, a);
		writeColorVert(tl_x, tl_y, tluv_x, tluv_y, r, g, b, a);
		writeColorVert(br_x, br_y, bruv_x, bruv_y, r, g, b, a);
		writeColorVert(bl_x, bl_y, bluv_x, bluv_y, r, g, b, a);
		
		quad_count++;
		
	}
	
	public inline function write4ColorQuad(
		tl_x : Float, tl_y : Float, tr_x : Float, tr_y : Float, 
		bl_x : Float, bl_y : Float, br_x : Float, br_y : Float,
		tluv_x : Float, tluv_y : Float, truv_x : Float, truv_y : Float,
		bluv_x : Float, bluv_y : Float, bruv_x : Float, bruv_y : Float,
		tl_r : Float, tl_g : Float, tl_b : Float, tl_a : Float,
		tr_r : Float, tr_g : Float, tr_b : Float, tr_a : Float,
		bl_r : Float, bl_g : Float, bl_b : Float, bl_a : Float,
		br_r : Float, br_g : Float, br_b : Float, br_a : Float
		)
	{
		
		writeColorVert(tl_x, tl_y, tluv_x, truv_y, tl_r, tl_g, tl_b, tl_a);
		writeColorVert(tr_x, tr_y, truv_x, truv_y, tr_r, tr_g, tr_b, tr_a);
		writeColorVert(br_x, br_y, bruv_x, bruv_y, br_r, br_g, br_b, br_a);
		writeColorVert(tl_x, tl_y, tluv_x, tluv_y, tl_r, tl_g, tl_b, tl_a);
		writeColorVert(br_x, br_y, bruv_x, bruv_y, br_r, br_g, br_b, br_a);
		writeColorVert(bl_x, bl_y, bluv_x, bluv_y, bl_r, bl_g, bl_b, bl_a);
		
		quad_count++;
		
	}
	
}

class Stage3DScene
{

	public var stage : flash.display.Stage;
	public var projection : Matrix3D;
	public var s : flash.display.Stage3D;
	public var c : flash.display3D.Context3D;
	public var shader : Texture2DShader;
	public var color_shader : TextureColor2DShader;
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
		
		shader = new Texture2DShader(c);		
		color_shader = new TextureColor2DShader(c);
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
		projection = createOrthographicProjectionMatrix(stage.stageWidth, stage.stageHeight, -1., 1.);
	}
	
	public inline function present()
	{
		c.present();
	}
	
	private function createOrthographicProjectionMatrix(viewWidth : Float, viewHeight : Float, 
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
	
	public inline function runShader(sheet : XTilesheet, buffer : Stage3DBuffer)
	{
		
		shader.init(
			{ mproj : projection },
			{ tex : sheet.texture }
		);
		
		buffer.seekQuad(buffer.idx_count);
		var idx_count = buffer.idx_max;
		var bytebuf_idx = buffer.bytebuf_idx;
		var bytebuf_vert = buffer.bytebuf_vert;
		
		var ibuf = c.createIndexBuffer(idx_count); ibuf.uploadFromByteArray(bytebuf_idx, 0, 0, idx_count);
		var vbuf = c.createVertexBuffer(idx_count, 4); vbuf.uploadFromByteArray(bytebuf_vert, 0, 0, idx_count);
		
		shader.bind(vbuf);
		c.drawTriangles(ibuf);
		
		shader.unbind();
		
		vbuf.dispose();
		ibuf.dispose();
		
	}
	
	public inline function runColorShader(sheet : XTilesheet, buffer : Stage3DBuffer)
	{
		
		color_shader.init(
			{ mproj : projection },
			{ tex : sheet.texture }
		);
		
		buffer.seekColorQuad(buffer.idx_count);
		var idx_count = buffer.idx_max;
		var bytebuf_idx = buffer.bytebuf_idx;
		var bytebuf_vert = buffer.bytebuf_vert;
		
		var ibuf = c.createIndexBuffer(idx_count); ibuf.uploadFromByteArray(bytebuf_idx, 0, 0, idx_count);
		var vbuf = c.createVertexBuffer(idx_count, 8); vbuf.uploadFromByteArray(bytebuf_vert, 0, 0, idx_count);
		
		color_shader.bind(vbuf);
		c.drawTriangles(ibuf);
		
		color_shader.unbind();
		
		vbuf.dispose();
		ibuf.dispose();
		
	}
	
}

class Texture2DShader extends format.hxsl.Shader {

	static var SRC = {
		var input : {
			pos : Float2,
			uv : Float2,
		};
		var tuv : Float2;
		function vertex( mproj : M44 ) {
			out = pos.xyzw * mproj;
			tuv = uv;
		}
		function fragment( tex : Texture ) {
			out = tex.get(tuv);
		}
	};

}

class TextureColor2DShader extends format.hxsl.Shader {

	static var SRC = {
		var input : {
			pos : Float2,
			uv : Float2,
			rgba : Float4
		};
		var tuv : Float2;
		var trgba : Float4;
		function vertex( mproj : M44 ) {
			out = pos.xyzw * mproj;
			tuv = uv;
			trgba = rgba;
		}
		function fragment( tex : Texture ) {
			out = tex.get(tuv) * trgba;
		}
	};

}
