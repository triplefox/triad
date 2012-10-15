package com.ludamix.triad.audio;

import com.ludamix.triad.audio.dsp.ADSR;
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
typedef SFZOpcodeGroup = { group:SFZOpcodeRegion, regions:Array<SFZOpcodeRegion> };

typedef AftertouchDefinition = {channel:Float, poly:Float};

typedef SFZEnvelopeDefinition = { delay:Float, start:Float, attack:Float, hold:Float, decay:Float, sustain:Float,
	release:Float, depth:Float, cc:IntHash<Float>, vel2delay:Float, vel2attack:Float, vel2hold:Float, vel2decay:Float,
	vel2sustain:Float, vel2release:Float, vel2depth:Float };
typedef SFZLfoDefinition = { frequency:Float, depth:Float, delay:Float, attack:Float, freqcc:IntHash<Float>,
	depthcc:IntHash<Float>, depthaft:AftertouchDefinition, freqaft:AftertouchDefinition };
typedef SFZPatchAssignment = { sfz:Int, patch:Int };

class SFZ
{
	
	public var regions : Array<SFZOpcodeRegion>;
	public var cache : SamplerOpcodeGroup;
	
	public function new(seq : Sequencer, str : String)
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
		
		// now cache each region's final behavior
		
		this.regions = new Array();
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
			
			for (r in rcache)
			{
				regions.push(r);
			}
		}
	}

	public function getSampleManifest()
	{
		var man = new Array<String>();
		for (n in regions)
		{
			var s : SFZOpcodeInstance = n.get('sample'); 
			var u = translateSFZUnit(s.value);
			if (s != null) { man.remove(u); man.push(u); }
		}
		return man;
	}

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
    
    public static function loadCompressed(seq:Sequencer, file : ByteArray, 
		programs:Array<SFZPatchAssignment> = null) : SFZBank
    {
        var sfzBank = new SFZBank(seq);
        
        file.position = 0;
        
        var sfz_set:Array<SFZ> = new Array<SFZ>();
		
		var mip_levels = 4;
        
        // read all SFZDefinitionBlocks
        var blockCount = file.readInt();
        for (i in 0 ... blockCount)
        {
            var sfzSize = file.readInt();
            var sfz = readString(file, sfzSize);
            sfz_set.push(new SFZ(seq, sfz));
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
            
            sfzBank.samples.set(name, 
				SamplerSynth.patchOfSoundSample(SoundSample.ofWAVE(WAV.read(bytes), name, SamplerSynth.MIP_LEVELS)));

        }
        
        // assign groups to bank
		
		if (programs == null)
		{
			programs = new Array<SFZPatchAssignment>();
			for (n in 0...sfz_set.length)
				programs.push({sfz:n,patch:n});
		}
		
		for ( n in programs )
			sfzBank.configureSFZ(sfz_set[n.sfz], n.patch);
        
        return sfzBank;
    }

	public static function load(seq : Sequencer, file : ByteArray) : SFZ
    {
		file.position = 0;
		return new SFZ(seq, file.readUTFBytes(file.length));
    }
	
	public static inline function db2pctPower(db : Float)
	{
		return 1.0 * Math.pow(10, db/20.);
	}
	
	public function emitOpcodeGroup(seq : Sequencer, samples : Hash<SamplerPatch>, ?use_cache=true) : SamplerOpcodeGroup
	{
		
		if (cache != null && use_cache) return cache;
		this.cache = new SamplerOpcodeGroup();
		for (r in regions)
		{
		
			var ampeg_p : SFZEnvelopeDefinition = 
				{ delay:0., start:0., attack:0., hold:0., decay:0., sustain:1., release:0., depth:0.,
				  cc:new IntHash(), 
				  vel2delay:0., vel2attack:0., vel2hold:0., vel2decay:0., 
				  vel2sustain:0., vel2release:0., vel2depth:0. };
			var ampeg_cc = { delay:new IntHash(), start:new IntHash(), attack:new IntHash(), hold:new IntHash(),
				decay:new IntHash(), sustain:new IntHash(), release:new IntHash()};
			var pitcheg_p : SFZEnvelopeDefinition = 
				{ delay:0., start:0., attack:0., hold:0., decay:0., sustain:1., release:0., depth:0.,
				  cc:new IntHash(), 
				  vel2delay:0., vel2attack:0., vel2hold:0., vel2decay:0., 
				  vel2sustain:0., vel2release:0., vel2depth:0.};
			var use_pitcheg = false;
			var fileg_p : SFZEnvelopeDefinition =
				{ delay:0., start:1., attack:0., hold:0., decay:0., sustain:1., release:0., depth:0.,
				  cc:new IntHash(), 
				  vel2delay:0., vel2attack:0., vel2hold:0., vel2decay:0., 
				  vel2sustain:0., vel2release:0., vel2depth:0.};
			var use_fileg = false;	
			var amplfo_p : SFZLfoDefinition = { frequency:0., depth:0., delay:0., attack:0., 
				freqcc:new IntHash(), depthcc:new IntHash(), depthaft: { channel:0., poly:0. },
				freqaft:{channel:0.,poly:0.} };
			var use_amplfo = false;	
			var pitchlfo_p : SFZLfoDefinition = { frequency:0., depth:0., delay:0., attack:0.,
				freqcc:new IntHash(), depthcc:new IntHash(), depthaft: { channel:0., poly:0. },
				freqaft:{channel:0.,poly:0.} };
			var use_pitchlfo = false;	
			var fillfo_p : SFZLfoDefinition = { frequency:0., depth:0., delay:0., attack:0.,
				freqcc:new IntHash(), depthcc:new IntHash(), depthaft: { channel:0., poly:0. },
				freqaft:{channel:0.,poly:0.} };
			var use_fillfo = false;
			
			var patch : SamplerPatch = patchDefault();
			
			var pitch_keycenter = 60.;
			var transpose = 0.;
			var tune = 0.;
			
			var filter_mode = VoiceCommon.FILTER_UNDEFINED;
			var filter_cutoff = 0.;
			var filter_cutoff_cc = new IntHash<Float>();
			var filter_aft : AftertouchDefinition = {channel:0., poly:0.};
			var filter_resonance = 0.;
			
			var loop_mode : Int = SamplerSynth.LOOP_UNSPECIFIED;
			var loop_start : Float = -1;
			var loop_end : Float = -1;
			
			for (o in r)
			{
			
				var u : Dynamic = translateSFZUnit(o.value);
				
				switch(o.op)
				{
					case Sample: 
						if (patch.sample == null) patch.sample = samples.get(u).sample;
						if (patch.loops == null) 
						{
							loop_mode = patch.sample.loops[0].loop_mode;
							loop_start = patch.sample.loops[0].loop_start;
							loop_end = patch.sample.loops[0].loop_end;
						}
						if (patch.tuning == null) 
						{
							patch.tuning = { base_frequency:patch.sample.tuning.base_frequency,
								sample_rate:patch.sample.tuning.sample_rate };
						}
						if (patch.name == null) patch.name = patch.sample.name;
					case LoChan:
					case HiChan:
					case LoKey: patch.keyrange.low = u;
					case HiKey: patch.keyrange.high = u;
					case Key: patch.keyrange.low = u; patch.keyrange.high = u;
					case LoVel: patch.velrange.low = u;
					case HiVel: patch.keyrange.high = u;
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
					case OnLocc(controller):
					case OnHicc(controller):
					case Delay:
					case DelayRandom:
					case Delaycc(controller):
					case Offset:
					case OffsetRandom:
					case Offsetcc(controller):
					case End:
					case Count:
					case LoopMode: loop_mode = u;
					case LoopStart: loop_start = u;
					case LoopEnd: loop_end = u;
					case SyncBeats:
					case SyncOffset:
					case Transpose: transpose = u;
					case Tune: tune = u;
					case PitchKeyCenter: pitch_keycenter = u;
					case PitchKeyTrack:
					case PitchVelTrack:
					case PitchRandom:
					case BendUp:
					case BendDown:
					case BendStep:
					case PitchEgDelay: pitcheg_p.delay = u;
					case PitchEgStart: pitcheg_p.start = u;
					case PitchEgAttack: pitcheg_p.attack = u;
					case PitchEgHold: pitcheg_p.hold = u;
					case PitchEgDecay: pitcheg_p.decay = u;
					case PitchEgSustain: pitcheg_p.sustain = u;
					case PitchEgRelease: pitcheg_p.release = u;
					case PitchEgDepth: pitcheg_p.depth = u; use_pitcheg = true;
					case PitchEgVel2Delay: pitcheg_p.vel2delay = u;
					case PitchEgVel2Attack: pitcheg_p.vel2attack = u;
					case PitchEgVel2Hold: pitcheg_p.vel2hold = u;
					case PitchEgVel2Decay: pitcheg_p.vel2decay = u;
					case PitchEgVel2Sustain: pitcheg_p.vel2sustain = u;
					case PitchEgVel2Release: pitcheg_p.vel2release = u;
					case PitchEgVel2Depth: pitcheg_p.vel2depth = u;
					case PitchLfoDelay: pitchlfo_p.delay = u;
					case PitchLfoFade: pitchlfo_p.attack = u;
					case PitchLfoFreq: pitchlfo_p.frequency = u;
					case PitchLfoDepth: pitchlfo_p.depth = u; use_pitchlfo = true;
					case PitchLfoDepthcc(controller): pitchlfo_p.depthcc.set(controller, u);
					case PitchLfoDepthChanAft: pitchlfo_p.depthaft.channel = u;
					case PitchLfoDepthPolyAft: pitchlfo_p.depthaft.poly = u;
					case PitchLfoFreqcc(controller): pitchlfo_p.freqcc.set(controller, u);
					case PitchLfoFreqChanAft: pitchlfo_p.freqaft.channel = u;
					case PitchLfoFreqPolyAft: pitchlfo_p.freqaft.poly = u;
					case FilType: filter_mode = u;
					case Cutoff: filter_cutoff = u;
					case Cutoffcc(controller): filter_cutoff_cc.set(controller, u);
					case CutoffChanAft: filter_aft.channel = u;
					case CutoffPolyAft: filter_aft.poly = u;
					case Resonance: filter_resonance = u/100.;
					case FilKeyTrack:
					case FilKeyCenter:
					case FilVelTrack:
					case FilRandom:
					case FilEgDelay: fileg_p.delay = u;
					case FilEgStart: fileg_p.start = u;
					case FilEgAttack: fileg_p.attack = u;
					case FilEgHold: fileg_p.hold = u;
					case FilEgDecay: fileg_p.decay = u;
					case FilEgSustain: fileg_p.sustain = u;
					case FilEgRelease: fileg_p.release = u; 
					case FilEgDepth: fileg_p.depth = u; use_fileg = true;
					case FilEgVel2Delay: fileg_p.vel2delay = u;
					case FilEgVel2Attack: fileg_p.vel2attack = u;
					case FilEgVel2Hold: fileg_p.vel2hold = u;
					case FilEgVel2Decay: fileg_p.vel2decay = u;
					case FilEgVel2Sustain: fileg_p.vel2sustain = u;
					case FilEgVel2Release: fileg_p.vel2release = u;
					case FilEgVel2Depth: fileg_p.vel2depth = u;
					case FilLfoDelay: fillfo_p.delay = u;
					case FilLfoFade: fillfo_p.attack = u;
					case FilLfoFreq: fillfo_p.frequency = u;
					case FilLfoDepth: fillfo_p.depth = u; use_fillfo = true;
					case FilLfoDepthcc(controller): fillfo_p.depthcc.set(controller, u);
					case FilLfoDepthChanAft: fillfo_p.depthaft.channel = u;
					case FilLfoDepthPolyAft: fillfo_p.depthaft.poly = u;
					case FilLfoFreqcc(controller): fillfo_p.freqcc.set(controller, u);
					case FilLfoFreqChanAft: fillfo_p.freqaft.channel = u;
					case FilLfoFreqPolyAft: fillfo_p.freqaft.poly = u;
					case Volume: patch.volume = db2pctPower(u);
					case Pan: patch.pan = (u+1)/2.;
					case Width:
					case Position:
					case AmpKeyTrack:
					case AmpKeyCenter:
					case AmpVelTrack:
					case AmpVelCurve(velocity):
					case AmpRandom:
					case RtDecay:
					case Output:
					case Gaincc(controller):
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
					case XFInLocc(controller):
					case XFInHicc(controller):
					case XFOutLocc(controller):
					case XFOutHicc(controller):
					case XFCCCurve:
					case AmpegDelay: ampeg_p.delay = u;
					case AmpegStart: ampeg_p.start = u;
					case AmpegAttack: ampeg_p.attack = u;
					case AmpegHold: ampeg_p.hold = u;
					case AmpegDecay: ampeg_p.decay = u;
					case AmpegSustain: ampeg_p.sustain = u;
					case AmpegRelease: ampeg_p.release = u;
					case AmpegVel2Delay: ampeg_p.vel2delay = u;
					case AmpegVel2Attack: ampeg_p.vel2attack = u;
					case AmpegVel2Hold: ampeg_p.vel2hold = u;
					case AmpegVel2Decay: ampeg_p.vel2decay = u;
					case AmpegVel2Sustain: ampeg_p.vel2sustain = u;
					case AmpegVel2Release: ampeg_p.vel2release = u;
					case AmpegDelaycc(controller): ampeg_cc.delay.set(controller, u);
					case AmpegStartcc(controller): ampeg_cc.start.set(controller, u);
					case AmpegAttackcc(controller): ampeg_cc.attack.set(controller, u);
					case AmpegHoldcc(controller): ampeg_cc.hold.set(controller, u);
					case AmpegDecaycc(controller): ampeg_cc.decay.set(controller, u);
					case AmpegSustaincc(controller): ampeg_cc.sustain.set(controller, u);
					case AmpegReleasecc(controller): ampeg_cc.release.set(controller, u);
					case AmpLfoDelay: amplfo_p.delay = u;
					case AmpLfoFade: amplfo_p.attack = u;
					case AmpLfoFreq: amplfo_p.frequency = u;
					case AmpLfoDepth: amplfo_p.depth = db2pctPower(u)-1.; use_amplfo = true;
					case AmpLfoDepthcc(controller): amplfo_p.depthcc.set(controller, u);
					case AmpLfoDepthChanAft: amplfo_p.depthaft.channel = u;
					case AmpLfoDepthPolyAft: amplfo_p.depthaft.poly = u;
					case AmpLfoFreqcc(controller): amplfo_p.freqcc.set(controller, u);
					case AmpLfoFreqChanAft:	amplfo_p.depthaft.channel = u;
					case AmpLfoFreqPolyAft:	amplfo_p.depthaft.poly = u;
					case EqFreq(band):
					case EqFreqcc(controller, band):
					case EqVel2Freq(band):
					case EqBw(band):
					case EqBwcc(controller, band):
					case EqGain(band):
					case EqGaincc(controller, band):
					case EqVel2Gain(band):
					case Effect1:
					case Effect2:
				}
				
				/*
				var sampler_patch : SamplerPatch = null;
				if (directives.exists('sample_data'))
					sampler_patch = Reflect.copy(directives.get('sample_data'));
				if (sampler_patch == null) continue; // no sample found...
				
				// ampeg directives are all in % and seconds.
				var amp_vals = [0., 0., 0., 0., 0., 1., 0.];			
				var fil_vals = [0., 0., 0., 0., 0., 1., 0.];
				var fil_depth = 0.;

				var midinote : Float = 60.0;
				
				// in the sfz spec: "+6db = power*2, -6db = power/2"
				// but I am using "real" dbs (+/- 10db = power *  / 2) here because it seems a little better.
				// this can be modified with the db_convention directive.
				var db = 10.;
				var vol_db = 0.;
					
				if (directives.exists("pitch_keycenter"))
					midinote = directives.get("pitch_keycenter");
				
				// rewrite the tuning data
				if (directives.exists("tune")) { midinote -= (directives.get("tune")/100); }
				if (directives.exists("transpose")) { midinote -= directives.get("transpose"); }
				sampler_patch.tuning = {
					sample_rate : sampler_patch.tuning.sample_rate,
					base_frequency : EvenTemperament.midiNoteToFrequency(midinote)
				};

				if (directives.exists("ampeg_delay")) { amp_vals[0] = directives.get("ampeg_delay"); }
				if (directives.exists("ampeg_start")) { amp_vals[1] = directives.get("ampeg_start") / 100; }
				if (directives.exists("ampeg_attack")) { amp_vals[2] = directives.get("ampeg_attack"); }
				if (directives.exists("ampeg_hold")) { amp_vals[3] = directives.get("ampeg_hold"); } 
				if (directives.exists("ampeg_decay")) { amp_vals[4] = directives.get("ampeg_decay"); }
				if (directives.exists("ampeg_sustain")) { amp_vals[5] = directives.get("ampeg_sustain") / 100; }
				if (directives.exists("ampeg_release")) { amp_vals[6] = directives.get("ampeg_release"); }

				if (directives.exists("fileg_delay")) { fil_vals[0] = directives.get("fileg_delay"); }
				if (directives.exists("fileg_start")) { fil_vals[1] = directives.get("fileg_start") / 100; }
				if (directives.exists("fileg_attack")) { fil_vals[2] = directives.get("fileg_attack"); }
				if (directives.exists("fileg_hold")) { fil_vals[3] = directives.get("fileg_hold"); } 
				if (directives.exists("fileg_decay")) { fil_vals[4] = directives.get("fileg_decay"); }
				if (directives.exists("fileg_sustain")) { fil_vals[5] = directives.get("fileg_sustain") / 100; }
				if (directives.exists("fileg_release")) { fil_vals[6] = directives.get("fileg_release"); }
				if (directives.exists("fileg_depth")) { fil_depth = directives.get("fileg_depth"); }
				
				var sample = sampler_patch.sample;
				
				if (directives.exists("loop_mode")) {
					switch(directives.get("loop_mode"))
					{
						case "no_loop": sampler_patch.loops[0].loop_mode = SamplerSynth.NO_LOOP;
						case "one_shot": sampler_patch.loops[0].loop_mode = SamplerSynth.ONE_SHOT;
						case "loop_continuous": sampler_patch.loops[0].loop_mode = SamplerSynth.LOOP_FORWARD;
						case "loop_sustain": sampler_patch.loops[0].loop_mode = SamplerSynth.SUSTAIN_FORWARD;						
					}
				}
				
				if (directives.exists("loop_start")) { sampler_patch.loops[0].loop_start = directives.get("loop_start"); }
				if (directives.exists("loop_end")) { sampler_patch.loops[0].loop_end = directives.get("loop_end"); }

				if (directives.exists("pan")) { sampler_patch.pan = ((directives.get("pan")/100)+1)/2; }
				if (directives.exists("db_convention")) { db = directives.get("db_convention"); }
				if (directives.exists("volume")) { vol_db = directives.get("volume"); }

				if (directives.exists("cutoff")) { sampler_patch.cutoff_frequency = directives.get("cutoff"); }
				if (directives.exists("resonance")) { sampler_patch.resonance_level = directives.get("resonance"); }
				if (directives.exists("fil_type"))
				{
					var fil_type = directives.get("fil_type");
					if (fil_type == "lpf_1p") sampler_patch.filter_mode = VoiceCommon.FILTER_LP;
					else if (fil_type == "lpf_2p") sampler_patch.filter_mode = VoiceCommon.FILTER_LP;
					else if (fil_type == "hpf_1p") sampler_patch.filter_mode = VoiceCommon.FILTER_HP;
					else if (fil_type == "hpf_2p") sampler_patch.filter_mode = VoiceCommon.FILTER_HP;
					else if (fil_type == "bpf_1p") sampler_patch.filter_mode = VoiceCommon.FILTER_BP;
					else if (fil_type == "bpf_2p") sampler_patch.filter_mode = VoiceCommon.FILTER_BP;
					else if (fil_type == "brf_1p") sampler_patch.filter_mode = VoiceCommon.FILTER_BR;
					else if (fil_type == "brf_2p") sampler_patch.filter_mode = VoiceCommon.FILTER_BR;
				}
				
				sampler_patch.volume = 1.0 * Math.pow(2, vol_db / db);
				
				// create envelopes
				var ampeg = Envelope.DSAHDSHR(seq.secondsToFrames, amp_vals[0], amp_vals[1], amp_vals[2], amp_vals[3],
					amp_vals[4], amp_vals[5], 0., amp_vals[6], 1., 1., 1., [VoiceCommon.AS_VOLUME_ADD]);
				sampler_patch.envelope_profiles = [ ampeg ];
				if (fil_depth != 0)
				{
					var fileg = Envelope.DSAHDSHR(seq.secondsToFrames, fil_vals[0], fil_vals[1], fil_vals[2], fil_vals[3],
						fil_vals[4], fil_vals[5], 0., fil_vals[6], 1., 1., 1., [VoiceCommon.AS_FREQUENCY_ADD_CENTS]);
					sampler_patch.envelope_profiles.push(fileg);
				}

				// set default filter mode
				if ((fil_depth != 0 || sampler_patch.cutoff_frequency != 0.) && 
					sampler_patch.filter_mode == VoiceCommon.FILTER_OFF)
					sampler_patch.filter_mode == VoiceCommon.FILTER_LP;
				
				region_cache.push( { region:directives, patch:sampler_patch } );		
				*/
				
			}
			
			// finalize with all the buffered data.
			
			patch.tuning = {
				sample_rate : patch.tuning.sample_rate,
				base_frequency : EvenTemperament.cache.midiNoteToFrequency(pitch_keycenter - transpose - tune)
			};
			
			patch.envelope_profiles.push(ampeg(seq, ampeg_p));
			if (use_pitcheg) { patch.envelope_profiles.push(pitcheg(seq, pitcheg_p)); }
			if (use_fileg) { patch.envelope_profiles.push(fileg(seq, fileg_p)); }
			if (use_amplfo) { patch.lfos.push(amplfo(amplfo_p)); }
			if (use_pitchlfo) { patch.lfos.push(pitchlfo(pitchlfo_p)); }
			if (use_fillfo) { patch.lfos.push(fillfo(fillfo_p)); }
			
			if (loop_start == -1) loop_start = patch.sample.loops[0].loop_start;
			if (loop_end == -1) loop_end = patch.sample.loops[0].loop_end;
			if (loop_mode == SamplerSynth.LOOP_UNSPECIFIED) loop_mode = patch.sample.loops[0].loop_mode;
			patch.loops = [ { loop_start:Std.int(loop_start), loop_end:Std.int(loop_end), loop_mode:loop_mode } ];
			
			patch.filter_mode = filter_mode;
			patch.cutoff_frequency = filter_cutoff;
			patch.resonance_level = filter_resonance;
			if (patch.cutoff_frequency <= 1.) patch.filter_mode = VoiceCommon.FILTER_OFF;
			if (patch.cutoff_frequency > seq.sampleRate()>>1) patch.filter_mode = seq.sampleRate()>>1;
			
			cache.regions.push(patch);
		}
		return cache;
	}
	
	public static function translateSFZUnit(u : SFZUnit) : Dynamic
	{
		// these units are stubby translations.
		// ideally I want to categorize them such that every unit in SFZ is converted here, not in opcode gen.
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
			case Cents(amount): return amount / 100.; // to semitones
			case Percentage(amount): return amount / 100.; // to 0-1
			case Hertz(amount): return amount;
			case Octaves(amount): return amount;
			case FilterTypeOption(which): switch(which)
				{
					case Lpf1p: return VoiceCommon.FILTER_LP;
					case Hpf1p: return VoiceCommon.FILTER_HP;
					case Lpf2p: return VoiceCommon.FILTER_LP;
					case Hpf2p: return VoiceCommon.FILTER_HP;
					case Bpf2p: return VoiceCommon.FILTER_BP;
					case Brf2p: return VoiceCommon.FILTER_BR;
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
	
	// below are the default settings according to sfz spec, including envelopes etc.
	// these use the _internal_ units. make sure we convert before applying them.
	
	// as we implement more features from sfz, corrections to defaults may be needed.
	// one wrinkle is that sfz doesn't define modulations in the same way that I do - as a single lfo that's xfaded.
	// it can apply potentially every CC, instead.
	// since this isn't how my sequencer is set up it's just not worth worrying about for now.
	
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
	
	public static function ampeg(seq : Sequencer, env : SFZEnvelopeDefinition) : EnvelopeProfile
	{
		return Envelope.DSAHDSHR(function(a:Float) { return a; }, 
			seq.secondsToFrames(env.delay), 
			env.start, 
			seq.secondsToFrames(env.attack), 
			seq.secondsToFrames(env.hold), 
			seq.secondsToFrames(env.decay), env.sustain, 0., 
			seq.secondsToFrames(env.release), 1.0, 1.0, 1.0, 
			[VoiceCommon.AS_VOLUME_ADD]);
	}

	public static function pitcheg(seq : Sequencer, env : SFZEnvelopeDefinition) : EnvelopeProfile
	{
		return Envelope.DSAHDSHR(function(a:Float) { return a; }, 
			seq.secondsToFrames(env.delay), 
			env.start*env.depth, 
			seq.secondsToFrames(env.attack), 
			seq.secondsToFrames(env.hold), 
			seq.secondsToFrames(env.decay), 
			env.sustain * env.depth, 0., 
			seq.secondsToFrames(env.release), 
				1.0, 1.0, 1.0, [VoiceCommon.AS_PITCH_ADD]);
	}
	
	public static function fileg(seq : Sequencer, env : SFZEnvelopeDefinition) : EnvelopeProfile
	{
		return Envelope.DSAHDSHR(function(a:Float) { return a; }, 
			seq.secondsToFrames(env.delay), 
			env.start*env.depth, 
			seq.secondsToFrames(env.attack), 
			seq.secondsToFrames(env.hold), 
			seq.secondsToFrames(env.decay), 
			env.sustain * env.depth, 0., 
			seq.secondsToFrames(env.release), 
			1.0, 1.0, 1.0, 
			[VoiceCommon.AS_FREQUENCY_ADD_CENTS]);
	}
	
	public static function amplfo(lfo : SFZLfoDefinition)
	{
		return { frequency:lfo.frequency, depth:lfo.depth, delay:lfo.delay, attack:lfo.attack,
			assigns:[VoiceCommon.AS_VOLUME_ADD]};
	}
	
	public static function pitchlfo(lfo : SFZLfoDefinition)
	{
		return { frequency:lfo.frequency, depth:lfo.depth, delay:lfo.delay, attack:lfo.attack,
			assigns:[VoiceCommon.AS_PITCH_ADD]};
	}
	
	public static function fillfo(lfo : SFZLfoDefinition)
	{
		return { frequency:lfo.frequency, depth:lfo.depth, delay:lfo.delay, attack:lfo.attack,
			assigns:[VoiceCommon.AS_FREQUENCY_ADD_CENTS]};
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