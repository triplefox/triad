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

class SampleHeaderBuilder extends StructureBuilder<SampleHeader>
{
    public function new() 
    {
        super();
    }
    
    public override function getLength() : Int
    {
        return 46;
    }
    
    public override function read(d:ByteArray) : SampleHeader
    {
        var sh = new SampleHeader();
        sh.sampleName = d.readString(20);
        sh.start = d.readInt();
        sh.end = d.readInt();
        sh.startLoop = d.readInt();
        sh.endLoop = d.readInt();
        sh.sampleRate = d.readInt();
        sh.originalPitch = d.readByte();
        sh.pitchCorrection = d.readSignedByte();
        sh.sampleLink = d.readShort();
        sh.sFSampleLink = d.readShort();
        data.push(sh);
        return sh;
    }     
    public function removeEOS()
    {
        data.removeAt(data.length-1);
    }
}