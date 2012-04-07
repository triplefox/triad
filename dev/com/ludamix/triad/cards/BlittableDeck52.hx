package com.ludamix.triad.cards;
import com.ludamix.triad.blitter.Blitter;
import com.ludamix.triad.cards.Card52;
import com.ludamix.triad.cards.Hand;
import com.ludamix.triad.geom.AABB;
import com.ludamix.triad.geom.SubINode;
import com.ludamix.triad.geom.SubIPoint;
import nme.geom.Point;

typedef HandDef = { hand:String, x : Float, y : Float, spacing : Float, max : Float, func : Dynamic };

class BlittableDeck52 extends SubINode
{
	
	public var hands : Array<HandDef>;
	
	public function new(hands : Array<HandDef>, deck : Deck, parent)
	{
		super(0, 0, parent);
		
		this.hands = hands;

	}
	
	public static function space(spacing : Float, elements : Float, max : Float) : Float
	{
		if (elements * spacing > max)
			return max / elements;		
		else
			return spacing;
	}
	
	public static function renderPile(idx : Int, x : Float, y : Float, spacing : Float, items : Int, max : Int, card_rect : AABB)
	{
		if (idx < 8) return new Point( x - Std.int(idx/2)*2, y - Std.int(idx/2)*2); else return new Point( x - 8, y - 8);
	}
	
	public static function renderRowRight(idx : Int, x : Float, y : Float, spacing : Float, items : Int, max : Int, card_rect : AABB)
	{
		var sp = space(spacing + card_rect.wf(), items, max);
		return new Point( x+idx*sp, y);
	}
	
	public static function renderRowLeft(idx : Int, x : Float, y : Float, spacing : Float, items : Int, max : Int, card_rect : AABB)
	{
		var sp = space(spacing + card_rect.wf(), items, max);
		return new Point( x-idx*sp, y);
	}
	
	public static function renderRowCenter(idx : Int, x : Float, y : Float, spacing : Float, items : Int, max : Int, card_rect : AABB)
	{
		var sp = space(spacing + card_rect.wf(), items, max);
		var basePos = sp * idx;
		var centerLine = items * sp / 2;
		return new Point( x + basePos - centerLine, y);
	}
	
	public static function renderColBottom(idx : Int, x : Float, y : Float, spacing : Float, items : Int, max : Int, card_rect : AABB)
	{
		var sp = space(spacing + card_rect.hf(), items, max);
		return new Point( x, -idx*sp+y);
	}
	
	public static function renderColTop(idx : Int, x : Float, y : Float, spacing : Float, items : Int, max : Int, card_rect : AABB)
	{
		var sp = space(spacing + card_rect.hf(), items, max);
		return new Point( x, idx*sp - max/2 + y);
	}
	
	public static function renderColCenter(idx : Int, x : Float, y : Float, spacing : Float, items : Int, max : Int, card_rect : AABB)
	{
		var sp = space(spacing + card_rect.hf(), items, max);
		var basePos = sp * idx;
		var centerLine = items * sp / 2;
		return new Point( x, y + basePos - centerLine);
	}
	
	public inline function renderDeck(deck : Deck, blitter : Blitter, card_rect : AABB)
	{
		var r = rect(card_rect);
		for (hdef in hands)
		{
			var hand = deck.hand(hdef.hand);
			for (n in 0...hand.cards.length)
			{
				var spt = SubIPoint.fromFPoint(hdef.func(
					n, hdef.x, hdef.y, hdef.spacing, hand.cards.length, hdef.max, card_rect) );
				spt.x += r.cx();
				spt.y += r.cy();
				renderCard(cast(hand.cards[n], Card52), 
					spt, blitter, Std.int(Math.min(blitter.sprite_queue.length-1, n)));
			}			
		}
	}
	
	public inline function testCards(deck : Deck, card_rect : AABB, mp : SubIPoint)
	{
		var results = new Array<Card>();
		for (hdef in hands)
		{
			var hand : Hand = deck.hand(hdef.hand);
			for (n in 0...hand.cards.length)
			{
				var spt = SubIPoint.fromFPoint(hdef.func(
					n, hdef.x, hdef.y, hdef.spacing, hand.cards.length, hdef.max, card_rect) );
				var r = rect(card_rect);
				r.x = spt.x + r.cx();	
				r.y = spt.y + r.cy();
				if (r.containsPoint(mp))
					results.push(hand.cards[n]);
			}			
		}
		return results;
	}
	
	public inline function renderCard(card : Card52, spt : SubIPoint, blitter : Blitter, z : Int)
	{
		var name = "card_back";
		if (!card.hidden)
		{
			name = "card_" + card.idx;
		}
		
		blitter.queueName(name, spt.xi(), spt.yi(), z);		

	}
	
}