package com.ludamix.triad.grid;

class ObjectGrid<T> extends AbstractGrid<T>
{
	
	public override function copyTo(prev: T, idx : Int) 
	{
		world[idx] = prev;
	}

	public function copyBlock(x:Int , y:Int , w:Int, h:Int, copyMethod:T->T) 
		: { x:Int, y:Int, w:Int, h:Int, ar:Array<T> }
	{
		var ar = new Array<T>();
		var cL = Std.int(x);
		var cR = Std.int(x+w);
		var cT = Std.int(y);
		var cB = Std.int(y+w);
		for (y in cT...cB) {
		for (x in cL...cR)
		{
			var t : T = c2t(x, y);
			ar.push(copyMethod(t));
		}}
		return { x:x, y:y, w:w, h:h, ar:ar };
	}
	
	public function pasteBlock(inp : {x:Int,y:Int,w:Int,h:Int,ar:Array<T>},x:Int,y:Int,pasteMethod:T->T->Void)
	{
		var cL = x;
		var cR = inp.w;
		var cT = y;
		var cB = inp.h;
		
		var ct = 0;
		for (y in cT...cB) {
		for (x in cL...cR)
		{
			pasteMethod(c2t(x, y),inp.ar[ct]);
			ct++;
		}}		
	}

}