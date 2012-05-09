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

class ADSR
{
	
	public var update : Void->Void;
	
	public var samplesProcessed : Int;
	public var sampleRate : Int;
	public var attackLength : Float;
	public var decayLength : Float;
	public var sustainLevel : Float;
	public var sustainLength : Float;
	public var releaseLength : Float;
	
	public var attackSamples : Float;
	public var decaySamples : Float;
	public var sustainSamples : Float;
	public var releaseSamples : Float;
	
	public var attack : Float;
	public var decay : Float;
	public var sustain : Float;
	public var release : Float;
	
	public function new(attackLength, decayLength, sustainLevel, sustainLength, releaseLength, sampleRate) {
	  this.sampleRate = sampleRate;
	  // Length in seconds
	  this.attackLength  = attackLength;
	  this.decayLength   = decayLength;
	  this.sustainLevel  = sustainLevel;
	  this.sustainLength = sustainLength;
	  this.releaseLength = releaseLength;
	  this.sampleRate    = sampleRate;
	 
	  // Length in samples
	  this.attackSamples  = attackLength  * sampleRate;
	  this.decaySamples   = decayLength   * sampleRate;
	  this.sustainSamples = sustainLength * sampleRate;
	  this.releaseSamples = releaseLength * sampleRate;
	 
	  // Updates the envelope sample positions
	  this.update = function() {
		this.attack         =                this.attackSamples;
		this.decay          = this.attack  + this.decaySamples;
		this.sustain        = this.decay   + this.sustainSamples;
		this.release        = this.sustain + this.releaseSamples;
	  };
	 
	  this.update();
	 
	  this.samplesProcessed = 0;
	}

	public function noteOn() {
	  this.samplesProcessed = 0;
	  this.sustainSamples = this.sustainLength * this.sampleRate;
	  this.update();
	}

	// Send a note off when using a sustain of infinity to let the envelope enter the release phase
	public function noteOff() {
	  this.sustainSamples = this.samplesProcessed - this.decaySamples;
	  this.update();
	}

	public function processSample(sample) {
	  var amplitude = 0.;

	  if ( this.samplesProcessed <= this.attack ) {
		amplitude = 0 + (1 - 0) * ((this.samplesProcessed - 0) / (this.attack - 0));
	  } else if ( this.samplesProcessed > this.attack && this.samplesProcessed <= this.decay ) {
		amplitude = 1 + (this.sustainLevel - 1) * ((this.samplesProcessed - this.attack) / (this.decay - this.attack));
	  } else if ( this.samplesProcessed > this.decay && this.samplesProcessed <= this.sustain ) {
		amplitude = this.sustainLevel;
	  } else if ( this.samplesProcessed > this.sustain && this.samplesProcessed <= this.release ) {
		amplitude = this.sustainLevel + (0 - this.sustainLevel) * ((this.samplesProcessed - this.sustain) / (this.release - this.sustain));
	  }
	 
	  return sample * amplitude;
	}

	public function value() {
	  var amplitude = 0.;

	  if ( this.samplesProcessed <= this.attack ) {
		amplitude = 0 + (1 - 0) * ((this.samplesProcessed - 0) / (this.attack - 0));
	  } else if ( this.samplesProcessed > this.attack && this.samplesProcessed <= this.decay ) {
		amplitude = 1 + (this.sustainLevel - 1) * ((this.samplesProcessed - this.attack) / (this.decay - this.attack));
	  } else if ( this.samplesProcessed > this.decay && this.samplesProcessed <= this.sustain ) {
		amplitude = this.sustainLevel;
	  } else if ( this.samplesProcessed > this.sustain && this.samplesProcessed <= this.release ) {
		amplitude = this.sustainLevel + (0 - this.sustainLevel) * ((this.samplesProcessed - this.sustain) / (this.release - this.sustain));
	  }
	 
	  return amplitude;
	}
		 
	public function process(buffer : Vector<Float>) {
	  for ( i in 0...buffer.length ) {
		buffer[i] *= this.value();

		this.samplesProcessed++;
	  }
	 
	  return buffer;
	}
		 
		 
	public function isActive() {
	  if ( this.samplesProcessed > this.release || this.samplesProcessed == -1 ) {
		return false;
	  } else {
		return true;
	  }
	}

	public function disable() {
	  this.samplesProcessed = -1;
	}	
	
}
