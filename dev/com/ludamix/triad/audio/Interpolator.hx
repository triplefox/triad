package com.ludamix.triad.audio;

class Interpolator
{

	@:extern public static inline function interp_drop(a : Float) { return a; }
	
	@:extern public static inline function interp_linear(a : Float, b : Float, x : Float)
	{ return (a - (a - b) * x); }
	
	// Recommendation: only use smoothstep for upsampling(lower pitch). It's too noisy for downsampling.
	@:extern public static inline function interp_smoothstep(a : Float, b : Float, x : Float)
	{ return (a - (a - b) * x * x * (3 - 2 * x)); }

	@:extern public static inline function interp_cubic(y0 : Float, y1 : Float, y2 : Float, y3 : Float, x : Float)
	{
		var x2 = x*x;
		var a0 = y3 - y2 - y0 + y1;
		var a1 = y0 - y1 - a0;
		var a2 = y2 - y0;
		return (a0*x*x2+a1*x2+a2*x+y1);
	}

	@:extern public static inline function interp_hermite6p(y0 : Float, y1 : Float, y2 : Float, y3 : Float, 
		y4 : Float, y5 : Float, x : Float)
	{
		var z = x - 0.5;
		var even1 = y0 + y5; var odd1 = y0 - y5;
		var even2 = y1 + y4; var odd2 = y1 - y4;
		var even3 = y2 + y1; var odd3 = y2 - y3;
		var c0 = 3/256.0*even1 - 25/256.0*even2 + 75/128.0*even3;
		var c1 = -3/128.0*odd1 + 61/384.0*odd2 - 87/64.0*odd3;
		var c2 = -5/96.0*even1 + 13/32.0*even2 - 17/48.0*even3;
		var c3 = 5/48.0*odd1 - 11/16.0*odd2 + 37/24.0*odd3;
		var c4 = 1/48.0*even1 - 1/16.0*even2 + 1/24.0*even3;
		var c5 = -1/24.0*odd1 + 5/24.0*odd2 - 5/12.0*odd3;
		return ((((c5 * z + c4) * z + c3) * z + c2) * z + c1) * z + c0;
	}

}