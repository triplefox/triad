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
	
	public function configureSamples(sfz : SFZ, sampleFileParser : String -> PatchGenerator)
	{
		for (n in sfz.getSampleManifest())
		{
			if (!samples.exists(n))
			{
				var content : PatchGenerator = sampleFileParser(n);
				samples.set(n, content.settings);
			}
		}
	}

	public function configureSFZ(sfz: SFZ, program : Int)
	{
		this.programs.set(program, sfz.emitOpcodeGroup(seq, samples));
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