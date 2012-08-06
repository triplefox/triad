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
using com.ludamix.triad.audio.sf2.ArrayExtensions;

class InstrumentBuilder extends StructureBuilder<Instrument>
{
    private var last_instrument:Instrument;
    
    public function new() 
    {
        super();
    }

    public override function getLength() : Int
    {
        return 22;
    }
    
    public override function read(d:ByteArray) : Instrument
    {
        var i = new Instrument();
        i.name = d.readString(20);
        i.start_instrument_zoneindex = d.readShort();
        if(last_instrument != null)
        {
            last_instrument.end_instrument_zoneindex = (i.start_instrument_zoneindex - 1);
        }
        data.push(i);
        last_instrument = i;
        return i;
    }     
    
    public function loadZones(zones:Array<Zone>)
    {
        // don't do the last preset, which is simply EOP
        for(instrument in 0 ... data.length - 1)
        {
            var i = data[instrument];
			i.zones = new Array<Zone>();
            for (j in 0 ... (i.end_instrument_zoneindex - i.start_instrument_zoneindex + 1))
            {
                i.zones[j] = zones[i.start_instrument_zoneindex + j];
            }
        }
        // we can get rid of the EOP record now
        data.removeAt(data.length - 1);
    }
}