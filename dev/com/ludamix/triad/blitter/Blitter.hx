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
	
	public var sprite_cache : Hash<BitmapData>;
	public var tile_cache : Hash<BlitterTileInfos>;
	public var sprite_queue : Array<Array<BlitterQueueInfos>>;
	public var erase_queue : Array<Rectangle>;
	
	public var fill_color : Int;
	
	public inline function getFillColor() : BitmapInt32
	{
		#if neko
			return {a:0xFF,rgb:fill_color};
		#else
			return fill_color;
		#end
	}
	
	public function new(width : Int, height : Int, transparent : Bool, color : Int, ?zlevels : Int = 32)
	{
		fill_color = color;
			super(new BitmapData(width, height, transparent, getFillColor()));
		sprite_cache = new Hash();
		tile_cache = new Hash();
		sprite_queue = new Array();
		erase_queue = new Array();
		for (n in 0...zlevels)
		{
			sprite_queue.push(new Array());
		}
	}
	
	public inline function store(name : String, data : BitmapData)
	{
		sprite_cache.set(name, data);
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
				tile_cache.set(naming(ct), new BlitterTileInfos(bd, new Rectangle(x, y, twidth, theight)));
				x += twidth;
				ct++;
			}
			x = 0;
			y += theight;
		}
		
	}	
	
	public inline function queueName(spr : String, x : Int, y : Int, z : Int)
	{
		if (tile_cache.exists(spr))
		{
			var tile = tile_cache.get(spr);
			sprite_queue[z].push( new BlitterQueueInfos(tile.bd, tile.rect, x, y));
		}
		else if (sprite_cache.exists(spr))
		{
			var sprite = sprite_cache.get(spr);
			sprite_queue[z].push( new BlitterQueueInfos(sprite, sprite.rect, x, y));
		}
	}
	
	public inline function queueBD(spr : BitmapData, x : Int, y : Int, z : Int)
	{
		sprite_queue[z].push(new BlitterQueueInfos(spr, spr.rect, x, y));
	}
	
	public inline function queueBDRect(spr : BitmapData, rect : Rectangle, x : Int, y : Int, z : Int)
	{
		sprite_queue[z].push(new BlitterQueueInfos(spr, rect, x, y));
	}
	
	public function update()
	{
		bitmapData.lock();
		for (n in erase_queue)
			bitmapData.fillRect(n, getFillColor());
		erase_queue = new Array();
		var pt = new Point(0., 0.);
		var pt2 = new Point(0., 0.);
		for (layer in this.sprite_queue)
		{
			while (layer.length>0)
			{
				var n : BlitterQueueInfos = layer.pop();
				pt.x = n.x;
				pt.y = n.y;
				bitmapData.copyPixels(n.bd, n.rect, pt, n.bd, pt2, true);
				erase_queue.push(n.rect);
			}
		}
		bitmapData.unlock();
	}
	
}