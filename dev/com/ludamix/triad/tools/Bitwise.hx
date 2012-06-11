class Bitwise
{
	
	public static inline function setBit(val : Int, bit : Int)
	{
		return val | (1 << bit);
	}
	
	public static inline function clearBit(val : Int, bit : Int)
	{
		return val & ~(1 << bit);
	}
	
	public static inline function testBit(val : Int, bit : Int)
	{
		return val & (1 << bit);
	}
	
}