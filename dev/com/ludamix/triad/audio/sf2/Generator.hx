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
	
	public function getGeneratorInformation() : GeneratorRangeDefaultInfos
	{
		switch(generator_type)
		{
			case StartAddressOffset: return { unit:Smpls, min:0, max: -1, default_amount:0, context:AValue, realtime:true, instrument_only:true };
			case EndAddressOffset: return { unit:Smpls, min:0, max:-1, default_amount:0, context:AValue, realtime:true, instrument_only:true };
			case StartLoopAddressOffset: return { unit:Smpls, min:0, max:-1, default_amount:0, context:AValue, realtime:true, instrument_only:true };
			case EndLoopAddressOffset: return { unit:Smpls, min:0, max:-1, default_amount:0, context:AValue, realtime:true, instrument_only:true };
			case StartAddressCoarseOffset: return { unit:Smpls32k, min:0, max:-1, default_amount:0, context:AValue, realtime:true, instrument_only:true };
			case ModulationLFOToPitch: return { unit:CentFs, min: -12000, max:12000, default_amount:0, context:AValue, realtime:true, instrument_only:false };
			case VibratoLFOToPitch: return { unit:CentFs, min:-12000, max:12000, default_amount:0, context:AValue, realtime:true, instrument_only:false };
			case ModulationEnvelopeToPitch: return { unit:CentFs, min:-12000, max:12000, default_amount:0, context:AValue, realtime:true, instrument_only:false };
			case InitialFilterCutoffFrequency: return { unit:Cent, min:1500, max:13500, default_amount:13500, context:AValue, realtime:true, instrument_only:false };
			case InitialFilterQ: return { unit:CB, min:0, max:960, default_amount:0, context:AValue, realtime:true, instrument_only:false };
			case ModulationLFOToFilterCutoffFrequency: return { unit:CentFs, min:-12000, max:12000, default_amount:0, context:AValue, realtime:true, instrument_only:false };
			case ModulationEnvelopeToFilterCutoffFrequency: return { unit:CentFs, min:-12000, max:12000, default_amount:0, context:AValue, realtime:true, instrument_only:false };
			case EndAddressCoarseOffset: return { unit:Smpls32k, min:-1, max:-1, default_amount:0, context:AValue, realtime:true, instrument_only:true };
			case ModulationLFOToVolume: return { unit:CBFs, min:-960, max:960, default_amount:0, context:AValue, realtime:true, instrument_only:false };
			case Unused1: return null;
			case ChorusEffectsSend: return { unit:PointOnePercent, min:0, max:1000, default_amount:0, context:AValue, realtime:true, instrument_only:false };
			case ReverbEffectsSend: return { unit:PointOnePercent, min:0, max:1000, default_amount:0, context:AValue, realtime:true, instrument_only:false };
			case Pan: return { unit:PointOnePercent, min:-500, max:500, default_amount:0, context:AValue, realtime:true, instrument_only:false };
			case Unused2: return null;
			case Unused3: return null;
			case Unused4: return null;
			case DelayModulationLFO: return { unit:TimeCent, min:-12000, max:5000, default_amount:-12000, context:AValue, realtime:true, instrument_only:false };
			case FrequencyModulationLFO: return { unit:Cent, min:-16000, max:4500, default_amount:0, context:AValue, realtime:true, instrument_only:false };
			case DelayVibratoLFO: return { unit:TimeCent, min:-12000, max:5000, default_amount:-12000, context:AValue, realtime:true, instrument_only:false };
			case FrequencyVibratoLFO: return { unit:Cent, min:-16000, max:4500, default_amount:0, context:AValue, realtime:true, instrument_only:false };
			case DelayModulationEnvelope: return { unit:TimeCent, min:-12000, max:5000, default_amount:-12000, context:AValue, realtime:true, instrument_only:false };
			case AttackModulationEnvelope: return { unit:TimeCent, min:-12000, max:5000, default_amount:-12000, context:AValue, realtime:true, instrument_only:false };
			case HoldModulationEnvelope: return { unit:TimeCent, min:-12000, max:5000, default_amount:-12000, context:AValue, realtime:true, instrument_only:false };
			case DecayModulationEnvelope: return { unit:TimeCent, min:-12000, max:5000, default_amount:-12000, context:AValue, realtime:true, instrument_only:false };
			case SustainModulationEnvelope: return { unit:NegativePointOnePercent, min:0, max:1000, default_amount:0, context:AValue, realtime:true, instrument_only:false };
			case ReleaseModulationEnvelope: return { unit:TimeCent, min:-12000, max:5000, default_amount:-12000, context:AValue, realtime:true, instrument_only:false };
			case KeyNumberToModulationEnvelopeHold: return { unit:TimeCentKey, min:-1200, max:1200, default_amount:0, context:AValue, realtime:true, instrument_only:false };
			case KeyNumberToModulationEnvelopeDecay: return { unit:TimeCentKey, min:-1200, max:1200, default_amount:0, context:AValue, realtime:true, instrument_only:false };
			case DelayVolumeEnvelope: return { unit:TimeCent, min:-12000, max:5000, default_amount:-12000, context:AValue, realtime:true, instrument_only:false };
			case AttackVolumeEnvelope: return { unit:TimeCent, min:-12000, max:5000, default_amount:-12000, context:AValue, realtime:true, instrument_only:false };
			case HoldVolumeEnvelope: return { unit:TimeCent, min:-12000, max:5000, default_amount:-12000, context:AValue, realtime:true, instrument_only:false };
			case DecayVolumeEnvelope: return { unit:TimeCent, min:-12000, max:5000, default_amount:-12000, context:AValue, realtime:true, instrument_only:false };
			case SustainVolumeEnvelope: return { unit:TimeCent, min:-12000, max:5000, default_amount:-12000, context:AValue, realtime:true, instrument_only:false };
			case ReleaseVolumeEnvelope: return { unit:TimeCent, min:-12000, max:5000, default_amount:-12000, context:AValue, realtime:true, instrument_only:false };
			case KeyNumberToVolumeEnvelopeHold: return { unit:TimeCentKey, min:-1200, max:1200, default_amount:0, context:AValue, realtime:true, instrument_only:false };
			case KeyNumberToVolumeEnvelopeDecay: return { unit:TimeCentKey, min:-1200, max:1200, default_amount:0, context:AValue, realtime:true, instrument_only:false };
			case Instrument: return null;
			case Reserved1: return null;
			case KeyRange: return { unit:MidiKeyNumber, min:0, max:127, default_amount:0, context:ARange, realtime:false, instrument_only:false };
			case VelocityRange: return { unit:MidiVel, min:0, max:127, default_amount:0, context:ARange, realtime:false, instrument_only:false };
			case StartLoopAddressCoarseOffset: return { unit:Smpls32k, min:0, max:-1, default_amount:0, context:AValue, realtime:true, instrument_only:true };
			case KeyNumber: return { unit:MidiKeyNumber, min:0, max:127, default_amount:-1, context:AValue, realtime:false, instrument_only:true };
			case Velocity: return { unit:MidiVel, min:0, max:127, default_amount:-1, context:AValue, realtime:false, instrument_only:true };
			case InitialAttenuation: return { unit:CB, min:0, max:1440, default_amount:0, context:AValue, realtime:true, instrument_only:false };
			case Reserved2: return null;
			case EndLoopAddressCoarseOffset: return { unit:Smpls32k, min:0, max:-1, default_amount:0, context:AValue, realtime:true, instrument_only:true };
			case CoarseTune: return { unit:Semitone, min:-120, max:120, default_amount:0, context:AValue, realtime:true, instrument_only:false };
			case FineTune: return { unit:Cent, min:-99, max:99, default_amount:0, context:AValue, realtime:true, instrument_only:false };
			case SampleID: return { unit:ArbitraryNumber, min:0, max:-1, default_amount:0, context:AIndex, realtime:false, instrument_only:true };
			case SampleModes: return { unit:BitFlags, min:0, max:-1, default_amount:0, context:AIndex, realtime:false, instrument_only:true };
			case Reserved3: return null;
			case ScaleTuning: return { unit:CentKey, min:0, max:1200, default_amount:100, context:AValue, realtime:false, instrument_only:false };
			case ExclusiveClass: return { unit:ArbitraryNumber, min:1, max:127, default_amount:0, context:AValue, realtime:false, instrument_only:true };
			case OverridingRootKey: return { unit:MidiKeyNumber, min:0, max:127, default_amount:-1, context:AValue, realtime:false, instrument_only:true };
			case Unused5: return null;
			case UnusedEnd:	return null;
		}
	}
	
	// generator merging rules:
	
	// generators with the same enumeration in the same zone overwrite each other in the order encountered.
	// generators describing ranges are filtered into the intersection set instead of added

	public function mergeLocalIntoGlobal(other : Generator)
	{
		if (other.generator_type != this.generator_type)
			throw "merging different generator types";
	
		var result = new Generator();
		result.raw_amount = other.raw_amount;
		result.generator_type = other.generator_type;
		result.instrument = other.instrument!=null ? other.instrument : this.instrument;
		result.sample_header = other.sample_header != null ? other.sample_header : this.sample_header;
		
		return result;
	}
	
	public function mergePGENIGEN(other : Generator) : Generator
	{
		if (other.generator_type != this.generator_type)
			throw "merging different generator types";
		
		var result = new Generator();
		result.generator_type = other.generator_type;
		result.instrument = this.instrument!=null ? this.instrument : other.instrument;
		result.sample_header = this.sample_header!=null ? this.sample_header : other.sample_header;
		
		var u = other.getGeneratorInformation();
		
		switch(u.context)
		{
			case AValue: // add
						result.raw_amount = this.raw_amount + other.raw_amount;
			case ARange: // find _intersection_ set
						var one = SF2.getLSMS(this.raw_amount);
						var two = SF2.getLSMS(other.raw_amount);
						var lo_r = one[0] > two[0] ? one[0] : two[0];
						var hi_r = one[1] < two[1] ? one[1] : two[1];
						result.raw_amount = SF2.toLSMS(lo_r, hi_r);
			case AIndex: // overwrite (this really shouldn't happen in PGEN/IGEN mergers)
						result.raw_amount = other.raw_amount; 
		}
		
		return result;
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
	instrument_only:Bool
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