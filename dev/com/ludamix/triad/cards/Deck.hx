package com.ludamix.triad.cards;

class Deck
{
	
	public var cards : Array<Card>;
	private var hands : Hash<Hand>;
	
	public function new()
	{
		cards = new Array();
		hands = new Hash();
	}
	
	public function hand(name : String)
	{
		if (hands.exists(name)) { return hands.get(name); }
		else { hands.set(name, new Hand(name)); return hands.get(name); }
	}
	
	public function push(card : Card, ?handName : String)
	{
		cards.push(card);
		if (handName != null)
			hand(handName).push(card);
	}
	
	public function drawAndMove(handFrom : String, handTo : String, ?position = -1)
	{
		var c = hand(handFrom).draw();
		moveCard(c, handTo, position);
		return c;
	}
	
	public function moveCard(card : Card, handTo : String, ?position = -1)
	{
		for (h in hands)
			h.remove(card);
		if (position==-1)
			hand(handTo).insert(card, hand(handTo).cards.length);
		else
			hand(handTo).insert(card, position);
	}
	
	public function withAllCards(func : Dynamic->Void)
	{
		for (n in cards)
		{
			func(n);
		}
	}
	
	public function withCardsIn(handName : String, func : Dynamic->Void)
	{
		for (n in hand(handName).cards.copy())
		{
			func(n);
		}
	}
	
}