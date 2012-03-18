package com.ludamix.triad.geom;

class AABB
{
	
	public var x : SubPixel;
	public var y : SubPixel;
	public var w : SubPixel;
	public var h : SubPixel;
	
	public function new(x,y,w,h)
	{
		this.x = x;
		this.y = y;
		this.w = w;
		this.h = h;
	}
	
	public static inline function fromInt(x : Int, y : Int, w : Int, h : Int)
	{
		return new AABB(SubIPoint.shift(x), SubIPoint.shift(y), SubIPoint.shift(w), SubIPoint.shift(h));
	}

	public static inline function fromFloat(x : Float, y : Float, w : Float, h : Float)
	{
		return new AABB(SubIPoint.shiftF(x), SubIPoint.shiftF(y), SubIPoint.shiftF(w), SubIPoint.shiftF(h));
	}
	
	public static inline function centerFromInt(w : Int, h : Int, ?x:Int = 0, ?y:Int = 0)
	{
		return fromInt(x+Std.int(-w / 2),y+Std.int(-h / 2),w,h);
	}

	public static inline function centerFromFloat(w : Float, h : Float, ?x:Float = 0, ?y:Float = 0)
	{
		return fromFloat(x+(-w / 2),y+(-h / 2),w,h);
	}
	
	public inline function xi() { return SubIPoint.unshift(x); }
	public inline function yi() { return SubIPoint.unshift(y); }
	public inline function wi() { return SubIPoint.unshift(w); }
	public inline function hi() { return SubIPoint.unshift(h); }
	
	public inline function xf() { return SubIPoint.unshiftF(x); }
	public inline function yf() { return SubIPoint.unshiftF(y); }
	public inline function wf() { return SubIPoint.unshiftF(w); }
	public inline function hf() { return SubIPoint.unshiftF(h); }
	
	// left, right, top, bottom (plus value)
	
	public inline function l(?plus = 0) { return x + plus; }
	public inline function r(?plus = 0) { return x + w + plus; }
	public inline function t(?plus = 0) { return y + plus; }
	public inline function b(?plus = 0) { return y + h + plus; }
	
	public inline function li(?plus = 0) { return SubIPoint.unshift(x + SubIPoint.shift(plus)); }
	public inline function ri(?plus = 0) { return SubIPoint.unshift(x + w + SubIPoint.shift(plus)); }
	public inline function ti(?plus = 0) { return SubIPoint.unshift(y + SubIPoint.shift(plus)); }
	public inline function bi(?plus = 0) { return SubIPoint.unshift(y + h + SubIPoint.shift(plus)); }
	
	public inline function lf(?plus = 0.) { return SubIPoint.unshiftF(x + SubIPoint.shiftF(plus)); }
	public inline function rf(?plus = 0.) { return SubIPoint.unshiftF(x + w + SubIPoint.shiftF(plus)); }
	public inline function tf(?plus = 0.) { return SubIPoint.unshiftF(y + SubIPoint.shiftF(plus)); }
	public inline function bf(?plus = 0.) { return SubIPoint.unshiftF(y + h + SubIPoint.shiftF(plus)); }
	
	// left, right, top, bottom (times percentage)
	
	public inline function lp(?pct = 0.) { return x + Std.int(pct*w); }
	public inline function rp(?pct = 0.) { return x + Std.int(w + pct*w); }
	public inline function tp(?pct = 0.) { return y + Std.int(pct*h); }
	public inline function bp(?pct = 0.) { return y + Std.int(h + pct*h); }
	
	public inline function lpi(?pct = 0.) { return SubIPoint.unshift(x + Std.int(pct*w)); }
	public inline function rpi(?pct = 0.) { return SubIPoint.unshift(x + Std.int(w + pct*w)); }
	public inline function tpi(?pct = 0.) { return SubIPoint.unshift(y + Std.int(pct*h)); }
	public inline function bpi(?pct = 0.) { return SubIPoint.unshift(y + Std.int(h + pct * h)); }
	
	public inline function lpf(?pct = 0.) { return SubIPoint.unshiftF(x + Std.int(pct*w)); }
	public inline function rpf(?pct = 0.) { return SubIPoint.unshiftF(x + Std.int(w + pct*w)); }
	public inline function tpf(?pct = 0.) { return SubIPoint.unshiftF(y + Std.int(pct*h)); }
	public inline function bpf(?pct = 0.) { return SubIPoint.unshiftF(y + Std.int(h + pct * h)); }
	
	// corner vectors
	
	public inline function tl(v : SubIPoint) { v.x = l(); v.y = t(); }
	public inline function tr(v : SubIPoint) { v.x = r(); v.y = t(); }
	public inline function bl(v : SubIPoint) { v.x = l(); v.y = b(); }
	public inline function br(v : SubIPoint) { v.x = r(); v.y = b(); }
	
	public inline function tlGen() { return new SubIPoint(l(),t()); }
	public inline function trGen() { return new SubIPoint(r(),t()); }
	public inline function blGen() { return new SubIPoint(l(),b()); }
	public inline function brGen() { return new SubIPoint(r(),b()); }
	
	// Center of rect (plus value)
	
	public inline function cx(?plus = 0) { return x + Std.int(w / 2) + plus; }
	public inline function cy(?plus = 0) { return y + Std.int(h / 2) + plus; }
	
	public inline function cxi(?plus = 0) { return SubIPoint.unshift(x + Std.int(w / 2) + SubIPoint.shift(plus)); }
	public inline function cyi(?plus = 0) { return SubIPoint.unshift(y + Std.int(h / 2) + SubIPoint.shift(plus)); }
	
	public inline function cxf(?plus = 0.) { return SubIPoint.unshiftF(x + Std.int(w / 2) + SubIPoint.shiftF(plus)); }
	public inline function cyf(?plus = 0.) { return SubIPoint.unshiftF(y + Std.int(h / 2) + SubIPoint.shiftF(plus)); }
	
	// Center of rect (times percentage)
	
	public inline function cxp(?pct = 0.) { return x + Std.int(w / 2 + pct * w); }
	public inline function cyp(?pct = 0.) { return y + Std.int(h / 2 + pct * h); }	
	
	public inline function cxpi(?pct = 0.) { return SubIPoint.unshift(x + Std.int(w / 2 + pct * w)); }
	public inline function cypi(?pct = 0.) { return SubIPoint.unshift(y + Std.int(h / 2 + pct * h)); }	
	
	public inline function cxpf(?pct = 0.) { return SubIPoint.unshiftF(x + Std.int(w / 2 + pct * w)); }
	public inline function cypf(?pct = 0.) { return SubIPoint.unshiftF(y + Std.int(h / 2 + pct * h)); }	
	
	public inline function resizeCenter(pct : Float) 
	{ 
		var nw = Std.int(w * pct); 
		x = cxp( -pct / 2 );
		w = nw;
		
		var nh = Std.int(h * pct);
		y = cyp( -pct / 2 );
		h = nh;
	}
	
	public inline function paste(aabb : AABB) { aabb.x = x; aabb.y = y; aabb.w = w; aabb.h = h; }
	public inline function clone() { return new AABB(x, y, w, h); }
	
	public function toString()
	{
		return Std.string(["rect",xf(),yf(),wf(),hf()]);
	}
	
	public inline function containsPoint(pt : SubIPoint)
	{
		return pt.x >= l() && pt.x <= r() && pt.y >= t() && pt.y <= b();
	}
	
	public inline function intersectsAABB(other : AABB)
	{
		return (!((this.r() < other.l()) || (this.l() > other.r()) || (this.b() < other.t()) || (this.t() > other.b())));
	}
	
}
