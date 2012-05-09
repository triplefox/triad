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

class IIRFilter2
{
	
	public var envelope : ADSR;
	public var type : Int;
	public var cutoff : Float;
	public var resonance : Float;
	public var freq : Float;
	public var damp : Float;
	public var sampleRate : Int;
	public var f : Vector<Float>;
	public var calcCoeff : Float->Float->Void;
	
	public function new(type, cutoff, resonance, sampleRate) {
	  this.type = type;
	  this.cutoff = cutoff;
	  this.resonance = resonance;
	  this.sampleRate = sampleRate;

	  this.f = new Vector<Float>(4);
	  this.f[0] = 0.0; // lp
	  this.f[1] = 0.0; // hp
	  this.f[2] = 0.0; // bp
	  this.f[3] = 0.0; // br 
	 
	  this.calcCoeff = function(cutoff, resonance) {
		this.freq = 2 * Math.sin(Math.PI * Math.min(0.25, cutoff/(this.sampleRate*2)));  
		this.damp = Math.min(2 * (1 - Math.pow(resonance, 0.25)), Math.min(2, 2/this.freq - this.freq * 0.5));
	  };

	  this.calcCoeff(cutoff, resonance);
	}

	public function process(buffer : Vector<Float>) {
	  var input : Float;
	  var output : Float;
	  var f = this.f;

	  for ( i in 0...buffer.length ) {
		input = buffer[i];

		// first pass
		f[3] = input - this.damp * f[2];
		f[0] = f[0] + this.freq * f[2];
		f[1] = f[3] - f[0];
		f[2] = this.freq * f[1] + f[2];
		output = 0.5 * f[this.type];

		// second pass
		f[3] = input - this.damp * f[2];
		f[0] = f[0] + this.freq * f[2];
		f[1] = f[3] - f[0];
		f[2] = this.freq * f[1] + f[2];
		output += 0.5 * f[this.type];

		if (this.envelope!=null) {
		  buffer[i] = (buffer[i] * (1 - this.envelope.value())) + (output * this.envelope.value());
		  this.envelope.samplesProcessed++;
		} else {
		  buffer[i] = output;
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
