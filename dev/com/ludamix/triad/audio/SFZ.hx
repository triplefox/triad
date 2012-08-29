package com.ludamix.triad.audio;

import com.ludamix.triad.format.WAV;
import haxe.Json;
import nme.Assets;
import nme.utils.ByteArray;

import com.ludamix.triad.audio.SamplerSynth;
import com.ludamix.triad.audio.Sequencer;
import com.ludamix.triad.audio.MIDITuning;
import com.ludamix.triad.audio.Envelope;
import haxe.io.Bytes;
import haxe.io.BytesInput;

typedef TString = com.ludamix.triad.tools.StringTools;
typedef HString = StringTools;

class SFZ
{

	public static function interpret_type(seq : Sequencer, key : String, value : String) : Dynamic
	{

		// note name mapping?
		var tuning = seq.tuning;
		var ct = 0;
		var upper = value.toUpperCase();
		for (n in tuning.notename)
		{
			if (upper == n) { return ct; }
			ct++;
		}

		return TString.parseIntFloatString(value);
	}
    
    private static function readString(file:ByteArray, len:Int) : String
    {
        var s = new StringBuf();
        
        for (i in 0 ... len)
        {
            s.addChar(file.readByte());
        }
        
        return s.toString();
    }
    
    public static function loadCompressed(seq:Sequencer, file : ByteArray, programs:Array<Int> = null) : SamplerBank
    {
        var sfzBank = new SamplerBank(seq);
        
        file.position = 0;
        
        var groups:Array<SamplerOpcodeGroup> = new Array<SamplerOpcodeGroup>();
        var waves:Hash<WAVE> = new Hash<WAVE>();
        
        // read all SFZDefinitionBlocks
        var blockCount = file.readInt();
        for (i in 0 ... blockCount)
        {
            var sfzSize = file.readInt();
            var sfz = readString(file, sfzSize);
            groups.push(loadFromData(seq, sfz)[0]);
        }
        
        // read all WaveFileBlocks
        blockCount = file.readInt();
        for (i in 0 ... blockCount)
        {
            var nameLength = file.readInt();
            var name = readString(file, nameLength);
            
            var byteCount = file.readInt();
            var bytes = new ByteArray();
            file.readBytes(bytes, 0, byteCount);
            
            waves.set(name, WAV.read(bytes));
        }
        
        // assign groups to bank
        for (i in 0 ... groups.length)
        {
            var groupPrograms:Array<Int>;
            if (programs != null)
            {
                groupPrograms = programs;
            }
            else
            {
                groupPrograms = [i];
            }
            sfzBank.configure(groups[i], groupPrograms, function(n) : PatchGenerator {
                var header = waves.get(n);
                return SamplerSynth.ofWAVE(seq.tuning, header, n);
            });
        }
        
        return sfzBank;
    }

	public static function load(seq : Sequencer, file : ByteArray) : Array<SamplerOpcodeGroup>
    {
		file.position = 0;
		return loadFromData(seq, file.readUTFBytes(file.length));
    }
    
	public static function loadFromData(seq : Sequencer, str:String) : Array<SamplerOpcodeGroup>
	{
		var lines = str.split("\n");

		var HEAD = 0;
		var GROUP = 1;
		var REGION = 2;

		var groups = new Array<SamplerOpcodeGroup>();

		var ctx = HEAD;
		var cur_group : SamplerOpcodeGroup = null;
		var cur_region : Hash<Dynamic> = null;

		for (l in lines)
		{
			l = HString.trim(l);
			if (l.length == 0 || HString.startsWith(l, "//")) { } // pass
			else if (HString.startsWith(l, "<group>")) { 
				cur_group = new SamplerOpcodeGroup(); groups.push(cur_group); 
				ctx = GROUP;  } // group
			else if (HString.startsWith(l, "<region>")) { 
				if (cur_group == null) { cur_group = new SamplerOpcodeGroup(); groups.push(cur_group); }
				cur_region = new Hash<Dynamic>(); 
				cur_group.regions.push(cur_region); ctx = REGION;  } // region
			else if (l.indexOf("=") >= 0) // opcode
			{
				var parts = l.split("=");
				parts[1] = HString.trim(parts[1].split("//")[0]); // eliminate comments
				if (ctx == GROUP)
				{
					cur_group.group_opcodes.set(parts[0],interpret_type(seq, parts[0], parts[1]));
				}
				else if (ctx == REGION)
				{
					cur_region.set(parts[0],interpret_type(seq, parts[0], parts[1]));
				}
			}
		}

		return groups;

	}

}
