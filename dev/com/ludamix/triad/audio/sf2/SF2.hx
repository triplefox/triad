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
import com.ludamix.triad.audio.Envelope;
import com.ludamix.triad.audio.sf2.GeneratorEnum;
import com.ludamix.triad.audio.sf2.ModulatorType;
import com.ludamix.triad.audio.sf2.TransformEnum;
import com.ludamix.triad.audio.MIDITuning;
import nme.utils.ByteArray;
import nme.utils.Endian;
import nme.Vector;

typedef SF2Bank = IntHash<SamplerOpcodeGroup>;
typedef MergedZone = { gen:IntHash<Generator>, mod:IntHash<Modulator> };

typedef SF2Envelope = {delay:Float,attack:Float,hold:Float,decay:Float,sustain:Float,release:Float};

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
						{loop_mode:SoundSample.NO_LOOP,
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
	public static inline function attentuationCBtoPctPower(data : Float) { return 1.0 * Math.pow(10, CBtoDB(data)/20.);  }
	public static inline function attentuationDBtoPctPower(data : Float) { return 1.0 * Math.pow(10, data/20.);  }
	public static inline function DBtoCB(data : Float) { return data * 10.; }
	public static inline function CBtoDB(data : Float) { return data / 10.; }
	public static inline function getLSMS(lsms : Int) { return [ lsms & 0xFF, lsms >> 8 ]; } // high, low
	public static inline function toLSMS(low : Int, high : Int) { return (high << 8) | (low); }
	
	// generator merging rules:
	// generators in global zones overwrite their default generator
	// generators in local zones overwrite both the global and default generator
	
	inline function mergeLocalGlobalZone(zlocal : Zone, zglobal : Zone) : MergedZone
	{
		var gen_zone = new IntHash<Generator>();
		var mod_zone = new IntHash<Modulator>();
		
		var gen_zl = zlocal.generatorsAsIntHash();
		var gen_zg = zglobal.generatorsAsIntHash();
		
		for (k in gen_zl.keys())
		{
			if (gen_zg.exists(k))
				gen_zone.set(k, gen_zg.get(k).mergeLocalIntoGlobal(gen_zl.get(k)));
			else
				gen_zone.set(k, gen_zl.get(k));
		}
		for (k in gen_zg.keys())
		{
			if (!gen_zl.exists(k))
				gen_zone.set(k, gen_zg.get(k));
		}
		
		return {gen:gen_zone,mod:mod_zone };
	}
	
	// generator merging rules:
	// generators in PGEN(presets) are additive to generators in IGEN(instruments)
	
	inline function mergeInstrumentPreset(inst : MergedZone, preset : MergedZone) : MergedZone
	{
		var result_gen = new IntHash<Generator>();
		var result_mod = new IntHash<Modulator>();
		for (k in inst.gen.keys())
		{
			if (preset.gen.exists(k))
				result_gen.set(k, inst.gen.get(k).mergePGENIGEN(preset.gen.get(k)));
			else
				result_gen.set(k, inst.gen.get(k));
		}
		for (k in preset.gen.keys())
		{
			if (!inst.gen.exists(k))
				result_gen.set(k, preset.gen.get(k));
		}
		
		return {gen:result_gen, mod:result_mod};
	}
	
	inline function parseZone(seq : Sequencer, ilocal : Zone, iglobal : Zone, plocal : Zone, pglobal : Zone) : SamplerPatch
	{
		var inst : MergedZone  = mergeLocalGlobalZone(ilocal, iglobal);
		var preset : MergedZone  = mergeLocalGlobalZone(plocal, pglobal);
		
		var merged : MergedZone = mergeInstrumentPreset(inst, preset);
		
		// this next part is like the SFZ parser, more or less.
		
		// we follow a similar process:
		// 1. find the SoundSample. (this is done in init() already, we just need to get the header)
		// 2. buffer generator changes
		// 3. apply them all to a final SamplerPatch.
		
		var loop_coarse_start = 0;
		var loop_fine_start = 0;
		var loop_coarse_end = 0;
		var loop_fine_end = 0;
		var sample : SoundSample = null;
		var header : SampleHeader = null;
		
		var fil_type : Int = VoiceCommon.FILTER_UNDEFINED;
		var fil_cutoff : Float = 0.;
		var fil_resonance : Float = 0.;
		var pan = 0.5;
		
		var lo_key = 0;
		var hi_key = 127;
		var lo_vel = 0;
		var hi_vel = 127;
		
		var volume = 1.;
		var transpose = 0.;
		var tune = 0.;
		var tune_addition = 0.;
		var pitch_keycenter = 60.;
		var pitch_keycenter_override = -1.;
		var sample_rate = 44100;
		
		var ampeg : SF2Envelope = { delay:0., attack:0., hold:0., decay:0., sustain:1., release:0. };
		var loop_mode = SamplerSynth.LOOP_UNSPECIFIED;
		
		for (g in merged.gen)
		{
			if (g.sample_header != null)
			{
				header = g.sample_header;
				sample = header.triad_soundsample;
				if (header.original_pitch <= 127 && header.original_pitch >= 0) pitch_keycenter = header.original_pitch;
				tune = -header.pitch_correction/100.;
				sample_rate = header.sample_rate;
			}
			
			switch(g.generator_type)
			{
				case StartAddressOffset: trace(g.raw_amount);
				case EndAddressOffset: trace(g.raw_amount);
				case StartAddressCoarseOffset:
				case EndAddressCoarseOffset: trace(g.raw_amount);
				case StartLoopAddressOffset: loop_fine_start = g.raw_amount;
				case EndLoopAddressOffset: loop_fine_end = g.raw_amount;
				case StartLoopAddressCoarseOffset: loop_coarse_start = g.raw_amount;
				case EndLoopAddressCoarseOffset: loop_coarse_end = g.raw_amount;
				case ModulationLFOToPitch:
				case VibratoLFOToPitch:
				case ModulationEnvelopeToPitch:
				case InitialFilterCutoffFrequency: fil_cutoff = g.raw_amount;
				case InitialFilterQ: fil_resonance = CBtoDB(g.raw_amount);
				case ModulationLFOToFilterCutoffFrequency:
				case ModulationEnvelopeToFilterCutoffFrequency:
				case ModulationLFOToVolume:
				case Unused1:
				case ChorusEffectsSend:
				case ReverbEffectsSend:
				case Pan: pan = g.raw_amount / 1000. + 0.5;
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
					ampeg.delay = secondsOfTimeCents(g.raw_amount);
				case AttackVolumeEnvelope: 
					ampeg.attack = secondsOfTimeCents(g.raw_amount);
				case HoldVolumeEnvelope: 
					ampeg.hold = secondsOfTimeCents(g.raw_amount);
				case DecayVolumeEnvelope: 
					ampeg.decay = secondsOfTimeCents(g.raw_amount);
				case SustainVolumeEnvelope: 
					ampeg.sustain = attentuationCBtoPctPower( -g.raw_amount);
				case ReleaseVolumeEnvelope:
					ampeg.release = secondsOfTimeCents(g.raw_amount);
				case KeyNumberToVolumeEnvelopeHold:
				case KeyNumberToVolumeEnvelopeDecay:
				case Instrument:
				case Reserved1:
				case KeyRange: var lsms = getLSMS(g.raw_amount); 
							   lo_key = lsms[0];
							   hi_key = lsms[1];
				case VelocityRange: var lsms = getLSMS(g.raw_amount); 
							   lo_vel = lsms[0];
							   hi_vel = lsms[1];
				case KeyNumber:
				case Velocity:
				case InitialAttenuation: volume = attentuationCBtoPctPower( -g.raw_amount);
				case Reserved2:
				case CoarseTune: transpose = g.raw_amount;
				case FineTune: tune_addition = g.raw_amount/100.;
				case SampleID:
				case SampleModes:
					switch(g.raw_amount)
					{
						case 0, 2: loop_mode = SamplerSynth.NO_LOOP;
						case 1: loop_mode = SamplerSynth.LOOP_FORWARD;
						case 3: loop_mode = SamplerSynth.SUSTAIN_FORWARD;
					}
				case Reserved3:
				case ScaleTuning:
				case ExclusiveClass:
				case OverridingRootKey:
					if (g.raw_amount >= 0 && g.raw_amount < 128) pitch_keycenter_override = g.raw_amount;
				case Unused5:
				case UnusedEnd:
			}
		}
		
		// TODO: merge and apply modulators correctly
		
		if (pitch_keycenter_override >= 0.) pitch_keycenter = pitch_keycenter_override;
		
		var patch : SamplerPatch = patchDefault();
		patch.sample = sample;
		patch.tuning = { sample_rate:sample_rate, 
			base_frequency: EvenTemperament.cache.midiNoteToFrequency(pitch_keycenter - transpose - tune - tune_addition) };
		
		patch.name = "";
		
		if (header != null)
		{
			var loop_start = header.triad_start_loop + loop_coarse_start * 32768 + loop_fine_start;
			var loop_end = header.triad_end_loop + loop_coarse_end * 32768 + loop_fine_end;
			patch.loops = [{loop_mode:loop_mode,loop_start:loop_start,loop_end:loop_end}];
			patch.name = header.sample_name;
			trace(header.sample_name);
		}
		
		patch.pan = pan;
		patch.volume = volume;
		patch.envelope_profiles.push(genAmpeg(ampeg));
		//patch.cutoff_frequency = fil_cutoff;
		//patch.resonance_level = fil_resonance;
		patch.keyrange.low = lo_key;
		patch.keyrange.high = hi_key;
		patch.velrange.low = lo_vel;
		patch.velrange.high = hi_vel;
		
		return patch;
	}
	
	public function genAmpeg(env : SF2Envelope) : EnvelopeProfile
	{
		return Envelope.DSAHDSHR(function(a:Float) { return a; }, 
			sequencer.secondsToFrames(env.delay), 
			0., 
			sequencer.secondsToFrames(env.attack), 
			sequencer.secondsToFrames(env.hold), 
			sequencer.secondsToFrames(env.decay), env.sustain, 0., 
			sequencer.secondsToFrames(env.release), 1.0, 1.0, 1.0, 
			[VoiceCommon.AS_VOLUME_ADD]);	
	}
	
	public static function patchDefault() : SamplerPatch
	{
		return {
			sample:null,
			tuning:null,
			loops:null,
			pan:0.5,
			envelope_profiles:new Array<EnvelopeProfile>(),
			volume:1.0,
			lfos:new Array<LFO>(),
			modulation_lfos:[{frequency:6.,depth:0.5,delay:0.05,attack:0.05,assigns:[VoiceCommon.AS_PITCH_ADD]}],
			arpeggiation_rate:0.0,
			cutoff_frequency:0.,
			resonance_level:0.,
			keyrange:{low:0.,high:127.},
			velrange:{low:0.,high:127.},
			filter_mode:VoiceCommon.FILTER_UNDEFINED,
			name:null
		};
	}
	
	public function parsePreset(seq : Sequencer, p : Preset) : SamplerOpcodeGroup
	{		
		var opcode_group = new SamplerOpcodeGroup();		
		
		// separate the preset layers into global and local
		
		var p_g = new Zone();
		var p_l = new Array<Zone>();
		
		if (p.zones.length > 1)
		{
			p_g = p.zones[0];
			for (n in 1...p.zones.length)
				p_l.push(p.zones[n]);
		}
		else p_l.push(p.zones[0]);
		
		// now drill down into the instruments of each local preset
		
		for (preset in p_l)
		{
			if (preset != null)
			{
				for (g in preset.generators)
				{
					if (g.instrument != null)
					{
						// separate the instrument zones as done with the presets
						
						var i_g = new Zone();
						var i_l = new Array<Zone>();
						
						if (g.instrument.zones.length > 1)
						{
							i_g = g.instrument.zones[0];
							for (n in 1...g.instrument.zones.length)
								i_l.push(g.instrument.zones[n]);
						}
						else i_l.push(g.instrument.zones[0]);
						
						// then make a region 
						for (instrument in i_l)
						{
							var r = parseZone(seq, instrument, i_g, preset, p_g);
							r.name = Std.format("${p.name}_${g.instrument.name}");
							opcode_group.regions.push(r); 
							//trace([r.tuning, r.cutoff_frequency, r.resonance_level, r.filter_mode, r.name, r.keyrange]);
						}
					}
				}
			}
		}
		//throw null;
		
		return opcode_group;
		
	}
	
	public function getPatchOfEvent(ev : SequencerEvent, patch_number : Int, bank_number : Int) : Array<PatchEvent>
	{
		
		var result = new Array<PatchEvent>();
		var b = usable_banks.get(bank_number);
		if (b!=null)
		{
			//trace(Std.format("${ev.channel}:${bank_number}:${patch_number}"));
			if (b.exists(patch_number))
			{
				var opcode_group = b.get(patch_number);
				var q = opcode_group.query(ev, sequencer);
				if (q!=null)
					result = result.concat(q);
			}
		}
		
		return result;
		
	}
    
    public function getGenerator() : PatchGenerator
    {
		return new PatchGenerator(this, function(settings, seq, seq_event) : Array<PatchEvent> 
		{
			return getPatchOfEvent(seq_event, 
				seq.channels[seq_event.channel].patch_id, 
				seq.channels[seq_event.channel].bank_id);
		} );
    } 
	
	public function log(str : String)
	{
		trace(str);
	}
	
}