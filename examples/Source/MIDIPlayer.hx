import com.ludamix.triad.audio.Codec;
import com.ludamix.triad.audio.MIDITuning;
import com.ludamix.triad.audio.SamplerSynth;
import com.ludamix.triad.audio.sf2.SampleHeader;
import com.ludamix.triad.audio.sf2.SF2;
import com.ludamix.triad.audio.sf2.SFSampleLink;
import com.ludamix.triad.audio.SMFParser;
import com.ludamix.triad.audio.SoundSample;
import com.ludamix.triad.format.SMF;
import com.ludamix.triad.audio.SFZ;
import com.ludamix.triad.audio.SFZBank;
import com.ludamix.triad.audio.TableSynth;
import com.ludamix.triad.audio.SwagSynth;
import com.ludamix.triad.audio.CycleBuilder;
import com.ludamix.triad.format.WAV;
import com.ludamix.triad.time.EventQueue;
import com.ludamix.triad.tools.Color;
import com.ludamix.triad.tools.FastFloatBuffer;
import com.ludamix.triad.ui.HSlider6;
import flash.utils.ByteArray;
import haxe.io.Bytes;
import haxe.io.BytesInput;
import haxe.Json;
import nme.Assets;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.Sprite;
import nme.events.Event;
import nme.events.SampleDataEvent;
import nme.events.MouseEvent;
import nme.Lib;
import nme.media.Sound;
import com.ludamix.triad.audio.dsp.Reverb;
import com.ludamix.triad.audio.Sequencer;
import com.ludamix.triad.audio.Audio;
import com.ludamix.triad.audio.SoftSynth;
import com.ludamix.triad.audio.SynthTools;
import com.ludamix.triad.ui.SettingsUI;
import com.ludamix.triad.ui.layout.LayoutBuilder;
import com.ludamix.triad.ui.Rect9;
import com.ludamix.triad.ui.Helpers;
import nme.net.SharedObject;
import nme.text.TextField;
import nme.utils.Endian;
import nme.Vector;
import com.ludamix.triad.tools.Visualization;

class MIDIPlayer
{

	var seq : Sequencer;	
	var events : Array<SequencerEvent>;
	var song_count : Int;
	var songs : Array<Array<String>>;
	var infos : TextField;
	var infos2 : TextField;
	
	var melodic : SFZBank;
	var percussion : SFZBank;
	
	var sf2 : SF2;
	
	public static inline var USING_SFZ = false;
	public static inline var SFZ_COMPRESSED = false;
	
	public static var num_voices = #if debug 4 #else 64 #end;
	public static var num_percussion_voices = #if debug 1 #else 16 #end;
	public static inline var MIP_LEVELS = #if debug 0 #else 8 #end;

	private function resetSamplerSynth()
	{
		var voices = new Array<SoftSynth>();
		// set up melodic voices
		for (n in 0...num_voices)
		{
			var synth = new SamplerSynth();
			synth.common.master_volume = 0.5;
			seq.addSynth(synth);
			voices.push(synth);
		}
		// setup channels
		for (n in 0...16)
		{
			var vgroup = new VoiceGroup(voices, num_voices>>1, n==9);
			
			if (USING_SFZ)
			{
				if (n == 9)
					seq.addChannel([vgroup], percussion.getGenerator());
				else
					seq.addChannel([vgroup], melodic.getGenerator());
			}
			else
			{
			if (n == 9)
				{
					seq.addChannel([vgroup], sf2.getGenerator(0,128));
					vgroup.channel.bank_id = 128;
				}
				else
					seq.addChannel([vgroup], sf2.getGenerator(0,0));			
			}
			
			// simple WAV sampler
			/*seq.addChannel([vgroup], SamplerSynth.ofWAVE(seq.tuning, wav, wav_data));*/

		}				
	}
	
	public function addVoice()
	{
		num_voices++; hardReset();
	}

	public function subVoice()
	{
		num_voices--; if (num_voices < 0) num_voices = 0; hardReset();
	}
	
	public function toggleFilter()
	{
		seq.filter_enabled = !seq.filter_enabled;
	}
	
	private function resetTableSynth()
	{
		var voices = new Array<SoftSynth>();
		var percussion_voices = new Array<SoftSynth>();
		// set up melodic voices
		for (n in 0...num_voices)
		{
			var synth = new TableSynth();
			synth.common.master_volume = 0.5;
			seq.addSynth(synth);
			voices.push(synth);
		}
		// dedicated percussion for when testing tablesynth
		for (n in 0...num_percussion_voices)
		{
			var synth = new SamplerSynth();
			synth.common.master_volume = 0.5;
			seq.addSynth(synth);
			percussion_voices.push(synth);
		}
		// setup channels
		for (n in 0...16)
		{
			if (n == 9)
			{
				if (USING_SFZ)
				{
					var vgroup = new VoiceGroup(percussion_voices, percussion_voices.length, n==9);
					seq.addChannel([vgroup], percussion.getGenerator());
				}
				else
				{
					var vgroup = new VoiceGroup(percussion_voices, percussion_voices.length, n==9);
					seq.addChannel([vgroup], sf2.getGenerator(0,128));
					vgroup.channel.bank_id = 128;				
				}
			}
			else
			{
				var vgroup = new VoiceGroup(voices, num_voices>>1, n==9);
				seq.addChannel([vgroup], TableSynth.generatorOf(TableSynth.defaultPatch(seq)));
			}

		}		
	}

	private function resetSwagSynth()
	{
		var voices = new Array<SoftSynth>();
		var percussion_voices = new Array<SoftSynth>();
		// set up melodic voices
		for (n in 0...num_voices)
		{
			var synth = new SwagSynth(wavetable);
			synth.common.master_volume = 0.5;
			seq.addSynth(synth);
			voices.push(synth);
		}
		// dedicated percussion
		for (n in 0...num_percussion_voices)
		{
			var synth = new SamplerSynth();
			synth.common.master_volume = 0.5;
			seq.addSynth(synth);
			percussion_voices.push(synth);
		}
		// setup channels
		for (n in 0...16)
		{
			if (n == 9)
			{
				if (USING_SFZ)
				{
					var vgroup = new VoiceGroup(percussion_voices, percussion_voices.length, n==9);
					seq.addChannel([vgroup], percussion.getGenerator());
				}
				else
				{
					var vgroup = new VoiceGroup(percussion_voices, percussion_voices.length, n==9);
					seq.addChannel([vgroup], sf2.getGenerator(0,128));
					vgroup.channel.bank_id = 128;				
				}
			}
			else
			{
				var vgroup = new VoiceGroup(voices, num_voices >> 1, n == 9);
				//var bankdef = SwagSynth.defaultBankDefinition();
				var bankdef = Json.parse(Assets.getText("assets/swagpatch.json"));
				seq.addChannel([vgroup], SwagSynth.bankGenerator(SwagSynth.buildBank(seq,bankdef)));
			}

		}		
	}
	
	public function hardReset()
	{
		seq.synths = new Array();
		seq.channels = new Array();
		seq.events = new Array();
		resetSamplerSynth();
		//resetTableSynth();
		//resetSwagSynth();
	}

	public var eq : EventQueue;
	public var sgc : SynthGUICommon;
	public var wavetable : Array<SoundSample>;
	public var shared_object : SharedObject;
	
	public function initWavetable()
	{
		wavetable = new Array();
		
		var FLUSH_CACHE = false;
		
		shared_object = SharedObject.getLocal("triad_synth_cache");
		try { if (FLUSH_CACHE) throw null;
			  var copy = new ByteArray(); // the unserializeSamples decompression is in-place, 
										  // so we do this to avoid dirtying the cache.
			  copy.writeBytes(shared_object.data.wavetable, 0, shared_object.data.wavetable.length);
			  wavetable = SoundSample.unserializeSamples(copy); 
			  }
		catch(d:Dynamic)
		{
		
			var viz = new Bitmap(new BitmapData(1, 1, true, 0));
			Lib.current.stage.addChild(viz);
			
			var updateViz = function() {
				if (wavetable.length > 0)
				{
					var v = Visualization.waveform(
						wavetable[wavetable.length-1].mip_levels[0].sample_left, 
						Main.W, Main.H >> 1); 
					viz.bitmapData = v.bitmapData; 
					viz.x = 0;
					viz.y = Main.H / 2 - viz.height / 2;
				}
			};
			
			eq.add(function() { eq.inter_queue = updateViz; } );
			for (n in CycleBuilder.defaultBank(seq.sampleRate(), wavetable))
				eq.add(n);
			eq.add(function() { shared_object.setProperty("wavetable", SoundSample.serializeSamples(wavetable));
								shared_object.flush(); } );
			eq.add(function() { eq.inter_queue = null; });
		}	
	}

	public function new()
	{

		Audio.init({Volume:{vol:1.0,on:true}},true);
		#if alchemy
			FastFloatBuffer.init(1024 * 1024 * 32);
		#end
		seq = new Sequencer(Std.int(44100), 4096,4,null,new Reverb(2048, 1800, 1.0, 1.0, 0.93, 1200, 2048));
		//seq = new Sequencer(Std.int(44100), 4096,8,null,new Reverb(2048, 1200, 1.0, 1.0, 0.83, 780, 1024));
		//seq = new Sequencer(Std.int(44100), 4096, 4);		
		
		sgc = new SynthGUICommon(seq);
		eq = new EventQueue();
		sgc.instPatchLoaderUI();
		
		initWavetable();
		
		if (USING_SFZ)
		{
			if (SFZ_COMPRESSED)
			{
				var sfzPath = "sfzcompressed/";
				
				eq.add(function() {
					var melodicData = Assets.getBytes(sfzPath + "melody.sfc");
					melodicData.endian = Endian.LITTLE_ENDIAN;
					melodic = SFZ.loadCompressed(seq, melodicData);
					sgc.loader_gui.keys.infos.text = "Loaded all instruments ";
					sgc.loader_gui.keys.infos.x = Main.W / 2 - sgc.loader_gui.keys.infos.width/2;
				});				
				
				eq.add(function() {
					var assign = new Array<SFZPatchAssignment>();
					for (n in 0...128)
						assign.push({sfz:0,patch:n});
					var percussionData = Assets.getBytes(sfzPath + "percussion.sfc");
					percussionData.endian = Endian.LITTLE_ENDIAN;
					percussion = SFZ.loadCompressed(seq, percussionData, assign);
					sgc.loader_gui.keys.infos.text = "Loaded percussion";
					sgc.loader_gui.keys.infos.x = Main.W / 2 - sgc.loader_gui.keys.infos.width/2;
				});
			
			}
			else
			{
				var sfzPath = "sfz/";
				var patchGenerator = function(n) {
					var header = WAV.read(Assets.getBytes(sfzPath + n), sfzPath + n);
					var content : PatchGenerator=  SamplerSynth.ofWAVE(header, n);
					return content;
				}
				
				melodic = new SFZBank(seq);
				for (n in 0...128)
				{
					eq.add(function() {
						var sfz = SFZ.load(seq, Assets.getBytes(sfzPath + Std.string(n + 1) + ".sfz"));
						melodic.configureSamples(sfz, patchGenerator);
						melodic.configureSFZ(sfz, n);
						sgc.loader_gui.keys.infos.text = "Loaded instrument " + Std.string(n + 1);
						sgc.loader_gui.keys.infos.x = Main.W / 2 - sgc.loader_gui.keys.infos.width/2;
					});

				}

				eq.add(function(){
					percussion = new SFZBank(seq);
					var sfz = SFZ.load(seq, Assets.getBytes(sfzPath + "kit-standard.sfz"));
					var assign = new Array<Int>();
					percussion.configureSamples(sfz, patchGenerator);
					for (n in 0...128) percussion.configureSFZ(sfz, n);
					sgc.loader_gui.keys.infos.text = "Loaded percussion";
					sgc.loader_gui.keys.infos.x = Main.W / 2 - sgc.loader_gui.keys.infos.width/2;
				});
			
			}
			eq.add(function() { sgc.instSMFPlayer(this); } );		
			eq.add(function() { sgc.startSMFPlayer(); } );				
		}
		else // SF2
		{
			eq.add(function() {
				sf2 = SF2.load(seq, Assets.getBytes("assets/E-MU 3.5 MB GM.sf2"));
				for (z in sf2.init(MIP_LEVELS, true))
					eq.add(z);
				eq.inter_queue = function()
				{
					sgc.loader_gui.keys.infos.text = 
						Std.format("${sf2.progress.samples_loaded.done}/${sf2.progress.samples_loaded.total} ")+
						Std.format("${sf2.progress.samples_mipped.done}/${sf2.progress.samples_mipped.total} ")+
						Std.format("${sf2.progress.presets_loaded.done}/${sf2.progress.presets_loaded.total} ")+
						Std.format("${sf2.progress.text}");
					sgc.loader_gui.keys.infos.x = Main.W / 2 - sgc.loader_gui.keys.infos.width / 2;
				}
				eq.add(function()
				{
					eq.inter_queue = null;
				});
				eq.add(function() { sgc.instSMFPlayer(this); } );
				eq.add(function() { sgc.startSMFPlayer(); } );				
			});
		}
		
		
		eq.start();

	}	

}