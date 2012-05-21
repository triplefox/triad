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

class Biquad
{
	/* 
	 *  Biquad filter
	 * 
	 *  Created by Ricard Marxer <email@ricardmarxer.com> on 2010-05-23.
	 *  Copyright 2010 Ricard Marxer. All rights reserved.
	 *
	 */
	// Implementation based on:
	// http://www.musicdsp.org/files/Audio-EQ-Cookbook.txt
	
	public var Fs : Int;
	public var type : Int;
	public var parameterType : Int;
	public var x_1_l : Float;
	public var x_2_l : Float;
	public var y_1_l : Float;
	public var y_2_l : Float;
	public var x_1_r : Float;
	public var x_2_r : Float;
	public var y_1_r : Float;
	public var y_2_r : Float;
	public var b0 : Float;
	public var a0 : Float;
	public var b1 : Float;
	public var a1 : Float;
	public var b2 : Float;
	public var a2 : Float;
	public var b0a0 : Float;
	public var b1a0 : Float;
	public var b2a0 : Float;
	public var a1a0 : Float;
	public var a2a0 : Float;
	public var f0 : Float;
	public var dBgain : Float;
	public var Q : Float;
	public var BW : Float;
	public var S : Float;
	
	public function new(type, sampleRate) 
	{
		this.Fs = sampleRate;
		this.type = type;  // type of the filter
		this.parameterType = DSP.Q; // type of the parameter

		this.x_1_l = 0;
		this.x_2_l = 0;
		this.y_1_l = 0;
		this.y_2_l = 0;

		this.x_1_r = 0;
		this.x_2_r = 0;
		this.y_1_r = 0;
		this.y_2_r = 0;

		this.b0 = 1;
		this.a0 = 1;

		this.b1 = 0;
		this.a1 = 0;

		this.b2 = 0;
		this.a2 = 0;

		this.b0a0 = this.b0 / this.a0;
		this.b1a0 = this.b1 / this.a0;
		this.b2a0 = this.b2 / this.a0;
		this.a1a0 = this.a1 / this.a0;
		this.a2a0 = this.a2 / this.a0;

		this.f0 = 3000;   // "wherever it's happenin', man."  Center Frequency or
						// Corner Frequency, or shelf midpoint frequency, depending
						// on which filter type.  The "significant frequency".

		this.dBgain = 12; // used only for peaking and shelving filters

		this.Q = 1;       // the EE kind of definition, except for peakingEQ in which A*Q is
						// the classic EE Q.  That adjustment in definition was made so that
						// a boost of N dB followed by a cut of N dB for identical Q and
						// f0/Fs results in a precisely flat unity gain filter or "wire".

		this.BW = -3;     // the bandwidth in octaves (between -3 dB frequencies for BPF
						// and notch or between midpoint (dBgain/2) gain frequencies for
						// peaking EQ

		this.S = 1;       // a "shelf slope" parameter (for shelving EQ only).  When S = 1,
						// the shelf slope is as steep as it can be and remain monotonically
						// increasing or decreasing gain with frequency.  The shelf slope, in
						// dB/octave, remains proportional to S for all other values for a
						// fixed f0/Fs and dBgain.
	}
						
	// Biquad filter types
	public static inline var LPF = 0;                // H(s) = 1 / (s^2 + s/Q + 1)
	public static inline var HPF = 1;                // H(s) = s^2 / (s^2 + s/Q + 1)
	public static inline var BPF_CONSTANT_SKIRT = 2; // H(s) = s / (s^2 + s/Q + 1)  (constant skirt gain, peak gain = Q)
	public static inline var BPF_CONSTANT_PEAK = 3;  // H(s) = (s/Q) / (s^2 + s/Q + 1)      (constant 0 dB peak gain)
	public static inline var NOTCH = 4;              // H(s) = (s^2 + 1) / (s^2 + s/Q + 1)
	public static inline var APF = 5;                // H(s) = (s^2 - s/Q + 1) / (s^2 + s/Q + 1)
	public static inline var PEAKING_EQ = 6;         // H(s) = (s^2 + s*(A/Q) + 1) / (s^2 + s/(A*Q) + 1)
	public static inline var LOW_SHELF = 7;          // H(s) = A * (s^2 + (sqrt(A)/Q)*s + A)/(A*s^2 + (sqrt(A)/Q)*s + 1)
	public static inline var HIGH_SHELF = 8;         // H(s) = A * (A*s^2 + (sqrt(A)/Q)*s + 1)/(s^2 + (sqrt(A)/Q)*s + A)

	public function coefficients() {
		var b = [this.b0, this.b1, this.b2];
		var a = [this.a0, this.a1, this.a2];
		return {b: b, a:a};
	  }

	public function setFilterType(type) {
		this.type = type;
		this.recalculateCoefficients();
	}

	public function setSampleRate(rate) {
		this.Fs = rate;
		this.recalculateCoefficients();
	  }

	public function setQ(q) {
		this.parameterType = DSP.Q;
		this.Q = Math.max(Math.min(q, 115.0), 0.001);
		this.recalculateCoefficients();
	}

	public function setBW(bw) {
		this.parameterType = DSP.BW;
		this.BW = bw;
		this.recalculateCoefficients();
	  }

	public function setS(s) {
		this.parameterType = DSP.S;
		this.S = Math.max(Math.min(s, 5.0), 0.0001);
		this.recalculateCoefficients();
	}

	public function setF0(freq) {
		this.f0 = freq;
		this.recalculateCoefficients();
	}
	 
	public function setDbGain(g) {
		this.dBgain = g;
		this.recalculateCoefficients();
	}

	public function recalculateCoefficients() {
		var A : Float =0.;
		if (type == PEAKING_EQ || type == LOW_SHELF || type == HIGH_SHELF ) {
		  A = Math.pow(10, (this.dBgain/40));  // for peaking and shelving EQ filters only
		} else {
		  A  = Math.sqrt( Math.pow(10, (this.dBgain/20)) );   
		}

		var w0 = DSP.TWO_PI * this.f0 / this.Fs;

		var cosw0 = Math.cos(w0);
		var sinw0 = Math.sin(w0);

		var alpha = 0.;
	   
		switch (this.parameterType) {
		  case DSP.Q:
			alpha = sinw0/(2*this.Q);
			   
		  case DSP.BW:
			alpha = sinw0 * DSP.sinh( DSP.LN2/2 * this.BW * w0/sinw0 );

		  case DSP.S:
			alpha = sinw0/2 * Math.sqrt( (A + 1/A)*(1/this.S - 1) + 2 );
		}

		/**
			FYI: The relationship between bandwidth and Q is
				 1/Q = 2*sinh(ln(2)/2*BW*w0/sin(w0))     (digital filter w BLT)
			or   1/Q = 2*sinh(ln(2)/2*BW)             (analog filter prototype)

			The relationship between shelf slope and Q is
				 1/Q = sqrt((A + 1/A)*(1/S - 1) + 2)
		*/

		var coeff = 0.;

		switch (this.type) {
		  case LPF:       // H(s) = 1 / (s^2 + s/Q + 1)
			this.b0 =  (1 - cosw0)/2;
			this.b1 =   1 - cosw0;
			this.b2 =  (1 - cosw0)/2;
			this.a0 =   1 + alpha;
			this.a1 =  -2 * cosw0;
			this.a2 =   1 - alpha;

		  case HPF:       // H(s) = s^2 / (s^2 + s/Q + 1)
			this.b0 =  (1 + cosw0)/2;
			this.b1 = -(1 + cosw0);
			this.b2 =  (1 + cosw0)/2;
			this.a0 =   1 + alpha;
			this.a1 =  -2 * cosw0;
			this.a2 =   1 - alpha;

		  case BPF_CONSTANT_SKIRT:       // H(s) = s / (s^2 + s/Q + 1)  (constant skirt gain, peak gain = Q)
			this.b0 =   sinw0/2;
			this.b1 =   0;
			this.b2 =  -sinw0/2;
			this.a0 =   1 + alpha;
			this.a1 =  -2*cosw0;
			this.a2 =   1 - alpha;

		  case BPF_CONSTANT_PEAK:       // H(s) = (s/Q) / (s^2 + s/Q + 1)      (constant 0 dB peak gain)
			this.b0 =   alpha;
			this.b1 =   0;
			this.b2 =  -alpha;
			this.a0 =   1 + alpha;
			this.a1 =  -2*cosw0;
			this.a2 =   1 - alpha;

		  case NOTCH:     // H(s) = (s^2 + 1) / (s^2 + s/Q + 1)
			this.b0 =   1;
			this.b1 =  -2*cosw0;
			this.b2 =   1;
			this.a0 =   1 + alpha;
			this.a1 =  -2*cosw0;
			this.a2 =   1 - alpha;

		  case APF:       // H(s) = (s^2 - s/Q + 1) / (s^2 + s/Q + 1)
			this.b0 =   1 - alpha;
			this.b1 =  -2*cosw0;
			this.b2 =   1 + alpha;
			this.a0 =   1 + alpha;
			this.a1 =  -2*cosw0;
			this.a2 =   1 - alpha;

		  case PEAKING_EQ:  // H(s) = (s^2 + s*(A/Q) + 1) / (s^2 + s/(A*Q) + 1)
			this.b0 =   1 + alpha*A;
			this.b1 =  -2*cosw0;
			this.b2 =   1 - alpha*A;
			this.a0 =   1 + alpha/A;
			this.a1 =  -2*cosw0;
			this.a2 =   1 - alpha/A;

		  case LOW_SHELF:   // H(s) = A * (s^2 + (sqrt(A)/Q)*s + A)/(A*s^2 + (sqrt(A)/Q)*s + 1)
			coeff = sinw0 * Math.sqrt( (A*A + 1)*(1/this.S - 1) + 2*A );
			this.b0 =    A*((A+1) - (A-1)*cosw0 + coeff);
			this.b1 =  2*A*((A-1) - (A+1)*cosw0);
			this.b2 =    A*((A+1) - (A-1)*cosw0 - coeff);
			this.a0 =       (A+1) + (A-1)*cosw0 + coeff;
			this.a1 =   -2*((A-1) + (A+1)*cosw0);
			this.a2 =       (A+1) + (A-1)*cosw0 - coeff;

		  case HIGH_SHELF:   // H(s) = A * (A*s^2 + (sqrt(A)/Q)*s + 1)/(s^2 + (sqrt(A)/Q)*s + A)
			coeff = sinw0 * Math.sqrt( (A*A + 1)*(1/this.S - 1) + 2*A );
			this.b0 =    A*((A+1) + (A-1)*cosw0 + coeff);
			this.b1 = -2*A*((A-1) + (A+1)*cosw0);
			this.b2 =    A*((A+1) + (A-1)*cosw0 - coeff);
			this.a0 =       (A+1) - (A-1)*cosw0 + coeff;
			this.a1 =    2*((A-1) - (A+1)*cosw0);
			this.a2 =       (A+1) - (A-1)*cosw0 - coeff;
		}
	   
		this.b0a0 = this.b0/this.a0;
		this.b1a0 = this.b1/this.a0;
		this.b2a0 = this.b2/this.a0;
		this.a1a0 = this.a1/this.a0;
		this.a2a0 = this.a2/this.a0;
	  }

	public function process(buffer : FastFloatBuffer) {
		  //y[n] = (b0/a0)*x[n] + (b1/a0)*x[n-1] + (b2/a0)*x[n-2]
		  //       - (a1/a0)*y[n-1] - (a2/a0)*y[n-2]

		  var len = buffer.length;
		  var output = new FastFloatBuffer(len);

		  for ( i in 0...buffer.length) {
			output.set(i, this.b0a0 * buffer.get(i) + this.b1a0 * this.x_1_l + 
						this.b2a0*this.x_2_l - this.a1a0*this.y_1_l - this.a2a0*this.y_2_l);
			this.y_2_l = this.y_1_l;
			this.y_1_l = output.get(i);
			this.x_2_l = this.x_1_l;
			this.x_1_l = buffer.get(i);
		  }

		  return output;
	  }

	public function processStereo(buffer : FastFloatBuffer) {
		  //y[n] = (b0/a0)*x[n] + (b1/a0)*x[n-1] + (b2/a0)*x[n-2]
		  //       - (a1/a0)*y[n-1] - (a2/a0)*y[n-2]

		  var len = buffer.length;
		  var output = new FastFloatBuffer(len);
		 
		  for (i in 0...len>>1) {
			output.set(2 * i, this.b0a0 * buffer.get(2 * i) + this.b1a0 * this.x_1_l + 
							this.b2a0*this.x_2_l - this.a1a0*this.y_1_l - this.a2a0*this.y_2_l);
			this.y_2_l = this.y_1_l;
			this.y_1_l = output.get(2*i);
			this.x_2_l = this.x_1_l;
			this.x_1_l = buffer.get(2*i);

			output.set(2 * i + 1, this.b0a0 * buffer.get(2 * i + 1) + this.b1a0 * this.x_1_r + 
						this.b2a0*this.x_2_r - this.a1a0*this.y_1_r - this.a2a0*this.y_2_r);
			this.y_2_r = this.y_1_r;
			this.y_1_r = output.get(2*i+1);
			this.x_2_r = this.x_1_r;
			this.x_1_r = buffer.get(2*i+1);
		  }

		  return output;
	  }
	
}

