// Based on the SoundFont reader of NAudio 
//      C# Code: (C) Mark Heath 2006 (mark@wordandspirit.co.uk)
//      Haxe Code: (C) Daniel Kuschny 2012 (danielku15@coderline.net)
// You are free to use this code for your own projects.
// Please consider giving credit somewhere in your app to this code if you use it
// Please do not redistribute this code without my permission
// Please get in touch and let me know of any bugs you find, enhancements you would like,
// and apps you have written
package com.ludamix.triad.audio.sf2;

class Zone 
{
    public var generator_index:Int;
    public var modulator_index:Int;
    public var generator_count:Int;
    public var modulator_count:Int;
    public var modulators:Array<Modulator>;
    public var generators:Array<Generator>;

    public function new() 
    {
    }
	
	public function generatorsAsIntHash() : IntHash<Generator>
	{
		var ih = new IntHash<Generator>();
		if (generators != null)
		{
			for (g in generators)
			{
				if (g!=null)
					ih.set(Type.enumIndex(g.generator_type), g);
			}
		}
		return ih;
	}
	
}