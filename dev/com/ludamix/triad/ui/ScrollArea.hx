package com.ludamix.triad.ui;

import com.ludamix.triad.ui.Helpers;
import com.ludamix.triad.ui.HSlider6;
import com.ludamix.triad.ui.HScrollbar6;
import nme.display.BitmapData;
import nme.display.DisplayObject;
import nme.display.Sprite;

class ScrollArea extends Sprite
{
	
	public var use_horizontal : Bool;
	public var use_vertical : Bool;
	
	public var surface : DisplayObject;
	public var scroll_mask : Sprite;
	public var scroll_h : HScrollbar6;
	public var scroll_v : HScrollbar6;
	
	public var mask_width : Int;
	public var mask_height : Int;
	
	public function new(mask_width, mask_height, surface, 
		scroll_style : ScrollableStyle, ?use_horizontal = true, ?use_vertical = true)
	{
		super();
		
		this.surface = surface;
		addChild(surface);
		
		this.use_horizontal = use_horizontal;
		this.use_vertical = use_vertical;
		this.mask_width = mask_width;
		this.mask_height = mask_height;
		
		scroll_mask = new Sprite();
		
		scroll_h = new HScrollbar6(scroll_style, mask_width, { pos:0., size:1. }, setHorizontal);
		scroll_v = new HScrollbar6(scroll_style, mask_height, { pos:0., size:1. }, setVertical);
		
		scroll_v.rotation = 90;
		scroll_v.x = mask_width;
		scroll_v.y = 0;
		scroll_h.x = 0;
		scroll_h.y = mask_height - scroll_h.height;
		
		addChild(scroll_h);
		addChild(scroll_v);
		
		eval();
	}
	
	public inline function maskDraw(mw, mh)
	{
		scroll_mask.graphics.lineStyle(0, 0, 0);
		scroll_mask.graphics.beginFill(0, 0);
		scroll_mask.graphics.drawRect(0, 0, mw, mh);
		scroll_mask.graphics.endFill();		
		surface.mask = scroll_mask;
	}
	
	public function calcSizing()
	{
		// we do two passes to discover the case where adding a bar to one forces a bar on the other.
		
		var mh = use_horizontal && surface.width > this.mask_width ? mask_height - scroll_h.tile_h : mask_height;
		var mw = use_vertical && surface.height > this.mask_height ? mask_width - scroll_v.tile_w : mask_width;
		mh = use_horizontal && surface.width > mw ? mask_height - scroll_h.tile_h : mask_height;
		mw = use_vertical && surface.height > mh ? mask_width - scroll_v.tile_w : mask_width;
		return { w:mw, h:mh };
	}
	
	public function eval()
	{
		var size = calcSizing();
		
		scroll_h.visible = use_horizontal && surface.width > size.w;
		scroll_v.visible = use_vertical && surface.height > size.h;
		
		maskDraw(size.w, size.h);
		
		scroll_h.total_w = size.w;
		scroll_v.total_w = size.h;
			
		scroll_h.draw( { pos:scroll_h.highlighted.pos, size:size.w / surface.width } );
		scroll_v.draw( { pos:scroll_v.highlighted.pos, size:size.h / surface.height } );
			
	}
	
	public function setHorizontal(pos : Float)
	{
		var size = calcSizing();
		var w = surface.width - size.w;
		surface.x = -pos * w;
	}
	
	public function setVertical(pos : Float)
	{
		var size = calcSizing();
		var h = surface.height - size.h;
		surface.y = -pos * h;
	}
	
}