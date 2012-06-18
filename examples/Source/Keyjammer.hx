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
import nme.events.KeyboardEvent;
import nme.geom.Rectangle;
import nme.ui.Keyboard;
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

class Keyjammer
{
	
	var seq : Sequencer;	
	var events : Array<SequencerEvent>;
	var song_count : Int;
	var songs : Array<Array<String>>;
	var infos : TextField;
	var infos2 : TextField;
	var melodic : SFZBank;
	var percussion : SFZBank;
	
	private function resetSamplerSynth()
	{
		var voices = new Array<SoftSynth>();
		// set up melodic voices
		#if debug
		  for (n in 0...4) // trying not to kill cpu!
		#else
		  for (n in 0...32)
		#end
		{
			var synth = new SamplerSynth();
			synth.common.master_volume = 0.45;
			synth.resample_method = SamplerSynth.RESAMPLE_CUBIC;
			seq.addSynth(synth);
			voices.push(synth);
		}
		// setup channels
		for (n in 0...16)
		{
			var vgroup = new VoiceGroup(voices, 32);
			
			if (n == 9)
				seq.addChannel([vgroup], percussion.getGenerator());
			else
				seq.addChannel([vgroup], melodic.getGenerator());
			
			
			/*seq.addChannel(voices, SamplerSynth.ofWAVE(seq.tuning, wav, wav_data));*/
			
		}				
	}
	
	public function hardReset()
	{
		seq.synths = new Array();
		seq.channels = new Array();
		seq.events = new Array();
		resetSamplerSynth();
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
	public var octave : Int;
	public var patch : Int;
	
	public function new()
	{
		
		octave = 4;
		patch = 0;
		
		Audio.init( { Volume: { vol:1.0, on:true }}, true);
		#if alchemy
			FastFloatBuffer.init(1024 * 1024 * 32);
		#end
		//seq = new Sequencer(Std.int(44100), 4096,16,null,new Reverb(2048, 983, 1.0, 1.0, 0.83, 780));
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
			
			var gui_data = 
			LayoutBuilder.create(0, 0, Main.W, Main.H, LDRect9(new Rect9(CommonStyle.rr, Main.W, Main.H, true), LAC(0, 0), null,
				LDPackV(LPMMinimum, LAC(0, 0), null, [
					LDDisplayObject(Helpers.labelButtonRect9(CommonStyle.basicButton, "Settings").button,LAC(0,0),"settings"),
					LDDisplayObject(Helpers.quickLabel(CommonStyle.cascade, "Text Infos"),LAC(0,0),"infos"),
					LDDisplayObject(Helpers.quickLabel(CommonStyle.cascade, "0/0"),LAC(0,0),"infos2"),
				])));
			
			infos = gui_data.keys.infos;
			infos2 = gui_data.keys.infos2;
			
			gui_data.keys.settings.addEventListener(MouseEvent.CLICK, function(d:Dynamic) { 
				CommonStyle.settings.visible = true; }
				);
			
			Lib.current.stage.addChild(gui_data.sprite);
			Lib.current.stage.addChild(CommonStyle.settings);
			CommonStyle.settings.visible = false;
			
			hardReset();
		});
		
		queueFunction(function(){
			seq.play("synth", "Volume");
			Lib.current.stage.addEventListener(Event.ENTER_FRAME, doLoop);
			Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, onDown);
			Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, onUp);
			
			drawDebugwaveform();
			
		});
		
		startQueue();
		
	}
	
	public var spr : Bitmap;
	public var info_vals : Dynamic;
	
	public function drawDebugwaveform()
	{
		spr = new Bitmap(new BitmapData(Main.W, Main.H, true, 0));
		Lib.current.stage.addChild(spr);
		spr.alpha = 0.5;
	}
	
	public function updateDebugwaveform()
	{
		//var wf = TableSynth.pulseWavetable[0][0];
		spr.bitmapData.fillRect(new Rectangle(0, 0, Main.W, Main.H),0);
		for (s in seq.synths)
		{
			var sc : Dynamic = s;
			for (follower in cast(sc.followers,Array<Dynamic>))
			{
				var mips : RawSample = follower.patch_event.patch.mips[0];
				var sample = mips.sample_left;
				var rate_multiplier : Float = mips.rate_multiplier;
				var p = Std.int(follower.patch_event.patch.loop_start/(sample.length*rate_multiplier) * Main.W);
				spr.bitmapData.fillRect(new Rectangle(p,0,1,Main.H), 0xFF880000);
				p = Std.int(follower.patch_event.patch.loop_end/(sample.length*rate_multiplier) * Main.W);
				spr.bitmapData.fillRect(new Rectangle(p, 0, 1, Main.H), 0xFF000088);
				p = Std.int(follower.loop_pos * Main.W);
				spr.bitmapData.fillRect(new Rectangle(p,0,1,Main.H), 0xFF444400);
				info_vals = {loop_pos : follower.loop_pos, release_level:follower.env[0].release_level, level:follower.env[0].level};
			}
		}
	}
	
	public function doLoop(_)
	{
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
		var str = "Octave " + Std.string(octave) + " (" + Std.string(octave * 12) + "-" + (octave * 12 + 11) + ") ";
		if (info_vals != null)
		{
			for (f in Reflect.fields(info_vals))
			{
				str += " " + f + ": " + Std.string(Reflect.field(info_vals, f));
			}
		}
		infos.text = str;
		infos.x = Main.W / 2 - infos.width / 2;
		infos2.text = Std.string(cc) + "/" + Std.string(seq.synths.length) + " playing. Programs: "+prog_str;
		infos2.x = Main.W / 2 - infos2.width / 2;
		updateDebugwaveform();
	}
	
	public function onDown(e : KeyboardEvent)
	{
		switch(e.charCode)
		{
			case 113: noteOn(0);
			case 119: noteOn(1);
			case 101: noteOn(2);
			case 114: noteOn(3);
			case 116: noteOn(4);
			case 121: noteOn(5);
			case 117: noteOn(6);
			case 105: noteOn(7);
			case 111: noteOn(8);
			case 112: noteOn(9);
			case 59: octave--; if (octave < 0) octave = 0;
			case 39: octave++; if (octave > 9) octave = 9;
			case 44: patch--; if (patch < 0) patch = 127; setPatch();
			case 46: patch++; if (patch > 127) patch = 0; setPatch();
		}
	}
	
	public function onUp(e : KeyboardEvent)
	{
		switch(e.charCode)
		{
			case 113: noteOff(0);
			case 119: noteOff(1);
			case 101: noteOff(2);
			case 114: noteOff(3);
			case 116: noteOff(4);
			case 121: noteOff(5);
			case 117: noteOff(6);
			case 105: noteOff(7);
			case 111: noteOff(8);
			case 112: noteOff(9);
		}
		
	}
	
	public function noteOn(input : Int)
	{
		var n = input + octave * 12;
		var freq = seq.tuning.midiNoteToFrequency(n);
		for (s in seq.synths)
		{
			for (f in s.common.getFollowers())
			{
				if (!f.env[0].releasing() && f.patch_event.sequencer_event.data.freq == freq)
					return;
			}
		}
		seq.pushEvent(new SequencerEvent(SequencerEvent.NOTE_ON, { freq:freq, velocity:127 }, 0, n, 0., 0));
	}
	
	public function noteOff(input : Int)
	{
		var n = input + octave * 12;
		seq.pushEvent(new SequencerEvent(SequencerEvent.NOTE_OFF, { freq:seq.tuning.midiNoteToFrequency(n), velocity:127 }, 0, n, 0., 0));
	}
	
	public function setPatch()
	{
		seq.pushEvent(new SequencerEvent(SequencerEvent.SET_PATCH, patch, 0, SequencerEvent.CHANNEL_EVENT, 0., 0));
	}
	
}
