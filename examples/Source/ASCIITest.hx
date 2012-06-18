import com.ludamix.triad.ascii.XBIN;
import com.ludamix.triad.ascii.ASCIIMap;
import com.ludamix.triad.ascii.ASCIISheet;
import nme.events.Event;
import nme.Lib;

typedef AssetCache = nme.Assets;

class ASCIITest
{
	
	public var ptr : Int;
	public var amap : ASCIIMap;
	public var asheet : ASCIISheet;
	
	public function new()
	{
		test2();
	}
	
	public function test1()
	{
		asheet = new ASCIISheet(AssetCache.getBitmapData("assets/VGA9x16.png"), 9, 16,
			[0x000000, 0x0000AA, 0x00AA00, 0x00AAAA, 0xAA0000, 0xAA00AA, 0xAA5500, 0xAAAAAA, 0x555555, 0x5555FF,
			0x55FF55,0x55FFFF,0xFF5555,0xFF55FF,0xFFFF55,0xFFFFFF]);
		amap = new ASCIIMap(asheet, 80, 25);
		
		Lib.current.stage.addChild(amap);
		
		Lib.current.addEventListener(Event.ENTER_FRAME, update1);
		
		ptr = 0;
		update1();
	}
	
	public function update1(?_ : Dynamic = null)
	{
		for (n in 0...amap.char.world.length)
		{
			var np = n + ptr;
			amap.char.world[n] = ASCIIMap.encode(Std.int(np / 256) % 16 , Std.int(np / (256 * 16)) % 16, np % 256);
		}
		
		amap.update();		
		
		ptr += 4;
	}
	
	public function test2()
	{
		var bd = haxe.io.Bytes.ofData(AssetCache.getBytes("assets/xbintest.xbin"));
		var xbt = XBIN.load(XBIN.load(bd).save()); // demonstrate load/save functionality
		
		asheet = new ASCIISheet(AssetCache.getBitmapData("assets/VGA9x16.png"), 9, 16,
			[0x000000, 0x0000AA, 0x00AA00, 0x00AAAA, 0xAA0000, 0xAA00AA, 0xAA5500, 0xAAAAAA, 0x555555, 0x5555FF,
			0x55FF55, 0x55FFFF, 0xFF5555, 0xFF55FF, 0xFFFF55, 0xFFFFFF]);
		
		// note: PabloDraw lies about which palette it's saving vs. which one it uses.
		// Otherwise I'd use the palette of the xb file.
		
		amap = new ASCIIMap(asheet, xbt.width, xbt.height);
		
		Lib.current.stage.addChild(amap);
		
		Lib.current.addEventListener(Event.ENTER_FRAME, update2);
		
		amap.blit(xbt.image24());
		
		update2();
	}
	
	public function update2(?_ : Dynamic = null)
	{
		
		var fg = new Array<Int>();
		var bg = new Array<Int>();
		for (n in 0...amap.char.worldW)
		{
			var val = ASCIIMap.decode(amap.char.c2t(n, 12));
			fg.push((val.fg+1) % 16);
			bg.push((16-(val.bg + 1)) % 16);
		}
		
		for (n in 0...13)
			amap.recolor(80, 1, 0, 12+n, fg, bg);
		
		amap.update();		
		
	}
	
}