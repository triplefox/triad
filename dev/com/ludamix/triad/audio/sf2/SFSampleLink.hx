// Based on the SoundFont reader of NAudio 
//      C# Code: (C) Mark Heath 2006 (mark@wordandspirit.co.uk)
//      Haxe Code: (C) Daniel Kuschny 2012 (danielku15@coderline.net)
// You are free to use this code for your own projects.
// Please consider giving credit somewhere in your app to this code if you use it
// Please do not redistribute this code without my permission
// Please get in touch and let me know of any bugs you find, enhancements you would like,
// and apps you have written
package com.ludamix.triad.audio.sf2;

class SFSampleLink 
{
    public static var MonoSample = 1;
    public static var RightSample = 2;
    public static var LeftSample = 4;
    public static var LinkedSample = 8;
    public static var RomMonoSample = 0x8001;
    public static var RomRightSample = 0x8002;
    public static var RomLeftSample = 0x8004;
    public static var RomLinkedSample = 0x8008;
}