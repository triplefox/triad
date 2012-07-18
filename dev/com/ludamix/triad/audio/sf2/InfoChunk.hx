// Based on the SoundFont reader of NAudio 
//      C# Code: (C) Mark Heath 2006 (mark@wordandspirit.co.uk)
//      Haxe Code: (C) Daniel Kuschny 2012 (danielku15@coderline.net)
// You are free to use this code for your own projects.
// Please consider giving credit somewhere in your app to this code if you use it
// Please do not redistribute this code without my permission
// Please get in touch and let me know of any bugs you find, enhancements you would like,
// and apps you have written
package com.ludamix.triad.audio.sf2;

class InfoChunk
{
    public var soundfont_version:SFVersion;
    public var wavetable_soundengine:String;
    public var bank_name:String;
    public var data_rom:String;
    public var creation_date:String;
    public var author:String;
    public var target_product:String;
    public var copyright:String;
    public var comments:String;
    public var tools:String;
    public var rom_version:SFVersion;

    public function new(chunk:RiffChunk) 
    {
        var ifil_present = false;
        var isng_present = false;
        var inam_present = false;
        if(chunk.readChunkID() != "INFO") 
        {
            throw "Not an INFO chunk";
        }
        var c:RiffChunk;
        while((c = chunk.getNextSubChunk()) != null) 
        {
            switch(c.chunk_id) 
            {
                case "ifil":
                    ifil_present = true;
                    soundfont_version = c.getDataAsStructure(new SFVersionBuilder());
                case "isng":
                    isng_present = true;
                    wavetable_soundengine = c.getDataAsString();
                case "INAM":
                    inam_present = true;
                    bank_name = c.getDataAsString();
                case "irom":
                    data_rom = c.getDataAsString();
                case "iver":
                    rom_version = c.getDataAsStructure(new SFVersionBuilder());
                case "ICRD":
                    creation_date = c.getDataAsString();
                case "IENG":
                    author = c.getDataAsString();
                case "IPRD":
                    target_product = c.getDataAsString();
                case "ICOP":
                    copyright = c.getDataAsString();
                case "ICMT":
                    comments = c.getDataAsString();
                case "ISFT":
                    tools = c.getDataAsString();
                default:
                    throw "Unknown chunk type " + c.chunk_id;
            }
        }
        if(!ifil_present) 
        {
            throw "Missing SoundFont version information";
        }
        if(!isng_present) 
        {
            throw "Missing wavetable sound engine information";
        }
        if(!inam_present) 
        {
            throw "Missing SoundFont name information";
        }
    }
}