package com.ludamix.triad.audio;

import com.ludamix.triad.audio.SamplerSynth;
import com.ludamix.triad.audio.Sequencer;

class SFZBank
{

	public var samples : Hash<SamplerPatch>;
	public var programs : IntHash<SamplerOpcodeGroup>;
	public var seq : Sequencer;

	// This is a toolbox to grab and allocate samples that SFZ instances are requesting.

	public function new(seq)
	{
		this.seq = seq;
		samples = new Hash();
		programs = new IntHash();
	}
	
	public function configureSamples(sfz : Array<SFZ>, sampleFileParser : String -> PatchGenerator)
	{
		for (s in sfz)
		{
			for (n in s.getSampleManifest())
			{
				if (!samples.exists(n))
				{
					var content : PatchGenerator = sampleFileParser(n);
					samples.set(n, content.settings);
				}
			}
		}
	}

	public function configureSFZ(sfz: Array<SFZ>, programs : Array<Int>)
	{
		for (idx in 0...programs.length)
		{
			this.programs.set(programs[idx], 
				sfz[idx].emitOpcodeGroup(seq, samples));
		}
	}

	public function configureSingleSFZ(sfz: SFZ, programs : Array<Int>)
	{
		for (program in programs)
		{
			this.programs.set(program, sfz.emitOpcodeGroup(seq, samples));
		}
	}
	
	public function getProgramOfEvent(ev : SequencerEvent, program_number : Int) : Array<PatchEvent>
	{
		if (programs.exists(program_number))
			return programs.get(program_number).query(ev, seq);
		else return null;
	}

	public function getGenerator()
	{
		return new PatchGenerator(this, function(settings, seq, seq_event) : Array<PatchEvent> { 
			return getProgramOfEvent(seq_event, seq.channels[seq_event.channel].patch_id);
		} );
	}

}