package com.ludamix.triad.tools;

import nme.Vector;

#if alchemy
import nme.Memory;
import nme.utils.ByteArray;
class FastFloatBuffer
{
	
	// To use Alchemy FFBs all allocations must be static.
	// FIXME: This won't be better than Vector until we add specialized methods to avoid the bitshifting behavior.
	// FIXME: The DSP.js algorithms allocate stuff willy-nilly. Refactor them to draw from a common pool.
	
	public static var mem : ByteArray;
	public static var ptr : Int;
	
	public static function init(bufsize : Int):Void 
	{
		mem = new ByteArray();
		mem.length = bufsize;
		Memory.select(mem);
		ptr = 0;
	}
	
	public var length : Int;
	
	private static inline var SIZE_FLOAT = 8;
	private static inline var SHIFT_FLOAT = 3;
	private var offset : Int;
	
	public function new(size : Int, ?basis : Vector<Float>)
	{
		offset = ptr;
		if (basis == null)
		{
			for (n in 0...size)
			{
				Memory.setFloat(ptr, 0.);
				ptr += SIZE_FLOAT;
				if (ptr >= Std.int(mem.length)) throw "alchemy buffer overrun";
			}
		}
		else
		{
			for (n in 0...size)
			{
				Memory.setFloat(ptr, basis[n]);
				ptr += SIZE_FLOAT;
				if (ptr >= Std.int(mem.length)) throw "alchemy buffer overrun";
			}			
		}
		length = size;
	}
	
	public inline function set(i : Int, d : Float)
	{
		Memory.setFloat((i<<SHIFT_FLOAT) + offset, d);
	}
	
	public inline function get(i : Int)
	{
		return Memory.getFloat((i<<SHIFT_FLOAT) + offset);
	}
	
	public static function fromVector(i : Vector<Float>)
	{
		return new FastFloatBuffer(i.length, i);
	}
	
	public inline function toVector() : Vector<Float>
	{
		var v = new Vector<Float>(length);
		for (n in 0...length)
			v[n] = get(n);
		return v;
	}
	
}
#else
class FastFloatBuffer
{
	
	private var data : Vector<Float>;
	public var length : Int;
	
	public function new(size : Int, ?basis : Vector<Float>)
	{
		if (basis == null)
		#if flash
			data = new Vector<Float>(size);
		#else
			data = new Vector<Float>();
		#end
		else
			data = basis;
		length = size;
	}
	
	public inline function set(i : Int, d : Float)
	{
		data[i] = d;
	}
	
	public inline function get(i : Int)
	{
		return data[i];
	}
	
	public static function fromVector(i : Vector<Float>)
	{
		return new FastFloatBuffer(i.length, i);
	}
	
	public inline function toVector() : Vector<Float>
	{
		return data;
	}
	
}
#end