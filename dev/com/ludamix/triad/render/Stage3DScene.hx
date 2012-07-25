package com.ludamix.triad.render;

import flash.Lib;
import flash.Vector;
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
import nme.utils.ByteArray;
import nme.utils.Endian;

typedef VFloat = Vector<Float>;

class Stage3DScene
{

	public var stage : flash.display.Stage;
	public var projection : Matrix3D;
	public var s : flash.display.Stage3D;
	public var c : flash.display3D.Context3D;
	public var shader : Texture2DShader;
	public var shader_color : Texture2DColorShader;
	public var tilesheets : Array<XTilesheet>;
	public var bytebuf_vert : ByteArray;
	public var bytebuf_idx : ByteArray;
	public var idx_count : Int;
	
	public var prof : Array<{time:Float,dist:Float,name:String}>;
	
	public function new(stage : Stage, ?callWhenReady : flash.events.Event->Void)
	{
		this.stage = stage;
		s = stage.stage3Ds[0];
		s.addEventListener( flash.events.Event.CONTEXT3D_CREATE, onReady );
		if (callWhenReady!=null)
			s.addEventListener( flash.events.Event.CONTEXT3D_CREATE, callWhenReady );
		#if flash11_4
		s.requestContext3D(Context3DRenderMode.AUTO, Context3DProfile.BASELINE_CONSTRAINED);
		#else
		s.requestContext3D("auto");
		#end
		tilesheets = new Array();
		bytebuf_vert = new ByteArray();
		bytebuf_idx = new ByteArray();
		bytebuf_vert.endian = Endian.LITTLE_ENDIAN;
		bytebuf_idx.endian = Endian.LITTLE_ENDIAN;
	}
	
	function onReady( _ ) 
	{
		c = s.context3D;
		c.enableErrorChecking = false;
		c.configureBackBuffer( stage.stageWidth, stage.stageHeight, 0, true );
		
		shader = new Texture2DShader(c);
		shader_color = new Texture2DColorShader(c);		
	}
	
	public function addTilesheet(ts : XTilesheet)
	{
		tilesheets.push(ts);
		ts.texture = c.createTexture(ts.nmeBitmap.width, ts.nmeBitmap.height,
			flash.display3D.Context3DTextureFormat.BGRA, false);
		ts.texture.uploadFromBitmapData(ts.nmeBitmap);
	}
	
	private inline function resetCounts()
	{
		idx_count = 0;
		bytebuf_idx.position = 0;
		bytebuf_vert.position = 0;
	}
	
	public inline function clear(r=0.,g=0.,b=0.,a=1.,depth=1.,stencil:UInt=0,mask:UInt=0xFFFFFFFF)
	{
		c.clear(r, g, b, a, depth, stencil, mask);		
		c.setDepthTest( true, flash.display3D.Context3DCompareMode.LESS_EQUAL );
		c.setCulling(flash.display3D.Context3DTriangleFace.BACK );
		c.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
		projection = createOrthographicProjectionMatrix(stage.stageWidth, stage.stageHeight, -1., 1.);
		resetCounts();
		prof = new Array();
	}
	
	public inline function present()
	{
		c.present();
		// profile infos
		var s = new Array<Array<Dynamic>>();
		for (n in prof)
			s.push([n.dist,n.name]);
		//trace(s);
	}
	
	public inline function doProf(name:String)
	{
		/*if (prof.length == 0)
			prof.push( { time:Lib.getTimer(), dist:0, name:name } );
		else
		{
			var t = Lib.getTimer();
			prof.push( { time:t, dist:t - prof[prof.length-1].time,name:name } );
		}*/
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
	
	public inline function writeVert(
		x : Float, y : Float, u : Float, v : Float)
	{
		bytebuf_vert.writeFloat(x);
		bytebuf_vert.writeFloat(y);
		bytebuf_vert.writeFloat(u);
		bytebuf_vert.writeFloat(v);
		++idx_count;
	}
	
	public inline function writeQuad(
		tl_x : Float, tl_y : Float, tr_x : Float, tr_y : Float, 
		bl_x : Float, bl_y : Float, br_x : Float, br_y : Float,
		tleft : Float, ttop : Float, tright : Float, tbottom : Float)
	{
		writeVert(tl_x, tl_y, tleft, ttop);
		writeVert(tr_x, tr_y, tright, ttop);
		writeVert(br_x, br_y, tright, tbottom);
		writeVert(tl_x, tl_y, tleft, ttop);
		writeVert(br_x, br_y, tright, tbottom);
		writeVert(bl_x, bl_y, tleft, tbottom);
	}
	
	public inline function writeColorVert(
		x : Float, y : Float, u : Float, v : Float, r : Float, g : Float, b : Float, a : Float)
	{
		bytebuf_vert.writeFloat(x);
		bytebuf_vert.writeFloat(y);
		bytebuf_vert.writeFloat(u);
		bytebuf_vert.writeFloat(v);
		bytebuf_vert.writeFloat(r);
		bytebuf_vert.writeFloat(g);
		bytebuf_vert.writeFloat(b);
		bytebuf_vert.writeFloat(a);
		++idx_count;
	}
	
	public inline function writeColorQuad(
		tl_x : Float, tl_y : Float, tr_x : Float, tr_y : Float, 
		bl_x : Float, bl_y : Float, br_x : Float, br_y : Float,
		tleft : Float, ttop : Float, tright : Float, tbottom : Float,
		r : Float, g : Float, b : Float, a : Float)
	{
		writeColorVert(tl_x, tl_y, tleft, ttop, r, g, b, a);
		writeColorVert(tr_x, tr_y, tright, ttop, r, g, b, a);
		writeColorVert(br_x, br_y, tright, tbottom, r, g, b, a);
		writeColorVert(tl_x, tl_y, tleft, ttop, r, g, b, a);
		writeColorVert(br_x, br_y, tright, tbottom, r, g, b, a);
		writeColorVert(bl_x, bl_y, tleft, tbottom, r, g, b, a);
	}
	
	private inline function padIBuf()
	{
		while (Std.int(bytebuf_idx.length) < idx_count * 2) // fill out the index buffer with incrementing values
		{
			bytebuf_idx.writeShort(bytebuf_idx.position >> 1);
		}	
	}
	
	public inline function runShader(sheet : XTilesheet)
	{
		shader.init(
			{ mproj : projection },
			{ tex : sheet.texture }
		);
		
		padIBuf();
		
		var ibuf = c.createIndexBuffer(idx_count); ibuf.uploadFromByteArray(bytebuf_idx, 0, 0, idx_count);
		var vbuf = c.createVertexBuffer(idx_count, 4); vbuf.uploadFromByteArray(bytebuf_vert, 0, 0, idx_count);
		
		resetCounts();
		
		shader.bind(vbuf);
		c.drawTriangles(ibuf);
		
		shader.unbind();
		
		vbuf.dispose();
		ibuf.dispose();
	}
	
	public inline function runColorShader(sheet : XTilesheet)
	{
		shader_color.init(
			{ mproj : projection },
			{ tex : sheet.texture }
		);
		
		padIBuf();
		
		var ibuf = c.createIndexBuffer(idx_count); ibuf.uploadFromByteArray(bytebuf_idx, 0, 0, idx_count);
		var vbuf = c.createVertexBuffer(idx_count, 8); vbuf.uploadFromByteArray(bytebuf_vert, 0, 0, idx_count);
		resetCounts();
		
		shader_color.bind(vbuf);
		c.drawTriangles(ibuf);
		
		shader_color.unbind();
		
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

class Texture2DColorShader extends format.hxsl.Shader {

	static var SRC = {
		var input : {
			pos : Float2,
			uv : Float2,
			rgba : Float4,
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
