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
    private var _lastZone:Zone;
    
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
        z.generatorIndex = d.readShort();
        z.modulatorIndex = d.readShort();
        if(_lastZone != null)
        {
            _lastZone.generatorCount = (z.generatorIndex - _lastZone.generatorIndex);
            _lastZone.modulatorCount = (z.modulatorIndex - _lastZone.modulatorIndex);
        }
        data.push(z);
        _lastZone = z;
        return z;
    } 
    
    public function load(modulators:Array<Modulator>, generators:Array<Generator>)
    {
        // don't do the last zone, which is simply EOZ
        for(zone in 0 ... data.length - 1)
        {
            var z = data[zone];
            z.generators = new Array<Generator>();
            for (i in 0 ... z.generatorCount)
            {
                z.generators[i] = generators[z.generatorIndex + i];
            }
            z.modulators = new Array<Modulator>();
            for (i in 0 ... z.modulatorCount)
            {
                z.modulators[i] = modulators[z.modulatorIndex + i];
            }
        }
        // we can get rid of the EOP record now
        data.removeAt(data.length - 1);
    }
    
}