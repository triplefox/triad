package com.ludamix.triad.tools;

class StringTools
{
	
	public static function parseHex(hexstr : String) : UInt
	{
		var remain = hexstr.substr(2).toUpperCase();
		var set : UInt = 0;
		for (idx in 0...remain.length)
		{
			var chr = remain.charAt((remain.length - 1) - idx);
			switch(chr)
			{
				case '0': {}
				case '1': { set += (1 << (idx * 4)); }
				case '2': { set += (2 << (idx * 4)); }
				case '3': { set += (3 << (idx * 4)); }
				case '4': { set += (4 << (idx * 4)); }
				case '5': { set += (5 << (idx * 4)); }
				case '6': { set += (6 << (idx * 4)); }
				case '7': { set += (7 << (idx * 4)); }
				case '8': { set += (8 << (idx * 4)); }
				case '9': { set += (9 << (idx * 4)); }
				case 'A': { set += (10 << (idx * 4)); }
				case 'B': { set += (11 << (idx * 4)); }
				case 'C': { set += (12 << (idx * 4)); }
				case 'D': { set += (13 << (idx * 4)); }
				case 'E': { set += (14 << (idx * 4)); }
				case 'F': { set += (15 << (idx * 4)); }
			}
		}
		return set;
	}
	
}