// Based on the SoundFont reader of NAudio 
//      C# Code: (C) Mark Heath 2006 (mark@wordandspirit.co.uk)
//      Haxe Code: (C) Daniel Kuschny 2012 (danielku15@coderline.net)
// You are free to use this code for your own projects.
// Please consider giving credit somewhere in your app to this code if you use it
// Please do not redistribute this code without my permission
// Please get in touch and let me know of any bugs you find, enhancements you would like,
// and apps you have written
package com.ludamix.triad.audio.sf2;

class PresetsChunk
{
    public var presetHeaders:PresetBuilder;
    public var presetZones:ZoneBuilder;
    public var presetZoneModulators:ModulatorBuilder;
    public var presetZoneGenerators:GeneratorBuilder;
    public var instruments:InstrumentBuilder;
    public var instrumentZones:ZoneBuilder;
    public var instrumentZoneModulators : ModulatorBuilder;
    public var instrumentZoneGenerators : GeneratorBuilder;
    public var sampleHeaders : SampleHeaderBuilder;
    
    public function new(chunk:RiffChunk) 
    {
        presetHeaders = new PresetBuilder();
        presetZones = new ZoneBuilder();
        presetZoneModulators = new ModulatorBuilder();
        presetZoneGenerators = new GeneratorBuilder();
        instruments = new InstrumentBuilder();
        instrumentZones = new ZoneBuilder();
        instrumentZoneModulators = new ModulatorBuilder();
        instrumentZoneGenerators = new GeneratorBuilder();
        sampleHeaders = new SampleHeaderBuilder();
        
        var header = chunk.readChunkID();
        if(header != "pdta") 
        {
            throw "Not a presets data chunk (" + header + ")";
        }

        var c:RiffChunk;
        while((c = chunk.getNextSubChunk()) != null) 
        {
            switch(c.chunkID) {
                case "PHDR":
                case "phdr":
                    c.getDataAsStructureArray(presetHeaders);
                case "PBAG":
                case "pbag":			
                    c.getDataAsStructureArray(presetZones);
                case "PMOD":
                case "pmod":
                    c.getDataAsStructureArray(presetZoneModulators);
                case "PGEN":
                case "pgen":
                    c.getDataAsStructureArray(presetZoneGenerators);
                case "INST":
                case "inst":
                    c.getDataAsStructureArray(instruments);
                case "IBAG":
                case "ibag":
                    c.getDataAsStructureArray(instrumentZones);
                case "IMOD":
                case "imod":
                    c.getDataAsStructureArray(instrumentZoneModulators);
                case "IGEN":
                case "igen":
                    c.getDataAsStructureArray(instrumentZoneGenerators);
                case "SHDR":
                case "shdr":
                    c.getDataAsStructureArray(sampleHeaders); 
                default:
                    throw "Unknown chunk type " + c.chunkID;
            }
        }

        // now link things up
        instrumentZoneGenerators.loadSampleHeaders(sampleHeaders.data);
        instrumentZones.load(instrumentZoneModulators.data,instrumentZoneGenerators.data);
        instruments.loadZones(instrumentZones.data);
        presetZoneGenerators.loadInstruments(instruments.data);
        presetZones.load(presetZoneModulators.data,presetZoneGenerators.data);
        presetHeaders.loadZones(presetZones.data);
        sampleHeaders.removeEOS();
    }
}
