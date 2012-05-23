package com.ludamix.triad.tools;

import nme.Vector;

#if alchemy
import nme.Memory;
import nme.utils.ByteArray;
#end
class FastFloatBuffer
{
	
	// TODO test the new read and write methods. 
	// once they work, test using calcRuns to create speedy loops.
	
	public var length : Int;
	public var length_inv : Float;
	
	public var run_first : Int;
	public var run_full : Int;
	public var run_last : Int;
	
#if alchemy
	
	// To use Alchemy FFBs all allocations must be static.
	// FIXME: This won't be better than Vector until we add specialized methods to avoid the bitshifting behavior.
	// FIXME: The DSP.js algorithms allocate stuff willy-nilly. Refactor them to draw from a common pool.
	
	public static var mem : ByteArray;
	public static var ptr : Int;
	
	public inline function advancePlayhead() { playhead = ((playhead + playback_rate - offset) % length) + offset; }
	public inline function advancePlayheadUnbounded() { playhead += playback_rate; }
	
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
	public var playhead(default, setPlayhead) : Int;
	public var playback_rate(default, setRate) : Int;
	
	private inline function setPlayhead(iv : Int) { playhead = offset + (iv << SHIFT_FLOAT); }
	private inline function setRate(iv : Int) { playback_rate = offset + (iv << SHIFT_FLOAT); }
		
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
	
	public inline function read()
	{ var d = Memory.getFloat(playhead); advancePlayhead();  return d; }
	
	public inline function readUnbounded()
	{ var d = Memory.getFloat(playhead); advancePlayheadUnbounded(); return d; }
	
	public inline function write(d : Float)
	{ Memory.setFloat(playhead, d); advancePlayhead(); }
	
	public inline function writeUnbounded(d : Float)
	{ Memory.setFloat(playhead, d); advancePlayheadUnbounded(); }
	
	public inline function add(d : Float)
	{ Memory.setFloat(playhead, Memory.getFloat(playhead)+d); advancePlayhead(); }
	
	public inline function addUnbounded(d : Float)
	{ Memory.setFloat(playhead, Memory.getFloat(playhead)+d); advancePlayheadUnbounded(); }
	
	public inline function calcRuns(samples : Int)
	{ 
		if ((playhead + samples) < length) { run_first = samples; run_full = 0; run_last = -1; } 
		else {
			run_first = length - playhead;
			var p = samples - run_first;
			run_full = 0;
			run_last = p % length;
			p -= run_last;
			run_full = Std.int(p/length);
		}
		run_first <<= SHIFT_FLOAT;
		run_full <<= SHIFT_FLOAT;
		run_last <<= SHIFT_FLOAT;
	}
	
#else
	
	private var data : Vector<Float>;
	public var playhead : Int;
	public var playback_rate : Int;
	
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
	
	public static function fromVector(i : Vector<Float>)
	{
		return new FastFloatBuffer(i.length, i);
	}
	
	public inline function toVector() : Vector<Float>
	{
		return data;
	}
	
	public inline function advancePlayhead() { playhead = ((playhead + playback_rate) % length); }
	public inline function advancePlayheadUnbounded() { playhead += playback_rate; }
	
	public inline function read()
	{ var d = data[playhead]; advancePlayhead(); return d; }
	
	public inline function readUnbounded()
	{ var d = data[playhead]; advancePlayheadUnbounded(); return d; }
	
	public inline function write(d : Float)
	{ data[playhead] = d; advancePlayhead(); }
	
	public inline function writeUnbounded(d : Float)
	{ data[playhead] = d; advancePlayheadUnbounded();  }
	
	public inline function add(d : Float)
	{ data[playhead] += d; advancePlayhead(); }
	
	public inline function addUnbounded(d : Float)
	{ data[playhead] += d; advancePlayheadUnbounded();  }
	
	public inline function calcRuns(samples : Int)
	{ 
		if ((playhead + samples) < length) { run_first = samples; run_full = 0; run_last = -1; } 
		else {
			run_first = length - playhead;
			var p = samples - run_first;
			run_full = 0;
			run_last = p % length;
			p -= run_last;
			run_full = Std.int(p/length);
		}
	}
	
#end
}