package com.ludamix.triad.render;

import nme.utils.ByteArray;
import nme.utils.Endian;
import nme.Vector;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.BlendMode;
import nme.display.Graphics;
import nme.display.Sprite;
import nme.display.Tilesheet;
import nme.geom.ColorTransform;
import nme.geom.Matrix;
import nme.geom.Point;
import nme.geom.Rectangle;

#if flash11
import flash.display3D.Context3D;
import flash.display3D.textures.Texture;
#end

class XTile
{
	public var rect : Rectangle;
	public var uv : Rectangle;
	public var offset : Point;
	public function new(rect, uv, offset)
	{
		this.rect = rect;
		this.uv = uv;
		this.offset = offset;
	}
}

class XTilesheet
{

	public var sheet : Tilesheet;
	public var nmeBitmap : BitmapData;
	public var tiles : Array<XTile>;
	private var temp_bitmap : Bitmap;
	
	#if flash11	
	public var texture : Texture;
	#end

	public function new(inImage : BitmapData)
	{ sheet = new Tilesheet(inImage); nmeBitmap = inImage;
	  tiles = new Array(); 
	  temp_bitmap = new Bitmap(inImage);
	}
	
	public inline function drawTiles(graphics : Graphics, tileData : Array<Float>, 
		?smooth : Bool=false, ?flags : Int=0)
	{ sheet.drawTiles(graphics, tileData, smooth, flags); }

	public inline function blit(bitmap : BitmapData, tileData : Array<Float>, ?smooth : Bool=false, ?flags : Int = 0)
	{
		var ptr = 0;
		var src : BitmapData = sheet.nmeBitmap;
		bitmap.lock();
		var pt = new Point(0., 0.);
		if (flags == 0)
		{		
			while (ptr < tileData.length)
			{
				pt.x = Math.round(tileData[ptr]);
				pt.y = Math.round(tileData[ptr + 1]);
				var rect : Rectangle = tiles[Std.int(tileData[ptr + 2])].rect;
				
				bitmap.copyPixels(src, rect, pt, src, new Point(rect.x,rect.y),true);
				ptr+=3;
			}
		}
		else
		{
			var useAlpha = (flags & Tilesheet.TILE_ALPHA) > 0;
			var useRGB = (flags & Tilesheet.TILE_RGB) > 0;
			var useScale = (flags & Tilesheet.TILE_SCALE) > 0;
			var useRotate = (flags & Tilesheet.TILE_ROTATION) > 0;
			var tb = temp_bitmap;
			tb.bitmapData = src;
			while (ptr < tileData.length)
			{
				pt.x = tileData[ptr]; ptr++;
				pt.y = tileData[ptr]; ptr++;
				var tile = tiles[Std.int(tileData[ptr])];
				var offset : Point = tile.offset;
				var rect : Rectangle = tile.rect; ptr++;				
				var scale = 1.;
				var rotation = 0.;
				var red = 1.;
				var green = 1.;
				var blue = 1.;
				var alpha = 1.;
				if (useScale) { scale = tileData[ptr]; ptr++; }
				if (useRotate) { rotation = tileData[ptr]; ptr++; }
				if (useRGB) { red = tileData[ptr]; green = tileData[ptr + 1]; blue = tileData[ptr + 2]; ptr += 3; }
				if (useAlpha) { alpha = tileData[ptr]; ptr++; }
				
				tb.scrollRect = rect;
				var ct = new ColorTransform(red, green, blue, alpha);
				var mtx = new Matrix();
				mtx.translate(-offset.x, -offset.y);
				mtx.scale(scale, scale);
				mtx.rotate(rotation);
				mtx.translate(pt.x+offset.x, pt.y+offset.y);
				
				bitmap.draw(tb,mtx,ct);
			}
		}
		bitmap.unlock();
	}
	
	public inline function clear(bitmap : BitmapData, tileData : Array<Float>, ?flags = 0, ?color = 0)
	{
		var ptr = 0;
		var src : BitmapData = sheet.nmeBitmap;
		var r = new Rectangle(0., 0., 1., 1.);
		var useScale = (flags & Tilesheet.TILE_SCALE) > 0;
		var useRotate = (flags & Tilesheet.TILE_ROTATION) > 0;
		var useRGB = (flags & Tilesheet.TILE_RGB) > 0;
		var useAlpha = (flags & Tilesheet.TILE_ALPHA) > 0;
		var advance = 3 + 
			(useScale ? 1 : 0) + 
			(useRotate ? 1 : 0) +
			(useRGB ? 3 : 0) + 
			(useAlpha ? 1 : 0);
		if (useScale || useRotate)
		{
			// less efficient than it could be - we just clear the entire potentially rotatable area.
			while (ptr < tileData.length)
			{
				r.x = tileData[ptr]; ptr++;
				r.y = tileData[ptr]; ptr++;
				var tile = tiles[Std.int(tileData[ptr])];
				var offset : Point = tile.offset;
				var rect : Rectangle = tile.rect; ptr++;				
				var scale = 1.;
				if (useScale) { scale = tileData[ptr]; ptr++; }
				if (useRotate) ptr++;
				if (useRGB) ptr += 3;
				if (useAlpha) ptr++;
				
				r.x -= rect.width * scale;
				r.y -= rect.height * scale;
				r.width = rect.width*2 * scale;
				r.height = rect.height*2 * scale;
				bitmap.fillRect(r, color);
			}
		}
		else
		{
			while (ptr < tileData.length)
			{
				r.x = tileData[ptr];
				r.y = tileData[ptr+1];
				var rect : Rectangle = tiles[Std.int(tileData[ptr + 2])].rect;
				r.width = rect.width;
				r.height = rect.height;
				bitmap.fillRect(r, color);
				ptr+=advance;
			}
		}
	}
	
	public inline function addTileRect(rectangle : Rectangle, ?centerPoint : Point=null)
	{
		sheet.addTileRect(rectangle, centerPoint);
		
		var left = rectangle.left / nmeBitmap.width;
		var right = rectangle.right / nmeBitmap.width;
		var top = rectangle.top / nmeBitmap.height;
		var bottom = rectangle.bottom / nmeBitmap.height;
		var uv = (new Rectangle(left, top, right - left, bottom - top));
		
		var offset : nme.geom.Point = null;
		if (centerPoint == null)
			offset = (new Point(0.,0.));
		else
			offset = (centerPoint);
		
		tiles.push(new XTile(rectangle, uv, centerPoint));
	}

}