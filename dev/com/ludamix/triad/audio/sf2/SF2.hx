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
    public var presets_chunk:PresetsChunk;
    public var sample_data:SampleDataChunk;

    public function new() 
    {
    }
    
    public static function load(data:ByteArray) : SF2
    {
        var sf2 = new SF2();
        var riff:RiffChunk = RiffChunk.getTopLevelChunk(data);
        if(riff.chunk_id == "RIFF") 
        {
            var form_header:String = riff.readChunkID();
            if(form_header != "sfbk") 
            {
                throw "Not a SoundFont (" + form_header + ")";
            }
            var list:RiffChunk = riff.getNextSubChunk();
            if(list.chunk_id == "LIST") 
            {
                sf2.info = new InfoChunk(list);

                var r:RiffChunk = riff.getNextSubChunk();
                sf2.sample_data = new SampleDataChunk(r);

                r = riff.getNextSubChunk();
                sf2.presets_chunk = new PresetsChunk(r);
            }
            else 
            {
                throw "Not info list found (" + list.chunk_id + ")";
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
			return null; // TODO: Find a way to get the events
		} );
    } 
}