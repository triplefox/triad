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
        
        for (i in 0 ... count) 
        {
            writeSfzDefinitionBlock(path + Std.string(i + 1) + ".sfz", path, output);
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
        
        writeSfzDefinitionBlock(path + name + ".sfz", path, output);
        
        output.close();
    }
    
    private static function writeSfzDefinitionBlock(sfzFile:String, path:String, output:FileOutput)
    {
        var sfzDefinition = File.getContent(sfzFile);

        // write SFZ file
        output.writeInt31(sfzDefinition.length);
        output.writeString(sfzDefinition);
        
        // search for all sample properties and write file then 
        var lines = sfzDefinition.split("\n");
        for (l in lines)
        {
            if (StringTools.startsWith(l, "sample")) 
            {
                var parts = l.split("=");
                parts[1] = StringTools.trim(parts[1].split("//")[0]);
            
                var waveFile = path + parts[1];
                
                writeWaveFileBlock(waveFile, output);
            }
        }
    }
    
    private static function writeWaveFileBlock(waveFilePath:String, output:FileOutput)
    {
        var waveFile = File.getBytes(waveFilePath);
        
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