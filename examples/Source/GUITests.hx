import com.ludamix.triad.io.ButtonManager;
import com.ludamix.triad.tools.Color;
import com.ludamix.triad.audio.Audio;
import com.ludamix.triad.ui.Helpers;
import com.ludamix.triad.ui.CascadingText;
import com.ludamix.triad.ui.HScrollbar6;
import com.ludamix.triad.ui.layout.LayoutBuilder;
import com.ludamix.triad.ui.HSlider6;
import com.ludamix.triad.ui.ScrollArea;
import com.ludamix.triad.ui.Rect9;
import com.ludamix.triad.ui.SettingsUI;
import nme.Assets;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.SimpleButton;
import nme.display.Sprite;
import nme.geom.Rectangle;
import nme.text.TextFormatAlign;
import nme.events.MouseEvent;
import nme.events.Event;
import nme.ui.Keyboard;
import nme.Lib;

class GUITests
{
	
	public var buttonmanager : ButtonManager;
	
	public function new()
	{
		
		var keys = [
			{ name:"Up", code:{keyCode:Keyboard.UP,charCode:0}, group:"Movement" },
			{ name:"Down", code:{keyCode:Keyboard.DOWN,charCode:0}, group:"Movement" },
			{ name:"Left", code: { keyCode:Keyboard.LEFT, charCode:0 }, group:"Movement" },
			{ name:"Right", code: { keyCode:Keyboard.RIGHT, charCode:0 }, group:"Movement" }
				];
		
		for (n in 0...10)
		{
			keys.push({name:"Foo"+Std.string(n),code:{keyCode:Keyboard.LEFT,charCode:0}, group:"Foo"});
		}
		
		buttonmanager = new ButtonManager(keys, 2);
		Audio.init();
		
		var bg = new Sprite();
		bg.graphics.beginFill(0xFF00FF,1.0);
		bg.graphics.drawRect(0, 0, Lib.current.stage.stageWidth, Lib.current.stage.stageHeight);
		bg.graphics.endFill();
		Lib.current.stage.addChild(bg);
		
		// clean this up to use CommonStyle
		
		var rr = new Rect9Template(Assets.getBitmapData("assets/frame.png"), 8, 8, 32, 32);
		var rrDown = new Rect9Template(Assets.getBitmapData("assets/frame2.png"), 8, 8, 32, 32);
		
		var textdata = { text:"Hello World", selectable:false };
		var fmtdata = { align:TextFormatAlign.CENTER };
		var cascade : CascadingTextDef = {field:[textdata],format:[fmtdata]};
		var styleUp : LabelRect9Style = {cascade:cascade, rect9 : rr };
		var styleDown : LabelRect9Style = {cascade:cascade, rect9 : rrDown };
		var btnstyle = {up:styleUp,down:styleDown,over:styleUp,sizing:BSSPad(10.,10.)};
		
		var btn = Helpers.labelButtonRect9(btnstyle);
		
		btn.button.x = 200;
		btn.button.y = 200;
		
		Lib.current.stage.addChild(btn.button);
		
		var scrollStyle1 = { bitmapdata: Assets.getBitmapData("assets/slider.png"), 
			tile_w:16, tile_h:16, drawmode:SliderRepeat};
		var scrollStyle2 = { bitmapdata: Assets.getBitmapData("assets/slider2.png"), 
			tile_w:16, tile_h:16, drawmode:SliderRepeat};
		var scrollStyle3 = { bitmapdata: Assets.getBitmapData("assets/scrollbar.png"), 
			tile_w:16, tile_h:16, drawmode:SliderRepeat};
		
		var hs = new HSlider6(scrollStyle1, 120, 0.5, null);
		var hs2 = new HSlider6(scrollStyle2, 120, 0.5, null, 0, false);
		var scroll = new HScrollbar6(scrollStyle3, 120, {pos:0.5,size:0.01}, null, 0, true, true);
		
		var chk = Helpers.checkboxImage(Assets.getBitmapData("assets/checkbox.png"), 16, 16, false, function(_) { } );
		chk.y = 200;		
		Lib.current.stage.addChild(chk);
		
		// basic nested box model
		
		var moo = LayoutBuilder.create(0, 0, 800, 100, 
			LDRect9(new Rect9(rr, 800, 80, true), LAC(0, 0), "panel",
				LDPackH(LPMMinimum,LAC(0,0),null,
				[
					LDPad(Pad4(100,0,0,0),LACL(0,0),null,
					LDDisplayObject(hs2,LAC(0,0),"slider")),
					LDPad(Pad4(100,0,0,0),LACL(0,0),null,
					LDDisplayObject(scroll,LAC(0,0),"scrollbar")),
				])
				));
		moo.keys.slider.beginAnimating(150., SAForever(ADPingpong));
		
		// complex packh/packv mixture
			
		/*var moo = LayoutBuilder.create(0, 0, 800, 100, 
			LDRect9(new Rect9(rr, 800, 200, true), LAC(0, 0), "panel", 
				LDPackV(LPMFixed(LSPixel(10,true)),LAC(0,0),null,[
					LDPackH(LPMSpecified([LSRatio(1),LSRatio(2),LSPixel(10,true)]), LAC(0, 0), null, 
					[LDRect9(new Rect9(rr, 50, 50, true), LAC(0, 0), null, LDEmpty),
					 LDRect9(new Rect9(rr, 100, 50, true), LAC(0, 0), null, LDEmpty),
					 LDRect9(new Rect9(rr, 70, 70, true), LAC(0, 0), null, LDEmpty)
					 ]),
					LDPackH(LPMSpecified([LSRatio(1),LSRatio(2),LSPixel(10,true)]), LAC(0, 0), null, 
					[LDRect9(new Rect9(rr, 50, 50, true), LAC(0, 0), null, LDEmpty),
					 LDRect9(new Rect9(rr, 100, 50, true), LAC(0, 0), null, LDEmpty),
					 LDRect9(new Rect9(rr, 70, 70, true), LAC(0, 0), null, LDEmpty)
					 ]),	 
				])));
		*/
		
		// packtable
		
		/*
		var rList = new Array<LayoutDef>();
		for (n in 0...9)
		{
			rList.push(LDRect9(new Rect9(rr, Std.int(Math.random()*100+10), Std.int(Math.random()*100+10), true), LAC(0, 0), null, LDEmpty));
		}
		var moo = LayoutBuilder.create(0, 0, 500, 500, 
			LDRect9(new Rect9(rr, 500, 500, true), LAC(0,0), null,
				LDPackTable(3, LPMFixed(LSPixel(10, true)), LPMFixed(LSPixel(10, true)), LAC(0, 0), null, rList)));
		*/
		
		Lib.current.stage.addChild(moo.sprite);
		
		var testbmp = new Bitmap(new BitmapData(500, 500, false, Color.ARGB(0,0)));
		#if flash
		testbmp.bitmapData.noise(5454, 0x000000, 0xFFFFFF);
		#end
		var sa = new ScrollArea(200, 200, testbmp, scrollStyle3);
		Lib.current.stage.addChild(sa);
		sa.x = 100;
		sa.y = 100;
		
		var ns = new SettingsUI(new Rectangle(0, 0, Lib.current.stage.stageWidth, Lib.current.stage.stageHeight),
			rr, { up:styleUp, down:styleDown, over:styleUp, sizing:BSSPad(10, 10) }, cascade, 
				{img:Assets.getBitmapData("assets/checkbox.png"), tw:16, th:16 },
				{bitmapdata:Assets.getBitmapData("assets/slider.png"), tile_w:16, tile_h:16, drawmode:SliderRepeat},
				{bitmapdata:Assets.getBitmapData("assets/scrollbar.png"), tile_w:16, tile_h:16, drawmode:SliderRepeat},
				"assets/sfx_test.mp3", 
				buttonmanager);
		Lib.current.stage.addChild(ns);
		
		
	}
	
	
}