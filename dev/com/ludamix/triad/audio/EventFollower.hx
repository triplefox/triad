package com.ludamix.triad.audio;
import com.ludamix.triad.audio.Sequencer;

class EventFollower
{
	
	// this thing holds some additional state per-event.
	
	public var event : SequencerEvent;
	public var env_state : Int;
	public var env_ptr : Int;
	
	public function new(event : SequencerEvent)
	{
		this.event = event; env_state = 0; env_ptr = 0;
	}
}
