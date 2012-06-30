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

/*
 * Something I want to do eventually:
 * 		Shift from "SFZ programs" into a generic opcode executor much as I've separated the MIDI from
 * 		the internal sequencer implementation.
 * 
 * This will aid in new synth development by providing an abstract mechanism for common functionality of the engine:
 * 		envelope, LFO, filter, etc.
 * 		All I'd have to add in is elements unique to each synth.
 * 
 * */

class SFZGroup
{

	// store region and groups

	public var group_opcodes : Hash<Dynamic>;
	public var regions : Array<Hash<Dynamic>>;
	public var region_cache : Array<{region:Hash<Dynamic>,patch:SamplerPatch}>;

	public function new():Void 
	{
		group_opcodes = new Hash();
		regions = new Array();
		regions.push(new Hash<Dynamic>()); // the empty region, representing group-global
	}

	public function getSamples()
	{
		var set = new Array<String>();
		if (group_opcodes.exists("sample"))
		{
			set.push(group_opcodes.get("sample"));
		}
		for (n in regions)
		{
			if (n.exists("sample"))
			{
				set.push(n.get("sample"));
			}
		}
		return set;
	}

	public function cacheRegions(seq : Sequencer, samples : Hash<SamplerPatch>)
	{
		region_cache = new Array();
		for (region in regions)
		{
			var sampler_patch : SamplerPatch = null;
			if (region.exists('sample'))
				sampler_patch = Reflect.copy(samples.get(region.get('sample')));
			else if (group_opcodes.exists('sample'))
				sampler_patch = Reflect.copy(samples.get(group_opcodes.get('sample')));
			if (sampler_patch == null) continue; // no sample found...

			// ampeg directives are all in % and seconds.
			var amp_vals = [0., 0., 0., 0., 0., 1., 0.];			
			var fil_vals = [0., 0., 0., 0., 0., 1., 0.];
			var fil_depth = 0.;

			var midinote : Float = 60.0;
			for (directives in [group_opcodes, region])
			{
				if (directives.exists("pitch_keycenter"))
					midinote = directives.get("pitch_keycenter");
				if (directives.exists("tune")) { midinote -= (directives.get("tune")/100); }
				if (directives.exists("transpose")) { midinote -= directives.get("transpose"); }
				sampler_patch.base_frequency = seq.tuning.midiNoteToFrequency(midinote);

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

				if (directives.exists("loop_mode")) {
					switch(directives.get("loop_mode"))
					{
						case "no_loop": sampler_patch.loop_mode = SamplerSynth.NO_LOOP;
						case "one_shot": sampler_patch.loop_mode = SamplerSynth.ONE_SHOT;
						case "loop_continuous": sampler_patch.loop_mode = SamplerSynth.LOOP_FORWARD;
						case "loop_sustain": sampler_patch.loop_mode = SamplerSynth.SUSTAIN_FORWARD;						
					}
				}

				if (directives.exists("loop_start")) { sampler_patch.loop_start = directives.get("loop_start"); }
				if (directives.exists("loop_end")) { sampler_patch.loop_end = directives.get("loop_end"); }

				if (directives.exists("pan")) { sampler_patch.pan = ((directives.get("pan")/100)+1)/2; }
				if (directives.exists("volume")) { sampler_patch.volume = 1.0 *
					//1.0; }
					// in the sfz spec: "+6db = power*2, -6db = power/2"
					// but I am using "real" dbs (+/- 10db = power*/2) here because it seems a little better.
					Math.pow(2, directives.get("volume") / 10);  }

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

			}

			// create envelopes
			var ampeg = Envelope2.DSAHDSHR(seq.secondsToFrames, amp_vals[0], amp_vals[1], amp_vals[2], amp_vals[3],
				amp_vals[4], amp_vals[5], 0., amp_vals[6], 1., 1., 1., [VoiceCommon.AS_VOLUME_ADD]);
			sampler_patch.envelope_profiles = [ ampeg ];
			if (fil_depth != 0)
			{
				var fileg = Envelope2.DSAHDSHR(seq.secondsToFrames, fil_vals[0], fil_vals[1], fil_vals[2], fil_vals[3],
					fil_vals[4], fil_vals[5], 0., fil_vals[6], 1., 1., 1., [VoiceCommon.AS_FREQUENCY_ADD_CENTS]);
				sampler_patch.envelope_profiles.push(fileg);
			}

			// set default filter mode
			if ((fil_depth != 0 || sampler_patch.cutoff_frequency != 0.) && 
				sampler_patch.filter_mode == VoiceCommon.FILTER_OFF)
				sampler_patch.filter_mode == VoiceCommon.FILTER_LP;

			region_cache.push( { region:region, patch:sampler_patch } );
		}
	}

	public function query(ev : SequencerEvent, seq : Sequencer) : Array<PatchEvent>
	{

		// currently only some region thingies are supported...

		var note = 0.;
		var velocity = 0;

		switch(ev.type)
		{
			case SequencerEvent.NOTE_ON, SequencerEvent.NOTE_OFF:
				note = seq.tuning.frequencyToMidiNote(ev.data.freq);
				velocity = ev.data.velocity;
			default:
				return null;
		}

		var result = new Array<PatchEvent>();
		for (r_c in region_cache)
		{
			var r = r_c.region;
			if (
				(!r.exists("lokey") || r.get("lokey") <= note) &&				
				(!r.exists("hikey") || r.get("hikey") >= note) &&
				(!r.exists("lovel") || r.get("lovel") <= velocity) &&
				(!r.exists("hivel") || r.get("hivel") >= velocity)
			)
			{
				result.push(new PatchEvent(
					new SequencerEvent(ev.type, ev.data, ev.channel, ev.id, ev.frame, ev.priority),
					r_c.patch));
			}
		}

		return result;

	}

	public function toString()
	{
		var result = new Array<String>();
		result.push("Group:");
		for (n in group_opcodes.keys())
		{
			result.push(n+"="+group_opcodes.get(n));
		}
		for (region in regions)
		{
			result.push("Region:");
			for (n in region.keys())
			{
				result.push(n+"="+region.get(n));
			}
		}
		return Std.string(result);
	}

}

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
    
    public static function loadCompressed(seq:Sequencer, file : ByteArray, programs:Array<Int> = null) : SFZBank
    {
        var sfzBank = new SFZBank(seq);
        
        file.position = 0;
        
        var groups:Array<SFZGroup> = new Array<SFZGroup>();
        var waves:Hash<WAVE> = new Hash<WAVE>();
        
        // read all SFZDefinitionBlocks
        var blockCount = file.readInt();
        for (i in 0 ... blockCount)
        {
            trace("Def " + Std.string(i) + "/"  + Std.string(blockCount));
            var sfzSize = file.readInt();
            var sfz = readString(file, sfzSize);
            groups.push(loadFromData(seq, sfz)[0]);
        }
        
        // read all WaveFileBlocks
        blockCount = file.readInt();
        for (i in 0 ... blockCount)
        {
            trace("WAV " + Std.string(i) + "/"  + Std.string(blockCount));
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
            sfzBank.assignSFZ(groups[i], groupPrograms, function(n) : PatchGenerator {
                var header = waves.get(n);
                return SamplerSynth.ofWAVE(seq.tuning, header, n);
            });
        }
        
        return sfzBank;
    }

	public static function load(seq : Sequencer, file : ByteArray) : Array<SFZGroup>
    {
		file.position = 0;
		return loadFromData(seq, file.readUTFBytes(file.length));
    }
    
	public static function loadFromData(seq : Sequencer, str:String) : Array<SFZGroup>
	{
		var lines = str.split("\n");

		var HEAD = 0;
		var GROUP = 1;
		var REGION = 2;

		var groups = new Array<SFZGroup>();

		var ctx = HEAD;
		var cur_group : SFZGroup = null;
		var cur_region : Hash<Dynamic> = null;

		for (l in lines)
		{
			l = HString.trim(l);
			if (l.length == 0 || HString.startsWith(l, "//")) { } // pass
			else if (HString.startsWith(l, "<group>")) { 
				cur_group = new SFZGroup(); groups.push(cur_group); 
				ctx = GROUP;  } // group
			else if (HString.startsWith(l, "<region>")) { 
				if (cur_group == null) { cur_group = new SFZGroup(); groups.push(cur_group); }
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

}

class SFZBank
{

	public var samples : Hash<SamplerPatch>;
	public var sfz_programs : IntHash<SFZGroup>;
	public var seq : Sequencer;

	// This is a toolbox to grab and allocate samples that SFZ instances are requesting.

	public function new(seq)
	{
		this.seq = seq;
		samples = new Hash();
		sfz_programs = new IntHash();
	}

	public function assignSFZ(sfz : SFZGroup, programs : Array<Int>, patchGenerator : String -> PatchGenerator, ?recache : Bool=true)
	{
		var req_samples = sfz.getSamples();
		for (n in req_samples)
		{
			if (!samples.exists(n))
			{
				var content : PatchGenerator = patchGenerator(n);
				samples.set(n, content.settings);
			}
		}
		for (program in programs)
			sfz_programs.set(program, sfz);
		if (recache)
			sfz.cacheRegions(seq, samples);
	}

	public function getProgramOfEvent(ev : SequencerEvent, number : Int) : Array<PatchEvent>
	{
		if (sfz_programs.exists(number))
			return sfz_programs.get(number).query(ev, seq);
		else return null;
	}

	public function getGenerator()
	{
		return new PatchGenerator(this, function(settings, seq, seq_event) : Array<PatchEvent> { 
			return getProgramOfEvent(seq_event, seq.channels[seq_event.channel].patch_id);
		} );
	}

}