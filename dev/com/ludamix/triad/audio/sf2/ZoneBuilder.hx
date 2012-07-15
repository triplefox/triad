// Based on the SoundFont reader of NAudio 
//      C# Code: (C) Mark Heath 2006 (mark@wordandspirit.co.uk)
//      Haxe Code: (C) Daniel Kuschny 2012 (danielku15@coderline.net)
// You are free to use this code for your own projects.
// Please consider giving credit somewhere in your app to this code if you use it
// Please do not redistribute this code without my permission
// Please get in touch and let me know of any bugs you find, enhancements you would like,
// and apps you have written
package com.ludamix.triad.audio.sf2;

using com.ludamix.triad.audio.sf2.ArrayExtensions;
import nme.utils.ByteArray;

class ZoneBuilder extends StructureBuilder<Zone>
{
    private var last_zone:Zone;
    
    public function new() 
    {
        super();
    }
    
    public override function getLength() : Int
    {
        return 4;
    }
    
    public override function read(d:ByteArray)
    {
        var z = new Zone();
        z.generator_index = d.readShort();
        z.modulator_index = d.readShort();
        if(last_zone != null)
        {
            last_zone.generator_count = (z.generator_index - last_zone.generator_index);
            last_zone.modulator_count = (z.modulator_index - last_zone.modulator_index);
        }
        data.push(z);
        last_zone = z;
        return z;
    } 
    
    public function load(modulators:Array<Modulator>, generators:Array<Generator>)
    {
        // don't do the last zone, which is simply EOZ
        for(zone in 0 ... data.length - 1)
        {
            var z = data[zone];
            z.generators = new Array<Generator>();
            for (i in 0 ... z.generator_count)
            {
                z.generators[i] = generators[z.generator_index + i];
            }
            z.modulators = new Array<Modulator>();
            for (i in 0 ... z.modulator_count)
            {
                z.modulators[i] = modulators[z.modulator_index + i];
            }
        }
        // we can get rid of the EOP record now
        data.removeAt(data.length - 1);
    }
    
}