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

class DFT extends FourierTransform
{
	
	public var sinTable : Vector<Float>;
	public var cosTable : Vector<Float>;
	
	/**
	 * DFT is a class for calculating the Discrete Fourier Transform of a signal.
	 *
	 * @param {Number} bufferSize The size of the sample buffer to be computed
	 * @param {Number} sampleRate The sampleRate of the buffer (eg. 44100)
	 *
	 * @constructor
	 */
	public function new(bufferSize : Int, sampleRate : Int) {
	  super(bufferSize, sampleRate);

	  var N = (bufferSize>>1) * bufferSize;
	  var TWO_PI = 2 * Math.PI;

	  this.sinTable = new Vector<Float>(N);
	  this.cosTable = new Vector<Float>(N);

	  for (i in 0...N) {
		this.sinTable[i] = Math.sin(i * TWO_PI / bufferSize);
		this.cosTable[i] = Math.cos(i * TWO_PI / bufferSize);
	  }
	}

	/**
	 * Performs a forward transform on the sample buffer.
	 * Converts a time domain signal to frequency domain spectra.
	 *
	 * @param {Array} buffer The sample buffer
	 *
	 * @returns The frequency spectrum array
	 */
	public function forward(buffer : Vector<Float>) {
	  var real = this.real; 
	  var imag = this.imag;
	  var rval = 0.;
	  var ival = 0.;

	  for (k in 0...this.bufferSize>>1) {
		rval = 0.0;
		ival = 0.0;

		for (n in 0...buffer.length) {
		  rval += this.cosTable[k*n] * buffer[n];
		  ival += this.sinTable[k*n] * buffer[n];
		}

		real[k] = rval;
		imag[k] = ival;
	  }

	  return this.calculateSpectrum();
	}

}

