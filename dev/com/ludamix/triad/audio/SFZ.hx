import haxe.io.Bytes;
import haxe.io.BytesInput;

package com.ludamix.triad.audio;

class SFZGroup
{
	
	// store region and groups
	
	public var group_opcodes : Hash<Dynamic>;
	public var regions : Array<Hash<Dynamic>>;
	
	public function new():Void 
	{
		
	}
	
	public function query(midinote : Float)
	{
		
		var available = Lambda.filter(regions, function(r) { return (r.get("lokey")>=midinote && r.get("hikey")<=midinote); } );
		
		
		
		// idea here is to retrieve the summed opcodes of a region as sampler patch settings.
		// we don't cache, so the opcodes could potentially be serialized again as created, minus comments.
		
		// this seems kind of heavy, but the amount of logic probably won't be so high even for multiple samples per key.
		// anyway, we potentially need to return multiple patches at once! so it'd be hard to optimize anyway.
	}
	
}

class SFZ
{
	
	public static function load(file : Bytes)
	{
		var i = new BytesInput(file);
		var str = i.readString(file.length);
		var lines = str.split("\n");
		
		var HEAD = 0;
		var GROUP = 1;
		var REGION = 2;
		
		var groups = new Array<SFZGroup>();
		
		var ctx = HEAD;
		for (l in lines)
		{
			l = StringTools.trim(l);
			if (l.length == 0 || StringTools.startsWith(l, "//")) { } // pass
			else if (StringTools.startsWith(l,"<group>")) {} // group
			else if (StringTools.startsWith(l, "<region>")) { } // region
			else if (l.indexOf("=") >= 0) // opcode
			{
				var parts = l.split("=");
				parts[1] = StringTools.trim(parts[1].split("//")[0]); // eliminate comments
			}
		}
		
	}
	
}