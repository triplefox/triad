import com.ludamix.triad.ButtonManager;
import com.ludamix.triad.geom.AABB;
import com.ludamix.triad.ui.temperate.SettingsUI;
import format.hxsl.Shader;
import nme.display.Bitmap;
import nme.events.Event;
import nme.events.MouseEvent;
import nme.geom.Point;
import nme.Lib;
import nme.Assets;
import com.ludamix.triad.ui.StyledText;
import com.ludamix.triad.ui.RoundRectButton;
import com.ludamix.triad.ui.Values;
import com.ludamix.triad.tools.Color;
import com.ludamix.triad.blitter.Blitter;
import com.ludamix.triad.geom.SubIPoint;
import com.ludamix.triad.cards.Card52;
import com.ludamix.triad.cards.BlackjackGame;
import nme.text.TextField;
import nme.ui.Keyboard;

import format.agal.Tools;

class Invaders
{
	
	//public var quader : Quader;
	
	public var settings : SettingsUI;
	public var buttons : ButtonManager;
	
	public var s3d : flash.display.Stage3D;
	public var ctx : flash.display3D.Context3D;
	
	public function new()
	{
		buttons = new ButtonManager([ { name:"Up", code:Keyboard.UP, group:"Movement" },
			{name:"Down", code:Keyboard.DOWN, group:"Movement" },
			{name:"Left", code:Keyboard.LEFT, group:"Movement" },
			{name:"Right", code:Keyboard.RIGHT, group:"Movement" },
			{name:"Fire",code:Keyboard.A, group:"Fire" } ], 1);
		settings = new SettingsUI(null, buttons, function() { });
		
		Lib.current.addChild(settings);
		
		s3d = flash.Lib.current.stage.stage3Ds[0];
		s3d.addEventListener(Event.CONTEXT3D_CREATE, on3DContext);
		s3d.requestContext3D();
		
	}
	
	public function on3DContext(_)
	{
		ctx = s3d.context3D;
		ctx.enableErrorChecking = true;
		ctx.configureBackBuffer(flash.Lib.current.stage.stageWidth,
								flash.Lib.current.stage.stageHeight,
								0, true);
		
		//var shader = new Shader(ctx);
		
		var vbuf = ctx.createVertexBuffer(1, 1);
		var ibuf = ctx.createIndexBuffer(1);
		
		// TODO figure out the minimal triangle drawing necessities...
		// and then get to the point where I'm rendering some quads
		// at that point i'll be ready to build a sprite engine, more or less
		
		//ctx.drawTriangles(ibuf, 0, 1);
		
		//var pol = new Cu
		
		Lib.current.stage.addEventListener(Event.ENTER_FRAME, onFrame);		
	}
	
	public function onFrame(_)
	{
	}
	
}