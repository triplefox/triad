package com.ludamix.triad.audio;

import com.ludamix.triad.audio.SamplerSynth;
import com.ludamix.triad.audio.Sequencer;
import com.ludamix.triad.audio.Envelope;
import com.ludamix.triad.audio.MIDITuning;

class SamplerOpcodeGroup
{

	// store region and groups for sampler patch opcodes

	public var regions : Array<SamplerPatch>;

	public function new():Void 
	{
		regions = new Array();
	}

	public function query(ev : SequencerEvent, seq : Sequencer) : Array<PatchEvent>
	{

		// currently only some region thingies are supported...

		var note = 0.;
		var velocity = 0;

		switch(ev.type)
		{
			case SequencerEvent.NOTE_ON, SequencerEvent.NOTE_OFF:
				note = seq.tuning.frequencyToMidiNote(ev.data.freq);
				velocity = ev.data.velocity;
			default:
				return null;
		}

		var result = new Array<PatchEvent>();
		for (r in regions)
		{
			if (
				(r.keyrange.low <= note) &&				
				(r.keyrange.high >= note) &&
				(r.velrange.low <= velocity) &&
				(r.velrange.high >= velocity)
			)
			{
				result.push(new PatchEvent(
					new SequencerEvent(ev.type, ev.data, ev.channel, ev.id, ev.frame, ev.priority),
					r));
			}
		}

		return result;

	}

	public function toString()
	{
		var result = new Array<String>();
		for (region in regions)
		{
			result.push("Region:");
			for (n in Reflect.fields(region))
			{
				result.push(n+"="+Reflect.field(region,n));
			}
		}
		return Std.string(result);
	}

}