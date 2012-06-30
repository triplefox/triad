package com.ludamix.triad.audio;

import sys.FileSystem;
import sys.io.File;
import sys.io.FileOutput;

/**
 * This utility class allows the compression of the SFZ directory
 * into one binary
 * 
 * NOTE: Compile triad with the neko target and run this class.
 */
class SFZCompressor 
{
    public static function compressList(path:String, count:Int, target:String)
    {
        var output:FileOutput = File.write(target);
        
        if (!StringTools.endsWith(path, "/")) 
        {
            path += "/";
        }
        
        // Definitions
        output.writeInt31(count);
        var samples:Array<String> = new Array<String>();
        for (i in 0 ... count) 
        {
            samples = samples.concat(writeSfzDefinitionBlock(path + Std.string(i + 1) + ".sfz", path, output));
        }
        
        // Waves
        for (s in samples)
        {
            writeWaveFileBlock(s, path, output);
        }
        
        output.close();
    }    
    
    public static function compressSingle(path:String, name:String, target:String)
    {
        var output:FileOutput = File.write(target);
        
        if (!StringTools.endsWith(path, "/")) 
        {
            path += "/";
        }
        
        output.writeInt31(1);
        writeSfzDefinitionBlock(path + name + ".sfz", path, output);
        
        output.close();
    }
    
    private static function writeSfzDefinitionBlock(sfzFile:String, path:String, output:FileOutput) : Array<String>
    {
        var sfzDefinition = File.getContent(sfzFile);

        // write SFZ file
        output.writeInt31(sfzDefinition.length);
        output.writeString(sfzDefinition);
        
        // search for all sample properties and write file then
        var samples:Array<String> = new Array<String>();
        var lines = sfzDefinition.split("\n");
        for (l in lines)
        {
            if (StringTools.startsWith(l, "sample")) 
            {
                var parts = l.split("=");
                parts[1] = StringTools.trim(parts[1].split("//")[0]);
                samples.push(parts[1]);
            }
        }
        
        return samples;
    }
    
    private static function writeWaveFileBlock(filename:String, path:String, output:FileOutput)
    {
        var waveFilePath = path + filename;
        var waveFile = File.getBytes(waveFilePath);
        
        output.writeInt31(filename.length);
        output.writeString(filename);
        
        output.writeInt31(waveFile.length);
        output.writeBytes(waveFile, 0, waveFile.length);
    }
    
    public static function main() 
    {
        var args:Array<String> = Sys.args();
        
        if (args.length != 2)
        {
            Sys.println("usage: SfzCompressor IN OUT");
            Sys.println("   IN  - The directory storing the SFZs");
            Sys.println("   OUT - The directory for writing the compressed SFZs to");
            return;
        }
        
        var dir = StringTools.replace(args[0], "\\", "/");
        var out = StringTools.replace(args[1], "\\", "/");
        if (!StringTools.endsWith(out, "/")) 
        {
            out += "/";
        }
        
        Sys.println("Compressing melody SFZ");
        SFZCompressor.compressList(dir, 128, out + "melody.sfc");        
        Sys.println("Compressing percussion SFZ");
        SFZCompressor.compressSingle(dir, "kit-standard", out + "percussion.sfc");
    }
}