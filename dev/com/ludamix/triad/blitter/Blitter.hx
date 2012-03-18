package com.ludamix.triad.blitter;
import com.ludamix.triad.tools.Color;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.BitmapInt32;
import nme.geom.Point;
import nme.geom.Matrix;
import nme.geom.Rectangle;

class Blitter extends Bitmap
{
	
	public var spriteCache : Hash<BitmapData>;
	public var spriteQueue : Array<Array<{bd:BitmapData,x:Int,y:Int}>>;
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
				var nt = new BitmapData(twidth, theight, true, Color.ARGB(0,0));
				var mtx = new Matrix();
				mtx.translate(-x, -y);
				nt.draw(bd, mtx);
				spriteCache.set(naming(ct), nt);
				x += twidth;
				ct++;
			}
			x = 0;
			y += theight;
		}
		
	}	
	
	public inline function queueName(spr : String, x : Int, y : Int, z : Int)
	{
		spriteQueue[z].push({bd:spriteCache.get(spr), x:x, y:y});
	}
	
	public inline function queueBD(spr : BitmapData, x : Int, y : Int, z : Int)
	{
		spriteQueue[z].push({bd:spr, x:x, y:y});
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
				var n : {bd:BitmapData,x:Int,y:Int} = layer.pop();
				pt.x = n.x;
				pt.y = n.y;
				bitmapData.copyPixels(n.bd, n.bd.rect, pt, n.bd, pt2, true);
				eraseQueue.push(new Rectangle(pt.x,pt.y,n.bd.width,n.bd.height));
			}
		}
		bitmapData.unlock();
	}
	
}