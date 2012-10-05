import com.ludamix.triad.render.foxquad.FoxQuadScene;
import com.ludamix.triad.render.foxquad.FQGrid;
import com.ludamix.triad.render.foxquad.Quads2D;
import com.ludamix.triad.render.foxquad.Quads2PointFiveD;
import com.ludamix.triad.render.foxquad.ShaderGeneral;
import com.ludamix.triad.render.GraphicsResource;
import com.ludamix.triad.grid.AutotileBoard;
import com.ludamix.triad.grid.IntGrid;
import com.ludamix.triad.render.XTilesheet;
import com.ludamix.triad.tools.Color;
import com.ludamix.triad.tools.MathTools;
import com.ludamix.triad.ui.Helpers;
import nme.display.Sprite;
import nme.display.Graphics;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.events.MouseEvent;
import nme.geom.ColorTransform;
import nme.Assets;
import nme.geom.Rectangle;
import nme.geom.Matrix;
import nme.geom.Matrix3D;
import nme.geom.Vector3D;
import nme.Lib;
import nme.events.Event;
import nme.events.KeyboardEvent;
import nme.geom.Point;
import nme.ui.Keyboard;
import nme.Vector;

typedef CameraView = { tx:Float, ty:Float, tw:Float, th:Float, 
			scale_x:Float, scale_y:Float, output_scale:Float,
			off_x:Float, off_y:Float, center_x:Float, center_y:Float };

typedef SortableSprite = { pt:Point, xtile:XTile, z:Float };

class TileLandscape
{

	public var graphics_resource : GraphicsResourceData;
	public var grid : FQGrid; // tilemap quads
	public var board : AutotileBoard;
	public var sprite_quads : Quads2D; // moving objects and objects that need dynamic z sorting
	public var sprite_sortqueue : Array<SortableSprite>;
	public var static_sprites : Array<SortableSprite>;
	public var gfx : Graphics;
	public var spr : Sprite;
	public var scene : FoxQuadScene;
	public var shader : ShaderGeneral2D;
	public var shaderZ : ShaderGeneral2PointFiveD;
	
	public var zoom_level : Float;
	public var day_cycle : Float;
	
	public var player : SmileyCharacter;

	public function new()
	{
	
		scene = new FoxQuadScene(Lib.current.stage, initialize);
	
	}

	public function initialize(_ : Dynamic)
	{
		graphics_resource = GraphicsResource.read(Assets.getText("assets/graphics.tc"), 512, true, "assets/", 2);
		sprite_quads = new Quads2D(scene.c);
		shader = new ShaderGeneral2D(scene.c);
		shaderZ = new ShaderGeneral2PointFiveD(scene.c);
		scene.addTilesheet(graphics_resource.tilesheet);
		grid = new FQGrid(graphics_resource.tilesheet, WORLD_W * 25, WORLD_H * 25, 16, 16, [0]);
		sprite_sortqueue = new Array();
		static_sprites = new Array();
		
		zoom_level = 1.;
		day_cycle = 0.;
		
		var pop = new Array<Int>(); for (n in 0...50 * 38) pop.push(0);
		board = new AutotileBoard(25, 19, 32, 32, pop, graphics_resource.autotile);
		
		initializeWorld();
		//initParticles();
		
		Lib.current.stage.addEventListener(Event.ENTER_FRAME, update);
		
		Lib.current.stage.addChild(Helpers.quickLabel( {field:[{textColor:0xFFFFFF}],format:[]}, "Arrow keys to move camera. F1, F2 zoom in and out."));
		
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, function(ev:KeyboardEvent)
		{
			var SHIFT_VAL = 4;
			if (ev.keyCode==Keyboard.F1)
				{ if (zoom_level <= 0.1) zoom_level = 8; else zoom_level -= 0.05; }
			if (ev.keyCode==Keyboard.F2)
				{ if (zoom_level >= 8) zoom_level = 0.1; else zoom_level += 0.05; }
		});
		Lib.current.stage.addEventListener(nme.events.MouseEvent.CLICK, function(ev:MouseEvent)
		{
			var zoom_w = Main.W * zoom_level;
			var zoom_h = Main.H * zoom_level;
			var mx = cam.x - zoom_w / 2 + ev.stageX / Main.W * zoom_w;
			var my = cam.y - zoom_h / 2 + ev.stageY / Main.H * zoom_h;
			
			if (board.pixelInBounds(mx,my))
			{
				var cur = board.getff(mx, my);
				board.setff(mx, my, (cur + 1) % 3);
				var pos = board.result.cffp(mx, my);
				updateScene(pos.x-2, pos.y-2, 6, 6);			
			}
			
		});
		
		player = new SmileyCharacter((WORLD_W*25*32)>>1,(WORLD_H*25*32)>>1,0, graphics_resource);
		
	}
	
	public static inline var WORLD_W = 8;
	public static inline var WORLD_H = 6;
	
	public var worldmap : IntGrid;
	public var cammap : IntGrid;
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
		
		board.source = worldmap;
		board.result.worldW = worldmap.worldW * 2;
		board.result.worldH = worldmap.worldH * 2;
		board.result.world = new Vector<Int>();
		board.recacheAll();
		
		createStaticObjects();
		
		initializeScene();
	}
	
	public function createStaticObjects()
	{
		static_sprites = new Array();
		
		// this is a very simple static object test. We just treat it like other dynamic objects - tile, xy, z.
		// a very large number of them will bottleneck the vertex upload!
		
		for (n in 0...100)
		{
			var px = new Point(Math.random() * worldmap.worldW * worldmap.twidth, 
							   Math.random() * worldmap.worldH * worldmap.theight);
			
			if (worldmap.cfft(px.x, px.y)!=1)
			{
				var z = grid.zOfY(px.y + 72, 0.);
				static_sprites.push({pt:px,xtile:graphics_resource.getSprite("tree").getTile(0),z:z});		
			}
		}		
	}
	
	public function viewOfCamera(camera_view : Rectangle, screen_view : Rectangle) : CameraView
	{
		var tile_tl = worldmap.cffp(camera_view.left, camera_view.top);
		var tile_br = worldmap.cffp(camera_view.right, camera_view.bottom);
		
		// pad one tile at the right and bottom to allow for scrolling
		var tile_x = Math.floor(tile_tl.x);
		var tile_y = Math.floor(tile_tl.y);
		var tile_w = Math.floor(tile_br.x - tile_tl.x) + 1;
		var tile_h = Math.floor(tile_br.y - tile_tl.y) + 1;
		
		var scale_x = screen_view.width / camera_view.width;
		var scale_y = screen_view.height / camera_view.height;
		
		var output_scale = scale_x; if (scale_x < scale_y) output_scale = scale_y;
		
		var off_x = -camera_view.x * output_scale;
		var off_y = -camera_view.y * output_scale;
		
		return { tx:tile_x, ty:tile_y, tw:tile_w, th:tile_h, 
			scale_x:scale_x, scale_y:scale_y, output_scale:output_scale,
			off_x:off_x, off_y:off_y, 
			center_x:camera_view.x + camera_view.width / 2,			
			center_y:camera_view.y + camera_view.height / 2 };			
	}
	
	public function copy(input : IntGrid, fallback : Int)
	{
	
		var at : Array<AutoTileDef> = graphics_resource.autotile;
		var offset = 0; // we offset to the correct tileset position
		for (n in 0...at.length)
		{
			if (at[n].name == "grass") offset = n*20;
		}
		
		grid.grid.worldW = input.worldW; grid.grid.worldH = input.worldH;
		
		var pop = grid.grid.world;
		var idx = 0;
		for (y in 0...input.worldH)
		{
			for (x in 0...input.worldW)
			{
				var inp = input.c2t(x, y);
				if (inp < 0)
					pop[idx] = inp;					
				else
					pop[idx] = inp + offset;					
				idx++;
			}
		}
		
	}
	
	public function initializeScene()
	{
		copy(board.result, 0);
		grid.recache(scene.c);
	}
	
	public function updateScene(tx, ty, tw, th)
	{
		copy(board.result, 0);
		grid.updateChunkRect(tx, ty, tw, th);
	}
	
	public inline function getCameraTranslation(mod_x : Float, mod_y : Float, mod_z : Float, view : CameraView)
	{
		var translate = new Matrix3D();
		translate.identity();
		translate.appendTranslation( mod_x - view.center_x, mod_y - view.center_y, mod_z);
		translate.appendRotation(0., new Vector3D(0., 0., 1., 0.));		
		translate.appendScale(view.output_scale, view.output_scale, 1.);
		translate.appendTranslation(Main.W / 2, Main.H / 2, 0.);		
		return translate;
	}
	
	public inline function drawSortQueue():Void 
	{
		sprite_sortqueue.sort(function(a, b) { return (a.z > b.z)?-1: 1; } );
		for (s in sprite_sortqueue)
			sprite_quads.writeXTile(s.pt, s.xtile);
	}
	
	public static inline var DEFAULTZ = 0.5;
	
	public function update(_)
	{
		//spawnParticles();
		//updateParticles(1/30.);
		
		sprite_quads.reset();
		sprite_sortqueue = static_sprites.copy();
		
		cam.x = player.px;
		cam.y = player.py;
		player.update();		
		player.draw(sprite_sortqueue, cam.x - player.px, cam.y - player.py, grid);
		drawSortQueue();
		
		var colors = computeDayColors();
		
		var zoom_w = Main.W * zoom_level;
		var zoom_h = Main.H * zoom_level;
		var view = viewOfCamera(new Rectangle(cam.x - zoom_w / 2, cam.y - zoom_h / 2, zoom_w, zoom_h), 
					 new Rectangle(0, 0, Main.W, Main.H));
		
		var minZ = -1.;
		var maxZ = 1.;
		
		scene.clear(1.0);
		
		grid.runShader(shaderZ,
			{mproj : scene.createOrthographicProjectionMatrix(Main.W, Main.H, minZ, maxZ), 
			 mtrans : getCameraTranslation(0.,0.,DEFAULTZ,view),
			 rgba : new Vector3D(colors.r, colors.g, colors.b, 1.) },			 
			{tex : graphics_resource.tilesheet.texture }
		);
		
		sprite_quads.runShader(shader,
			{mproj : scene.createOrthographicProjectionMatrix(Main.W, Main.H, minZ, maxZ), 
			 mtrans : getCameraTranslation(0.,0.,DEFAULTZ,view),
			 rgba : new Vector3D(colors.r * 2, colors.g * 2, colors.b * 2, 1.) },			 
			{tex : graphics_resource.tilesheet.texture }
		);
		
		scene.present();
	}
	
	public function computeDayColors()
	{
		var grad = [0x001065, 0x9556b2, 0xdfb1ce, 0xf2f1dd, 0xf2826c, 0x753a82, 0x001065];
		var pos = day_cycle * 6;
		var left = Std.int(pos);
		var right = Std.int(pos + 1);
		var pct = pos - left;
		var hsv_left = { h:0., s:0., v:0. };
		var hsv_right = { h:0., s:0., v:0. };
		Color.RGBtoHSV(Color.RGBPx(grad[left]), hsv_left);
		Color.RGBtoHSV(Color.RGBPx(grad[right]), hsv_right);
		var h = MathTools.lerp(hsv_left.h, hsv_right.h, pct);
		var s = MathTools.lerp(hsv_left.s, hsv_right.s, pct);
		var v = MathTools.lerp(hsv_left.v, hsv_right.v, pct);
		var final = { r:0, g:0, b:0 };
		Color.HSVtoRGB({h:h,s:s,v:v},final);
		day_cycle += 0.0005;
		if (day_cycle > 1.) day_cycle -= 1.;
		return { r:final.r / 255., g:final.g / 255., b:final.b / 255. };
	}

}

class SmileyCharacter
{

	public var wx : Int;
	public var wy : Int;
	public var wcycle : Float;
	
	public var px : Int;
	public var py : Int;
	public var facing : Int;
	
	private var z : Float;
	private var off_x : Float;
	private var off_y : Float;
	
	public var graphics_resource : GraphicsResourceData;

	public function new(px, py, facing, graphics_resource)
	{
		this.px = px;		
		this.py = py;
		this.graphics_resource = graphics_resource;
		wcycle = 0.;
		wx = 0;
		wy = 0;
		this.facing = facing;	
		
		var SPEED = 2;
		
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, function(ev:KeyboardEvent)
		{
			if (ev.keyCode==Keyboard.RIGHT)
				{ wx = SPEED; }
			if (ev.keyCode==Keyboard.LEFT)
				{ wx = -SPEED; }
			if (ev.keyCode==Keyboard.UP)
				{ wy = -SPEED; }
			if (ev.keyCode==Keyboard.DOWN)
				{ wy = SPEED; }
		});
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, function(ev:KeyboardEvent)
		{
			if (ev.keyCode==Keyboard.RIGHT)
				wx = 0;
			if (ev.keyCode==Keyboard.LEFT)
				wx = 0;
			if (ev.keyCode==Keyboard.UP)
				wy = 0;
			if (ev.keyCode==Keyboard.DOWN)
				wy = 0;
		});		
	}
	
	public function update()
	{
		px += wx;
		py += wy;	
	}
	
	public inline function addName(sprite_sortqueue : Array<SortableSprite>, 
		name : String, frame : Int, x : Float, y : Float)
	{
		var tile = graphics_resource.getSprite(name).getTile(frame);
		sprite_sortqueue.push({pt:new flash.geom.Point(off_x + x, off_y + y),xtile:tile,z:z});
	}
	
	public function draw(sprite_sortqueue : Array<SortableSprite>, offx : Float, offy : Float, grid : FQGrid)
	{
		this.z = grid.zOfY(py + 64., 0.);
		
		this.off_x = px + offx;
		this.off_y = py + offy;
		
		var CYCLET = 0.17;
		
		if (wx != 0) { if (wx > 0) wcycle -= CYCLET; else wcycle += CYCLET; }
		else if (wy != 0) { if (wy > 0) wcycle -= CYCLET; else wcycle += CYCLET; }
		
		var wcycle_inv = wcycle + Math.PI;
		
		var FEET_D = 7;
		var RECOVERY = 0.7;
		var BOB = 2;
		var FEET_H = 20;
		var FEET_C = 6;
		
		if (wx != 0.) // x cycle
		{
			var f_facing = (wx > 0) ? 1 : 0;
			facing = wx>0 ? 2 : 1;
			
			addName(sprite_sortqueue, "faces", facing, 0, Math.sin(wcycle * 2) * BOB);
			addName(sprite_sortqueue, "feet", f_facing, Math.cos(wcycle_inv) * FEET_D,
				FEET_H + Math.min(0., Math.sin(wcycle_inv) * -FEET_C));
			addName(sprite_sortqueue, "feet", f_facing, Math.cos(wcycle) * FEET_D,
				FEET_H + Math.min(0., Math.sin(wcycle) * -FEET_C));
		}
		else // y cycle
		{
			var r_facing = 0; var l_facing = 1;
			
			if (wy == 0.) { wcycle *= RECOVERY; wcycle_inv = wcycle + Math.PI; } // reset on still
			else facing = wy < 0 ? 3 : 0;
			addName(sprite_sortqueue, "faces", facing, 0, Math.sin(wcycle * 2) * BOB);
			addName(sprite_sortqueue, "feet", l_facing, FEET_D, 
				FEET_H + Math.min(0., Math.sin(wcycle_inv) * -FEET_C));
			addName(sprite_sortqueue, "feet", r_facing, - FEET_D, 
				FEET_H + Math.min(0., Math.sin(wcycle) * -FEET_C));
		}
		
		wcycle = wcycle % (Math.PI * 2);
		
	}	

}