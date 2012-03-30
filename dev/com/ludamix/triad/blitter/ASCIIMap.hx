package com.ludamix.triad.blitter;

import com.ludamix.triad.blitter.Blitter;
import com.ludamix.triad.grid.IntGrid;
import com.ludamix.triad.tools.Color;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.geom.ColorTransform;
import nme.geom.Matrix;
import nme.geom.Point;
class ASCIIMap extends Bitmap
{
	
	// Custom renderer for "ASCII-like" character graphics
	
	public var sheet : ASCIISheet;
	public var char : IntGrid;
	private var swap : IntGrid;
	
	public function new(sheet : ASCIISheet, mapwidth : Int, mapheight : Int)
	{
		var vwidth = sheet.twidth * mapwidth;
		var vheight = sheet.theight * mapheight;
		
		super(new BitmapData(vwidth, vheight, false, Color.ARGB(0xFF00FF,0xFF)));
		
		this.sheet = sheet;
		
		var ar = new Array<Int>(); for (n in 0...mapwidth * mapheight) { ar.push(0); }
		var ar2 = new Array<Int>(); for (n in 0...mapwidth * mapheight) { ar.push(-1); }
		
		char = new IntGrid(mapwidth, mapheight, sheet.twidth, sheet.theight, ar);
		swap = new IntGrid(mapwidth, mapheight, sheet.twidth, sheet.theight, ar2);
		
	}
	
	public function update()
	{
		bitmapData.lock();
		var pt2 = new Point(0., 0.);
		var pt = new Point(0., 0.);		
		for (n in 0...char.world.length)
		{
			if (char.world[n] != swap.world[n])
			{
				var dec = decode(char.world[n]);
				var tinfos = sheet.chars[dec.bg][dec.fg][dec.char];
				bitmapData.copyPixels(tinfos.bd, tinfos.rect, pt, tinfos.bd, pt2, false);
			}
			pt.x += sheet.twidth; if (pt.x >= this.bitmapData.width) { pt.x = 0; pt.y += sheet.theight; }
		}
		bitmapData.unlock();		
		swap.world = char.world.copy();
	}
	
	public static inline function encode(bg_color : Int, fg_color : Int, char : Int)
	{
		return Color.buildRGB(bg_color, fg_color, char);
	}	
	
	public static inline function decode(packed : Int)
	{
		return { bg:Color.RGBred(packed), fg:Color.RGBgreen(packed), char:Color.RGBblue(packed) };		
	}

}