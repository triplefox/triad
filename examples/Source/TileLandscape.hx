import com.ludamix.triad.render.TilesheetGrid;
import com.ludamix.triad.render.GraphicsResource;
import com.ludamix.triad.render.SpriteRenderer;
import com.ludamix.triad.render.Stage3DScene;
import com.ludamix.triad.grid.AutotileBoard;
import com.ludamix.triad.grid.IntGrid;
import com.ludamix.triad.render.XTilesheet;
import com.ludamix.triad.tools.MathTools;
import com.ludamix.triad.ui.Helpers;
import nme.display.Sprite;
import nme.display.Graphics;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.geom.ColorTransform;
import nme.Assets;
import nme.Lib;
import nme.events.Event;
import nme.events.KeyboardEvent;
import nme.geom.Point;
import nme.ui.Keyboard;

class TileLandscape
{

	public var graphics_resource : GraphicsResourceData;
	public var grid : TilesheetGrid;
	public var board : AutotileBoard;
	public var sprite : SpriteRenderer;
	public var gfx : Graphics;
	public var spr : Sprite;
	#if flash11
	public var scene : Stage3DScene;
	#end

	public function new()
	{
	
		#if flash11
		scene = new Stage3DScene(Lib.current.stage, initialize);
		#else
		initialize(null);
		#end
	
	}

	public function initialize(_ : Dynamic)
	{
		graphics_resource = GraphicsResource.read(Assets.getText("assets/graphics.tc"), 512, true, "assets/", 2);
		sprite = new SpriteRenderer(graphics_resource.sprite);
		#if flash11
		scene.addTilesheet(graphics_resource.tilesheet);
		#else
		spr = new Sprite();
		gfx = spr.graphics;
		Lib.current.addChild(spr);
		#end
		
		var pop = new Array<Int>(); for (n in 0...50 * 38) pop.push(0);
		grid = new TilesheetGrid(graphics_resource.tilesheet, 50, 38, 16, 16, pop);
		var pop = new Array<Int>(); for (n in 0...50 * 38) pop.push(0);
		board = new AutotileBoard(25, 19, 32, 32, pop, graphics_resource.autotile);
		
		initializeWorld();
		//initParticles();
		
		Lib.current.stage.addEventListener(Event.ENTER_FRAME, update);
		
		Lib.current.stage.addChild(Helpers.quickLabel( {field:[{textColor:0xFFFFFF}],format:[]}, "Arrow keys to move camera."));
		
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, function(ev:KeyboardEvent)
		{
			if (ev.keyCode==Keyboard.RIGHT)
				shiftCamera(1, 0);
			if (ev.keyCode==Keyboard.LEFT)
				shiftCamera(-1, 0);
			if (ev.keyCode==Keyboard.UP)
				shiftCamera(0, -1);
			if (ev.keyCode==Keyboard.DOWN)
				shiftCamera(0, 1);
			if (ev.keyCode==Keyboard.F1)
				{ if (grid.scale <= 0.05) grid.scale = 2.; else grid.scale -= 0.05; }
			if (ev.keyCode==Keyboard.F2)
				{ if (grid.scale >= 2.) grid.scale = 0.05; else grid.scale += 0.05; }
		});
		
	}
	
	public static inline var WORLD_W = 8;
	public static inline var WORLD_H = 8;
	
	public var worldmap : IntGrid;
	public var cam : { x:Int, y:Int };
	
	public function initializeWorld()
	{
		var t_w = WORLD_W * 25;
		var t_h = WORLD_H * 25;
		var sz = t_w * t_h;
		
		cam = { x:0, y:0 };
		
		var pop = new Array<Int>(); for (n in 0...sz) pop.push(0);
		worldmap = new IntGrid(t_w,t_h,32,32,pop);
		
		var nodes = new Array<{x:Int,y:Int,t:Int}>();
		for (n in 0...700)
		{
			nodes.push( { x:Std.int(Math.random() * t_w), y:Std.int(Math.random() * t_h), t:Std.int(Math.random()*3) } );
		}
		
		var w = worldmap.world;
		var x = 0;
		var y = 0;
		for (n in 0...w.length)
		{
			var bd = MathTools.sqrDist(nodes[0].x, nodes[0].y, x, y);
			var bn = nodes[0];
			for (nd in nodes)
			{
				var dd = MathTools.sqrDist(nd.x, nd.y, x, y);
				if (dd < bd)
				{
					bd = dd;
					bn = nd;
				}
			}
			w[n] = bn.t;
			x++; if (x >= t_w) { x = 0; y++; }
		}
		
		for (n in 0...t_h)
		{
			worldmap.world[worldmap.c21(0, n)] = 0;
			worldmap.world[worldmap.c21(worldmap.worldW-1, n)] = 1;
		}
		for (n in 0...t_w)
		{
			worldmap.world[worldmap.c21(n,0)] = 0;
			worldmap.world[worldmap.c21(n,worldmap.worldH-1)] = 1;
		}
		
		initializeScene();
	}
	
	public function shiftCamera(x : Int, y : Int)
	{
		cam.x += x;
		cam.y += y;
		var dist_x = worldmap.worldW - Std.int(Main.W/32);
		var dist_y = worldmap.worldH - Std.int(Main.H/32);
		if (cam.x < 0) cam.x = dist_x;
		if (cam.y < 0) cam.y = dist_y;
		if (cam.x + Main.W/32 > worldmap.worldW) cam.x = 0;
		if (cam.y + Main.H/32 > worldmap.worldH) cam.y = 0;
		initializeScene();

	}
	
	public inline function getWorldTile(x, y)
	{
		return worldmap.c2t(x + cam.x, y + cam.y);
	}
	
	public function initializeScene()
	{
		
		var pop = new Array<Int>();
		
		var t_w = board.source.worldW;
		var t_h = board.source.worldH;
		
		var at : Array<AutoTileDef> = graphics_resource.autotile;
		var offset = 0;
		for (n in 0...at.length)
		{
			if (at[n].name == "grass") offset = n;
		}
		
		for (y in 0...t_h)
		{
			for (x in 0...t_w)
			{
				pop.push(getWorldTile(x, y) + offset);
			}
		}
		
		board.source.world = pop;
		
		board.recacheAll();
		
	}
	
	public function update(_)
	{
		//spawnParticles();
		//updateParticles(1/30.);

		// Now let's think about how we're going to do the zoom resize stuff.

		#if flash11
		scene.clear(1.0);
		grid.stage3DFromGrid(board.result, scene, false);
		sprite.draw_stage3d(scene);
		scene.present();
		#else
		gfx.clear();
		grid.renderFromGrid(board.result, gfx, false);
		sprite.draw_tiles(gfx);
		#end
	}

}
