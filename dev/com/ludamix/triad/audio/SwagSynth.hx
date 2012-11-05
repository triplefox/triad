package com.ludamix.triad.audio;

import com.ludamix.triad.audio.SoftSynth;
import com.ludamix.triad.tools.StringTools;

import com.ludamix.triad.tools.FastFloatBuffer;
import com.ludamix.triad.audio.Sequencer;
import com.ludamix.triad.audio.Envelope;
import com.ludamix.triad.audio.VoiceCommon;
import com.ludamix.triad.audio.SoundSample;
import com.ludamix.triad.tools.FloatPlayhead;

typedef SwagSynthPatch = {
	envelope_profiles : Array<EnvelopeProfile>,
	lfos : Array<LFO>,
	modulation_lfos : Array<LFO>,
	arpeggiation_rate : Float, // 0 = off, hz value
	wave_sweep : Array<Int>,
	filter_mode : Float,
	cutoff_frequency : Float,
	resonance_level : Float,
	volume : Float,
	pan : Float,
	transpose : Float
};

typedef SwagSynthBankDefinition = {bank:Int,instrument:Int,voices:Array<Dynamic>};
typedef SwagSynthBank = IntHash<IntHash<Array<SwagSynthPatch>>>;

class SwagSynth implements SoftSynth
{

	public var common : VoiceCommon;
	
	public var playhead : FloatPlayhead;
	
	public var table : Array<SoundSample>;
	
	public static inline var ATTACK = 0;
	public static inline var SUSTAIN = 1;
	public static inline var RELEASE = 2;
	public static inline var OFF = 3;
	
	public static inline var CYCLE_FULL = 0;
	public static inline var CYCLE_HALF = 1;
	public static inline var CYCLE_QUARTER = 2;
	
	// heuristic to ramp down priority when releasing
	public static inline var PRIORITY_RAMPDOWN = 0.95;
	// and ramp up priority when sustaining
	public static inline var PRIORITY_RAMPUP = 1;

	public function new(wavetable : Array<SoundSample>)
	{
		common = new VoiceCommon();
		playhead = new FloatPlayhead();
		this.table = wavetable;
	}
	
	public static function simpleGenerator(settings : SwagSynthPatch)
	{
		return new PatchGenerator(settings, function(settings, seq, ev) { 
			return [new PatchEvent(ev, settings) ]; 
		} );
	}
	
	public inline function waveIsTransitioning(wave : SoundSample)
	{
		return !(common.custom_data == wave || common.custom_data==null);
	}
	
	public inline function setPreviousWave(wave : SoundSample)
	{
		common.custom_data = wave;
	}
	
	public static function bankGenerator(bank : SwagSynthBank)
	{
		return new PatchGenerator(bank, function(settings : Dynamic, seq : Sequencer, ev : SequencerEvent) 
		{ 
			var ar = new Array(); 
			var chan : SequencerChannel = seq.channels[ev.channel];
			var b = settings.get(chan.bank_id);
			if (b != null) 
			{
				var voices : Array<SwagSynthPatch> = b.get(chan.patch_id);
				if (voices != null)
				{
					for (v in voices)
					{
						ar.push(new PatchEvent(ev, v));
					}
				}
			}
			return ar;
		} );
	}
	
	public static function defaultCycleSet()
	{
		// return the queue. Possibly reverse the sweep direction.
	}
	
	public static function defaultPatch(seq : Sequencer) : SwagSynthPatch
	{
		var m_lfos : Array<LFO> = 
			[ { frequency:6., depth:0.5, delay:0.05, attack:0.05, assigns:[VoiceCommon.AS_PITCH_ADD] } ];
		return 
			{ envelope_profiles:[Envelope.ADSR(seq.secondsToFrames, 0.01, 2.4, 0.15, 0.5, [VoiceCommon.AS_VOLUME_ADD]),
			Envelope.vector(seq.secondsToFrames, 
				[[0.0,1.0,1.5]], [[1.0,1.0,1.0]], [[1.0,1.0,1.0]], [VoiceCommon.AS_CUSTOM_ADD],1.)],
				lfos : new Array<LFO>(),
				//lfos : [{frequency:1.,depth:0.005,delay:0.,attack:0.5,assigns:[VoiceCommon.AS_FREQUENCY_ADD]}],
				modulation_lfos:m_lfos,
				arpeggiation_rate:0.0,
				//wave_sweep:StringTools.parseIntervalArray(["0..31"]),
				wave_sweep:StringTools.parseIntervalArray([289]),
				filter_mode:VoiceCommon.FILTER_OFF,
				cutoff_frequency:0.,
				resonance_level:0.,
				volume:0.15,
				pan:0.5,
				transpose:0.
				}
				;
	}
	
	public static function defaultBankDefinition()
	{
		var result = new Array<SwagSynthBankDefinition>();
		for (n in 0...127)
		{
			var r : SwagSynthBankDefinition = { bank:0, instrument:n, voices:[ 
				{wave_sweep:[288], transpose: -0.04, filter_mode:"ringmod_tuned", cutoff_frequency:1.3333, envelopes:[ { adsr:[0.01, 0.1, 0.001, 0., "volume_add"] } ] },
				{envelopes:[ { adsr:[0.05, 0.1, 0.1, 0.5, "volume_add"] }]},
				//{transpose:0., filter_mode:"ringmod_tuned", cutoff_frequency:4, lfos:[{frequency:1.2,depth:-0.05,delay:0.,attack:0.5,assigns:["pitch_add"]}]},
				//{transpose:0.02, wave_sweep:[64], filter_mode:"ringmod_tuned", cutoff_frequency:0.91666666666, lfos:[{frequency:1.,depth:0.05,delay:0.01,attack:0.,assigns:["pitch_add"]}]},
				//{ wave_sweep:["32...63"], volume:-0.15, transpose:-0.04 },
				//{ wave_sweep:["32...63"], lfos:[{frequency:4, depth:0.015, delay:0.01, attack:0., assigns:["pitch_add","volume_add"]}] },
				] };
			result.push(r);
		}
		return result;
	}
	
	public inline function write()
	{	
		return common.updateFollowers(progress_follower);
	}
	
	public function progress_follower(infos : VoiceFrameInfos, cur_follower : EventFollower, ?write : Bool)
	{
		
		var patch = cur_follower.patch_event.patch;
		
		var freq = infos.frequency;
		var wl = infos.wavelength;
		var left = infos.volume_left;
		var right = infos.volume_right;
		
		var buffer = common.buffer;
		var vol = (left + right) / 2;
		
		playhead.wl = Std.int(wl);
		
		var pos : Float = playhead.getSamplePos();
		buffer.playhead = 0;
		
		var sweeptab : Array<Int> = patch.wave_sweep;
		
		// apply the "frame_custom_adjust" of the event follower to find the wave for this frame
		var sweep_state = Std.int(Math.min(sweeptab.length-1, Math.max(0., Math.min(sweeptab.length, 
			common.frame_custom_adjust * sweeptab.length))));
		
		var wave = table[sweeptab[sweep_state]];	
		
		var mip = SoundSample.getMipmap(wl, common.sequencer.sampleRate(), freq, wave.mip_levels);
		
		if (common.sequencer.isSuffering())
			write = false;
		
		if (write) pos = runWavetable(buffer, wave, mip, wl, pos, left, right);
		
		playhead.setSamplePos(Std.int(pos)); // this whole thing may be wrong
		
		// Priority calculations.
		
		var ct = 0;
		var master = cur_follower.env[0];
		
		if (!master.isOff())
		{
			if (master.sustaining()) // encourage sustains to be retained
				cur_follower.patch_event.sequencer_event.priority += PRIORITY_RAMPUP;
		}
		if (master.releasing()) // ramp down on release
		{
			cur_follower.patch_event.sequencer_event.priority = 
				Std.int(cur_follower.patch_event.sequencer_event.priority * PRIORITY_RAMPDOWN);
		}
		
	}
	
	public inline function runWavetable(buffer : FastFloatBuffer, wave : SoundSample, mip : Int, 
		wl : Float, pos : Float, left : Float, right : Float) : Float
	{		
		
		buffer.playhead = 0;
		
		var samples_requested = 0;
		var sample_left = wave.mip_levels[mip].sample_left;
		var sample_right = wave.mip_levels[mip].sample_right;
		var loop_start = wave.loops[0].loop_start;
		var loop_end = wave.loops[0].loop_end / wave.mip_levels[mip].rate_multiplier;
		var loop_len = loop_end - loop_start;
		var inc = loop_len / wl;
		
		while (buffer.playhead < buffer.length)
		{
			
			// to handle wave transitions cleaner: we use the follower's custom data to hold the previous wave,
			// and run each cycle of CopyLoop using either the previous or current.
			
			// later we may want to add to CopyLoop to explicitly support this case? (there is a single sample of bleed
			// that is incorrectly calculated).
			
			if (waveIsTransitioning(wave))
			{
				sample_left = common.custom_data.mip_levels[mip].sample_left;
				sample_right = common.custom_data.mip_levels[mip].sample_right;
				loop_start = common.custom_data.loops[0].loop_start;
				loop_end = common.custom_data.loops[0].loop_end / common.custom_data.mip_levels[mip].rate_multiplier;
				loop_len = loop_end - loop_start;
				inc = loop_len / wl;
				samples_requested = SoundSample.getLoopLen(pos, buffer, inc, loop_end);
			}
			else
			{
				sample_left = wave.mip_levels[mip].sample_left;
				sample_right = wave.mip_levels[mip].sample_right;
				loop_start = wave.loops[0].loop_start;
				loop_end = wave.loops[0].loop_end / wave.mip_levels[mip].rate_multiplier;
				loop_len = loop_end - loop_start;
				inc = loop_len / wl;
				samples_requested = SoundSample.getLoopLen(pos, buffer, inc, loop_end);
			}
			
			var npos = ((pos - loop_start) % loop_end) + loop_start;
			if (npos != pos) // we successfully finished a cycle, so it's safe to switch waves now
			{
				setPreviousWave(wave);
				pos = npos;
			}
			
			if (inc == 1.) // drop
			{
				if (common.filter_mode == VoiceCommon.FILTER_OFF)
					CopyLoop.copyLoop(1, "mirror", [], "loop");
				else if (common.filter_mode == VoiceCommon.FILTER_LP)
					CopyLoop.copyLoop(1, "mirror", ["lowpass_filter"], "loop");
				else if (common.filter_mode == VoiceCommon.FILTER_HP)
					CopyLoop.copyLoop(1, "mirror", ["highpass_filter"], "loop");
				else if (common.filter_mode == VoiceCommon.FILTER_BP)
					CopyLoop.copyLoop(1, "mirror", ["bandpass_filter"], "loop");
				else if (common.filter_mode == VoiceCommon.FILTER_BR)
					CopyLoop.copyLoop(1, "mirror", ["bandreject_filter"], "loop");
				else if (common.filter_mode == VoiceCommon.FILTER_RINGMOD || 
						 common.filter_mode == VoiceCommon.FILTER_RINGMOD_TUNED)
					CopyLoop.copyLoop(1, "mirror", ["ringmod_filter"], "loop");
			}
			else // linear
			{
				if (common.filter_mode == VoiceCommon.FILTER_OFF)
					CopyLoop.copyLoop(2, "mirror", ["Interpolator.interp_linear"], "loop");
				else if (common.filter_mode == VoiceCommon.FILTER_LP)
					CopyLoop.copyLoop(2, "mirror", ["lowpass_filter","Interpolator.interp_linear"], "loop");
				else if (common.filter_mode == VoiceCommon.FILTER_HP)
					CopyLoop.copyLoop(2, "mirror", ["highpass_filter","Interpolator.interp_linear"], "loop");
				else if (common.filter_mode == VoiceCommon.FILTER_BP)
					CopyLoop.copyLoop(2, "mirror", ["bandpass_filter","Interpolator.interp_linear"], "loop");
				else if (common.filter_mode == VoiceCommon.FILTER_BR)
					CopyLoop.copyLoop(2, "mirror", ["bandreject_filter","Interpolator.interp_linear"], "loop");
				else if (common.filter_mode == VoiceCommon.FILTER_RINGMOD || 
						 common.filter_mode == VoiceCommon.FILTER_RINGMOD_TUNED)
					CopyLoop.copyLoop(2, "mirror", ["ringmod_filter","Interpolator.interp_linear"], "loop");
			}		
		
		}
		
		return pos;
	}
	
	public inline function lowpass_filter(a : Float) { return common.filter.getLP(a); }
	public inline function highpass_filter(a : Float) { return common.filter.getHP(a); }
	public inline function bandpass_filter(a : Float) { return common.filter.getBP(a); }
	public inline function bandreject_filter(a : Float) { return common.filter.getBR(a); }
	public inline function ringmod_filter(a : Float) { return common.filter.getRingMod(a); }
	
	public static var defaultCache : SwagSynthPatch;
	
	private static function _parsePatchVoice(seq : Sequencer, patch_voice : Dynamic) : SwagSynthPatch
	{
		if (defaultCache==null)
			defaultCache = defaultPatch(seq);
		var result = Reflect.copy(defaultCache);
		
		// here we should fill in the details - the different parse modes for envelopes, etc.
		
		if (Reflect.hasField(patch_voice, "envelopes"))
		{
			var ar = new Array<EnvelopeProfile>();
			result.envelope_profiles = ar;
			
			for (e in cast(patch_voice.envelopes,Array<Dynamic>))
			{
				if (Reflect.hasField(e, "adsr"))
				{
					var add_styles = new Array<Int>();
					var ct = 4; 
					while (ct < e.adsr.length) { add_styles.push(VoiceCommon.parseAddStyle(e.adsr[ct])); ct++; }
					var e = Envelope.ADSR(seq.secondsToFrames, e.adsr[0], e.adsr[1], e.adsr[2], e.adsr[3], add_styles);
					ar.push(e);
				}
				else if (Reflect.hasField(e, "dsahdshr"))
				{
					var add_styles = new Array<Int>();
					var ct = 11; 
					var env : Array<Dynamic> = e.dsahdshr;
					while (ct < env.length) { add_styles.push(VoiceCommon.parseAddStyle(env[ct])); ct++; }
					var e = Envelope.DSAHDSHR(
						seq.secondsToFrames, env[0], env[1], env[2], env[3], env[4], env[5], env[6],
							env[7], env[8], env[9], env[10], add_styles);
					ar.push(e);
				}
				else if (Reflect.hasField(e, "vector"))
				{
					var assigns : Array<String> = e.vector.assigns;
					var add_styles = new Array<Int>();
					for (n in assigns) add_styles.push(VoiceCommon.parseAddStyle(n));
					if (Reflect.hasField(e.vector, "sustain"))
						ar.push(Envelope.vector(
							seq.secondsToFrames, e.vector.attack, e.vector.sustain, e.vector.release, add_styles,
							e.vector.endpoint));
					else
						ar.push(Envelope.vector(
							seq.secondsToFrames, e.vector.attack, null, e.vector.release, add_styles,
							e.vector.endpoint));
				}
			}
		}
		
		var getLfo = function(l : Dynamic)
		{
			var add_styles = new Array<Int>(); 
			for (n in cast(l.assigns,Array<Dynamic>)) add_styles.push(VoiceCommon.parseAddStyle(n));
			return( { frequency:l.frequency, 
						   depth:l.depth, 
						   delay:l.delay, 
						   attack:l.attack, 
						   assigns:add_styles } );		
		}
		
		if (Reflect.hasField(patch_voice, "lfos"))
		{
			var ar = new Array<LFO>();
			result.lfos = ar;
			for (l in cast(patch_voice.lfos, Array<Dynamic>)) ar.push(getLfo(l));
		}
		
		if (Reflect.hasField(patch_voice, "modulation_lfos"))
		{
			var ar = new Array<LFO>();
			result.modulation_lfos = ar;
			for (l in cast(patch_voice.modulation_lfos, Array<Dynamic>)) ar.push(getLfo(l));		
		}
		
		if (Reflect.hasField(patch_voice, "filter_mode"))
		{
			result.filter_mode = VoiceCommon.parseFilterMode(patch_voice.filter_mode);
		}
		
		if (Reflect.hasField(patch_voice, "cutoff_frequency"))
		{
			result.cutoff_frequency = patch_voice.cutoff_frequency;
		}
		
		if (Reflect.hasField(patch_voice, "resonance_level"))
		{
			result.resonance_level = patch_voice.resonance_level;
		}
		
		if (Reflect.hasField(patch_voice, "volume"))
		{
			result.volume = patch_voice.volume;
		}
		
		if (Reflect.hasField(patch_voice, "pan"))
		{
			result.pan = patch_voice.pan;
		}
		
		if (Reflect.hasField(patch_voice, "transpose"))
		{
			result.transpose = patch_voice.transpose;
		}
		
		if (Reflect.hasField(patch_voice, "arpeggiation_rate"))
		{
			result.arpeggiation_rate = patch_voice.arpeggiation_rate;
		}
		
		if (Reflect.hasField(patch_voice, "wave_sweep"))
		{
			result.wave_sweep = com.ludamix.triad.tools.StringTools.parseIntervalArray(patch_voice.wave_sweep);
		}
		
		return result;
	}
	
	public static function buildBank(seq : Sequencer, definitions : Array<SwagSynthBankDefinition>) : SwagSynthBank
	{
		
		var result = new SwagSynthBank();
		
		for (p in definitions)
		{
			if (!Reflect.hasField(p, "bank")) throw "no bank assignment";
			if (!Reflect.hasField(p, "instrument")) throw "no instrument assignment";
			if (!Reflect.hasField(p, "voices")) throw "no voices";
			
			var voices = new Array<SwagSynthPatch>();
			
			for (v in cast(p.voices,Array<Dynamic>))
			{
				voices.push(_parsePatchVoice(seq, v));
				voices[voices.length - 1].arpeggiation_rate = voices.length - 1;
			}
			
			var cbank = result.get(p.bank);
			if (cbank == null) { cbank = new IntHash<Array<SwagSynthPatch>>(); result.set(p.bank, cbank); }
			var cinst = cbank.get(p.instrument);
			if (cinst == null) { cinst = new Array<SwagSynthPatch>(); cbank.set(p.instrument, cinst); }
			for (v in voices) cinst.push(v);
			
		}
		
		//throw (exportBank(seq, result)[0].voices);
		
		return result;
	}
	
	public static function exportBank(seq : Sequencer, patches : SwagSynthBank) : Array<SwagSynthBankDefinition>
	{
		var result = new Array<SwagSynthBankDefinition>();
		for (b_idx in patches.keys())
		{
			var bank = patches.get(b_idx);
			for (i_idx in bank.keys())
			{
				var def : Dynamic = { bank:b_idx, instrument:i_idx, voices:new Array<Dynamic>() };
				for (v in bank.get(i_idx))
				{
					def.voices.push({}); // TODO: STUB (must read out the voice stuff)
				}
				result.push(def);
			}
		}
		return result;
	}

}