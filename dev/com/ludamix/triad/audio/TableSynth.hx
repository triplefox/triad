package com.ludamix.triad.audio;

import nme.Vector;
import com.ludamix.triad.audio.Sequencer;

typedef TSAssign = Int;

typedef TableSynthPatch = {
	envelopes : Array<Envelope>,
	lfos : Array<LFO>,
	oscillator : Int,
	modulation_lfo : Float, // applies to LFO1, depth multiplier if greater than 0
	arpeggiation_rate : Float // 0 = off, hz value
};

class TableSynth implements SoftSynth
{
	
	public var buffer : Vector<Float>;
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
	
	public static inline var ATTACK = 0;
	public static inline var SUSTAIN = 1;
	public static inline var RELEASE = 2;
	public static inline var OFF = 3;
	
	// naive oscillators
	public static inline var PULSE = 0;
	public static inline var SAW = 1;
	public static inline var TRI = 2;
	public static inline var SIN = 3;
	// phase distortion-based ( cosine * cosine with optional windowing envelope on both)
	public static inline var PD_WINDOW_WINDOW = 4;
	// fm-based
	public static inline var FM_2OP = 5;
	
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
		
	}
	
	public static function generatorOf(settings : TableSynthPatch)
	{
		return new PatchGenerator(settings, function(settings,seq, ev) { return [new PatchEvent(ev, settings) ]; } );
	}
	
	public static function defaultPatch(seq : Sequencer) : TableSynthPatch
	{
		var adsr_base = SynthTools.interpretADSR(seq.secondsToFrames, 0.2, 0.4, 0.5, 0.1, SynthTools.CURVE_POW,
			SynthTools.CURVE_POW, SynthTools.CURVE_POW, false);
		var envs : Array<Envelope> = [ { attack:adsr_base.attack, sustain:adsr_base.sustain, release:adsr_base.release, assigns:[AS_VOLUME_ADD],
							quantization:0 } ];
		var lfos : Array<LFO> = [ { frequency:6., depth:0.5, delay:0.05, attack:0.05, assigns:[AS_PITCH_ADD] } ];
		return { envelopes:envs,
				oscillator:FM_2OP,
				lfos : lfos,
				modulation_lfo:1.0,
				arpeggiation_rate:0.0
				}
				;
	}
	
	public function init(sequencer)
	{
		this.sequencer = sequencer;
		this.buffer = sequencer.buffer;
		this.followers = new Array();		
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
		frame_pulsewidth = 0.;
		
		updateLFO(patch, cur_channel, cur_follower);
		updateEnvelope(patch, cur_channel, cur_follower);
		
		freq = Std.int(seq_event.data.freq);
		
		var wl = Std.int(sequencer.waveLengthOfBentFrequency(freq, 
					pitch_bend + Std.int(frame_pitch_adjust * 8192 / sequencer.tuning.bend_semitones)));
		if (wl < 1) wl = 1;
		
		velocity = seq_event.data.velocity / 128;
		
		var curval = master_volume * channel_volume * cur_channel.velocityCurve(velocity) * frame_vol_adjust;
		
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
						buffer[bufptr] += left;
						buffer[bufptr+1] += right;
						buffer[bufptr+2] += left;
						buffer[bufptr+3] += right;
					}
					else
					{
						buffer[bufptr] += -left;
						buffer[bufptr+1] += -right;
						buffer[bufptr+2] += -left;
						buffer[bufptr+3] += -right;
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
					buffer[bufptr] += sum * left;
					buffer[bufptr+1] += sum * right;
					buffer[bufptr+2] += sum * left;
					buffer[bufptr+3] += sum * right;
					pos = (pos+4) % wl;
					bufptr = (bufptr+4) % buffer.length;
				}
			case TRI: // naive, run at full rate
				var peak = curval;
				var one_over_wl = peak / wl;
				var left = pan * 2;
				var right = (1.-pan) * 2;
				for (i in 0 ... buffer.length >> 1) 
				{
					var sum = ((wl-(pos<<1)) % wl) * one_over_wl;
					if (pos % wl >= hw)
					{
						sum = peak - sum;
					}
					buffer[bufptr] += sum * left;
					buffer[bufptr+1] += sum * right;
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
					buffer[bufptr] += sum * left;
					buffer[bufptr+1] += sum * right;
					pos = (pos+2) % wl;
					bufptr = (bufptr+2) % buffer.length;
				}
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
					buffer[bufptr] += sum * left;
					buffer[bufptr+1] += sum * right;
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
					buffer[bufptr] += sum * left;
					buffer[bufptr+1] += sum * right;
					pos = (pos+2) % wl;
					bufptr = (bufptr+2) % buffer.length;
				}
				
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
