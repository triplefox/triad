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
	
	public var envelope : ADSR;
	public var type : Int;
	public var cutoff : Float;
	public var resonance : Float;
	public var freq : Float;
	public var damp : Float;
	public var sampleRate : Int;
	public var f : FastFloatBuffer;
	public var calcCoeff : Float->Float->Void;
	
	public function new(type, cutoff, resonance, sampleRate) {
	  this.type = type;
	  this.cutoff = cutoff;
	  this.resonance = resonance;
	  this.sampleRate = sampleRate;

	  this.f = new FastFloatBuffer(4);
	  this.f.set(0, 0.0); // lp
	  this.f.set(1, 0.0); // hp
	  this.f.set(2, 0.0); // bp
	  this.f.set(3, 0.0); // br 
	 
	  this.calcCoeff = function(cutoff, resonance) {
		this.freq = 2 * Math.sin(Math.PI * Math.min(0.25, cutoff/(this.sampleRate*2)));  
		this.damp = Math.min(2 * (1 - Math.pow(resonance, 0.25)), Math.min(2, 2/this.freq - this.freq * 0.5));
	  };

	  this.calcCoeff(cutoff, resonance);
	}

	public function process(buffer : FastFloatBuffer) {
	  var input : Float;
	  var output : Float;
	  var f = this.f;

	  for ( i in 0...buffer.length ) {
		input = buffer.get(i);

		// first pass
		f.set(3, input - this.damp * f.get(2));
		f.set(0, f.get(0) + this.freq * f.get(2));
		f.set(1, f.get(3) - f.get(0));
		f.set(2, this.freq * f.get(1) + f.get(2));
		output = 0.5 * f.get(this.type);

		// second pass
		f.set(3, input - this.damp * f.get(2));
		f.set(0, f.get(0) + this.freq * f.get(2));
		f.set(1, f.get(3) - f.get(0));
		f.set(2, this.freq * f.get(1) + f.get(2));
		output += 0.5 * f.get(this.type);

		if (this.envelope!=null) {
		  buffer.set(i, (buffer.get(i) * (1 - this.envelope.value())) + (output * this.envelope.value()));
		  this.envelope.samplesProcessed++;
		} else {
		  buffer.set(i, output);
		}
	  }
	}

	public function addEnvelope(envelope) {
	  if ( Type.getClass(envelope)==ADSR ) {
		this.envelope = envelope;
	  } else {
		throw "This is not an envelope.";
	  }
	}

	public function set(cutoff, resonance) {
	  this.calcCoeff(cutoff, resonance);
	}	
	
}
