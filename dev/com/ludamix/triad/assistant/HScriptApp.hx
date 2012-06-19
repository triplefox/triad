package com.ludamix.triad.assistant;

import com.ludamix.triad.assistant.AssistantApp;
import com.ludamix.triad.ui.layout.LayoutBuilder;
import nme.events.MouseEvent;
import nme.text.TextFieldAutoSize;
import nme.text.TextFieldType;
import nme.text.TextField;
import nme.text.TextFormat;
import hscript.Interp;
import hscript.Parser;

class HScriptApp extends AssistantApp
{
	
	// concept: two panes of equal size. One is output, one is input.
	
	public var text : TextField;
	public var input : TextField;
	public var interp : Interp;
	public var parse : Parser;
	
	public function new(interp : Interp)
	{
		super();
		this.parse = new Parser();
		this.interp = interp;
	}
	
	public override function appId() { return "HScript"; }
	
	public override function init(assistant) 
	{ 
		this.assistant = assistant; 
		
		var wh = getSize();
		this.graphics.beginFill(0, 0.4);
		this.graphics.drawRect(0, 0, wh.w, wh.h);
		this.graphics.endFill();
		text = quickText("Initialized.\n", 
			{width:wh.w, height:wh.h / 2 - 32, textColor: 0xFFFFFF, wordWrap:true, autoSize:TextFieldAutoSize.NONE,
				mouseEnabled:true, selectable:true, multiline:true}, 
			{align:nme.text.TextFormatAlign.LEFT});
		this.addChild(text);
		input = quickText("return \"hello world\";", 
			{width:wh.w, height:wh.h / 2, textColor: 0xFFFFFF, wordWrap:true, autoSize:TextFieldAutoSize.NONE,  
				type:TextFieldType.INPUT, mouseEnabled:true, selectable:true, multiline:true}, 
			{align:nme.text.TextFormatAlign.LEFT});
		this.addChild(input);
		input.y = wh.h / 2;
		var run = quickButton("Run").button;
		run.addEventListener(MouseEvent.CLICK, function(_) {
				text.text = interp.expr(parse.parseString(input.text));
			} );
		
		var run2 = quickButton("Restart+Run").button;
		run2.addEventListener(MouseEvent.CLICK, function(_) {
				text.text = interp.execute(parse.parseString(input.text));
			} );
		
		addChild(LayoutBuilder.create(0, wh.h / 2 - 32, wh.w, 32, 
			LDPackH(LPMMinimum, LAC(0, 0), null, 
				[LDDisplayObject(run,LAC(0,0),null), LDDisplayObject(run2,LAC(0,0),null)])).sprite);
	}
	
}