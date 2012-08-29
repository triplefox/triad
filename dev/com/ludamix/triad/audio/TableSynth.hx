package com.ludamix.triad.audio;

import com.ludamix.triad.tools.FastFloatBuffer;
import com.ludamix.triad.audio.Sequencer;
import com.ludamix.triad.audio.Envelope;
import com.ludamix.triad.audio.VoiceCommon;
import com.ludamix.triad.math.LFSR;
import com.ludamix.triad.tools.FloatPlayhead;

typedef TSAssign = Int;

typedef TableSynthPatch = {
	envelope_profiles : Array<EnvelopeProfile>,
	lfos : Array<LFO>,
	oscillator : Int,
	modulation_lfo : Float, // applies to LFO1, depth multiplier if greater than 0
	arpeggiation_rate : Float, // 0 = off, hz value
	base_pulsewidth : Float,
};

class TableSynth implements SoftSynth
{
	
	public var common : VoiceCommon;
	
	public var playhead : FloatPlayhead;
	
	public static inline var ATTACK = 0;
	public static inline var SUSTAIN = 1;
	public static inline var RELEASE = 2;
	public static inline var OFF = 3;
	
	// naive oscillators
	public static inline var PULSE = 0;
	public static inline var SAW = 1;
	public static inline var TRI = 2;
	public static inline var SIN = 3;
	// wavetable oscillators
	public static inline var PULSE_WT = 4;
	public static inline var SAW_WT = 5;
	public static inline var TRI_WT = 6;
	
	public static inline var AS_PITCH_ADD = 0;
	public static inline var AS_PITCH_MUL = 1;
	public static inline var AS_VOLUME_ADD = 2;
	public static inline var AS_VOLUME_MUL = 3;
	public static inline var AS_PULSEWIDTH = 4;
	
	// heuristic to ramp down priority when releasing
	public static inline var PRIORITY_RAMPDOWN = 0.95;
	// and ramp up priority when sustaining
	public static inline var PRIORITY_RAMPUP = 1;
	
	public function new()
	{
		common = new VoiceCommon();
		playhead = new FloatPlayhead();
		
		//if (pulseWavetable == null) genPulseWT();
		//if (sawWavetable == null) genSawWT();
		//if (triWavetable == null) genTriWT();
	}
	
	public static function generatorOf(settings : TableSynthPatch)
	{
		return new PatchGenerator(settings, function(settings,seq, ev) { return [new PatchEvent(ev, settings) ]; } );
	}
	
	public static function defaultPatch(seq : Sequencer) : TableSynthPatch
	{
		var lfos : Array<LFO> = [ { frequency:6., depth:0.5, delay:0.05, attack:0.05, assigns:[AS_PITCH_ADD] },
			{ frequency:1.7, depth:1., delay:0., attack:0., assigns:[AS_PULSEWIDTH] }];
		return { envelope_profiles:[Envelope.ADSR(seq.secondsToFrames, 0.01, 0.4, 0.5, 0.01, [AS_VOLUME_ADD])],
				oscillator:SAW_WT,
				lfos : lfos,
				modulation_lfo:1.0,
				arpeggiation_rate:0.0,
				base_pulsewidth:0.
				}
				;
	}
	
	public static inline function alg_window(i : Float, wl : Float)
	{
		// phase distortion windowing function.
		return (wl-(i%wl))/wl;
	}
	
	public static inline function alg_free(i : Float, wl : Float)
	{
		// free-running frequency. (compare to alg_window)
		return i/wl;
	}
	
	public static inline var TABLE_START = 512; // roughly, the accuracy of our lowest regular note
												 // 44100*TABLE_OVERSAMPLE/TABLE_START = the bassiest frequency in hz
	public static inline var TABLE_PITCHES = 48;// num of unique pitches sampled between table start and end
    public static function tableMapping(i : Float) : Float {return Math.pow(i, 6);} // biases the pitches we sample from 
	public static inline var TABLE_MODULATIONS = 6; // number of unique modulations sampled per pitch
	public static inline var TABLE_OVERSAMPLE = 1; // determines which table is chosen at runtime. 
		// Using tables oversampled brings out the highs more prominently, but puts more pressure on resampling accuracy,
		// and makes the lows "run out" much faster.
	public static inline var TABLE_END = 16; // below this wavelength we stop extending the table.
		// if set too low, high-pitched samples start to contain no power (which screws up the gain controller)
		// 		- or worse, they contain so little power that numeric error occurs.
		// and all the other factors may affect when a no-power sample occurs - jitter them if it breaks.
		// a higher value helps us gain pitch accuracy by reducing the territory each sample has to cover,
		// but hurts accuracy after the table end.
	public static inline var SINE_START = 10; // replace table with sinewave
    public static inline var MAX_OCTAVES = 128; // essentially, how many passes per sample
	
	public static var pulseWavetable : Array<Array<FastFloatBuffer>>;
	public static var sawWavetable : Array<Array<FastFloatBuffer>>;
	public static var triWavetable : Array<Array<FastFloatBuffer>>;
	
	public static inline function normalizeWave(wave : FastFloatBuffer, tablesize : Int, infos : String)
	{
		var pow = 0.;
		for (i in 0...tablesize)
		{
			pow += Math.abs(wave.get(i) - wave.get(i+1));
		}
		if (pow == 0.) throw Std.string(tablesize)+" samples produced no power "+infos;
		var pow_mod = 4.0/pow; // power of a sine, measured by delta, is 2. We let our samples be a bit stronger.
		for (i in 0...tablesize+1)
		{
			wave.set(i, wave.get(i) * pow_mod);
		}
	}
	
	public static function genPulseWT()
	{
		// todo - gen with 2 extra samples on each side so that we can do 2x interp faster
		// 		  do something about the tiny tables - when they're so small runtime slows down due to excessive modulo
		
		pulseWavetable = new Array();
		for (o in 0...TABLE_PITCHES)
		{
			var fn = tableMapping;
			var tablesize = Std.int(TABLE_END + (TABLE_START - TABLE_END) * fn(o) / fn(TABLE_PITCHES - 1));
			var modTable =  new Array();
			pulseWavetable.insert(0, modTable);
			for (m in 0...TABLE_MODULATIONS)
			{
				var wave = new FastFloatBuffer(tablesize+1); // pad with a sample so that linear interp works cleanly
				modTable.push(wave);
				
				// derived from wikipedia entry
				
				var ts = Std.int(tablesize/ (o+1));
				var oo = 1;
				var pw = (1. - m / TABLE_MODULATIONS); // modulations control pulse width.
				pw = pw * 0.45 + 0.05; // two important things: we only need to sample half the range,
								 	   // and we don't want the very ends because power drops to zero.
				pw *= tablesize;
				var OTABLESIZE = 1. / tablesize;
				var half_pw = pw / 2;
				while (oo < MAX_OCTAVES) 
					// shrink effective table size until it's too tiny to bother with.
				{
					var oo_pi = oo * Math.PI;
					var oo_pi_otablesize = oo * Math.PI * OTABLESIZE;
					for (i in 0...tablesize+1)
					{
						wave.set(i, wave.get(i) + 2. / (oo_pi) * Math.sin(pw*oo_pi_otablesize) * 
							Math.cos(2 * (i - half_pw) * oo_pi_otablesize));
					}
					oo += 2;
				}
				normalizeWave(wave, tablesize, "pulse");
			}
			tablesize -= Std.int(TABLE_START / (TABLE_PITCHES+1));
		}
	}
	
	public static function genSawWT()
	{
		sawWavetable = new Array();
		for (o in 0...TABLE_PITCHES)
		{
			var fn = tableMapping;
			var tablesize = Std.int(TABLE_END + (TABLE_START - TABLE_END) * fn(o) / fn(TABLE_PITCHES - 1));
			var modTable =  new Array();
			sawWavetable.insert(0, modTable);
			for (m in 0...TABLE_MODULATIONS)
			{
				var wave = new FastFloatBuffer(tablesize+1); // pad with a sample so that linear interp works cleanly
				modTable.push(wave);
				
				// derived from wikipedia entry
				
				var ts = Std.int(tablesize/ (o+1));
				var oo = 1;
				var pw = Math.pow(m / (TABLE_MODULATIONS-1), 0.5) * 125; // filtering effect
				var sign = -1;
				var OTABLESIZE = 1. / tablesize;
				while (oo < MAX_OCTAVES - pw) 
					// shrink effective table size until it's too tiny to bother with.
				{
					var div_factor = 1. / (oo);
					for (i in 0...tablesize+1)
					{
						wave.set(i, wave.get(i) + Math.sin((i*Math.PI*2*OTABLESIZE)*oo) * sign * div_factor);
					}
					sign = -sign;
					oo += 1;
				}
				normalizeWave(wave, tablesize, "saw");
			}
		}		
	}
	
	public static function genTriWT()
	{
		triWavetable = new Array();
		for (o in 0...TABLE_PITCHES)
		{
			var fn = tableMapping;
			var tablesize = Std.int(TABLE_END + (TABLE_START - TABLE_END) * fn(o) / fn(TABLE_PITCHES - 1));
			var modTable =  new Array();
			triWavetable.insert(0, modTable);
			for (m in 0...TABLE_MODULATIONS)
			{
				var wave = new FastFloatBuffer(tablesize+1); // pad with a sample so that linear interp works cleanly
				modTable.push(wave);
				
				// derived from wikipedia entry
				
				var ts = Std.int(tablesize/ (o+1));
				var oo = m/TABLE_MODULATIONS * 0.1; // pulsewidth adds a fairly dramatic, FM-like waveshaping effect
				var sign = -1;
				var OTABLESIZE = 1. / tablesize;
				while (oo < MAX_OCTAVES) 
					// shrink effective table size until it's too tiny to bother with.
				{
					var twokplus1overtablesize = (2*oo+1)/(tablesize>>4);
					var one_over_twokplus1_sq = 1. / ((2 * oo + 1) * (2 * oo + 1));
					for (i in 0...tablesize+1)
					{
						wave.set(i, wave.get(i) + Math.sin(twokplus1overtablesize*i) * sign * one_over_twokplus1_sq);
					}
					sign = -sign;
					oo += 1;
				}
				normalizeWave(wave, tablesize, "tri");
			}
		}		
	}
	
	public inline function write()
	{	
		return common.updateFollowers(progress_follower);
	}
	
	public function progress_follower(infos : VoiceFrameInfos, cur_follower : EventFollower, ?write : Bool)
	{
		
		var freq = infos.frequency;
		var wl = Std.int(infos.wavelength);
		var left = infos.volume_left;
		var right = infos.volume_right;
		
		var patch = cur_follower.patch_event.patch;
		var buffer = common.buffer;
		var vol = (left + right) / 2;
		
		playhead.wl = Std.int(wl);
		
		var frame_pulsewidth = 0.;
		var hw = wl/2;
			
		var pos = playhead.getSamplePos();
		buffer.playhead = 0;
		
		switch(patch.oscillator)
		{
			case PULSE: // naive, run at half rate
				for (i in 0 ... buffer.length >> 2) {
					if (pos % wl < hw)
					{
						buffer.add(left); buffer.advancePlayheadUnbounded();
						buffer.add(right); buffer.advancePlayheadUnbounded();
						buffer.add(left); buffer.advancePlayheadUnbounded();
						buffer.add(right); buffer.advancePlayheadUnbounded();
					}
					else
					{
						buffer.add(-left); buffer.advancePlayheadUnbounded();
						buffer.add(-right); buffer.advancePlayheadUnbounded();
						buffer.add(-left); buffer.advancePlayheadUnbounded();
						buffer.add(-right); buffer.advancePlayheadUnbounded();
					}
					pos = (pos+4) % wl;
				}
			case SAW: // naive, run at half rate
				var peak = vol * 2;
				var one_over_wl = peak / wl;
				for (i in 0 ... buffer.length >> 2) 
				{
					var sum = ((wl - (pos << 1)) % wl) * one_over_wl;
					var l = sum * left;
					var r = sum * right;
					buffer.add(l); buffer.advancePlayheadUnbounded();
					buffer.add(r); buffer.advancePlayheadUnbounded();
					buffer.add(l); buffer.advancePlayheadUnbounded();
					buffer.add(r); buffer.advancePlayheadUnbounded();
					pos = (pos+4) % wl;
				}
			case TRI: // naive, run at full rate
				var peak = vol;
				var one_over_wl = 2. / wl;
				var h = wl >> 1;
				for (i in 0 ... buffer.length >> 1) 
				{
					var sum = (-((pos + h) << 1)% wl) * one_over_wl;
					if (pos >= h)
						sum = -sum - 1;
					else
						sum += 1;
					buffer.add(sum * left); buffer.advancePlayheadUnbounded();
					buffer.add(sum * right); buffer.advancePlayheadUnbounded();
					pos = (pos+2) % wl;
				}
			case SIN: // using Math.sin()
				var adjust = 2 * Math.PI / wl;
				left *= 0.3;
				right *= 0.3;
				for (i in 0 ... buffer.length >> 1) 
				{
					var sum = Math.sin(pos * adjust);
					buffer.add(sum * left); buffer.advancePlayheadUnbounded();
					buffer.add(sum * right); buffer.advancePlayheadUnbounded();
					pos = (pos+2) % wl;
				}
			case PULSE_WT: pos = runWavetable(buffer, pulseWavetable, wl, hw, pos, left, right);
			case SAW_WT: pos = runWavetable(buffer, sawWavetable, wl, hw, pos, left, right);
			case TRI_WT: pos = runWavetable(buffer, triWavetable, wl, hw, pos, left, right);
		}
		
		playhead.setSamplePos(pos);
		
		// Priority calculations.
		
		var ct = 0;
		var master = cur_follower.env[0];
		
		if (!master.isOff())
		{
			if (master.sustaining()) // encourage sustains to be retained
				cur_follower.patch_event.sequencer_event.priority += PRIORITY_RAMPUP;
		}
		if (master.releasing()) // ramp down on release
		{
			cur_follower.patch_event.sequencer_event.priority = 
				Std.int(cur_follower.patch_event.sequencer_event.priority * PRIORITY_RAMPDOWN);
		}
		
	}
	
	public inline function runWavetable(buffer : FastFloatBuffer,
		table : Array<Array<FastFloatBuffer>>, wl : Int, hw : Float,
		pos : Int, 
		left : Float, right : Float)
	{
		var oct = 0;
		var base_wl : Float = table[oct][0].length - 1;
		var test_wl = wl * TABLE_OVERSAMPLE;
		// we try to pick the nearest wavelength, starting from the biggest one and working downwards.
		while (test_wl < base_wl && oct < table.length-1)
		{
			oct += 1;
			base_wl = table[oct][0].length - 1;
		}
		if (oct>0 && Math.abs(test_wl - table[oct-1][0].length)<Math.abs(test_wl - base_wl)) 
			{ oct--; base_wl = table[oct][0].length - 1; } // correct overshoot
		var di = 0.;
		if (test_wl > base_wl) di = Math.abs(test_wl / base_wl);
		else di = Math.abs(base_wl / test_wl);
		if (test_wl < SINE_START)
		{
			pos = pos % wl;
			var adjust = Math.PI*2 / wl;
			for (i in 0 ... buffer.length >> 1) 
			{
				var sum = Math.sin(pos * adjust);
				buffer.add(sum * left); buffer.advancePlayheadUnbounded();
				buffer.add(sum * right); buffer.advancePlayheadUnbounded();
				pos = (pos+2) % wl;
			}		
		}
		else // regular linear
		{
			var pwi = Std.int(hw / wl * TABLE_MODULATIONS);
			if (pwi < 0) pwi = Std.int(Math.abs(pwi)); 
			if (pwi >= TABLE_MODULATIONS) pwi = TABLE_MODULATIONS - 1;
			var wave = table[oct][pwi];
			var adjust = base_wl / wl;
			
			buffer.playhead = 0;
			wave.playhead = pos;
			wave.playback_rate = 1;
			
			for (i in 0 ... buffer.length >> 1) 
			{
				var pa = pos * adjust;
				var spa = Std.int(pa);
				var dist = pa - spa;
				wave.playhead = spa;
				var l = wave.read();
				var r = wave.read();
				var sum = (l * (dist) + r * (1. - dist));
				buffer.add(sum * left);
				buffer.advancePlayheadUnbounded();
				buffer.add(sum * right);
				buffer.advancePlayheadUnbounded();
				pos = (pos + 2) % wl;
			}		
		}
		return pos;
	}
	
}
