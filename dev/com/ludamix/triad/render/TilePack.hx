package com.ludamix.triad.render;

import com.ludamix.triad.geom.BinPacker;
import nme.display.BitmapData;
import nme.geom.Point;
import nme.geom.Rectangle;

class TilePack
{
	
	// takes some input bitmapDatas and outputs a BitmapData with packed elements, suitable for a Tilesheet.
	
	public var basis : Array<{idx:Int,bitmapdata:BitmapData,offx:Int,offy:Int}>;
	
	public function new()
	{
		basis = new Array();
	}
	
	public function add(bd : BitmapData, offx:Int, offy:Int) 
	{ 
		basis.push( { idx:basis.length, bitmapdata:bd, offx:offx, offy:offy } ); 
	}
	
	/* add the image, sliced by the given width and height */
	public function addSlice(bd : BitmapData, w : Int, h : Int, offx:Int, offy:Int)
	{
		var tw = Std.int(bd.width / w);
		var th = Std.int(bd.height / h);
		for (x in 0...tw)
		{
			for (y in 0...th)
			{
				var nb = new BitmapData(w, h, false, 0);
				nb.copyPixels(bd, new Rectangle(x * w, y * h, w, h), new Point(0., 0.), bd, new Point(0., 0.));
				add(nb,offx,offy);
			}
		}
	}
	
	public function compute(sheet_size : Int, sheet_border : Bool,
		skipx : Int=1) : {bitmapdata:BitmapData,nodes:Array<PackerNode>}
	{	
		var bd = new BitmapData(sheet_size, sheet_size, true, 0);
		
		var add_val = sheet_border ? 1. : 0.;
		
		var ar = new Array<{w:Float,h:Float,contents:Dynamic}>();
		for (n in basis)
			ar.push({contents:n,w:n.bitmapdata.width+add_val,h:n.bitmapdata.height+add_val});
		var bp : BinPacker = new BinPacker(sheet_size, sheet_size, ar, skipx);
		
		for (n in bp.nodes)
		{
			n.w -= add_val; n.h -= add_val;
			bd.copyPixels(n.contents.bitmapdata, n.contents.bitmapdata.rect, 
			new Point(n.x, n.y), n.contents.bitmapdata, new Point(0., 0.), false);
		}
		
		return {bitmapdata:bd,nodes:bp.nodes};
		
	}
	
	
}
