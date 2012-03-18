package com.ludamix.triad.cards;

class Card
{
	
	public var owner : String;
	public var hidden : Bool;
	
	public function new(?owner : String = null, ?hidden = false) 
	{
		this.owner = owner;
		this.hidden = hidden;
	}
	
}