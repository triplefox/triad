// Based on the SoundFont reader of NAudio 
//      C# Code: (C) Mark Heath 2006 (mark@wordandspirit.co.uk)
//      Haxe Code: (C) Daniel Kuschny 2012 (danielku15@coderline.net)
// You are free to use this code for your own projects.
// Please consider giving credit somewhere in your app to this code if you use it
// Please do not redistribute this code without my permission
// Please get in touch and let me know of any bugs you find, enhancements you would like,
// and apps you have written
package com.ludamix.triad.audio.sf2;

import com.ludamix.triad.audio.Sequencer;

class Preset 
{
    public var name:String;
    public var patchNumber:Int;
    public var bank:Int;
    public var startPresetZoneIndex:Int;
    public var endPresetZoneIndex:Int;
    public var library:Int;
    public var genre:Int;
    public var morphology:Int;
    public var zones:Array<Zone>;

    public function new() 
    {        
    }
    
    public function query(ev : SequencerEvent, seq : Sequencer) : Array<PatchEvent>
	{
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
}