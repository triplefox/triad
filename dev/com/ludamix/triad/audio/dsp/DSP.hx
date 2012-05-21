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
 
////////////////////////////////////////////////////////////////////////////////
//                                  CONSTANTS                                 //
////////////////////////////////////////////////////////////////////////////////

/**
 * DSP is an object which contains general purpose utility functions and constants
 */
class DSP
{
	
	// Channels
	public static inline var LEFT = 0;
	public static inline var RIGHT = 1;
	public static inline var MIX = 2;

	// Waveforms
	public static inline var SINE = 1;
	public static inline var TRIANGLE = 2;
	public static inline var SAW = 3;
	public static inline var SQUARE = 4;

	// Filters
	public static inline var LOWPASS = 0;
	public static inline var HIGHPASS = 1;
	public static inline var BANDPASS = 2;
	public static inline var NOTCH = 3;

	// Loop modes
	public static inline var OFF = 0;
	public static inline var FW = 1;
	public static inline var BW = 2;
	public static inline var FWBW = 3;

	// Biquad filter parameter types
	public static inline var Q = 1;
	//public static inline var BW = 2; // SHARED with BACKWARDS LOOP MODE
	public static inline var S = 3;

	// Math
	public static inline var TWO_PI = 2 * Math.PI;
	public static inline var LN2 = 0.6931471805599453;
	public static inline var SQRT1_2 = 0.7071067811865476;
	public static inline var E = 2.718281828459045;
  
	////////////////////////////////////////////////////////////////////////////////
	//                            DSP UTILITY FUNCTIONS                           //
	////////////////////////////////////////////////////////////////////////////////

	/**
	 * Inverts the phase of a signal
	 *
	 * @param {Array} buffer A sample buffer
	 *
	 * @returns The inverted sample buffer
	 */
	public static inline function invert(buffer : FastFloatBuffer) 
	{
	  for (i in 0...buffer.length) buffer.set(i, buffer.get(i) * -1);
	  return buffer;
	}

	/**
	 * Converts split-stereo (dual mono) sample buffers into a stereo interleaved sample buffer
	 *
	 * @param {Array} left  A sample buffer
	 * @param {Array} right A sample buffer
	 *
	 * @returns The stereo interleaved buffer
	 */
	public static inline function interleave(left : FastFloatBuffer, right : FastFloatBuffer) 
	{
	  if (left.length != right.length) throw "Can not interleave. Channel lengths differ.";
	 
	  var stereoInterleaved = new FastFloatBuffer(left.length * 2);
	 
	  for (i in 0...left.length) 
	  {
		stereoInterleaved.set(2*i, left.get(i));
		stereoInterleaved.set(2*i+1, right.get(i));
	  }
	 
	  return stereoInterleaved;
	}

	/**
	 * Converts a stereo-interleaved sample buffer into split-stereo (dual mono) sample buffers
	 *
	 * @param {Array} buffer A stereo-interleaved sample buffer
	 *
	 * @returns an Array containing left and right channels
	 */
	public static function deinterleave(buffer : FastFloatBuffer) 
	{
		return [getChannel(LEFT, buffer), getChannel(RIGHT, buffer)];
	}

	/**
	 * Separates a channel from a stereo-interleaved sample buffer
	 *
	 * @param {Array}  buffer A stereo-interleaved sample buffer
	 * @param {Number} channel A channel constant (LEFT, RIGHT, MIX)
	 *
	 * @returns an Array containing a signal mono sample buffer
	 */
	public static function getChannel(channel : Int, buffer : FastFloatBuffer)
	{
		var result = new FastFloatBuffer(Std.int(buffer.length/2));
		switch(channel)
		{
			case MIX:
				for (i in 0...Std.int(buffer.length / 2)) result.set(i, (buffer.get(2 * i) + buffer.get(2 * i + 1)) / 2);
			case LEFT:
				for (i in 0...Std.int(buffer.length / 2)) result.set(i, buffer.get(2*i));
			case RIGHT:
				for (i in 0...Std.int(buffer.length / 2)) result.set(i, buffer.get(2*i+1));
		}
		return result;
	}

	/**
	 * Helper method (for Reverb) to mix two (interleaved) samplebuffers. It's possible
	 * to negate the second buffer while mixing and to perform a volume correction
	 * on the final signal.
	 *
	 * @param {Array} sampleBuffer1 Array containing Float values or a Float32Array
	 * @param {Array} sampleBuffer2 Array containing Float values or a Float32Array
	 * @param {Boolean} negate When true inverts/flips the audio signal
	 * @param {Number} volumeCorrection When you add multiple sample buffers, use this to tame your signal ;)
	 *
	 * @returns A new Float32Array interleaved buffer.
	 */
	public static inline function mixSampleBuffers(sampleBuffer1 : FastFloatBuffer, sampleBuffer2 : FastFloatBuffer, 
		negate : Bool, volumeCorrection : Float)
	{
	  var outputSamples = new FastFloatBuffer(sampleBuffer1.length);

	  for(i in 0...sampleBuffer1.length)
		outputSamples.set(i, outputSamples.get(i) + 
			(sampleBuffer1.get(i) + (negate ? -sampleBuffer2.get(i) : sampleBuffer2.get(i))) / volumeCorrection);
	 
	  return outputSamples;
	}

	// Find RMS of signal
	public static inline function RMS(buffer : FastFloatBuffer)
	{
	  var total = 0.;
	  
	  for (i in 0...buffer.length)
		total += buffer.get(i) * buffer.get(i);
	  
	  return Math.sqrt(total / buffer.length);
	}

	// Find Peak of signal
	public static inline function Peak(buffer : FastFloatBuffer) 
	{
	  var peak = 0.;
	  
	  for (i in 0...buffer.length)
		peak = (Math.abs(buffer.get(i)) > peak) ? Math.abs(buffer.get(i)) : peak; 
	  
	  return peak;
	}

	public static inline function sinh(arg : Float) {
	  // Returns the hyperbolic sine of the number, defined as (exp(number) - exp(-number))/2 
	  //
	  // version: 1004.2314
	  // discuss at: http://phpjs.org/functions/sinh    // +   original by: Onno Marsman
	  // *     example 1: sinh(-0.9834330348825909);
	  // *     returns 1: -1.1497971402636502
	  return (Math.exp(arg) - Math.exp(-arg))/2;
	}

	/* 
	 *  Magnitude to decibels
	 * 
	 *  Created by Ricard Marxer <email@ricardmarxer.com> on 2010-05-23.
	 *  Copyright 2010 Ricard Marxer. All rights reserved.
	 *
	 *  @buffer array of magnitudes to convert to decibels
	 *
	 *  @returns the array in decibels
	 *
	 */
	public static inline function mag2db(buffer : FastFloatBuffer) {
	  var minDb = -120;
	  var minMag = Math.pow(10.0, minDb / 20.0);

	  var log = Math.log;
	  var max = Math.max;
	 
	  var result = new FastFloatBuffer(buffer.length);
	  for (i in 0...buffer.length)
		result.set(i, 20.0*log(max(buffer.get(i), minMag)));

	  return result;
	}

	/* 
	 *  Frequency response
	 * 
	 *  Created by Ricard Marxer <email@ricardmarxer.com> on 2010-05-23.
	 *  Copyright 2010 Ricard Marxer. All rights reserved.
	 *
	 *  Calculates the frequency response at the given points.
	 *
	 *  @b b coefficients of the filter
	 *  @a a coefficients of the filter
	 *  @w w points (normally between -PI and PI) where to calculate the frequency response
	 *
	 *  @returns the frequency response in magnitude
	 *
	 */
	public static inline function freqz(b : Array<Float>, a : Array<Float>, w : FastFloatBuffer) : FastFloatBuffer
	{
	  var i : Float; 
	  var j : Float;

	  if (w==null) {
		w = new FastFloatBuffer(200);
		for (i in 0...w.length) {
		  w.set(i, DSP.TWO_PI/w.length * i - Math.PI);
		}
	  }

	  var result = new FastFloatBuffer(w.length);
	 
	  var sqrt = Math.sqrt;
	  var cos = Math.cos;
	  var sin = Math.sin;
	 
	  for (i in 0...w.length) {
		var numerator = {real:0.0, imag:0.0};
		for (j in 0...b.length) {
		  numerator.real += b[j] * cos(-j*w.get(i));
		  numerator.imag += b[j] * sin(-j*w.get(i));
		}

		var denominator = {real:0.0, imag:0.0};
		for (j in 0...a.length) {
		  denominator.real += a[j] * cos(-j*w.get(i));
		  denominator.imag += a[j] * sin(-j*w.get(i));
		}
	 
		result.set(i, sqrt(numerator.real * numerator.real + numerator.imag * numerator.imag) / 
			sqrt(denominator.real*denominator.real + denominator.imag*denominator.imag));
	  }

	  return result;
	}
  
}
