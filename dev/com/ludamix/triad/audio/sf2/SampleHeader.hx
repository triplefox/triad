// Based on the SoundFont reader of NAudio 
//      C# Code: (C) Mark Heath 2006 (mark@wordandspirit.co.uk)
//      Haxe Code: (C) Daniel Kuschny 2012 (danielku15@coderline.net)
// You are free to use this code for your own projects.
// Please consider giving credit somewhere in your app to this code if you use it
// Please do not redistribute this code without my permission
// Please get in touch and let me know of any bugs you find, enhancements you would like,
// and apps you have written
package com.ludamix.triad.audio.sf2;
import com.ludamix.triad.audio.SoundSample;

class SampleHeader 
{
    public var sample_name:String;
    public var start:Int;
    public var end:Int;
    public var start_loop:Int;
    public var end_loop:Int;
    public var sample_rate:Int;
    public var original_pitch:Int;
    public var pitch_correction:Int;
    public var sample_link:Int;
    public var sf_sample_type:Int;
	
	public var triad_soundsample:SoundSample;

    public function new() 
    {
    }
}