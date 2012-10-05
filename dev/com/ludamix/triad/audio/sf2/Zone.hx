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
	
	public function generatorsAsIntHash()
	{
		var ih = new IntHash<Generator>();
		for (g in generators)
		{
			ih.set(Type.enumIndex(g.generator_type), g);
		}
	}
	
	public function getMerged(zones : Array<Zone>)
	{
		// is this actually going to work? I have the feeling that not all generators are additive in this way.
		// which means I'm going to have to go through them, one by one, and pull out the mergable ones.
		
		// no modulators are included in the preset zones.
	
		var gens = generatorsAsIntHash();
		for (z in zones)
		{
			var zg = z.generatorsAsIntHash();
			for (k in zg.keys())
			{
				var ng : Generator = gens.get(k);
				var og = zg.get(k);
				if (ng = null)
				{ 
					ng = new Generator(); 
					gens.set(k, ng); 
					ng.generator_type = og.generator_type;
					ng.raw_amount = og.raw_amount; 
					ng.instrument = og.instrument;
					ng.sample_header = og.sample_header;
				}
				else
				{
					ng.raw_amount += og.raw_amount;
					if (og.instrument == null) ng.instrument = og.instrument;
					if (og.sample_header == null) ng.sample_header = og.sample_header;
				}
			}
		}
	}
	
}