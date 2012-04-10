package com.ludamix.triad.audio;

import nme.Vector;
import com.ludamix.triad.audio.Sequencer;

interface SoftSynth
{	
	
	// SoftSynth responsibilities:
	// 1. Initialize with the given buffer size and sequencer
	// 2. Write bytes to the buffer when requested with write() - if synth has no activity, can return False
	// 3. Recieve events and maintain their state: The event array should be used so that channels
	//    can make a decision on how to assign voicing. However, the synth is free to change event population
	//    at write() time.
	
	public var buffer : Vector<Float>;
	public var sequencer : Sequencer;
	
	public function init(sequencer : Sequencer, buffersize : Int):Void;
	public function write():Bool;
	public function event(data : SequencerEvent, channel : SequencerChannel):Void;
	public function getEvents():Array<SequencerEvent>;
	
}
