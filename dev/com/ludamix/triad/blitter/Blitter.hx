package com.ludamix.triad.blitter;
import com.ludamix.triad.tools.Color;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.BitmapInt32;
import nme.geom.Point;
import nme.geom.Matrix;
import nme.geom.Rectangle;

class BlitterQueueInfos
{
	public var bd : BitmapData; public var rect : Rectangle; public var x : Int; public var y : Int;
	public function new(bd, rect, x, y) { this.bd = bd; this.rect = rect; this.x = x; this.y = y; }
}

class BlitterTileInfos
{
	public var bd : BitmapData; public var rect : Rectangle; 
	public function new(bd, rect) { this.bd = bd; this.rect = rect; }
}

class Blitter extends Bitmap
{
	
	public var spriteCache : Hash<BitmapData>;
	public var tileCache : Hash<BlitterTileInfos>;
	public var spriteQueue : Array<Array<BlitterQueueInfos>>;
	public var eraseQueue : Array<Rectangle>;
	
	public var fillColor : Int;
	
	public inline function getFillColor() : BitmapInt32
	{
		#if neko
			return {a:0xFF,rgb:fillColor};
		#else
			return fillColor;
		#end
	}
	
	public function new(width : Int, height : Int, transparent : Bool, color : Int, ?zlevels : Int = 32)
	{
		fillColor = color;
			super(new BitmapData(width, height, transparent, getFillColor()));
		spriteCache = new Hash();
		tileCache = new Hash();
		spriteQueue = new Array();
		eraseQueue = new Array();
		for (n in 0...zlevels)
		{
			spriteQueue.push(new Array());
		}
	}
	
	public inline function store(name : String, data : BitmapData)
	{
		spriteCache.set(name, data);
	}
	
	public function storeTiles(bd : BitmapData, twidth : Int, theight : Int, naming : Int->String)
	{
		var x = 0;
		var y = 0;
		
		var ct = 0;
		
		while (y<bd.height)
		{
			while (x<bd.width)
			{
				tileCache.set(naming(ct), new BlitterTileInfos(bd, new Rectangle(x, y, twidth, theight)));
				x += twidth;
				ct++;
			}
			x = 0;
			y += theight;
		}
		
	}	
	
	public inline function queueName(spr : String, x : Int, y : Int, z : Int)
	{
		if (tileCache.exists(spr))
		{
			var tile = tileCache.get(spr);
			spriteQueue[z].push( new BlitterQueueInfos(tile.bd, tile.rect, x, y));
		}
		else if (spriteCache.exists(spr))
		{
			var sprite = spriteCache.get(spr);
			spriteQueue[z].push( new BlitterQueueInfos(sprite, sprite.rect, x, y));
		}
	}
	
	public inline function queueBD(spr : BitmapData, x : Int, y : Int, z : Int)
	{
		spriteQueue[z].push(new BlitterQueueInfos(spr, spr.rect, x, y));
	}
	
	public inline function queueBDRect(spr : BitmapData, rect : Rectangle, x : Int, y : Int, z : Int)
	{
		spriteQueue[z].push(new BlitterQueueInfos(spr, rect, x, y));
	}
	
	public function update()
	{
		bitmapData.lock();
		for (n in eraseQueue)
			bitmapData.fillRect(n, getFillColor());
		eraseQueue = new Array();
		var pt = new Point(0., 0.);
		var pt2 = new Point(0., 0.);
		for (layer in this.spriteQueue)
		{
			while (layer.length>0)
			{
				var n : BlitterQueueInfos = layer.pop();
				pt.x = n.x;
				pt.y = n.y;
				bitmapData.copyPixels(n.bd, n.rect, pt, n.bd, pt2, true);
				eraseQueue.push(n.rect);
			}
		}
		bitmapData.unlock();
	}
	
}