import com.ludamix.triad.grid.AutotileBoard;
import com.ludamix.triad.grid.IntGrid;
import com.ludamix.triad.grid.TilesheetGrid;
import com.ludamix.triad.grid.Tilepack;
import flash.display.BitmapData;
import nme.display.Bitmap;
import nme.Assets;
import nme.display.Sprite;
import nme.Lib;
import nme.events.KeyboardEvent;

class Tilemapping
{
	
	public var grid : TilesheetGrid;
	public var board : AutotileBoard;
	public var gfx : Bitmap;
	
	public function new()
	{
		
		var pop = new Array<Int>(); for (n in 0...32 * 32) pop.push(-1);
		grid = new TilesheetGrid(Assets.getBitmapData("assets/autotile.png"), 32, 32, 8, 8, pop);
		
		gfx = new Bitmap(new BitmapData(16*16,16*16));
		Lib.current.addChild(gfx);
		
		var defs = [ 
			{ name:"moo", indexes:[0, 1, 0 + 10, 1 + 10, 2, 3, 2 + 10, 3 + 10, 4, 5, 4 + 10, 5 + 10, 6, 7, 6 + 10, 7 + 10, 8, 9, 8 + 10, 9 + 10], mask:1 },
			{ name:"foo", indexes:[0, 1, 0 + 10, 1 + 10, 2, 3, 2 + 10, 3 + 10, 4, 5, 4 + 10, 5 + 10, 6, 7, 6 + 10, 7 + 10, 8, 9, 8 + 10, 9 + 10], mask:2 }
			];
		for (n in 0...defs[1].indexes.length)
			defs[1].indexes[n] = defs[1].indexes[n] + 20;
		pop = new Array<Int>(); for (n in 0...16 * 16) pop.push(0);
		board = new AutotileBoard(16, 16, 16, 16, pop, defs);
		doOver();
		
		Lib.current.addEventListener(nme.events.Event.ENTER_FRAME, render);
		Lib.current.stage.addEventListener(nme.events.KeyboardEvent.KEY_DOWN, doOver);
		
		render(null);
	}
	
	public function render(_)
	{
		grid.blitFromGrid(board.result, gfx.bitmapData, true);
	}
	
	public function doOver(?event : KeyboardEvent)
	{
		var pop = new Array<Int>(); for (n in 0...16 * 16) pop.push(0);
		board.source.world = pop;
		var x = 0; var y = 0;
		for (n in 0...120)
		{
			if (Math.random() > 0.5)
				x += Math.random() > 0.5 ? 1 : -1;
			else
				y += Math.random() > 0.5 ? 1 : -1;
			board.set2wrap(x, y, 1);
		}
		board.recacheAll();
		grid.blitFromGrid(board.result, gfx.bitmapData, false);
	}
	
}