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
import com.ludamix.triad.render.stage3d.Camera;
import com.ludamix.triad.render.stage3d.Polygon;
import com.ludamix.triad.render.stage3d.Cube;
import com.ludamix.triad.render.stage3d.Vector;
import nme.Assets;

typedef K = flash.ui.Keyboard;
typedef FV = flash.Vector<Float>;

// (This is derived from the Molehill tutorial Nicolas made.)

// The next steps are:

// create an orthographic projection that matches drawTiles
// create a textured quad renderer that can correctly utilize packed sheets
// test shader modes with alpha and colorization
// create an API over this for the sprite and tile renderers.

class Stage3DTest
{
	var stage : flash.display.Stage;
	var s : flash.display.Stage3D;
	var c : flash.display3D.Context3D;
	var shader : TextureShader;
	var pol : Polygon;
	var keys : Array<Bool>;
	var texture : flash.display3D.textures.Texture;

	var camera : Camera;

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

		shader = new TextureShader(c);
		camera = new Camera();

		/*pol = new Cube();
		pol.unindex();
		pol.addNormals();
		pol.addTCoords();
		pol.alloc(c);*/
		
		// this appears to draw a quad correctly...but scale is still an unknown
		pol = new Polygon([new Vector(0.,0.),new Vector(1.,0.),new Vector(1.,1.),new Vector(0.,1.)],[0,1,2,0,2,3]);
		pol.unindex();
		pol.addNormals();
		{
			var z = new UV(0, 0);
			var x = new UV(1, 0);
			var y = new UV(0, 1);
			var o = new UV(1, 1);
			pol.tcoords = [z,x,o,z,o,y];
		}		
		pol.alloc(c);
		
		var bmp = Assets.getBitmapData("assets/Stone-Wall-Texture-17.jpg");
		texture = c.createTexture(bmp.width, bmp.height, flash.display3D.Context3DTextureFormat.BGRA, false);
		texture.uploadFromBitmapData(bmp);		
	}

	private function createOrthographicProjectionMatrix(viewWidth : Float, viewHeight : Float, near : Float, far : Float):Matrix3D
	{
   // this is a projection matrix that gives us an orthographic view of the world (meaning there's no perspective effect)
   // the view is defined with (0,0) being in the middle,
   //	(-viewWidth / 2, -viewHeight / 2) at the top left,
   // 	(viewWidth / 2, viewHeight / 2) at the bottom right,
   //	and 'near' and 'far' giving limits to the range of z values for objects to appear.
   return new Matrix3D(
   (FV.ofArray([
    2./viewWidth, 0, 0, 0,
    0, -2/viewHeight, 0, 0,
    0, 0, 1/(far-near), -near/(far-near),
    0, 0, 0, 1
   ])));
  }
  
	function update(_) {
		if( c == null ) return;

		c.clear(0, 0, 0, 1);
		c.setDepthTest( true, flash.display3D.Context3DCompareMode.LESS_EQUAL );
		c.setCulling(flash.display3D.Context3DTriangleFace.BACK);

		if( keys[K.UP] )
			camera.moveAxis(0,-0.1);
		if( keys[K.DOWN] )
			camera.moveAxis(0,0.1);
		if( keys[K.LEFT] )
			camera.moveAxis(-0.1,0);
		if( keys[K.RIGHT] )
			camera.moveAxis(0.1, 0);
		if( keys[109] )
			camera.zoom /= 1.05;
		if( keys[107] )
			camera.zoom *= 1.05;
		camera.update();
		
		var project = camera.m.toMatrix();
		
		var light = new flash.geom.Vector3D(1.,0.,0.);
		light.normalize();

		// the quad is not showing up now. Why? Is the projection/scaling false?
		// At this point it may be appropriate to reference GL/DX tutorials for 2d renderers...
		// or frameworks like Starling.
		// I'm only looking for how to scale it properly right now.

		shader.init(
			{ mpos : new flash.geom.Matrix3D(), mproj : createOrthographicProjectionMatrix(800.,600.,-100.,100.), light : light },
			{ tex : texture }
		);

		shader.bind(pol.vbuf);
		c.drawTriangles(pol.ibuf);
		c.present();
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
