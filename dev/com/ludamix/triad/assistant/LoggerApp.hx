package com.ludamix.triad.assistant;

import com.ludamix.triad.assistant.AssistantApp;
import nme.text.TextField;
import nme.text.TextFormat;
import nme.text.TextFieldAutoSize;

class LoggerApp extends AssistantApp
{
	
	public var text : TextField;
	public var buf : Int;
	
	public override function appId() { return "Logger"; }
	
	public override function init(assistant) 
	{ 
		this.assistant = assistant; 
		
		var wh = getSize();
		this.graphics.beginFill(0, 0.4);
		this.graphics.drawRect(0, 0, wh.w, wh.h);
		this.graphics.endFill();
		buf = 0;
		text = quickText("Logging started\n", 
			{width:wh.w, height:wh.h / 2 - 32, textColor: 0xFFFFFF, wordWrap:true, autoSize:TextFieldAutoSize.NONE,
				mouseEnabled:true, selectable:true, multiline:true}, 
			{align:nme.text.TextFormatAlign.LEFT});
		this.addChild(text);
		
	}
	
	public function write(data : Dynamic)
	{
		buf++;
		if (buf > 20) { text.text = "";  buf = 0; }
		text.text += Std.string(data) + "\n";
	}
	
	public function writeJoined(data : Array<Dynamic>, ?sep=" ")
	{
		write(data.join(sep));
	}
	
}