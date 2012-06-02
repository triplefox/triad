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

import com.ludamix.triad.tools.FastFloatBuffer;
import nme.Vector;

class IIRFilter2
{
	
	public var type : Int;
	public var cutoff : Float;
	public var resonance : Float;
	public var freq : Float;
	public var damp : Float;
	public var sampleRate : Int;
	public var f0 : Float;
	public var f1 : Float;
	public var f2 : Float;
	public var f3 : Float;
	public var calcCoeff : Float->Float->Void;
	public var output : Float;
	
	public function new(type, cutoff, resonance, sampleRate) {
	  this.type = type;
	  this.cutoff = cutoff;
	  this.resonance = resonance;
	  this.sampleRate = sampleRate;

	  f0 = 0.; // lp
	  f1 = 0.; // hp
	  f2 = 0.; // bp
	  f3 = 0.; // br 
	  output = 0.;
	 
	  this.calcCoeff = function(cutoff, resonance) {
		this.freq = 2 * Math.sin(Math.PI * Math.min(0.25, cutoff/(this.sampleRate*2)));  
		this.damp = Math.min(2 * (1 - Math.pow(resonance, 0.25)), Math.min(2, 2/this.freq - this.freq * 0.5));
	  };

	  this.calcCoeff(cutoff, resonance);
	}

	public function process(buffer : FastFloatBuffer) {
	  var input : Float;
	  var output : Float;
	
	  buffer.playhead = 0;
	  
	  if (this.type == 0)
	  {
		for ( i in 0...buffer.length ) {
			buffer.write(getLP(buffer.read()));
			buffer.advancePlayheadUnbounded();
		}
	  }
	  else if (this.type == 1)
	  {
		for ( i in 0...buffer.length ) {
			buffer.write(getHP(buffer.read()));
			buffer.advancePlayheadUnbounded();
		}		  
	  }
	  else if (this.type == 2)
	  {
		for ( i in 0...buffer.length ) {
			buffer.write(getBP(buffer.read()));
			buffer.advancePlayheadUnbounded();
		}		  
	  }
	  else if (this.type == 3)
	  {
		for ( i in 0...buffer.length ) {
			buffer.write(getBR(buffer.read()));
			buffer.advancePlayheadUnbounded();
		}		  
	  }
	  
	}
	
	public inline function firstPass(input : Float)
	{
		f3 = input - this.damp * f2;
		f0 = f0 + this.freq * f2;
		f1 = f3 - f0;
		f2 = this.freq * f1 + f2;
	}
	
	public inline function secondPass(input : Float)
	{
		f3 =  input - this.damp * f2;
		f0 = f0 + this.freq * f2;
		f1 = f3 - f0;
		f2 = this.freq * f1 + f2;		
	}

	public inline function getLP(input : Float)
	{
		firstPass(input);
		output = 0.5 * f0;
		secondPass(input);
		output = 0.5 * f0;
		return output;
	}
	
	public inline function getHP(input : Float)
	{
		firstPass(input);
		output = 0.5 * f1;
		secondPass(input);
		output = 0.5 * f1;
		return output;
	}
	
	public inline function getBP(input : Float)
	{
		firstPass(input);
		output = 0.5 * f2;
		secondPass(input);
		output = 0.5 * f2;
		return output;
	}
	
	public inline function getBR(input : Float)
	{
		firstPass(input);
		output = 0.5 * f3;
		secondPass(input);
		output = 0.5 * f3;
		return output;
	}
	
	public function set(cutoff, resonance) {
	  this.calcCoeff(cutoff, resonance);
	}	
	
	public inline function clear():Void 
	{
		f0 = 0.;
		f1 = 0.;
		f2 = 0.;
		f3 = 0.;
	}
	
}
