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
import format.agal.Tools;
import com.ludamix.triad.render.stage3d.UV;
import com.ludamix.triad.render.stage3d.Polygon;
import com.ludamix.triad.render.stage3d.Cube;
import com.ludamix.triad.render.stage3d.Vector;
import nme.Assets;

typedef K = flash.ui.Keyboard;
typedef FV = flash.Vector<Float>;

// The next steps are:

// shift from Polygon to a custom vertex batch
// add shader modes for alpha and colorization - test against displaylist alpha and colorTransform
// add rotation and scaling
// create an API over this for the sprite and tile renderers.

class Stage3DTest
{
	var stage : flash.display.Stage;
	var s : flash.display.Stage3D;
	var c : flash.display3D.Context3D;
	var shader : Texture2DShader;
	var pol : Polygon;
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

		/*pol = new Cube();
		pol.unindex();
		pol.addNormals();
		pol.addTCoords();
		pol.alloc(c);*/
		
		drawPoly(100., 100., 100+256.,100+256.);
		
		var bmp = SpritePacking.makePack();
		//var bmp = new BitmapData(256, 256, false, 0xFFFFFF);
		//bmp.noise(43);
		texture = c.createTexture(bmp.width, bmp.height, flash.display3D.Context3DTextureFormat.BGRA, false);
		texture.uploadFromBitmapData(bmp);		
		bt = new Bitmap(bmp); bt.x = 100; bt.y = 100; Lib.current.addChild(bt);
	}
	
	private inline function drawPoly(left, top, right, bottom)
	{
		pol = new Polygon([new Vector(left, top), new Vector(right, top), new Vector(right, bottom), 
			new Vector(left, top), new Vector(right, bottom), new Vector(left, bottom)]);
		var uleft = 0.;
		var uright = 1.;
		var utop = 0.;
		var ubottom = 1.;
		var z = new UV(uleft, utop);
		var x = new UV(uright, utop);
		var y = new UV(uleft, ubottom);
		var o = new UV(uright, ubottom);
		pol.tcoords = [z,x,o,z,o,y];
		pol.alloc(c);	
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

		shader.bind(pol.vbuf);
		c.drawTriangles(pol.ibuf);
		c.present();
		
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

class TextureShader extends format.hxsl.Shader {

	static var SRC = {
		var input : {
			pos : Float3,
			norm : Float3,
			uv : Float2,
		};
		var tuv : Float2;
		var lpow : Float;
		function vertex( mpos : M44, mproj : M44, light : Float3 ) {
			out = pos.xyzw * mpos * mproj;
			var tnorm = (norm * mpos).normalize();
			lpow = light.dot(tnorm).max(0);
			tuv = uv;
		}
		function fragment( tex : Texture ) {
			out = tex.get(tuv) * (lpow * 0.8 + 0.2);
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
