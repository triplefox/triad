package com.ludamix.triad.audio;

import com.ludamix.triad.format.wav.Reader;
import haxe.Json;
import nme.Assets;

import com.ludamix.triad.audio.SamplerSynth;
import com.ludamix.triad.audio.Sequencer;
import com.ludamix.triad.audio.MIDITuning;
import haxe.io.Bytes;
import haxe.io.BytesInput;

class SFZGroup
{
	
	// store region and groups
	
	public var group_opcodes : Hash<Dynamic>;
	public var regions : Array<Hash<Dynamic>>;
	
	public function new():Void 
	{
		group_opcodes = new Hash();
		regions = new Array();
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
	
	public function query(ev : SequencerEvent, seq : Sequencer, samples : Hash<SamplerPatch>) : Array<PatchEvent>
	{
		
		// currently only some region thingies are supported...
		
		var note = 0.;
		var velocity = 0;
		
		switch(ev.type)
		{
			case SequencerEvent.NOTE_ON, SequencerEvent.NOTE_OFF:
				note = seq.tuning.frequencyToMidiNote(ev.data.note);
				velocity = ev.data.velocity;
			default:
				return null;
		}
		
		var available = Lambda.filter(regions, function(r) { 
			return (
				(!r.exists("lokey") || r.get("lokey") <= note) &&				
				(!r.exists("hikey") || r.get("hikey") >= note) &&
				(!r.exists("lovel") || r.get("lovel") <= velocity) &&
				(!r.exists("hivel") || r.get("hivel") >= velocity)
			); } );
			
		var result = new Array<PatchEvent>();
		
		if (available.length < 1) available.push(new Hash<Dynamic>()); // allow group to assert itself when no regions defined
		
		for (region in available)
		{
			var sampler_patch : SamplerPatch =null;
			if (region.exists('sample'))
				sampler_patch = Reflect.copy(samples.get(region.get('sample')));
			else if (group_opcodes.exists('sample'))
				sampler_patch = Reflect.copy(samples.get(group_opcodes.get('sample')));
			sampler_patch.unpitched = true;
			
			// ampeg directives are all in % and seconds.
			var dsahdsr = [0.,1.,0.,0.,0.,1.,0.];
			
			for (directives in [group_opcodes, region])
			{
				if (directives.exists("pitch_keycenter"))
				{
					sampler_patch.sample.base_frequency = seq.tuning.midiNoteToFrequency(directives.get("pitch_keycenter"));
					sampler_patch.unpitched = false;
				}
				
				if (directives.exists("ampeg_delay")) { dsahdsr[0] = directives.get("ampeg_delay"); }
				if (directives.exists("ampeg_start")) { dsahdsr[1] = directives.get("ampeg_start"); }
				if (directives.exists("ampeg_attack")) { dsahdsr[2] = directives.get("ampeg_attack"); }
				if (directives.exists("ampeg_hold")) { dsahdsr[3] = directives.get("ampeg_hold"); }
				if (directives.exists("ampeg_decay")) { dsahdsr[4] = directives.get("ampeg_decay"); }
				if (directives.exists("ampeg_sustain")) { dsahdsr[5] = directives.get("ampeg_sustain"); }
				if (directives.exists("ampeg_release")) { dsahdsr[6] = directives.get("ampeg_release"); }
				
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
				
			}
			
			var envs = SynthTools.interpretDSAHDSR(seq, dsahdsr[0], dsahdsr[1], dsahdsr[2], dsahdsr[3],
				dsahdsr[4], dsahdsr[5], dsahdsr[6], SynthTools.CURVE_LINEAR, SynthTools.CURVE_LINEAR, 
					SynthTools.CURVE_LINEAR);
			sampler_patch.attack_envelope = envs.attack_envelope;
			sampler_patch.sustain_envelope = envs.sustain_envelope;
			sampler_patch.release_envelope = envs.release_envelope;
			
			var patch_event = new PatchEvent(
				new SequencerEvent(ev.type, ev.data, ev.channel, ev.id, ev.frame, ev.priority),
				sampler_patch);
			result.push(patch_event);
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
			if (upper == n) return ct;
			ct++;
		}
		
		// number?
		var before_deci : String = ""; 
		var after_deci : String = "";
		var decimal : Bool = false;
		var ok : Bool = true;
		for (idx in 0...value.length)
		{
			switch(value.charAt(idx))
			{
				case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9": 
					if (decimal) after_deci += value.charAt(idx);
					else before_deci += value.charAt(idx);
				case ".": if (decimal) { ok = false;  break; } else { decimal = true; }
				default:
					ok = false;  break;
			}
		}
		if (ok) { if (decimal) return Std.parseFloat(value); else return Std.parseInt(value); }
		
		// string...
		return value;		
	}
	
	public static function load(seq : Sequencer, file : Bytes) : Array<SFZGroup>
	{
		var i = new BytesInput(file);
		var str = i.readString(file.length);
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
			l = StringTools.trim(l);
			if (l.length == 0 || StringTools.startsWith(l, "//")) { } // pass
			else if (StringTools.startsWith(l, "<group>")) { cur_group = new SFZGroup(); groups.push(cur_group); 
				ctx = GROUP;  } // group
			else if (StringTools.startsWith(l, "<region>")) { cur_region = new Hash<Dynamic>(); 
				if (cur_group == null) { cur_group = new SFZGroup(); groups.push(cur_group); }
				cur_group.regions.push(cur_region); ctx = REGION;  } // region
			else if (l.indexOf("=") >= 0) // opcode
			{
				var parts = l.split("=");
				parts[1] = StringTools.trim(parts[1].split("//")[0]); // eliminate comments
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
	public var path : String;
	
	// This is a toolbox to grab and allocate samples that SFZ instances are requesting.
	
	public function new(seq, path)
	{
		this.seq = seq;
		this.path = path;
		samples = new Hash();
		sfz_programs = new IntHash();
	}
	
	public function assignSFZ(sfz : SFZGroup, program : Int)
	{
		var req_samples = sfz.getSamples();
		for (n in req_samples)
		{
			if (!samples.exists(n))
			{
				var reader = new Reader(new BytesInput(Bytes.ofData(Assets.getBytes(path + n))));
				var header = reader.read();
				var content : PatchGenerator = SamplerSynth.ofWAVE(seq.tuning, header);
				samples.set(n, content.settings);
			}
		}
		sfz_programs.set(program, sfz);
	}
	
	public function getProgramOfEvent(ev : SequencerEvent, number : Int) : Array<PatchEvent>
	{
		if (sfz_programs.exists(number))
			return sfz_programs.get(number).query(ev, seq, samples);
		else return null;
	}
	
	public function getGenerator()
	{
		return new PatchGenerator(this, function(settings, seq, seq_event) : Array<PatchEvent> { 
			return getProgramOfEvent(seq_event, seq.channels[seq_event.channel].patch_id);
		} );
	}
	
}