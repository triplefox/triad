package com.ludamix.triad.audio;

import nme.Vector;
import com.ludamix.triad.audio.Sequencer;

class EventFollower
{
	public var event : SequencerEvent;
	public var env_state : Int;
	public var env_ptr : Int;
	
	public function new(event : SequencerEvent)
	{
		this.event = event; env_state = 0; env_ptr = 0;
	}
}

typedef TableSynthPatch = {
	attack_envelope : Array<Float>,
	sustain_envelope : Array<Float>,
	release_envelope : Array<Float>,
	oscillator : Int
};

class TableSynth implements SoftSynth
{
	
	public var buffer : Vector<Float>;
	public var events : Array<EventFollower>;
	public var sequencer : Sequencer;
	
	public var freq : Float;
	public var pos : Int;
	public var bufptr : Int;
	
	public var master_volume : Float;
	public var velocity : Float;
	public var velocity_mapping : Int;
	
	public static inline var VELOCITY_LINEAR = 0;
	public static inline var VELOCITY_SQR = 1;
	public static inline var VELOCITY_POW = 2;
	
	public var pulsewidth : Float;
	
	public static inline var ATTACK = 0;
	public static inline var SUSTAIN = 1;
	public static inline var RELEASE = 2;
	public static inline var OFF = 3;
	
	// naive oscillators
	public static inline var PULSE = 0;
	public static inline var SAW = 1;
	public static inline var TRI = 2;
	public static inline var SIN = 3;
	// later... band-limited versions?
	
	public function new()
	{
		freq = 440.;
		pos = 0;
		bufptr = 0;
		master_volume = 0.1;
		velocity = 1.0;
		velocity_mapping = VELOCITY_SQR;
		
		pulsewidth = 0.5;
	}
	
	public static function defaultPatch() : TableSynthPatch
	{
		return {attack_envelope:[1.0],
					  sustain_envelope:[1.0],
					  release_envelope:[1.0],
					  oscillator:PULSE };
	}
	
	public function init(sequencer : Sequencer, buffersize : Int)
	{
		this.sequencer = sequencer;
		this.buffer = new Vector(buffersize, true);
		this.events = new Array();		
	}
	
	public inline function velocityCurve()
	{
		switch(velocity_mapping)
		{
			case VELOCITY_LINEAR:
				return velocity;
			case VELOCITY_SQR:
				return velocity * velocity;
			case VELOCITY_POW:
				return Math.pow(velocity, 1.0 - velocity);
			default:
				return velocity;
		}
	}
	
	public function write()
	{	
		while (events.length > 0 && events[events.length - 1].env_state == OFF) events.pop();
		if (events.length < 1) { pos = 0; return false; }
		
		var cur_event : EventFollower = events[events.length - 1];
		var cur_channel = sequencer.channels[cur_event.event.channel];
		var pitch_bend = cur_channel.pitch_bend;
		var channel_volume = cur_channel.channel_volume;		
		var patch : TableSynthPatch = cur_channel.patch;
		
		freq = Std.int(cur_event.event.data.note);
		var wl = Std.int(sequencer.waveLengthOfBentFrequency(freq, pitch_bend));
		
		velocity = cur_event.event.data.velocity / 128;
		
		// update envelopes and vol+envelope state
		var attack_envelope = patch.attack_envelope;
		var sustain_envelope = patch.sustain_envelope;
		var release_envelope = patch.release_envelope;
		var envelopes = [attack_envelope, sustain_envelope, release_envelope];		
		var curval = master_volume * channel_volume * velocityCurve() * envelopes[cur_event.env_state][cur_event.env_ptr];
		
		// update pulsewidth and "halfway" point
		//pulsewidth += 0.01; if (pulsewidth > 2.0) pulsewidth = 0.;
		var hw : Int;
		if (pulsewidth > 1.0) 
			hw = Std.int(wl * (1.0 - (pulsewidth%1.0)));
		else
			hw = Std.int(wl * pulsewidth);
		
		switch(patch.oscillator)
		{
			case PULSE:
				for (i in 0 ... buffer.length>>1) {
					if (pos % wl < hw)
					{
						buffer[bufptr] = curval; // left
						buffer[bufptr+1] = curval; // right
					}
					else
					{
						buffer[bufptr] = -curval; // left
						buffer[bufptr+1] = -curval; // right
					}
					pos = (pos+2) % wl;
					bufptr = (bufptr+2) % buffer.length;
				}
			case SAW:
				var peak = 2 * curval;
				var one_over_wl = peak / wl;
				for (i in 0 ... buffer.length >> 1) 
				{
					var sum = ((wl-(pos<<1)) % wl) * one_over_wl;
					buffer[bufptr] = sum; // left
					buffer[bufptr+1] = sum; // right
					pos = (pos+2) % wl;
					bufptr = (bufptr+2) % buffer.length;
				}
			case TRI:
				var peak = curval;
				var one_over_wl = peak / wl;
				for (i in 0 ... buffer.length >> 1) 
				{
					var sum = ((wl-(pos<<1)) % wl) * one_over_wl;
					if (pos % wl >= hw)
					{
						sum = peak - sum;
					}
					buffer[bufptr] = sum; // left
					buffer[bufptr+1] = sum; // right
					pos = (pos+2) % wl;
					bufptr = (bufptr+2) % buffer.length;
				}
			case SIN:
				var peak = curval * 0.3;
				var adjust = 2 * Math.PI / wl;
				for (i in 0 ... buffer.length >> 1) 
				{
					var sum = peak * Math.sin(pos * adjust);
					buffer[bufptr] = sum; // left
					buffer[bufptr+1] = sum; // right
					pos = (pos+2) % wl;
					bufptr = (bufptr+2) % buffer.length;
				}
		}
		
		for (ev in events)
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
	
	public function event(ev : SequencerEvent, channel : SequencerChannel)
	{
		switch(ev.type)
		{
			case SequencerEvent.NOTE_ON: 
				events.push(new EventFollower(ev)); 
			case SequencerEvent.NOTE_OFF: 
				for (n in events) 
				{ 
					if (n.event.id == ev.id) 
					{
						if (channel.patch.release_envelope.length>0)
							{ if (n.env_state!=RELEASE) {n.env_state = RELEASE; n.env_ptr = 0;} }
						else
							n.env_state = OFF;
					}
				}
		}
	}
	
	public function getEvents()
	{
		var result = new Array<SequencerEvent>();
		for ( n in events )
		{
			result.push(n.event);
		}
		return result;
	}
	
}
