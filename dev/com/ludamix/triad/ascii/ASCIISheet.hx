package com.ludamix.triad.ascii;
import com.ludamix.triad.blitter.Blitter;
import com.ludamix.triad.tools.Color;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.geom.ColorTransform;
import nme.geom.Matrix;
import nme.geom.Rectangle;
import nme.Lib;
class ASCIISheet
{
	
	// Renderer for "ASCII-like" character graphics
	
	public var chars : Array<Array<Array<BlitterTileInfos>>>;
	public var palette : Array<Int>;
	public var twidth : Int;
	public var theight : Int;
	
	private inline function storeTiles(bd : BitmapData, twidth : Int, theight : Int, fct : Int)
	{
		var x = 0;
		var y = 0;
		
		var ct = 0;
		
		var bctarray = new Array<BlitterTileInfos>();
		chars[fct].push(bctarray);
		
		while (y<bd.height)
		{
			while (x<bd.width)
			{
				bctarray.push(new BlitterTileInfos(bd, new Rectangle(x, y, twidth, theight)));
				x += twidth;
				ct++;
			}
			x = 0;
			y += theight;
		}
		
	}	
	
	public function new(sheet : BitmapData, twidth : Int, theight : Int, palette : Array<Int>)
	{
		this.palette = palette;
		
		chars = new Array();
		
		var fct = 0;
		for (fg_color in palette)
		{
			chars.push(new Array());
			
			var rgb = Color.RGBPx(fg_color);
			for (bg_color in palette)
			{
				#if neko
					var modsheet = new BitmapData(sheet.width, sheet.height, false, {rgb:bg_color,a:255});
				#else
					var modsheet = new BitmapData(sheet.width, sheet.height, false, bg_color);
				#end
				modsheet.draw(sheet, new Matrix(), new ColorTransform(0.0, 0.0, 0.0, 1.0, rgb.r, rgb.g, rgb.b, 0));
				storeTiles(modsheet, twidth, theight, fct);
			}
			fct++;
		}
		
		this.twidth = twidth;
		this.theight = theight;
		
	}

}