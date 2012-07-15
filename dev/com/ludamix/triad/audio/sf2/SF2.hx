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
import nme.utils.ByteArray;

class SF2 
{
    public var info:InfoChunk;
    public var presetsChunk:PresetsChunk;
    public var sampleData:SampleDataChunk;

    public function new() 
    {
         
    }
    
    public static function load(data:ByteArray) : SF2
    {
        var sf2 = new SF2();
        var riff:RiffChunk = RiffChunk.getTopLevelChunk(data);
        if(riff.chunkID == "RIFF") 
        {
            var formHeader:String = riff.readChunkID();
            if(formHeader != "sfbk") 
            {
                throw "Not a SoundFont (" + formHeader + ")";
            }
            var list:RiffChunk = riff.getNextSubChunk();
            if(list.chunkID == "LIST") 
            {
                sf2.info = new InfoChunk(list);

                var r:RiffChunk = riff.getNextSubChunk();
                sf2.sampleData = new SampleDataChunk(r);

                r = riff.getNextSubChunk();
                sf2.presetsChunk = new PresetsChunk(r);
            }
            else 
            {
                throw "Not info list found (" + list.chunkID + ")";
            }
        }
        else
        {
            throw "Not a RIFF file";
        }
        
        return sf2;
    }
    
    public function getGenerator() : PatchGenerator
    {
		return new PatchGenerator(this, function(settings, seq, seq_event) : Array<PatchEvent> { 
			return getProgramOfEvent(seq_event, seq.channels[seq_event.channel].patch_id);
		} );
    }
    
	public function getProgramOfEvent(ev : SequencerEvent, number : Int) : Array<PatchEvent>
	{
		if (presetsChunk.presetHeaders.presets.exists(number))
			return presetsChunk.presetHeaders.presets.get(number).query(ev, seq);
		else return null;
	}    
}