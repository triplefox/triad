import com.ludamix.triad.assistant.TriadAssistant;
import com.ludamix.triad.assistant.AssistantApp;
import com.ludamix.triad.assistant.LoggerApp;
import com.ludamix.triad.assistant.HScriptApp;
import hscript.Interp;
import nme.display.Sprite;
class Assistant
{
	
	public var assist : TriadAssistant;
	
	public function new()
	{
		
		var testApp = new AssistantApp();
		testApp.graphics.beginFill(0xFF0000, 1);
		testApp.graphics.drawRoundRect(0, 0, 64, 64, 8);
		testApp.graphics.endFill();
		
		var loggerApp = new LoggerApp();
		var hscriptApp = new HScriptApp(new Interp());
		
		CommonStyle.init();
		
		assist = new TriadAssistant(this, CommonStyle.cascade, CommonStyle.basicButton);
		assist.addApps([testApp, loggerApp, hscriptApp]);
		nme.Lib.current.stage.addChild(assist);
		
		loggerApp.write("hello world");
		
	}
	
}