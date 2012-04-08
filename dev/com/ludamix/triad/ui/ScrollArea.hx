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
		scroll_mask.graphics.lineStyle(0, 0, 0);
		scroll_mask.graphics.beginFill(0, 0);
		scroll_mask.graphics.drawRect(0, 0, mask_width, mask_height);
		scroll_mask.graphics.endFill();
		
		surface.mask = scroll_mask;
		
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
	
	public function eval()
	{
		scroll_h.visible = use_horizontal && surface.width > this.mask_width;
		scroll_v.visible = use_vertical && surface.height > this.mask_height;
		
		if (scroll_h.visible && scroll_v.visible)
		{
			scroll_h.total_w = mask_width - scroll_h.tile_w;
			scroll_v.total_w = mask_height - scroll_v.tile_h;
			
			scroll_h.draw( { pos:scroll_h.highlighted.pos, size:mask_width / surface.width } );
			scroll_v.draw( { pos:scroll_v.highlighted.pos, size:mask_height / surface.height } );
			
		}
		else if (scroll_h.visible)
		{
			scroll_h.total_w = mask_width;
			scroll_h.draw( { pos:scroll_h.highlighted.pos, size:mask_width / surface.width } );
		}
		else if (scroll_v.visible)
		{
			scroll_v.total_w = mask_height;
			scroll_v.draw( { pos:scroll_v.highlighted.pos, size:mask_height / surface.height } );
		}
	}
	
	public function setHorizontal(pos : Float)
	{
		var w = surface.width - mask_width;
		surface.x = -pos * w;
	}
	
	public function setVertical(pos : Float)
	{
		var h = surface.height - mask_height;
		surface.y = -pos * h;
	}
	
}