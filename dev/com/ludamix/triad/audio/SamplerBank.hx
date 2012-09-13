package com.ludamix.triad.audio;

import com.ludamix.triad.audio.SamplerSynth;
import com.ludamix.triad.audio.Sequencer;

class SamplerBank
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

	public function configureSFZ(opcode_group : SamplerOpcodeGroup, programs : Array<Int>, 
		patchGenerator : String -> PatchGenerator, ?recache : Bool=true)
	{
		// build patches for each sample
		var req_samples = opcode_group.getSampleNames();
		for (n in req_samples)
		{
			if (!samples.exists(n))
			{
				var content : PatchGenerator = patchGenerator(n);
				samples.set(n, content.settings);
			}
		}
		for (program in programs)
			this.programs.set(program, opcode_group);
		if (recache) // we're creating new region data
		{
			// assign the sample_data parameter
			for (program in this.programs)
			{
				if (program.group_opcodes.exists('sample'))
					program.group_opcodes.set('sample_data', samples.get(program.group_opcodes.get('sample')));
				for (region in program.regions)
				{
					if (region.exists('sample'))
						region.set('sample_data', samples.get(region.get('sample')));
				}
			}
			opcode_group.cacheRegionsSFZ(seq);
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