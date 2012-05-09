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

class Oscillator
{
	
	// FIXME: no motiviation to finish porting this right now.
	
	/**
	 * Oscillator class for generating and modifying signals
	 *
	 * @param {Number} type       A waveform constant (eg. DSP.SINE)
	 * @param {Number} frequency  Initial frequency of the signal
	 * @param {Number} amplitude  Initial amplitude of the signal
	 * @param {Number} bufferSize Size of the sample buffer to generate
	 * @param {Number} sampleRate The sample rate of the signal
	 *
	 * @contructor
	 */
	
	public var generateWaveTable : Void->Void;
	 
	public function new(type, frequency, amplitude, bufferSize, sampleRate) {
	  this.frequency  = frequency;
	  this.amplitude  = amplitude;
	  this.bufferSize = bufferSize;
	  this.sampleRate = sampleRate;
	  //this.pulseWidth = pulseWidth;
	  this.frameCount = 0;
	 
	  this.waveTableLength = 2048;

	  this.cyclesPerSample = frequency / sampleRate;

	  this.signal = new Vector<Float>(bufferSize);
	  this.envelope = null;

	  switch(parseInt(type, 10)) {
		case DSP.TRIANGLE:
		  this.func = Oscillator.Triangle;
		  break;

		case DSP.SAW:
		  this.func = Oscillator.Saw;
		  break;

		case DSP.SQUARE:
		  this.func = Oscillator.Square;
		  break;

		default:
		case DSP.SINE:
		  this.func = Oscillator.Sine;
		  break;
	  }

	  this.generateWaveTable = function() {
		waveTable[this.func] = new Vector<Float>(2048);
		var waveTableTime = this.waveTableLength / this.sampleRate;
		var waveTableHz = 1 / waveTableTime;
		
		for (i in 0...this.waveTableLength) {
		  waveTable[this.func][i] = this.func(i * waveTableHz/this.sampleRate);
		}
	  };

	  if ( typeof Oscillator.waveTable === 'undefined' ) {
		Oscillator.waveTable = {};
	  }

	  if ( typeof Oscillator.waveTable[this.func] === 'undefined' ) {
		this.generateWaveTable();
	  }
	 
	  this.waveTable = Oscillator.waveTable[this.func];
	}

	/**
	 * Set the amplitude of the signal
	 *
	 * @param {Number} amplitude The amplitude of the signal (between 0 and 1)
	 */
	public function setAmp(amplitude) {
	  if (amplitude >= 0 && amplitude <= 1) {
		this.amplitude = amplitude;
	  } else {
		throw "Amplitude out of range (0..1).";
	  }
	};
	  
	/**
	 * Set the frequency of the signal
	 *
	 * @param {Number} frequency The frequency of the signal
	 */  
	public function setFreq(frequency) {
	  this.frequency = frequency;
	  this.cyclesPerSample = frequency / this.sampleRate;
	};
		 
	// Add an oscillator
	public function add(oscillator) {
	  for ( var i = 0; i < this.bufferSize; i++ ) {
		//this.signal[i] += oscillator.valueAt(i);
		this.signal[i] += oscillator.signal[i];
	  }
	 
	  return this.signal;
	};
		 
	// Add a signal to the current generated osc signal
	public function addSignal(signal) {
	  for ( var i = 0; i < signal.length; i++ ) {
		if ( i >= this.bufferSize ) {
		  break;
		}
		this.signal[i] += signal[i];
	   
		/*
		// Constrain amplitude
		if ( this.signal[i] > 1 ) {
		  this.signal[i] = 1;
		} else if ( this.signal[i] < -1 ) {
		  this.signal[i] = -1;
		}
		*/
	  }
	  return this.signal;
	};
		 
	// Add an envelope to the oscillator
	public function addEnvelope(envelope) {
	  this.envelope = envelope;
	};

	public function applyEnvelope() {
	  this.envelope.process(this.signal);
	};
		 
	public function valueAt(offset) {
	  return this.waveTable[offset % this.waveTableLength];
	};
		 
	public function generate() {
	  var frameOffset = this.frameCount * this.bufferSize;
	  var step = this.waveTableLength * this.frequency / this.sampleRate;
	  var offset;

	  for ( var i = 0; i < this.bufferSize; i++ ) {
		//var step = (frameOffset + i) * this.cyclesPerSample % 1;
		//this.signal[i] = this.func(step) * this.amplitude;
		//this.signal[i] = this.valueAt(Math.round((frameOffset + i) * step)) * this.amplitude;
		offset = Math.round((frameOffset + i) * step);
		this.signal[i] = this.waveTable[offset % this.waveTableLength] * this.amplitude;
	  }

	  this.frameCount++;

	  return this.signal;
	};

	public function Sine(step) {
	  return Math.sin(DSP.TWO_PI * step);
	};

	public function Square(step) {
	  return step < 0.5 ? 1 : -1;
	};

	public function Saw(step) {
	  return 2 * (step - Math.round(step));
	};

	public function Triangle(step) {
	  return 1 - 4 * Math.abs(Math.round(step) - step);
	};

	public function Pulse(step) {
	  // stub
	};
	 
	
}
