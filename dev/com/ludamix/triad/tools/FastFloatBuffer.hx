package com.ludamix.triad.tools;

import nme.Vector;

#if alchemy
import nme.Memory;
import nme.utils.ByteArray;
#end
class FastFloatBuffer
{
	
	public var length : Int;
	public var length_inv : Float;
	
	public static function fromVector(i : Vector<Float>)
	{
		var ffb = new FastFloatBuffer(i.length, i);
		return ffb;
	}
	
#if alchemy
	
	// To use Alchemy FFBs all allocations must be static.
	// FIXME: The DSP.js algorithms allocate stuff willy-nilly. Refactor them to draw from a common pool.
	
	public static var mem : ByteArray;
	public static var ptr : Int;
	
	public inline function advancePlayhead() { advancePlayheadUnbounded(); windowPlayhead(); }
	public inline function advancePlayheadUnbounded() { playhead2 += playback_rate2; }
	public inline function windowPlayhead() { 
		playhead2 = ((((playhead2 - offset)) % (length << SHIFT_FLOAT))) + offset; }
	
	public static function init(bufsize : Int):Void 
	{
		mem = new ByteArray();
		mem.length = bufsize;
		Memory.select(mem);
		ptr = 0;
	}
	
	private static inline var SIZE_FLOAT = 8;
	private static inline var SHIFT_FLOAT = 3;
	private var offset : Int;
	public var playhead(getPlayhead, setPlayhead) : Int;
	public var playhead2 : Int;
	public var playback_rate(getRate, setRate) : Int;
	public var playback_rate2 : Int;
	
	private inline function getPlayhead() { return (playhead2-offset) >> SHIFT_FLOAT; }
	private inline function setPlayhead(iv : Int) { playhead2 = offset + (iv << SHIFT_FLOAT); return iv; }
	private inline function getRate() { return playback_rate2 >> SHIFT_FLOAT;  }
	private inline function setRate(iv : Int) { playback_rate2 = (iv << SHIFT_FLOAT); return iv;  }
		
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
			if (basis.length == size) // faster copy when size matches
			{
				for (n in 0...size)
				{
					Memory.setFloat(ptr, basis[n]);
					ptr += SIZE_FLOAT;
					if (ptr >= Std.int(mem.length)) throw "alchemy buffer overrun";
				}			
			}
			else
			{
				for (n in 0...size)
				{
					Memory.setFloat(ptr, basis[n % basis.length]); // loop basis when size greater
					ptr += SIZE_FLOAT;
					if (ptr >= Std.int(mem.length)) throw "alchemy buffer overrun";
				}			
			}
		}
		length = size;
		length_inv = 1. / size;
		playhead = 0;
		playback_rate = 1;
	}
	
	public inline function set(i : Int, d : Float)
	{
		Memory.setFloat((i<<SHIFT_FLOAT) + offset, d);
	}
	
	public inline function get(i : Int)
	{
		return Memory.getFloat((i<<SHIFT_FLOAT) + offset);
	}
	
	public inline function toVector() : Vector<Float>
	{
		var v = new Vector<Float>(length);
		for (n in 0...length)
			v[n] = get(n);
		return v;
	}
	
	public inline function read()
	{ return Memory.getFloat(playhead2); }
	
	public inline function write(d : Float)
	{ Memory.setFloat(playhead2, d); }
	
	public inline function add(d : Float)
	{ Memory.setFloat(playhead2, Memory.getFloat(playhead2)+d); }
	
#else
	
	private var data : Vector<Float>;
	public var playhead : Int;
	public var playback_rate : Int;
	
	public function new(size : Int, ?basis : Vector<Float>)
	{
		if (basis == null || Std.int(basis.length) != size )
		{
		#if flash
			data = new Vector<Float>(size);
		#else
			data = new Vector<Float>();
		#end
			if (basis != null)
			{
				for (d in 0...data.length)
					data[d] = basis[d % basis.length]; // loop basis when size greater
			}
		}
		else
			data = basis;
		length = size;
		length_inv = 1. / size;
		playhead = 0;
		playback_rate = 1;
	}
	
	public inline function set(i : Int, d : Float)
	{
		data[i] = d;
	}
	
	public inline function get(i : Int)
	{
		return data[i];
	}
	
	public inline function toVector() : Vector<Float>
	{
		return data;
	}
	
	public inline function advancePlayhead() { playhead = ((playhead + playback_rate) % length); }
	public inline function advancePlayheadUnbounded() { playhead += playback_rate; }
	public inline function windowPlayhead() { playhead = playhead % length; }
	
	public inline function read()
	{ return data[playhead]; }	
	
	public inline function write(d : Float)
	{ data[playhead] = d; }
	
	public inline function add(d : Float)
	{ data[playhead] += d; }
	
#end
}