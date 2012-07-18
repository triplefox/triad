// Based on the SoundFont reader of NAudio 
//      C# Code: (C) Mark Heath 2006 (mark@wordandspirit.co.uk)
//      Haxe Code: (C) Daniel Kuschny 2012 (danielku15@coderline.net)
// You are free to use this code for your own projects.
// Please consider giving credit somewhere in your app to this code if you use it
// Please do not redistribute this code without my permission
// Please get in touch and let me know of any bugs you find, enhancements you would like,
// and apps you have written
package com.ludamix.triad.audio.sf2;

import nme.utils.ByteArray;

/**
 * Some extension methods for normal Arrays and the ByteArray class. 
 */
class ArrayExtensions 
{
	/**
	 * Reads a simple ASCII string from the buffer
	 * @param b the byte array to read from
	 * @param length the size of the string to read
	 * @return the string 
	 */
    public static function readString(b:ByteArray, length:Int) : String
    {
        var buf = new StringBuf();
        for (i in 0 ... length) buf.addChar(b.readByte());
        return buf.toString();
    }
    
	/**
	 * Reads a signed byte from the buffer
	 * @param b the byte array to read from
	 * @return a 8 bit integer in the range from -128 to 127
	 */
    public static function readSignedByte(b:ByteArray)  : Int
    {
        var data = b.readByte() & 0xFF;
        return data > 127 ? -256 + data : data;
    }
    
	/**
	 * Removes the a single item from the given array.
	 * @param a the array
	 * @param pos the index of the item to remove
	 * @return true if an item was removed, otherwise false. 
	 */
    public static function removeAt<T>(a:Array<T>, pos:Int) : Bool 
    {
        if (pos >= 0)
        {
            if (pos == 0)
                a.shift();
            else if (pos == (a.length - 1))
                a.pop();
            else
                a.splice(pos, 1);
        }
        return pos >= 0;
    }
    
}