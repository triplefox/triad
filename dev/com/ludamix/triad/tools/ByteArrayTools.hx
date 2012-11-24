package com.ludamix.triad.tools;
import flash.utils.ByteArray;
import haxe.io.Bytes;
import haxe.io.BytesData;

class ByteArrayTools
{

	// Flash provides writeMultiByte and readMultiByte, however they are unreliable in some versions of Flash.
	// cpp does not implement them at all.

	public static inline function writeASCII(ba : ByteArray, str : String) : Void
	{
		for (c in 0...str.length)
			ba.writeByte(str.charCodeAt(c));
	}
	
	public static inline function readASCII(ba : ByteArray, len : Int) : String
	{
		var b = new StringBuf();
		for (c in 0...len)
			b.addChar(ba.readByte());
		return b.toString();
	}
	
	// Again, not all platforms provide the same functionality. Bytearray and BytesData happen to be the
	// same type in Flash, but not in other platforms.
	
	public static inline function byteArray2Bytes(ba : ByteArray) : Bytes
	{
		#if flash
		return Bytes.ofData(ba);
		#else
		var b = Bytes.alloc(ba.length);
		ba.position = 0;
		for (n in 0...ba.length)
			b.set(n, ba.readByte());
		return b;
		#end
	}
	
	public static inline function bytesData2ByteArray(bd : BytesData) : ByteArray
	{
		#if flash
		return bd;
		#else
		var ba = new ByteArray();
		for (n in 0...bd.length)
			ba.writeByte(cast(bd[n],Int));
		return ba;
		#end
	}

}