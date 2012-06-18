package grid;

import com.ludamix.triad.geom.BinPacker;
import nme.display.BitmapData;
import nme.geom.Point;
import nme.geom.Rectangle;

class TilePack
{
	
	// takes some input bitmapDatas and outputs a Tilesheet.
	
	public var basis : Array<BitmapData>;
	
	public function new()
	{
		basis = new Array();
	}
	
	public function add(bd : BitmapData) { basis.push(bd); }
	
	/* add the image, sliced by the given width and height */
	public function addSlice(bd : BitmapData, w : Int, h : Int)
	{
		var tw = bd.width / w;
		var th = bd.height / h;
		for (x in 0...tw)
		{
			for (y in 0...th)
			{
				var nb = new BitmapData(w, h, false, 0);
				nb.copyPixels(bd, new Rectangle(x * w, y * h, w, h), new Point(0., 0.), bd, new Point(0., 0.));
				basis.push();
			}
		}
	}
	
	public function compute(sheet_size : Int) : BitmapData
	{	
		var bd = new BitmapData(sheet_size, sheet_size, true, 0);
		
		var ar = new Array<Dynamic>();
		for (n in basis)
			ar.push({contents:n,w:n.width,h:n.height});
		var bp = new BinPacker(sheet_size, sheet_size, ar);
		trace(bp.nodes);
		// blit using these nodes...assuming they're correct :o
		
	}
	
	
}
