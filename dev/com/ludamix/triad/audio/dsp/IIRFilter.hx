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

class IIRFilter
{
	
	public var sampleRate : Int;
	public var vibraPos : Float;
	public var vibraSpeed : Float;
	public var envelope : Dynamic;
	public var w : Float;
	public var q : Float;
	public var r : Float;
	public var c : Float;
	
	public function new(type, cutoff, resonance, sampleRate) {
	  this.sampleRate = sampleRate;

	  switch(type) {
		case DSP.LOWPASS:
		  LP12(cutoff, resonance, sampleRate);
	  }
	}
	
	// the original implementation made these dynamic getters...but does nothing useful with them.
	
	public var cutoff(default, default) : Float;
	public var resonance(default, default) : Float;

	private var _addEnvelope : ADSR->Void;
	private var calcCoeff : Float->Float->Void;
	public var process : Vector<Float>->Void;

	public function set(cutoff, resonance) {
	  calcCoeff(cutoff, resonance);
	}

	// Add an envelope to the filter
	public function addEnvelope(envelope) {
	  if ( Type.getClass(envelope)==ADSR ) {
		this.addEnvelope(envelope);
	  } else {
		throw "Not an envelope.";
	  }
	}

	public function LP12 (cutoff, resonance, sampleRate) {
	  this.sampleRate = sampleRate;
	  this.vibraPos   = 0;
	  this.vibraSpeed = 0;
	  this.envelope = false;
	 
	  this.calcCoeff = function(cutoff, resonance) {
		this.w = 2.0 * Math.PI * cutoff / this.sampleRate;
		this.q = 1.0 - this.w / (2.0 * (resonance + 0.5 / (1.0 + this.w)) + this.w - 2.0);
		this.r = this.q * this.q;
		this.c = this.r + 1.0 - 2.0 * Math.cos(this.w) * this.q;
	   
		this.cutoff = cutoff;
		this.resonance = resonance;
	  };

	  this.calcCoeff(cutoff, resonance);

	  this.process = function(buffer) {
		for ( i in 0...buffer.length ) {
		  this.vibraSpeed += (buffer[i] - this.vibraPos) * this.c;
		  this.vibraPos   += this.vibraSpeed;
		  this.vibraSpeed *= this.r;
	   
		  /*
		  var temp = this.vibraPos;
		 
		  if ( temp > 1.0 ) {
			temp = 1.0;
		  } else if ( temp < -1.0 ) {
			temp = -1.0;
		  } else if ( temp != temp ) {
			temp = 1;
		  }
		 
		  buffer[i] = temp;
		  */

		  if (this.envelope) {
			buffer[i] = (buffer[i] * (1 - this.envelope.value())) + (this.vibraPos * this.envelope.value());
			this.envelope.samplesProcessed++;
		  } else {
			buffer[i] = this.vibraPos;
		  }
		}
	  }
	  
	  this._addEnvelope = function(envelope) { this.envelope = envelope; };	
	}
	
}
