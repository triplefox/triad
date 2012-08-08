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
import nme.geom.Rectangle;
import nme.Lib;
import nme.events.Event;
import nme.events.KeyboardEvent;
import nme.geom.Point;
import nme.ui.Keyboard;
import nme.Vector;

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
	public var zoom_level : Float;

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
		zoom_level = 1.;
		
		var pop = new Array<Int>(); for (n in 0...50 * 38) pop.push(0);
		grid = new TilesheetGrid(graphics_resource.tilesheet, 50, 38, 16, 16, pop);
		var pop = new Array<Int>(); for (n in 0...50 * 38) pop.push(0);
		board = new AutotileBoard(25, 19, 32, 32, pop, graphics_resource.autotile);
		
		initializeWorld();
		//initParticles();
		
		Lib.current.stage.addEventListener(Event.ENTER_FRAME, update);
		
		Lib.current.stage.addChild(Helpers.quickLabel( {field:[{textColor:0xFFFFFF}],format:[]}, "Arrow keys to move camera. F1, F2 zoom in and out."));
		
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, function(ev:KeyboardEvent)
		{
			var SHIFT_VAL = 4;
			if (ev.keyCode==Keyboard.RIGHT)
				shiftCamera(SHIFT_VAL, 0);
			if (ev.keyCode==Keyboard.LEFT)
				shiftCamera(-SHIFT_VAL, 0);
			if (ev.keyCode==Keyboard.UP)
				shiftCamera(0, -SHIFT_VAL);
			if (ev.keyCode==Keyboard.DOWN)
				shiftCamera(0, SHIFT_VAL);
			if (ev.keyCode==Keyboard.F1)
				{ if (zoom_level <= 0.1) zoom_level = 3.; else zoom_level -= 0.05; initializeScene(); }
			if (ev.keyCode==Keyboard.F2)
				{ if (zoom_level >= 3.) zoom_level = 0.1; else zoom_level += 0.05; initializeScene(); }
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
		//if (cam.x < 0) cam.x = dist_x;
		//if (cam.y < 0) cam.y = dist_y;
		//if (cam.x + Main.W/32 > worldmap.worldW) cam.x = 0;
		//if (cam.y + Main.H/32 > worldmap.worldH) cam.y = 0;
		initializeScene();

	}
	
	public inline function getWorldTile(x, y)
	{
		return worldmap.c2t(x + cam.x, y + cam.y);
	}
	
	public static function copy(input : IntGrid, camera_view : Rectangle, screen_view : Rectangle, fallback : Int)
	{
		var tile_tl = input.cffp(camera_view.left, camera_view.top);
		var tile_br = input.cffp(camera_view.right, camera_view.bottom);
		
		// pad one tile at the right and bottom to allow scrolling
		// then pad with one tile on all sides to allow the autotiler to render correctly
		var tile_x = Math.floor(tile_tl.x)-1;
		var tile_y = Math.floor(tile_tl.y)-1;
		var tile_w = Math.floor(tile_br.x - tile_tl.x)+3;
		var tile_h = Math.floor(tile_br.y - tile_tl.y)+3;
		
		var pop = new Vector<Int>();
		for (y in tile_y...tile_y + tile_h)
		{
			for (x in tile_x...tile_x + tile_w)			
			{
				if (input.tileInBounds(x,y))
					pop.push(input.c2t(x, y));
				else
					pop.push(fallback);
			}
		}
		
		var output = new IntGrid(tile_w, tile_h, input.twidth, input.theight, [0]);
		output.world = pop;
		// include padding in offset
		var off_x = (-camera_view.x % output.twidth) - input.twidth;
		var off_y = (-camera_view.y % output.theight) - input.theight;
		
		var scale_x = screen_view.width / camera_view.width;
		var scale_y = screen_view.height / camera_view.height;
		
		var output_scale = scale_x;
		scale_x > scale_y ? output_scale = scale_x : output_scale = scale_y;
		
		off_x *= output_scale;
		off_y *= output_scale;
		
		return {world:output.world, scale:output_scale, off_x:off_x, off_y:off_y, width:tile_w, height:tile_h};
		
	}
	
	public function initializeScene()
	{
		
		// Can we refactor this into something more "off-the-shelf"?
		// At the moment it performs poorly when scrolling, throwing out more data than necessary.
		// A lot of this depends on the way the vector data is constructed and cached.
		// It might also help to rewrite IntGrid to Vector<Int>.
		
		var zoom_w = Main.W * zoom_level;
		var zoom_h = Main.H * zoom_level;

		var at : Array<AutoTileDef> = graphics_resource.autotile;
		var offset = 0; // we offset to the correct tileset position
		for (n in 0...at.length)
		{
			if (at[n].name == "grass") offset = n;
		}

		var render_world = copy(worldmap,
			new Rectangle(cam.x - zoom_w/2, cam.y - zoom_h/2, 
				zoom_w, zoom_h), new Rectangle(0, 0, Main.W, Main.H),
				offset);
		
		// we offset the tiles.
		for (n in 0...render_world.world.length)
			render_world.world[n] += offset;
		
		board.source.world = render_world.world;
		board.source.worldW = render_world.width;
		board.source.worldH = render_world.height;
		board.result.worldW = render_world.width * 2;		
		board.result.worldH = render_world.height * 2;
		board.result.world = new Vector(board.result.worldW * board.result.worldH);
		grid.grid.worldW = render_world.width * 2;
		grid.grid.worldH = render_world.height * 2;
		grid.grid.world = new Vector(grid.grid.worldW * grid.grid.worldH);
		grid.off_x = render_world.off_x;
		grid.off_y = render_world.off_y;
		grid.scale = render_world.scale;
		grid.flags_changed = true;
		
		board.recacheAll();
		
		var infos = [board.source.worldW, board.source.worldH, board.source.world.length];	
		var infos_2 = [board.result.worldW, board.result.worldH, board.result.world.length];	
		var infos_3 = [grid.grid.worldW, grid.grid.worldH, grid.grid.world.length];	
		
		if (Std.int(board.source.worldW * board.source.worldH) != Std.int(board.source.world.length))
			throw Std.format("fail_src $infos $infos_2 $infos_3");
		if (Std.int(board.result.worldW * board.result.worldH) != Std.int(board.result.world.length))
			throw Std.format("fail_res $infos $infos_2 $infos_3");
		if (Std.int(grid.grid.worldW * grid.grid.worldH) != Std.int(grid.grid.world.length))
			throw Std.format("fail_gri $infos $infos_2 $infos_3");
		
		// fail_res 50 30 1900
		
	}
	
	public function update(_)
	{
		//spawnParticles();
		//updateParticles(1/30.);
		
		#if flash11
		scene.clear(1.0);
		grid.stage3DFromGrid(board.result, scene, true);
		sprite.draw_stage3d(scene);
		scene.present();
		#else
		gfx.clear();
		grid.renderFromGrid(board.result, gfx, true);
		sprite.draw_tiles(gfx);
		#end
	}

}
