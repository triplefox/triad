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
    public var verSoundFont:SFVersion;
    public var waveTableSoundEngine:String;
    public var bankName:String;
    public var dataROM:String;
    public var creationDate:String;
    public var author:String;
    public var targetProduct:String;
    public var copyright:String;
    public var comments:String;
    public var tools:String;
    public var verROM:SFVersion;

    public function new(chunk:RiffChunk) 
    {
        var ifilPresent = false;
        var isngPresent = false;
        var INAMPresent = false;
        if(chunk.readChunkID() != "INFO") 
        {
            throw "Not an INFO chunk";
        }
        var c:RiffChunk;
        while((c = chunk.getNextSubChunk()) != null) 
        {
            switch(c.chunkID) 
            {
                case "ifil":
                    ifilPresent = true;
                    verSoundFont = c.getDataAsStructure(new SFVersionBuilder());
                case "isng":
                    isngPresent = true;
                    waveTableSoundEngine = c.getDataAsString();
                case "INAM":
                    INAMPresent = true;
                    bankName = c.getDataAsString();
                case "irom":
                    dataROM = c.getDataAsString();
                case "iver":
                    verROM = c.getDataAsStructure(new SFVersionBuilder());
                case "ICRD":
                    creationDate = c.getDataAsString();
                case "IENG":
                    author = c.getDataAsString();
                case "IPRD":
                    targetProduct = c.getDataAsString();
                case "ICOP":
                    copyright = c.getDataAsString();
                case "ICMT":
                    comments = c.getDataAsString();
                case "ISFT":
                    tools = c.getDataAsString();
                default:
                    throw "Unknown chunk type " + c.chunkID;
            }
        }
        if(!ifilPresent) 
        {
            throw "Missing SoundFont version information";
        }
        if(!isngPresent) 
        {
            throw "Missing wavetable sound engine information";
        }
        if(!INAMPresent) 
        {
            throw "Missing SoundFont name information";
        }
    }
}