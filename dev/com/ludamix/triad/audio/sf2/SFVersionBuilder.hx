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

class SFVersionBuilder extends StructureBuilder<SFVersion>
{
    public function new()
    {
        super();
    }
    
    public override function getLength() : Int
    {
        return 4;
    }
    
    public override function read(d:ByteArray) : SFVersion
    {
        var v:SFVersion = new SFVersion();
        v.major = d.readShort();
        v.minor = d.readShort();
        return v;
    }
}