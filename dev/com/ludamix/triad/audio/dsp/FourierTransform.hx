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

class FourierTransform
{
	
	public var bufferSize : Int;
	public var sampleRate : Int;
	public var bandwidth : Float;
	public var spectrum : Vector<Float>;
	public var real : Vector<Float>;
	public var imag : Vector<Float>;
	public var peakBand : Float;
	public var peak : Float;
	
	// Fourier Transform Module used by DFT, FFT, RFFT
	public function new(bufferSize : Int, sampleRate : Int) 
	{
		
	  this.bufferSize = bufferSize;
	  this.sampleRate = sampleRate;
	  this.bandwidth  = 2 / bufferSize * sampleRate / 2;

	  this.spectrum   = new Vector<Float>(bufferSize>>1);
	  this.real       = new Vector<Float>(bufferSize);
	  this.imag       = new Vector<Float>(bufferSize);

	  this.peakBand   = 0.;
	  this.peak       = 0.;

	}	
	
  /**
   * Calculates the *middle* frequency of an FFT band.
   *
   * @param {Number} index The index of the FFT band.
   *
   * @returns The middle frequency in Hz.
   */
	public inline function getBandFrequency(index) { return this.bandwidth * index + this.bandwidth / 2; }

	public inline function calculateSpectrum() 
	{
		var spectrum  = this.spectrum;
		var real      = this.real;
		var imag      = this.imag;
		var bSi       = 2 / this.bufferSize;
		var rval = 0.;
		var ival = 0.;
		var mag = 0.;

		for (i in 0...bufferSize >> 1) 
		{			
		  rval = real[i];
		  ival = imag[i];
		  mag = bSi * Math.sqrt(rval * rval + ival * ival);

		  if (mag > this.peak) {
			this.peakBand = i;
			this.peak = mag;
		  }

		  spectrum[i] = mag;
		}
		
	}
}

