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

class FFT extends FourierTransform
{
	
	public var reverseTable : Vector<Int>;
	public var sinTable : FastFloatBuffer;
	public var cosTable : FastFloatBuffer;
	
	/**
	 * FFT is a class for calculating the Discrete Fourier Transform of a signal
	 * with the Fast Fourier Transform algorithm.
	 *
	 * @param {Number} bufferSize The size of the sample buffer to be computed. Must be power of 2
	 * @param {Number} sampleRate The sampleRate of the buffer (eg. 44100)
	 *
	 * @constructor
	 */
	public function new(bufferSize, sampleRate) {
	  super(bufferSize, sampleRate);
	   
	  this.reverseTable = new Vector<Int>();

	  var limit = 1;
	  var bit = bufferSize >> 1;

	  var i;

	  while (limit < bufferSize) {
		for (i in 0...limit) {
		  this.reverseTable[i + limit] = this.reverseTable[i] + bit;
		}

		limit = limit << 1;
		bit = bit >> 1;
	  }

	  this.sinTable = new FastFloatBuffer(bufferSize);
	  this.cosTable = new FastFloatBuffer(bufferSize);

	  for (i in 0...bufferSize) {
		this.sinTable.set(i, Math.sin(-Math.PI/i));
		this.cosTable.set(i, Math.cos(-Math.PI/i));
	  }
	}
	
	/**
	 * Performs a forward transform on the sample buffer.
	 * Converts a time domain signal to frequency domain spectra.
	 *
	 * @param {Array} buffer The sample buffer. Buffer Length must be power of 2
	 *
	 * @returns The frequency spectrum array
	 */
	public function forward(buffer : FastFloatBuffer) : FastFloatBuffer
	{
		// Locally scope variables for speed up
		var bufferSize      = this.bufferSize;
		var cosTable        = this.cosTable;
		var sinTable        = this.sinTable;
		var reverseTable    = this.reverseTable;
		var real            = this.real;
		var imag            = this.imag;
		var spectrum        = this.spectrum;

		var k = Math.floor(Math.log(bufferSize) / DSP.LN2);

		if (Math.pow(2, k) != bufferSize) { throw "Invalid buffer size, must be a power of 2."; }
		if (bufferSize != Std.int(buffer.length)) 
			{ throw "Supplied buffer is not the same size as defined FFT. FFT Size: " + bufferSize + " Buffer Size: " + buffer.length; }
		 
		var halfSize = 1;
		var phaseShiftStepReal = 0.;
		var phaseShiftStepImag = 0.;
		var currentPhaseShiftReal = 0.;
		var currentPhaseShiftImag = 0.;
		var off = 0;
		var tr = 0.;
		var ti = 0.;
		var tmpReal = 0.;
		var i = 0;

		for (i in 0...bufferSize) 
		{
			real.set(i, buffer.get(reverseTable[i]));
			imag.set(i, 0);
		}

		while (halfSize < bufferSize) 
		{
			//phaseShiftStepReal = Math.cos(-Math.PI/halfSize);
			//phaseShiftStepImag = Math.sin(-Math.PI/halfSize);
			phaseShiftStepReal = cosTable.get(halfSize);
			phaseShiftStepImag = sinTable.get(halfSize);
			
			currentPhaseShiftReal = 1;
			currentPhaseShiftImag = 0;

			for (fftStep in 0...halfSize) {
			  i = fftStep;

			  while (i < bufferSize) {
				off = i + halfSize;
				tr = (currentPhaseShiftReal * real.get(off)) - (currentPhaseShiftImag * imag.get(off));
				ti = (currentPhaseShiftReal * imag.get(off)) + (currentPhaseShiftImag * real.get(off));

				real.set(off, real.get(i) - tr);
				imag.set(off, imag.get(i) - ti);
				real.set(i, real.get(i) + tr);
				imag.set(i, real.get(i) + ti);

				i += halfSize << 1;
			  }

			  tmpReal = currentPhaseShiftReal;
			  currentPhaseShiftReal = (tmpReal * phaseShiftStepReal) - (currentPhaseShiftImag * phaseShiftStepImag);
			  currentPhaseShiftImag = (tmpReal * phaseShiftStepImag) + (currentPhaseShiftImag * phaseShiftStepReal);
			}

			halfSize = halfSize << 1;
		}

		return this.calculateSpectrum();
	}

	public function inverse(?real : FastFloatBuffer, ?imag : FastFloatBuffer, ?buffer : FastFloatBuffer) 
	{
		// Locally scope variables for speed up
		var bufferSize      = this.bufferSize;
		var cosTable        = this.cosTable;
		var sinTable        = this.sinTable;
		var reverseTable    = this.reverseTable;
		var spectrum        = this.spectrum;
		 
		real = real!=null ? real : this.real;
		imag = imag!=null ? imag : this.imag;

		var halfSize = 1;
		var phaseShiftStepReal = 0.;
		var phaseShiftStepImag = 0.;
		var currentPhaseShiftReal = 0.;
		var currentPhaseShiftImag = 0.;
		var off = 0;
		var tr = 0.;
		var ti = 0.;
		var tmpReal = 0.;
		var i = 0;

		for (i in 0...bufferSize) {
			imag.set(i, imag.get(i) * -1);
		}

		var revReal = new FastFloatBuffer(bufferSize);
		var revImag = new FastFloatBuffer(bufferSize);
		 
		for (i in 0...real.length) {
			revReal.set(i, real.get(reverseTable[i]));
			revImag.set(i, imag.get(reverseTable[i]));
		}
		 
		real = revReal;
		imag = revImag;

		while (halfSize < bufferSize) {
			phaseShiftStepReal = cosTable.get(halfSize);
			phaseShiftStepImag = sinTable.get(halfSize);
			currentPhaseShiftReal = 1;
			currentPhaseShiftImag = 0;

			for (fftStep in 0...halfSize) {
				i = fftStep;

				while (i < bufferSize) {
					off = i + halfSize;
					tr = (currentPhaseShiftReal * real.get(off)) - (currentPhaseShiftImag * imag.get(off));
					ti = (currentPhaseShiftReal * imag.get(off)) + (currentPhaseShiftImag * real.get(off));

					real.set(off, real.get(i) - tr);
					imag.set(off, imag.get(i) - ti);
					real.set(i, real.get(i) + tr);
					imag.set(i, imag.get(i) + ti);

					i += halfSize << 1;
				}

				tmpReal = currentPhaseShiftReal;
				currentPhaseShiftReal = (tmpReal * phaseShiftStepReal) - (currentPhaseShiftImag * phaseShiftStepImag);
				currentPhaseShiftImag = (tmpReal * phaseShiftStepImag) + (currentPhaseShiftImag * phaseShiftStepReal);
			}

			halfSize = halfSize << 1;
		}
		
		if (buffer==null)
			buffer = new FastFloatBuffer(bufferSize);
		for (i in 0...bufferSize) {
			buffer.set(i, real.get(i) / bufferSize);
		}

		return buffer;
	}
	
}

