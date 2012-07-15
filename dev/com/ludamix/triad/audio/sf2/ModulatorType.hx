// Based on the SoundFont reader of NAudio 
//      C# Code: (C) Mark Heath 2006 (mark@wordandspirit.co.uk)
//      Haxe Code: (C) Daniel Kuschny 2012 (danielku15@coderline.net)
// You are free to use this code for your own projects.
// Please consider giving credit somewhere in your app to this code if you use it
// Please do not redistribute this code without my permission
// Please get in touch and let me know of any bugs you find, enhancements you would like,
// and apps you have written
package com.ludamix.triad.audio.sf2;

class ControllerSourceEnum 
{
    public static inline var NoController = 0;
    public static inline var NoteOnVelocity = 2;
    public static inline var NoteOnKeyNumber = 3;
    public static inline var PolyPressure = 10;
    public static inline var ChannelPressure = 13;
    public static inline var PitchWheel = 14;
    public static inline var PitchWheelSensitivity = 16;
}

class SourceTypeEnum 
{
    public static inline var Linear = 0;
    public static inline var Concave = 1;
    public static inline var Convex = 2;
    public static inline var Switch = 3;
}
    
class ModulatorType 
{
    public var polarity:Bool;
    public var direction:Bool;
    public var midiContinuousController:Bool;
    public var controllerSource:Int;
    public var sourceType:Int;
    public var midiContinuousControllerNumber:Int;

    public function new(raw:Int) 
    {
        polarity = ((raw & 0x0200) == 0x0200);
        direction = ((raw & 0x0100) == 0x0100);
        midiContinuousController = ((raw & 0x0080) == 0x0080);
        sourceType = ((raw & (0xFC00)) >> 10);

        controllerSource = (raw & 0x007F);
        midiContinuousControllerNumber = (raw & 0x007F);

    }
    
}