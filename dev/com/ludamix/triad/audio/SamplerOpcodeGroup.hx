package com.ludamix.triad.audio;

import com.ludamix.triad.audio.SamplerSynth;
import com.ludamix.triad.audio.Sequencer;
import com.ludamix.triad.audio.Envelope;

class SamplerOpcodeGroup
{

	// store region and groups for sampler patch opcodes

	public var regions : Array<Hash<Dynamic>>;
	public var region_cache : Array<{region:Hash<Dynamic>,patch:SamplerPatch}>;

	public function new():Void 
	{
		regions = new Array();
		regions.push(new Hash<Dynamic>()); // the empty region, representing group-global
	}

	public function getSampleNames()
	{
		var set = new Array<String>();
		for (n in regions)
		{
			if (n.exists("sample"))
			{
				set.push(n.get("sample"));
			}
		}
		return set;
	}
	
	// instead of "cacheRegions" we should call it "parseOpcodes."
	// i.e. it's the last step in creating a final sampler patch.
	// in its first incarnation it'll be 90% the same...
	// gradually we'll move more and more of this stuff back out to SFZ, and then add equivalents in SF2.
	// after it stablizes we can consider Enumifying it.
	
	public function parseOpcodes(seq : Sequencer)
	{
		region_cache = new Array();
		for ( directives in regions )
		{
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
			// but I am using "real" dbs (+/- 10db = power*/2) here because it seems a little better.
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
				base_frequency : seq.tuning.midiNoteToFrequency(midinote)
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

/*
 * The stuff below is going to be part of the new opcode parsing system.
 * It works like this:
 * 
 * 1. Original sampler data(SF2 or SFZ) is parsed into enums and metadata describing each opcode and its quantities
 * 2. The opcodes are cached into trigger ranges(key, vel, etc.) according to the rules of the format - presets/groups/etc.
 * 		(this is possibly the most crucial difference - by the time we reach internal opcodes hierarchy should be gone)
 * 3. Source opcodes are interpreted into internal opcodes. We apply enums to help in automating conversions between
 * 	 the different units, toggles, etc. This replaces the existing cacheRegions code with a hopefully less delicate system.
 * 4. (TBD) Internal opcodes are either converted to the existing anonymous-object/hash bundle, or we rework the system to
 * make use of them. 
 * 
 * For right now we aren't going to use these enums, instead focusing on the parse structure of the specific formats
 * and reusing the existing system for final output. Later we can go back and apply this structure to the parsing.
 * 
 * */

enum SamplerOpcode
{
	AmplitudeEnvelope(mode : EnvelopeMode);
	FilterEnvelope(mode : EnvelopeMode);
	SampleLoopMode(mode : Int);
	Pan(pct : Float);
	Cutoff(hz : Float);
	Resonance(level : Float);
	PitchKeycenter(midinote : Float);	
}

enum EnvelopeMode
{
	Delay(ms : Float);
	Start(value : Float);
	Attack(ms : Float);
	Hold(ms : Float);
	Decay(ms : Float);
	Sustain(value : Float);
	Release(ms : Float);	
}

enum SamplerUnit
{
	SUSamples;
	SUCents;
	SUSemitones;
	SUPercents;
	SUDB;
	SUHz;
	SUUndefined;
}