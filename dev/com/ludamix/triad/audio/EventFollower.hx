package com.ludamix.triad.audio;
import com.ludamix.triad.audio.Sequencer;
import com.ludamix.triad.audio.Envelope;

class EventFollower
{
	
	// this thing holds some additional state per-event.
	
	public var patch_event : PatchEvent;
	public var env : Array<EnvelopeState>;
	public var lfo_pos : Int;
	public var pos : Float;
	public var release_level : Float;
	
	public function new(event : PatchEvent, num_envelopes)
	{
		this.patch_event = event; 
		env = new Array();
		for (n in 0...num_envelopes)
			env.push(new EnvelopeState());
		this.lfo_pos = 0;
		pos = 0.; release_level = 1.;
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
			for (e in env) { e.state = TableSynth.RELEASE; e.ptr = 0; }
		}
	}
	
}
