// Based on the SoundFont reader of NAudio 
//      C# Code: (C) Mark Heath 2006 (mark@wordandspirit.co.uk)
//      Haxe Code: (C) Daniel Kuschny 2012 (danielku15@coderline.net)
// You are free to use this code for your own projects.
// Please consider giving credit somewhere in your app to this code if you use it
// Please do not redistribute this code without my permission
// Please get in touch and let me know of any bugs you find, enhancements you would like,
// and apps you have written
package com.ludamix.triad.audio.sf2;

class Modulator 
{
    public var source_modulation_data:ModulatorType;
    public var destination_generator:GeneratorEnum;
    public var amount:Int;
    public var source_modulation_amount:ModulatorType;
    public var source_transform:TransformEnum;


	/*
	 * Modulators (when implemented) serve the purpose of SFZ's keymapped/cc-mapped assignments.
	 * */

	/* 
	 * If a second modulator is
encountered with the same three enumerators as a previous modulator with the same zone, the first
modulator will be ignored.

	Modulators in the PMOD sub-chunk act as additively relative modulators with respect to those in the
IMOD sub-chunk.  In other words, a PMOD modulator can increase or decrease the amount of an
IMOD modulator. Section “9.5 The SoundFont Modulator Controller Model” contains the details of how this
application works.

	Note for backward compatibility that in SoundFont 2.00, no modulators had been defined. So in
SoundFont 2.00 compatible rendering engines, the PMOD sub-chunk will always be ignored


The sfModSrcOper is a value of one of the SFModulator enumeration type values.  Unknown or
undefined values are ignored. This value indicates the source of data for the modulator. Note that this
enumeration is two bytes in length.
The sfModDestOper indicates the destination of the modulator. The destination is a value of one of the
SFGenerator enumerations. Unknown or undefined values are ignored.   Note that this enumeration is
two bytes in length.
The SHORT modAmount is a signed value indicating the degree to which the source modulates the
destination.  A zero value indicates there is no fixed amount.
The sfModAmtSrcOper is a value of one of the SFModulator enumeration type values.  Unknown or
undefined values are ignored. This value indicates the degree to which the source modulates the
destination is to be controlled by the specified modulation source. Note that this enumeration is two
bytes in length.
The sfModTransOper is a value of one of the SFTransform enumeration type values.  Unknown or
undefined values are ignored.  This value indicates that a transform of the specified type will be applied
to the modulation source before application to the modulator. Note that this enumeration is two bytes in
length.


Modulators in the IMOD sub-chunk are absolute.  This means that an IMOD modulator replaces, rather
than adds to, a default modulator. However the effect of a modulator on a generator is additive, IE the
output of a modulator adds to a generator value

A Generator and a Modulator Destination are two terms meaning the same thing, a single synthesizer
parameter. Modulator Destinations are exclusively the list of
Value Generators.

	*/

    public function new() 
    {
    }
}