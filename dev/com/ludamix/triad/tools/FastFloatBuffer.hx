package com.ludamix.triad.tools;

import nme.Vector;

class FastFloatBuffer
{
	
	private var data : Vector<Float>;
	public var length : Int;
	
	public function new(size : Int, ?basis : Vector<Float>)
	{
		if (basis==null)
			data = new Vector<Float>(size);
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
	
	public inline function dealloc() { }
	
	public static function fromVector(i : Vector<Float>)
	{
		return new FastFloatBuffer(i.length, i);
	}
	
	public inline function toVector() : Vector<Float>
	{
		return data;
	}
	
}