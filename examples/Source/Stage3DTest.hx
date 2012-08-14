import com.ludamix.triad.render.foxquad.FoxQuadScene;
import com.ludamix.triad.render.foxquad.Quads2D;
import com.ludamix.triad.render.foxquad.ShaderGeneral;
import com.ludamix.triad.render.GraphicsResource;
import com.ludamix.triad.grid.IntGrid;
import com.ludamix.triad.tools.MathTools;
import com.ludamix.triad.ui.Helpers;
import flash.geom.Vector3D;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.Tilesheet;
import nme.geom.ColorTransform;
import nme.geom.Matrix3D;
import nme.Lib;
import nme.events.Event;
import nme.events.KeyboardEvent;
import nme.geom.Point;
import nme.ui.Keyboard;
import nme.Assets;

class Stage3DTest
{
	public var graphics_resource : GraphicsResourceData;
	public var scene : FoxQuadScene;
	public var quads : Quads2D;
	public var shader : ShaderGeneral2D;
	public var xt : Float;
	public var yt : Float;
	public var rot : Float;
	public var xs : Float;
	public var ys : Float;
	
	public function new()
	{
		scene = new FoxQuadScene(Lib.current.stage, initialize);	
	}
	
	public function initialize(_ : Dynamic)
	{
		graphics_resource = GraphicsResource.read(Assets.getText("assets/graphics.tc"), 512, true, "assets/", 2);
		quads = new Quads2D(scene.c);
		shader = new ShaderGeneral2D(scene.c);
		scene.addTilesheet(graphics_resource.tilesheet);
		
		xt = 0.;
		yt = 0.;
		rot = 0.;
		xs = 1.;
		ys = 1.;
		
		Lib.current.stage.addEventListener(Event.ENTER_FRAME, update);
		
		Lib.current.stage.addChild(Helpers.quickLabel( 
			{ field:[ { textColor:0xFFFFFF } ], format:[] }, "Arrow keys to shift image. F1, F2 rotate. F3, F4 scale."));
		
		pause = false;
		
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, function(ev:KeyboardEvent)
		{
			if (ev.keyCode == Keyboard.LEFT) { xt -= 1; }
			if (ev.keyCode == Keyboard.RIGHT) { xt += 1; }
			if (ev.keyCode == Keyboard.UP) { yt -= 1; }
			if (ev.keyCode == Keyboard.DOWN) { yt += 1; }
			if (ev.keyCode == Keyboard.F1) { rot += 1; }
			if (ev.keyCode == Keyboard.F2) { rot -= 1; }
			if (ev.keyCode == Keyboard.F3) { xs *= 0.5; ys *= 0.5; }
			if (ev.keyCode == Keyboard.F4) { xs *= 2.; ys *= 2.; }
			if (ev.keyCode == Keyboard.SPACE) { pause = !pause; }
			if (xs < 0.001) { xs = 0.001; ys = 0.001; }
		});
		
		quads.reset();
		for (n in 0...1000)
			quads.writeXTile(new flash.geom.Point(Math.random() * Main.W, 
												  Math.random() * Main.H), 
												  graphics_resource.getSprite("faces").getTile(0));
		
	}
	
	public var pause : Bool;
	
	public function update(_)
	{
		
		var pivot_x = Main.W / 2;
		var pivot_y = Main.H / 2;
		
		var translate = new Matrix3D();
		translate.identity();
		translate.appendTranslation(-pivot_x, -pivot_y, 0.);
		translate.appendRotation(rot, new Vector3D(0., 0., 1., 0.));
		translate.appendScale(xs, ys, 1.);
		translate.appendTranslation(pivot_x+xt, pivot_y+yt, 0.);
		
		scene.clear();
		quads.runShader(shader,
			{mproj : scene.createOrthographicProjectionMatrix(Main.W, Main.H, -1., 1.), 
			 mtrans : translate,
			 rgba : new Vector3D(1.,1.,1.,1.)},
			{tex : graphics_resource.tilesheet.texture }
		);
		scene.present();
		
	}

}