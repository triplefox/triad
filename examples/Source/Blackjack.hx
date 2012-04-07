import com.ludamix.triad.cards.BlittableDeck52;
import com.ludamix.triad.geom.AABB;
import com.ludamix.triad.ui.CascadingText;
import com.ludamix.triad.ui.Helpers;
import com.ludamix.triad.ui.layout.LayoutBuilder;
import com.ludamix.triad.ui.Rect9;
import com.ludamix.triad.ui.Button;
import nme.display.Bitmap;
import nme.display.Sprite;
import nme.events.Event;
import nme.events.MouseEvent;
import nme.geom.Point;
import nme.Lib;
import nme.Assets;
import com.ludamix.triad.tools.Color;
import com.ludamix.triad.blitter.Blitter;
import com.ludamix.triad.geom.SubIPoint;
import com.ludamix.triad.cards.Card52;
import com.ludamix.triad.cards.BlackjackGame;
import nme.text.TextField;

class Blackjack
{
	
	public var blitter : Blitter;
	public var cardRect : AABB;
	public var game : BlackjackGame;
	public var deck : BlittableDeck52;
	
	public var hit : Button;
	public var stand : Button;
	public var restart : Button;
	public var message : CascadingText;
	
	public static inline var SPRW = 74;
	public static inline var SPRH = 98;
	
	public function new()
	{
		blitter = new Blitter(Main.W, Main.H, false, 0x228833);
		Lib.current.addChild(blitter);
		
		cardRect = AABB.centerFromInt(SPRW, SPRH);
		
		blitter.storeTiles(Assets.getBitmapData("assets/cards.png"), SPRW, SPRH,
			Card52.spriteNaming);
		game = new BlackjackGame();
		deck = new BlittableDeck52([ 
			{ hand:"deck", x : 64., y : 20.+SPRH/2, spacing : 0., max : 0., func : BlittableDeck52.renderPile },
			{ hand:"player", x : 64., y : 128.+SPRH/2, spacing : 8., max : 512-128., func : BlittableDeck52.renderRowRight },
			{ hand:"dealer", x : 64., y : 228.+SPRH/2, spacing : 8., max : 512-128., func : BlittableDeck52.renderRowRight }
		], game, null);
		
		CommonStyle.init();
		
		hit = Helpers.labelButtonRect9(CommonStyle.basicButton, "Hit").button;
		stand = Helpers.labelButtonRect9(CommonStyle.basicButton, "Stand").button;
		restart = Helpers.labelButtonRect9(CommonStyle.basicButton, "Restart").button;
		message = Helpers.quickLabel(CommonStyle.cascade, "Message");
		
		hit.addEventListener(nme.events.MouseEvent.CLICK, onHit);
		stand.addEventListener(nme.events.MouseEvent.CLICK, onStand);
		restart.addEventListener(nme.events.MouseEvent.CLICK, onRestart);
		
		var layout = LayoutBuilder.create(0, Main.H*3/4, Main.W, 100, LDPackH(LPMFixed(LSPixel(20,true)),
			LAC(0, 0), null, [LDDisplayObject(hit, LAC(0, 0), null),
							LDDisplayObject(stand, LAC(0, 0), null),
							LDDisplayObject(restart, LAC(0, 0), null)]));
		
		Lib.current.addChild(layout.sprite);
		
		message.x = Main.W / 2 - message.width/2;
		message.y = layout.sprite.y;
		Lib.current.addChild(message);		
		
		game.start();		
		updateDisplay();
		
		Lib.current.stage.addEventListener(Event.ENTER_FRAME, onFrame);	
	}
	
	public function onFrame(ev : Event)
	{
	}
	
	public function updateDisplay()
	{
		deck.renderDeck(game, blitter, cardRect);
		blitter.update();
		message.text = game.stateText();
	}
	
	public function onHit(ev : MouseEvent) { game.hit(); updateDisplay(); }
	
	public function onStand(ev : MouseEvent) { game.stand(); updateDisplay(); }
	
	public function onRestart(ev : MouseEvent) { game.start(); updateDisplay(); }
	
}