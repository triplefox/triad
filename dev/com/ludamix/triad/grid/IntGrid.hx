package com.ludamix.triad.grid;

class IntGrid extends AbstractGrid<Int>
{
	
	public inline override function copyTo(prev: Int, idx : Int) 
	{
		world[idx] = prev;
	}
	
	public inline function s2(x : Int, y : Int, v : Int)
	{
		world[c21(x, y)] = v;
	}
	
}