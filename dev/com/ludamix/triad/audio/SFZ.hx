package com.ludamix.triad.audio;

import com.ludamix.triad.format.WAV;
import haxe.Json;
import haxe.Serializer;
import haxe.Unserializer;
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

typedef SFZOpcodeRegion = Hash<SFZOpcodeInstance>;
typedef SFZOpcodeGroup = {group:SFZOpcodeRegion,regions:Array<SFZOpcodeRegion>};

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

		var groups = new Array<SFZOpcodeGroup>();

		var ctx = HEAD;
		var cur_group : SFZOpcodeGroup = null;
		var cur_region : SFZOpcodeRegion = null;
		
		var setupGroup = function()
		{
			cur_group = { group:new SFZOpcodeRegion(), regions:new Array<SFZOpcodeRegion>() }; 
			groups.push(cur_group); 
		};
		var setupRegion = function()
		{
			cur_region = new SFZOpcodeRegion(); 
			cur_group.regions.push(cur_region); 
		};
		
		for (l in lines)
		{
			l = HString.trim(l);
			if (l.length == 0 || HString.startsWith(l, "//")) { } // pass
			else if (HString.startsWith(l, "<group>")) { 
				setupGroup(); ctx = GROUP;  } // group
			else if (HString.startsWith(l, "<region>")) { 
				if (cur_group == null) setupGroup(); 
				setupRegion(); ctx = REGION; } // region
			else if (l.indexOf("=") >= 0) // opcode
			{
				var parts = l.split("=");
				parts[1] = HString.trim(parts[1].split("//")[0]); // eliminate comments
				if (ctx == GROUP)
				{
					cur_group.group.set(parts[0],parseOpcode(parts[0], interpret_type(seq, parts[0], parts[1])));
				}
				else if (ctx == REGION)
				{
					cur_region.set(parts[0],parseOpcode(parts[0], interpret_type(seq, parts[0], parts[1])));
				}
			}
		}
		
		// now cache each region's final behavior.
		
		var result_groups = new Array<Hash<Dynamic>>();
		for (g in groups)
		{
			var rcache = new Array<SFZOpcodeRegion>();
			
			for (r in cur_group.regions)
			{
				var result = new SFZOpcodeRegion();
				for (k in cur_group.group)
					result.set(k.name, k);
				for (k in r)
					result.set(k.name, k);
				rcache.push(result);
			}			
			// now apply rules to translate the SFZ opcodes into SamplerOpcodeGroups, using default values where missing.
			// TODO: we could probably optimize the loading...the defaults are cached using haxe.Serializer
			// but this may not be optimal.
			
			for (r in rcache)
			{
				var region = getOpcodeDefault();
				for (k in r)
				{
					var data = emitInternalOpcodes(k);
					region.set(data[0], data[1]);
				}
				result_groups.push(region);
			}
		}		
		
		var result = new SamplerOpcodeGroup();
		result.regions = result_groups;
		
		return [result];

	}
	
	public static function emitInternalOpcodes(o : SFZOpcodeInstance) : Array<Dynamic>
	{
		// returns values immediately usable by the sampler
		var tu = translateSFZUnit(o.value);
		switch(o.op)
		{
			case Sample: return ["sample", tu];
			
			case LoChan: return ["lochan", tu];
			case HiChan: return ["hichan", tu];
			case LoKey: return ["lokey", tu];
			case HiKey: return ["hikey", tu];
			case Key: return ["key", tu];
			case LoVel: return ["lovel", tu];
			case HiVel: return ["hivel", tu];
			case LoBend: return ["lobend", tu];
			case HiBend: return ["hibend", tu];
			case LoChanAft: return ["lochanaft", tu];
			case HiChanAft: return ["hichanaft", tu];
			case LoPolyAft: return ["lopolyaft", tu];
			case HiPolyAft: return ["hipolyaft", tu];
			case LoRand: return ["lorand", tu];
			case HiRand: return ["hirand", tu];
			case LoBpm: return ["lobpm", tu];
			case HiBpm: return ["hibpm", tu];
			case SeqLength: return ["seq_length", tu];
			case SeqPosition: return ["seq_position", tu];
			case SwLoKey: return ["sw_lokey", tu];
			case SwHiKey: return ["sw_hikey", tu];
			case SwLast: return ["sw_last", tu];
			case SwDown: return ["sw_down", tu];
			case SwUp: return ["sw_up", tu];
			case SwPrevious: return ["sw_previous", tu];
			case SwVel: return ["sw_vel", tu];
			case Trigger: return ["trigger", tu];
			case Group: return ["group", tu];
			case OffBy: return ["off_by", tu];
			case OffMode: return ["off_mode", tu];
			case OnLocc(controller): return ["on_locc"+Std.string(controller), tu];
			case OnHicc(controller): return ["on_hicc"+Std.string(controller), tu];
			
			case Delay: return ["delay", tu];
			case DelayRandom: return ["delay_random", tu];
			case Delaycc(controller): return ["delay_cc"+Std.string(controller), tu];
			case Offset: return ["offset", tu];
			case OffsetRandom: return ["offset_random", tu];
			case Offsetcc(controller): return ["offset_cc"+Std.string(controller), tu];
			case End: return ["end", tu];
			case Count: return ["count", tu];
			case LoopMode: return ["loop_mode", tu];
			case LoopStart: return ["loop_start", tu];
			case LoopEnd: return ["loop_end", tu];
			case SyncBeats: return ["sync_beats", tu];
			case SyncOffset: return ["sync_offset", tu];
			
			case Transpose: return ["transpose", tu];
			case Tune: return ["tune", tu];
			case PitchKeyCenter: return ["pitch_keycenter", tu];
			case PitchKeyTrack: return ["pitch_keytrack", tu];
			case PitchVelTrack: return ["pitch_veltrack", tu];
			case PitchRandom: return ["pitch_random", tu];
			case BendUp: return ["bend_up", tu];
			case BendDown: return ["bend_down", tu];
			case BendStep: return ["bend_step", tu];
			
			case PitchEgDelay: return ["pitcheg_delay", tu];
			case PitchEgStart: return ["pitcheg_start", tu];
			case PitchEgAttack: return ["pitcheg_attack", tu];
			case PitchEgHold: return ["pitcheg_hold", tu];
			case PitchEgDecay: return ["pitcheg_decay", tu];
			case PitchEgSustain: return ["pitcheg_sustain", tu];
			case PitchEgRelease: return ["pitcheg_release", tu];
			case PitchEgDepth: return ["pitcheg_depth", tu];
			case PitchEgVel2Delay: return ["pitcheg_vel2delay", tu];
			case PitchEgVel2Attack: return ["pitcheg_vel2attack", tu];
			case PitchEgVel2Hold: return ["pitcheg_vel2hold", tu];
			case PitchEgVel2Decay: return ["pitcheg_vel2decay", tu];
			case PitchEgVel2Sustain: return ["pitcheg_vel2sustain", tu];
			case PitchEgVel2Release: return ["pitcheg_vel2release", tu];
			case PitchEgVel2Depth: return ["pitcheg_vel2depth", tu];
			
			case PitchLfoDelay: return ["pitchlfo_delay", tu];
			case PitchLfoFade: return ["pitchlfo_fade", tu];
			case PitchLfoFreq: return ["pitchlfo_freq", tu];
			case PitchLfoDepth: return ["pitchlfo_depth", tu];
			case PitchLfoDepthcc(controller): return ["pitchlfo_depthcc"+Std.string(controller), tu];
			case PitchLfoDepthChanAft: return ["pitchlfo_depthchanaft", tu];
			case PitchLfoDepthPolyAft: return ["pitchlfo_depthpolyaft", tu];
			case PitchLfoFreqcc(controller): return ["pitchlfo_freqcc"+Std.string(controller), tu];
			case PitchLfoFreqChanAft: return ["pitchlfo_freqchanaft", tu];
			case PitchLfoFreqPolyAft: return ["pitchlfo_freqpolyaft", tu];
			
			case FilType: return ["fil_type", tu];
			case Cutoff: return ["cutoff", tu];
			case Cutoffcc(controller): return ["cutoff_cc"+Std.string(controller), tu];
			case CutoffChanAft: return ["cutoff_chanaft", tu];
			case CutoffPolyAft: return ["cutoff_polyaft", tu];
			case Resonance: return ["resonance", tu];
			case FilKeyTrack: return ["fil_keytrack", tu];
			case FilKeyCenter: return ["fil_keycenter", tu];
			case FilVelTrack: return ["fil_veltrack", tu];
			case FilRandom: return ["fil_random", tu];
			
			case FilEgDelay: return ["fileg_delay", tu];
			case FilEgStart: return ["fileg_start", tu];
			case FilEgAttack: return ["fileg_attack", tu];
			case FilEgHold: return ["fileg_hold", tu];
			case FilEgDecay: return ["fileg_decay", tu];
			case FilEgSustain: return ["fileg_sustain", tu];
			case FilEgRelease: return ["fileg_release", tu];
			case FilEgDepth: return ["fileg_depth", tu];
			case FilEgVel2Delay: return ["fileg_vel2delay", tu];
			case FilEgVel2Attack: return ["fileg_vel2attack", tu];
			case FilEgVel2Hold: return ["fileg_vel2hold", tu];
			case FilEgVel2Decay: return ["fileg_vel2decay", tu];
			case FilEgVel2Sustain: return ["fileg_vel2sustain", tu];
			case FilEgVel2Release: return ["fileg_vel2release", tu];
			case FilEgVel2Depth: return ["fileg_vel2depth", tu];
			
			case FilLfoDelay: return ["fillfo_delay", tu];
			case FilLfoFade: return ["fillfo_fade", tu];
			case FilLfoFreq: return ["fillfo_freq", tu];
			case FilLfoDepth: return ["fillfo_depth", tu];
			case FilLfoDepthcc(controller): return ["fillfo_depthcc"+Std.string(controller), tu];
			case FilLfoDepthChanAft: return ["fillfo_depthchanaft", tu];
			case FilLfoDepthPolyAft: return ["fillfo_depthpolyaft", tu];
			case FilLfoFreqcc(controller): return ["fillfo_freqcc"+Std.string(controller), tu];
			case FilLfoFreqChanAft: return ["fillfo_freqchanaft", tu];
			case FilLfoFreqPolyAft: return ["fillfo_freqpolyaft", tu];
			
			case Volume: return ["volume", tu];
			case Pan: return ["pan", tu];
			case Width: return ["width", tu];
			case Position: return ["position", tu];
			case AmpKeyTrack: return ["amp_keytrack", tu];
			case AmpKeyCenter: return ["amp_keycenter", tu];
			case AmpVelTrack: return ["amp_veltrack", tu];
			case AmpVelCurve(velocity): return ["amp_velcurve"+Std.string(velocity), tu];
			case AmpRandom: return ["amp_random", tu];
			case RtDecay: return ["rt_decay", tu];
			case Output: return ["output", tu];
			case Gaincc(controller): return ["gain_cc"+Std.string(controller), tu];
			case XFInLoKey: return ["xfin_lokey",tu];
			case XFInHiKey: return ["xfin_hikey",tu];
			case XFOutLoKey: return ["xfout_lokey",tu];
			case XFOutHiKey: return ["xfout_hikey",tu];
			case XFKeyCurve: return ["xf_keycurve",tu];
			case XFInLoVel: return ["xfin_lovel",tu];
			case XFInHiVel: return ["xfin_hivel",tu];
			case XFOutLoVel: return ["xfout_lovel",tu];
			case XFOutHiVel: return ["xfout_hivel",tu];
			case XFVelCurve: return ["xf_velcurve",tu];
			case XFInLocc(controller): return ["xfin_locc"+Std.string(controller),tu];
			case XFInHicc(controller): return ["xfin_hicc"+Std.string(controller),tu];
			case XFOutLocc(controller): return ["xfout_locc"+Std.string(controller),tu];
			case XFOutHicc(controller): return ["xfout_hicc"+Std.string(controller),tu];
			case XFCCCurve: return ["xf_cccurve", tu];
			
			case AmpegDelay: return ["ampeg_delay",tu];
			case AmpegStart: return ["ampeg_start",tu];
			case AmpegAttack: return ["ampeg_attack",tu];
			case AmpegHold: return ["ampeg_hold",tu];
			case AmpegDecay: return ["ampeg_decay",tu];
			case AmpegSustain: return ["ampeg_sustain",tu];
			case AmpegRelease: return ["ampeg_release",tu];
			case AmpegVel2Delay: return ["ampeg_vel2delay",tu];
			case AmpegVel2Attack: return ["ampeg_vel2attack",tu];
			case AmpegVel2Hold: return ["ampeg_vel2hold",tu];
			case AmpegVel2Decay: return ["ampeg_vel2decay",tu];
			case AmpegVel2Sustain: return ["ampeg_vel2sustain",tu];
			case AmpegVel2Release: return ["ampeg_vel2release",tu];
			case AmpegDelaycc(controller): return ["ampeg_delaycc"+Std.string(controller),tu];
			case AmpegStartcc(controller): return ["ampeg_startcc"+Std.string(controller),tu];
			case AmpegAttackcc(controller): return ["ampeg_attackcc"+Std.string(controller),tu];
			case AmpegHoldcc(controller): return ["ampeg_holdcc"+Std.string(controller),tu];
			case AmpegDecaycc(controller): return ["ampeg_decaycc"+Std.string(controller),tu];
			case AmpegSustaincc(controller): return ["ampeg_sustaincc"+Std.string(controller),tu];
			case AmpegReleasecc(controller): return ["ampeg_releasecc"+Std.string(controller),tu];
			
			case AmpLfoDelay: return ["amplfo_delay",tu];
			case AmpLfoFade: return ["amplfo_fade",tu];
			case AmpLfoFreq: return ["amplfo_freq",tu];
			case AmpLfoDepth: return ["amplfo_depth",tu];
			case AmpLfoDepthcc(controller): return ["amplfo_depthcc"+Std.string(controller),tu];
			case AmpLfoDepthChanAft: return ["amplfo_depthchanaft",tu];
			case AmpLfoDepthPolyAft: return ["amplfo_depthpolyaft",tu];
			case AmpLfoFreqcc(controller): return ["amplfo_freqcc"+Std.string(controller),tu];
			case AmpLfoFreqChanAft: return ["amplfo_freqchanaft",tu];
			case AmpLfoFreqPolyAft: return ["amplfo_freqpolyaft",tu];
			
			case EqFreq(band): return ["eq"+Std.string(band)+"_freq",tu];
			case EqFreqcc(controller, band): return ["eq"+Std.string(band)+"_freqcc"+Std.string(controller),tu];
			case EqVel2Freq(band): return ["eq"+Std.string(band)+"_vel2freq",tu];
			case EqBw(band): return ["eq"+Std.string(band)+"_bw",tu];
			case EqBwcc(controller, band): return ["eq"+Std.string(band)+"_bwcc"+Std.string(controller),tu];
			case EqGain(band): return ["eq"+Std.string(band)+"_gain",tu];
			case EqGaincc(controller, band): return ["eq"+Std.string(band)+"_gaincc"+Std.string(controller),tu];
			case EqVel2Gain(band): return ["eq"+Std.string(band)+"_vel2gain",tu];
			
			case Effect1: return ["effect1",tu];
			case Effect2: return ["effect2",tu];
		}
	}
	
	public static function translateSFZUnit(u : SFZUnit) : Dynamic
	{
		// these units are stubby translations.
		// later I want to move all the translations of percentages and dB values etc. in here.
		switch(u)
		{
			case Filename(name): return name;
			case MIDIChannel(number): return number;
			case MIDINote(number): return number;
			case MIDIPitchbend(number): return number;
			case MIDICC(number): return number;
			case MIDI127Range(number): return number;
			case MIDIBPM(number): return number;
			case ArbitraryFloat(number): return number;
			case ArbitraryInt(number): return number;
			case VelCurve(velocity, level): return null;
			case SwVelOption(which): return null;
			case TriggerOption(which): return null;
			case OffModeOption(which): return null;
			case Seconds(amount): return amount;
			case Beats(amount): return amount;
			case Samples(amount): return amount;
			case LoopModeOption(which): switch(which)
				{
					case NoLoop: return SamplerSynth.NO_LOOP;
					case OneShot: return SamplerSynth.ONE_SHOT;
					case LoopContinuous: return SamplerSynth.LOOP_FORWARD;
					case LoopSustain: return SamplerSynth.SUSTAIN_FORWARD;
					case Default: return SamplerSynth.LOOP_UNSPECIFIED;
				}
			case CurveOption(which): return null;
			case Semitones(amount): return amount;
			case Cents(amount): return amount;
			case Percentage(amount): return amount;
			case Hertz(amount): return amount;
			case Octaves(amount): return amount;
			case FilterTypeOption(which): switch(which)
				{
					case Lpf1p: return "lpf_1p";
					case Hpf1p: return "hpf_1p";
					case Lpf2p: return "lpf_2p";
					case Hpf2p: return "hpf_2p";
					case Bpf2p: return "bpf_2p";
					case Brf2p: return "brf_2p";
				}
			case DB(amount): return amount;
			case DBPerSecond(amount): return amount;
		}
	}
	
	public static function parseOpcode(i : String, v : Dynamic) : SFZOpcodeInstance
	{
		// return the unit from interpret_type(or parse the enumerated strings)
		var r : SFZOpcodeInstance = { name:i, op:null, value:null };
		
		// eliminate numbers in the constants
		i = StringTools.replace(i, "vel2", "velto");
		i = StringTools.replace(i, "_1p", "_op");
		i = StringTools.replace(i, "_2p", "_tp");
		i = StringTools.replace(i, "effect1", "effectone");
		i = StringTools.replace(i, "effect2", "effecttwo");
		
		// need to parse each one for number_a and number_b and clean out the number data
		var p_mode = 0; // 0 = before number_a, 1 = number_a, 2 = before number_b, 3 = number_b
		var number_a_str = "";
		var number_b_str = "";
		for (idx in 0...i.length)
		{
			var c = i.charAt(idx);
			if (c == '0' || c == '1' || c == '2' || c == '3' || c == '4' || c == '5' || 
				c == '6' || c == '7' || c == '8' || c == '9')
			{
				if (p_mode == 0 || p_mode == 2) p_mode++;
				if (p_mode == 1) number_a_str += c;
				else number_b_str += c;
			}
			else
			{
				if (p_mode == 1 || p_mode == 3) p_mode++;
			}
		}
		var number_a = Std.parseInt(number_a_str);
		var number_b = Std.parseInt(number_b_str);
		i = StringTools.replace(i, number_a_str, "");
		i = StringTools.replace(i, number_b_str, "");
		
		switch(i)
		{
			case "sample": r.op = Sample; r.value = Filename(v);
			
			case "lochan": r.op = LoChan; r.value = MIDIChannel(v);
			case "hichan": r.op = HiChan; r.value = MIDIChannel(v);
			case "lokey": r.op = LoKey; r.value = MIDINote(v);
			case "hikey": r.op = HiKey; r.value = MIDINote(v);
			case "key": r.op = Key; r.value = MIDINote(v);
			case "lovel": r.op = LoVel; r.value = MIDI127Range(v);
			case "hivel": r.op = HiVel; r.value = MIDI127Range(v);
			case "lobend": r.op = LoBend; r.value = MIDIPitchbend(v);
			case "hibend": r.op = HiBend; r.value = MIDIPitchbend(v);
			case "lochanaft": r.op = LoChanAft; r.value = MIDI127Range(v);
			case "hichanaft": r.op = HiChanAft; r.value = MIDI127Range(v);
			case "lopolyaft": r.op = LoPolyAft; r.value = MIDI127Range(v);
			case "hipolyaft": r.op = HiPolyAft; r.value = MIDI127Range(v);
			case "lorand": r.op = LoRand; r.value = ArbitraryFloat(v);
			case "hirand": r.op = HiRand; r.value = ArbitraryFloat(v);
			case "lobpm": r.op = LoBpm; r.value = ArbitraryFloat(v);
			case "hibpm": r.op = HiBpm; r.value = ArbitraryFloat(v);
			case "seq_length": r.op = SeqLength; r.value = ArbitraryInt(v);
			case "seq_position": r.op = SeqPosition;  r.value = ArbitraryInt(v);
			case "sw_lokey": r.op = SwLoKey;  r.value = MIDINote(v);
			case "sw_hikey": r.op = SwHiKey; r.value = MIDINote(v);
			case "sw_last": r.op = SwLast; r.value = MIDINote(v);
			case "sw_down": r.op = SwDown; r.value = MIDINote(v);
			case "sw_up": r.op = SwUp; r.value = MIDINote(v);
			case "sw_previous": r.op = SwPrevious; r.value = MIDINote(v);
			case "sw_vel": r.op = SwVel; r.value = SwVelOption(v);
			case "trigger": r.op = Trigger;
					 if (v == "attack") r.value = TriggerOption(Attack);
				else if (v == "release") r.value = TriggerOption(Release);
				else if (v == "first") r.value = TriggerOption(First);
				else if (v == "legato") r.value = TriggerOption(Legato);				
			case "group": r.op = Group;  r.value = ArbitraryInt(v);
			case "off_by": r.op = OffBy;  r.value = ArbitraryInt(v); 
			case "off_mode": r.op = OffMode;
					 if (v == "fast") r.value = OffModeOption(Fast);
				else if (v == "normal") r.value = OffModeOption(Normal);
			case "on_locc": r.op = OnLocc(number_a); r.value = MIDICC(v);
			case "on_hicc": r.op = OnHicc(number_a); r.value = MIDICC(v);			
			
			case "delay": r.op = Delay; r.value = Seconds(v);
			case "delay_random": r.op = DelayRandom; r.value = Seconds(v);
			case "delay_cc": r.op = Delaycc(number_a); r.value = Seconds(v);
			case "offset": r.op = Offset; r.value = Samples(v);
			case "offset_random": r.op = OffsetRandom; r.value = Samples(v);
			case "offset_cc": r.op = Offsetcc(number_a); r.value = Samples(v);
			case "end": r.op = End; r.value = Samples(v);
			case "count": r.op = Count; r.value = ArbitraryInt(v);
			case "loop_mode": r.op = LoopMode;
					 if (v == "no_loop") r.value = LoopModeOption(NoLoop);
				else if (v == "one_shot") r.value = LoopModeOption(OneShot);
				else if (v == "loop_continuous") r.value = LoopModeOption(LoopContinuous);
				else if (v == "loop_sustain") r.value = LoopModeOption(LoopSustain);
			case "loop_start": r.op = LoopStart; r.value = Samples(v);
			case "loop_end": r.op = LoopEnd; r.value = Samples(v);
			case "sync_beats": r.op = SyncBeats; r.value = Beats(v);
			case "sync_offset": r.op = SyncOffset; r.value = Beats(v);
			
			case "transpose": r.op = Transpose; r.value = Semitones(v);
			case "tune": r.op = Tune; r.value = Cents(v);
			case "pitch_keycenter": r.op = PitchKeyCenter; r.value = MIDINote(v);
			case "pitch_keytrack": r.op = PitchKeyTrack; r.value = Cents(v);
			case "pitch_veltrack": r.op = PitchVelTrack; r.value = Cents(v);
			case "pitch_random": r.op = PitchRandom; r.value = Cents(v);
			case "bend_up": r.op = BendUp; r.value = Cents(v);
			case "bend_down": r.op = BendDown; r.value = Cents(v);
			case "bend_step": r.op = BendStep; r.value = Cents(v);
			
			case "pitcheg_delay": r.op = PitchEgDelay; r.value = Seconds(v);
			case "pitcheg_start": r.op = PitchEgStart; r.value = Percentage(v);
			case "pitcheg_attack": r.op = PitchEgAttack; r.value = Seconds(v);
			case "pitcheg_hold": r.op = PitchEgHold;  r.value = Seconds(v);
			case "pitcheg_decay": r.op = PitchEgDecay;  r.value = Seconds(v);
			case "pitcheg_sustain": r.op = PitchEgSustain;  r.value = Percentage(v);
			case "pitcheg_release": r.op = PitchEgRelease; r.value = Seconds(v);
			case "pitcheg_depth": r.op = PitchEgDepth; r.value = Cents(v);
			case "pitcheg_veltodelay": r.op = PitchEgVel2Delay; r.value = ArbitraryFloat(v);
			case "pitcheg_veltoattack": r.op = PitchEgVel2Attack; r.value = Seconds(v);
			case "pitcheg_veltohold": r.op = PitchEgVel2Hold; r.value = Seconds(v);
			case "pitcheg_veltodecay": r.op = PitchEgVel2Decay; r.value = Seconds(v);
			case "pitcheg_veltosustain": r.op = PitchEgVel2Sustain; r.value = Percentage(v);
			case "pitcheg_veltorelease": r.op = PitchEgVel2Release; r.value = Seconds(v);
			case "pitcheg_veltodepth": r.op = PitchEgVel2Depth; r.value = Cents(v);
			
			case "pitchlfo_delay": r.op = PitchLfoDelay; r.value = Seconds(v);
			case "pitchlfo_fade": r.op = PitchLfoFade; r.value = Seconds(v);
			case "pitchlfo_freq": r.op = PitchLfoFreq; r.value = Hertz(v);
			case "pitchlfo_depth": r.op = PitchLfoDepth; r.value = Cents(v);
			case "pitchlfo_depthcc": r.op = PitchLfoDepthcc(number_a); r.value = Cents(v);
			case "pitchlfo_depthchanaft": r.op = PitchLfoDepthChanAft; r.value = Cents(v);
			case "pitchlfo_depthpolyaft": r.op = PitchLfoDepthPolyAft; r.value = Cents(v);
			case "pitchlfo_freqcc": r.op = PitchLfoFreqcc(number_a); r.value = Hertz(v);
			case "pitchlfo_freqchanaft": r.op = PitchLfoFreqChanAft; r.value = Hertz(v);
			case "pitchlfo_freqpolyaft": r.op = PitchLfoFreqPolyAft; r.value = Hertz(v);
			
			case "fil_type": r.op = FilType;
					 if (v == "lpf_op") r.value = FilterTypeOption(Lpf1p);
				else if (v == "hpf_op") r.value = FilterTypeOption(Hpf2p);
				else if (v == "lpf_tp") r.value = FilterTypeOption(Lpf2p);
				else if (v == "hpf_tp") r.value = FilterTypeOption(Hpf2p);
				else if (v == "bpf_tp") r.value = FilterTypeOption(Bpf2p);
				else if (v == "brf_tp") r.value = FilterTypeOption(Brf2p);
			case "cutoff": r.op = Cutoff; r.value = Hertz(v);
			case "cutoff_cc": r.op = Cutoffcc(number_a); r.value = Cents(v);
			case "cutoff_chanaft": r.op = CutoffChanAft; r.value = Cents(v);
			case "cutoff_polyaft": r.op = CutoffPolyAft; r.value = Cents(v);
			case "resonance": r.op = Resonance; r.value = DB(v);
			case "fil_keytrack": r.op = FilKeyTrack; r.value = Cents(v);
			case "fil_keycenter": r.op = FilKeyCenter; r.value = MIDINote(v);
			case "fil_veltrack": r.op = FilVelTrack; r.value = Cents(v);
			case "fil_random": r.op = FilRandom; r.value = Cents(v);
			
			case "fileg_delay": r.op = FilEgDelay; r.value = Seconds(v);
			case "fileg_start": r.op = FilEgStart; r.value = Percentage(v);
			case "fileg_attack": r.op = FilEgAttack; r.value = Seconds(v);
			case "fileg_hold": r.op = FilEgHold; r.value = Seconds(v);
			case "fileg_decay": r.op = FilEgDecay; r.value = Seconds(v);
			case "fileg_sustain": r.op = FilEgSustain; r.value = Percentage(v);
			case "fileg_release": r.op = FilEgRelease; r.value = Seconds(v);
			case "fileg_depth": r.op = FilEgDepth; r.value = Cents(v);
			case "fileg_veltodelay": r.op = FilEgVel2Delay; r.value = Seconds(v);
			case "fileg_veltoattack": r.op = FilEgVel2Attack; r.value = Seconds(v);
			case "fileg_veltohold": r.op = FilEgVel2Hold; r.value = Seconds(v);
			case "fileg_veltodecay": r.op = FilEgVel2Decay; r.value = Seconds(v);
			case "fileg_veltosustain": r.op = FilEgVel2Sustain; r.value = Percentage(v);
			case "fileg_veltorelease": r.op = FilEgVel2Release; r.value = Seconds(v);
			case "fileg_veltodepth": r.op = FilEgVel2Depth; r.value = Cents(v);
			
			case "fillfo_delay": r.op = FilLfoDelay; r.value = Seconds(v);
			case "fillfo_fade": r.op = FilLfoFade; r.value = Seconds(v);
			case "fillfo_freq": r.op = FilLfoFreq; r.value = Hertz(v);
			case "fillfo_depth": r.op = FilLfoDepth; r.value = Cents(v);
			case "fillfo_depthcc": r.op = FilLfoDepthcc(number_a); r.value = Cents(v);
			case "fillfo_depthchanaft": r.op = FilLfoDepthChanAft; r.value = Cents(v);
			case "fillfo_depthpolyaft": r.op = FilLfoDepthPolyAft; r.value = Cents(v);
			case "fillfo_freqcc": r.op = FilLfoFreqcc(number_a); r.value = Hertz(v);
			case "fillfo_freqchanaft": r.op = FilLfoFreqChanAft; r.value = Hertz(v);
			case "fillfo_freqpolyaft": r.op = FilLfoFreqPolyAft; r.value = Hertz(v);
			
			case "volume": r.op = Volume; r.value = DB(v);
			case "pan": r.op = Pan; r.value = Percentage(v);
			case "width": r.op = Width; r.value = Percentage(v);
			case "position": r.op = Position; r.value = Percentage(v);
			case "amp_keytrack": r.op = AmpKeyTrack; r.value = DB(v);
			case "amp_keycenter": r.op = AmpKeyCenter; r.value = MIDINote(v);
			case "amp_veltrack": r.op = AmpVelTrack; r.value = Percentage(v);
			case "amp_velcurve": r.op = AmpVelCurve(number_a); r.value = VelCurve(number_a, v);
			case "amp_random": r.op = AmpRandom; r.value = DB(v);
			case "rt_decay": r.op = RtDecay; r.value = DBPerSecond(v);
			case "output": r.op = Output; r.value = DB(v);
			case "gain_cc": r.op = Gaincc(number_a); r.value = DBPerSecond(v);
			case "xfin_lokey": r.op = XFInLoKey; r.value = MIDINote(v);
			case "xfin_hikey": r.op = XFInHiKey; r.value = MIDINote(v);
			case "xfout_lokey": r.op = XFOutLoKey; r.value = MIDINote(v);
			case "xfout_hikey": r.op = XFOutHiKey; r.value = MIDINote(v);
			case "xf_keycurve": r.op = XFKeyCurve;
					 if (v == "gain") r.value = CurveOption(Gain);
				else if (v == "power") r.value = CurveOption(Power);
			case "xfin_lovel": r.op = XFInLoVel; r.value = MIDI127Range(v);
			case "xfin_hivel": r.op = XFInHiVel; r.value = MIDI127Range(v);
			case "xfout_lovel": r.op = XFOutLoVel; r.value = MIDI127Range(v);
			case "xfout_hivel": r.op = XFOutHiVel; r.value = MIDI127Range(v);
			case "xf_velcurve": r.op = XFVelCurve;
					 if (v == "gain") r.value = CurveOption(Gain);
				else if (v == "power") r.value = CurveOption(Power);
			case "xfin_locc": r.op = XFInLocc(number_a); r.value = MIDI127Range(v);
			case "xfin_hicc": r.op = XFInHicc(number_a); r.value = MIDI127Range(v);
			case "xfout_locc": r.op = XFOutLocc(number_a); r.value = MIDI127Range(v);
			case "xfout_hicc": r.op = XFOutHicc(number_a); r.value = MIDI127Range(v);
			case "xfcccurve": r.op = XFCCCurve;
					 if (v == "gain") r.value = CurveOption(Gain);
				else if (v == "power") r.value = CurveOption(Power);			
				
			case "ampeg_delay": r.op = AmpegDelay; r.value = Seconds(v);
			case "ampeg_start": r.op = AmpegStart; r.value = Percentage(v);
			case "ampeg_attack": r.op = AmpegAttack; r.value = Seconds(v);
			case "ampeg_hold": r.op = AmpegHold; r.value = Seconds(v);
			case "ampeg_decay": r.op = AmpegDecay; r.value = Seconds(v);
			case "ampeg_sustain": r.op = AmpegSustain; r.value = Percentage(v);
			case "ampeg_release": r.op = AmpegRelease; r.value = Seconds(v);
			case "ampeg_veltodelay": r.op = AmpegVel2Delay; r.value = Seconds(v);
			case "ampeg_veltoattack": r.op = AmpegVel2Attack; r.value = Seconds(v);
			case "ampeg_veltohold": r.op = AmpegVel2Hold; r.value = Seconds(v);
			case "ampeg_veltodecay": r.op = AmpegVel2Decay; r.value = Seconds(v);
			case "ampeg_veltosustain": r.op = AmpegVel2Sustain; r.value = Percentage(v);
			case "ampeg_veltorelease": r.op = AmpegVel2Release; r.value = Seconds(v);
			case "ampeg_delaycc": r.op = AmpegDelaycc(number_a); r.value = Seconds(v);
			case "ampeg_startcc": r.op = AmpegStartcc(number_a); r.value = Percentage(v);
			case "ampeg_attackcc": r.op = AmpegAttackcc(number_a); r.value = Seconds(v);
			case "ampeg_holdcc": r.op = AmpegHoldcc(number_a); r.value = Seconds(v);
			case "ampeg_decaycc": r.op = AmpegDecaycc(number_a); r.value = Seconds(v);
			case "ampeg_sustaincc": r.op = AmpegSustaincc(number_a); r.value = Percentage(v);
			case "ampeg_releasecc": r.op = AmpegReleasecc(number_a); r.value = Seconds(v);
			
			case "amplfo_delay": r.op = AmpLfoDelay; r.value = Seconds(v);
			case "amplfo_fade": r.op = AmpLfoFade; r.value = Seconds(v);
			case "amplfo_freq": r.op = AmpLfoFreq; r.value = Hertz(v);
			case "amplfo_depth": r.op = AmpLfoDepth; r.value = DB(v);
			case "amplfo_depthcc": r.op = AmpLfoDepthcc(number_a); r.value = DB(v);
			case "amplfo_depthchanaft": r.op = AmpLfoDepthChanAft; r.value = DB(v);
			case "amplfo_depthpolyaft": r.op = AmpLfoDepthPolyAft; r.value = DB(v);
			case "amplfo_freqcc": r.op = AmpLfoFreqcc(number_a); r.value = Hertz(v);
			case "amplfo_freqchanaft": r.op = AmpLfoFreqChanAft; r.value = Hertz(v);
			case "amplfo_freqpolyaft": r.op = AmpLfoFreqPolyAft; r.value = Hertz(v);
			
			case "eq_freq": r.op = EqFreq(number_a); r.value = Hertz(v);
			case "eq_freqcc": r.op = EqFreqcc(number_a,number_b); r.value = Hertz(v);
			case "eq_veltofreq": r.op = EqVel2Freq(number_a); r.value = Hertz(v);
			case "eq_bw": r.op = EqBw(number_a); r.value = Octaves(v);
			case "eq_bwcc": r.op = EqBwcc(number_a, number_b); r.value = Octaves(v);
			case "eq_gain": r.op = EqGain(number_a); r.value = DB(v);
			case "eq_gaincc": r.op = EqGaincc(number_a, number_b); r.value = DB(v);
			case "eq_veltogain": r.op = EqVel2Gain(number_a); r.value = DB(v);
			
			case "effectone": r.op = Effect1; r.value = Percentage(v);
			case "effecttwo": r.op = Effect2; r.value = Percentage(v);
		}
		return r;
	}
	
	private static inline function rSet(r : Hash<Dynamic>, name : String, op : SFZOpcode, value : Dynamic)
	{
		var z = emitInternalOpcodes( { name:name, op:op, value:value } );
		r.set(z[0], z[1]);
	}
	
	public static var default_cache : String;
	
	public static function getOpcodeDefault() : Hash<Dynamic>
	{
		return new Hash<Dynamic>();
		// TODO improve these defaults so that:
		// ... they load fast
		// ... they don't cause the track to be silent
		if (default_cache != null) return Unserializer.run(default_cache);
		else
		{
			var r = new Hash<Dynamic>();
			rSet(r, "lochan", LoChan, MIDIChannel(1));
			rSet(r, "hichan", HiChan,MIDIChannel(16));
			rSet(r, "lokey", LoKey,MIDINote(0));
			rSet(r, "hikey", HiKey,MIDINote(127));
			rSet(r, "key", HiKey,MIDINote(0));
			rSet(r, "lovel", LoVel,MIDI127Range(0));
			rSet(r, "hivel", HiVel,MIDI127Range(127));
			rSet(r, "lobend", LoBend,MIDIPitchbend(-8192));
			rSet(r, "hibend", HiBend,MIDIPitchbend(8192));
			rSet(r, "lochanaft", LoChanAft,MIDI127Range(0));
			rSet(r, "hichanaft", HiChanAft,MIDI127Range(127));
			rSet(r, "lopolyaft", LoPolyAft,MIDI127Range(0));
			rSet(r, "hipolyaft", HiPolyAft,MIDI127Range(127));
			rSet(r, "lorand", LoRand,ArbitraryFloat(0.));
			rSet(r, "hirand", HiRand,ArbitraryFloat(1.));
			rSet(r, "lobpm", LoBpm,ArbitraryFloat(0.));
			rSet(r, "hibpm", HiBpm,ArbitraryFloat(50.));
			rSet(r, "seq_length", SeqLength,ArbitraryInt(1));
			rSet(r, "seq_position", SeqPosition,ArbitraryInt(1));
			rSet(r, "sw_lokey", SwLoKey,MIDINote(0));
			rSet(r, "sw_hikey", SwHiKey,MIDINote(127));
			rSet(r, "sw_last", SwLast,MIDINote(0));
			rSet(r, "sw_down", SwDown,MIDINote(0));
			rSet(r, "sw_up", SwUp,MIDINote(0));
			rSet(r, "sw_vel", SwVel,SwVelOption(Current));
			rSet(r, "trigger", Trigger,TriggerOption(Attack));
			rSet(r, "group", Group,ArbitraryInt(0));
			rSet(r, "off_by", OffBy,ArbitraryInt(0));
			rSet(r, "off_mode", OffMode,OffModeOption(Fast));
				
			rSet(r, "delay", Delay,Seconds(0.));
			rSet(r, "delay_random", DelayRandom,Seconds(0.));
			rSet(r, "offset", Offset,Samples(0));
			rSet(r, "offset_random", OffsetRandom,Samples(0));
			rSet(r, "end", End,Samples(0));
			rSet(r, "count", Count,ArbitraryInt(0));
			rSet(r, "loop_mode", LoopMode,LoopModeOption(Default));
			rSet(r, "loop_start", LoopStart,Samples(0));
			rSet(r, "loop_end", LoopEnd,Samples(0));
			rSet(r, "sync_beats", SyncBeats,Beats(0.));
			rSet(r, "sync_offset", SyncOffset,Beats(0.));
				
			rSet(r, "transpose", Transpose,Semitones(0));
			rSet(r, "tune", Tune,Cents(0));
			rSet(r, "pitch_keycenter", PitchKeyCenter,MIDINote(60));
			rSet(r, "pitch_keytrack", PitchKeyTrack,Cents(100));
			rSet(r, "pitch_veltrack", PitchVelTrack,Cents(0));
			rSet(r, "pitch_random", PitchRandom,Cents(0));
			rSet(r, "bend_up", BendUp,Cents(200));
			rSet(r, "bend_down", BendDown,Cents(-200));
			rSet(r, "bend_step", BendDown,Cents(1));
				
			rSet(r, "pitcheg_delay", PitchEgDelay,Seconds(0.));
			rSet(r, "pitcheg_start", PitchEgStart,Percentage(0.));
			rSet(r, "pitcheg_attack", PitchEgAttack,Seconds(0.));
			rSet(r, "pitcheg_hold", PitchEgHold,Seconds(0.));
			rSet(r, "pitcheg_decay", PitchEgDecay,Seconds(0.));
			rSet(r, "pitcheg_sustain", PitchEgSustain,Percentage(100.));
			rSet(r, "pitcheg_release", PitchEgRelease,Seconds(100.));
			rSet(r, "pitcheg_depth", PitchEgDepth, Cents(0) );
			rSet(r, "pitcheg_vel2delay", PitchEgVel2Delay, ArbitraryFloat(0.) );
			rSet(r, "pitcheg_vel2attack", PitchEgVel2Attack, Seconds(0.) );
			rSet(r, "pitcheg_vel2hold", PitchEgVel2Hold, Seconds(0.) );
			rSet(r, "pitcheg_vel2decay", PitchEgVel2Decay, Seconds(0.) );
			rSet(r, "pitcheg_vel2sustain", PitchEgVel2Sustain, Percentage(0.) );
			rSet(r, "pitcheg_vel2release", PitchEgVel2Release, Seconds(0.) );
			rSet(r, "pitcheg_vel2depth", PitchEgVel2Depth, Cents(0) );
				
			rSet(r, "pitchlfo_delay", PitchLfoDelay, Seconds(0.) );
			rSet(r, "pitchlfo_fade", PitchLfoFade, Seconds(0.) );
			rSet(r, "pitchlfo_freq", PitchLfoFreq, Hertz(0.) );
			rSet(r, "pitchlfo_depth", PitchLfoDepth, Cents(0) );
			rSet(r, "pitchlfo_depthchanaft", PitchLfoDepthChanAft, Cents(0) );
			rSet(r, "pitchlfo_depthpolyaft", PitchLfoDepthPolyAft, Cents(0) );
			rSet(r, "pitchlfo_freqchanaft", PitchLfoFreqChanAft, Hertz(0.) );
			rSet(r, "pitchlfo_freqpolyaft", PitchLfoFreqPolyAft, Hertz(0.) );
				
			rSet(r, "fil_type", FilType, FilterTypeOption(Lpf2p) );
			rSet(r, "cutoff", Cutoff, Hertz(-1.) );
			rSet(r, "cutoff_chanaft", CutoffChanAft, Cents(0) );
			rSet(r, "cutoff_polyaft", CutoffPolyAft, Cents(0) );
			rSet(r, "resonance", Resonance, DB(0) );
			rSet(r, "fil_keytrack", FilKeyTrack, Cents(0) );
			rSet(r, "fil_keycenter", FilKeyCenter, MIDINote(60) );
			rSet(r, "fil_veltrack", FilVelTrack, Cents(0) );
			rSet(r, "fil_random", FilRandom, Cents(0) );
				
			rSet(r, "fileg_delay", FilEgDelay, Seconds(0.) );
			rSet(r, "fileg_start", FilEgStart, Percentage(0.) );
			rSet(r, "fileg_attack", FilEgAttack, Seconds(0.) );
			rSet(r, "fileg_hold", FilEgHold, Seconds(0.) );
			rSet(r, "fileg_decay", FilEgDecay, Seconds(0.) );
			rSet(r, "fileg_sustain", FilEgSustain, Percentage(100.) );
			rSet(r, "fileg_release", FilEgRelease, Seconds(0.) );
			rSet(r, "fileg_depth", FilEgDepth, Cents(0) );
			rSet(r, "fileg_vel2delay", FilEgVel2Delay, Seconds(0.) );
			rSet(r, "fileg_vel2attack", FilEgVel2Attack, Seconds(0.) );
			rSet(r, "fileg_vel2hold", FilEgVel2Hold, Seconds(0.) );
			rSet(r, "fileg_vel2decay", FilEgVel2Decay, Seconds(0.) );
			rSet(r, "fileg_vel2sustain", FilEgVel2Sustain, Percentage(0.) );
			rSet(r, "fileg_vel2release", FilEgVel2Release, Seconds(0.) );
			rSet(r, "fileg_vel2depth", FilEgVel2Depth, Cents(0) );
				
			rSet(r, "fillfo_delay", FilLfoDelay, Seconds(0.) );
			rSet(r, "fillfo_fade", FilLfoFade, Seconds(0.) );
			rSet(r, "fillfo_freq", FilLfoFreq, Hertz(0.) );
			rSet(r, "fillfo_depth", FilLfoDepth, Cents(0) );
			rSet(r, "fillfo_depthchanaft", FilLfoDepthChanAft, Cents(0) );
			rSet(r, "fillfo_depthpolyaft", FilLfoDepthPolyAft, Cents(0) );
			rSet(r, "fillfo_freqchanaft", FilLfoFreqChanAft, Hertz(0.) );
			rSet(r, "fillfo_freqpolyaft", FilLfoFreqPolyAft, Hertz(0.) );
			
			rSet(r, "volume", Volume, DB(0.) );
			rSet(r, "pan", Pan, Percentage(0.) );
			rSet(r, "width", Width, Percentage(0.) );
			rSet(r, "position", Position, Percentage(0.) );
			rSet(r, "amp_keytrack", AmpKeyTrack, DB(0.) );
			rSet(r, "amp_keycenter", AmpKeyCenter, MIDINote(60) );
			rSet(r, "amp_veltrack", AmpVelTrack, Percentage(100.) );
			rSet(r, "amp_random", AmpRandom, Hertz(0.) );
			rSet(r, "rt_decay", RtDecay, DBPerSecond(0.) );
			rSet(r, "output", Output, DB(0.) );
			rSet(r, "xfin_lokey", XFInLoKey, MIDINote(0) );
			rSet(r, "xfin_hikey", XFInHiKey, MIDINote(127) );
			rSet(r, "xfout_lokey", XFOutLoKey, MIDINote(127) );
			rSet(r, "xfout_hikey", XFOutHiKey, MIDINote(127) );
			rSet(r, "xf_keycurve", XFKeyCurve, CurveOption(Power) );
			rSet(r, "xfin_lovel", XFInLoVel, MIDI127Range(0) );
			rSet(r, "xfin_hivel", XFInHiVel, MIDI127Range(0) );
			rSet(r, "xfout_lovel", XFOutLoVel, MIDI127Range(127) );
			rSet(r, "xfout_hivel", XFOutHiVel, MIDI127Range(127) );
			rSet(r, "xf_velcurve", XFVelCurve, CurveOption(Power) );
			rSet(r, "xf_cccurve", XFCCCurve, CurveOption(Power) );
				
			rSet(r, "ampeg_delay", AmpegDelay, Seconds(0.) );
			rSet(r, "ampeg_start", AmpegStart, Percentage(0.) );
			rSet(r, "ampeg_attack", AmpegAttack, Seconds(0.) );
			rSet(r, "ampeg_hold", AmpegHold, Seconds(0.) );
			rSet(r, "ampeg_decay", AmpegDecay, Seconds(0.) );
			rSet(r, "ampeg_sustain", AmpegSustain, Percentage(100.) );
			rSet(r, "ampeg_release", AmpegRelease, Seconds(0.) );
			rSet(r, "ampeg_vel2delay", AmpegVel2Delay, Seconds(0.) );
			rSet(r, "ampeg_vel2attack", AmpegVel2Attack, Seconds(0.) );
			rSet(r, "ampeg_vel2hold", AmpegVel2Hold, Seconds(0.) );
			rSet(r, "ampeg_vel2decay", AmpegVel2Decay, Seconds(0.) );
			rSet(r, "ampeg_vel2sustain", AmpegVel2Sustain, Percentage(0.) );
			rSet(r, "ampeg_vel2release", AmpegVel2Release, Seconds(0.) );
				
			rSet(r, "amplfo_delay", AmpLfoDelay, Seconds(0.) );
			rSet(r, "amplfo_fade", AmpLfoFade, Seconds(0.) );
			rSet(r, "amplfo_freq", AmpLfoFreq, Hertz(0.) );
			rSet(r, "amplfo_depth", AmpLfoDepth, DB(0.) );
			rSet(r, "amplfo_depthchanaft", AmpLfoDepthChanAft, DB(0.) );
			rSet(r, "amplfo_depthpolyaft", AmpLfoDepthPolyAft, DB(0.) );
			rSet(r, "amplfo_freqchanaft", AmpLfoFreqChanAft, Hertz(0.) );
			rSet(r, "amplfo_freqpolyaft", AmpLfoFreqPolyAft, Hertz(0.) );
				
			rSet(r, "eq1_freq", EqFreq(1), Hertz(50.) );
			rSet(r, "eq2_freq", EqFreq(2), Hertz(500.) );
			rSet(r, "eq3_freq", EqFreq(3), Hertz(5000.) );
			rSet(r, "eq1_vel2freq", EqVel2Freq(1), Hertz(0.) );
			rSet(r, "eq2_vel2freq", EqVel2Freq(2), Hertz(0.) );
			rSet(r, "eq3_vel2freq", EqVel2Freq(3), Hertz(0.) );
			rSet(r, "eq1_bw", EqBw(1), Octaves(1.) );
			rSet(r, "eq2_bw", EqBw(2), Octaves(1.) );
			rSet(r, "eq3_bw", EqBw(3), Octaves(1.) );
			rSet(r, "eq1_gain", EqGain(1), DB(0.) );
			rSet(r, "eq2_gain", EqGain(2), DB(0.) );
			rSet(r, "eq3_gain", EqGain(3), DB(0.) );
			rSet(r, "eq1_vel2gain", EqVel2Gain(1), DB(0.) );
			rSet(r, "eq2_vel2gain", EqVel2Gain(2), DB(0.) );
			rSet(r, "eq3_vel2gain", EqVel2Gain(3), DB(0.) );
				
			rSet(r, "effect1", Effect1, Percentage(0.) );
			rSet(r, "effect2", Effect2, Percentage(0.) );
			default_cache = Serializer.run(r);
			return r;
		}
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
	OnLocc(controller : Int);
	OnHicc(controller : Int);
	Delay;
	DelayRandom;
	Delaycc(controller : Int);
	Offset;
	OffsetRandom;
	Offsetcc(controller : Int);
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
	PitchLfoDepthcc(controller : Int);
	PitchLfoDepthChanAft;
	PitchLfoDepthPolyAft;
	PitchLfoFreqcc(controller : Int);
	PitchLfoFreqChanAft;
	PitchLfoFreqPolyAft;
	FilType;
	Cutoff;
	Cutoffcc(controller : Int);
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
	FilEgDepth;
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
	FilLfoDepthcc(controller : Int);
	FilLfoDepthChanAft;
	FilLfoDepthPolyAft;
	FilLfoFreqcc(controller : Int);
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
	RtDecay;
	Output;
	Gaincc(controller : Int);
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
	XFInLocc(controller : Int);
	XFInHicc(controller : Int);
	XFOutLocc(controller : Int);
	XFOutHicc(controller : Int);
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
	AmpegDelaycc(controller : Int);
	AmpegStartcc(controller : Int);
	AmpegAttackcc(controller : Int);
	AmpegHoldcc(controller : Int);
	AmpegDecaycc(controller : Int);
	AmpegSustaincc(controller : Int);
	AmpegReleasecc(controller : Int);
	AmpLfoDelay;
	AmpLfoFade;
	AmpLfoFreq;
	AmpLfoDepth;
	AmpLfoDepthcc(controller : Int);
	AmpLfoDepthChanAft;
	AmpLfoDepthPolyAft;
	AmpLfoFreqcc(controller : Int);	
	AmpLfoFreqChanAft;	
	AmpLfoFreqPolyAft;	
	EqFreq(band:Int);
	EqFreqcc(controller : Int, band:Int);
	EqVel2Freq(band:Int);
	EqBw(band:Int);
	EqBwcc(controller : Int, band:Int);
	EqGain(band:Int);
	EqGaincc(controller : Int, band:Int);
	EqVel2Gain(band:Int);
	Effect1;
	Effect2;
}

enum SFZUnit
{
	Filename(name:String);
	MIDIChannel(number:Int);
	MIDINote(number:Int);
	MIDIPitchbend(number:Int);
	MIDICC(number:Int);
	MIDI127Range(number:Int);
	MIDIBPM(number:Float);
	ArbitraryFloat(number:Float);
	ArbitraryInt(number:Int);
	VelCurve(velocity : Int, level : Float);
	SwVelOption(which:SwVelUnit);
	TriggerOption(which:TriggerUnit);
	OffModeOption(which:OffModeUnit);
	Seconds(amount:Float);
	Beats(amount:Float);
	Samples(amount:Int);
	LoopModeOption(which:LoopModeUnit);
	CurveOption(which:CurveUnit);
	Semitones(amount:Int);
	Cents(amount:Int);
	Percentage(amount:Float);
	Hertz(amount:Float);
	Octaves(amount:Float);
	FilterTypeOption(which:FilterTypeUnit);
	DB(amount:Float);
	DBPerSecond(amount:Float);
}

enum SwVelUnit { Current; Previous; }
enum TriggerUnit { Attack; Release; First; Legato; }
enum OffModeUnit { Fast; Normal; }
enum LoopModeUnit { NoLoop; OneShot; LoopContinuous; LoopSustain; Default; }
enum FilterTypeUnit { Lpf1p; Hpf1p; Lpf2p; Hpf2p; Bpf2p; Brf2p; }
enum CurveUnit { Gain; Power; }

typedef SFZOpcodeInstance = {name:String, op:SFZOpcode, value:SFZUnit};