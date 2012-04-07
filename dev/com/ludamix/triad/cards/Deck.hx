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
	
	public function push(card : Card, ?hand_name : String)
	{
		cards.push(card);
		if (hand_name != null)
			hand(hand_name).push(card);
	}
	
	public function drawAndMove(handFrom : String, hand_to : String, ?position = -1)
	{
		var c = hand(handFrom).draw();
		moveCard(c, hand_to, position);
		return c;
	}
	
	public function moveCard(card : Card, hand_to : String, ?position = -1)
	{
		for (h in hands)
			h.remove(card);
		if (position==-1)
			hand(hand_to).insert(card, hand(hand_to).cards.length);
		else
			hand(hand_to).insert(card, position);
	}
	
	public function withAllCards(func : Dynamic->Void)
	{
		for (n in cards)
		{
			func(n);
		}
	}
	
	public function withCardsIn(hand_name : String, func : Dynamic->Void)
	{
		for (n in hand(hand_name).cards.copy())
		{
			func(n);
		}
	}
	
}