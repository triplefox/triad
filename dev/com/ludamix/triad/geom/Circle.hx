package com.ludamix.triad.geom;

class Circle
{
	
	public var x : SubPixel;
	public var y : SubPixel;
	public var r : SubPixel;
	
	public function new(x,y,r)
	{
		this.x = x;
		this.y = y;
		this.r = r;
	}
	
	public static inline function fromInt(x : Int, y : Int, r : Int)
	{
		return new Circle(SubIPoint.shift(x), SubIPoint.shift(y), SubIPoint.shift(r));
	}

	public static inline function fromFloat(x : Float, y : Float, r : Float)
	{
		return new Circle(SubIPoint.shiftF(x), SubIPoint.shiftF(y), SubIPoint.shiftF(r));
	}
	
	public static inline function topLeftFromInt(r : Int, ?x:Int = 0, ?y:Int = 0)
	{
		return fromInt(x - r, y - r, r);		
	}

	public static inline function topLeftFromFloat(r : Float, ?x:Float = 0, ?y:Float = 0)
	{
		return fromFloat(x - r , y - r , r);		
	}
	
	public inline function xi() { return SubIPoint.unshift(x); }
	public inline function yi() { return SubIPoint.unshift(y); }
	public inline function ri() { return SubIPoint.unshift(r); }
	
	public inline function xf() { return SubIPoint.unshiftF(x); }
	public inline function yf() { return SubIPoint.unshiftF(y); }
	public inline function rf() { return SubIPoint.unshiftF(r); }
	
	// left, right, top, bottom (plus value)
	
	public inline function l(?plus = 0) { return x - r + plus; }
	public inline function r(?plus = 0) { return x + r + plus; }
	public inline function t(?plus = 0) { return y - r + plus; }
	public inline function b(?plus = 0) { return y + r + plus; }
	
	public inline function li(?plus = 0) { return SubIPoint.unshift(x - r + SubIPoint.shift(plus)); }
	public inline function ri(?plus = 0) { return SubIPoint.unshift(x + r + SubIPoint.shift(plus)); }
	public inline function ti(?plus = 0) { return SubIPoint.unshift(y - r + SubIPoint.shift(plus)); }
	public inline function bi(?plus = 0) { return SubIPoint.unshift(y + r + SubIPoint.shift(plus)); }
	
	public inline function lf(?plus = 0.) { return SubIPoint.unshiftF(x - r + SubIPoint.shiftF(plus)); }
	public inline function rf(?plus = 0.) { return SubIPoint.unshiftF(x + r + SubIPoint.shiftF(plus)); }
	public inline function tf(?plus = 0.) { return SubIPoint.unshiftF(y - r + SubIPoint.shiftF(plus)); }
	public inline function bf(?plus = 0.) { return SubIPoint.unshiftF(y + r + SubIPoint.shiftF(plus)); }
	
	// left, right, top, bottom (times percentage)
	
	public inline function lp(?pct = 0.) { return x - r + Std.int(pct*r); }
	public inline function rp(?pct = 0.) { return x + r + Std.int(pct*r); }
	public inline function tp(?pct = 0.) { return y - r + Std.int(pct*r); }
	public inline function bp(?pct = 0.) { return y + r + Std.int(pct*r); }
	
	public inline function lpi(?pct = 0.) { return SubIPoint.unshift(x - r + Std.int(pct*r)); }
	public inline function rpi(?pct = 0.) { return SubIPoint.unshift(x + r + Std.int(pct*r)); }
	public inline function tpi(?pct = 0.) { return SubIPoint.unshift(y - r + Std.int(pct*r)); }
	public inline function bpi(?pct = 0.) { return SubIPoint.unshift(y + r + Std.int(pct*r)); }
	
	public inline function lpf(?pct = 0.) { return SubIPoint.unshiftF(x - r + Std.int(pct*r)); }
	public inline function rpf(?pct = 0.) { return SubIPoint.unshiftF(x + r + Std.int(pct*r)); }
	public inline function tpf(?pct = 0.) { return SubIPoint.unshiftF(y - r + Std.int(pct*r)); }
	public inline function bpf(?pct = 0.) { return SubIPoint.unshiftF(y + r + Std.int(pct*r)); }
	
	// corner vectors
	
	public inline function tl(v : SubIPoint) { v.x = l(); v.y = t(); }
	public inline function tr(v : SubIPoint) { v.x = r(); v.y = t(); }
	public inline function bl(v : SubIPoint) { v.x = l(); v.y = b(); }
	public inline function br(v : SubIPoint) { v.x = r(); v.y = b(); }
	
	public inline function tlGen() { return new SubIPoint(l(),t()); }
	public inline function trGen() { return new SubIPoint(r(),t()); }
	public inline function blGen() { return new SubIPoint(l(),b()); }
	public inline function brGen() { return new SubIPoint(r(),b()); }
	
	// Center (plus value)
	
	public inline function cx(?plus = 0) { return x + plus; }
	public inline function cy(?plus = 0) { return y + plus; }
	
	public inline function cxi(?plus = 0) { return SubIPoint.unshift(x + SubIPoint.shift(plus)); }
	public inline function cyi(?plus = 0) { return SubIPoint.unshift(y + SubIPoint.shift(plus)); }
	
	public inline function cxf(?plus = 0.) { return SubIPoint.unshiftF(x + SubIPoint.shiftF(plus)); }
	public inline function cyf(?plus = 0.) { return SubIPoint.unshiftF(y + SubIPoint.shiftF(plus)); }
	
	// Center (times percentage)
	
	public inline function cxp(?pct = 0.) { return x + Std.int(pct * r); }
	public inline function cyp(?pct = 0.) { return y + Std.int(pct * r); }	
	
	public inline function cxpi(?pct = 0.) { return SubIPoint.unshift(x + Std.int(pct * r)); }
	public inline function cypi(?pct = 0.) { return SubIPoint.unshift(y + Std.int(pct * r)); }	
	
	public inline function cxpf(?pct = 0.) { return SubIPoint.unshiftF(x + Std.int(pct * r)); }
	public inline function cypf(?pct = 0.) { return SubIPoint.unshiftF(y + Std.int(pct * r)); }	
	
	public inline function paste(circle : Circle) { circle.x = x; circle.y = y; circle.r = r; }
	public inline function clone() { return new Circle(x, y, r); }
	
	public function toString()
	{
		return Std.string(["circle",xf(),yf(),rf()]);
	}
	
	public inline function containsPoint(pt : SubIPoint)
	{
		return (pt.x - this.x) * (pt.x - this.x) + (pt.y - this.y) * (pt.y - this.y) < r * r;		
	}
	
	public inline function rectContainsPoint(pt : SubIPoint)
	{
		return pt.x >= l() && pt.x <= r() && pt.y >= t() && pt.y <= b();
	}
	
	public inline function intersectsCircle(c : Circle)
	{
		return (c.x - this.x) * (c.x - this.x) + (c.y - this.y) * (c.y - this.y) < (r + c.r) * (r + c.r);
	}
	
}
