package com.ludamix.triad.ui;

import nme.display.BitmapData;
import nme.display.Sprite;
import nme.geom.Rectangle;
import nme.events.MouseEvent;

import com.ludamix.triad.audio.Audio;
import com.ludamix.triad.ButtonManager;
import com.ludamix.triad.ui.Button;
import com.ludamix.triad.ui.CascadingText;
import com.ludamix.triad.ui.CheckBox;
import com.ludamix.triad.ui.HSlider6;
import com.ludamix.triad.ui.Helpers;
import com.ludamix.triad.ui.Rect9;
import com.ludamix.triad.ui.layout.LayoutBuilder;

class SettingsUI extends Sprite
{
	
	var onClose : Void->Void;
	var bindingUI : LayoutResult;
	var layout : LayoutResult;
	var bindings : ButtonManager;
	
	var text : CascadingTextDef;
	var button : { up:LabelRect9Style, down:LabelRect9Style, over:LabelRect9Style, sizing:ButtonSizingStrategy };
	var frame : Rect9Template;
	var checkbox : {img:BitmapData,tw:Int,th:Int};
	var slider : { img:BitmapData, tw:Int, th:Int, drawmode:SliderDrawMode };
	var preserve : Array<Dynamic>;
	
	public function new(screenrect : Rectangle, frame : Rect9Template, 
			button : { up:LabelRect9Style, down:LabelRect9Style, over:LabelRect9Style, sizing:ButtonSizingStrategy },
			text : CascadingTextDef, checkbox : {img:BitmapData,tw:Int,th:Int},
			slider : {img:BitmapData,tw:Int,th:Int,drawmode:SliderDrawMode},
		?testsound : String = null, ?bindings : ButtonManager = null, ?onClose : Void->Void = null, 
		?desiredW : Float=400, ?desiredH : Float=350)
	{
		super();
		this.onClose = onClose;
		
		this.text = text;
		this.button = button;
		this.frame = frame;
		this.checkbox = checkbox;
		this.slider = slider;
		
		var elementList = new Array<LayoutDef>();
		
		if (testsound != null)
		{
			var soundTxt = Helpers.quickLabel(text, "Sound Settings");
			elementList.push(LDDisplayObject(soundTxt,LAC(0,0),null));
			
			var availableGroups = Reflect.fields(Audio.mix.data);
			availableGroups.sort(
				function(a:String, b:String) { a = a.toLowerCase(); b = b.toLowerCase(); if (a == b) return 0; else
					return a > b ? -1 : 1; }
			);
			
			for (n in availableGroups)
			{
				elementList.push(
					addSlider(n, Reflect.field(Audio.mix.data,n).vol, Reflect.field(Audio.mix.data,n).on, testsound));
			}
		}		
		
		if (bindings!=null)
		{
			
			this.bindings = bindings;
			
			var keys = new Hash<CascadingText>();
			
			var keyTxt = Helpers.quickLabel(text, "Keyboard Bindings");
			elementList.push(LDDisplayObject(keyTxt,LAC(0,0),null));
			
			for (n in bindings.getBindings())
			{
				elementList.push(addBindingRow(keys, n.name, ButtonManager.keyNameOf(n.code)));
			}
			
			var dbuttonsprite = Helpers.labelButtonRect9(button, "Reset to Defaults").button;
			var dbutton = LDDisplayObject(dbuttonsprite,LAC(0,0),"keyboardDefaults");
			
			elementList.push(dbutton);
			
			dbuttonsprite.onClick = function(_) { this.bindings.defaults(); 
				for ( n in keys.keys() )
				{
					keys.get(n).text = ButtonManager.keyNameOf(this.bindings.mappings.get(n).code);
				}
				this.bindings.save();
			};
		
		}
		
		elementList.push(LDDisplayObject(Helpers.labelButtonRect9(button,"Ok").button,LAC(0,0),"ok"));
		
		var self = this;
		
		layout = LayoutBuilder.create(screenrect.x, screenrect.y, screenrect.width, screenrect.height,
			LDRect9(new Rect9(frame, Std.int(desiredW), Std.int(desiredH), true), LAC(0, 0), "frame",
				LDPackV(LPMFixed(LSRatio(1)), LAC(0,0), null, elementList)));
		layout.keys.frame.mouseEnabled = false;
		this.addChild(layout.sprite);
		
		layout.keys.ok.onClick = function(_) { self.visible = false; 
		if (self.onClose!=null ){self.onClose();} };
		
		var ntd = CascadingText.injectDef(text, { text:"Placeholder bindingUI text", width:desiredW } );
		bindingUI = LayoutBuilder.create(screenrect.x, screenrect.y, screenrect.width, screenrect.height,
			LDRect9(new Rect9(frame, Std.int(desiredW), Std.int(desiredH), true), LAC(0, 0), "frame",
				LDDisplayObject(new CascadingText(ntd.field,ntd.format),
					LAC(0,0),"text")
				));
		
		this.addChild(bindingUI.sprite);
		bindingUI.sprite.visible = false;
		bindingUI.keys.frame.mouseEnabled = false;
		
	}

	public function addSlider(name : String, initVal : Float, initToggle : Bool, testsound : String)
	{
		
		var check = Helpers.checkboxImage(checkbox.img, checkbox.tw, checkbox.th, initToggle, function(_) { } );
		
		var widget = new HSlider6(this.slider.img, this.slider.tw, this.slider.th, 
			120, initVal, this.slider.drawmode, null);
		
		var title = Helpers.quickLabel(text, name);
		var label = Helpers.quickLabel(text, "100%");
		
		var test = Helpers.labelButtonRect9(button, "Test");
		if (testsound != null)
		{
			test.button.onClick = function(_) { 
				Audio.channelPlay(name, testsound, name, 0, 1, 1., 0., 0., OverwriteAlways); 
			};
		}
		
		var readOut = function() { 
			Audio.setMixgroup(name, check.state); 
			Audio.modMixgroup(name, widget.highlighted);
			if (check.state)
				label.text = Std.string(Std.int(widget.highlighted*100)) + "%";
			else 
				label.text = "OFF";				
			};
		
		widget.onSet = function(value : Float) { if (value > 0.) { check.state = true; }
			else { check.state = false; }
			readOut();  return null; };
		
		check.sendState = function(nstate : Bool) { if (nstate == true && widget.highlighted == 0. ) { 
			widget.highlighted = 1.; } 
			readOut(); return null;  };
		
		readOut();
		
		return LDPackH(LPMSpecified([LSRatio(0.5), LSPixel(8, true), LSPixel(8, true), LSRatio(0.2), LSRatio(0.5)]),
					LAC(0, 0), null,
					[LDDisplayObject(title, LACR(-8, 0),null),
					 LDDisplayObject(check, LAC(0, 0),null),
					 LDDisplayObject(widget, LAC(0, 0),null),
					 LDDisplayObject(label, LAC(0, 0), null),
					 LDDisplayObject(test.button, LACL(8, 0), null)]);
		
	}
	
	public function addBindingRow(keys, name : String, defaultBind : String)
	{
		var change = Helpers.labelButtonRect9(button, "Change");
		
		var bindT = Helpers.quickLabel(CascadingText.injectDef(text,{width:150}), defaultBind);
		var nameT = Helpers.quickLabel(text, name);
		keys.set(name, bindT);
		
		var startBind = function(_) { bindingUI.sprite.visible = true;
			bindingUI.keys.text.text = bindings.startBind(name, function(result:String) { 
				 bindingUI.sprite.visible = false; 
				 bindT.text = ButtonManager.keyNameOf(bindings.mappings.get(name).code); } ); };
		
		change.button.onClick = startBind;
		
		return LDPackH(LPMSpecified([LSRatio(0.5), LSRatio(0.5), LSRatio(0.5)]), LAC(0, 0), name,
					[LDDisplayObject(change.button, LACR( -8, 0), null),
					 LDPad(PadWH(100,0,true),LAC(0,0),null,LDDisplayObject(bindT, LACL(0, 0), null)),
					 LDDisplayObject(nameT, LACL(8, 0), null)]);
	}

}