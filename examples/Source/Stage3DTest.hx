import com.ludamix.triad.render.XTilesheet;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.events.Event;
import flash.display.Stage3D;
import flash.display.Stage;
import flash.display3D.Context3D;
import flash.display3D.Context3DCompareMode;
import flash.display3D.Context3DRenderMode;
import flash.display3D.Context3DTextureFormat;
import flash.display3D.textures.Texture;
import flash.geom.Matrix3D;
import flash.Lib;
import flash.Vector;
import format.agal.Tools;
import nme.Assets;
import nme.geom.ColorTransform;
import nme.geom.Matrix;
import nme.geom.Point;
import nme.geom.Rectangle;

typedef K = flash.ui.Keyboard;
typedef FV = flash.Vector<Float>;
typedef Quad = { tl:Point, tr:Point, bl:Point, br:Point, tleft:Float, ttop:Float, tright:Float, tbottom:Float };
typedef RGBAQuad = { >Quad, r : Float, g : Float, b : Float, a : Float };

class Stage3DScene
{

	public var stage : flash.display.Stage;
	public var s : flash.display.Stage3D;
	public var c : flash.display3D.Context3D;
	public var shader : Texture2DShader;
	public var shader_color : Texture2DColorShader;
	public var tilesheets : Array<XTilesheet>;
	public var textures : Array<Texture>;
	
	public function new(stage : Stage)
	{
		this.stage = stage;
		s = stage.stage3Ds[0];
		s.addEventListener( flash.events.Event.CONTEXT3D_CREATE, onReady );
		s.requestContext3D();
		tilesheets = new Array();
		textures = new Array();
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
		textures.push(c.createTexture(ts.nmeBitmap.width, ts.nmeBitmap.height,
			flash.display3D.Context3DTextureFormat.BGRA, false));
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
		(FV.ofArray([
			2 / sub_rl, 0, 0,  0,
			0,  2 / sub_tb, 0, 0,
			0,  0, 1 / sub_fn,   0,
			-add_rl/sub_rl, -add_tb/sub_tb, -add_fn/sub_fn, 1
		])));
		return mtx;
	}
	
	// TODO: make the batch writers accept the drawTiles data instead of Quad objects,
	// and do their own matrix ops to perform rotations etc. as necessary.
	
/*	function writeBatch(quads : Array<Quad>)
	{
		shader.init(
			{ mproj : createOrthographicProjectionMatrix(Main.W, Main.H, -1., 1.) },
			{ tex : texture }
		);
		
		var buf = doUpload(quads);
		
		shader.bind(buf.vertex);
		c.drawTriangles(buf.idx);
		
		shader.unbind();
		
		buf.vertex.dispose();
		buf.idx.dispose();
	}
  
	function writeRGBABatch(quads : Array<RGBAQuad>)
	{
		shader_color.init(
			{ mproj : createOrthographicProjectionMatrix(Main.W, Main.H, -1., 1.) },
			{ tex : texture }
		);
		
		var buf = doUploadColor(quads);
		
		shader_color.bind(buf.vertex);
		c.drawTriangles(buf.idx);
		
		shader_color.unbind();
		
		buf.vertex.dispose();
		buf.idx.dispose();
		
	}
*/
}

class Stage3DTest
{

	var stage : Stage;
	var s : flash.display.Stage3D;
	var c : flash.display3D.Context3D;
	var shader : Texture2DShader;
	var shader_color : Texture2DColorShader;
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
		stage.color = 0x5555FF;
	}

	function onKey( down, e : flash.events.KeyboardEvent ) {
		keys[e.keyCode] = down;
	}

	function onReady( _ ) {
		c = s.context3D;
		c.enableErrorChecking = true;
		c.configureBackBuffer( stage.stageWidth, stage.stageHeight, 0, true );

		shader = new Texture2DShader(c);
		shader_color = new Texture2DColorShader(c);
		
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
	
	public inline function doUpload(quads : Array<Quad>)
	{
		var idx = new Vector<UInt>();
		var buf = new Vector<Float>();
		var points = quads.length * 6;
		for (q in quads) writeQuad(buf, idx, q.tl, q.tr, q.bl, q.br, q.tleft, q.ttop, q.tright, q.tbottom);
		var ibuf = c.createIndexBuffer(idx.length); ibuf.uploadFromVector(idx, 0, idx.length);
		var vbuf = c.createVertexBuffer(points, 5); vbuf.uploadFromVector(buf, 0, points);
		return { idx:ibuf, vertex:vbuf };
	}

	public inline function doUploadColor(quads : Array<RGBAQuad>)	
	{
		var idx = new Vector<UInt>();
		var buf = new Vector<Float>();
		var points = quads.length * 6;
		for (q in quads) 
			writeColorQuad(buf, idx, q.tl, q.tr, q.bl, q.br, q.tleft, q.ttop, q.tright, q.tbottom, 
							q.r,q.g,q.b,q.a);
		var ibuf = c.createIndexBuffer(idx.length); ibuf.uploadFromVector(idx, 0, idx.length);
		var vbuf = c.createVertexBuffer(points, 9); vbuf.uploadFromVector(buf, 0, points);
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
  
	function writeBatch(quads : Array<Quad>)
	{
		shader.init(
			{ mproj : createOrthographicProjectionMatrix(Main.W, Main.H, -1., 1.) },
			{ tex : texture }
		);
		
		var buf = doUpload(quads);
		
		shader.bind(buf.vertex);
		c.drawTriangles(buf.idx);
		
		shader.unbind();
		
		buf.vertex.dispose();
		buf.idx.dispose();
	}
  
	function writeRGBABatch(quads : Array<RGBAQuad>)
	{
		shader_color.init(
			{ mproj : createOrthographicProjectionMatrix(Main.W, Main.H, -1., 1.) },
			{ tex : texture }
		);
		
		var buf = doUploadColor(quads);
		
		shader_color.bind(buf.vertex);
		c.drawTriangles(buf.idx);
		
		shader_color.unbind();
		
		buf.vertex.dispose();
		buf.idx.dispose();
		
	}
	
	function buildTestQuad(left:Float,top:Float,right:Float,bottom:Float, mtx : Matrix) : RGBAQuad
	{
		var tl = new Point(left, top);
		var tr = new Point(right, top);
		var bl = new Point(left, bottom);
		var br = new Point(right, bottom);
		
		if (mtx != null)
		{
			tl = mtx.transformPoint(tl);
			tr = mtx.transformPoint(tr); 
			bl = mtx.transformPoint(bl);
			br = mtx.transformPoint(br);
		}	
		return {tl:tl,tr:tr,bl:bl,br:br,tleft:0.,tright:1.,ttop:0.,tbottom:1.,r:0.5,g:0.5,b:1.0,a:1.0};
	}
	
	function update(_) {
		if( c == null ) return;

		c.clear(0, 0, 0, 1);
		c.setDepthTest( true, flash.display3D.Context3DCompareMode.LESS_EQUAL );
		c.setCulling(flash.display3D.Context3DTriangleFace.BACK);
		
		var mtx = new Matrix();
		mtx.scale(1.6,1.6);
		mtx.translate(-bt.width/2,-bt.height/2);
		mtx.rotate(Math.PI/4);
		mtx.translate(200.,200.);
		
		var p = buildTestQuad(0.,0.,256.,256.,mtx);
		
		//writeBatch([q]);
		writeRGBABatch([p]);
		
		c.present();
		
		//bt.visible = false;
		bt.transform.matrix = mtx;
		//bt.transform.colorTransform = new ColorTransform(1.0, 0.5, 0.2, 1.0);
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
		function vertex( mproj : M44 ) {
			out = pos.xyzw * mproj;
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
