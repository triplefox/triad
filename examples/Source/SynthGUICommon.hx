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
import com.ludamix.triad.format.tar.Reader;
import nme.utils.ByteArray;
import format.tar.Data;
import haxe.io.Bytes;
import haxe.io.BytesData;
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

using com.ludamix.triad.tools.ByteArrayTools;

#if flash import com.ludamix.triad.io.FlashIO; #end

typedef SongEntry = {fileName: String, data:Bytes, path: String};

class SynthGUICommon
{

	public var events : Array<SequencerEvent>;
	public var song_count : Int;
	public var songs : Array<SongEntry>;
	public var infos : TextField;
	public var infos2 : TextField;
	public var loader_gui : LayoutResult;
	public var seq : Sequencer;
	public var app : Dynamic;
	
	public function new(seq)
	{
		this.seq = seq;
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
		while (songs[song_count].path == cur_group.path)
		{
			incSong();
		}
	}

	public function decGroup()
	{
		var cur_group = songs[song_count];
		while (songs[song_count].path == cur_group.path)
		{
			decSong();
		}
	}
	
	public function addSong(entry : SongEntry, ?set_to_song = true)
	{
		songs.push(entry);
		if (set_to_song) song_count = songs.length - 1;
	}

	public function loadSong()
	{
		// output of toByteArray isn't rhythm-exact yet...
		//events = SMFParser.load(seq, SMF.read(songs[song_count].data.getData().bytesData2ByteArray());
		
		events = SMFParser.load(seq, songs[song_count].data.getData().bytesData2ByteArray());

		for (e in events)
		{
			// for some reason a very large number of SMFs will try to set the percussion to the melodic bank,
			// which sounds idiotic.
			if (e.type == SequencerEvent.SET_BANK && e.channel == 9 && e.data.value == 0)
			{
				e.data = -1;
			}
		}

		seq.pushEvents(events.copy());
		infos.text = "playing " + songs[song_count].fileName;
		infos.x = Main.W / 2 - infos.width / 2;
	}

	public function doLoop(_)
	{
		if (seq.events.length<1)
		{
			incSong();
			app.hardReset();
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
		infos2.text = Std.string(cc) + "/" + Std.string(seq.synths.length) + " playing. Programs: " + prog_str +
			(seq.isSuffering() ? " Suffering!" : (" Filter "+(seq.filter_enabled ? "on." : "off.")));
		infos2.x = Main.W / 2 - infos2.width / 2;
	}
	
	public function instPatchLoaderUI()
	{
		CommonStyle.init(null, "assets/sfx_test.mp3");
		loader_gui = 
			LayoutBuilder.create(0, 0, Main.W, Main.H, LDRect9(new Rect9(CommonStyle.rr, Main.W, Main.H, true), 
				LAC(0, 0), null,
				LDPackV(LPMMinimum, LAC(0, 0), null, [
					LDDisplayObject(Helpers.quickLabel(CommonStyle.cascade, "Text Infos"),LAC(0,0),"infos"),
				])));
		Lib.current.stage.addChild(loader_gui.sprite);	
	}
	
	public function instSMFPlayer(app : Dynamic)
	{
		var gui_data = 
		LayoutBuilder.create(0, 0, Main.W, Main.H, 
			LDRect9(new Rect9(CommonStyle.rr, Main.W, Main.H, true), LAC(0, 0), null,
			LDPackV(LPMMinimum, LAC(0, 0), null, [
				LDPackH(LPMMinimum, LAC(0, 0), null, [
					LDDisplayObject(Helpers.labelButtonRect9(CommonStyle.basicButton, "Volume").button,LAC(0,0),"volume"),
					LDDisplayObject(Helpers.labelButtonRect9(CommonStyle.basicButton, "Polyphony+").button,LAC(0,0),"polyphonyadd"),
					LDDisplayObject(Helpers.labelButtonRect9(CommonStyle.basicButton, "Polyphony-").button,LAC(0,0),"polyphonysub"),
					LDDisplayObject(Helpers.labelButtonRect9(CommonStyle.basicButton, "Filter Toggle").button,LAC(0,0),"filter_toggle"),
				]),
				LDPackH(LPMMinimum, LAC(0, 0), null, [
					LDDisplayObject(Helpers.labelButtonRect9(CommonStyle.basicButton, "Prev Track").button,LAC(0,0),"prev_track"),
					LDDisplayObject(Helpers.labelButtonRect9(CommonStyle.basicButton, "Next Track").button,LAC(0,0),"next_track"),				
				]),
				LDPackH(LPMMinimum, LAC(0, 0), null, [
					LDDisplayObject(Helpers.labelButtonRect9(CommonStyle.basicButton, "Prev Group").button,LAC(0,0),"prev_group"),
					LDDisplayObject(Helpers.labelButtonRect9(CommonStyle.basicButton, "Next Group").button,LAC(0,0),"next_group"),
				]),
				LDPackH(LPMMinimum, LAC(0, 0), null, [
					LDDisplayObject(Helpers.labelButtonRect9(CommonStyle.basicButton, "Load MIDI File").button,LAC(0,0),"load_midi"),
				]),
				LDDisplayObject(Helpers.quickLabel(CommonStyle.cascade, "Text Infos"),LAC(0,0),"infos"),
				LDDisplayObject(Helpers.quickLabel(CommonStyle.cascade, "0/0"), LAC(0, 0), "infos2"),
			])));

		infos = gui_data.keys.infos;
		infos2 = gui_data.keys.infos2;
		this.app = app;

		gui_data.keys.volume.addEventListener(MouseEvent.CLICK, function(d:Dynamic) { 
			CommonStyle.settings.visible = true; }
			);
		gui_data.keys.polyphonyadd.addEventListener(MouseEvent.CLICK, function(d:Dynamic) { 
			app.addVoice(); loadSong(); }
			);
		gui_data.keys.polyphonysub.addEventListener(MouseEvent.CLICK, function(d:Dynamic) { 
			app.subVoice(); loadSong(); }
			);
		gui_data.keys.filter_toggle.addEventListener(MouseEvent.CLICK, function(d:Dynamic) { 
			app.toggleFilter(); }
			);
		gui_data.keys.next_track.addEventListener(MouseEvent.CLICK, function(d:Dynamic) { 
			app.hardReset(); incSong(); loadSong(); }
			);
		gui_data.keys.prev_track.addEventListener(MouseEvent.CLICK, function(d:Dynamic) { 
			app.hardReset(); decSong(); loadSong(); }
			);
		gui_data.keys.next_group.addEventListener(MouseEvent.CLICK, function(d:Dynamic) { 
			app.hardReset(); incGroup(); loadSong(); }
			);
		gui_data.keys.prev_group.addEventListener(MouseEvent.CLICK, function(d:Dynamic) { 
			app.hardReset(); decGroup(); loadSong(); }
			);
		gui_data.keys.load_midi.addEventListener(MouseEvent.CLICK, function(d:Dynamic) { 
			#if flash
			FlashIO.loadBytes(d, "Standard MIDI Format", "*.mid", function(b : Bytes) { 
				addSong( { fileName:"User loaded song", data:b, path:"" }, true );
				app.hardReset(); loadSong();
			}); 
			#else
			trace("midi load not implemented");			
			#end
			}
			);

		Lib.current.stage.addChild(gui_data.sprite);
		Lib.current.stage.addChild(CommonStyle.settings);
		CommonStyle.settings.visible = false;
		
		var smfbytearray = Assets.getBytes("assets/smf.tar");		
		
		var tar_reader = new Reader(new BytesInput(smfbytearray.byteArray2Bytes()));
		var songlist = Lambda.filter((Lambda.map(tar_reader.read(), function(e:Entry):SongEntry
			{
				var str = StringTools.replace(e.fileName,"\\","/");
				var split : Array<String> = str.split("/");
				split.pop();
				return { fileName:e.fileName, data:e.data, path:split.join("/") }; } 
			)), function(s:SongEntry) { return s.fileName.length>0; } );
		songs = Lambda.array(songlist);
		
		song_count = 0;
		for (n in songs)
		{
			var fname = n.fileName;
			//if (fname == "sam_n_max_hit_the_road/SNMEND.MID")
			if (fname == "heart_of_china/HOCGM1.MID")
			//if (fname == "doom_1_and_2/D_E1M1 - Hanger.mid")
			//if (fname == "little_big_adventure/LBA1-01.MID")
			//if (fname == "little_big_adventure/LBA1-04.MID")
			//if (fname == "wing_commander_privateer/Privateer I - Admiral Terell's Office.mid")
			//if (fname == "wing_commander_1/WC1MID36.MID")
			//if (fname == "wing_commander_1/WC1MID21.MID")
			//if (fname == "sam_n_max_hit_the_road/LAINTRO.MID")
			{
				break;
			}
			incSong();
		}

		app.hardReset();
		loadSong();	
	}
	
	public function startSMFPlayer()
	{
		seq.play("synth", "Volume");
		Lib.current.stage.addEventListener(Event.ENTER_FRAME, doLoop);	
	}

}

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
