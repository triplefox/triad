class Probability
{
	
	public static inline function intRange(low : Int, hi : Int)
	{
		// (0,1) returns [0,1], (0,2) returns [0,1,2], etc.
		var range = hi - low + 1;
		return Std.int(Math.random() * range + low);
	}
	
	public static inline function boolean()
	{
		return Math.random() < 0.5;
	}
	
	public static inline function pick(list : Array<Dynamic>)
	{
		return list[Std.int(Math.random() * list.length)];
	}
	
}