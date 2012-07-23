package com.ludamix.triad.render;

import flash.Vector;
import flash.geom.Matrix3D;
import flash.display.Stage;
import flash.display.Stage3D;
import flash.display3D.Context3D;
import flash.display3D.Context3DCompareMode;
import flash.display3D.Context3DRenderMode;
import flash.display3D.Context3DTextureFormat;
import flash.display3D.textures.Texture;

typedef VFloat = Vector<Float>;

class Stage3DScene
{

	public var stage : flash.display.Stage;
	public var s : flash.display.Stage3D;
	public var c : flash.display3D.Context3D;
	public var shader : Texture2DShader;
	public var shader_color : Texture2DColorShader;
	public var tilesheets : Array<XTilesheet>;
	
	public function new(stage : Stage, ?callWhenReady : flash.events.Event->Void)
	{
		this.stage = stage;
		s = stage.stage3Ds[0];
		s.addEventListener( flash.events.Event.CONTEXT3D_CREATE, onReady );
		if (callWhenReady!=null)
			s.addEventListener( flash.events.Event.CONTEXT3D_CREATE, callWhenReady );
		s.requestContext3D();
		tilesheets = new Array();
	}
	
	function onReady( _ ) 
	{
		c = s.context3D;
		c.enableErrorChecking = true;
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
	
	public inline function clear()
	{
		c.clear(0, 0, 0, 1);
		c.setDepthTest( true, flash.display3D.Context3DCompareMode.LESS_EQUAL );
		c.setCulling(flash.display3D.Context3DTriangleFace.BACK);	
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
	
	public inline function writeVert(buf : Vector<Float>, idx : Vector<UInt>, 
		x : Float, y : Float, z : Float, u : Float, v : Float)
	{
		buf.push(x);
		buf.push(y);
		buf.push(z);
		buf.push(u);
		buf.push(v);
		idx.push(idx.length);
	}
	
	public inline function writeQuad(buf : Vector<Float>, idx : Vector<UInt>, 
		tl, tr, bl, br, tleft, ttop, tright, tbottom)
	{
		writeVert(buf, idx, tl.x, tl.y, 0., tleft, ttop);
		writeVert(buf, idx, tr.x, tr.y, 0., tright, ttop);
		writeVert(buf, idx, br.x, br.y, 0., tright, tbottom);
		writeVert(buf, idx, tl.x, tl.y, 0., tleft, ttop);
		writeVert(buf, idx, br.x, br.y, 0., tright, tbottom);
		writeVert(buf, idx, bl.x, bl.y, 0., tleft, tbottom);
	}
	
	public inline function writeColorVert(buf : Vector<Float>, idx : Vector<UInt>, 
		x : Float, y : Float, z : Float, u : Float, v : Float, r : Float, g : Float, b : Float, a : Float)
	{
		buf.push(x);
		buf.push(y);
		buf.push(z);
		buf.push(u);
		buf.push(v);
		buf.push(r);
		buf.push(g);
		buf.push(b);
		buf.push(a);
		idx.push(idx.length);
	}
	
	public inline function writeColorQuad(buf : Vector<Float>, idx : Vector<UInt>, 
		tl, tr, bl, br, tleft, ttop, tright, tbottom, r, g, b, a)
	{
		writeColorVert(buf, idx, tl.x, tl.y, 0., tleft, ttop, r, g, b, a);
		writeColorVert(buf, idx, tr.x, tr.y, 0., tright, ttop, r, g, b, a);
		writeColorVert(buf, idx, br.x, br.y, 0., tright, tbottom, r, g, b, a);
		writeColorVert(buf, idx, tl.x, tl.y, 0., tleft, ttop, r, g, b, a);
		writeColorVert(buf, idx, br.x, br.y, 0., tright, tbottom, r, g, b, a);
		writeColorVert(buf, idx, bl.x, bl.y, 0., tleft, tbottom, r, g, b, a);
	}
	
	inline function doUpload(buf : Vector<Float>, idx : Vector<UInt>, numQuads : Int)
	{
		var points = numQuads * 6;
		var ibuf = c.createIndexBuffer(idx.length); ibuf.uploadFromVector(idx, 0, idx.length);
		var vbuf = c.createVertexBuffer(points, 5); vbuf.uploadFromVector(buf, 0, points);
		return { idx:ibuf, vertex:vbuf };
	}

	inline function doUploadColor(buf : Vector<Float>, idx : Vector<UInt>, numQuads : Int)
	{
		var points = numQuads * 6;
		var ibuf = c.createIndexBuffer(idx.length); ibuf.uploadFromVector(idx, 0, idx.length);
		var vbuf = c.createVertexBuffer(points, 9); vbuf.uploadFromVector(buf, 0, points);
		return { idx:ibuf, vertex:vbuf };
	}
	
	public inline function runShader(buf : Vector<Float>, idx : Vector<UInt>, numQuads : Int, sheet : XTilesheet)
	{
		shader.init(
			{ mproj : createOrthographicProjectionMatrix(Main.W, Main.H, -1., 1.) },
			{ tex : sheet.texture }
		);	
		
		var result = doUpload(buf, idx, numQuads);
		
		shader.bind(result.vertex);
		c.drawTriangles(result.idx);
		
		shader.unbind();
		
		result.vertex.dispose();
		result.idx.dispose();
	}
	
	public inline function runColorShader(buf : Vector<Float>, idx : Vector<UInt>, numQuads : Int, sheet : XTilesheet)
	{
		shader_color.init(
			{ mproj : createOrthographicProjectionMatrix(Main.W, Main.H, -1., 1.) },
			{ tex : sheet.texture }
		);
		
		var result = doUploadColor(buf, idx, numQuads);
		
		shader_color.bind(result.vertex);
		c.drawTriangles(result.idx);
		
		shader_color.unbind();
		
		result.vertex.dispose();
		result.idx.dispose();
	}
	
}

class Texture2DShader extends format.hxsl.Shader {

	static var SRC = {
		var input : {
			pos : Float3,
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
			pos : Float3,
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
