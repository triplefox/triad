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
    public static inline var NO_CONTROLLER = 0;
    public static inline var NOTE_ON_VELOCITY = 2;
    public static inline var NOTE_ON_KEY_NUMBER = 3;
    public static inline var POLY_PRESSURE = 10;
    public static inline var CHANNEL_PRESSURE = 13;
    public static inline var PITCH_WHEEL = 14;
    public static inline var PITCH_WHEEL_SENSITIVITY = 16;
}

class SourceTypeEnum 
{
    public static inline var LINEAR = 0;
    public static inline var CONCAVE = 1;
    public static inline var CONVEC = 2;
    public static inline var SWITCH = 3;
}
    
class ModulatorType 
{
    public var polarity:Bool;
    public var direction:Bool;
    public var midi_continuous_controller:Bool;
    public var controller_source:Int;
    public var source_type:Int;
    public var midi_continuous_controller_number:Int;

    public function new(raw:Int) 
    {
        polarity = ((raw & 0x0200) == 0x0200);
        direction = ((raw & 0x0100) == 0x0100);
        midi_continuous_controller = ((raw & 0x0080) == 0x0080);
        source_type = ((raw & (0xFC00)) >> 10);

        controller_source = (raw & 0x007F);
        midi_continuous_controller_number = (raw & 0x007F);
    }
}