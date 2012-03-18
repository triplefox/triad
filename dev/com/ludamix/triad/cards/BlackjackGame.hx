package com.ludamix.triad.cards;

class BlackjackGame extends Deck
{
	
	public var state : Int;
	
	public static inline var WIN = 0;
	public static inline var LOSE = 1;
	public static inline var PLAY = 2;
	
	public function new()
	{
		state = PLAY;
		super();
		Card52.deck(this);
	}
	
	public function permutations(hand : String)
	{
		var tot = 0;
		var aces = 0;
		withCardsIn(hand, function(card : Card52) { 
			var val = card.value(); if (val == 1) aces++; else tot += val; 
		} );
		
		if (aces == 0) return tot;
		
		var best = 99999;
		var ct = aces;
		while (ct > 0)
		{
			var result = tot + (aces - ct) + ct * 13;
			if ((result < best && best > 21) || (result > best && best <= 21 && result <= 21))			
				best = result;
			ct--;
		}
		return best;
	}
	
	public function check()
	{
		var minVal = permutations("player");		
		var dealerVal = permutations("dealer");
		
		if (minVal == 21) state = WIN;
		else if (dealerVal == 21) state = LOSE;
		else if (minVal > 21) state = LOSE;
		else if (dealerVal > 21) state = WIN;
		else state = PLAY;
		
		finalizeState();
	}
	
	public function stand()
	{
		if (state != PLAY) return;
		
		var minVal = permutations("player");		
		var dealerVal = permutations("dealer");
		
		if (minVal == 21) state = WIN;
		else if (dealerVal == 21) state = LOSE;
		else if (minVal > 21) state = LOSE;
		else if (minVal > dealerVal) state = WIN;
		else if (dealerVal > 21) state = WIN;
		else state = LOSE;
		
		finalizeState();
	}
	
	public function finalizeState()
	{
		if (state != PLAY)
		{
			withCardsIn("dealer", function(card : Card52) { 
				card.hidden = false;
			} );
			
			withCardsIn("deck", function(card : Card52) { 
				card.hidden = false;
			} );			
		}
	}
	
	public function start()
	{
		state = PLAY;
		
		withAllCards(function(card : Card52) { moveCard(card, "deck"); card.hidden = true; } );
		hand("deck").shuffle();
		
		for (n in 0...2)
		{
			var c = drawAndMove("deck", "player"); c.hidden = false;
			var c = drawAndMove("deck", "dealer"); c.hidden = true;
		}
		check();	
	}
	
	public function hit()
	{
		if (state != PLAY) return;
		var c = drawAndMove("deck", "player");
		c.hidden = false;
		check();
	}
	
	public function play(command : String) : Dynamic
	{
		// for console testing
		
		switch(command)
		{
			case "start":
				return [hand("player"), hand("dealer"), start()];
			case "hit":
				return [hand("player"), hand("dealer"), hit()];
			case "stand":
				return [hand("player"), hand("dealer"), stand()];
			default:
				return ["start,hit,stand"];
		}
		
	}
	
	public function stateText()
	{
		switch(state)
		{
			case PLAY: return "Try to get 21";
			case WIN: return "You Win";
			case LOSE: return "You Lose";
			default: return "";
		}
	}
	
	
}