package com.ludamix.triad.ui;
import com.ludamix.triad.ui.HSlider6;
import com.ludamix.triad.ui.layout.LayoutBuilder;
import com.ludamix.triad.tools.Color;
import com.ludamix.triad.tools.MathTools;
import nme.display.Sprite;
import nme.display.BitmapData;
import nme.events.Event;
import nme.events.MouseEvent;
import nme.events.TimerEvent;
import nme.geom.Matrix;
import nme.geom.Point;
import nme.geom.Rectangle;
import nme.display.Bitmap;
import nme.display.Sprite;
import nme.Lib;
import nme.utils.Timer;

class HScrollbar6 extends Sprite
{
	
	/*
	 * Similar to HSlider6, but uses a resizing handle indicating area covered.
	 * 
	 * Provide a bitmap containing these tiles:
	 * Left endcap (container)
	 * Bar (container)
	 * Right endcap (container)
	 * Left endcap (highlight)
	 * Bar (highlight)
	 * Right endcap (highlight)
	 * Spinner up
	 * Spinner down
	 * 
	 * */
	
	public var frames : Array<Array<BitmapData>>;
	public var tile_w : Int;
	public var tile_h : Int;
	public var total_w : Int;
	public var onSet : Float->Void; // for clicking, not general events
	public var drawMode : SliderDrawMode;
	public var settable : Bool;
	public var spinners : Bool;
	public var spin_amount : Float;
	public var spin_buffer : Int;
	public var spin_buffer_time : Int;
	public var spinner_l_down : Bool;
	public var spinner_r_down : Bool;
	public var dragging : Bool;
	
	public var frame : Int;
	public var pingpong : Bool;
	public var highlighted(default, draw) : {pos:Float,size:Float};
	public var timer : Timer;
	public var animateType : SliderAnimType;
	
	private static inline var CLCAP = 0;
	private static inline var CBAR = 1;
	private static inline var CRCAP = 2;
	private static inline var HLCAP = 3;
	private static inline var HBAR = 4;
	private static inline var HRCAP = 5;
	private static inline var SPINNER_UP = 6;
	private static inline var SPINNER_DOWN = 7;

	public function new(base : BitmapData, tile_w : Int, tile_h : Int, total_w : Int, 
		highlighted : { pos:Float, size:Float }, drawmode : SliderDrawMode, onSet : Float->Void, 
		?frame : Int = 0, ?settable : Bool = true, ?spinners : Bool = true, ?spin_amount : Float = 0.01,
		?spin_buffer_time = 18)
	{
		super();
		
		var framecount = Std.int(base.height / tile_h);
		frames = new Array<Array<BitmapData>>();
		for (y in 0...framecount)
		{
			var slices = new Array<BitmapData>();
			frames.push(slices);
			for (x in 0...8)
			{
					var bd = new BitmapData(tile_w, tile_h, true, Color.ARGB(0, 0));
					bd.copyPixels(base, new Rectangle(x * tile_w, y * tile_h, tile_w, tile_h), new Point(0, 0), base, 
						new Point(x * tile_w, y * tile_h), false);
					slices.push(bd);
			}
		}
		
		this.tile_w = tile_w;
		this.tile_h = tile_h;
		this.onSet = onSet;
		this.drawMode = drawmode;
		this.frame = frame;
		this.settable = settable;
		this.pingpong = false;
		this.total_w = total_w;
		this.spinners = spinners;
		this.spin_amount = spin_amount;
		this.spin_buffer = 0;
		this.spinner_l_down = false;
		this.spinner_r_down = false;
		this.dragging = false;
		this.spin_buffer_time = spin_buffer_time;
		
		draw(highlighted);
		
		this.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
		
	}
	
	public function draw(highlighted : {pos:Float,size:Float})
	{
		this.graphics.clear();
		this.highlighted = highlighted;
		
		if (highlighted.size > 1.) highlighted.size = 1.;
		
		var pos = 0;
		var spinner_size = spinners ? tile_w * 2 : 0;
		
		var bar_total = total_w - spinner_size;
		var bar_middle = total_w - tile_w * 2 - spinner_size;
		var bar_offset = spinners ? tile_w : 0;
		var highlight_total = Std.int(Math.max(tile_w * 2, highlighted.size * bar_total));
		var highlight_middle = Std.int(highlight_total - tile_w * 2);
		var highlight_pos = Std.int(bar_offset + MathTools.limit(0, bar_total - highlight_total, highlighted.pos * bar_total));
		
		// draw the spinners.
		
		var slices = frames[frame];
		
		var s = slices[SPINNER_UP];
		if (spinner_l_down)
			s = slices[SPINNER_DOWN];
		var mtx = new Matrix();
		this.graphics.beginBitmapFill(s, mtx, true, true);
		this.graphics.drawRect(0,0,tile_w,tile_h);
		this.graphics.endFill();
		
		var s = slices[SPINNER_UP];
		if (spinner_r_down)
			s = slices[SPINNER_DOWN];
		var mtx = new Matrix();
		mtx.rotate(Math.PI);
		mtx.translate(tile_w/2, 0.);
		this.graphics.beginBitmapFill(s, mtx, true, true);
		this.graphics.drawRect(total_w - tile_w,0,tile_w,tile_h);
		this.graphics.endFill();
		
		// draw the bars.
		
		for (s in slices)
		{
			if (pos > 5) break;
			
			var x_pos : Int = 0;
			var mW : Int = 0;
			var display = true;
			
			switch(pos)
			{
				case CLCAP: x_pos = bar_offset;  mW = tile_w;
				case CBAR: x_pos = bar_offset + tile_w; mW = bar_middle;
				case CRCAP: x_pos = bar_offset + bar_middle + tile_w; mW = tile_w;
				case HLCAP: x_pos = highlight_pos; mW = tile_w;
				case HBAR: x_pos = highlight_pos + tile_w; mW = highlight_middle;
				case HRCAP: x_pos = highlight_pos + tile_w + highlight_middle; mW = tile_w;
			}
			
			if (mW > 0)
			{
				var mtx = new Matrix();
				if (pos == CBAR)
				{
					switch(drawMode)
					{
						case SliderCut:
							var sX = bar_middle / tile_w;
							mtx.scale( sX, 1.);							
						case SliderRepeat: {}
						case SliderStretch:
							var sX = mW / tile_w;
							mtx.scale( sX, 1.);							
					}
				}
				else if (pos == HBAR)
				{
					switch(drawMode)
					{
						case SliderCut:
							var sX = highlight_middle / tile_w;
							mtx.scale( sX, 1.);							
						case SliderRepeat: {}
						case SliderStretch:
							var sX = mW / tile_w;
							mtx.scale( sX, 1.);							
					}
				}
				mtx.translate(x_pos, 0);
				
				this.graphics.beginBitmapFill(s, mtx, true, true);
				this.graphics.drawRect(x_pos,0,mW,tile_h);
				this.graphics.endFill();
			}
			
			pos++;
		}			
		
		return highlighted;
	}
	
	public function advanceFrame(ad : AnimDirection)
	{
		if (frames.length == 1) frame = 0;
		else
		{
			switch(ad)
			{
				case ADForward:
					frame = (frame + 1) % frames.length;
				case ADBackward:
					frame = frame - 1; if (frame < 0 ) frame = frames.length - 1;
				case ADPingpong:
					if (pingpong)
						{ frame = (frame - 1); if (frame == 0) pingpong = !pingpong; }
					else
						{ frame = (frame + 1); if (frame == frames.length-1) pingpong = !pingpong; }
			}
		}
		
		draw(this.highlighted);
	}
	
	private function onAnimate(_)
	{
		
		switch(animateType)
		{
			case SAForever(ad): advanceFrame(ad);
			case SAOnce(ad):
				advanceFrame(ad);
				timer.removeEventListener(TimerEvent.TIMER, onAnimate);
			case SATimes(ad, times):
				advanceFrame(ad);
				if (times > 0)
					this.animateType = SATimes(ad, times - 1);
				else
					timer.removeEventListener(TimerEvent.TIMER, onAnimate);
			case SAUntilHidden(ad):
				advanceFrame(ad);
				if (!this.visible)
					timer.removeEventListener(TimerEvent.TIMER, onAnimate);
		}
	}
	
	public function beginAnimating(delay : Float, animtype : SliderAnimType)
	{
		this.animateType = animtype;
		timer = new Timer(delay);
		timer.addEventListener(TimerEvent.TIMER, onAnimate);
		timer.start();
	}
	
	public function spinLeft() { return MathTools.limit(0., 1., highlighted.pos - spin_amount); }
	public function spinRight() { return MathTools.limit(0., 1., highlighted.pos + spin_amount); }
	
	public function onFrame(_)
	{
		
		// A hideous stateful monster. I'm sorry.
		
		var spinner_size = spinners ? tile_w / total_w : 0.;
		var spinner_l = spinner_size;
		var spinner_r = 1. - spinner_size;
		var bar_size = 1. - spinner_size * 2;
		
		var visual_size = MathTools.limit((tile_w * 2)/(total_w)/bar_size, 1., highlighted.size);
		
		var pct = MathTools.limit(0., 1., (this.mouseX - tile_w) / (total_w - tile_w * 2));
		
		if (pct < spinner_l && !dragging && !spinner_r_down)
		{
			if (spin_buffer==0 || (spin_buffer>=spin_buffer_time))
				pct = spinLeft();
			else pct = highlighted.pos;
			spinner_l_down = true;
			spin_buffer += 1;
		}
		else if (pct > spinner_r && !dragging && !spinner_l_down)
		{
			if (spin_buffer==0 || (spin_buffer>=spin_buffer_time))
				pct = spinRight();
			else pct = highlighted.pos;
			spinner_r_down = true;
			spin_buffer += 1;
		}
		else if (!spinner_l_down && !spinner_r_down)
		{
			spinner_l_down = false;
			spinner_r_down = false;
			dragging = true;
			if (pct > highlighted.pos && pct < highlighted.pos + visual_size)
				pct = highlighted.pos;
			else if (pct >= highlighted.pos + visual_size)
				pct = pct - visual_size;
			spin_buffer = 0;
		}
		else
		{
			spinner_l_down = false;
			spinner_r_down = false;
			dragging = false;
			pct = highlighted.pos;
		}
			
		draw({pos:pct,size:highlighted.size});
		if (onSet!=null)
			onSet(pct);
	
	}
	
	public function onDown(_)
	{
		if (settable)
		{
			Lib.current.stage.addEventListener(Event.ENTER_FRAME, onFrame);		
			Lib.current.stage.addEventListener(MouseEvent.MOUSE_UP,onUp); 
		}
	}
	
	public function onUp(_)
	{
		Lib.current.stage.removeEventListener(Event.ENTER_FRAME, onFrame); 		
		Lib.current.stage.removeEventListener(MouseEvent.MOUSE_UP, onUp); 
		spinner_l_down = false;
		spinner_r_down = false;
		dragging = false;
		spin_buffer = 0;
		draw(highlighted);
	}
	
}
