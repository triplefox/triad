package com.ludamix.triad.ascii;

import com.ludamix.triad.ascii.ASCIIMap;
import com.ludamix.triad.ascii.ASCIISheet;
import nme.utils.ByteArray;

class Hexviewer
{
	
	// blits some numbers using the ASCII map.
	
	public var map : ASCIIMap;
	
	public function new(map : ASCIIMap):Void 
	{
		this.map = map;
	}
	
	public function draw(data : ByteArray, ?bytes_position = 0, ?cols = -1, ?rows = -1, ?x = 0, ?y = 0,
		?spacing = 1, ?fg_color=10, ?bg_color=0)
	{
		data.position = bytes_position;
		
		if (cols < 1) cols = map.char.worldW;
		if (rows < 1) rows = map.char.worldH;
		
		cols = cols >> 1;
		
		for (r in 0...rows)
		{
			var str = "";
			var str2 = "";
			var c = 0;
			while (c<cols-2)
			{
				if (data.position < data.length)
				{
					var byte = data.readUnsignedByte();
					str += StringTools.hex(byte, 2);
					str2 += String.fromCharCode(byte);
					c += 2;
					if (c%5 == 4) { str += " "; c++; }
				}
				else
				{
					str += " ";
					c++;
				}
			}
			map.text(str, x, y + r*spacing, fg_color, bg_color);
			map.text(str2, x + cols + 1, y + r*spacing, fg_color, bg_color);
			map.text(Std.string(data.position), x + cols + 1 + str2.length + 1, y + r*spacing, fg_color, bg_color);
		}
		
	}
	
	public function drawDiff(datas : Array<{bytearray:ByteArray,fg_color:Int,bg_color:Int}>, 
		?bytes_position = 0, ?cols = -1, ?rows = -1, ?x = 0, ?y = 0)
	{
		// draws multiple bytearrays interleaved with each other every row.
		for (n in 0...datas.length)
			draw(datas[n].bytearray, bytes_position, cols, rows >> (datas.length - 1), x, y + n, 
			datas.length, datas[n].fg_color, datas[n].bg_color);
	}
	
	// don't forget to update() the amap
	
}