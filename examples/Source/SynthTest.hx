import com.ludamix.triad.audio.Codec;
import com.ludamix.triad.audio.SamplerSynth;
import com.ludamix.triad.audio.SMFParser;
import com.ludamix.triad.format.SMF;
import com.ludamix.triad.audio.SFZ;
import com.ludamix.triad.audio.TableSynth;
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
import flash.events.SampleDataEvent;
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
import nme.Vector;

// Not for use outside Flash.

class ADSRUI
{
	
	public static function make(seq : Sequencer)
	{
		var attack : HSlider6 = null;		
		var decay : HSlider6 = null;		
		var sustain : HSlider6 = null;		
		var release : HSlider6 = null;
		
		// now have the synths take a template from the channel...
		
		var update = function() { 
			var envelopes = SynthTools.interpretADSR(seq.secondsToFrames, attack.highlighted, decay.highlighted,
				sustain.highlighted, release.highlighted, SynthTools.CURVE_POW, SynthTools.CURVE_SQR, SynthTools.CURVE_POW);
			for (n in seq.channels) { 
				//n.patch_generator.settings.attack_envelope = envelopes.attack_envelope; 
				//n.patch_generator.settings.sustain_envelope = envelopes.sustain_envelope; 
				//n.patch_generator.settings.release_envelope = envelopes.release_envelope; 
				} 
			};
		attack = new HSlider6(CommonStyle.slider, 100, 0.5, function(v : Float)
					{ update(); } );
		decay = new HSlider6(CommonStyle.slider, 100, 0.5, function(v : Float)
					{ update(); } );
		sustain = new HSlider6(CommonStyle.slider, 100, 0.5, function(v : Float)
					{ update(); } );
		release = new HSlider6(CommonStyle.slider, 100, 0.5, function(v : Float)
					{ update(); } );
		return LayoutBuilder.create(0, 0, 300, 300, LDRect9(new Rect9(CommonStyle.rr, 300, 300, true), LAC(0, 0), null,
			LDPackV(LPMFixed(LSRatio(1)), LAC(0, 0), null, [
				LDDisplayObject(attack, LAC(0,0), "attack"),
				LDDisplayObject(decay, LAC(0,0), "decay"),
				LDDisplayObject(sustain, LAC(0,0), "sustain"),
				LDDisplayObject(release, LAC(0,0), "release"),
			])));
	}
	
}

class SynthTest
{
	
	var seq : Sequencer;	
	var events : Array<SequencerEvent>;
	var song_count : Int;
	var songs : Array<Array<String>>;
	var infos : TextField;
	var infos2 : TextField;
	var melodic : SFZBank;
	var percussion : SFZBank;
	
	#if debug
		public static inline var VOICES = 4;
		public static inline var CHANNEL_POLYPHONY = 4;
		public static inline var PERCUSSION_VOICES = 1;
	#else
		public static inline var VOICES = 64;
		public static inline var CHANNEL_POLYPHONY = 48;
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
				seq.addChannel([vgroup], percussion.getGenerator());
			else
				seq.addChannel([vgroup], melodic.getGenerator());
			
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
				seq.addChannel([vgroup], percussion.getGenerator());
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
	
	public function queueFunction(func : Dynamic)
	{
		// uses closures to run all the events with a frame of gap.
		if (queue == null) queue = new Array();
		queue.push(function(time_start : Int) { 
			func(); 
			var time_end = Lib.getTimer();
			if (queue.length > 0)
			{
				if (time_end - time_start < 250)
					queue.shift()(time_start);
				else
				{
					var inner_func : Dynamic = null;
					inner_func = function(_) {
						Lib.current.removeEventListener(Event.ENTER_FRAME, inner_func);
						queue.shift()(Lib.getTimer());
					};
					Lib.current.addEventListener(Event.ENTER_FRAME, inner_func);
				}
			}
		});
	}
	
	public function startQueue() { queue.shift()(Lib.getTimer()); }
	
	public var queue : Array<Dynamic>;
	public var loader_gui : LayoutResult;
	
	public function new()
	{
		
		Audio.init({Volume:{vol:1.0,on:true}},true);
		#if alchemy
			FastFloatBuffer.init(1024 * 1024 * 32);
		#end
		//seq = new Sequencer(Std.int(44100), 4096,8,null,new Reverb(2048, 983, 1.0, 1.0, 0.83, 780));
		seq = new Sequencer(Std.int(44100), 4096,8);
		
		CommonStyle.init(null, "assets/sfx_test.mp3");
		loader_gui = 
			LayoutBuilder.create(0, 0, Main.W, Main.H, LDRect9(new Rect9(CommonStyle.rr, Main.W, Main.H, true), LAC(0, 0), null,
				LDPackV(LPMMinimum, LAC(0, 0), null, [
					LDDisplayObject(Helpers.quickLabel(CommonStyle.cascade, "Text Infos"),LAC(0,0),"infos"),
				])));
		Lib.current.stage.addChild(loader_gui.sprite);
		
		melodic = new SFZBank(seq, "sfz/");
		for (n in 0...128)
		{
			queueFunction(function(){
				var sfz_loadable = SFZ.load(seq, Assets.getBytes("sfz/" + Std.string(n+1) + ".sfz"));
				melodic.assignSFZ(sfz_loadable[0], [n]);
				loader_gui.keys.infos.text = "Loaded instrument " + Std.string(n + 1);
				loader_gui.keys.infos.x = Main.W / 2 - loader_gui.keys.infos.width/2;
			});

		}
		
		queueFunction(function(){
			percussion = new SFZBank(seq, "sfz/");
			var sfz_data = SFZ.load(seq, Assets.getBytes("sfz/kit-standard.sfz"));
			var assign = new Array<Int>();
			for (n in 0...128)
				assign.push(n);
			percussion.assignSFZ(sfz_data[0], assign);
			loader_gui.keys.infos.text = "Loaded percussion";
			loader_gui.keys.infos.x = Main.W / 2 - loader_gui.keys.infos.width/2;
		});
		
		queueFunction(function(){
			
			//Lib.current.stage.addChild(ADSRUI.make(seq).sprite);
			
			var gui_data = 
			LayoutBuilder.create(0, 0, Main.W, Main.H, LDRect9(new Rect9(CommonStyle.rr, Main.W, Main.H, true), LAC(0, 0), null,
				LDPackV(LPMMinimum, LAC(0, 0), null, [
					LDDisplayObject(Helpers.labelButtonRect9(CommonStyle.basicButton, "Settings").button,LAC(0,0),"settings"),
					LDDisplayObject(Helpers.labelButtonRect9(CommonStyle.basicButton, "Prev Track").button,LAC(0,0),"prev_track"),
					LDDisplayObject(Helpers.labelButtonRect9(CommonStyle.basicButton, "Next Track").button,LAC(0,0),"next_track"),
					LDDisplayObject(Helpers.labelButtonRect9(CommonStyle.basicButton, "Prev Group").button,LAC(0,0),"prev_group"),
					LDDisplayObject(Helpers.labelButtonRect9(CommonStyle.basicButton, "Next Group").button,LAC(0,0),"next_group"),
					LDDisplayObject(Helpers.quickLabel(CommonStyle.cascade, "Text Infos"),LAC(0,0),"infos"),
					LDDisplayObject(Helpers.quickLabel(CommonStyle.cascade, "0/0"),LAC(0,0),"infos2"),
				])));
			
			infos = gui_data.keys.infos;
			infos2 = gui_data.keys.infos2;
			
			gui_data.keys.settings.addEventListener(MouseEvent.CLICK, function(d:Dynamic) { 
				CommonStyle.settings.visible = true; }
				);
			gui_data.keys.next_track.addEventListener(MouseEvent.CLICK, function(d:Dynamic) { 
				hardReset(); incSong(); loadSong(); }
				);
			gui_data.keys.prev_track.addEventListener(MouseEvent.CLICK, function(d:Dynamic) { 
				hardReset(); decSong(); loadSong(); }
				);
			gui_data.keys.next_group.addEventListener(MouseEvent.CLICK, function(d:Dynamic) { 
				hardReset(); incGroup(); loadSong(); }
				);
			gui_data.keys.prev_group.addEventListener(MouseEvent.CLICK, function(d:Dynamic) { 
				hardReset(); decGroup(); loadSong(); }
				);
			
			Lib.current.stage.addChild(gui_data.sprite);
			Lib.current.stage.addChild(CommonStyle.settings);
			CommonStyle.settings.visible = false;
			
			songs = Json.parse(Assets.getText("assets/smf/song_db.json"));
			song_count = 0;
			for (n in songs)
			{
				//if (n[1] == "assets/smf/doom_1_and_2/D_E1M1 - Hanger.mid")
				//if (n[1] == "assets/smf/little_big_adventure/LBA1-01.MID")
				if (n[1] == "assets/smf/wing_commander_1/WC1MID36.MID")
				//if (n[1] == "assets/smf/wing_commander_1/WC1MID21.MID")
				//if (n[1] == "assets/smf/sam_n_max_hit_the_road/SNMEND.MID")
				{
					break;
				}
				incSong();
			}
			
			hardReset();
			loadSong();
		});
		
		queueFunction(function(){
			seq.play("synth", "Volume");
			Lib.current.stage.addEventListener(Event.ENTER_FRAME, doLoop);
			
			//drawDebugwaveform();
			
		});
		
		startQueue();
		
	}
	
	public function drawDebugwaveform()
	{
		var wf = TableSynth.pulseWavetable[0][0];
		var spr : Bitmap = new Bitmap(new BitmapData(wf.length, Main.H, false, 0));
		Lib.current.stage.addChild(spr);
		for (n in 0...wf.length)
		{
			spr.bitmapData.setPixel(Std.int(n), Std.int(Main.H/2 - 100), 0x444400);
			spr.bitmapData.setPixel(Std.int(n), Std.int(Main.H/2 + 100), 0x444400);
			spr.bitmapData.setPixel(Std.int(n), Std.int(Main.H/2), 0x444400);
		}
		for (n in 0...wf.length)
		{
			spr.bitmapData.setPixel(Std.int(n), Std.int(wf.get(n) * 100 + Main.H/2), 0x00FF00);
		}
		spr.scaleX *= Main.W / spr.width;
		spr.alpha = 0.5;
	}
	
	public function decSong()
	{
		song_count = (song_count - 1);
		if (song_count < 0) song_count = songs.length - 1;
	}
	
	public function incSong()
	{
		song_count = (song_count + 1) % songs.length;
	}
	
	public function incGroup()
	{
		var cur_group = songs[song_count];
		while (songs[song_count][0] == cur_group[0])
		{
			incSong();
		}
	}
	
	public function decGroup()
	{
		var cur_group = songs[song_count];
		while (songs[song_count][0] == cur_group[0])
		{
			decSong();
		}
	}
	
	public function loadSong()
	{
		// output of toByteArray isn't rhythm-exact yet...
		//events = SMFParser.load(seq, SMF.read(Assets.getBytes(songs[song_count][1])).toByteArray());
		events = SMFParser.load(seq, Assets.getBytes(songs[song_count][1]));
		
		/*for (e in events)
		{
			if (e.type == SequencerEvent.SET_PATCH)
				e.data = 47;
		}*/
		
		seq.pushEvents(events.copy());
		infos.text = "playing " + songs[song_count][1];
		infos.x = Main.W / 2 - infos.width / 2;
	}
	
	public function doLoop(_)
	{
		if (seq.events.length<1)
		{
			incSong();
			hardReset();
			loadSong();
		}
		var cc = 0;
		for (c in seq.synths)
		{
			if (c.common.getEvents().length > 0)
				cc++;
		}
		var programs = new Array<Int>();
		for (c in seq.channels)
		{
			programs.push(c.patch_id+1);
		}
		var prog_str = "";
		for (u in programs) prog_str += Std.string(u) + " ";
		infos2.text = Std.string(cc) + "/" + Std.string(seq.synths.length) + " playing. Programs: "+prog_str;
		infos2.x = Main.W / 2 - infos2.width / 2;
	}
	
	
	
}
