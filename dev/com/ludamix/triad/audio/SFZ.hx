package com.ludamix.triad.audio;

import com.ludamix.triad.format.WAV;
import haxe.Json;
import nme.Assets;
import nme.utils.ByteArray;

import com.ludamix.triad.audio.SamplerSynth;
import com.ludamix.triad.audio.Sequencer;
import com.ludamix.triad.audio.MIDITuning;
import com.ludamix.triad.audio.Envelope;
import haxe.io.Bytes;
import haxe.io.BytesInput;

typedef TString = com.ludamix.triad.tools.StringTools;
typedef HString = StringTools;

class SFZ
{

	public static function interpret_type(seq : Sequencer, key : String, value : String) : Dynamic
	{

		// note name mapping?
		var tuning = seq.tuning;
		var ct = 0;
		var upper = value.toUpperCase();
		for (n in tuning.notename)
		{
			if (upper == n) { return ct; }
			ct++;
		}

		return TString.parseIntFloatString(value);
	}
    
    private static function readString(file:ByteArray, len:Int) : String
    {
        var s = new StringBuf();
        
        for (i in 0 ... len)
        {
            s.addChar(file.readByte());
        }
        
        return s.toString();
    }
    
    public static function loadCompressed(seq:Sequencer, file : ByteArray, programs:Array<Int> = null) : SamplerBank
    {
        var sfzBank = new SamplerBank(seq);
        
        file.position = 0;
        
        var groups:Array<SamplerOpcodeGroup> = new Array<SamplerOpcodeGroup>();
        var waves:Hash<WAVE> = new Hash<WAVE>();
        
        // read all SFZDefinitionBlocks
        var blockCount = file.readInt();
        for (i in 0 ... blockCount)
        {
            var sfzSize = file.readInt();
            var sfz = readString(file, sfzSize);
            groups.push(loadFromData(seq, sfz)[0]);
        }
        
        // read all WaveFileBlocks
        blockCount = file.readInt();
        for (i in 0 ... blockCount)
        {
            var nameLength = file.readInt();
            var name = readString(file, nameLength);
            
            var byteCount = file.readInt();
            var bytes = new ByteArray();
            file.readBytes(bytes, 0, byteCount);
            
            waves.set(name, WAV.read(bytes));
        }
        
        // assign groups to bank
        for (i in 0 ... groups.length)
        {
            var groupPrograms:Array<Int>;
            if (programs != null)
            {
                groupPrograms = programs;
            }
            else
            {
                groupPrograms = [i];
            }
            sfzBank.configureSFZ(groups[i], groupPrograms, function(n) : PatchGenerator {
                var header = waves.get(n);
                return SamplerSynth.ofWAVE(seq.tuning, header, n);
            });
        }
        
        return sfzBank;
    }

	public static function load(seq : Sequencer, file : ByteArray) : Array<SamplerOpcodeGroup>
    {
		file.position = 0;
		return loadFromData(seq, file.readUTFBytes(file.length));
    }
    
	public static function loadFromData(seq : Sequencer, str:String) : Array<SamplerOpcodeGroup>
	{
		var lines = str.split("\n");

		var HEAD = 0;
		var GROUP = 1;
		var REGION = 2;

		var groups = new Array<SamplerOpcodeGroup>();

		var ctx = HEAD;
		var cur_group : SamplerOpcodeGroup = null;
		var cur_region : Hash<Dynamic> = null;

		for (l in lines)
		{
			l = HString.trim(l);
			if (l.length == 0 || HString.startsWith(l, "//")) { } // pass
			else if (HString.startsWith(l, "<group>")) { 
				cur_group = new SamplerOpcodeGroup(); groups.push(cur_group); 
				ctx = GROUP;  } // group
			else if (HString.startsWith(l, "<region>")) { 
				if (cur_group == null) { cur_group = new SamplerOpcodeGroup(); groups.push(cur_group); }
				cur_region = new Hash<Dynamic>(); 
				cur_group.regions.push(cur_region); ctx = REGION;  } // region
			else if (l.indexOf("=") >= 0) // opcode
			{
				var parts = l.split("=");
				parts[1] = HString.trim(parts[1].split("//")[0]); // eliminate comments
				if (ctx == GROUP)
				{
					cur_group.group_opcodes.set(parts[0],interpret_type(seq, parts[0], parts[1]));
				}
				else if (ctx == REGION)
				{
					cur_region.set(parts[0],interpret_type(seq, parts[0], parts[1]));
				}
			}
		}

		return groups;

	}
	
	public static function getOpcodeInformation(o : SFZOpcode) : SFZUnit
	{
	/*
		switch(o)
		{
			case Sample: return Filename("");
			case LoChan: return MIDI127Range(0);
			case HiChan: // TODO finish this infos...
			case LoKey:
			case HiKey:
			case Key:
			case LoVel:
			case HiVel:
			case LoBend:
			case HiBend:
			case LoChanAft:
			case HiChanAft:
			case LoPolyAft:
			case HiPolyAft:
			case LoRand:
			case HiRand:
			case LoBpm:
			case HiBpm:
			case SeqLength:
			case SeqPosition:
			case SwLoKey:
			case SwHiKey:
			case SwLast:
			case SwDown:
			case SwUp:
			case SwPrevious:
			case SwVel:
			case Trigger:
			case Group:
			case OffBy:
			case OffMode:
			case OnLoccN:
			case OnHiccN:
			case Delay:
			case DelayRandom:
			case DelayccN:
			case Offset:
			case OffsetRandom:
			case OffsetccN:
			case End:
			case Count:
			case LoopMode:
			case LoopStart:
			case LoopEnd:
			case SyncBeats:
			case SyncOffset:
			case Transpose:
			case Tune:
			case PitchKeyCenter:
			case PitchKeyTrack:
			case PitchVelTrack:
			case PitchRandom:
			case BendUp:
			case BendDown:
			case BendStep:
			case PitchEgDelay:
			case PitchEgStart:
			case PitchEgAttack:
			case PitchEgHold:
			case PitchEgDecay:
			case PitchEgSustain:
			case PitchEgRelease:
			case PitchEgDepth:
			case PitchEgVel2Delay:
			case PitchEgVel2Attack:
			case PitchEgVel2Hold:
			case PitchEgVel2Decay:
			case PitchEgVel2Sustain:
			case PitchEgVel2Release:
			case PitchEgVel2Depth:
			case PitchLfoDelay:
			case PitchLfoFade:
			case PitchLfoFreq:
			case PitchLfoDepth:
			case PitchLfoDepthccN:
			case PitchLfoDepthChanAft:
			case PitchLfoDepthPolyAft:
			case PitchLfoFreqccN:
			case PitchLfoFreqChanAft:
			case PitchLfoFreqPolyAft:
			case FilType:
			case Cutoff:
			case CutoffccN:
			case CutoffChanAft:
			case CutoffPolyAft:
			case Resonance:
			case FilKeyTrack:
			case FilKeyCenter:
			case FilVelTrack:
			case FilRandom:
			case FilEgDelay:
			case FilEgStart:
			case FilEgAttack:
			case FilEgHold:
			case FilEgDecay:
			case FilEgSustain:
			case FilEgRelease:
			case FilEgVel2Delay:
			case FilEgVel2Attack:
			case FilEgVel2Hold:
			case FilEgVel2Decay:
			case FilEgVel2Sustain:
			case FilEgVel2Release:
			case FilEgVel2Depth:
			case FilLfoDelay:
			case FilLfoFade:
			case FilLfoFreq:
			case FilLfoDepth:
			case FilLfoDepthccN:
			case FilLfoDepthChanAft:
			case FilLfoDepthPolyAft:
			case FilLfoFreqccN:
			case FilLfoFreqChanAft:
			case FilLfoFreqPolyAft:
			case Volume:
			case Pan:
			case Width:
			case Position:
			case AmpKeyTrack:
			case AmpKeyCenter:
			case AmpVelTrack:
			case AmpVelCurve(velocity):
			case AmpRandom:
			case RtDelay:
			case Output:
			case GainccN:
			case XFInLoKey:
			case XFInHiKey:
			case XFOutLoKey:
			case XFOutHiKey:
			case XFKeyCurve:
			case XFInLoVel:
			case XFInHiVel:
			case XFOutLoVel:
			case XFOutHiVel:
			case XFVelCurve:
			case XFInLoccN:
			case XFInHiccN:
			case XFOutLoccN:
			case XFOutHiccN:
			case XFCCCurve:
			case AmpegDelay:
			case AmpegStart:
			case AmpegAttack:
			case AmpegHold:
			case AmpegDecay:
			case AmpegSustain:
			case AmpegRelease:
			case AmpegVel2Delay:
			case AmpegVel2Attack:
			case AmpegVel2Hold:
			case AmpegVel2Decay:
			case AmpegVel2Sustain:
			case AmpegVel2Release:
			case AmpegDelayccN:
			case AmpegStartccN:
			case AmpegAttackccN:
			case AmpegHoldccN:
			case AmpegDecayccN:
			case AmpegSustainccN:
			case AmpegReleaseccN:
			case AmpLfoDelay:
			case AmpLfoFade:
			case AmpLfoFreq:
			case AmpLfoDepth:
			case AmpLfoDepthccN:
			case AmpLfoDepthChanAft:
			case AmpLfoDepthPolyAft:
			case AmpLfoFreqccN: 
			case AmpLfoFreqChanAft:
			case AmpLfoFreqPolyAft:
			case EqFreq(band):
			case EqFreqccN(band):
			case EqVel2Freq(band):
			case EqBw(band):
			case EqBwccN(band):
			case EqGain(band):
			case EqGainccN(band):
			case EqVel2Gain(band):
			case Effect1:
			case Effect2:
		}
		*/
		return null;
	}

}

enum SFZOpcode
{
	Sample;
	LoChan;
	HiChan;
	LoKey;
	HiKey;
	Key;
	LoVel;
	HiVel;
	LoBend;
	HiBend;
	LoChanAft;
	HiChanAft;
	LoPolyAft;
	HiPolyAft;
	LoRand;
	HiRand;
	LoBpm;
	HiBpm;
	SeqLength;
	SeqPosition;
	SwLoKey;
	SwHiKey;
	SwLast;
	SwDown;
	SwUp;
	SwPrevious;
	SwVel;
	Trigger;
	Group;
	OffBy;
	OffMode;
	OnLoccN;
	OnHiccN;
	Delay;
	DelayRandom;
	DelayccN;
	Offset;
	OffsetRandom;
	OffsetccN;
	End;
	Count;
	LoopMode;
	LoopStart;
	LoopEnd;
	SyncBeats;
	SyncOffset;
	Transpose;
	Tune;
	PitchKeyCenter;
	PitchKeyTrack;
	PitchVelTrack;
	PitchRandom;
	BendUp;
	BendDown;
	BendStep;
	PitchEgDelay;
	PitchEgStart;
	PitchEgAttack;
	PitchEgHold;
	PitchEgDecay;
	PitchEgSustain;
	PitchEgRelease;
	PitchEgDepth;
	PitchEgVel2Delay;
	PitchEgVel2Attack;
	PitchEgVel2Hold;
	PitchEgVel2Decay;
	PitchEgVel2Sustain;
	PitchEgVel2Release;
	PitchEgVel2Depth;
	PitchLfoDelay;
	PitchLfoFade;
	PitchLfoFreq;
	PitchLfoDepth;
	PitchLfoDepthccN;
	PitchLfoDepthChanAft;
	PitchLfoDepthPolyAft;
	PitchLfoFreqccN;
	PitchLfoFreqChanAft;
	PitchLfoFreqPolyAft;
	FilType;
	Cutoff;
	CutoffccN;
	CutoffChanAft;
	CutoffPolyAft;
	Resonance;
	FilKeyTrack;
	FilKeyCenter;
	FilVelTrack;
	FilRandom;
	FilEgDelay;
	FilEgStart;
	FilEgAttack;
	FilEgHold;
	FilEgDecay;
	FilEgSustain;
	FilEgRelease;
	FilEgVel2Delay;
	FilEgVel2Attack;
	FilEgVel2Hold;
	FilEgVel2Decay;
	FilEgVel2Sustain;
	FilEgVel2Release;
	FilEgVel2Depth;
	FilLfoDelay;
	FilLfoFade;
	FilLfoFreq;
	FilLfoDepth;
	FilLfoDepthccN;
	FilLfoDepthChanAft;
	FilLfoDepthPolyAft;
	FilLfoFreqccN;
	FilLfoFreqChanAft;
	FilLfoFreqPolyAft;
	Volume;
	Pan;
	Width;
	Position;
	AmpKeyTrack;
	AmpKeyCenter;
	AmpVelTrack;
	AmpVelCurve(velocity : Int);
	AmpRandom;
	RtDelay;
	Output;
	GainccN;
	XFInLoKey;
	XFInHiKey;
	XFOutLoKey;
	XFOutHiKey;
	XFKeyCurve;
	XFInLoVel;
	XFInHiVel;
	XFOutLoVel;
	XFOutHiVel;
	XFVelCurve;
	XFInLoccN;
	XFInHiccN;
	XFOutLoccN;
	XFOutHiccN;
	XFCCCurve;
	AmpegDelay;
	AmpegStart;
	AmpegAttack;
	AmpegHold;
	AmpegDecay;
	AmpegSustain;
	AmpegRelease;
	AmpegVel2Delay;
	AmpegVel2Attack;
	AmpegVel2Hold;
	AmpegVel2Decay;
	AmpegVel2Sustain;
	AmpegVel2Release;
	AmpegDelayccN;
	AmpegStartccN;
	AmpegAttackccN;
	AmpegHoldccN;
	AmpegDecayccN;
	AmpegSustainccN;
	AmpegReleaseccN;
	AmpLfoDelay;
	AmpLfoFade;
	AmpLfoFreq;
	AmpLfoDepth;
	AmpLfoDepthccN;
	AmpLfoDepthChanAft;
	AmpLfoDepthPolyAft;
	AmpLfoFreqccN;	
	AmpLfoFreqChanAft;	
	AmpLfoFreqPolyAft;	
	EqFreq(band:Int);
	EqFreqccN(band:Int);
	EqVel2Freq(band:Int);
	EqBw(band:Int);
	EqBwccN(band:Int);
	EqGain(band:Int);
	EqGainccN(band:Int);
	EqVel2Gain(band:Int);
	Effect1;
	Effect2;
}

enum SFZUnit
{
	Filename(name:String);
	MIDINote(number:Int);
	MIDIPitchbend(number:Int);
	MIDICC(number:Int);
	MIDI127Range(number:Int);
	MIDIBPM(number:Float);
	ArbitraryFloat(number:Float);
	ArbitraryInt(number:Int);
	SwVelOption(which:SwVelUnit);
	TriggerOption(which:TriggerUnit);
	OffByOption(which:OffByUnit);
	Seconds(amount:Float);
	Beats(amount:Float);
	Samples(amount:Int);
	LoopModeOption(which:LoopModeUnit);
	Semitones(amount:Int);
	Cents(amount:Int);
	Percentage(amount:Float);
	Hertz(amount:Float);
	FilterTypeOption(which:FilterTypeUnit);
	DB(amount:Float);
}

enum SwVelUnit { Current; Previous; }
enum TriggerUnit { Attack; Release; First; Legato; }
enum OffByUnit { Fast; Normal; }
enum LoopModeUnit { NoLoop; OneShot; LoopContinuous; LoopSustain; }
enum FilterTypeUnit { Lpf1p; Hpf1p; Lpf2p; Hpf2p; Bpf2p; Brf2p; }
