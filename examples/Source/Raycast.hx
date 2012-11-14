import com.ludamix.triad.geom.AABB;
import com.ludamix.triad.geom.SubPixel;
import com.ludamix.triad.geom.SubIPoint;
import com.ludamix.triad.io.ButtonManager;
import com.ludamix.triad.math.Trig;
import com.ludamix.triad.grid.ObjectGrid;
import com.ludamix.triad.tools.Color;
import com.ludamix.triad.tools.MathTools;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Point;
import nme.Assets;
import nme.display.BitmapData;
import nme.display.Bitmap;
import nme.display.Graphics;
import nme.display.Sprite;
import nme.geom.Rectangle;
import nme.Lib;
import nme.ui.Keyboard;

typedef Camera = { pos:SubIPoint, z:Float, ang:Float };

class RaycastWall
{
	public var solid : Bool;
	public var texture : Int;
	public function new(solid, texture) { this.solid = solid; this.texture = texture; }
	public inline function reprRaycast() { return solid ? texture : 0; }
	public inline function reprOverhead() { return solid ? Color.ARGB(Color.get(ColHTML5(CadetBlue)),0xFF) : Color.ARGB(0,0); }
}

class RayState
{
	public var dist : Float;
	public var ang : Float;
	public var x : Float;
	public var y : Float;
	public var tex : Int;
	public var tex_offset : Float;
	public function new(ang : Float)
	{
		dist = 1.;
		this.ang = ang;
		this.x = 0; this.y = 0; this.tex = 0;
		tex_offset = 0;
	}
}

class Raycast
{
	
	public static inline var ROTPI = Math.PI / 180.;
	public static inline var OVERHEADSIZE = 8;
	
	public static inline var PLAYER_SIZE = 0.5;
	
	public static inline var DIVISIONS = 1; // when using more divisions, use lower res textures or you'll get "cracking"
	
	public static inline var FOV = 70.;
	
	public var view_width : Int;
	public var view_height : Int;
	
	public var map : ObjectGrid<RaycastWall>;
	
	public var cam : Camera;
	
	//public var surf : Bitmap; // this version uses flat colors - it's a lot faster!
	public var surf : Array<Sprite>;
	public var overhead : Bitmap;
	public var overhead_spr : Sprite;
	public var bg : Sprite;
	
	public var button : ButtonManager;
	
	public var tex : BitmapData;
	
	public var cast_buffer : Array<RayState>;
	
	public var debug_rays : Bool;
	
	public function new()
	{
		
		button = new ButtonManager([
							{ name:"Up", code:{keyCode:Keyboard.UP,charCode:0}, group:"Movement" },
							{ name:"Down", code:{keyCode:Keyboard.DOWN,charCode:0}, group:"Movement" },
							{ name:"Left", code:{keyCode:Keyboard.LEFT,charCode:0}, group:"Movement" },
							{ name:"Right", code:{keyCode:Keyboard.RIGHT,charCode:0}, group:"Movement" },
							], 1);
		
		view_width = Main.W;
		view_height = Main.H;
		
		cast_buffer = new Array();
		for (n in 0...Std.int(view_width/DIVISIONS))
		{
			var strip_pos = n / view_width * DIVISIONS;
			cast_buffer.push(new RayState(Trig.deg2rad(FOV)*strip_pos - Trig.deg2rad(FOV/2)));
		}
		
		var mapg = new Array<RaycastWall>();
		for (n in 0...(32*32))
			mapg.push(new RaycastWall(false, 0));
		map = new ObjectGrid(32,32,OVERHEADSIZE,OVERHEADSIZE,mapg);
		for (n in 0...32)
		{
			map.c2t(n, 0).solid = true; map.c2t(0, n).solid = true;
			map.c2t(n, 31).solid = true; map.c2t(31, n).solid = true;
			if (n % 2 == 0)
			{
				map.c2t(Std.int(n), Std.int(n)).solid = true;
				map.c2t(Std.int(n+1), Std.int(31-n)).solid = true;
			}
		}
		for (n in 0...16)
		{
			map.c2t(n, 24).solid = true; map.c2t(24, n).solid = true;
		}
		
		bg = new Sprite();
		Lib.current.addChild(bg);
		bg.graphics.clear();
		bg.graphics.beginFill(Color.get(ColHTML5(DarkOliveGreen)));
		bg.graphics.drawRect(0, 0, view_width, view_height / 2);
		bg.graphics.endFill();
		bg.graphics.beginFill(Color.get(ColHTML5(DarkGray)));
		bg.graphics.drawRect(0, view_height/2, view_width, view_height / 2);
		bg.graphics.endFill();
		/*surf = new Bitmap(new BitmapData(view_width, view_height, false, Color.ARGB(0,0)));
		Lib.current.addChild(surf);*/
		surf = new Array();
		for (n in 0...cast_buffer.length)
		{
			surf.push(new Sprite());
			Lib.current.addChild(surf[n]);
			var strip_pos = n * DIVISIONS;
			surf[n].x = Std.int(strip_pos);
		}
		overhead = new Bitmap(new BitmapData(Std.int(map.worldW * map.twidth), 
											 Std.int(map.worldH * map.theight), 
											 true, Color.ARGB(0, 0)));
		overhead_spr = new Sprite();
		Lib.current.addChild(overhead);
		Lib.current.addChild(overhead_spr);
		
		tex = Assets.getBitmapData("assets/Stone-Wall-Texture-17.jpg");
		//tex = Assets.getBitmapData("assets/frame2.png");
		
		debug_rays = false;
		
		cam = {pos:SubIPoint.fromFloat(16.,8.),z:0.,ang:0.};
		
		Lib.current.stage.addEventListener(nme.events.Event.ENTER_FRAME, update);
	}	
	
	public function getInput() : {forward:Float,turn:Float,strafe:Float}
	{
		var forward = 0.;
		var turn = 0.;
		var strafe = 0.;
		if (button.isPressed("Up"))
			forward = 0.1;
		if (button.isPressed("Down"))
			forward = -0.1;
		if (button.isPressed("Left"))
			turn = Math.PI / -60;
		if (button.isPressed("Right"))
			turn = Math.PI / 60;
		
		return { forward:forward, turn:turn, strafe:strafe };
	}
	
	public function drawOverhead()
	{
		var wx = 0;
		var wy = 0;
		for (n in 0...map.world.length)
		{
			overhead.bitmapData.fillRect(new Rectangle(wx * map.twidth, wy * map.theight, map.twidth, map.theight),
				map.world[n].reprOverhead());
			wx++; if (wx >= map.worldW) { wx = 0; wy++; }
		}
		
		var proj = Trig.pointOfPolar( { ang:cam.ang, dist:32. } );
		
		var cam_floats = cam.pos.genFPoint();
		cam_floats.x *= OVERHEADSIZE;
		cam_floats.y *= OVERHEADSIZE;
		
		var g : Graphics = overhead_spr.graphics;
		g.clear();
		g.lineStyle(1, 0x888888);
		
		if (debug_rays)
		{
			for (rc in 0...cast_buffer.length)
			{
				var ray = cast_buffer[rc];
				g.moveTo(cam_floats.x, cam_floats.y);	
				g.lineTo(ray.x * OVERHEADSIZE, ray.y * OVERHEADSIZE);
			}
		}
		
		g.lineStyle(1, 0x00FF00);
		g.moveTo(cam_floats.x, cam_floats.y);	g.lineTo(proj.x + cam_floats.x, proj.y + cam_floats.y);
		g.moveTo(cam_floats.x, cam_floats.y);	
		g.lineTo(cast_buffer[0].x * OVERHEADSIZE, cast_buffer[0].y * OVERHEADSIZE);
		g.moveTo(cam_floats.x, cam_floats.y);	
		g.lineTo(cast_buffer[cast_buffer.length-1].x * OVERHEADSIZE, cast_buffer[cast_buffer.length-1].y * OVERHEADSIZE);
		
	}
	
	public function environmentCollision()
	{
		var force = getInput();
		
		// create the desired movement vector
		
		var proj = Trig.subIPointOfPolar( { ang:cam.ang + force.turn, dist:force.forward } );
		var strafe = Trig.subIPointOfPolar( { ang:cam.ang + force.turn + Math.PI / 2, dist: force.strafe } );
		proj.x += strafe.x;
		proj.y += strafe.y;
		
		// find all the nearby tiles and just chop off the vector where there's a collision.
		// it's not really the "best" collision response, but it could probably ship a game.
		
		var initial = AABB.centerFromFloat(PLAYER_SIZE, PLAYER_SIZE, 0, 0);
		initial.x += cam.pos.x; initial.y += cam.pos.y;
		
		var test_x = initial.clone();
		var test_y = initial.clone();
		var test = initial.clone();
		
		test_x.x += proj.x; 
		test_y.y += proj.y;
		test.x += proj.x; test.y += proj.y;
		
		var x_ok = true;
		var y_ok = true;
		
		for (x in (test.li()-1)...(test.ri()+1))
		{
			for (y in (test.ti()-1)...(test.bi()+1))
			{
				if (map.tileInBounds(x, y) && map.c2t(x, y).solid)
				{
					var comp = AABB.fromInt(x, y, 1, 1);
					if (test_x.intersectsAABB(comp))
					{
						x_ok = false;
					}
					if (test_y.intersectsAABB(comp))
					{
						y_ok = false;
					}
				}
			}
		}
		
		if (!x_ok) proj.x = 0;
		if (!y_ok) proj.y = 0;
		
		// apply
		
		cam.pos.x += proj.x;
		cam.pos.y += proj.y;
		cam.ang += force.turn;
		
	}
	
	public function raycastMap()
	{
		
		var pos_base = cam.pos.genFPoint();
		
		for (ray in cast_buffer)
		{
			
			var ray_ang = (cam.ang + ray.ang) % (Math.PI * 2);
			
			var horiz_ray = new Point(pos_base.x, pos_base.y);
			var vert_ray = new Point(pos_base.x, pos_base.y);
			var proj = Trig.pointOfPolar( { ang:ray_ang, dist:1. } );
			var horiz_unit = (proj.x < 0) ? -1 : 1;
			var vert_unit = (proj.y < 0) ? -1 : 1;
			var slope = proj.x==0 ? 0. : proj.y / proj.x * horiz_unit; 
			var inv_slope = proj.y==0 ? 0. : proj.x / proj.y * vert_unit; 
			
			// slam each vector's unit advancer by the edge opposite the expected direction before we begin. 
			// This is a cheat that ensures that we only strike wall edges.
			horiz_ray.x = proj.x < 0 ? Std.int(pos_base.x + 1) - 0.001 : Std.int(pos_base.x);
			vert_ray.y = proj.y < 0 ? Std.int(pos_base.y + 1) - 0.001 : Std.int(pos_base.y);
			
			if (proj.x == 0) { horiz_ray.x = -9999999; horiz_ray.y = -9999999; } else
			while (true)
			{
				// horizontal run
				
				var test = horiz_ray;
				
				// advance
				
				test.x += horiz_unit;
				test.y = pos_base.y + slope * Math.abs(test.x - pos_base.x);
				
				// get end point
				
				var ex = Std.int(test.x);
				var ey = Std.int(test.y);
				
				if (!map.tileInBounds(ex, ey) || map.c2t(ex, ey).solid)
				{
					break;
				}
			}
			
			if (proj.y == 0) { vert_ray.x = -9999999; vert_ray.y = -9999999; } else
			while (true)
			{
				// vertical run
				
				var test = vert_ray;
				
				// advance
				
				test.y += vert_unit;
				test.x = pos_base.x + inv_slope * Math.abs(test.y - pos_base.y);
				
				// get end point
				
				var ex = Std.int(test.x);
				var ey = Std.int(test.y);
				
				if (!map.tileInBounds(ex, ey) || map.c2t(ex, ey).solid)
				{
					break;
				}
			}
			
			var hd = MathTools.sqrDist(horiz_ray.x, horiz_ray.y, pos_base.x, pos_base.y);
			var vd = MathTools.sqrDist(vert_ray.x, vert_ray.y, pos_base.x, pos_base.y);
			
			if (vd > hd)
			{
				ray.x = horiz_ray.x;
				ray.y = horiz_ray.y;
				ray.dist = hd;
				ray.tex_offset = horiz_ray.y % 1;
			}
			else
			{
				ray.x = vert_ray.x;
				ray.y = vert_ray.y;
				ray.dist = vd;
				ray.tex_offset = vert_ray.x % 1;
			}
		}
		
	}
	
	public function drawBuffer()
	{
		//surf.bitmapData.fillRect(surf.bitmapData.rect, Color.ARGB(0, 0));
		var x = 0;
		var count = 0;
		var sz = 0;
		var midpoint = view_height / 2;
		var strip_width = Std.int(view_width/cast_buffer.length);
		var verts = new nme.Vector<Float>();
		var idxs = new nme.Vector<Int>();
		
		for (ray in cast_buffer)
		{
			var dist_mod = Math.sqrt(ray.dist) * Math.cos(ray.ang);
			sz = Std.int(view_height / dist_mod);
			var y = midpoint - sz / 2;
			
			// flat color renderer
			//surf.bitmapData.fillRect(new Rectangle(x, Std.int(midpoint - sz / 2), 1, sz),Color.getMultiplied(ColHTML5(CornflowerBlue), 1., 1., sz/view_height));
			
			var g : Graphics = surf[count].graphics;
			g.clear();
			
			var mtx = new Matrix();
			var h_scale = sz / tex.height;
			mtx.scale(1., h_scale);
			mtx.translate( -ray.tex_offset * tex.width, y);
			
			if (sz<view_height/2) // don't bother smoothing when small
				g.beginBitmapFill(tex, mtx, false, false);
			else
				g.beginBitmapFill(tex, mtx, false, true);
			g.drawRect(0, y, strip_width, sz);
			g.endFill();
			
			x += strip_width;
			count++;
		}
		
	}
	
	public function update(_)
	{
		environmentCollision();
		raycastMap();
		drawOverhead();
		drawBuffer();
	}
	
}