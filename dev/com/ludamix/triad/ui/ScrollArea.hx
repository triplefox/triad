package com.ludamix.triad.ui;

import com.ludamix.triad.ui.Helpers;
import com.ludamix.triad.ui.HSlider6;
import com.ludamix.triad.ui.HScrollbar6;
import nme.display.BitmapData;
import nme.display.DisplayObject;
import nme.display.Sprite;
import nme.events.Event;
import nme.geom.Rectangle;

class ScrollArea extends Sprite
{
	
	public var use_horizontal : Bool;
	public var use_vertical : Bool;
	public var scrollbar_compact : Bool;
	
	public var surface : DisplayObject;
	public var scroll_h : HScrollbar6;
	public var scroll_v : HScrollbar6;
	
	public var mask_width : Int;
	public var mask_height : Int;
	
	public var last_x : Float;
	public var last_y : Float;
	
	#if flash
	public var mask_sprite : Sprite;	
	#end
	
	public function new(mask_width, mask_height, surface, 
		scroll_style : ScrollableStyle, ?use_horizontal = true, ?use_vertical = true, ?scrollbar_compact = true)
	{
		super();
		
		this.surface = surface;
		addChild(surface);
		
		this.use_horizontal = use_horizontal;
		this.use_vertical = use_vertical;
		this.mask_width = mask_width;
		this.mask_height = mask_height;
		
		// we have to implement this different on different targets. Flash uses a mask and hates the scrollrect.
		// Neko loves the scrollrect and crashes with a mask.
		
		#if flash
		mask_sprite = new flash.display.Sprite();
		mask_sprite.visible = false;
		addChild(mask_sprite);
		#end
		
		scroll_h = new HScrollbar6(scroll_style, mask_width, { pos:0., size:1. }, setHorizontal);
		scroll_v = new HScrollbar6(scroll_style, mask_height, { pos:0., size:1. }, setVertical);
		
		scroll_v.rotation = 90;
		
		addChild(scroll_h);
		addChild(scroll_v);
		
		last_x = 0.;
		last_y = 0.;
		eval();
		setHorizontal(0. );
		setVertical(0. );
		
	}
	
	public function calcSizing()
	{
		// we do two passes to discover the case where adding a bar to one forces a bar on the other.
		
		var mh = use_horizontal && surface.width > this.mask_width ? mask_height - scroll_h.tile_h : mask_height;
		var mw = use_vertical && surface.height > this.mask_height ? mask_width - scroll_v.tile_w : mask_width;
		mh = use_horizontal && surface.width > mw ? mask_height - scroll_h.tile_h : mask_height;
		mw = use_vertical && surface.height > mh ? mask_width - scroll_v.tile_w : mask_width;
		if (scrollbar_compact)
		{
			mh = Std.int(Math.min(mh, surface.height));
			mw = Std.int(Math.min(mw, surface.width));
		}
		return { w:mw, h:mh };
	}
	
	public function eval(?_)
	{
		
		var size = calcSizing();
		
		scroll_h.visible = use_horizontal && surface.width > size.w;
		scroll_v.visible = use_vertical && surface.height > size.h;
		
		scroll_h.total_w = size.w;
		scroll_v.total_w = size.h;
			
		scroll_h.draw( { pos:scroll_h.highlighted.pos, size:size.w / surface.width } );
		scroll_v.draw( { pos:scroll_v.highlighted.pos, size:size.h / surface.height } );
			
		scroll_v.x = size.w + scroll_v.tile_h; // the rotation does funny stuff
		scroll_v.y = 0;
		scroll_h.x = 0;
		scroll_h.y = size.h;
		
		setScrollRect(size);
	}
	
	public function setHorizontal(pos : Float)
	{
		var size = calcSizing();
		var w = surface.width - size.w;
		last_x = pos * w;
		eval();
	}
	
	public function setVertical(pos : Float)
	{
		var size = calcSizing();
		var h = surface.height - size.h;
		last_y = pos * h;
		eval();
	}
	
	public function setScrollRect(size)
	{
		#if flash
			surface.x = -last_x;
			surface.y = -last_y;
			mask_sprite.graphics.clear();
			mask_sprite.graphics.beginFill(0,0);
			mask_sprite.graphics.lineStyle(0,0,0);
			mask_sprite.graphics.drawRect(0, 0, size.w, size.h);
			mask_sprite.graphics.endFill();
			surface.mask = mask_sprite;
		#else
			surface.scrollRect = new Rectangle(last_x, last_y, size.w, size.h);
		#end		
	}
	
}