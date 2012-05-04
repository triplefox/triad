import com.ludamix.triad.audio.Codec;
import com.ludamix.triad.audio.SamplerSynth;
import com.ludamix.triad.audio.SMFParser;
import com.ludamix.triad.audio.SFZ;
import com.ludamix.triad.audio.TableSynth;
import com.ludamix.triad.ui.HSlider6;
import haxe.io.Bytes;
import haxe.io.BytesInput;
import haxe.Json;
import nme.Assets;
import nme.events.Event;
import flash.events.SampleDataEvent;
import nme.events.MouseEvent;
import nme.Lib;
import nme.media.Sound;
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
			var envelopes = SynthTools.interpretADSR(seq, attack.highlighted, decay.highlighted,
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
	
	public function hardReset()
	{
		seq.synths = new Array();
		seq.channels = new Array();
		seq.events = new Array();
		var voices = new Array<SoftSynth>();
		#if debug
		  for (n in 0...4) // trying not to kill cpu!
		#else
		  for (n in 0...32)
		#end
		{
			//var synth = new TableSynth();
			var synth = new SamplerSynth();
			seq.addSynth(synth);
			voices.push(synth);
		}
		for (n in 0...16)
		{
			if (n == 9)
				seq.addChannel(voices, percussion.getGenerator());
			else
				seq.addChannel(voices, melodic.getGenerator());
			//seq.addChannel(seq.synths, SamplerSynth.ofWAVE(seq.tuning, wav, wav_data));
			//seq.addChannel(seq.synths, TableSynth.generatorOf(TableSynth.defaultPatch()));
		}		
	}
	
	public function new()
	{
		
		Audio.init({Volume:{vol:1.0,on:true}},true);
		seq = new Sequencer();
		
		melodic = new SFZBank(seq, "sfz/");
		
		for (n in 0...128)
		{
         #if flash
		   var sfz_loadable = SFZ.load(seq, Bytes.ofData(Assets.getBytes("sfz/" + Std.string(n+1) + ".sfz")) );
         #else
			var sfz_loadable = SFZ.load(seq, Assets.getBytes("sfz/" + Std.string(n+1) + ".sfz"));
         #end

			melodic.assignSFZ(sfz_loadable[0], n);
		}
		
		percussion = new SFZBank(seq, "sfz/");
      #if flash
		var sfz_data = SFZ.load(seq, Bytes.ofData(Assets.getBytes("sfz/kit-standard.sfz")));
      #else
		var sfz_data = SFZ.load(seq, Assets.getBytes("sfz/kit-standard.sfz"));
      #end
		// hack:
		for (r in sfz_data[0].regions)
		{
			r.set("loop_mode", "one_shot"); // this reduces the amount of polyphony taken by stupid cymbal crashes
		}	
		for (n in 0...128)
		{
			percussion.assignSFZ(sfz_data[0], n);
		}
		
		hardReset();
		
		//seq.pushEvent(new SequencerEvent(SequencerEvent.NOTE_ON, seq.waveLength(55.0), chan.id, 0, 0, 1));
		//seq.pushEvent(new SequencerEvent(SequencerEvent.NOTE_ON, seq.waveLength(110.0), chan.id, 0, Std.int(seq.BPMToFrames(1,480.0)), 1));
		//seq.pushEvent(new SequencerEvent(SequencerEvent.NOTE_ON, seq.waveLength(220.0), chan.id, 0, Std.int(seq.BPMToFrames(2,480.0)), 1));
		//seq.pushEvent(new SequencerEvent(SequencerEvent.NOTE_ON, seq.waveLength(440.0), chan.id, 0, Std.int(seq.BPMToFrames(3,480.0)), 1));
		//seq.pushEvent(new SequencerEvent(SequencerEvent.NOTE_ON, seq.waveLength(880.0), chan.id, 0, Std.int(seq.BPMToFrames(4,480.0)), 1));
		//seq.pushEvent(new SequencerEvent(SequencerEvent.NOTE_OFF, null, chan.id, 0, Std.int(seq.BPMToFrames(5,480.0)), 1));
		
		seq.play("synth", "Volume");
		
		CommonStyle.init(null, "assets/sfx_test.mp3");
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
		
		songs = Json.parse(Assets.getText("assets/smf/song_db.json"));
		song_count = 0;
		for (n in songs)
		{
			if (n[1] == "assets/smf/doom_1_and_2/D_E1M1 - Hanger.mid")
			{
				break;
			}
			incSong();
		}
		
		loadSong();
		Lib.current.stage.addEventListener(Event.ENTER_FRAME, doLoop);
		
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
		events = SMFParser.load(seq, Assets.getBytes(songs[song_count][1]));
		
		// for debugging certain channels
		/*var ec = new Array<SequencerEvent>();
		for (n in events)
		{
			if (n.channel == 13)
			{
				ec.push(n);
			}
		}
		events = ec;*/
		
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
			if (c.getEvents().length > 0)
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
