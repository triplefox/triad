package com.ludamix.triad.assistant;

import com.ludamix.triad.assistant.TriadAssistant;
import com.ludamix.triad.ui.CascadingText;
import com.ludamix.triad.ui.Helpers;
import nme.display.Sprite;
import nme.Lib;

class AssistantApp extends Sprite
{
	
	public var assistant : TriadAssistant;
	
	public function appId() { return "Appname"; }
	public function init(assistant) { this.assistant = assistant; }
	
	public function getSize()
	{
		return {w:Lib.current.stage.stageWidth, h:Lib.current.stage.stageHeight};
	}
	
	public function quickText(text : String, ?textfield : Dynamic, ?textformat : Dynamic)
	{
		var d = CascadingText.injectDef(assistant.textdef, textfield, textformat);
		return Helpers.quickLabel(d, text);
	}
	
	public function quickButton(label : String)
	{
		return Helpers.labelButtonRect9(assistant.buttondef, label);
	}
	
}