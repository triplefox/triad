package com.ludamix.triad.quaddraw;
import nme.display.BitmapData;
import nme.display.Tilesheet;
import nme.display.Sprite;
import nme.geom.Rectangle;
import com.ludamix.triad.geom.AABB;
import com.ludamix.triad.tools.Color;

// as usual enums seem to be leading the way forward for how i do my definitions now...
// the idea seems to be simply that I go from "placeholder" sheets to more and more defined rect slices.
// the sheets are autopacked at load time for me; not in any particular order, at least for now.
// Once I do that, I can build drawing mechanisms, associations with ents, etc. on top....
//     It's still a little bit frustrating to build entities right now, however, if i enum everything
//     it should get easier and easier, until it's like I have the perfect setup.

typedef Slice = {sheet : Tilesheet, idx : Int, aabb : AABB};

enum OffsetPref = {
	OffTopLeft;
	OffCenter;
}

enum SheetDef = {
	SDSlicedWH(name:String, tex:BitmapData, w:Int, h:Int, offset:OffsetPref);
	SDSlicedRects(name:String, tex:BitmapData, rects:Array<Rectangle>, offset:OffsetPref);
	SDPlaceholder(name:String, color:EColor, w:Int, h:Int, offset:OffsetPref);	
};

class Quaddraw extends Sprite
{
	
	public var slices : Hash<Array<Slice>>;
	public var sheets : Array<Tilesheet>;
	
	public function new(defs : Array<SheetDef>, sheetsize : Int)
	{
		sheets = new Array();
		slices = new Hash();
	}
	
}