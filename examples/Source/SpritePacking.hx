import com.ludamix.triad.grid.Tilepack;
import flash.display.BitmapData;
import nme.display.Bitmap;
import nme.Assets;
import nme.display.Sprite;
import nme.Lib;
import nme.events.KeyboardEvent;

class SpritePacking
{
	
	public var bmp : Bitmap;
	
	public function new()
	{
		
		bmp = new Bitmap(new BitmapData(1, 1));
		Lib.current.addChild(bmp);
		doOver();
		
		Lib.current.stage.addEventListener(nme.events.KeyboardEvent.KEY_DOWN, doOver);
		
	}
	
	public function doOver(?event : KeyboardEvent)
	{
		var pack = new TilePack();
		for (n in 0...160)
		pack.add(
			new BitmapData(Std.int(Math.random() * 30 + 4), Std.int(Math.random() * 30 + 4), 
			//new BitmapData(16,16,
				true, 0xFF000000 + Std.int(Math.random() * 0xFFFFFF)));
		for (n in pack.basis)
		{
			n.setPixel32(0, 0, 0xFF000000);
			n.setPixel32(n.width-1, 0, 0xFF000000);
			n.setPixel32(0, n.height-1, 0xFF000000);
			n.setPixel32(n.width-1, n.height-1, 0xFF000000);
		}
		bmp.bitmapData = pack.compute(256);
	}
	
}