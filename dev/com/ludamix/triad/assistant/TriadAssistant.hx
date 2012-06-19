package com.ludamix.triad.assistant;
import com.ludamix.triad.ui.CascadingText;
import com.ludamix.triad.ui.Helpers;
import com.ludamix.triad.ui.layout.LayoutBuilder;
import nme.display.DisplayObject;
import nme.display.Sprite;
import nme.events.KeyboardEvent;
import nme.events.MouseEvent;
import nme.Lib;
import nme.ui.Keyboard;

enum TriadAssistantState { TriadAssistantClosed; TriadAssistantOpen; TriadAssistantTorn; }

class TriadAssistant extends Sprite
{
	
	public var state : TriadAssistantState;
	public var view : Dynamic;
	public var apps : Array<AssistantApp>;
	public var curapp : Dynamic;
	
	public var sidebar : Sprite;
	public var textdef : CascadingTextDef;
	public var buttondef : LabelButtonStyle;
	private var sidebar_internal : DisplayObject;
	private var app_container : Sprite;
	
	public function new(view : Dynamic, textdef : CascadingTextDef, buttondef : LabelButtonStyle,
		?keyToggle:Int=-123, ?keyTear:Int=-123)
	{
		super();
		this.view = view;
		this.textdef = textdef;
		if (this.textdef == null) throw "Please make sure your textdef is initialized";
		this.buttondef = buttondef;
		if (this.buttondef == null) throw "Please make sure your buttondef is initialized";
		apps = new Array();
		sidebar = new Sprite();
		app_container = new Sprite();
		addChild(app_container);
		addChild(sidebar);
		close();
		
		if (keyToggle == -123)
			keyToggle = Keyboard.BACKSLASH;
		if (keyTear == -123)
			keyTear = Keyboard.RIGHTBRACKET;
		
		if (keyToggle > 0)
			Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, 
				function(e:KeyboardEvent) { var kei : Int = e.keyCode; if (kei == keyToggle) { toggle(); }} );
		if (keyTear > 0)
			Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, 
				function(e:KeyboardEvent) { var kei : Int = e.keyCode; if (kei == keyTear) { toggleTear(); }} );
		
	}
	
	public function addApps(_apps : Array<AssistantApp>)
	{
		for (app in _apps)
		{
			app.init(this);
			apps.push(app);
			app_container.addChild(app);
			app.visible = false;
		}
		renderSidebar();
	}
	
	public function open(?_)
	{
		state = TriadAssistantOpen;
		visible = true;
		sidebar.visible = true;
		updateApps();
	}
	
	public function close(?_)
	{
		state = TriadAssistantClosed;
		visible = false;
		sidebar.visible = false;
		updateApps();
	}
	
	public function tear(?_)
	{
		state = TriadAssistantTorn;
		visible = true;
		sidebar.visible = false;
		updateApps();
	}
	
	public function toggle(?_)
	{
		switch(state)
		{
			case TriadAssistantClosed:
				open();
			case TriadAssistantOpen:
				close();
			case TriadAssistantTorn:
				open();
		}
	}
	
	public function toggleTear(?_)
	{
		switch(state)
		{
			case TriadAssistantClosed:
				tear();
			case TriadAssistantOpen:
				tear();
			case TriadAssistantTorn:
				close();
		}
	}
	
	public function setApp(app : Dynamic)
	{
		curapp = app;
		updateApps();
	}
	
	public function renderSidebar()
	{
		if (sidebar_internal != null)
			sidebar.removeChild(sidebar_internal);
		sidebar_internal = null;
		
		var app_names = Lambda.map(apps, function(a:Dynamic) 
			{   var btn = Helpers.labelButtonRect9(buttondef, a.appId()).button;
				btn.addEventListener(MouseEvent.CLICK, function(_) { setApp(a); } );
				return LDDisplayObject(btn, LAC(0, 0), a.appId()); } );
		var app_ratios = Lambda.map(apps, function(a:Dynamic) 
			{ return LSMinimum; } );
		app_names.add(LDEmpty);
		app_ratios.add(LSRatio(1));
		
		sidebar_internal = LayoutBuilder.create(0, 0, Lib.current.stage.stageWidth, Lib.current.stage.stageHeight, 
			LDPackH(LPMSpecified([LSRatio(1),LSMinimum]),LATR(0,0),null,[LDEmpty,
				LDPackV(LPMSpecified(Lambda.array(app_ratios)),LATR(0,0),null,Lambda.array(app_names))])).sprite;
		
		sidebar.addChild(sidebar_internal);
	}
	
	public function updateApps()
	{
		for (n in apps)
		{
			n.visible = (n == curapp);
		}
	}
	
}