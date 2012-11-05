package com.ludamix.triad.audio;
import com.ludamix.triad.audio.dsp.SVFilter;
import com.ludamix.triad.audio.Sequencer;
import com.ludamix.triad.audio.Envelope;

class EventFollower
{
	
	// this thing holds some additional state per-event.
	
	public var patch_event : PatchEvent;
	public var env : Array<Envelope>;
	public var lfo_pos : Int;
	public var loop_pos : Float;
	public var loop_state : Int;
	public var filter : SVFilter;
	
	public static inline var LOOP_PRE = 0;
	public static inline var LOOP_FORWARD = 1;
	public static inline var LOOP_BACKWARD = 2;
	public static inline var LOOP_PING = 3;
	public static inline var LOOP_PONG = 4;
	public static inline var LOOP_POST = 5;
	
	public function new(event : PatchEvent, seq:Sequencer)
	{
		this.patch_event = event; 
		env = new Array();
		for (n in cast(event.patch.envelope_profiles,Array<Dynamic>))
			env.push(new Envelope(n.attack,n.release,n.assigns,n.endpoint));
		this.lfo_pos = 0;
		loop_pos = 0.; loop_state = LOOP_PRE;
		filter = new SVFilter(440.,0,seq.sampleRate());
	}
	
	public inline function isOff() { return env[0].isOff(); }
	
	public inline function setRelease()
	{
		for (e in env)
			e.setRelease();
	}
	
	public inline function setOff()
	{
		for (e in env)
			e.setOff();
	}
	
}
