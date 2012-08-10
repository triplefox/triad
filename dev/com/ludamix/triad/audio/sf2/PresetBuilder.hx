// Based on the SoundFont reader of NAudio 
//      C# Code: (C) Mark Heath 2006 (mark@wordandspirit.co.uk)
//      Haxe Code: (C) Daniel Kuschny 2012 (danielku15@coderline.net)
// You are free to use this code for your own projects.
// Please consider giving credit somewhere in your app to this code if you use it
// Please do not redistribute this code without my permission
// Please get in touch and let me know of any bugs you find, enhancements you would like,
// and apps you have written
package com.ludamix.triad.audio.sf2;

import nme.utils.ByteArray;
using com.ludamix.triad.tools.StringTools;
using com.ludamix.triad.audio.sf2.ArrayExtensions;

class PresetBuilder extends StructureBuilder<Preset>
{
    private var last_preset:Preset;
    public var presets:IntHash<Preset>;
    
    public function new()
    {
        super();
        presets = new IntHash<Preset>();
    }
    
    public override function getLength() : Int
    {
        return 38;
    }
    
    public override function read(d:ByteArray) : Preset
    {
        var p = new Preset();
        var s = d.readString(20);
        p.name = s.cleanASCII();
        p.patch_number = d.readShort();
        p.bank = d.readShort();
        p.start_preset_zoneindex = d.readShort();
        p.library = d.readInt();
        p.genre = d.readInt();
        p.morphology = d.readInt();			
        if(last_preset != null)
            last_preset.end_preset_zoneindex =  (p.start_preset_zoneindex - 1);
        data.push(p);
        presets.set(p.patch_number, p);
        last_preset = p;
        return p;
    } 
    
    public function loadZones(preset_zones:Array<Zone>)
    {
        // don't do the last preset, which is simply EOP
        for (preset in 0 ... (data.length - 1))
        {
            var p = data[preset];
            p.zones = new Array<Zone>();
            for (i in 0 ... (p.end_preset_zoneindex - p.start_preset_zoneindex + 1))
            {
                p.zones[i] = preset_zones[p.start_preset_zoneindex + i];
            }
        }
        // we can get rid of the EOP record now
        data.removeAt(data.length - 1);
    }
}