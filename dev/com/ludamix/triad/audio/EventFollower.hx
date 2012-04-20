package com.ludamix.triad.audio;
import com.ludamix.triad.audio.Sequencer;

class EventFollower
{
	
	// this thing holds some additional state per-event.
	
	public var patch_event : PatchEvent;
	public var env_state : Int;
	public var env_ptr : Int;
	public var pos : Float;
	public var release_level : Float;
	
	public function new(event : PatchEvent)
	{
		this.patch_event = event; env_state = 0; env_ptr = 0; pos = 0.; release_level = 1.;
	}
}
