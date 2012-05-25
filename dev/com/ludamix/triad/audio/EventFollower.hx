package com.ludamix.triad.audio;
import com.ludamix.triad.audio.Sequencer;
import com.ludamix.triad.audio.Envelope;

class EventFollower
{
	
	// this thing holds some additional state per-event.
	
	public var patch_event : PatchEvent;
	public var env : Array<EnvelopeState>;
	public var lfo_pos : Int;
	public var loop_pos : Float;
	public var loop_state : Int;
	public var release_level : Float;
	
	public static inline var LOOP_PRE = 0;
	public static inline var LOOP = 1;
	public static inline var LOOP_POST = 2;
	
	public function new(event : PatchEvent, num_envelopes)
	{
		this.patch_event = event; 
		env = new Array();
		for (n in 0...num_envelopes)
			env.push(new EnvelopeState());
		this.lfo_pos = 0;
		loop_pos = 0.; loop_state = 0; release_level = 1.;
	}
	
	public inline function isOff()
	{
		return env[0].state == TableSynth.OFF;
	}
	
	public inline function setRelease()
	{
		if (patch_event.patch.envelopes[0].release.length == 0)
		{
			for (e in env) { e.state = TableSynth.OFF; }
		}
		else if (env[0].state != TableSynth.RELEASE)
		{
			for (e in env) { e.state = TableSynth.RELEASE; e.ptr = 0; 
				if (loop_state != LOOP_POST) { loop_state = LOOP_POST; loop_pos = 0.; }
			}
		}
	}
	
}
