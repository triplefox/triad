package com.ludamix.triad.render;

import com.ludamix.triad.geom.BinPacker;
import nme.display.BitmapData;
import nme.geom.Point;
import nme.geom.Rectangle;

typedef PackMode = Int;

class TilePack
{
	
	public static inline var PACK_EMPTY = 0; // adds 1 pixel empty.
	public static inline var PACK_BLEED = 1; // adds 1 pixel bleedover.
	
	// takes some input bitmapDatas and outputs a BitmapData with packed elements, suitable for a Tilesheet.
	
	public var basis : Array<{idx:Int,bitmapdata:BitmapData,offx:Int,offy:Int,packmode:PackMode}>;
	
	public function new()
	{
		basis = new Array();
	}
	
	public function add(bd : BitmapData, offx:Int, offy:Int, packmode:PackMode) 
	{ 
		basis.push( { idx:basis.length, bitmapdata:bd, offx:offx, offy:offy, packmode : packmode } ); 
	}
	
	/* add the image, sliced by the given width and height */
	public function addSlice(bd : BitmapData, w : Int, h : Int, offx:Int, offy:Int, packmode:PackMode)
	{
		var tw = Std.int(bd.width / w);
		var th = Std.int(bd.height / h);
		for (x in 0...tw)
		{
			for (y in 0...th)
			{
				var nb = new BitmapData(w, h, false, 0);
				nb.copyPixels(bd, new Rectangle(x * w, y * h, w, h), new Point(0., 0.), bd, new Point(0., 0.));
				add(nb,offx,offy,packmode);
			}
		}
	}
	
	public function compute(sheet_size : Int, sheet_border : Int,
		skipx : Int=1) : {bitmapdata:BitmapData,nodes:Array<PackerNode>}
	{	
		var bd = new BitmapData(sheet_size, sheet_size, true, 0);
		
		var add_val = sheet_border;
		var mul_val = sheet_border*2;
		
		var ar = new Array<BinPackerInput>();
		for (n in basis)
			ar.push({contents:n,w:n.bitmapdata.width+mul_val,h:n.bitmapdata.height+mul_val});
		var bp : BinPacker = new BinPacker(sheet_size, sheet_size, ar, skipx);
		
		for (n in bp.nodes)
		{
			n.x += add_val; n.y += add_val;
			n.w -= mul_val; n.h -= mul_val;
			bd.copyPixels(n.contents.bitmapdata, n.contents.bitmapdata.rect, 
			new Point(n.x, n.y), n.contents.bitmapdata, new Point(0., 0.), false);
			if (n.contents.packmode == PACK_BLEED && sheet_border > 0)
			{
				var l = Std.int(n.x);
				var t = Std.int(n.y);
				var r = Std.int(n.x + n.w - 1);
				var b = Std.int(n.y + n.h - 1);
				for (h in 0...n.contents.bitmapdata.height)
				{
					for (q in 0...add_val) 
					{
						bd.setPixel32(l - q - 1, Std.int(n.y + h), bd.getPixel32(l, Std.int(n.y + h)));
						bd.setPixel32(r + q + 1, Std.int(n.y + h), bd.getPixel32(r, Std.int(n.y + h)));
					}
				}
				for (w in 0...n.contents.bitmapdata.width)
				{
					for (q in 0...add_val) 
					{
						bd.setPixel32(Std.int(n.x + w), t - q - 1, bd.getPixel32(Std.int(n.x + w), t));						
						bd.setPixel32(Std.int(n.x + w), b + q + 1, bd.getPixel32(Std.int(n.x + w), b));
					}
				}
			}
		}
		
		return {bitmapdata:bd,nodes:bp.nodes};
		
	}
	
	
}
