package com.ludamix.triad.ui;
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

class HSlider6 extends Sprite
{
	
	/*
	 * Horizontal slider.
	 * Provide a bitmap containing these tiles:
	 * Left endcap (container)
	 * Bar (container)
	 * Right endcap (container)
	 * Left endcap (highlight)
	 * Bar (highlight)
	 * Right endcap (highlight)
	 * Handle
	 * */
	
	public var frames : Array<Array<BitmapData>>;
	public var tileW : Int;
	public var tileH : Int;
	public var sliderW : Int;
	public var onSet : Float->Void; // for clicking, not general events
	public var drawMode : SliderDrawMode;
	public var settable : Bool;
	
	public var frame : Int;
	public var pingpong : Bool;
	public var highlighted(default, draw) : Float;
	public var timer : Timer;
	public var animateType : SliderAnimType;
	
	private static inline var CLCAP = 0;
	private static inline var CBAR = 1;
	private static inline var CRCAP = 2;
	private static inline var HLCAP = 3;
	private static inline var HBAR = 4;
	private static inline var HRCAP = 5;
	private static inline var HANDLE = 6;

	public function new(base : BitmapData, tileW : Int, tileH : Int, sliderW : Int, highlighted : Float, drawmode : SliderDrawMode, 
		onSet : Float->Void, ?frame : Int = 0, ?settable : Bool = true)
	{
		super();
		
		var framecount = Std.int(base.height / tileH);
		frames = new Array<Array<BitmapData>>();
		for (y in 0...framecount)
		{
			var slices = new Array<BitmapData>();
			frames.push(slices);
			for (x in 0...7)
			{
					var bd = new BitmapData(tileW, tileH, true, Color.ARGB(0, 0));
					bd.copyPixels(base, new Rectangle(x * tileW, y * tileH, tileW, tileH), new Point(0, 0), base, 
						new Point(x * tileW, y * tileH), false);
					slices.push(bd);
			}
		}
		
		this.tileW = tileW;
		this.tileH = tileH;
		this.sliderW = sliderW;
		this.onSet = onSet;
		this.drawMode = drawmode;
		this.frame = frame;
		this.settable = settable;
		this.pingpong = false;
		
		draw(highlighted);
		
		this.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
		
	}
	
	public function draw(highlighted : Float)
	{
		this.graphics.clear();
		this.highlighted = highlighted;
		
		var pos = 0;
		var allocBar = sliderW - tileW * 2;
		var allocHighlight = Std.int((sliderW - tileW) * highlighted);
		var allocHandle = Std.int(sliderW * highlighted) - tileW;
		
		var slices = frames[frame];
		for (s in slices)
		{
			if (pos > 5) break;
			
			var xPos : Int = 0;
			var mW : Int = 0;
			var display = true;
			
			switch(pos)
			{
				case CLCAP: mW = tileW;
				case CBAR: xPos = tileW; mW = allocBar;
				case CRCAP: mW = tileW; xPos = sliderW - tileW;
				case HLCAP: mW = Std.int(MathTools.limit(0, tileW, allocHighlight + tileW/2 ));
				case HBAR: xPos = tileW; mW = Std.int(MathTools.limit(0, allocBar, allocHighlight - tileW/2));
				case HRCAP: xPos = sliderW - tileW; mW = Std.int(MathTools.limit(0, tileW, allocHighlight - tileW/2 - allocBar ));
			}
			
			if (mW > 0)
			{
				var mtx = new Matrix();
				if (pos == CBAR || pos == HBAR)
				{
					switch(drawMode)
					{
						case SliderCut:
							var sX = allocBar / tileW;
							mtx.scale( sX, 1.);							
						case SliderRepeat: {}
						case SliderStretch:
							var sX = mW / tileW;
							mtx.scale( sX, 1.);							
					}
				}
				mtx.translate( xPos, 0);
				
				this.graphics.beginBitmapFill(s, mtx, true, true);
				this.graphics.drawRect(xPos,0,mW,tileH);
				this.graphics.endFill();
			}
			
			pos++;
		}			
		
		var xPos = allocHighlight;
		var mtx = new Matrix();
		mtx.translate(xPos, 0);
		
		this.graphics.beginBitmapFill(slices[HANDLE], mtx);
		this.graphics.drawRect(xPos,0,tileW,tileH);
		this.graphics.endFill();
		
		return highlighted;
	}
	
	public function advanceFrame(ad : AnimDirection)
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
	
	public function onFrame(_)
	{
		
		var pct = MathTools.limit(0., 1., (this.mouseX)/sliderW);
		
		draw(pct);
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
		Lib.current.stage.removeEventListener(MouseEvent.MOUSE_UP,onUp); 
	}
	
}

enum SliderDrawMode { SliderStretch; SliderRepeat; SliderCut; }
enum SliderAnimType { SAForever(ad : AnimDirection); 
					  SAOnce(ad : AnimDirection); 
					  SATimes(ad : AnimDirection, n : Int); 
					  SAUntilHidden(ad : AnimDirection); }
enum AnimDirection { ADForward; ADBackward; ADPingpong; }