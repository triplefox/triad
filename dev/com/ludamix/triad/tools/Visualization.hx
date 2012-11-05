package com.ludamix.triad.tools;

import nme.display.Bitmap;
import nme.display.BitmapData;
import com.ludamix.triad.tools.FastFloatBuffer;

class Visualization
{

	public static function waveform(wf : FastFloatBuffer, 
		display_width : Int, display_height : Int, ?bitmap : Bitmap)
	{
		var H = Std.int(display_height);
		var H1 = H >> 1;
		var LIM = display_height / 2 - 1;
		var spr = { if (bitmap != null) bitmap;
			else new Bitmap(new BitmapData(display_width, H, false, Color.ARGB(0,0)));}
		var scaleX = wf.length / display_width;
		for (n in 0...display_width)
		{
			spr.bitmapData.setPixel(Std.int(n), Std.int(H1 - LIM), 0x444400);
			spr.bitmapData.setPixel(Std.int(n), Std.int(H1 + LIM), 0x444400);
			spr.bitmapData.setPixel(Std.int(n), Std.int(H1), 0x444400);
		}
		var last = H1;
		var cur = H1;
		for (n in 0...display_width)
		{
			cur = Std.int(wf.get(Std.int(n*scaleX)) * LIM + H1);
			var top = Std.int(Math.max(cur, last));
			var bot = Std.int(Math.min(cur, last));
			for (z in bot...top)
			{
				spr.bitmapData.setPixel(Std.int(n), z, 0x00FF00);
			}
			spr.bitmapData.setPixel(Std.int(n), cur, 0x008800);
			last = cur;
		}
		return spr;
	}

}