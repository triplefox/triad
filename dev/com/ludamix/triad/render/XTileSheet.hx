package com.ludamix.triad.render;

import nme.display.BitmapData;
import nme.display.Graphics;
import nme.display.Tilesheet;
import nme.geom.Point;
import nme.geom.Rectangle;

class XTilesheet
{

	public var sheet : Tilesheet;
	public var nmeBitmap : BitmapData;
	public var rects : Array<Rectangle>;
	public var points : Array<Point>;

	public function new(inImage : BitmapData)
	{ sheet = new Tilesheet(inImage); nmeBitmap = inImage; rects = new Array(); points = new Array(); }
	
	public inline function drawTiles(graphics : Graphics, tileData : Array<Float>, 
		?smooth : Bool=false, ?flags : Int=0)
	{ sheet.drawTiles(graphics, tileData, smooth, flags); }

	public inline function blit(bitmap : BitmapData, tileData : Array<Float>, ?smooth : Bool=false, ?flags : Int = 0)
	{
		// for right now we assume flags = 0.
		// fix this as we get more flags...
		// (also fix clear when doing so)
		var ptr = 0;
		var src : BitmapData = sheet.nmeBitmap;
		var pt = new Point(0., 0.);
		while (ptr < tileData.length)
		{
			pt.x = tileData[ptr];
			pt.y = tileData[ptr + 1];
			var rect : Rectangle = rects[Std.int(tileData[ptr + 2])];
			bitmap.copyPixels(src, rect, pt, src, new Point(rect.x,rect.y),true);
			ptr+=3;
		}
	}
	
	public inline function clear(bitmap : BitmapData, tileData : Array<Float>, ?color = 0)
	{
		var ptr = 0;
		var src : BitmapData = sheet.nmeBitmap;
		var r = new Rectangle(0., 0., 1.,1.);
		while (ptr < tileData.length)
		{
			r.x = tileData[ptr];
			r.y = tileData[ptr+1];
			var rect : Rectangle = rects[Std.int(tileData[ptr + 2])];
			r.width = rect.width;
			r.height = rect.height;
			bitmap.fillRect(r, color);
			ptr+=3;
		}
	}
	
	public inline function addTileRect(rectangle : Rectangle, ?centerPoint : Point=null)
	{
		sheet.addTileRect(rectangle, centerPoint);
		rects.push(rectangle);
		if (centerPoint == null)
			points.push(new Point(0.,0.));
		else
			points.push(centerPoint);
	}

}