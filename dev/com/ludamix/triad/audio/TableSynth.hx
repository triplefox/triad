package com.ludamix.triad.audio;

import nme.Vector;
import com.ludamix.triad.audio.Sequencer;

// TODO: Upgrade the synth. It will run a table of changes each frame for
// pitch, vibrato, volume, waveform, support more waveforms, and more event types.

class TableSynth implements SoftSynth
{
	
	public var buffer : Vector<Float>;
	public var events : Array<SequencerEvent>;
	public var sequencer : Sequencer;
	
	public var wl : Int;
	public var pos : Int;
	public var bufptr : Int;
	
	public function new()
	{
		wl = 400;
		pos = 0;
		bufptr = 0;
	}
	
	public function init(sequencer : Sequencer, buffersize : Int)
	{
		this.sequencer = sequencer;
		this.buffer = new Vector(buffersize, true);
		this.events = new Array();
	}
	
	public function write()
	{
		if (events.length < 1)
			return false;
		wl = Std.int(events[events.length-1].data);
		var hw = wl >> 1;
		for (i in 0 ... buffer.length>>1) {
			if (pos % wl < hw)
			{
				buffer[bufptr] = 0.1; // left
				buffer[bufptr+1] = 0.1; // right
			}
			else
			{
				buffer[bufptr] = 0.; // left
				buffer[bufptr+1] = 0.; // right
			}
			pos = (pos+2) % wl;
			bufptr = (bufptr+2) % buffer.length;
		}
		return true;
	}
	
	public function event(ev : SequencerEvent, channel : SequencerChannel)
	{
		switch(ev.type)
		{
			case SequencerEvent.NOTE_ON: 
				{ events.push(ev); }
			case SequencerEvent.NOTE_OFF: 
				{for (n in events.copy()) { if (n.id == ev.id) events.remove(n); }}
		}
	}
	
}
