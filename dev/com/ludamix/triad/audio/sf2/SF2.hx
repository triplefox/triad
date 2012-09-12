// Based on the SoundFont reader of NAudio 
//      C# Code: (C) Mark Heath 2006 (mark@wordandspirit.co.uk)
//      Haxe Code: (C) Daniel Kuschny 2012 (danielku15@coderline.net)
// You are free to use this code for your own projects.
// Please consider giving credit somewhere in your app to this code if you use it
// Please do not redistribute this code without my permission
// Please get in touch and let me know of any bugs you find, enhancements you would like,
// and apps you have written
package com.ludamix.triad.audio.sf2;

import com.ludamix.triad.audio.SamplerOpcodeGroup;
import com.ludamix.triad.audio.SamplerSynth;
import com.ludamix.triad.audio.Sequencer;
import com.ludamix.triad.audio.MIDITuning;
import com.ludamix.triad.audio.SoundSample;
import com.ludamix.triad.audio.VoiceCommon;
import com.ludamix.triad.audio.sf2.GeneratorEnum;
import com.ludamix.triad.audio.sf2.ModulatorType;
import com.ludamix.triad.audio.sf2.TransformEnum;
import nme.utils.ByteArray;
import nme.utils.Endian;
import nme.Vector;

typedef SF2Bank = IntHash<SamplerOpcodeGroup>;

class SF2 
{
    public var info:InfoChunk;
    public var presets_chunk:PresetsChunk;
    public var sample_data:SampleDataChunk;
    public var usable_samples:Array<SoundSample>;
	public var usable_banks:IntHash<SF2Bank>;
	public var sequencer : Sequencer;

    public function new() 
    {
    }
    
    public static function load(seq : Sequencer, data:ByteArray) : SF2
    {
        var sf2 = new SF2();
		sf2.sequencer = seq;
		data.endian = Endian.LITTLE_ENDIAN;
        var riff:RiffChunk = RiffChunk.getTopLevelChunk(data);
        if(riff.chunk_id == "RIFF") 
        {
            var form_header:String = riff.readChunkID();
            if(form_header != "sfbk") 
            {
                throw "Not a SoundFont (" + form_header + ")";
            }
            var list:RiffChunk = riff.getNextSubChunk();
            if(list.chunk_id == "LIST") 
            {
                sf2.info = new InfoChunk(list);

                var r:RiffChunk = riff.getNextSubChunk();
                sf2.sample_data = new SampleDataChunk(r);

                r = riff.getNextSubChunk();
                sf2.presets_chunk = new PresetsChunk(r);
            }
            else 
            {
                throw "Not info list found (" + list.chunk_id + ")";
            }
        }
        else
        {
            throw "Not a RIFF file";
        }
        
        return sf2;
    }
	
	public function init(seq : Sequencer, mip_levels : Int)
	{
		var tuning = seq.tuning;
		
		// SF2 spec adds a lot of complexity via the linked sample construct.
		// When samples are linked, we toss out the data for one of the sample headers
		// to construct a unified SoundSample. According to Creative spec this should
		// be based on the right channel's sample always.
		
		// in the first pass, we extract the PCM data to a Vector<Float> array, do a preliminary assignment,
		//		and detect which samples will need a reassignment.
		
		var sample_array = new Array<{left:Vector<Float>,right:Vector<Float>,header:SampleHeader}>();
		var reassigns = new IntHash<{from:Int,to:Int}>();
		var sample_idx = 0;
		
		this.sample_data.sample_data.endian = Endian.LITTLE_ENDIAN;
		
		for (sh in this.presets_chunk.sample_headers.data)
		{
			var start = sh.start;
			var end = sh.end;
			
			sh.triad_start_loop = sh.start_loop - sh.start;
			sh.triad_end_loop = sh.end_loop - sh.start - 1;
			
			var vec = new Vector<Float>();
			this.sample_data.sample_data.position = sh.start * 2;
			for (n in start...end)
			{
				vec.push(this.sample_data.sample_data.readShort() / 32768.);
			}
			//trace(["*****", sh.sample_name, start, end, sh.triad_start_loop, sh.triad_end_loop, vec.length, vec[vec.length-1]]);
			
			sample_array.push({left:vec,right:vec,header:sh});
			
			if (sh.sf_sample_type == SFSampleLink.LEFT_SAMPLE)
			{
				if (sh.sample_link == sample_idx) 
				{
					log("sample #${sample_idx} ${sh.sample_name} tried to link to itself - corrupt?");
				}
				else
					reassigns.set(sample_idx, {from:sample_idx,to:sh.sample_link});
			}
			
			sample_idx++;
		}
		
		// in the second pass, we use reassignment data to create a stereo sample.
		
		for (ra in reassigns)
		{
			sample_array[ra.to].left = sample_array[ra.from].left;
		}
		
		// in the third pass, we emit the unique SoundSamples and ignore the linked ones momentarily.
		
		var result = new Array<SoundSample>();
		var sample_idx = 0;
		for (cur_smp in sample_array)
		{
			if (reassigns.exists(sample_idx)) // don't emit the linked yet
			{
				result.push(null);
			}
			else
			{
				var left = cur_smp.left; var right = cur_smp.right; var sh = cur_smp.header;
				var sample = SoundSample.ofVector(left,right,sh.sample_rate,
					tuning.midiNoteBentToFrequency(sh.original_pitch, sh.pitch_correction),
					sh.sample_name, mip_levels, [
						{loop_mode:SoundSample.LOOP_FORWARD,
						 loop_start:sh.triad_start_loop,loop_end:sh.triad_end_loop}]);
				result.push(sample);
			}
			
			sample_idx++;
		}
		
		// in the fourth pass, we clean up the references for the reassigned(linked) samples.
		
		for (r in reassigns.keys())
		{
			result[r] = result[reassigns.get(r).to];
		}
		
		this.usable_samples = result;
		
		// we give the headers a reference to the result so that it's easier to create the samplepatch later.
		
		var sample_idx = 0;
		for (cur_smp in sample_array)
		{
			cur_smp.header.triad_soundsample = usable_samples[sample_idx];
			sample_idx++;
		}
		
		// now create the preset cache
		
		usable_banks = new IntHash();
		
		for (p in presets_chunk.preset_headers.data) 
		{
			var bank : SF2Bank = null;
			if (usable_banks.exists(p.bank))
				bank = usable_banks.get(p.bank);
			else
				{ bank = new SF2Bank(); usable_banks.set(p.bank, bank); }
			bank.set(p.patch_number, parsePreset(seq, p));
		}
		
	}
	
	public static inline function secondsOfTimeCents(data : Float) { return Math.pow(2.0, data / 1200.0); }
	public static inline function attentuationCBtoPct(data : Float) { return Math.pow(2.0, CBtoDB(data)); }
	public static inline function DBtoCB(data : Float) { return data * 10.; }
	public static inline function CBtoDB(data : Float) { return data / 10.; }
	public static inline function getLSMS(lsms : Int) { return [ lsms & 0xFF, lsms >> 8 ]; }
	
	inline function parseZone(seq : Sequencer, z : Zone) : Hash<Dynamic>
	{
		var cur_zone = new Hash<Dynamic>();
		
		var loop_coarse_start = 0;
		var loop_fine_start = 0;
		var loop_coarse_end = 0;
		var loop_fine_end = 0;
		var sample : SoundSample = null;
		var header : SampleHeader = null;
		
		for (generator in z.generators)
		{
			if (generator == null) continue; // yeah this actually happens
			if (generator.sample_header != null)
			{
				header = generator.sample_header;
				sample = header.triad_soundsample;
				cur_zone.set("sample_data", 
					SamplerSynth.patchOfSoundSample(seq.tuning, sample));
			}
			
			// these offsets... the coarse and fine are a per-patch thing. 
			// we don't have a good mechanism for supporting the start/end address offsets right now.
			
			// a lot of these, we can ignore for now.
			
			switch(generator.generator_type)
			{
				case StartAddressOffset: trace(generator.raw_amount);
				case EndAddressOffset: trace(generator.raw_amount);
				case StartAddressCoarseOffset:
				case EndAddressCoarseOffset: trace(generator.raw_amount);
				case StartLoopAddressOffset: loop_fine_start = generator.raw_amount;
				case EndLoopAddressOffset: loop_fine_end = generator.raw_amount;
				case StartLoopAddressCoarseOffset: loop_coarse_start = generator.raw_amount;
				case EndLoopAddressCoarseOffset: loop_coarse_end = generator.raw_amount;
				case ModulationLFOToPitch:
				case VibratoLFOToPitch:
				case ModulationEnvelopeToPitch:
				case InitialFilterCutoffFrequency:
				case InitialFilterQ:
				case ModulationLFOToFilterCutoffFrequency:
				case ModulationEnvelopeToFilterCutoffFrequency:
				case ModulationLFOToVolume:
				case Unused1:
				case ChorusEffectsSend:
				case ReverbEffectsSend:
				case Pan: cur_zone.set("pan", generator.raw_amount/1000. + 0.5);
				case Unused2:
				case Unused3:
				case Unused4:
				case DelayModulationLFO:
				case FrequencyModulationLFO:
				case DelayVibratoLFO:
				case FrequencyVibratoLFO:
				case DelayModulationEnvelope:
				case AttackModulationEnvelope:
				case HoldModulationEnvelope:
				case DecayModulationEnvelope:
				case SustainModulationEnvelope:
				case ReleaseModulationEnvelope:
				case KeyNumberToModulationEnvelopeHold:
				case KeyNumberToModulationEnvelopeDecay:
				case DelayVolumeEnvelope: 
					cur_zone.set("ampeg_start", secondsOfTimeCents(generator.raw_amount));
				case AttackVolumeEnvelope: 
					cur_zone.set("ampeg_attack", secondsOfTimeCents(generator.raw_amount));
				case HoldVolumeEnvelope: 
					cur_zone.set("ampeg_hold", secondsOfTimeCents(generator.raw_amount));
				case DecayVolumeEnvelope: 
					cur_zone.set("ampeg_decay", secondsOfTimeCents(generator.raw_amount));
				case SustainVolumeEnvelope: 
					cur_zone.set("ampeg_sustain", attentuationCBtoPct(-generator.raw_amount));
				case ReleaseVolumeEnvelope:
					cur_zone.set("ampeg_release", secondsOfTimeCents(generator.raw_amount));
				case KeyNumberToVolumeEnvelopeHold:
				case KeyNumberToVolumeEnvelopeDecay:
				case Instrument:
				case Reserved1:
				case KeyRange: var lsms = getLSMS(generator.raw_amount); 
							   cur_zone.set("lokey", lsms[0]);
							   cur_zone.set("hikey", lsms[1]);
				case VelocityRange: var lsms = getLSMS(generator.raw_amount); 
							   cur_zone.set("lovel", lsms[0]);
							   cur_zone.set("hivel", lsms[1]);
				case KeyNumber:
				case Velocity:
				case InitialAttenuation:
					cur_zone.set("volume", CBtoDB(-generator.raw_amount));
					cur_zone.set("db_convention", 1.);
				case Reserved2:
				case CoarseTune: cur_zone.set("transpose", generator.raw_amount);
				case FineTune: cur_zone.set("tune", generator.raw_amount);
				case SampleID:
				case SampleModes:
				case Reserved3:
				case ScaleTuning:
				case ExclusiveClass:
				case OverridingRootKey:
					if (generator.raw_amount >= 0) cur_zone.set("pitch_keycenter", generator.raw_amount);
				case Unused5:
				case UnusedEnd:
			}
			
		}
		for (modulator in z.modulators)
		{
			if (modulator == null) continue;
			// some more things in sampler_patch get set here!
		}
		
		if (header != null)
		{
			cur_zone.set("loop_start", header.triad_start_loop + loop_coarse_start * 32768 + loop_fine_start);
			cur_zone.set("loop_end", header.triad_end_loop + loop_coarse_end * 32768 + loop_fine_end);
		}
		
		return cur_zone;
	}
	
	public function parsePreset(seq : Sequencer, p : Preset) : SamplerOpcodeGroup
	{		
		var opcode_group = new SamplerOpcodeGroup();		
		opcode_group.group_opcodes = new Hash<Dynamic>();
		
		// to review how this is laid out:
		// Each zone contains any number of generators and modulators.
		
		// each generator can contain an _optional_ sampleheader, a generator typeenum(various opcodes),
		// and a quantity.
		
		// the modulators are similar but have a source and destination parameter and a transform type,
		// but no sampleheader reference.
		
		// Our process is to parse this "loosely-coupled" system into the tighter one used by SamplerOpcodeGroup,
		// and then use SampleOpcodeGroup's method to create patch data.
		
		// One of the tricky points is to account for the difference between presets and instruments:
		// Any zone can reference an instrument, but it's presumed that only preset zones will do so.
		
		if (p.zones.length>1) log(Std.format("WARNING: more than one zone in preset ${p.name} - using last one"));
		for (z in p.zones)
		{
			// group = the preset zone
			opcode_group.group_opcodes = parseZone(seq, z);
			
			for (generator in z.generators)
			{
				if (generator.instrument != null)
				{
					// regions = the instrument zones
					for (z2 in generator.instrument.zones)
					{
						opcode_group.regions.push(parseZone(seq, z2));	
					}
				}
			}
		}
		opcode_group.cacheRegions(seq);
		
		return opcode_group;
		
	}
	
	public function getPatchOfEvent(ev : SequencerEvent, patch_number : Int, bank_number : Int) : Array<PatchEvent>
	{
		
		var result = new Array<PatchEvent>();
		var b = usable_banks.get(bank_number);
		if (b!=null)
		{
			if (b.exists(patch_number))
			{
				var opcode_group = b.get(patch_number);
				var q = opcode_group.query(ev, sequencer);
				if (q!=null)
					result = result.concat(q);
			}
		}
		
		if (result.length>0)
			trace(result[0].patch); // a clue - we don't seem to be using zones properly because multisampling is gone.
		return result;
		
	}
    
    public function getGenerator() : PatchGenerator
    {
		return new PatchGenerator(this, function(settings, seq, seq_event) : Array<PatchEvent> 
		{
			return getPatchOfEvent(seq_event, seq.channels[seq_event.channel].patch_id, 0);
		} );
    } 
	
	public function log(str : String)
	{
		trace(str);
	}
	
}