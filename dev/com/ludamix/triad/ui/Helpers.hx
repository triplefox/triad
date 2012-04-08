package com.ludamix.triad.ui;
import nme.geom.Rectangle;
import nme.geom.Point;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.SimpleButton;
import com.ludamix.triad.ui.Rect9;
import com.ludamix.triad.ui.HSlider6;
import com.ludamix.triad.ui.CascadingText;
import com.ludamix.triad.ui.layout.LayoutBuilder;
import com.ludamix.triad.tools.Color;
import nme.text.TextFieldAutoSize;

typedef LabelRect9Style = {cascade : CascadingTextDef, rect9 : Rect9Template};
typedef LabelButtonStyle = { up:LabelRect9Style, down:LabelRect9Style, over:LabelRect9Style, sizing:ButtonSizingStrategy };

enum ButtonSizingStrategy {
	BSSFixed(w:Float,h:Float);
	BSSPad(w:Float,h:Float);
}

class Helpers
{
	
	public static function quickLabel(style : CascadingTextDef, text : String)
	{
		var ndef = quickLabelDef(style, text);
		return new CascadingText(ndef.field,ndef.format);
	}
	
	public static function quickLabelDef(style : CascadingTextDef, text : String)
	{
		return CascadingText.injectDef(style, { text:text, autoSize:TextFieldAutoSize.LEFT } );
	}
	
	public static function labelButtonRect9(
		style : LabelButtonStyle,
		?inject_text : String = null)
	{
		
		var style_up = style.up;
		var style_down = style.down;
		var style_over = style.over;
		
		if (inject_text != null)
		{
			style_up = { rect9:style.up.rect9, cascade:quickLabelDef(style.up.cascade, inject_text ) };
			style_down = { rect9:style.down.rect9, cascade:quickLabelDef(style.down.cascade, inject_text ) };
			style_over = { rect9:style.over.rect9, cascade:quickLabelDef(style.over.cascade, inject_text ) };
		}
		
		var w = -1.; var addw = 0.; 
		var h = -1.; var addh = 0.; 
		
		switch(style.sizing)
		{
			case BSSFixed(_w, _h):w = _w; h = _h;
			case BSSPad(w, h):addw = w; addh = h;
		}
		
		// we always add autosizing for our labels.
		var addWH = function(d : Array<Dynamic>) { 
			var mine = new Array<Dynamic>();  for (n in d) { mine.push(n); }
				mine.push( { autoSize:TextFieldAutoSize.LEFT } );
			return mine; }
		
		var up_ct = new CascadingText(addWH(style_up.cascade.field), style_up.cascade.format);	
		var over_ct = new CascadingText(addWH(style_over.cascade.field), style_over.cascade.format);
		var down_ct = new CascadingText(addWH(style_down.cascade.field), style_down.cascade.format);
		
		for (n in [up_ct, over_ct, down_ct])
		{
			w = Math.max(w, n.width);
			h = Math.max(h, n.height);
		}
		
		w += addw;
		h += addh;
			
		var iw = Std.int(w);
		var ih = Std.int(h);
		var up = LayoutBuilder.create(0, 0, w, h, LDRect9(new Rect9(style_up.rect9, iw,ih, true), LATL(0, 0), "button", 
			LDDisplayObject(up_ct,LAC(0,0),"text"))
		);
		var over = LayoutBuilder.create(0, 0, w, h, LDRect9(new Rect9(style_over.rect9, iw,ih, true), LATL(0, 0), "button", 
			LDDisplayObject(over_ct,LAC(0,0),"text"))
		);
		var down = LayoutBuilder.create(0, 0, w, h, LDRect9(new Rect9(style_down.rect9, iw,ih, true), LATL(0, 0), "button", 
			LDDisplayObject(down_ct,LAC(0,0),"text"))
		);
		
		return { button:new Button(up.sprite, over.sprite, down.sprite),
				 up:up,down:down,over:over};
	}
	
	public static function checkboxImage(base : BitmapData, tw : Int, th : Int, startState : Bool, sendState : Bool->Void)
	{
		var slices = new Array<Array<BitmapData>>();
		
		var sb = new Array<Button>();
		
		for (state in 0...2)
		{
			var overlay = { w:tw, h:th, x:Std.int(tw * (3 + state)), y:0 };
			var set = new Array<BitmapData>();
			slices.push(set);
			for (x in 0...3)
			{
				var tile = {w:tw,h:th,x:Std.int(tw*x),y:0};
				var bd = new BitmapData(tile.w, tile.h, true, Color.ARGB(0, 0));
				
				bd.copyPixels(base, new Rectangle(tile.x, tile.y, tile.w, tile.h), new Point(0, 0), base, 
					new Point(tile.x, tile.y), false);
				bd.copyPixels(base, new Rectangle(overlay.x, overlay.y, overlay.w, overlay.h), new Point(0, 0), base, 
					new Point(overlay.x, overlay.y), true);
				set.push(bd);
			}
			
			sb.push(new Button(new Bitmap(set[0]), new Bitmap(set[1]), new Bitmap(set[2])));
			
		}
		
		return new CheckBox(sb[1],sb[0],startState,sendState);
	}	
	
	public static function highlightingColor(hc:HighlightingColorDef) : {off:Int,highlighted:Int,down:Int}
	{
		switch(hc)
		{
			case HCPlaceholder:
				return { off:Color.get(DarkSlateGray), highlighted:Color.get(SlateGray), down:Color.get(Black) };
			case HCHueShift(primary,strength):
				return { off:Color.getShifted(primary, 0, 0, 0),
						 highlighted:Color.getShifted(primary, strength, 0, 0),
						 down:Color.getShifted(primary, -strength, 0, 0)
						 };
			case HCSatShift(primary,strength):
				return { off:Color.getShifted(primary, 0, 0, 0),
						 highlighted:Color.getShifted(primary, 0, strength, 0),
						 down:Color.getShifted(primary, 0, -strength, 0)
						 };
			case HCValShift(primary,strength):
				return { off:Color.getShifted(primary, 0, 0, 0),
						 highlighted:Color.getShifted(primary, 0, 0, strength),
						 down:Color.getShifted(primary, 0, 0, -strength)
						 };
			case HCHueSatShift(primary,strength):
				return { off:Color.getShifted(primary, 0, 0, 0),
						 highlighted:Color.getShifted(primary, strength, strength, 0),
						 down:Color.getShifted(primary, -strength, -strength, 0)
						 };
			case HCSatValShift(primary,strength):
				return { off:Color.getShifted(primary, 0, 0, 0),
						 highlighted:Color.getShifted(primary, 0, strength, strength),
						 down:Color.getShifted(primary, 0, -strength, -strength)
						 };
			case HCHueValShift(primary,strength):
				return { off:Color.getShifted(primary, 0, 0, 0),
						 highlighted:Color.getShifted(primary, strength, 0, strength),
						 down:Color.getShifted(primary, -strength, 0, -strength)
						 };
			case HCHueSatValShift(primary,strength):
				return { off:Color.getShifted(primary, 0, 0, 0),
						 highlighted:Color.getShifted(primary, strength, strength, strength),
						 down:Color.getShifted(primary, -strength, -strength, -strength)
						 };
			case HCTricolor(off,highlighted,down):
				return { off:Color.get(off),
						 highlighted:Color.get(highlighted),
						 down:Color.get(down)
						 };
			case HCDualcolor(off,down):
				return { off:Color.get(off),
						 highlighted:Color.get(off),
						 down:Color.get(down)
						 };
			case HCMono(c):
				return { off:Color.get(c),
						 highlighted:Color.get(c),
						 down:Color.get(c)
						 };
		}
	}
	
}

enum HighlightingColorDef {
	HCPlaceholder;
	HCHueShift(primary : EColor, strength : Float);
	HCSatShift(primary : EColor, strength : Float);
	HCValShift(primary : EColor, strength : Float);
	HCHueSatShift(primary : EColor, strength : Float);
	HCHueValShift(primary : EColor, strength : Float);
	HCSatValShift(primary : EColor, strength : Float);
	HCHueSatValShift(primary : EColor, strength : Float);
	HCTricolor(off : EColor, highlighted : EColor, down : EColor);
	HCDualcolor(off : EColor, down : EColor);
	HCMono(c : EColor);
}

typedef ConcreteHighlightingColor = {off:Int,highlighted:Int,down:Int};
