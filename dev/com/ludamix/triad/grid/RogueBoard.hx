import com.ludamix.triad.grid.ObjectGrid;

class RogueBoard
{
	
	// A highly generalized board for a roguelike-type game, or any game using tile scale for all actors.
	// This should be integrated with the entity system... one for the world, one for the actors.
	// As well, I should have a RogueView? Maybe.
	
	public var tiles : ObjectGrid<Dynamic>;
	public var tileRepr : Dynamic->{char:Int,bg:Int,fg:Int};
	public var actors : Array<{id:Int, x:Int, y:Int, repr:Dynamic->{char:Int,bg:Int,fg:Int}}>;
	
	public function new(w,h,pop)
	{
		tiles = new ObjectGrid(w,h,1,1,pop);
	}
	
	public function infos(x, y)
	{
		var tile = tiles.c2t(x, y);		
		var actors = Lambda.filter(this.actors, function(a) { return a.x == x && a.y == y; } );
		return {tile:tile,actors:actors};
	}
	
}