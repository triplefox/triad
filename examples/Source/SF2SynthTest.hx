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
import com.ludamix.triad.audio.TableSynth;
import com.ludamix.triad.format.WAV;
import com.ludamix.triad.time.EventQueue;
import com.ludamix.triad.tools.Color;
import com.ludamix.triad.tools.FastFloatBuffer;
import com.ludamix.triad.ui.HSlider6;
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
import nme.text.TextField;
import nme.utils.Endian;
import nme.Vector;

class SF2SynthTest
{

	var seq : Sequencer;	
	var sf2 : SF2;
	
	public static inline var MIP_LEVELS = 8;

	#if debug
		public static inline var VOICES = 4;
		public static inline var CHANNEL_POLYPHONY = 4;
		public static inline var PERCUSSION_VOICES = 1;
	#else
		public static inline var VOICES = 64;
		public static inline var CHANNEL_POLYPHONY = 64;
		public static inline var PERCUSSION_VOICES = 8;
	#end

	private function resetSamplerSynth()
	{
		var voices = new Array<SoftSynth>();
		// set up melodic voices
		for (n in 0...VOICES)
		{
			var synth = new SamplerSynth();
			synth.common.filter_cutoff_multiplier = 4.0;
			synth.common.master_volume = 0.5;
			seq.addSynth(synth);
			voices.push(synth);
		}
		// setup channels
		for (n in 0...16)
		{
			var vgroup = new VoiceGroup(voices, CHANNEL_POLYPHONY);

			if (n == 9)
			{
				seq.addChannel([vgroup], sf2.getGenerator(0,128));
				vgroup.channel.bank_id = 128;
			}
			else
				seq.addChannel([vgroup], sf2.getGenerator(0,0));

			/*seq.addChannel([vgroup], SamplerSynth.ofWAVE(seq.tuning, wav, wav_data));*/

		}				
	}

	private function resetTableSynth()
	{
		var voices = new Array<SoftSynth>();
		var percussion_voices = new Array<SoftSynth>();
		// set up melodic voices
		for (n in 0...VOICES)
		{
			var synth = new TableSynth();
			synth.common.master_volume = 0.5;
			seq.addSynth(synth);
			voices.push(synth);
		}
		// dedicated percussion for when testing tablesynth
		for (n in 0...PERCUSSION_VOICES)
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
				var vgroup = new VoiceGroup(percussion_voices, percussion_voices.length);
				seq.addChannel([vgroup], sf2.getGenerator(0,128));
				vgroup.channel.bank_id = 128;
			}
			else
			{
				var vgroup = new VoiceGroup(voices, CHANNEL_POLYPHONY);
				seq.addChannel([vgroup], TableSynth.generatorOf(TableSynth.defaultPatch(seq)));
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
	}

	public var eq : EventQueue;
	public var sgc : SynthGUICommon;

	public function new()
	{

		Audio.init({Volume:{vol:1.0,on:true}},true);
		#if alchemy
			FastFloatBuffer.init(1024 * 1024 * 32);
		#end
		seq = new Sequencer(Std.int(44100), 4096,8,null,new Reverb(2048, 1200, 1.0, 1.0, 0.83, 780, 1024));
		//seq = new Sequencer(Std.int(44100), 4096,8);

		sgc = new SynthGUICommon(seq);
		eq = new EventQueue();
		sgc.instPatchLoaderUI();

        var sfzPath = "sfz/";
        var patchGenerator = function(n) {
            var header = WAV.read(Assets.getBytes(sfzPath + n), sfzPath + n);
            var content : PatchGenerator=  SamplerSynth.ofWAVE(header, n);
            return content;
        }
        
		eq.add(function() {
			sf2 = SF2.load(seq, Assets.getBytes("assets/E-MU 8.0 MB GS FX Rev B.sf2"));
			sf2.init(seq, MIP_LEVELS);
			sgc.loader_gui.keys.infos.text = "Loaded SF2";
			sgc.loader_gui.keys.infos.x = Main.W / 2 - sgc.loader_gui.keys.infos.width / 2;
			//throw ""; // if we want to inspect tracelogs at load time
		});

		eq.add(function() { sgc.instSMFPlayer(hardReset); } );		
		eq.add(function() { sgc.startSMFPlayer(); } );		
		
		eq.start();

	}

}