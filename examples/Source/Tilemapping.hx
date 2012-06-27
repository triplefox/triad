import com.ludamix.triad.grid.AutotileBoard;
import com.ludamix.triad.grid.IntGrid;
import com.ludamix.triad.render.SpriteRenderer;
import com.ludamix.triad.render.TilesheetGrid;
import com.ludamix.triad.render.TilePack;
import flash.display.BitmapData;
import nme.display.Bitmap;
import nme.Assets;
import nme.display.Sprite;
import nme.display.Tilesheet;
import nme.Lib;
import nme.events.KeyboardEvent;

class Tilemapping
{
	
	public var grid : TilesheetGrid;
	public var board : AutotileBoard;
	public var sprite : SpriteRenderer;
	public var gfx : Sprite;
	public var bmp : Bitmap;
	
	public var gfx_spr : Sprite;
	public var bmp_spr : Bitmap;
	
	public function new()
	{
		
		var pop = new Array<Int>(); for (n in 0...32 * 32) pop.push( -1);
		
		var gr = com.ludamix.triad.render.GraphicsResource.read(Assets.getText("assets/graphics.tc"), 512, "assets/");
		
		grid = new TilesheetGrid(gr.tilesheet, 32, 32, 8, 8, pop);
		
		bmp = new Bitmap(new BitmapData(16*16,16*16,true,0));
		Lib.current.addChild(bmp);
		bmp_spr = new Bitmap(new BitmapData(16*16,16*16,true,0));
		Lib.current.addChild(bmp_spr);
		gfx = new Sprite();
		Lib.current.addChild(gfx);
		gfx_spr = new Sprite();
		Lib.current.addChild(gfx_spr);
		animtest = 0;
		
		// instance spriterenderer
		
		sprite = new SpriteRenderer(gr.sprite, gr.tilesheet);
		
		// instance tilemap
		
		pop = new Array<Int>(); for (n in 0...16 * 16) pop.push(0);
		board = new AutotileBoard(16, 16, 16, 16, pop, gr.autotile);
		doOver();
		
		Lib.current.addEventListener(nme.events.Event.ENTER_FRAME, render);
		Lib.current.stage.addEventListener(nme.events.KeyboardEvent.KEY_DOWN, doOver);
		
		render(null);
	}
	
	public static var TESTFLAGS = Tilesheet.TILE_ALPHA +
			Tilesheet.TILE_RGB + Tilesheet.TILE_ROTATION + Tilesheet.TILE_SCALE;
	
	public inline function renderTiles()
	{
		gfx.graphics.clear();
		gfx_spr.graphics.clear();
		
		grid.renderFromGrid(board.result, gfx.graphics, true);
		sprite.draw_tiles(gfx_spr.graphics,false,TESTFLAGS);
	}
	
	public inline function renderBlitter()
	{
		grid.blitFromGrid(board.result, bmp.bitmapData, true);
		sprite.draw_blitter(bmp_spr.bitmapData, 0, false, TESTFLAGS);
	}
	
	public var animtest : Int;
	
	public function render(_)
	{
		TESTFLAGS = 0;
		for (n in 0...64)
			sprite.addName(n*8, animtest, 0, "8x16", n, 0.5,1.0,1.0,2.0,(Math.PI*animtest)/256,1.0);
		//	sprite.addName(16, 16, 0, "8x16", 2, 0.5,0.5,1.0,2.0,(Math.PI*animtest)/256,1.0);
		grid.red = 1. - (animtest/200);
		//grid.red = 0.5;
		animtest = (animtest + 1) % 200;
		
		//renderBlitter();
		renderTiles();
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
		//grid.blitFromGrid(board.result, bmp.bitmapData, false);
		grid.renderFromGrid(board.result, gfx.graphics, false);
	}
	
}