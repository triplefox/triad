package com.ludamix.triad.ui.layout;

import com.ludamix.triad.ui.layout.LayoutDef;
import com.ludamix.triad.ui.layout.LayoutAlign;

import haxe.Unserializer;
import nme.display.DisplayObject;
import nme.display.DisplayObjectContainer;
import nme.display.Sprite;

typedef LayoutResult = { keys:Dynamic, sprite:DisplayObject };

class LayoutBuilder
{
	
	public inline static function create(x : Float, y : Float, w : Float, h : Float, lh : LayoutDef) : LayoutResult
	{
		var widgetDict = { };
		return {sprite:rectangleData(x, y, w, h, lh, widgetDict),keys:widgetDict};
	}
	
	public static function estimateSize(lh : LayoutDef) : { w:Float, h:Float }
	{
		// determine the minimal size for the element and its children.
		// most of these return their children, 0,0, or an addition to them.
		
		switch(lh)
		{
			case LDEmpty: return {w:0.,h:0.};
			case LDPad(pad, align, name, inner):
				var est = estimateSize(inner);
				switch(pad)
				{
					case Pad4(l, t, r, b):
						est.w += l;
						est.w += r;
						est.h += t;
						est.h += b;
					case PadWH(w, h, lock):
						if (lock)
						{
							est.w = w;
							est.h = h;
						}
						else
						{
							est.w += w;
							est.h += h;
						}
				}
				return est;
			case LDRect9(widget, align, name, inner):
				return {w:widget.width,h:widget.height};
			case LDDisplayObjectContainer(widget, align, name, inner):
				return {w:widget.width,h:widget.height};
			case LDDisplayObject(widget, align, name):
				return {w:widget.width,h:widget.height};
			case LDPackH(packing, align, name, elements):
				var tw = 0.;
				var th = 0.;
				for (e in elements)
				{
					var est = estimateSize(e);
					th = Math.max(th, est.h);
					tw += est.w;
				}
				return {w:tw,h:th};
			case LDPackV(packing, align, name, elements):
				var tw = 0.;
				var th = 0.;
				for (e in elements)
				{
					var est = estimateSize(e);
					tw = Math.max(tw, est.w);
					th += est.h;
				}
				return {w:tw,h:th};
			case LDPackTable(cols, packingH, packingV, align, name, elements):
				// we go row-by-row.
				var ct = 0;
				var tw = 0.;
				var th = 0.;
				var rw = 0.;
				var rh = 0.;
				for (e in elements)
				{
					var est = estimateSize(e);
					rh = Math.max(rh, est.h);
					rw += est.w;
					ct++;
					if (ct >= cols)
					{
						th += rh;
						tw = Math.max(rw, tw);
						rw = 0.;
						rh = 0.;
						ct = 0;
					}
				}
				return {w:tw, h:th};
		}		
	}
	
	private static function commitWidget(widget : DisplayObjectContainer, name : String, widgetDict : Dynamic, inner : LayoutDef,
		ix : Float, iy : Float, wx : Float, wy : Float, iest : { w:Float, h:Float } )
	{
		if (name!=null)
			Reflect.setField(widgetDict, name, widget);
		var rd = rectangleData(ix, iy, iest.w, iest.h, inner, widgetDict);
		if (rd != null)
		{
			widget.addChild(rd);
		}
		widget.x = Std.int(wx);
		widget.y = Std.int(wy);		
		return widget;
	}
	
	private static function commitEndWidget(widget : DisplayObject, name : String, widgetDict : Dynamic, 
				wx : Float, wy : Float)
	{
		if (name!=null)
			Reflect.setField(widgetDict, name, widget);
		widget.x = Std.int(wx);
		widget.y = Std.int(wy);		
		return widget;
	}
	
	private static function commitWidgetMulti(widget : DisplayObjectContainer, name : String, widgetDict : Dynamic, 
		inner : Array<{def:LayoutDef,x:Float,y:Float,est:{w:Float,h:Float}}>, wx : Float, wy : Float)
	{
		if (name!=null)
			Reflect.setField(widgetDict, name, widget);
		for (i in inner)
		{
			var rd = rectangleData(i.x, i.y, i.est.w, i.est.h, i.def, widgetDict);
			if (rd != null)
			{
				widget.addChild(rd);
			}
		}
		widget.x = wx;
		widget.y = wy;
		return widget;
	}
	
	private static function applyAlignment(align : LayoutAlign, rx : Float, ry : Float, 
		rw : Float, rh : Float, ww : Float, wh : Float)
	{
		// given the alignment directive, the outer rectangle width and height, and the widget width and height,
		// find the appropriate position.
		switch(align)
		{
			case LAC(x, y):
				return { x:rx+x + rw / 2 - ww / 2, y:ry+y + rh / 2 - wh / 2 };
			case LATL(x,y):
				return { x:rx+x, y:ry+y };
			case LATR(x,y):
				return { x:rx+x + rw - ww, y:ry+y };
			case LABL(x,y):
				return { x:rx+x, y:ry+y + rh - wh };
			case LABR(x,y):
				return { x:rx+x + rw - ww, y:ry+y + rh - wh };
			case LATC(x,y):
				return { x:rx+x + rw / 2 - ww / 2, y:ry+y };
			case LABC(x,y):
				return { x:rx+x + rw / 2 - ww / 2, y:ry+y + rh - wh };
			case LACL(x,y):
				return { x:rx+x, y:ry+y + rh / 2 - wh / 2 };
			case LACR(x,y):
				return { x:rx+x + rw - ww, y:ry+y + rh / 2 - wh / 2 };
		}
	}
	
	public static function rectangleData(rx : Float, ry : Float, 
										 rw : Float, rh : Float, lh : LayoutDef, widgetDict : Dynamic)
	{
		
		// rectangleData takes in a suggested x, y, width, and height rectangle.
		// the LayoutDef determines how to allocate this rectangle - it may take more or less space, depending on the
		// contents.
		
		switch(lh)
		{
			case LDEmpty: 
				return null;
				
			case LDPad(pad, align, name, inner):
				
				// inner position
				var ix = 0.;
				var iy = 0.;
				// padding width/height
				var pw = 0.;
				var ph = 0.;
				
				// initial estimate from inner
				var iest = estimateSize(inner);
				
				switch (pad) 
				{
					case Pad4(l, t, r, b):
						ix = l;
						iy = t;
						pw = r + l + iest.w;
						ph = t + b + iest.h;
					case PadWH(w, h, lock):
						if (lock)
						{
							pw = w;
							ph = h;
						}
						else
						{
							pw = w + iest.w;
							ph = h + iest.h;
						}
						iest.w = pw;
						iest.h = ph;
				}
				
				var widget = new Sprite();
				#if layout_debug
					widget.graphics.lineStyle(3.);
					widget.graphics.drawRect(0, 0, pw, ph);
				#end
				var widgetPos = applyAlignment(align, rx, ry, rw, rh, pw, ph);
				return commitWidget(widget, name, widgetDict, inner, ix, iy, widgetPos.x, widgetPos.y, iest);
			case LDRect9(widget, align, name, inner):
				// uses the part inside the border as the inner bounds
				var inW = widget.width - widget.template.hBorder();
				var inH = widget.height - widget.template.vBorder();
				var widgetPos = applyAlignment(align, rx, ry, rw, rh, widget.width, widget.height);
				return commitWidget(widget, name, widgetDict, inner, widget.template.midX(), widget.template.midY(),
															  widgetPos.x, widgetPos.y,
															  {w:inW, h:inH});
			case LDDisplayObjectContainer(widget, align, name, inner):
				// passes through the original rectangle to any inner display objects.
				var widgetPos = applyAlignment(align, rx, ry, rw, rh, widget.width, widget.height);
				return commitWidget(widget, name, widgetDict, inner, 0., 0.,
															  widgetPos.x, widgetPos.y,
															  {w:widget.width,h:widget.height});
			case LDDisplayObject(widget, align, name):
				// tree ends with plain displayobjects.
				var widgetPos = applyAlignment(align, rx, ry, rw, rh, widget.width, widget.height);
				return commitEndWidget(widget, name, widgetDict, widgetPos.x, widgetPos.y);
			case LDPackH(packing, align, name, elements):
				
				var process_function = function(packing : LayoutPackingMethod, align : LayoutAlign, 
					name : String, elements : Array<LayoutDef>, 
					elementsizing : Array<LayoutSizing>) : DisplayObjectContainer
				{
					// in our first pass we ignore ratio elements
					var totalest = estimateSize(lh); // this is the _minimum_ estimated size.
					var x = 0.;
					var innerinfos = new Array<{x:Float,y:Float,est:{w:Float,h:Float},def:LayoutDef}>();
					var widgetPos : { x:Float, y:Float } = null;
					var widget = new Sprite();
					var ct = 0;
					var totalratio = 0.;
					for (e in elements)
					{
						var est : { w:Float, h:Float } = estimateSize(e);
						switch(elementsizing[ct])
						{
							case LSMinimum: {}
							case LSPixel(px, addinner): if (addinner) est.w += px; else est.w = px;
							case LSRatio(r): est.w = 0.; totalratio += r;
						}
						innerinfos.push( { def:e, x:x, y:0., est:est } );
						x += est.w;
						ct++;
					}
					var alloc = x;						
					var remainder = rw - alloc;
					
					// now we go back and fix all alignments using remainder and totalratio
					ct = 0;
					x = 0.;
					for (e in elements)
					{
						switch(elementsizing[ct])
						{
							case LSMinimum: {}
							case LSPixel(px, addinner): {}
							case LSRatio(r): innerinfos[ct].est.w = r/totalratio*remainder;
						}
						innerinfos[ct].x = Std.int(x);
						innerinfos[ct].est.h = rh;
						x += innerinfos[ct].est.w;
						ct++;
					}
					
					widgetPos = applyAlignment(align, rx, ry, rw, rh, x, rh);					
					return commitWidgetMulti(widget, name, widgetDict, innerinfos, widgetPos.x, widgetPos.y);
				};
				
				switch(packing)
				{
					case LPMMinimum:
						var ar = new Array<LayoutSizing>();
						for (n in elements) ar.push(LSMinimum);
						return process_function(packing, align, name, elements, ar);
					case LPMFixed(sizing):
						var ar = new Array<LayoutSizing>();
						for (n in elements) ar.push(sizing);
						return process_function(packing, align, name, elements, ar);
					case LPMSpecified(elementsizing):
						return process_function(packing, align, name, elements, elementsizing);
				}
			case LDPackV(packing, align, name, elements):
				// please note - this is really, really similar to LDPackH, so if there's a problem in one
				// it's probably in the other too.
 				var process_function = function(packing : LayoutPackingMethod, align : LayoutAlign, 
					name : String, elements : Array<LayoutDef>, 
					elementsizing : Array<LayoutSizing>) : DisplayObjectContainer
				{
					// in our first pass we ignore ratio elements
					var totalest = estimateSize(lh); // this is the _minimum_ estimated size.
					var y = 0.;
					var innerinfos = new Array<{y:Float,x:Float,est:{h:Float,w:Float},def:LayoutDef}>();
					var widgetPos : { y:Float, x:Float } = null;
					var widget = new Sprite();
					var ct = 0;
					var totalratio = 0.;
					for (e in elements)
					{
						var est : { h:Float, w:Float } = estimateSize(e);
						switch(elementsizing[ct])
						{
							case LSMinimum: {}
							case LSPixel(px, addinner): if (addinner) est.h += px; else est.h = px;
							case LSRatio(r): est.h = 0.; totalratio += r;
						}
						innerinfos.push( { def:e, y:y, x:0., est:est } );
						y += est.h;
						ct++;
					}
					var alloc = y;						
					var remainder = rh - alloc;
					
					// now we go back and fix all alignments using remainder and totalratio
					ct = 0;
					y = 0.;
					for (e in elements)
					{
						switch(elementsizing[ct])
						{
							case LSMinimum: {}
							case LSPixel(px, addinner): {}
							case LSRatio(r): innerinfos[ct].est.h = r/totalratio*remainder;
						}
						innerinfos[ct].y = Std.int(y);
						innerinfos[ct].est.w = rw;
						y += innerinfos[ct].est.h;
						ct++;
					}
					
					widgetPos = applyAlignment(align, rx, ry, rw, rh, rw, y);
					return commitWidgetMulti(widget, name, widgetDict, innerinfos, widgetPos.x, widgetPos.y);
				};
				
				switch(packing)
				{
					case LPMMinimum:
						var ar = new Array<LayoutSizing>();
						for (n in elements) ar.push(LSMinimum);
						return process_function(packing, align, name, elements, ar);
					case LPMFixed(sizing):
						var ar = new Array<LayoutSizing>();
						for (n in elements) ar.push(sizing);
						return process_function(packing, align, name, elements, ar);
					case LPMSpecified(elementsizing):
						return process_function(packing, align, name, elements, elementsizing);
				}				
			case LDPackTable(cols, packingH, packingV, align, name, elements):
				var pos = 0;
				var set = new Array<LayoutDef>();
				while (pos < elements.length)
				{
					var subs = new Array<LayoutDef>();
					for (n in 0...cols)
						subs.push(elements[pos + n]);
					set.push(LDPackH(packingH,LAC(0,0),null,subs));
					pos += cols;
				}
				return rectangleData(rx, ry, rw, rh, LDPackV(packingV, align, null, set),widgetDict);
		}
	}
	
}

// Alignments: Center, Top, Left, etc. all can be offset with an x/y

enum LayoutAlign {
	LAC(x : Float,y : Float);
	LATL(x : Float,y : Float);
	LATR(x : Float,y : Float);
	LABL(x : Float,y : Float);
	LABR(x : Float,y : Float);
	LATC(x : Float,y : Float);
	LABC(x : Float,y : Float);
	LACL(x : Float,y : Float);
	LACR(x : Float,y : Float);
}

// Definitions for layout elements - either widgets or widget containers.

enum LayoutDef {
	LDEmpty;
	LDPad(pad : PaddingDef, align : LayoutAlign, name : String, inner : LayoutDef);
	LDRect9(r : Rect9, align : LayoutAlign, name : String, inner : LayoutDef);
	LDDisplayObject(dobj : DisplayObject, align : LayoutAlign, name : String);
	LDDisplayObjectContainer(dobj : DisplayObjectContainer, align : LayoutAlign, name : String, inner : LayoutDef);
	LDPackH(packing : LayoutPackingMethod, align : LayoutAlign, name : String, elements : Array<LayoutDef>);
	LDPackV(packing : LayoutPackingMethod, align : LayoutAlign, name : String, elements : Array<LayoutDef>);
	LDPackTable(cols : Int, packingH : LayoutPackingMethod, packingV : LayoutPackingMethod, 
		align : LayoutAlign, name : String, elements : Array<LayoutDef>);
}

enum LayoutPackingMethod {
	LPMMinimum;
	LPMFixed(sizing : LayoutSizing);
	LPMSpecified(elementsizing : Array<LayoutSizing>);
}

// the types of padding we use. Applied on top of the inner sizing.

// Pad4 forces the inner to be constrained inside the specified padding distances, negating inner alignment.
// PadWH acts to respecify the amount of room given to the inner for alignment.
// PadWH with lock on ignores the inner object's size, and uses only the provided WH values.

enum PaddingDef {
	Pad4(l : Float, t : Float, r : Float, b : Float);
	PadWH(w : Float, h : Float, lock : Bool);
}

// LayoutSizing determines how we compute the width of elements
// LSMinimum packs the elements at their estimated size
// LSPixel uses a fixed amount and optionally adds to the estimated size
// LSRatio divides up the remaining available space after minimum and pixel elements are added
//     using the formula (element_r)/(sum of all element_r)

enum LayoutSizing {
	LSPixel(px : Float, addInner : Bool);
	LSRatio(r : Float);
	LSMinimum;
}
