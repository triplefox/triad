import com.ludamix.triad.ascii.ASCIIMap;
import com.ludamix.triad.ascii.ASCIISheet;
import com.ludamix.triad.AssetCache;
import nme.events.Event;
import nme.Lib;

class ASCIITest
{
	
	public var ptr : Int;
	public var amap : ASCIIMap;
	public var asheet : ASCIISheet;
	
	public function new()
	{
		asheet = new ASCIISheet(AssetCache.getBitmapData("assets/VGA9x16.png"), 9, 16,
			[0x000000, 0x0000AA, 0x00AA00, 0x00AAAA, 0xAA0000, 0xAA00AA, 0xAA5500, 0xAAAAAA, 0x555555, 0x5555FF,
			0x55FF55,0x55FFFF,0xFF5555,0xFF55FF,0xFFFF55,0xFFFFFF]);
		amap = new ASCIIMap(asheet, 80, 25);
		
		Lib.current.stage.addChild(amap);
		
		Lib.current.addEventListener(Event.ENTER_FRAME, update);
		
		ptr = 0;
		update();
		
	}
	
	public function update(?_ : Dynamic = null)
	{
		for (n in 0...amap.char.world.length)
		{
			var np = n + ptr;
			amap.char.world[n] = ASCIIMap.encode(Std.int(np / 256) % 16 , Std.int(np / (256 * 16)) % 16, np % 256);
		}
		
		amap.update();		
		
		ptr += 4;
	}
	
}