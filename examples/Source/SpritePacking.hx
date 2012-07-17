import com.ludamix.triad.render.TilePack;
import com.ludamix.triad.render.GraphicsResource;
import com.ludamix.triad.render.XTilesheet;
import flash.display.BitmapData;
import nme.display.Bitmap;
import nme.Assets;
import nme.display.Graphics;
import nme.display.Sprite;
import nme.display.Tilesheet;
import nme.Lib;
import nme.events.KeyboardEvent;

class SpritePacking
{
	
	public var bmp : Bitmap;
	
	public function new()
	{
		
		Lib.current.stage.color = 0x666666;
		
		bmp = new Bitmap(new BitmapData(1, 1));
		Lib.current.addChild(bmp);
		doInitial();
		
		Lib.current.stage.addEventListener(nme.events.KeyboardEvent.KEY_DOWN, doOver);
		
	}
	
	public function doInitial()
	{
		var infos = GraphicsResource.read(Assets.getText("assets/graphics.tc"), 512, true, "assets/");
		
		//bmp.bitmapData = infos.tilesheet.nmeBitmap;
		
		var spr = new Sprite();
		var g = spr.graphics;
		var ts : XTilesheet = infos.tilesheet;
		//ts.drawTiles(g, [0., 0., 20.]);
		
		Lib.current.addChild(spr);
		
	}
	
	public function doOver(?event : KeyboardEvent)
	{
		bmp.bitmapData = makePack();
	}
	
	public static function makePack() : BitmapData
	{
		var pack = new TilePack();
		for (n in 0...140)
		pack.add(
			new BitmapData(Std.int(Math.random() * 30 + 4), Std.int(Math.random() * 30 + 4), 
			//new BitmapData(16,16,
				true, 0xFF000000 + Std.int(Math.random() * 0xFFFFFF)),0,0);
		for (n in pack.basis)
		{
			n.bitmapdata.setPixel32(0, 0, 0xFF000000);
			n.bitmapdata.setPixel32(n.bitmapdata.width-1, 0, 0xFF000000);
			n.bitmapdata.setPixel32(0, n.bitmapdata.height-1, 0xFF000000);
			n.bitmapdata.setPixel32(n.bitmapdata.width-1, n.bitmapdata.height-1, 0xFF000000);
		}
		var bd = pack.compute(256, true).bitmapdata;
		return bd;	
	}
	
}