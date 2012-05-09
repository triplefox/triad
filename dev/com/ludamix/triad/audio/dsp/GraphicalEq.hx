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

class GraphicalEq
{
	/* 
	 *  Graphical Equalizer
	 *
	 *  Implementation of a graphic equalizer with a configurable bands-per-octave
	 *  and minimum and maximum frequencies
	 * 
	 *  Created by Ricard Marxer <email@ricardmarxer.com> on 2010-05-23.
	 *  Copyright 2010 Ricard Marxer. All rights reserved.
	 *
	 */
	public function new(sampleRate) {
	  this.FS = sampleRate;
	  this.minFreq = 40.0;
	  this.maxFreq = 16000.0;

	  this.bandsPerOctave = 1.0;

	  this.filters = new Array();
	  this.freqzs = new Array();

	  this.calculateFreqzs = true;

	}
	
	public var FS : Int;
	public var minFreq : Float;
	public var maxFreq : Float;
	public var bandsPerOctave : Float;
	public var filters : Array<Biquad>;
	public var freqzs : Array<Vector<Float>>;
	public var calculateFreqzs : Bool;
	public var w : Vector<Float>;
	
	public function recalculateFilters() 
	{
		var bandCount = Math.round(Math.log(this.maxFreq/this.minFreq) * this.bandsPerOctave/ DSP.LN2);

	  this.filters = new Array();
		for (i in 0...bandCount) {
		  var freq = this.minFreq*(Math.pow(2, i/this.bandsPerOctave));
		  var newFilter = new Biquad(Biquad.PEAKING_EQ, this.FS);
		  newFilter.setDbGain(0);
		  newFilter.setBW(1/this.bandsPerOctave);
		  newFilter.setF0(freq);
		  this.filters[i] = newFilter;
		  this.recalculateFreqz(i);
		}
	}

	public function setMinimumFrequency(freq) {
		this.minFreq = freq;
		this.recalculateFilters();
	}

	public function setMaximumFrequency(freq) {
		this.maxFreq = freq;
		this.recalculateFilters();
	}

	public function setBandsPerOctave (bands) {
		this.bandsPerOctave = bands;
		this.recalculateFilters();
	}

	public function setBandGain(bandIndex : Int, gain : Float) 
	{
		if (bandIndex < 0 || bandIndex > (this.filters.length-1)) {
		  throw "The band index of the graphical equalizer is out of bounds.";
		}

		this.filters[bandIndex].setDbGain(gain);
		this.recalculateFreqz(bandIndex);
	}
	 
	public function recalculateFreqz(bandIndex : Int) 
	{
		if (!this.calculateFreqzs) {
		  return;
		}

		if (bandIndex < 0 || bandIndex > (this.filters.length-1)) {
		  throw "The band index of the graphical equalizer is out of bounds. " + 
			Std.string(bandIndex) + " is out of [" + Std.string(0) + ", " + Std.string(this.filters.length-1) + "]";
		}
		   
		if (this.w==null) {
		  this.w = new Vector<Float>(400);
		  for (i in 0...this.w.length) {
			 this.w[i] = Math.PI/this.w.length * i;
		  }
		}
	   
		var b = [this.filters[bandIndex].b0, this.filters[bandIndex].b1, this.filters[bandIndex].b2];
		var a = [this.filters[bandIndex].a0, this.filters[bandIndex].a1, this.filters[bandIndex].a2];

		this.freqzs[bandIndex] = DSP.mag2db(DSP.freqz(b, a, this.w));
	}

	public function process(buffer : Vector<Float>) 
	{
		var output = buffer;

		for (i in 0...this.filters.length)
		  output = this.filters[i].process(output);

		return output;
	}

	public function processStereo(buffer) 
	{
		var output = buffer;

		for (i in 0...this.filters.length)
		  output = this.filters[i].processStereo(output);

		return output;
	}
	  
}

