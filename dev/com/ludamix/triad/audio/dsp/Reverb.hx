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
import nme.Vector;

class Reverb
{
	
	/**
	 * Reverb effect by Almer Thie (http://code.almeros.com).
	 * Copyright 2010 Almer Thie. All rights reserved.
	 * Example: http://code.almeros.com/code-examples/reverb-firefox-audio-api/
	 *
	 * This reverb consists of 6 SingleDelays, 6 MultiDelays and an IIRFilter2
	 * for each of the two stereo channels.
	 *
	 * Compatible with interleaved stereo buffers only!
	 *
	 * @param {Number} maxDelayInSamplesSize Maximum possible delay in samples (size of circular buffers)
	 * @param {Number} delayInSamples Initial delay in samples for internal (Single/Multi)delays
	 * @param {Number} masterVolume Initial master volume. Float value: 0.0 (silence), 1.0 (normal), >1.0 (amplify)
	 * @param {Number} mixVolume Initial reverb signal mix volume. Float value: 0.0 (silence), 1.0 (normal), >1.0 (amplify)
	 * @param {Number} delayVolume Initial feedback delay volume for internal (Single/Multi)delays. Float value: 0.0 (silence), 1.0 (normal), >1.0 (amplify)
	 * @param {Number} dampFrequency Initial low pass filter frequency. 0 to 44100 (depending on your maximum sampling frequency)
	 *
	 * @constructor
	 */
	
	public var delayInSamples : Int;
	public var masterVolume : Float;
	public var mixVolume : Float;
	public var delayVolume : Float;
	public var dampFrequency : Float;
	
	public static inline var NR_OF_MULTIDELAYS = 6;
	public static inline var NR_OF_SINGLEDELAYS = 6;
	
	public var LOWPASSL : IIRFilter2;
	public var LOWPASSR : IIRFilter2;
	public var multiDelays : Array<MultiDelay>;
	public var singleDelays : Array<SingleDelay>;
	
	public function new(maxDelayInSamplesSize, delayInSamples, masterVolume, mixVolume, delayVolume, dampFrequency) {
	  this.delayInSamples   = delayInSamples;
	  this.masterVolume     = masterVolume;
	  this.mixVolume       = mixVolume;
	  this.delayVolume     = delayVolume;
	  this.dampFrequency     = dampFrequency;
	 
	  this.LOWPASSL = new IIRFilter2(DSP.LOWPASS, dampFrequency, 0, 44100);
	  this.LOWPASSR = new IIRFilter2(DSP.LOWPASS, dampFrequency, 0, 44100);
	 
	  this.singleDelays = new Array<SingleDelay>();
	  
	  var i : Int = 0;
	  var delayMultiply : Float = 0.;

	  for (i in 0...NR_OF_SINGLEDELAYS) {
		delayMultiply = 1.0 + (i/7.0); // 1.0, 1.1, 1.2...
		this.singleDelays[i] = new SingleDelay(maxDelayInSamplesSize, Math.round(this.delayInSamples * delayMultiply), this.delayVolume);
	  }
	 
	  this.multiDelays = new Array<MultiDelay>();

	  for (i in 0...NR_OF_MULTIDELAYS) {
		delayMultiply = 1.0 + (i/10.0); // 1.0, 1.1, 1.2... 
		this.multiDelays[i] = new MultiDelay(maxDelayInSamplesSize, Math.round(this.delayInSamples * delayMultiply), this.masterVolume, this.delayVolume);
	  }
	}

	/**
	 * Change the delay time in samples as a base for all delays.
	 *
	 * @param {Number} delayInSamples Delay in samples
	 */
	public function setDelayInSamples(delayInSamples){
	  this.delayInSamples = delayInSamples;

	  var i : Int = 0;
	  var delayMultiply : Float = 0.;
	 
	  for (i in 0...NR_OF_SINGLEDELAYS) {
		delayMultiply = 1.0 + (i/7.0); // 1.0, 1.1, 1.2...
		this.singleDelays[i].setDelayInSamples( Math.round(this.delayInSamples * delayMultiply) );
	  }
	   
	  for (i in 0...NR_OF_MULTIDELAYS) {
		delayMultiply = 1.0 + (i/10.0); // 1.0, 1.1, 1.2...
		this.multiDelays[i].setDelayInSamples( Math.round(this.delayInSamples * delayMultiply) );
	  }
	}

	/**
	 * Change the master volume.
	 *
	 * @param {Number} masterVolume Float value: 0.0 (silence), 1.0 (normal), >1.0 (amplify)
	 */
	public function setMasterVolume(masterVolume){
	  this.masterVolume = masterVolume;
	}

	/**
	 * Change the reverb signal mix level.
	 *
	 * @param {Number} mixVolume Float value: 0.0 (silence), 1.0 (normal), >1.0 (amplify)
	 */
	public function setMixVolume(mixVolume){
	  this.mixVolume = mixVolume;
	}

	/**
	 * Change all delays feedback volume.
	 *
	 * @param {Number} delayVolume Float value: 0.0 (silence), 1.0 (normal), >1.0 (amplify)
	 */
	public function setDelayVolume(delayVolume){
	  this.delayVolume = delayVolume;
	 
	  for (i in 0...NR_OF_SINGLEDELAYS) {
		this.singleDelays[i].setDelayVolume(this.delayVolume);
	  } 
	 
	  for (i in 0...NR_OF_MULTIDELAYS) {
		this.multiDelays[i].setDelayVolume(this.delayVolume);
	  } 
	}

	/**
	 * Change the Low Pass filter frequency.
	 *
	 * @param {Number} dampFrequency low pass filter frequency. 0 to 44100 (depending on your maximum sampling frequency)
	 */
	public function setDampFrequency(dampFrequency){
	  this.dampFrequency = dampFrequency;
	 
	  this.LOWPASSL.set(dampFrequency, 0);
	  this.LOWPASSR.set(dampFrequency, 0); 
	}

	/**
	 * Process a given interleaved float value Array and copies and adds the reverb signal.
	 *
	 * @param {Array} samples Array containing Float values or a Float32Array
	 *
	 * @returns A new Float32Array interleaved buffer.
	 */
	public function process(interleavedSamples : Vector<Float>){ 
	  // NB. Make a copy to put in the output samples to return.
	  var outputSamples = new Vector<Float>(interleavedSamples.length);
	  var reusableBuffer = new Vector<Float>(interleavedSamples.length);
	 
	  // Perform low pass on the input samples to mimick damp
	  var leftRightMix = DSP.deinterleave(interleavedSamples);
	  this.LOWPASSL.process( leftRightMix[DSP.LEFT] );
	  this.LOWPASSR.process( leftRightMix[DSP.RIGHT] ); 
	  var filteredSamples = DSP.interleave(leftRightMix[DSP.LEFT], leftRightMix[DSP.RIGHT]);
	  
	  // Process MultiDelays in parallel
	  for (i in 0...NR_OF_MULTIDELAYS) {
		// Invert the signal of every even multiDelay
		reusableBuffer = multiDelays[i].process(filteredSamples, reusableBuffer);
		if (2 % i == 0)
		{
			for (s in 0...filteredSamples.length)
			{
				outputSamples[s] = (outputSamples[s] - reusableBuffer[s]) / NR_OF_MULTIDELAYS;
			}
		}
		else
		{
			for (s in 0...filteredSamples.length)
			{
				outputSamples[s] = (outputSamples[s] + reusableBuffer[s]) / NR_OF_MULTIDELAYS;
			}
		}
	  }
	 
	  // Process SingleDelays in series
	  var singleDelaySamples = new Vector<Float>(outputSamples.length);
	  for (i in 0...NR_OF_SINGLEDELAYS) {
		// Invert the signal of every even singleDelay
		var postDelaySamples = singleDelays[i].process(outputSamples, reusableBuffer);
		if (2 % i == 0)
		{
			for (s in 0...singleDelaySamples.length) 
			{
				singleDelaySamples[s] = singleDelaySamples[s] - postDelaySamples[s] * this.mixVolume;
			}
		}
		else
		{
			for (s in 0...singleDelaySamples.length) 
			{
				singleDelaySamples[s] = singleDelaySamples[s] + postDelaySamples[s] * this.mixVolume;
			}
		}
	  }
	 
	  // Mix the original signal with the reverb signal
	  for (i in 0...outputSamples.length)
		outputSamples[i] = singleDelaySamples[i] + interleavedSamples[i] * this.masterVolume;
	   
	  return outputSamples;
	}	
	
}