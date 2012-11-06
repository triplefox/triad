package com.ludamix.triad.audio;

import com.ludamix.triad.audio.dsp.SVFilter;
import com.ludamix.triad.tools.FastFloatBuffer;
import com.ludamix.triad.audio.Sequencer;
import com.ludamix.triad.tools.MathTools;
import com.ludamix.triad.audio.MIDITuning;

typedef VoiceFrameInfos = { frequency:Float, wavelength:Float, volume_left:Float, volume_right:Float };

class VoiceCommon
{
	public var buffer : FastFloatBuffer;
	public var followers : Array<EventFollower>;
	public var sequencer : Sequencer;
	public var freq : Float;
	public var tuning : MIDITuning;
	
	public var event_priority : Int;
	
	public var master_volume : Float;
	public var velocity : Float;
	
	public var frame_pitch_adjust : Float;
	public var frame_vol_adjust : Float;
	public var frame_frequency_adjust : Float;
	public var frame_resonance_adjust : Float;
	public var frame_custom_adjust : Float;
	
	public var custom_data : Dynamic;
	
	public var arpeggio : Float;
	
	public var filter : SVFilter;	
	public var filter_cutoff_multiplier : Float; // a kind of hacky thing to compensate for a strong/weak filter
	public var filter_resonance_multiplier : Float; // likewise
	public var filter_mode : Int;
	
	public static inline var FILTER_UNDEFINED = -1;
	public static inline var FILTER_OFF = 0;
	public static inline var FILTER_LP = 1;
	public static inline var FILTER_HP = 2;
	public static inline var FILTER_BP = 3;
	public static inline var FILTER_BR = 4;
	public static inline var FILTER_RINGMOD = 5;
	public static inline var FILTER_RINGMOD_TUNED = 6;
	
	public static inline var AS_PITCH_ADD = 0; // semitones
	public static inline var AS_PITCH_MUL = 1; // of 1. = 100%
	public static inline var AS_VOLUME_ADD = 2; // of 1. = 100%
	public static inline var AS_VOLUME_MUL = 3; // of 1. = 100%
	public static inline var AS_FREQUENCY_ADD = 4; // hz
	public static inline var AS_FREQUENCY_ADD_CENTS = 5; // cents
	public static inline var AS_FREQUENCY_MUL = 6; // hz
	public static inline var AS_RESONANCE_ADD = 7;
	public static inline var AS_RESONANCE_MUL = 8;
	
	public static inline var AS_CUSTOM_ADD = 9; // of 1. = 100%

	public static inline var LFO_SIN = 0;
	public static inline var LFO_COS = 1;
	public static inline var LFO_RAMP = 2;
	public static inline var LFO_SQR = 3;
	public static inline var LFO_TRI = 4;
	public static inline var LFO_RAND = 5;
	
	public function new()
	{
		event_priority = -1;
		freq = 440.;
		master_volume = 0.1;
		velocity = 1.0;
		arpeggio = 0.;		
		filter_cutoff_multiplier = 1.;
		filter_resonance_multiplier = 1.;
		frame_custom_adjust = 0.;
		tuning = EvenTemperament.cache;
	}
	
	public function init(sequencer : Sequencer)
	{
		this.sequencer = sequencer;
		this.buffer = sequencer.buffer;
		this.followers = new Array();		
	}
	
	public function getEvents() : Array<PatchEvent>
	{
		var result = new Array<PatchEvent>();
		for ( n in followers )
		{
			result.push(n.patch_event);
		}
		return result;
	}
	
	public inline function getFollowers() : Array<EventFollower>
	{
		return followers;
	}
	
	public function allOff()
	{
		while (followers.length>0) followers.pop().dispose();
	}
	
	public function allRelease()
	{
		for (f in followers) { f.setRelease(); }
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
				case AS_FREQUENCY_ADD: frame_frequency_adjust += qty;
				case AS_FREQUENCY_ADD_CENTS: frame_frequency_adjust = 
					tuning.midiNoteToFrequency(tuning.frequencyToMidiNote(
						frame_frequency_adjust)+qty/100.);
				case AS_FREQUENCY_MUL: frame_frequency_adjust *= qty;
				case AS_RESONANCE_ADD: frame_resonance_adjust += qty;
				case AS_RESONANCE_MUL: frame_resonance_adjust *= qty;
				case AS_CUSTOM_ADD: frame_custom_adjust += qty;
			}
		}
	}
	
	public static function parseAddStyle(i : String)
	{
		switch(i)
		{
			default: throw "bad style " + i;
			case "pitch_add": return AS_PITCH_ADD;
			case "pitch_mul": return AS_PITCH_MUL;
			case "volume_add": return AS_VOLUME_ADD;
			case "volume_mul": return AS_VOLUME_MUL;
			case "frequency_add": return AS_FREQUENCY_ADD;
			case "frequency_add_cents": return AS_FREQUENCY_ADD_CENTS;
			case "frequency_mul": return AS_FREQUENCY_MUL;
			case "resonance_add": return AS_RESONANCE_ADD;
			case "resonance_mul": return AS_RESONANCE_MUL;
			case "custom_add": return AS_CUSTOM_ADD;
		}
	}
	
	public static function parseLfoType(i : String)
	{
		switch(i)
		{
			default: throw "bad lfo type " + i;
			case "sine","sin": return LFO_SIN;
			case "cosine","cos": return LFO_COS;
			case "square","sq","sqr": return LFO_SQR;
			case "random","rand": return LFO_RAND;
			case "ramp","saw": return LFO_RAMP;
			case "triangle","tri": return LFO_TRI;
		}
	}
	
	public static function parseFilterMode(i : String)
	{
		switch(i)
		{
			default: throw "bad filter mode " + i;
			case "bp": return FILTER_BP;
			case "lp": return FILTER_LP;
			case "hp": return FILTER_HP;
			case "br": return FILTER_BR;
			case "ringmod": return FILTER_RINGMOD;
			case "ringmod_tuned": return FILTER_RINGMOD_TUNED;
			case "off": return FILTER_OFF;
		}
	}
	
	public inline function updateLFO(patch : Dynamic, channel : SequencerChannel, cur_follower : EventFollower)
	{
		for (n in cast(patch.lfos,Array<Dynamic>))
		{
			var cycle_length = sequencer.secondsToFrames(1. / n.frequency);
			var delay_length = sequencer.secondsToFrames(n.delay);
			var attack_length = sequencer.secondsToFrames(n.attack);
			var mpos = cur_follower.lfo_pos - delay_length;
			if (mpos > 0)
			{
				var depth : Float = n.depth;
				if (mpos <= attack_length) // ramp up
				{
					depth *= (mpos / attack_length);
				}
				switch(n.type)
				{
					case LFO_SIN: pipeAdjustment(Math.sin(2 * Math.PI * mpos / cycle_length) * depth, n.assigns);
					case LFO_COS: pipeAdjustment(Math.cos(2 * Math.PI * mpos / cycle_length) * depth, n.assigns);
					case LFO_RAMP: pipeAdjustment(((mpos % cycle_length) / cycle_length) * depth, n.assigns);
					case LFO_TRI: pipeAdjustment(((mpos % cycle_length) > cycle_length * 0.5 ? 
						((mpos % cycle_length) / cycle_length * 2 ) :
						(1. - 2 * (mpos % cycle_length * 0.5) / cycle_length)) * depth, n.assigns);
					case LFO_SQR: pipeAdjustment(((mpos % cycle_length) > cycle_length*0.5 ? 1.:-1.) * depth, n.assigns);
					case LFO_RAND: pipeAdjustment((Math.random() * 2 - 1) * depth, n.assigns);
				}
				
			}
		}
		for (n in cast(patch.modulation_lfos,Array<Dynamic>))
		{
			var cycle_length = sequencer.secondsToFrames(1. / n.frequency);
			var delay_length = sequencer.secondsToFrames(n.delay);
			var attack_length = sequencer.secondsToFrames(n.attack);
			var modulation_amount = channel.modulation;
			var mpos = cur_follower.lfo_pos - delay_length;
			if (mpos > 0 && modulation_amount > 0)
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
		}
		cur_follower.lfo_pos += 1;
	}
	
	public function updateFollowers(progress_follower : VoiceFrameInfos->EventFollower->Bool->Void) : Bool
	{
		while (followers.length > 0 && followers[followers.length - 1].isOff()) followers.pop().dispose();
		if (followers.length < 1) { return false; }
		
		var cur_follower : EventFollower = followers[followers.length - 1];		
		var patch : Dynamic = cur_follower.patch_event.patch;
		if (patch.arpeggiation_rate>0.0)
		{
			var available = Lambda.array(Lambda.filter(followers, function(a) { return !a.isOff(); } ));
			cur_follower = available[Std.int(((arpeggio) % 1) * available.length)];
			patch = cur_follower.patch_event.patch;
			arpeggio += sequencer.secondsToFrames(1.0) / (patch.arpeggiation_rate);
		}
		
		for (follower in followers)
		{
			var channel = sequencer.channels[follower.patch_event.sequencer_event.channel];
			var patch : Dynamic = follower.patch_event.patch;
			
			var pitch_bend = channel.pitch_bend;
			
			var seq_event = follower.patch_event.sequencer_event;
			
			frame_pitch_adjust = 0.;
			frame_vol_adjust = 0.;
			frame_frequency_adjust = patch.cutoff_frequency;
			if (!(patch.filter_mode == FILTER_RINGMOD || patch.filter_mode == FILTER_RINGMOD_TUNED))
			{
				frame_frequency_adjust *= filter_cutoff_multiplier;
			}
			frame_resonance_adjust = patch.resonance_level * filter_resonance_multiplier;
			frame_custom_adjust = 0.;
			
			filter = follower.filter;
			
			// envelopes
			for (env in follower.env)
			{
				if (!env.isOff())
				{
					pipeAdjustment(env.update(1.0), env.assigns);
				}
			}
			
			updateLFO(patch, channel, follower);
			
			freq = seq_event.data.freq;
			
			var wl = sequencer.waveLengthOfBentFrequency(freq + frame_pitch_adjust, pitch_bend, patch.transpose);
			
			freq = sequencer.frequency(wl);
			
			if (patch.filter_mode == FILTER_UNDEFINED) // default filter behavior
			{
				if (patch.cutoff_frequency >= 1.) patch.filter_mode = FILTER_LP;
				else patch.filter_mode = FILTER_OFF;
			}
			
			filter_mode = patch.filter_mode;
			if (patch.filter_mode == FILTER_RINGMOD_TUNED)
				frame_frequency_adjust = frame_frequency_adjust * freq;
			if (filter_mode != FILTER_OFF)
				filter.set(frame_frequency_adjust, frame_resonance_adjust);
			
			velocity = seq_event.data.velocity / 128;
			
			var channel_volume = channel.channel_volume;
			var pan = channel.pan;
			
			var curval = patch.volume * master_volume * channel_volume * channel.velocityCurve(velocity) * 
				frame_vol_adjust;
			
			var pan_sum = MathTools.limit(0., 1., pan + 2 * (patch.pan - 0.5));
			var left = curval * Math.cos(pan_sum * 2);
			var right = curval * Math.sin(pan_sum * 2);
			
			progress_follower( { frequency:freq, wavelength:wl, volume_left:left, volume_right:right }, 			
				follower, follower==cur_follower);
		}
		return true;
	}
	
}
