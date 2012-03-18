package com.ludamix.triad.cards;

class Hand
{
	
	public var cards : Array<Card>;
	public var name : String;
	
	public function new(name : String)
	{
		this.name = name;
		this.cards = new Array();
	}
	
	public function insert(card : Card, idx : Int)
	{
		cards.insert(idx, card);
		card.owner = name;
	}
	
	public function push(card : Card)
	{
		cards.push(card);
		card.owner = name;
	}
	
	public function pushBottom(card : Card)
	{
		cards.insert(0, card);
		card.owner = name;
	}
	
	public function draw()
	{
		var card = cards.pop();
		card.owner = null;
		return card;
	}
	
	public function drawBottom()
	{
		var card = cards.pop();
		card.owner = null;
		return card;
	}
	
	public function swap(a : Card, b : Card)
	{
		var nd = new Array<Card>();
		
		for (n in cards)
		{
			if (n == a)
			{
				nd.push(b);
			}
			else if (n == b)
			{
				nd.push(a);
			}
			else nd.push(n);
		}
		cards = nd;
	}
	
	public function swapIdx(a : Int, b : Int)
	{
		swap(cards[a], cards[b]);
	}
	
	public function shuffle()
	{
		var nd = new Array<Card>();
		while (cards.length > 0)
		{
			var z = Std.int(Math.random() * cards.length);
			var card = removeIdx(z);
			nd.push(card);
		}
		cards = nd;
	}
	
	public function remove(card : Card)
	{
		card.owner = null;
		cards.remove(card);
		return card;
	}
	
	public function removeIdx(idx : Int)
	{
		var card = cards[idx];
		card.owner = null;
		cards.remove(card);
		return card;
	}
	
	public function toString()
	{
		var ar = new Array<String>();
		for (c in cards)
			ar.push(Std.string(c));
		return Std.string(ar);
	}
	
	public function top()
	{
		return cards[cards.length - 1];
	}
	
	public function bottom()
	{
		return cards[0];
	}
	
}