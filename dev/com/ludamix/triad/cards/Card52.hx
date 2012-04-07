package com.ludamix.triad.cards;

class Card52 extends Card
{
	
	public var idx : Int;
	
	public static inline var suit_names = ["Spades","Hearts","Diamonds","Clubs"]; // bridge ordering
	public static inline var value_names = ["Ace","2","3","4","5","6","7","8","9","10","Jack","Queen","King"];
	
	public function suit() { return Std.int(idx % 4); }
	public function value() { return Std.int(idx/4) + 1;	}
	public function suitName() { return suit_names[Std.int(idx % 4)]; }
	public function valueName() { return value_names[Std.int(idx/4)];	}
	
	public function new(suit : Int, value : Int, ?owner : String) 
	{
		this.idx = value*4 + suit;
		super(owner);
	}
	
	public static function deck(?d : Deck = null )
	{
		if (d == null)
			d = new Deck();
		for (s in 0...4)
		{
			for (v in 0...13)
			{
				d.push(new Card52(s, v, "deck"), "deck");
			}
		}
		return d;
	}
	
	public function toString()
	{
		if (hidden)
			return "Hidden";
		else if (idx == 52)
			return "Joker";
		else
			return valueName()+" of "+suitName();
	}
	
	public static inline function spriteNaming(idx : Int) : String
	{
		if (idx < 53) return "card_" + Std.string(idx);
			else return "card_back";
	}
	
}