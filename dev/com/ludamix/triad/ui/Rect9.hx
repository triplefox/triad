package com.ludamix.triad.ui;
import com.ludamix.triad.tools.Color;
import flash.display.Sprite;
import nme.display.BitmapData;
import nme.geom.Matrix;
import nme.geom.Point;
import nme.geom.Rectangle;
import nme.display.Bitmap;
import nme.display.Sprite;

class Rect9 extends Sprite
{
	
	public var template : Rect9Template;
	
	public function new(template : Rect9Template, w : Int, h : Int, scale : Bool)
	{
		this.template = template;
		super();
		template.draw(this, w, h, scale);
	}
	
	public function redraw(w,h,scale)
	{
		this.graphics.clear();
		template.draw(this, w, h, scale);
	}
	
}

class Rect9Template
{
	
	public var baseRect : { slices:Array<BitmapData>, x:Int,y:Int,w:Int,h:Int, szX:Int, szY:Int };
	
	public function new(base : BitmapData, rectx:Int, recty:Int, rectw:Int, recth:Int)	
	{
		var slices = new Array<BitmapData>();
		baseRect = { slices:slices, x:rectx, y:recty, w:rectw, h:recth, szX:base.width, szY:base.height };
		
		for (y in 0...3)
		{
			for (x in 0...3)
			{
				var tile = xyOf(x, y);
				
				var bd = new BitmapData(tile.w, tile.h, true, Color.ARGB(0, 0));
				
				bd.copyPixels(base, new Rectangle(tile.x, tile.y, tile.w, tile.h), new Point(0, 0), base, 
					new Point(tile.x, tile.y), false);
				slices.push(bd);
			}
		}
		
	}
	
	public inline function leftX() { return 0; }
	public inline function topY() { return 0; }
	public inline function leftW() { return baseRect.x; }
	public inline function topH() { return baseRect.y; }
	
	public inline function midX() { return baseRect.x; }
	public inline function midY() { return baseRect.y; }
	public inline function midW() { return baseRect.w; }
	public inline function midH() { return baseRect.h; }
	
	public inline function rightX() { return baseRect.x + midW(); }
	public inline function bottomY() { return baseRect.y + midH(); }
	public inline function rightW() { return baseRect.szX - rightX(); }
	public inline function bottomH() { return baseRect.szY - bottomY(); }
	
	public inline function hBorder() { return leftW()+rightW(); }
	public inline function vBorder() { return topH()+bottomH(); }
	
	public function xyOf(x,y) 
	{
		var tileW = 0;
		var tileX = 0;
		var tileH = 0;
		var tileY = 0;
		switch(x)
		{
			case 0: tileW = leftW(); tileX = leftX();
			case 1: tileW = midW(); tileX = midX();
			case 2: tileW = rightW(); tileX = rightX();
		}
		switch(y)
		{
			case 0: tileH = topH(); tileY = topY();
			case 1: tileH = midH(); tileY = midY();
			case 2: tileH = bottomH(); tileY = bottomY();
		}
		return { x:tileX, y:tileY, w:tileW, h:tileH };
	}
	
	public function modXYOf(x, y, rectW, rectH)
	{
		var tileW = 0;
		var tileX = 0;
		var tileH = 0;
		var tileY = 0;
		switch(x)
		{
			case 0: tileW = leftW(); tileX = leftX();
			case 1: tileW = rectW - leftW() - rightW(); tileX = midX();
			case 2: tileW = rightW(); tileX = rectW - rightW();
		}
		switch(y)
		{
			case 0: tileH = topH(); tileY = topY();
			case 1: tileH = rectH - topH() - bottomH(); tileY = midY();
			case 2: tileH = bottomH(); tileY = rectH - bottomH();
		}
		return { x:tileX, y:tileY, w:tileW, h:tileH };
	}
	
	public function draw(sprite : Sprite, rectW : Int, rectH : Int, scale : Bool)
	{
		var pos = 0;
		
		for (s in baseRect.slices)
		{
			var widthLock : Bool = false;
			var heightLock : Bool = false;
			
			var tile : { x:Int, y:Int, w:Int, h:Int } = null;
			var modtile : { x:Int, y:Int, w:Int, h:Int } = null;
			
			switch(pos)
			{
				case 0: tile = xyOf(0, 0); modtile = modXYOf(0, 0, rectW, rectH);
				case 1: tile = xyOf(1, 0); modtile = modXYOf(1, 0, rectW, rectH);
				case 2: tile = xyOf(2, 0); modtile = modXYOf(2, 0, rectW, rectH);
				case 3: tile = xyOf(0, 1); modtile = modXYOf(0, 1, rectW, rectH);
				case 4: tile = xyOf(1, 1); modtile = modXYOf(1, 1, rectW, rectH);
				case 5: tile = xyOf(2, 1); modtile = modXYOf(2, 1, rectW, rectH);
				case 6: tile = xyOf(0, 2); modtile = modXYOf(0, 2, rectW, rectH);
				case 7: tile = xyOf(1, 2); modtile = modXYOf(1, 2, rectW, rectH);
				case 8: tile = xyOf(2, 2); modtile = modXYOf(2, 2, rectW, rectH);
			}
			
			var mtx = new Matrix();
			
			if (scale)
			{
				mtx.scale(modtile.w/tile.w, modtile.h/tile.h);
				mtx.translate(modtile.x, modtile.y);
				if (pos!=0 && pos!=2 && pos!=5 && pos!=8)
					sprite.graphics.beginBitmapFill(s, mtx, false, true);
				else
					sprite.graphics.beginBitmapFill(s, mtx, false, false);
				sprite.graphics.drawRect(modtile.x, modtile.y,modtile.w, modtile.h);
				sprite.graphics.endFill();
			}
			else
			{
				mtx.translate(modtile.x, modtile.y);
				sprite.graphics.beginBitmapFill(s, mtx, true);
				sprite.graphics.drawRect(modtile.x, modtile.y,modtile.w, modtile.h);
				sprite.graphics.endFill();
			}
			pos++;
		}		
	}
	
}