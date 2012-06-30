import com.ludamix.triad.geom.AABB;
import com.ludamix.triad.geom.CollisionBroadphase;
import com.ludamix.triad.geom.SubINode;
import com.ludamix.triad.geom.SubIPoint;
import com.ludamix.triad.grid.AutotileBoard;
import com.ludamix.triad.grid.IntGrid;
import com.ludamix.triad.render.GraphicsResource;
import com.ludamix.triad.render.SpriteRenderer;
import com.ludamix.triad.render.TilesheetGrid;
import com.ludamix.triad.render.TilePack;
import flash.display.BitmapData;
import nme.display.Bitmap;
import nme.Assets;
import nme.display.Graphics;
import nme.display.Sprite;
import nme.display.Tilesheet;
import nme.Lib;
import nme.events.KeyboardEvent;

class CollisionTest
{
	
	public var gfx : Sprite;
	public var bc : CollisionBroadphase;
	public var cursor : BroadphaseNode;
	
	public function new()
	{
	
		gfx = new Sprite();
		Lib.current.addChild(gfx);
		bc = new CollisionBroadphase();
		cursor = bc.add(
			SubINode.fromFloat(Math.random() * Main.W, Math.random() * Main.H), 
			AABB.centerFromFloat(32, 32), 0, 1, 1);
		for (n in 1...32)
			bc.add(SubINode.fromFloat(Math.random() * Main.W, Math.random() * Main.H), 
			AABB.centerFromFloat(32, 32), n, 1, 1);
		
		Lib.current.addEventListener(nme.events.Event.ENTER_FRAME, render);
		
	}
	
	public function render(_)
	{
		cursor.point.setxf(Lib.current.stage.mouseX);
		cursor.point.setyf(Lib.current.stage.mouseY);
		var contacts = bc.update();
		
		var g : Graphics = gfx.graphics;
		g.clear();
		for (n in bc.nodes)
		{
			var r = n.point.rect(n.aabb);
			g.lineStyle(2, 0);
			var mark = 0x660000;
			for (c in contacts)
			{
				if (c.a == n.id || c.b == n.id)
				{
					mark = 0x006600; break;
				}
			}
			g.beginFill(mark, 1.);
			g.drawRect(r.lf(), r.tf(), r.wf(), r.hf());
			g.endFill();
		}
	}
	
}