/* 
 *  DSP.js - a comprehensive digital signal processing  library for javascript
 * 
 *  Created by Corban Brook <corbanbrook@gmail.com> on 2010-01-01.
 *  Copyright 2010 Corban Brook. All rights reserved.
 * 
 *  Haxe port by James Hofmann, May 2012
 *
 */

package com.ludamix.triad.audio.dsp;

import nme.Vector;

class WindowFunction
{
	
	public var alpha : Float;
	public var func : Int->Int->Float->Float;
	
	public function new(type, alpha : Dynamic) {
	  this.alpha = alpha;
	 
	  switch(type) {
		case DSP.BARTLETT:
		  this.func = WindowFunction.Bartlett;
		case DSP.BARTLETTHANN:
		  this.func = WindowFunction.BartlettHann;
		case DSP.BLACKMAN:
		  this.func = WindowFunction.Blackman;
		  this.alpha = alpha == null ? 0.16 : alpha;
		case DSP.COSINE:
		  this.func = WindowFunction.Cosine;
		case DSP.GAUSS:
		  this.func = WindowFunction.Gauss;
		  this.alpha = alpha == null ? 0.25 : alpha;
		case DSP.HAMMING:
		  this.func = WindowFunction.Hamming;
		case DSP.HANN:
		  this.func = WindowFunction.Hann;
		case DSP.LANCZOS:
		  this.func = WindowFunction.Lanczos;
		case DSP.RECTANGULAR:
		  this.func = WindowFunction.Rectangular;
		case DSP.TRIANGULAR:
		  this.func = WindowFunction.Triangular;
	  }
	}

	public function process(buffer : Vector<Float>) {
	  var length = buffer.length;
	  for ( i in 0...length ) {
		buffer[i] *= this.func(length, i, this.alpha);
	  }
	  return buffer;
	}

	public static inline function Bartlett(length : Int, index : Int, alpha : Float) {
	  return 2 / (length - 1) * ((length - 1) / 2 - Math.abs(index - (length - 1) / 2));
	}

	public static inline function BartlettHann(length : Int, index : Int, alpha : Float) {
	  return 0.62 - 0.48 * Math.abs(index / (length - 1) - 0.5) - 0.38 * Math.cos(DSP.TWO_PI * index / (length - 1));
	}

	public static inline function Blackman(length : Int, index : Int, alpha : Float) {
	  var a0 = (1 - alpha) / 2;
	  var a1 = 0.5;
	  var a2 = alpha / 2;

	  return a0 - a1 * Math.cos(DSP.TWO_PI * index / (length - 1)) + a2 * Math.cos(4 * Math.PI * index / (length - 1));
	}

	public static inline function Cosine(length : Int, index : Int, alpha : Float) {
	  return Math.cos(Math.PI * index / (length - 1) - Math.PI / 2);
	}

	public static inline function Gauss(length : Int, index : Int, alpha : Float) {
	  return Math.pow(DSP.E, -0.5 * Math.pow((index - (length - 1) / 2) / (alpha * (length - 1) / 2), 2));
	}

	public static inline function Hamming(length : Int, index : Int, alpha : Float) {
	  return 0.54 - 0.46 * Math.cos(DSP.TWO_PI * index / (length - 1));
	}

	public static inline function Hann(length : Int, index : Int, alpha : Float) {
	  return 0.5 * (1 - Math.cos(DSP.TWO_PI * index / (length - 1)));
	}

	public static inline function Lanczos(length : Int, index : Int, alpha : Float) {
	  var x = 2 * index / (length - 1) - 1;
	  return Math.sin(Math.PI * x) / (Math.PI * x);
	}

	public static inline function Rectangular(length : Int, index : Int, alpha : Float) {
	  return 1;
	}

	public static inline function Triangular(length : Int, index : Int, alpha : Float) {
	  return 2 / length * (length / 2 - Math.abs(index - (length - 1) / 2));
	}	
	
}

