package com.ludamix.triad.audio;

import com.ludamix.triad.tools.FastFloatBuffer;
import com.ludamix.triad.audio.dsp.IIRFilter2;
import com.ludamix.triad.audio.Sequencer;
import com.ludamix.triad.tools.MathTools;

class VoiceCommon
{
	public var buffer : FastFloatBuffer;
	public var followers : Array<EventFollower>;
	public var sequencer : Sequencer;
	public var freq : Float;
	
	public var master_volume : Float;
	public var velocity : Float;
	
	public var frame_pitch_adjust : Float;
	public var frame_vol_adjust : Float;
	public var frame_frequency_adjust : Float;
	public var frame_resonance_adjust : Float;
	
	public var arpeggio : Float;
	
	public var filter : IIRFilter2;	
	public var filter_cutoff_multiplier : Float; // a kind of hacky thing to compensate for a strong/weak filter
	
	public static inline var AS_PITCH_ADD = 0;
	public static inline var AS_PITCH_MUL = 1;
	public static inline var AS_VOLUME_ADD = 2;
	public static inline var AS_VOLUME_MUL = 3;
	public static inline var AS_FREQUENCY_ADD = 4;
	public static inline var AS_FREQUENCY_ADD_CENTS = 5;
	public static inline var AS_FREQUENCY_MUL = 6;
	public static inline var AS_RESONANCE_ADD = 7;
	public static inline var AS_RESONANCE_MUL = 8;
	
	public function new()
	{
		freq = 440.;
		master_volume = 0.1;
		velocity = 1.0;
		arpeggio = 0.;		
		filter_cutoff_multiplier = 1.;
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
		while (followers.length>0) followers.pop();
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
				case AS_FREQUENCY_ADD_CENTS: frame_frequency_adjust += 
					sequencer.tuning.midiNoteToFrequency(sequencer.tuning.frequencyToMidiNote(
						frame_frequency_adjust)+qty/100.);
				case AS_FREQUENCY_MUL: frame_frequency_adjust *= qty;
				case AS_RESONANCE_ADD: frame_resonance_adjust += qty;
				case AS_RESONANCE_MUL: frame_resonance_adjust *= qty;
			}
		}
	}
	
	public inline function updateLFO(patch : Dynamic, channel : SequencerChannel, cur_follower : EventFollower)
	{
		var lfo_num = 0;
		for (n in cast(patch.lfos,Array<Dynamic>))
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
	
	public function updateFollowers(progress_follower : Float->Float->Float->Float->EventFollower->Bool->Void) : Bool
	{
		while (followers.length > 0 && followers[followers.length - 1].isOff()) followers.pop();
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
			frame_frequency_adjust = patch.cutoff_frequency * filter_cutoff_multiplier;
			frame_resonance_adjust = patch.resonance_level;
			
			filter = follower.filter;
			
			// envelopes
			var env_num = 0;
			for (env in follower.env)
			{
				if (!env.isOff())
				{
					pipeAdjustment(env.update(1.0), env.assigns);
				}
				env_num++;
			}
			
			updateLFO(patch, channel, follower);
			
			filter.set(frame_frequency_adjust, frame_resonance_adjust);
			
			freq = seq_event.data.freq;
			
			var wl = sequencer.waveLengthOfBentFrequency(freq, 
						pitch_bend + Std.int((frame_pitch_adjust * 8192 / sequencer.tuning.bend_semitones)));
			
			freq = sequencer.frequency(wl);
			
			velocity = seq_event.data.velocity / 128;
			
			var channel_volume = channel.channel_volume;
			var pan = channel.pan;
			
			var curval = patch.volume * master_volume * channel_volume * channel.velocityCurve(velocity) * 
				frame_vol_adjust;
			
			var pan_sum = MathTools.limit(0., 1., pan + 2 * (patch.pan - 0.5));
			var left = curval * Math.sin(pan_sum * 2);
			var right = curval * Math.cos(1. - pan_sum) * 2;
			
			progress_follower(freq, wl, left, right, follower, follower==cur_follower);
		}
		return true;
	}
	
}
