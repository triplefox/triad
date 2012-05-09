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

class RFFT extends FourierTransform
{
	
	public var trans : Vector<Float>;
	public var reverseTable : Vector<Int>;

	/**
	 * RFFT is a class for calculating the Discrete Fourier Transform of a signal
	 * with the Fast Fourier Transform algorithm.
	 *
	 * This method currently only contains a forward transform but is highly optimized.
	 *
	 * @param {Number} bufferSize The size of the sample buffer to be computed. Must be power of 2
	 * @param {Number} sampleRate The sampleRate of the buffer (eg. 44100)
	 *
	 * @constructor
	 */

	// lookup tables don't really gain us any speed, but they do increase
	// cache footprint, so don't use them in here

	// also we don't use sepearate arrays for real/imaginary parts

	// this one a little more than twice as fast as the one in FFT
	// however I only did the forward transform

	// the rest of this was translated from C, see http://www.jjj.de/fxt/
	// this is the real split radix FFT

	public function new(bufferSize, sampleRate) 
	{
		super(bufferSize, sampleRate);

		this.trans = new Vector<Float>(bufferSize);

		this.reverseTable = new Vector<Int>(bufferSize);
		generateReverseTable();
	}

	// don't use a lookup table to do the permute, use this instead
	public function reverseBinPermute(dest : Vector<Float> , source : Vector<Float>) 
	{
		var bufferSize  = this.bufferSize;
		var halfSize    = bufferSize >>> 1;
		var nm1         = bufferSize - 1;
		var i = 1;
		var r = 0;
		var h = 0;

		dest[0] = source[0];

		while (true)
		{
			r += halfSize;
			dest[i] = source[r];
			dest[r] = source[i];
		  
			i++;

			h = halfSize << 1;
			h = h >> 1;
			r ^= h;
			while ((r & h) == 0) { r ^= h;  h = h >> 1; }
			
			if (r >= i) { 
				dest[i]     = source[r]; 
				dest[r]     = source[i];

				dest[nm1-i] = source[nm1-r]; 
				dest[nm1-r] = source[nm1-i];
			}
			i++;
			if (i >= halfSize) break;
		}
		dest[nm1] = source[nm1];
	}

	public function generateReverseTable()
	{
		var bufferSize  = this.bufferSize, 
		halfSize    = bufferSize >>> 1, 
		nm1         = bufferSize - 1, 
		i = 1, r = 0, h;

		this.reverseTable[0] = 0;

		while (true) 
		{
			r += halfSize;
  
			this.reverseTable[i] = r;
			this.reverseTable[r] = i;

			i++;

			h = halfSize << 1;
			h = h >> 1;
			r ^= h;
			while ((r & h) == 0) { r ^= h;  h = h >> 1; }

			if (r >= i) { 
				this.reverseTable[i] = r;
				this.reverseTable[r] = i;
	
				this.reverseTable[nm1-i] = nm1-r;
				this.reverseTable[nm1-r] = nm1-i;
			}
			i++;
			if (i >= halfSize) break;
		}

		this.reverseTable[nm1] = nm1;
	}
	
	// Ordering of output:
	//
	// trans[0]     = re[0] (==zero frequency, purely real)
	// trans[1]     = re[1]
	//             ...
	// trans[n/2-1] = re[n/2-1]
	// trans[n/2]   = re[n/2]    (==nyquist frequency, purely real)
	//
	// trans[n/2+1] = im[n/2-1]
	// trans[n/2+2] = im[n/2-2]
	//             ...
	// trans[n-1]   = im[1] 

	public function forward(buffer : Vector<Float>) 
	{
		var n     = this.bufferSize;
		var spectrum  = this.spectrum;
		var x         = this.trans;
		var TWO_PI    = 2 * Math.PI;
		var sqrt      = Math.sqrt;
		var i         = n >>> 1;
		var bSi       = 2 / n;
		var n2 = 0; var n4 = 0; var n8 = 0; var nn = 0;
		var t1 = 0.; var t2 = 0.; var t3 = 0.; var t4 = 0.; 
		var i1 = 0; var i2 = 0; var i3 = 0; var i4 = 0; var i5 = 0; var i6 = 0; var i7 = 0; var i8 = 0;
		var st1 = 0.; var cc1 = 0.; var ss1 = 0.; var cc3 = 0.; var ss3 = 0.;
		var e = 0.;
		var a = 0.;
		var rval = 0.; var ival = 0.; var mag = 0.;

		this.reverseBinPermute(x, buffer);

		/*
		var reverseTable = this.reverseTable;

		for (var k = 0, len = reverseTable.length; k < len; k++) {
		x[k] = buffer[reverseTable[k]];
		}
		*/
		
		var id = 4;
		var ix = 0;
		while(ix < n) 
		{
			var i0 = ix;
			while(i0 < n)
			{
				//sumdiff(x[i0], x[i0+1]); // {a, b}  <--| {a+b, a-b}
				st1 = x[i0] - x[i0+1];
				x[i0] += x[i0+1];
				x[i0 + 1] = st1;
				i0 += id;
			} 
			ix = 2 * (id - 1);
			id *= 4;
		}

		n2 = 2;
		nn = n >>> 1;

		nn = nn >>> 1;
		while (nn != 0) 
		{
			
			ix = 0;
			n2 = n2 << 1;
			id = n2 << 1;
			n4 = n2 >>> 2;
			n8 = n2 >>> 3;
			while (true)
			{
				if (n4 != 1) 
				{
					var i0 = ix;
					while(i0 < n) 
					{
						i1 = i0;
						i2 = i1 + n4;
						i3 = i2 + n4;
						i4 = i3 + n4;
	 
						//diffsum3_r(x[i3], x[i4], t1); // {a, b, s} <--| {a, b-a, a+b}
						t1 = x[i3] + x[i4];
						x[i4] -= x[i3];
						//sumdiff3(x[i1], t1, x[i3]);   // {a, b, d} <--| {a+b, b, a-b}
						x[i3] = x[i1] - t1; 
						x[i1] += t1;

						i1 += n8;
						i2 += n8;
						i3 += n8;
						i4 += n8;

						//sumdiff(x[i3], x[i4], t1, t2); // {s, d}  <--| {a+b, a-b}
						t1 = x[i3] + x[i4];
						t2 = x[i3] - x[i4];

						t1 = -t1 * DSP.SQRT1_2;
						t2 *= DSP.SQRT1_2;

						// sumdiff(t1, x[i2], x[i4], x[i3]); // {s, d}  <--| {a+b, a-b}
						st1 = x[i2];
						x[i4] = t1 + st1; 
						x[i3] = t1 - st1;

						//sumdiff3(x[i1], t2, x[i2]); // {a, b, d} <--| {a+b, b, a-b}
						x[i2] = x[i1] - t2;
						x[i1] += t2;
						
						i0 += id;
					}
				} else 
				{
					var i0 = ix;
					while (i0 < n) 
					{
						i1 = i0;
						i2 = i1 + n4;
						i3 = i2 + n4;
						i4 = i3 + n4;

						//diffsum3_r(x[i3], x[i4], t1); // {a, b, s} <--| {a, b-a, a+b}
						t1 = x[i3] + x[i4]; 
						x[i4] -= x[i3];

						//sumdiff3(x[i1], t1, x[i3]);   // {a, b, d} <--| {a+b, b, a-b}
						x[i3] = x[i1] - t1; 
						x[i1] += t1;
						
						i0 += id;
					}
				}

				ix = (id << 1) - n2;
				id = id << 2;
				if (ix >= n) break;
				
			}

			e = TWO_PI / n2;

			for (j in 1...n8) 
			{
				a = j * e;
				ss1 = Math.sin(a);
				cc1 = Math.cos(a);

				//ss3 = sin(3*a); cc3 = cos(3*a);
				cc3 = 4*cc1*(cc1*cc1-0.75);
				ss3 = 4*ss1*(0.75-ss1*ss1);

				ix = 0; id = n2 << 1;
				while (true)
				{
					var i0 = ix;
					while (i0 < n) 
					{
						i1 = i0 + j;
						i2 = i1 + n4;
						i3 = i2 + n4;
						i4 = i3 + n4;

						i5 = i0 + n4 - j;
						i6 = i5 + n4;
						i7 = i6 + n4;
						i8 = i7 + n4;

						//cmult(c, s, x, y, &u, &v)
						//cmult(cc1, ss1, x[i7], x[i3], t2, t1); // {u,v} <--| {x*c-y*s, x*s+y*c}
						t2 = x[i7]*cc1 - x[i3]*ss1; 
						t1 = x[i7]*ss1 + x[i3]*cc1;

						//cmult(cc3, ss3, x[i8], x[i4], t4, t3);
						t4 = x[i8]*cc3 - x[i4]*ss3; 
						t3 = x[i8]*ss3 + x[i4]*cc3;

						//sumdiff(t2, t4);   // {a, b} <--| {a+b, a-b}
						st1 = t2 - t4;
						t2 += t4;
						t4 = st1;

						//sumdiff(t2, x[i6], x[i8], x[i3]); // {s, d}  <--| {a+b, a-b}
						//st1 = x[i6]; x[i8] = t2 + st1; x[i3] = t2 - st1;
						x[i8] = t2 + x[i6]; 
						x[i3] = t2 - x[i6];

						//sumdiff_r(t1, t3); // {a, b} <--| {a+b, b-a}
						st1 = t3 - t1;
						t1 += t3;
						t3 = st1;

						//sumdiff(t3, x[i2], x[i4], x[i7]); // {s, d}  <--| {a+b, a-b}
						//st1 = x[i2]; x[i4] = t3 + st1; x[i7] = t3 - st1;
						x[i4] = t3 + x[i2]; 
						x[i7] = t3 - x[i2];

						//sumdiff3(x[i1], t1, x[i6]);   // {a, b, d} <--| {a+b, b, a-b}
						x[i6] = x[i1] - t1; 
						x[i1] += t1;

						//diffsum3_r(t4, x[i5], x[i2]); // {a, b, s} <--| {a, b-a, a+b}
						x[i2] = t4 + x[i5]; 
						x[i5] -= t4;
						
						i0 += id;
					}
			 
					ix = (id << 1) - n2;
					id = id << 2;

					if (ix >= n) break;
				}
			}	
			nn = nn >>> 1;
		}
		
		i--;
		while (i!=0) 
		{
			rval = x[i];
			ival = x[n-i-1];
			mag = bSi * sqrt(rval * rval + ival * ival);

			if (mag > this.peak) {
			  this.peakBand = i;
			  this.peak = mag;
			}

			spectrum[i] = mag;
			i--;
		}

		spectrum[0] = bSi * x[0];

		return spectrum;
	}

}	
