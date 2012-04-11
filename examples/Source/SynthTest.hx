import com.ludamix.triad.audio.SMFParser;
import com.ludamix.triad.audio.TableSynth;
import com.ludamix.triad.ui.HSlider6;
import nme.Assets;
import nme.events.Event;
import flash.events.SampleDataEvent;
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
				sustain.highlighted, release.highlighted);
			for (n in seq.channels) { 
				n.patch.attack_envelope = envelopes.attack_envelope; 
				n.patch.sustain_envelope = envelopes.sustain_envelope; 
				n.patch.release_envelope = envelopes.release_envelope; 
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
	
	public function new()
	{
		Audio.init({Volume:{vol:1.0,on:true}},true);
		seq = new Sequencer();
		for (n in 0...32)
		{
			var synth = new TableSynth();
			seq.addSynth(synth);
		}
		for (n in 0...16)
		{
			seq.addChannel(seq.synths, TableSynth.defaultPatch());
		}
		
		//seq.pushEvent(new SequencerEvent(SequencerEvent.NOTE_ON, seq.waveLength(55.0), chan.id, 0, 0, 1));
		//seq.pushEvent(new SequencerEvent(SequencerEvent.NOTE_ON, seq.waveLength(110.0), chan.id, 0, Std.int(seq.BPMToFrames(1,480.0)), 1));
		//seq.pushEvent(new SequencerEvent(SequencerEvent.NOTE_ON, seq.waveLength(220.0), chan.id, 0, Std.int(seq.BPMToFrames(2,480.0)), 1));
		//seq.pushEvent(new SequencerEvent(SequencerEvent.NOTE_ON, seq.waveLength(440.0), chan.id, 0, Std.int(seq.BPMToFrames(3,480.0)), 1));
		//seq.pushEvent(new SequencerEvent(SequencerEvent.NOTE_ON, seq.waveLength(880.0), chan.id, 0, Std.int(seq.BPMToFrames(4,480.0)), 1));
		//seq.pushEvent(new SequencerEvent(SequencerEvent.NOTE_OFF, null, chan.id, 0, Std.int(seq.BPMToFrames(5,480.0)), 1));
		
		seq.play("synth", "Volume");
		
		events = SMFParser.load(seq, Assets.getBytes("assets/test_03.mid"));
		for (n in events)
		{
			if (n.channel == 9 || n.channel == 11) // mute some instruments that translate poorly
				n.type = SequencerEvent.NOTE_OFF;
		}
		
		CommonStyle.init(null, "assets/sfx_test.mp3");
		
		Lib.current.stage.addChild(ADSRUI.make(seq).sprite);
		Lib.current.stage.addChild(CommonStyle.settings);
		
		Lib.current.stage.addEventListener(Event.ENTER_FRAME, doLoop);
		
	}
	
	public function doLoop(_)
	{
		if (seq.events.length<1)
		{
			seq.pushEvents(events.copy());
		}
		else
		{
			//trace(seq.events[0]);
		}
	}
	
	
	
}