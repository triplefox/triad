import nme.Assets;
import nme.events.Event;
import flash.events.SampleDataEvent;
import nme.Lib;
import nme.media.Sound;
import com.ludamix.triad.audio.Sequencer;
import com.ludamix.triad.audio.Audio;
import com.ludamix.triad.ui.SettingsUI;

class SynthTest
{
	
	var seq : Sequencer;	
	var events : Array<SequencerEvent>;
	
	public function new()
	{
		Audio.init({Volume:{vol:1.0,on:true}},true);
		seq = new Sequencer();
		for (n in 0...64)
			seq.addSynth(new SquareWave());
		for (n in 0...16)
			seq.addChannel(seq.synths);
		
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
		
		CommonStyle.init();
		
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