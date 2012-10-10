// Based on the SoundFont reader of NAudio 
//      C# Code: (C) Mark Heath 2006 (mark@wordandspirit.co.uk)
//      Haxe Code: (C) Daniel Kuschny 2012 (danielku15@coderline.net)
// You are free to use this code for your own projects.
// Please consider giving credit somewhere in your app to this code if you use it
// Please do not redistribute this code without my permission
// Please get in touch and let me know of any bugs you find, enhancements you would like,
// and apps you have written
package com.ludamix.triad.audio.sf2;

class Generator 
{
    public var generator_type:GeneratorEnum;
    public var raw_amount:Int;
    public var instrument:Instrument;
    public var sample_header:SampleHeader;

    public function new()
    {
    }
	
	public inline function getGeneratorInformation() : GeneratorRangeDefaultInfos
	{
		// NOTE: I started mapping these to SFZ parameters, however I intend to change this to internal opcode enums!
		switch(generator_type)
		{
			case StartAddressOffset: return { unit:Smpls, min:0, max: -1, default_amount:0, context:AValue, realtime:true, instrument_only:true, mapping:"start_address_offset" };
			case EndAddressOffset: return { unit:Smpls, min:0, max:-1, default_amount:0, context:AValue, realtime:true, instrument_only:true, mapping:"end_address_offset" };
			case StartLoopAddressOffset: return { unit:Smpls, min:0, max:-1, default_amount:0, context:AValue, realtime:true, instrument_only:true, mapping:"loop_start" };
			case EndLoopAddressOffset: return { unit:Smpls, min:0, max:-1, default_amount:0, context:AValue, realtime:true, instrument_only:true, mapping:"loop_end" };
			case StartAddressCoarseOffset: return { unit:Smpls32k, min:0, max:-1, default_amount:0, context:AValue, realtime:true, instrument_only:true, mapping:"start_address_offset" };
			case ModulationLFOToPitch: return { unit:CentFs, min: -12000, max:12000, default_amount:0, context:AValue, realtime:true, instrument_only:false, mapping:null };
			case VibratoLFOToPitch: return { unit:CentFs, min:-12000, max:12000, default_amount:0, context:AValue, realtime:true, instrument_only:false, mapping:null };
			case ModulationEnvelopeToPitch: return { unit:CentFs, min:-12000, max:12000, default_amount:0, context:AValue, realtime:true, instrument_only:false, mapping:"cutoff" };
			case InitialFilterCutoffFrequency: return { unit:Cent, min:1500, max:13500, default_amount:13500, context:AValue, realtime:true, instrument_only:false, mapping:"resonance" };
			case InitialFilterQ: return { unit:CB, min:0, max:960, default_amount:0, context:AValue, realtime:true, instrument_only:false, mapping:null };
			case ModulationLFOToFilterCutoffFrequency: return { unit:CentFs, min:-12000, max:12000, default_amount:0, context:AValue, realtime:true, instrument_only:false, mapping:null };
			case ModulationEnvelopeToFilterCutoffFrequency: return { unit:CentFs, min:-12000, max:12000, default_amount:0, context:AValue, realtime:true, instrument_only:false, mapping:null };
			case EndAddressCoarseOffset: return { unit:Smpls32k, min:-1, max:-1, default_amount:0, context:AValue, realtime:true, instrument_only:true, mapping:"end_address_offset" };
			case ModulationLFOToVolume: return { unit:CBFs, min:-960, max:960, default_amount:0, context:AValue, realtime:true, instrument_only:false, mapping:null };
			case Unused1: return null;
			case ChorusEffectsSend: return { unit:PointOnePercent, min:0, max:1000, default_amount:0, context:AValue, realtime:true, instrument_only:false, mapping:null };
			case ReverbEffectsSend: return { unit:PointOnePercent, min:0, max:1000, default_amount:0, context:AValue, realtime:true, instrument_only:false, mapping:null };
			case Pan: return { unit:PointOnePercent, min:-500, max:500, default_amount:0, context:AValue, realtime:true, instrument_only:false, mapping:"pan" };
			case Unused2: return null;
			case Unused3: return null;
			case Unused4: return null;
			case DelayModulationLFO: return { unit:TimeCent, min:-12000, max:5000, default_amount:-12000, context:AValue, realtime:true, instrument_only:false, mapping:null };
			case FrequencyModulationLFO: return { unit:Cent, min:-16000, max:4500, default_amount:0, context:AValue, realtime:true, instrument_only:false, mapping:null };
			case DelayVibratoLFO: return { unit:TimeCent, min:-12000, max:5000, default_amount:-12000, context:AValue, realtime:true, instrument_only:false, mapping:null };
			case FrequencyVibratoLFO: return { unit:Cent, min:-16000, max:4500, default_amount:0, context:AValue, realtime:true, instrument_only:false, mapping:null };
			case DelayModulationEnvelope: return { unit:TimeCent, min:-12000, max:5000, default_amount:-12000, context:AValue, realtime:true, instrument_only:false, mapping:null };
			case AttackModulationEnvelope: return { unit:TimeCent, min:-12000, max:5000, default_amount:-12000, context:AValue, realtime:true, instrument_only:false, mapping:null };
			case HoldModulationEnvelope: return { unit:TimeCent, min:-12000, max:5000, default_amount:-12000, context:AValue, realtime:true, instrument_only:false, mapping:null };
			case DecayModulationEnvelope: return { unit:TimeCent, min:-12000, max:5000, default_amount:-12000, context:AValue, realtime:true, instrument_only:false, mapping:null };
			case SustainModulationEnvelope: return { unit:NegativePointOnePercent, min:0, max:1000, default_amount:0, context:AValue, realtime:true, instrument_only:false, mapping:null };
			case ReleaseModulationEnvelope: return { unit:TimeCent, min:-12000, max:5000, default_amount:-12000, context:AValue, realtime:true, instrument_only:false, mapping:null };
			case KeyNumberToModulationEnvelopeHold: return { unit:TimeCentKey, min:-1200, max:1200, default_amount:0, context:AValue, realtime:true, instrument_only:false, mapping:null };
			case KeyNumberToModulationEnvelopeDecay: return { unit:TimeCentKey, min:-1200, max:1200, default_amount:0, context:AValue, realtime:true, instrument_only:false, mapping:null };
			case DelayVolumeEnvelope: return { unit:TimeCent, min:-12000, max:5000, default_amount:-12000, context:AValue, realtime:true, instrument_only:false, mapping:"ampeg_start" };
			case AttackVolumeEnvelope: return { unit:TimeCent, min:-12000, max:5000, default_amount:-12000, context:AValue, realtime:true, instrument_only:false, mapping:"ampeg_attack" };
			case HoldVolumeEnvelope: return { unit:TimeCent, min:-12000, max:5000, default_amount:-12000, context:AValue, realtime:true, instrument_only:false, mapping:"ampeg_hold" };
			case DecayVolumeEnvelope: return { unit:TimeCent, min:-12000, max:5000, default_amount:-12000, context:AValue, realtime:true, instrument_only:false, mapping:"ampeg_decay" };
			case SustainVolumeEnvelope: return { unit:TimeCent, min:-12000, max:5000, default_amount:-12000, context:AValue, realtime:true, instrument_only:false, mapping:"ampeg_sustain" };
			case ReleaseVolumeEnvelope: return { unit:TimeCent, min:-12000, max:5000, default_amount:-12000, context:AValue, realtime:true, instrument_only:false, mapping:"ampeg_release" };
			case KeyNumberToVolumeEnvelopeHold: return { unit:TimeCentKey, min:-1200, max:1200, default_amount:0, context:AValue, realtime:true, instrument_only:false, mapping:null };
			case KeyNumberToVolumeEnvelopeDecay: return { unit:TimeCentKey, min:-1200, max:1200, default_amount:0, context:AValue, realtime:true, instrument_only:false, mapping:null };
			case Instrument: return null;
			case Reserved1: return null;
			case KeyRange: return { unit:MidiKeyNumber, min:0, max:127, default_amount:0, context:ARange, realtime:false, instrument_only:false, mapping:"keyrange" };
			case VelocityRange: return { unit:MidiVel, min:0, max:127, default_amount:0, context:ARange, realtime:false, instrument_only:false, mapping:"velrange" };
			case StartLoopAddressCoarseOffset: return { unit:Smpls32k, min:0, max:-1, default_amount:0, context:AValue, realtime:true, instrument_only:true, mapping:"loop_start" };
			case KeyNumber: return { unit:MidiKeyNumber, min:0, max:127, default_amount:-1, context:AValue, realtime:false, instrument_only:true, mapping:null };
			case Velocity: return { unit:MidiVel, min:0, max:127, default_amount:-1, context:AValue, realtime:false, instrument_only:true, mapping:null };
			case InitialAttenuation: return { unit:CB, min:0, max:1440, default_amount:0, context:AValue, realtime:true, instrument_only:false, mapping:"value" };
			case Reserved2: return null;
			case EndLoopAddressCoarseOffset: return { unit:Smpls32k, min:0, max:-1, default_amount:0, context:AValue, realtime:true, instrument_only:true, mapping:"loop_end" };
			case CoarseTune: return { unit:Semitone, min:-120, max:120, default_amount:0, context:AValue, realtime:true, instrument_only:false, mapping:"transpose" };
			case FineTune: return { unit:Cent, min:-99, max:99, default_amount:0, context:AValue, realtime:true, instrument_only:false, mapping:"tune" };
			case SampleID: return { unit:ArbitraryNumber, min:0, max:-1, default_amount:0, context:AIndex, realtime:false, instrument_only:true, mapping:null };
			case SampleModes: return { unit:BitFlags, min:0, max:-1, default_amount:0, context:AIndex, realtime:false, instrument_only:true, mapping:null };
			case Reserved3: return null;
			case ScaleTuning: return { unit:CentKey, min:0, max:1200, default_amount:100, context:AValue, realtime:false, instrument_only:false, mapping:null };
			case ExclusiveClass: return { unit:ArbitraryNumber, min:1, max:127, default_amount:0, context:AValue, realtime:false, instrument_only:true, mapping:null };
			case OverridingRootKey: return { unit:MidiKeyNumber, min:0, max:127, default_amount:-1, context:AValue, realtime:false, instrument_only:true, mapping:null };
			case Unused5: return null;
			case UnusedEnd:	return null;
		}
	}
	
	// generator merging rules:
	
	// generators with the same enumeration in the same zone overwrite each other in the order encountered.
	// generators in PGEN(presets) are additive to generators in IGEN(instruments)
	// generators in global zones overwrite their default generator
	// generators in local zones overwrite both the global and default generator
	// generators describing ranges are filtered into the intersection set instead of added
	
	public function merge(other : Generator)
	{
		if (other.generator_type != this.generator_type)
			throw "merging different generator types";
		// TODO add merge rules
	}
	
	public function mergeOverwrite(other : Generator)
	{
		var result = new Generator();
		result.generator_type = other.generator_type;
		result.raw_amount = other.raw_amount;
		result.instrument = other.instrument != null ? other.instrument : this.instrument;
		result.sample_header = other.sample_header != null ? other.sample_header : this.sample_header;
	}
	
	public function mergeAdditive(other : Generator)
	{
		
	}
	
}

enum GeneratorZoneContext
{
	ZoneGlobal;
	ZoneLocal;
}

enum GeneratorGENContext
{
	PGEN;
	IGEN;
}

enum GeneratorAmountContext
{
	ARange;
	AIndex;
	AValue;
}

typedef GeneratorRangeDefaultInfos =
{
	unit:GeneratorUnit,
	min:Int,
	max:Int,
	default_amount:Int,
	context:GeneratorAmountContext,
	realtime:Bool,
	instrument_only:Bool,
	mapping:String
}

enum GeneratorUnit
{
	Smpls;
	Smpls32k;
	CentFs;
	Cent;
	CentKey;
	CB;
	CBFs;
	CBAttn;
	PointOnePercent;
	NegativePointOnePercent;
	TimeCent;
	TimeCentKey;
	MidiKeyNumber;
	MidiVel;
	Semitone;
	BitFlags;
	ArbitraryNumber;
}