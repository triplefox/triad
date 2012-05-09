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

class SingleDelay
{
	
	/**
	 * SingleDelay effect by Almer Thie (http://code.almeros.com).
	 * Copyright 2010 Almer Thie. All rights reserved.
	 * Example: See usage in Reverb class
	 *
	 * This is a delay that does NOT feeds it's own delayed signal back into its 
	 * circular buffer, neither does it return the original signal. Also known as
	 * an AllPassFilter(?).
	 *
	 * Compatible with interleaved stereo (or more channel) buffers and
	 * non-interleaved mono buffers.
	 *
	 * @param {Number} maxDelayInSamplesSize Maximum possible delay in samples (size of circular buffer)
	 * @param {Number} delayInSamples Initial delay in samples
	 * @param {Number} delayVolume Initial feedback delay volume. Float value: 0.0 (silence), 1.0 (normal), >1.0 (amplify)
	 *
	 * @constructor
	 */

	public function new(maxDelayInSamplesSize, delayInSamples, delayVolume) 
	{
	  this.delayBufferSamples = new Vector<Float>(maxDelayInSamplesSize); // The maximum size of delay
	  this.delayInputPointer  = delayInSamples;
	  this.delayOutputPointer = 0;
	 
	  this.delayInSamples     = delayInSamples;
	  this.delayVolume        = delayVolume;
	}
	
	public var delayBufferSamples : Vector<Float>;
	public var delayInputPointer : Int;
	public var delayOutputPointer : Int;
	public var delayInSamples : Int;
	public var delayVolume : Float;

	/**
	 * Change the delay time in samples.
	 *
	 * @param {Number} delayInSamples Delay in samples
	 */
	public function setDelayInSamples(delayInSamples) {
	  this.delayInSamples = delayInSamples;
	  this.delayInputPointer = this.delayOutputPointer + delayInSamples;

	  if (this.delayInputPointer >= this.delayBufferSamples.length-1) {
		this.delayInputPointer = this.delayInputPointer - this.delayBufferSamples.length; 
	  }
	}

	/**
	 * Change the return signal volume.
	 *
	 * @param {Number} delayVolume Float value: 0.0 (silence), 1.0 (normal), >1.0 (amplify)
	 */
	public function setDelayVolume(delayVolume) {
	  this.delayVolume = delayVolume;
	}

	/**
	 * Process a given interleaved or mono non-interleaved float value Array and
	 * returns the delayed audio.
	 *
	 * @param {Array} samples Array containing Float values or a Float32Array
	 *
	 * @returns A new Float32Array interleaved or mono non-interleaved as was fed to this function.
	 */
	public function process(samples : Vector<Float>) {
	  // NB. Make a copy to put in the output samples to return.
	  var outputSamples = new Vector<Float>(samples.length);

	  for (i in 0...samples.length) {

		// Add audio data with the delay in the delay buffer
		this.delayBufferSamples[this.delayInputPointer] = samples[i];
	   
		// delayBufferSamples could contain initial NULL's, return silence in that case
		var delaySample = this.delayBufferSamples[this.delayOutputPointer];

		// Return the audio with delay mix
		outputSamples[i] = delaySample * this.delayVolume;

		// Manage circulair delay buffer pointers
		this.delayInputPointer++;

		if (this.delayInputPointer >= this.delayBufferSamples.length-1) {
		  this.delayInputPointer = 0;
		}
		 
		this.delayOutputPointer++;

		if (this.delayOutputPointer >= this.delayBufferSamples.length-1) {
		  this.delayOutputPointer = 0; 
		} 
	  }
	 
	  return outputSamples;
	}	
	
}
