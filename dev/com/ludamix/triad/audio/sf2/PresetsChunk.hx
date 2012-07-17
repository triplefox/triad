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
    public var preset_headers:PresetBuilder;
    public var preset_zones:ZoneBuilder;
    public var preset_zone_modulators:ModulatorBuilder;
    public var preset_zone_generators:GeneratorBuilder;
    public var instruments:InstrumentBuilder;
    public var instrument_zones:ZoneBuilder;
    public var instrument_zone_modulators : ModulatorBuilder;
    public var instrument_zone_generators : GeneratorBuilder;
    public var sample_headers : SampleHeaderBuilder;
    
    public function new(chunk:RiffChunk) 
    {
        preset_headers = new PresetBuilder();
        preset_zones = new ZoneBuilder();
        preset_zone_modulators = new ModulatorBuilder();
        preset_zone_generators = new GeneratorBuilder();
        instruments = new InstrumentBuilder();
        instrument_zones = new ZoneBuilder();
        instrument_zone_modulators = new ModulatorBuilder();
        instrument_zone_generators = new GeneratorBuilder();
        sample_headers = new SampleHeaderBuilder();
        
        var header = chunk.readChunkID();
        if(header != "pdta") 
        {
            throw "Not a presets data chunk (" + header + ")";
        }

        var c:RiffChunk;
        while((c = chunk.getNextSubChunk()) != null) 
        {
            switch(c.chunk_id) {
                case "PHDR":
                case "phdr":
                    c.getDataAsStructureArray(preset_headers);
                case "PBAG":
                case "pbag":			
                    c.getDataAsStructureArray(preset_zones);
                case "PMOD":
                case "pmod":
                    c.getDataAsStructureArray(preset_zone_modulators);
                case "PGEN":
                case "pgen":
                    c.getDataAsStructureArray(preset_zone_generators);
                case "INST":
                case "inst":
                    c.getDataAsStructureArray(instruments);
                case "IBAG":
                case "ibag":
                    c.getDataAsStructureArray(instrument_zones);
                case "IMOD":
                case "imod":
                    c.getDataAsStructureArray(instrument_zone_modulators);
                case "IGEN":
                case "igen":
                    c.getDataAsStructureArray(instrument_zone_generators);
                case "SHDR":
                case "shdr":
                    c.getDataAsStructureArray(sample_headers); 
                default:
                    throw "Unknown chunk type " + c.chunk_id;
            }
        }

        // now link things up
        instrument_zone_generators.loadSampleHeaders(sample_headers.data);
        instrument_zones.load(instrument_zone_modulators.data, instrument_zone_generators.data);
        instruments.loadZones(instrument_zones.data);
        preset_zone_generators.loadInstruments(instruments.data);
        preset_zones.load(preset_zone_modulators.data, preset_zone_generators.data);
        preset_headers.loadZones(preset_zones.data);
        sample_headers.removeEOS();
    }
}
