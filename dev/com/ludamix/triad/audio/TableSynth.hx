package com.ludamix.triad.audio;

import nme.Vector;
import com.ludamix.triad.audio.Sequencer;

typedef TableSynthPatch = {
	attack_envelope : Array<Float>,
	sustain_envelope : Array<Float>,
	release_envelope : Array<Float>,
	oscillator : Int,
	vibrato_frequency : Float, // hz
	vibrato_depth : Float, // midi notes
	vibrato_delay : Float, // seconds
	vibrato_attack : Float, // seconds
	modulation_vibrato : Float, // multiplier if greater than 0
	envelope_quantization : Int, // 0 = off, lower values produce "chippier" envelope character
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
	
	public var pulsewidth : Float;
	public var vibrato : Float;	
	public var arpeggio : Float;
	
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
	public static inline var PD_WINDOW_FREE = 5;
	public static inline var PD_FREE_WINDOW = 6;
	public static inline var PD_FREE_FREE = 7;
	
	public function new()
	{
		freq = 440.;
		pos = 0;
		bufptr = 0;
		master_volume = 0.1;
		velocity = 1.0;
		vibrato = 0.;
		arpeggio = 0.;
		
		pulsewidth = 0.5;
		
	}
	
	public static function generatorOf(settings : TableSynthPatch)
	{
		return new PatchGenerator(settings, function(settings,seq, ev) { return [new PatchEvent(ev, settings) ]; } );
	}
	
	public static function defaultPatch() : TableSynthPatch
	{
		return {attack_envelope:[1.0],
				sustain_envelope:[1.0],
				release_envelope:[1.0],
				oscillator:PD_WINDOW_FREE,
				vibrato_frequency:3.,
				vibrato_depth:0.5,
				vibrato_delay:0.05,
				vibrato_attack:0.05,
				modulation_vibrato:1.0,
				envelope_quantization:0,
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
	
	public inline function updateVibrato(patch : TableSynthPatch, channel : SequencerChannel) : Float
	{
		var cycle_length = sequencer.secondsToFrames(1. / patch.vibrato_frequency);
		var delay_length = sequencer.secondsToFrames(patch.vibrato_delay);
		var attack_length = sequencer.secondsToFrames(patch.vibrato_attack);
		var modulation_amount = patch.modulation_vibrato>0 ? patch.modulation_vibrato * channel.modulation : 1.0;
 		var mvibrato = vibrato - delay_length;
		vibrato += 1;
		if (mvibrato > 0)
		{
			if (mvibrato > attack_length)
			{
				return Math.sin(2 * Math.PI * mvibrato / cycle_length) * patch.vibrato_depth * modulation_amount;
			}
			else // ramp up vibrato
			{
				return Math.sin(2 * Math.PI * mvibrato / cycle_length) * modulation_amount * 
					(patch.vibrato_depth * (mvibrato/attack_length));
			}
		}
		else return 0.;
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
		while (followers.length > 0 && followers[followers.length - 1].env_state == OFF) followers.pop();
		if (followers.length < 1) { pos = 0; return false; }
		
		var cur_follower : EventFollower = followers[followers.length - 1];		
		var cur_channel = sequencer.channels[cur_follower.patch_event.sequencer_event.channel];
		var patch : TableSynthPatch = cur_follower.patch_event.patch;
		if (patch.arpeggiation_rate>0.0)
		{
			var available = Lambda.array(Lambda.filter(followers, function(a) { return a.env_state != OFF; } ));
			cur_follower = available[Std.int(((arpeggio) % 1) * available.length)];
			cur_channel = sequencer.channels[cur_follower.patch_event.sequencer_event.channel];
			patch = cur_follower.patch_event.patch;
			arpeggio += sequencer.secondsToFrames(1.0) / (patch.arpeggiation_rate);
		}
		var pitch_bend = cur_channel.pitch_bend;
		var channel_volume = cur_channel.channel_volume;
		var pan = cur_channel.pan;
		
		var seq_event = cur_follower.patch_event.sequencer_event;
		
		freq = Std.int(seq_event.data.freq);
		var wl = Std.int(sequencer.waveLengthOfBentFrequency(freq, 
					pitch_bend + Std.int((updateVibrato(patch, cur_channel) * 8192 / sequencer.tuning.bend_semitones))));
		if (wl < 1) wl = 1;
		
		velocity = seq_event.data.velocity / 128;
		
		// update envelopes and vol+envelope state
		var attack_envelope = patch.attack_envelope;
		var sustain_envelope = patch.sustain_envelope;
		var release_envelope = patch.release_envelope;
		var envelopes = [attack_envelope, sustain_envelope, release_envelope];
		var env_val = envelopes[cur_follower.env_state][cur_follower.env_ptr];
		if (patch.envelope_quantization != 0)
			env_val = (Math.round(env_val * patch.envelope_quantization) / patch.envelope_quantization);	
		var curval = master_volume * channel_volume * cur_channel.velocityCurve(velocity) * 
					env_val;
		
		// update pulsewidth and "halfway" point
		pulsewidth += 0.001; if (pulsewidth > 2.0) pulsewidth = 0.;
		var hw : Int;
		if (pulsewidth > 1.0) 
			hw = Std.int(wl * (1.0 - (pulsewidth%1.0)));
		else
			hw = Std.int(wl * pulsewidth);
		
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
				var outer_a = 0.5 + pulsewidth;
				var outer_b = 0.5;
				var inner_a = 1.0 + pulsewidth;
				var inner_b = 3.0;
				var inner_c = 0.1 + pulsewidth;
				
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
			case PD_WINDOW_FREE:
				/*
				 * 	
				var outer_a = 1.0;
				var outer_b = 0.5;
				var inner_a = 1.0;
				var inner_b = 1.0;
				var inner_c = 0.125;
				*/
				var outer_a = 0.5;
				var outer_b = 0.5 + pulsewidth;
				var inner_a = 1.01;
				var inner_b = 3.1;
				var inner_c = 0.11;
				
				var peak = curval * 2;
				var left = pan * peak;
				var right = (1. -pan) * peak;
				
				for (i in 0 ... buffer.length >> 1) 
				{
					var sum = Math.cos(alg_window(pos * outer_a, wl * outer_b) * Math.PI * 2 * 
								Math.cos(alg_free(pos * inner_a, wl * inner_b) * inner_c * Math.PI * 2));								
					buffer[bufptr] += sum * left;
					buffer[bufptr+1] += sum * right;
					pos = (pos+2) % wl;
					bufptr = (bufptr+2) % buffer.length;
				}
			case PD_FREE_WINDOW:
				/*
				 * 	
				var outer_a = 1.0;
				var outer_b = 0.5;
				var inner_a = 1.0;
				var inner_b = 1.0;
				var inner_c = 0.125;
				*/
				var outer_a = 0.5;
				var outer_b = 0.5;
				var inner_a = 1.0;
				var inner_b = 3.0;
				var inner_c = 0.1;
				
				var peak = curval * 2;
				var left = pan * peak;
				var right = (1. -pan) * peak;
				
				for (i in 0 ... buffer.length >> 1) 
				{
					var sum = Math.cos(alg_free(pos * outer_a, wl * outer_b) * Math.PI * 2 * 
								Math.cos(alg_window(pos * inner_a, wl * inner_b) * inner_c * Math.PI * 2));								
					buffer[bufptr] += sum * left;
					buffer[bufptr+1] += sum * right;
					pos = (pos+2) % wl;
					bufptr = (bufptr+2) % buffer.length;
				}
			case PD_FREE_FREE:
				/*
				 * 	
				var outer_a = 1.0;
				var outer_b = 0.5;
				var inner_a = 1.0;
				var inner_b = 1.0;
				var inner_c = 0.125;
				*/
				var outer_a = 2.5;
				var outer_b = 7.5;
				var inner_a = 1.2;
				var inner_b = 3.7;
				var inner_c = 0.5;
				
				var peak = curval * 2;
				var left = pan * peak;
				var right = (1. -pan) * peak;
				
				for (i in 0 ... buffer.length >> 1) 
				{
					var sum = Math.cos(alg_free(pos * outer_a, wl * outer_b) * Math.PI * 2 * 
								Math.cos(alg_free(pos * inner_a, wl * inner_b) * inner_c * Math.PI * 2));								
					buffer[bufptr] += sum * left;
					buffer[bufptr+1] += sum * right;
					pos = (pos+2) % wl;
					bufptr = (bufptr+2) % buffer.length;
				}
		}
		
		for (ev in followers)
		{
			ev.env_ptr++;
			if (ev.env_state!=OFF && ev.env_ptr >= envelopes[ev.env_state].length)
			{
				if (ev.env_state != SUSTAIN)
					{ev.env_state += 1; }
				ev.env_ptr = 0;
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
				followers.push(new EventFollower(patch_ev));
				vibrato = 0.;
				pos = 0;
			case SequencerEvent.NOTE_OFF: 
				for (n in followers) 
				{ 
					if (n.patch_event.sequencer_event.id == ev.id)
					{
						if (n.patch_event.patch.release_envelope.length>0)
							{ if (n.env_state!=RELEASE) {n.env_state = RELEASE; n.env_ptr = 0;} }
						else
							n.env_state = OFF;
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
	
}
