package com.ludamix.triad.audio;

import com.ludamix.triad.tools.FastFloatBuffer;
import com.ludamix.triad.audio.Sequencer;

interface SoftSynth
{	
	
	// VoiceCommon contains most of the key elements of the synth:
	// Envelopes, LFOs, pitch and volume state, the buffer pointer.
	// When the synth runs write() it should update the VoiceCommon data, with a hook for the inner loop of
	// synth processing.
	
	public var common : VoiceCommon;	
	public function write():Bool;
	
}
