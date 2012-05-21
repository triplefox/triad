package com.ludamix.triad.audio;

import com.ludamix.triad.tools.FastFloatBuffer;
import com.ludamix.triad.audio.Sequencer;
import com.ludamix.triad.math.LFSR;

typedef TSAssign = Int;

typedef TableSynthPatch = {
	envelopes : Array<Envelope>,
	lfos : Array<LFO>,
	oscillator : Int,
	modulation_lfo : Float, // applies to LFO1, depth multiplier if greater than 0
	arpeggiation_rate : Float, // 0 = off, hz value
	base_pulsewidth : Float,
};

class TableSynth implements SoftSynth
{
	
	public var buffer : FastFloatBuffer;
	public var followers : Array<EventFollower>;
	public var sequencer : Sequencer;
	
	public var freq : Float;
	public var pos : Int;
	public var bufptr : Int;
	
	public var master_volume : Float;
	public var velocity : Float;
	
	public var arpeggio : Float;
	
	public var frame_pitch_adjust : Float;
	public var frame_vol_adjust : Float;
	public var frame_pulsewidth : Float;
	
	public var lfsr : LFSR;
	public var lfsr_pos : Int;
	public var lfsr_wavelength : Int;
	
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
	// (experimental)
	// phase distortion-based ( cosine * cosine with optional windowing envelope on both)
	public static inline var PD_WINDOW_WINDOW = 100;
	// fm-based
	public static inline var FM_2OP = 101;
	
	public static inline var LFSR_2 = 202;
	public static inline var LFSR_3 = 203;
	public static inline var LFSR_4 = 204;
	public static inline var LFSR_5 = 205;
	public static inline var LFSR_6 = 206;
	public static inline var LFSR_7 = 207;
	public static inline var LFSR_8 = 208;
	public static inline var LFSR_9 = 209;
	public static inline var LFSR_10 = 210;
	public static inline var LFSR_11 = 211;
	public static inline var LFSR_12 = 212;
	public static inline var LFSR_13 = 213;
	public static inline var LFSR_14 = 214;
	public static inline var LFSR_15 = 215;
	public static inline var LFSR_16 = 216;
	public static inline var LFSR_17 = 217;
	public static inline var LFSR_18 = 218;
	public static inline var LFSR_19 = 219;
	
	public static inline var AS_PITCH_ADD = 0;
	public static inline var AS_PITCH_MUL = 1;
	public static inline var AS_VOLUME_ADD = 2;
	public static inline var AS_VOLUME_MUL = 3;
	public static inline var AS_PULSEWIDTH = 4;
	
	// heuristic to ramp down priority when releasing
	public static inline var PRIORITY_RAMPDOWN = 0.95;
	// and ramp up priority when sustaining
	public static inline var PRIORITY_RAMPUP = 1;
	// and ramp down priority this much each time a new voice is added to the channel
	public static inline var PRIORITY_VOICE = 0.95;
	
	public function new()
	{
		freq = 440.;
		pos = 0;
		bufptr = 0;
		master_volume = 0.1;
		velocity = 1.0;
		arpeggio = 0.;
		lfsr_wavelength = 16;
		lfsr_pos = Std.int(Math.random() * lfsr_wavelength);
	}
	
	public static function generatorOf(settings : TableSynthPatch)
	{
		return new PatchGenerator(settings, function(settings,seq, ev) { return [new PatchEvent(ev, settings) ]; } );
	}
	
	public static function defaultPatch(seq : Sequencer) : TableSynthPatch
	{
		var adsr_base = SynthTools.interpretADSR(seq.secondsToFrames, 0.01, 0.4, 0.5, 0.01, SynthTools.CURVE_POW,
			SynthTools.CURVE_POW, SynthTools.CURVE_POW, false);
		var envs : Array<Envelope> = [ { attack:adsr_base.attack, sustain:adsr_base.sustain, release:adsr_base.release, assigns:[AS_VOLUME_ADD],
							quantization:0 } ];
		var lfos : Array<LFO> = [ { frequency:6., depth:0.5, delay:0.05, attack:0.05, assigns:[AS_PITCH_ADD] },
			{ frequency:1.7, depth:1., delay:0., attack:0., assigns:[AS_PULSEWIDTH] }];
		return { envelopes:envs,
				oscillator:SAW_WT,
				lfos : lfos,
				modulation_lfo:1.0,
				arpeggiation_rate:0.0,
				base_pulsewidth:0.
				}
				;
	}
	
	public function init(sequencer)
	{
		this.sequencer = sequencer;
		this.buffer = sequencer.buffer;
		this.followers = new Array();
		this.lfsr = new LFSR();
		
		if (pulseWavetable == null) genPulseWT();
		if (sawWavetable == null) genSawWT();
		if (triWavetable == null) genTriWT();
		
	}
	
	public inline function pipeAdjustment(qty : Float, assigns : Array<Int>)
	{
		for (assign in assigns)
		{
			switch(assign)
			{
				case AS_PITCH_ADD: frame_pitch_adjust += qty;
				case AS_PITCH_MUL: frame_pitch_adjust *= qty;
				case AS_VOLUME_ADD: frame_vol_adjust += qty;
				case AS_VOLUME_MUL: frame_vol_adjust *= qty;
				case AS_PULSEWIDTH: frame_pulsewidth += qty;
			}
		}
	}
	
	public inline function updateEnvelope(patch : TableSynthPatch, channel : SequencerChannel, cur_follower : EventFollower)
	{
		var env_num = 0;
		for (env in cur_follower.env)
		{
			if (env.state < 3)
			{
				var patch_env = patch.envelopes[env_num];
				var env_val = 0.;
				env_val = env.getTable(patch_env)[env.ptr];
				if (patch_env.quantization != 0)
					env_val = (Math.round(env_val * patch_env.quantization) / patch_env.quantization);	
				pipeAdjustment(env_val, patch_env.assigns);
			}
			env_num++;
		}		
	}
	
	public inline function updateLFO(patch : TableSynthPatch, channel : SequencerChannel, cur_follower : EventFollower)
	{
		var lfo_num = 0;
		for (n in patch.lfos)
		{
			var cycle_length = sequencer.secondsToFrames(1. / n.frequency);
			var delay_length = sequencer.secondsToFrames(n.delay);
			var attack_length = sequencer.secondsToFrames(n.attack);
			var modulation_amount = (lfo_num == 0 && patch.modulation_lfo > 0) ? 
				patch.modulation_lfo * channel.modulation : 1.0;
			var mpos = cur_follower.lfo_pos - delay_length;
			if (mpos > 0)
			{
				if (mpos > attack_length)
				{
					pipeAdjustment(Math.sin(2 * Math.PI * mpos / cycle_length) * n.depth * modulation_amount, n.assigns);
				}
				else // ramp up
				{
					pipeAdjustment(Math.sin(2 * Math.PI * mpos / cycle_length) * modulation_amount * 
						(n.depth * (mpos/attack_length)), n.assigns);
				}
			}
			lfo_num++;
		}
		cur_follower.lfo_pos += 1;
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
    public static inline var DOUBLE_INTERPOLATE = 2; // start using 2x interpolation at this ratio of frequency diff
	
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
	
	public function write()
	{	
		while (followers.length > 0 && followers[followers.length - 1].isOff()) followers.pop();
		if (followers.length < 1) { pos = 0; return false; }
		
		var cur_follower : EventFollower = followers[followers.length - 1];		
		var cur_channel = sequencer.channels[cur_follower.patch_event.sequencer_event.channel];
		var patch : TableSynthPatch = cur_follower.patch_event.patch;
		if (patch.arpeggiation_rate>0.0)
		{
			var available = Lambda.array(Lambda.filter(followers, function(a) { return !a.isOff(); } ));
			cur_follower = available[Std.int(((arpeggio) % 1) * available.length)];
			cur_channel = sequencer.channels[cur_follower.patch_event.sequencer_event.channel];
			patch = cur_follower.patch_event.patch;
			arpeggio += sequencer.secondsToFrames(1.0) / (patch.arpeggiation_rate);
		}
		var pitch_bend = cur_channel.pitch_bend;
		var channel_volume = cur_channel.channel_volume;
		var pan = cur_channel.pan;
		
		var seq_event = cur_follower.patch_event.sequencer_event;
		
		frame_pitch_adjust = 0.;
		frame_vol_adjust = 0.;
		frame_pulsewidth = patch.base_pulsewidth;
		
		updateLFO(patch, cur_channel, cur_follower);
		updateEnvelope(patch, cur_channel, cur_follower);
		
		freq = Std.int(seq_event.data.freq);
		
		var wl = Std.int(sequencer.waveLengthOfBentFrequency(freq, 
					pitch_bend + Std.int(frame_pitch_adjust * 8192 / sequencer.tuning.bend_semitones)));
		if (wl < 1) wl = 1;
		
		velocity = seq_event.data.velocity / 128;
		
		if (cur_follower.env[0].state == RELEASE) // apply the release envelope on top of the release level
			frame_vol_adjust *= cur_follower.release_level;
		var curval = master_volume * channel_volume * cur_channel.velocityCurve(velocity) * 
			frame_vol_adjust;
		
		frame_pulsewidth = frame_pulsewidth % 2.0;
		var hw : Int;
		if (frame_pulsewidth > 1.0) 
			hw = Std.int(wl * (1.0 - (frame_pulsewidth%1.0)));
		else
			hw = Std.int(wl * frame_pulsewidth);
		
		switch(patch.oscillator)
		{
			case PULSE: // naive, run at half rate
				var left = curval * pan * 2;
				var right = curval * (1.-pan) * 2;
				for (i in 0 ... buffer.length >> 2) {
					if (pos % wl < hw)
					{
						buffer.set(bufptr, buffer.get(bufptr)+left);
						buffer.set(bufptr+1, buffer.get(bufptr+1)+right);
						buffer.set(bufptr+2, buffer.get(bufptr+2)+left);
						buffer.set(bufptr+3, buffer.get(bufptr+3)+right);
					}
					else
					{
						buffer.set(bufptr, buffer.get(bufptr)-left);
						buffer.set(bufptr+1, buffer.get(bufptr+1)-right);
						buffer.set(bufptr+2, buffer.get(bufptr+2)-left);
						buffer.set(bufptr+3, buffer.get(bufptr+3)-right);
					}
					pos = (pos+4) % wl;
					bufptr = (bufptr+4) % buffer.length;
				}
			case SAW: // naive, run at half rate
				var peak = curval * 2;
				var one_over_wl = peak / wl;
				var left = pan * 2;
				var right = (1.-pan) * 2;
				for (i in 0 ... buffer.length >> 2) 
				{
					var sum = ((wl-(pos<<1)) % wl) * one_over_wl;
					buffer.set(bufptr, buffer.get(bufptr) + sum * left);
					buffer.set(bufptr, buffer.get(bufptr+1) + sum * right);
					buffer.set(bufptr, buffer.get(bufptr+2) + sum * left);
					buffer.set(bufptr, buffer.get(bufptr+3) + sum * right);
					pos = (pos+4) % wl;
					bufptr = (bufptr+4) % buffer.length;
				}
			case TRI: // naive, run at full rate
				var peak = curval;
				var one_over_wl = 2. / wl;
				var left = pan * peak;
				var right = (1. -pan) * peak;
				var h = wl >> 1;
				for (i in 0 ... buffer.length >> 1) 
				{
					var sum = (-((pos + h) << 1)% wl) * one_over_wl;
					if (pos >= h)
						sum = -sum - 1;
					else
						sum += 1;
					buffer.set(bufptr, buffer.get(bufptr)+sum * left);
					buffer.set(bufptr+1, buffer.get(bufptr+1)+sum * right);
					pos = (pos+2) % wl;
					bufptr = (bufptr+2) % buffer.length;
				}
			case SIN: // using Math.sin()
				var peak = curval * 0.3;
				var adjust = 2 * Math.PI / wl;
				var left = pan * 2;
				var right = (1.-pan) * 2;
				for (i in 0 ... buffer.length >> 1) 
				{
					var sum = peak * Math.sin(pos * adjust);
					buffer.set(bufptr, buffer.get(bufptr)+sum * left);
					buffer.set(bufptr+1, buffer.get(bufptr+1)+sum * right);
					pos = (pos+2) % wl;
					bufptr = (bufptr+2) % buffer.length;
				}
			case PULSE_WT: runWavetable(pulseWavetable, curval, wl, hw, pan);
			case SAW_WT: runWavetable(sawWavetable, curval, wl, hw, pan);
			case TRI_WT: runWavetable(triWavetable, curval, wl, hw, pan);
			case PD_WINDOW_WINDOW:
				/*
				 * 	
				var outer_a = 1.0;
				var outer_b = 0.5;
				var inner_a = 1.0;
				var inner_b = 1.0;
				var inner_c = 0.125;
				*/
				var outer_a = 0.5 + frame_pulsewidth;
				var outer_b = 0.5;
				var inner_a = 1.0 + frame_pulsewidth;
				var inner_b = 3.0;
				var inner_c = 0.1 + frame_pulsewidth;
				
				var peak = curval * 2;
				var left = pan * peak;
				var right = (1. -pan) * peak;
				
				for (i in 0 ... buffer.length >> 1) 
				{
					var sum = Math.cos(alg_window(pos * outer_a, wl * outer_b) * Math.PI * 2 * 
								Math.cos(alg_window(pos * inner_a, wl * inner_b) * inner_c * Math.PI * 2));								
					buffer.set(bufptr, buffer.get(bufptr)+sum * left);
					buffer.set(bufptr+1, buffer.get(bufptr+1)+sum * right);
					pos = (pos+2) % wl;
					bufptr = (bufptr+2) % buffer.length;
				}
			case FM_2OP:
				
				var peak = curval * 2;
				var adjust = 2 * Math.PI / wl;
				var left = pan * peak;
				var right = (1. -pan) * peak;
				for (i in 0 ... buffer.length >> 1) 
				{
					var pa = pos * adjust;
					var sum = Math.cos(pa * (1+Math.cos((frame_pulsewidth*0.2+peak)*Math.PI)));
					buffer.set(bufptr, buffer.get(bufptr)+sum * left);
					buffer.set(bufptr+1, buffer.get(bufptr+1)+sum * right);
					pos = (pos+2) % wl;
					bufptr = (bufptr+2) % buffer.length;
				}
			case LFSR_2: runLfsr(curval, pan, wl, hw, 2);
			case LFSR_3: runLfsr(curval, pan, wl, hw, 3);
			case LFSR_4: runLfsr(curval, pan, wl, hw, 4);
			case LFSR_5: runLfsr(curval, pan, wl, hw, 5);
			case LFSR_6: runLfsr(curval, pan, wl, hw, 6);
			case LFSR_7: runLfsr(curval, pan, wl, hw, 7);
			case LFSR_8: runLfsr(curval, pan, wl, hw, 8);
			case LFSR_9: runLfsr(curval, pan, wl, hw, 9);
			case LFSR_10: runLfsr(curval, pan, wl, hw, 10);
			case LFSR_11: runLfsr(curval, pan, wl, hw, 11);
			case LFSR_12: runLfsr(curval, pan, wl, hw, 12);
			case LFSR_13: runLfsr(curval, pan, wl, hw, 13);
			case LFSR_14: runLfsr(curval, pan, wl, hw, 14);
			case LFSR_15: runLfsr(curval, pan, wl, hw, 15);
			case LFSR_16: runLfsr(curval, pan, wl, hw, 16);
			case LFSR_17: runLfsr(curval, pan, wl, hw, 17);
			case LFSR_18: runLfsr(curval, pan, wl, hw, 18);
			case LFSR_19: runLfsr(curval, pan, wl, hw, 19);
		}
		
		for (ev in followers)
		{
			// Advance each envelope of each follower one step.
			
			var idx = 0;
			for (env in ev.env)
			{
				env.ptr++;
				var cur_env : Array<Float> = null;
				if (env.state == SUSTAIN)
				{
					if (idx == 0)
						cur_follower.patch_event.sequencer_event.priority += PRIORITY_RAMPUP;
					cur_env = patch.envelopes[idx].sustain;
				}
				else if (env.state==ATTACK)
					cur_env = patch.envelopes[idx].attack;
				else if (env.state == RELEASE)
				{
					if (idx == 0)
						cur_follower.patch_event.sequencer_event.priority = 
							Std.int(cur_follower.patch_event.sequencer_event.priority * PRIORITY_RAMPDOWN);
					cur_env = patch.envelopes[idx].release;
				}
				if (env.state < RELEASE && idx == 0) // release is tied to master env
				{
					cur_follower.release_level = frame_vol_adjust;
				}
				if (env.state!=OFF && env.ptr >= cur_env.length)
				{
					if (env.state != SUSTAIN)
						{env.state += 1; }
					env.ptr = 0;
				}
				idx++;
			}
			
		}
		return true;
	}
	
	public inline function runLfsr(curval : Float, pan : Float, wl : Int, hw : Int, taps : Int)
	{
		var peak = curval * 0.3;
		var left = pan * 2;
		var right = (1. -pan) * 2;
		var pw = hw / wl;
		hw = Std.int(wl * 0.5);
		var gen_level = 1. - (pw * 0.5);
		var gen = lfsr.noiseThresh(taps, gen_level);
		var gl = gen * left;
		var gr = gen * right;
		for (i in 0 ... buffer.length >> 2) 
		{
			if (pos % wl < hw)
			{
				buffer.set(bufptr, buffer.get(bufptr) + gl);
				buffer.set(bufptr+1, buffer.get(bufptr+1) + gr);
				buffer.set(bufptr+2, buffer.get(bufptr+2) + gl);
				buffer.set(bufptr+3, buffer.get(bufptr+3) + gr);
			}
			else
			{
				buffer.set(bufptr, buffer.get(bufptr) - gl);
				buffer.set(bufptr+1, buffer.get(bufptr+1) - gr);
				buffer.set(bufptr+2, buffer.get(bufptr+2) - gl);
				buffer.set(bufptr+3, buffer.get(bufptr+3) - gr);
			}
			pos = (pos+4) % wl;
			bufptr = (bufptr+4) % buffer.length;
			lfsr_pos++;
			if (lfsr_pos > lfsr_wavelength) { 
				gen = lfsr.noiseThresh(taps, gen_level);
				gl = gen * left;
				gr = gen * right;
			}
		}
		
	}
	
	public inline function runWavetable(table : Array<Array<FastFloatBuffer>>, curval : Float, wl : Int, hw : Float,
		pan : Float)
	{
		var peak = curval * 0.3;
		var left = pan * 2;
		var right = (1. -pan) * 2;
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
				var sum = peak * Math.sin(pos * adjust);
				buffer.set(bufptr, buffer.get(bufptr)+ sum * left);
				buffer.set(bufptr+1, buffer.get(bufptr+1) + sum * right);
				pos = (pos+2) % wl;
				bufptr = (bufptr+2) % buffer.length;
			}		
		}
		else if (di > DOUBLE_INTERPOLATE)
		{
			// run with a 2x linear implementation to make the wavetable part more filtered
			var pwi = Std.int(hw / wl * TABLE_MODULATIONS);
			if (pwi < 0) pwi = Std.int(Math.abs(pwi)); 
			if (pwi >= TABLE_MODULATIONS) pwi = TABLE_MODULATIONS - 1;
			var wave = table[oct][pwi];
			var adjust = base_wl / wl;
			pos = pos % wl;
			for (i in 0 ... buffer.length >> 1) 
			{
				var pa = pos * adjust;
				var dist = pa - Std.int(pa);
				var pb = Math.max(0., pa - 1);
				var pc = Math.min(wave.length-1, pa + 2);
				var dist2 = (pb - pc)*0.33333333;
				var l = wave.get(Std.int(pa));
				var r = wave.get(Std.int(pa) + 1);
				var l2 = wave.get(Std.int(pb));
				var r2 = wave.get(Std.int(pc));
				var sum = peak * (l * (dist) + r * (1. - dist) + l2 * (dist2) + r2 * (1. - dist2)) * 0.5;
				buffer.set(bufptr, buffer.get(bufptr)+ sum * left);
				buffer.set(bufptr+1, buffer.get(bufptr+1) + sum * right);
				pos = (pos+2) % wl;
				bufptr = (bufptr+2) % buffer.length;
			}		
		}
		else // regular linear
		{
			var pwi = Std.int(hw / wl * TABLE_MODULATIONS);
			if (pwi < 0) pwi = Std.int(Math.abs(pwi)); 
			if (pwi >= TABLE_MODULATIONS) pwi = TABLE_MODULATIONS - 1;
			var wave = table[oct][pwi];
			var adjust = base_wl / wl;
			pos = pos % wl;
			for (i in 0 ... buffer.length >> 1) 
			{
				var pa = pos * adjust;
				var spa = Std.int(pa);
				var dist = pa - spa;
				var l = wave.get(spa);
				var r = wave.get(spa + 1);
				var sum = peak * (l * (dist) + r * (1. - dist));
				buffer.set(bufptr, buffer.get(bufptr)+ sum * left);
				buffer.set(bufptr+1, buffer.get(bufptr+1) + sum * right);
				pos = (pos+2) % wl;
				bufptr = (bufptr+2) % buffer.length;
			}		
		}
	}
	
	public function event(patch_ev : PatchEvent, channel : SequencerChannel)
	{
		var ev = patch_ev.sequencer_event;
		switch(ev.type)
		{
			case SequencerEvent.NOTE_ON: 
				// as the channel adds more voices, the priority of its notes gets squashed.
				// doing this on note ons naturally favors squashing of repetitive drum hits and stacattos,
				// which have plenty of release tails, instead of held notes.
				followers.push(new EventFollower(patch_ev, patch_ev.patch.envelopes.length));
				for (f in channel.allocated)
				{
					patch_ev.sequencer_event.priority = Std.int((patch_ev.sequencer_event.priority * PRIORITY_VOICE));
				}
				pos = 0;
			case SequencerEvent.NOTE_OFF: 
				for (n in followers) 
				{ 
					if (n.patch_event.sequencer_event.id == ev.id)
					{
						n.setRelease();
					}
				}
		}
		
		for (n in followers) 
		{	
			if (n.patch_event.sequencer_event.channel == channel.id)
				return true; 
		}
		return false;
	}
	
	public function getEvents()
	{
		var result = new Array<SequencerEvent>();
		for ( n in followers )
		{
			result.push(n.patch_event.sequencer_event);
		}
		return result;
	}
	
	public function allOff()
	{
		while (followers.length>0) followers.pop();
	}
	
	public function allRelease()
	{
		for (f in followers) { f.setRelease(); }
	}
	
}
