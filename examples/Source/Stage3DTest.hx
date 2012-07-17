import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.events.Event;
import flash.display.Stage3D;
import flash.display3D.Context3D;
import flash.display3D.Context3DCompareMode;
import flash.display3D.Context3DRenderMode;
import flash.display3D.Context3DTextureFormat;
import flash.geom.Matrix3D;
import flash.Lib;
import flash.Vector;
import format.agal.Tools;
import nme.Assets;

typedef K = flash.ui.Keyboard;
typedef FV = flash.Vector<Float>;
typedef Quad = { left:Float, top:Float, right:Float, bottom:Float, tleft:Float, ttop:Float, tright:Float, tbottom:Float };

// The next steps are:

// add shader modes for alpha and colorization - test against displaylist alpha and colorTransform
// add rotation and scaling (use a matrix to pretransform each quad)
// create an API over this for the sprite and tile renderers.

class Stage3DTest
{

	var stage : flash.display.Stage;
	var s : flash.display.Stage3D;
	var c : flash.display3D.Context3D;
	var shader : Texture2DShader;
	var keys : Array<Bool>;
	var texture : flash.display3D.textures.Texture;
	var bt : Bitmap;

	public function new() {
		haxe.Log.setColor(0xFF0000);
		keys = [];
		stage = flash.Lib.current.stage;
		s = stage.stage3Ds[0];
		s.addEventListener( flash.events.Event.CONTEXT3D_CREATE, onReady );
		stage.addEventListener( flash.events.KeyboardEvent.KEY_DOWN, callback(onKey,true) );
		stage.addEventListener( flash.events.KeyboardEvent.KEY_UP, callback(onKey,false) );
		flash.Lib.current.addEventListener(flash.events.Event.ENTER_FRAME, update);
		s.requestContext3D();
	}

	function onKey( down, e : flash.events.KeyboardEvent ) {
		keys[e.keyCode] = down;
	}

	function onReady( _ ) {
		c = s.context3D;
		c.enableErrorChecking = true;
		c.configureBackBuffer( stage.stageWidth, stage.stageHeight, 0, true );

		shader = new Texture2DShader(c);
		
		var bmp = SpritePacking.makePack();
		//var bmp = new BitmapData(256, 256, false, 0xFFFFFF);
		//bmp.noise(43);
		texture = c.createTexture(bmp.width, bmp.height, flash.display3D.Context3DTextureFormat.BGRA, false);
		texture.uploadFromBitmapData(bmp);		
		bt = new Bitmap(bmp); bt.x = 100; bt.y = 100; Lib.current.addChild(bt);
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
		left, top, right, bottom, tleft, ttop, tright, tbottom)
	{
		writeVert(buf, idx, left, top, 0., tleft, ttop);
		writeVert(buf, idx, right, top, 0., tright, ttop);
		writeVert(buf, idx, right, bottom, 0., tright, tbottom);
		writeVert(buf, idx, left, top, 0., tleft, ttop);
		writeVert(buf, idx, right, bottom, 0., tright, tbottom);
		writeVert(buf, idx, left, bottom, 0., tleft, tbottom);
	}
	
	public inline function doUpload(quads : Array<Quad>)
	{
		var idx = new Vector<UInt>();
		var buf = new Vector<Float>();
		var points = quads.length * 6;
		for (q in quads) writeQuad(buf, idx, q.left, q.top, q.right, q.bottom, q.tleft, q.ttop, q.tright, q.tbottom);
		var ibuf = c.createIndexBuffer(idx.length); ibuf.uploadFromVector(idx, 0, idx.length);
		var vbuf = c.createVertexBuffer(points, 5); vbuf.uploadFromVector(buf, 0, points);
		return { idx:ibuf, vertex:vbuf };
	}

	private function createOrthographicProjectionMatrix(viewWidth : Float, viewHeight : Float, near : Float, far : Float):Matrix3D
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
		(FV.ofArray([
			2 / sub_rl, 0, 0,  0,
			0,  2 / sub_tb, 0, 0,
			0,  0, 1 / sub_fn,   0,
			-add_rl/sub_rl, -add_tb/sub_tb, -add_fn/sub_fn, 1
		])));
		return mtx;
	}
	
	public static var alpha = 1.;
  
	function update(_) {
		if( c == null ) return;

		c.clear(0, 0, 0, 1);
		c.setDepthTest( true, flash.display3D.Context3DCompareMode.LESS_EQUAL );
		c.setCulling(flash.display3D.Context3DTriangleFace.BACK);

		//var light = new flash.geom.Vector3D(1.,0.,0.);
		//light.normalize();

		var frustum = new Matrix3D(); frustum.identity();
		
		shader.init(
			{ mpos : frustum, mproj : createOrthographicProjectionMatrix(Main.W, Main.H, -1., 1.), 
			 }, //light : light },
			{ tex : texture }
		);

		var q = { left:100., top:100., right: 100 + 256., bottom: 100 + 256., tleft:0., tright:1., ttop:0., tbottom:1. };
		
		var buf = doUpload([q]);
		
		shader.bind(buf.vertex);
		c.drawTriangles(buf.idx);
		c.present();
		
		buf.vertex.dispose();
		buf.idx.dispose();
		
		bt.alpha = alpha;
		alpha -= 0.01;
		if (alpha <= 0.) alpha = 1.;
		
	}

}

class ColorShader extends format.hxsl.Shader {

	static var SRC = {
		var input : {
			pos : Float3,
		};
		var color : Float3;
		function vertex( mpos : M44, mproj : M44 ) {
			out = pos.xyzw * mpos * mproj;
			color = pos;
		}
		function fragment() {
			out = color.xyzw;
		}
	};

}

class Texture2DShader extends format.hxsl.Shader {

	static var SRC = {
		var input : {
			pos : Float3,
			uv : Float2,
		};
		var tuv : Float2;
		function vertex( mpos : M44, mproj : M44 ) {
			out = pos.xyzw * mpos * mproj;
			tuv = uv;
		}
		function fragment( tex : Texture ) {
			out = tex.get(tuv);
		}
	};

}

class Texture2DColorShader extends format.hxsl.Shader {

	// so... we need to adjust the poly drawing routine to account for this batch type
	// this invalidates the simplicity of what I had before, oh well.

	static var SRC = {
		var input : {
			pos : Float3,
			uv : Float2,
			rgb : Float3,
			alpha : Float1
		};
		var tuv : Float2;
		var trgb : Float3;
		var talpha : Float1;
		function vertex( mpos : M44, mproj : M44 ) {
			out = pos.xyzw * mpos * mproj;
			tuv = uv;
		}
		function fragment( tex : Texture ) {
			out = tex.get(tuv);
		}
	};

}
