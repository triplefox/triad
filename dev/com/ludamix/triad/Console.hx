package com.ludamix.triad;

import flash.text.TextFieldAutoSize;
import flash.text.TextFormatAlign;
import hscript.Interp;
import hscript.Parser;
import Lambda;
import Type;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.events.KeyboardEvent;
import flash.filters.DropShadowFilter;
import flash.Lib;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.ui.Keyboard;

class Console extends Sprite
{
	
	// Envision Console 2.0....	
	// Something that lets me throw in tuning variables really quickly.
	// more clicky. more of a "palette" of stuff.
	// we run an "app launcher" interface.
	// one of the apps is a logging tool, of course.
	// another app is hscript.
	// goal of apps is to be so easy to make that you just do that instead of hacking it in.
	// apps need to be able to run over the gameplay as well. Hmm. So they're kind of a concern of the view.
	// I can get it all from this UI... I just need a difference between "close" and "background" modes.
	// what do I mean for "background?" "tear off" sort of works.
	// and then when you bring the appview up again, the torn off app just moves back into that context.
	
	// The high-level control should all take place over the entity system. Dogfood it! Prove it!
	// Tear-off also introduces a new hotkey to toggle it.
	
	/*             tear\ |   x
	 *                  \|
	 * appview           |apps
	 *                   |
	 *                   |
	 *                   |
	 * */
	
	public static var inst : Console;
	
	public var consoleInner : Sprite;
	
	public var procDisplay : TextField;
	
	public var text : TextField;
	public var textIn : TextField;
	public var on : Bool;
	
	public var history : Array<String>;
	public var historyPtr : Int;
	
	public var buf : Int;
	
	public var image : Bitmap;
	
	public var processes : Array<{name:String,code:Dynamic}>;
	public var interp : Interp;
	public var parse : Parser;	
	public var cacheFieldInfo : Hash<Array<String>>;
	
	public static function init()
	{
		inst = new Console();		
		addVariable("Console", Console);
		addVariable("Math", Math);
		addVariable("q", function(name:String) : Array<Dynamic> { 
			if (inst.cacheFieldInfo.exists(name))
				return inst.cacheFieldInfo.get(name);
			else
				return null;
		} );
	}
	
	public function getSize()
	{
		return {w:Lib.current.stage.stageWidth, h:Lib.current.stage.stageHeight};
	}
	
	private function addVariableFields(name : String, variable : Dynamic)
	{
		// traversal of the fields so that we can browse a (static cache) of them at runtime
		// we don't recurse this because there is potential of cycles; add each class/instance you need at init.
		var fields : Array<String> = null;
		try { 
			fields = Type.getClassFields(variable); 
		} catch(d:Dynamic){}
		if (fields == null || fields.length<1)
		{			
			try {
				fields = Type.getInstanceFields(variable);
			}
			catch ( de : Dynamic ) {}
		}
		cacheFieldInfo.set(name, fields);
	}
	
	public static function addVariable(name : String, variable : Dynamic, ?tryAddFields : Bool = true)
	{
		inst.interp.variables.set(name, variable);
		if (tryAddFields)
			inst.addVariableFields(name, variable);
	}
	
	public function new()
	{
		super();
		
		consoleInner = new Sprite();
		this.addChild(consoleInner);
		
		var wh = getSize();
		consoleInner.graphics.beginFill(0, 0.4);
		consoleInner.graphics.drawRect(0, 0, wh.w, wh.h);
		consoleInner.graphics.endFill();
		on = false;
		buf = 0;
		text = new TextField();
		text.text = "Console loaded\n";
		var txtFormat = new TextFormat(null, 16, 0xFFFFFF);
		text.defaultTextFormat = txtFormat;
		text.width = wh.w;
		text.height = wh.h;
		text.textColor = 0xFFFFFF;
		text.wordWrap = true;
		consoleInner.addChild(text);
		image = new Bitmap(new BitmapData(1, 1, true, 0));
		consoleInner.addChild(image);
		
		history = new Array();
		historyPtr = 0;
		
		textIn = new TextField();
		textIn.defaultTextFormat = txtFormat;
		textIn.width = wh.w;
		textIn.y = wh.h - 32;
		textIn.textColor = 0xFFFFFF;
		consoleInner.addChild(textIn);
		
		Lib.current.stage.addChild(this);
		forceToTop();
		
		processes = new Array();
		
		interp = new Interp();
		parse = new Parser();
		cacheFieldInfo = new Hash();
		
		procDisplay = new TextField();
		procDisplay.width = wh.w;
		procDisplay.height = wh.h;
		procDisplay.autoSize = TextFieldAutoSize.RIGHT;
		procDisplay.mouseEnabled = false;
		procDisplay.text = "hello";		
		var txtFormat = new TextFormat(null, 16, 0xFFFFFF,false,false,false,null,null,TextFormatAlign.RIGHT);
		procDisplay.textColor = 0xFFFFFF;
		procDisplay.defaultTextFormat = txtFormat;
		procDisplay.wordWrap = true;
		
		this.addChild(procDisplay);
		
	}
	
	public function forceToTop()
	{
		var idx = Lib.current.stage.getChildIndex(this);
		var lastidx = Lib.current.stage.numChildren - 1;
		if (idx != lastidx)
			Lib.current.stage.swapChildrenAt(idx, lastidx);		
		if (on)
			consoleInner.visible = true;
		else
			consoleInner.visible = false;		
	}
	
	public function onKey(ev : KeyboardEvent) : KeyboardEvent
	{		
		if (ev.charCode == "`".charCodeAt(0) && ev.ctrlKey)
		{
			on = !on;
			forceToTop();
			return null;
		}
		else if (on)
		{
			input(ev);
			forceToTop();
			return null;
		}
		else
			return ev;
	}
	
	public static function write(data : Dynamic)
	{
		inst.forceToTop();
		inst.buf++;
		if (inst.buf > 20) { inst.text.text = "";  inst.buf = 0; }
		inst.text.text += Std.string(data) + "\n";
	}
	
	public static function writeJoined(data : Array<Dynamic>, ?sep=" ")
	{
		write(data.join(sep));
	}
	
	public static function draw(bd : BitmapData)
	{
		var wh = inst.getSize();
		inst.image.bitmapData = bd;
		inst.image.x = wh.w - inst.image.width;
	}
	
	public static function input(ev : KeyboardEvent)
	{
		var textIn = inst.textIn;
		if (ev.charCode == Keyboard.BACKSPACE)
			textIn.text = textIn.text.substr(0, textIn.text.length - 1);
		else if (ev.charCode == Keyboard.ENTER)
		{
			// this relies a bit on modifying Interp to not do the "reset locals" thingy :|
			var result : Dynamic = null;
			try {
			 result = inst.interp.exprReturn(inst.parse.parseString(textIn.text));				
			}
			catch ( d : Dynamic ) { result = d; }
			if (result!=null && Reflect.hasField(result,"length"))
				Console.writeJoined(result);
			else
				Console.write(result);
			if (inst.historyPtr == inst.history.length)
			{
				inst.history.push(textIn.text);
				inst.historyPtr = inst.history.length;
			}
			textIn.text = "";
		}
		else if (ev.keyCode == Keyboard.UP)
		{
			inst.historyBack();
		}
		else if (ev.keyCode == Keyboard.DOWN)
		{
			inst.historyForward();
		}
		else
		{
			inst.historyPtr = inst.history.length;
			textIn.text += String.fromCharCode(ev.charCode);
		}
	}
	
	public function historyBack():Void 
	{
		historyPtr--;
		grabHistory();
	}

	public function historyForward():Void 
	{
		historyPtr++;
		grabHistory();
	}
	
	public function grabHistory():Void
	{
		if (historyPtr <= 0) historyPtr = 0;
		if (historyPtr >= history.length) historyPtr = history.length - 1;
		
		if (history.length == 0) return;
		else
		{
			textIn.text = history[historyPtr];
		}
	}
	
	public function runProcesses()
	{
		var lst = new Array<String>();
		var rm = new Array<Dynamic>();
		for (idx in 0...processes.length)
		{
			lst.push(Std.string(idx));
			lst.push(processes[idx].name);
			try {
				lst.push(Std.string(processes[idx].code()));
				lst.push("\n");
			}
			catch (d:Dynamic) { Console.write(d); rm.push(processes[idx]); }
		}
		for (r in rm) processes.remove(r);
		procDisplay.text = lst.join(" ");
	}
	
	public static function startProcess(name : String, code : Dynamic)
	{
		inst.processes.push({name:name,code:code});
	}
	
	public static function killProcess(name : String)
	{
		var tr = new Array<Dynamic>();
		var ct = 0;
		var num = -1;
		if (name.charAt(0) == "#")
			num = Std.parseInt(name.substr(1));
		for (n in inst.processes)
		{
			if (n.name == name || ct == num)
				tr.push(n);
			ct++;
		}
		for (n in tr)
			inst.processes.remove(n);
	}

}