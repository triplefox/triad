class IntGrid extends AbstractGrid<Int>
{
	
	public inline override function copyTo(prev: Int, idx : Int) 
	{
		world[idx] = prev;
	}
	
}