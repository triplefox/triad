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

class TableSynth implements SoftSynth
{
	
	public var buffer : Vector<Float>;
	public var events : Array<EventFollower>;
	public var sequencer : Sequencer;
	
	public var freq : Float;
	public var pos : Int;
	public var bufptr : Int;
	
	public var master_volume : Float;
	public var track_volume : Float;
	public var velocity : Float;
	public var velocity_mapping : Int;
	
	public var pitch_bend : Int;
	
	public static inline var VELOCITY_LINEAR = 0;
	public static inline var VELOCITY_SQR = 1;
	public static inline var VELOCITY_POW = 2;
	
	public var attack_envelope : Array<Float>;
	public var sustain_envelope : Array<Float>;
	public var release_envelope : Array<Float>;
	
	public var oscillator : Int;
	
	public var pulsewidth : Float;
	
	public static inline var ATTACK = 0;
	public static inline var SUSTAIN = 1;
	public static inline var RELEASE = 2;
	public static inline var OFF = 3;
	
	public static inline var PULSE = 0;
	public static inline var SAW = 1;
	public static inline var TRI = 2;
	
	public function new()
	{
		freq = 440.;
		pos = 0;
		bufptr = 0;
		master_volume = 0.1;
		track_volume = 1.0;
		velocity = 1.0;
		velocity_mapping = VELOCITY_SQR;
		pitch_bend = 0;
		
		attack_envelope = [1.0];
		sustain_envelope = [1.0];
		release_envelope = [1.0];
		
		oscillator = PULSE;
		pulsewidth = 0.5;		
	}
	
	public function interpretADSR(a : Float, d : Float, s : Float, r : Float)
	{
		var af = Math.ceil(sequencer.secondsToFrames(a));
		var df = Math.ceil(sequencer.secondsToFrames(d));
		var rf = Math.ceil(sequencer.secondsToFrames(r));
		
		if (af == 0) af = 1;
		if (df == 0) df = 1;
		if (rf == 0) rf = 1;
		
		attack_envelope = new Array<Float>();
		for (n in 0...af)
			attack_envelope.push(com.ludamix.triad.tools.MathTools.rescale(0,af,0.,1.0,n));
		for (n in 0...df)
			attack_envelope.push(com.ludamix.triad.tools.MathTools.rescale(0,df,s,1.0,df-n));
		sustain_envelope = [s];
		release_envelope = new Array<Float>();
		for (n in 0...rf)
			release_envelope.push(com.ludamix.triad.tools.MathTools.rescale(0,rf,0.,s,rf-n));
		
	}
	
	public function init(sequencer : Sequencer, buffersize : Int)
	{
		this.sequencer = sequencer;
		this.buffer = new Vector(buffersize, true);
		this.events = new Array();
		
		interpretADSR(0.01,0.4,0.3,0.2);
		
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
		if (events.length < 1) return false;
		
		var cur_event : EventFollower = events[events.length - 1];
		
		freq = Std.int(cur_event.event.data.note);
		var wl = Std.int(sequencer.waveLengthOfBentFrequency(freq, pitch_bend));
		
		velocity = cur_event.event.data.velocity / 128;
		
		// update envelopes and vol+envelope state
		var envelopes = [attack_envelope, sustain_envelope, release_envelope];		
		var curval = master_volume * track_volume * velocityCurve() * envelopes[cur_event.env_state][cur_event.env_ptr];
		
		// update pulsewidth and "halfway" point
		pulsewidth += 0.01; if (pulsewidth > 2.0) pulsewidth = 0.;
		var hw : Int;
		if (pulsewidth > 1.0) 
			hw = Std.int(wl * (1.0 - (pulsewidth%1.0)));
		else
			hw = Std.int(wl * pulsewidth);
		
		switch(oscillator)
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
						if (release_envelope.length>0)
							{ if (n.env_state!=RELEASE) {n.env_state = RELEASE; n.env_ptr = 0;} }
						else
							n.env_state = OFF;
					}
				}
			case SequencerEvent.PITCH_BEND:
				pitch_bend = ev.data;
			case SequencerEvent.VOLUME:
				track_volume = ev.data;
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
