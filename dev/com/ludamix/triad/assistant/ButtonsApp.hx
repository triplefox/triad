package com.ludamix.triad.assistant;

import com.ludamix.triad.assistant.AssistantApp;
import com.ludamix.triad.ui.layout.LayoutBuilder;
import nme.events.MouseEvent;

enum ButtonsFixture
{
	BFHeading(id:String, text:String);
	BFButton(id:String, text:String, fn:ButtonsApp->Void);
}

class ButtonsApp extends AssistantApp
{
	
	// concept: user inputs an ordered list of headings and buttons that do various app-specific things.
	
	public var fields : Array<ButtonsFixture>;
	public var layout : Dynamic;
	public var on_update : ButtonsApp->Void;
	
	public function new(fields : Array<ButtonsFixture>, ?on_update : Dynamic->Void)
	{
		this.fields = fields;
		if (on_update == null) on_update = function(ba) { } ;
		this.on_update = on_update;
		super();
	}
	
	public override function appId() { return "Buttons"; }
	
	public override function init(assistant) 
	{ 
		this.assistant = assistant; 
		
		var wh = getSize();
		
		var result = new Array<LayoutDef>();
		layout = { };
		
		for (n in fields)
		{
			switch n
			{
				case BFHeading(id, text):
					var widget = quickText(text);
					result.push(LDDisplayObject(widget, LAC(0, 0), null));
					Reflect.setProperty(layout, id, widget);
				case BFButton(id, text, fn):
					var widget = quickButton(text).button; 
					result.push(LDDisplayObject(widget,LAC(0,0),null));
					widget.addEventListener(MouseEvent.CLICK, function(_) { fn(this); on_update(this); } );
					Reflect.setProperty(layout, id, widget);
			}
		}
		
		addChild(LayoutBuilder.create(0, wh.h / 2 - 32, wh.w, 32, 
			LDPackH(LPMMinimum, LAC(0, 0), null, result)).sprite);
	}
	
}