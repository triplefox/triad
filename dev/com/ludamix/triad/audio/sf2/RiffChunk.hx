// Based on the SoundFont reader of NAudio 
//      C# Code: (C) Mark Heath 2006 (mark@wordandspirit.co.uk)
//      Haxe Code: (C) Daniel Kuschny 2012 (danielku15@coderline.net)
// You are free to use this code for your own projects.
// Please consider giving credit somewhere in your app to this code if you use it
// Please do not redistribute this code without my permission
// Please get in touch and let me know of any bugs you find, enhancements you would like,
// and apps you have written
package com.ludamix.triad.audio.sf2;

import nme.utils.ByteArray;
using com.ludamix.triad.tools.ByteArrayTools;
using com.ludamix.triad.audio.sf2.ArrayExtensions;

#if cpp typedef UInt = Int; #end

class RiffChunk
{
    public var chunk_id:String;
    public var chunk_size:Int;
    public var data_offset:UInt; // data offset in the file
    public var riff_file:ByteArray;

    public static function getTopLevelChunk(file:ByteArray) : RiffChunk
    {
        var r:RiffChunk = new RiffChunk(file);
        r.readChunk();
        return r;
    }

    private function new(file:ByteArray) 
    {
        riff_file = file;
        chunk_id = "????";
        chunk_size = 0;
        data_offset = 0;
    }

    public function readChunkID() : String
    {
        return riff_file.readASCII(4);
    }

    private function readChunk() 
    {
        this.chunk_id = readChunkID();
        this.chunk_size = riff_file.readInt(); 
        this.data_offset = riff_file.position;
    }

    public function getNextSubChunk() : RiffChunk
    {
        if(riff_file.position + 8 < data_offset + chunk_size) 
        {
            var chunk:RiffChunk = new RiffChunk(riff_file);
            chunk.readChunk();
            return chunk;
        }
        return null;
    }

    public function getData() : ByteArray
    {
        riff_file.position = data_offset;
        var data:ByteArray = new ByteArray();
        riff_file.readBytes(data, 0, chunk_size);
        if(cast(data.length,Int) != chunk_size) 
        {
            throw "Couldn't read chunk's data Chunk";
        }
        return data;
    }

    public function getDataAsString() : String
    {
        var data = getData();
        if(data == null)
            return null;
        data.position = 0;
        
        var s = new StringBuf();
        while (true) 
        {
            var b = data.readByte();
            if (b == 0) return s.toString();
            s.addChar(b);
        }
        
        return s.toString();
    }

    public function getDataAsStructure<T>(s:StructureBuilder<T>) : T
    {
        riff_file.position = data_offset;
        if(s.getLength() != chunk_size) 
        {
            throw "Chunk size is: " + chunk_size + " so can't read structure of: " + s.getLength();
        }
        return s.read(riff_file);
    }

    public function getDataAsStructureArray<T>(s:StructureBuilder<T>) : Array<T>
    {
        riff_file.position = data_offset;
        if(chunk_size % s.getLength() != 0) 
        {
            throw "Chunk size is: " + chunk_size + " not a multiple of structure size: " + s.getLength();
        }
        var structures_to_read:Int = Std.int(chunk_size / s.getLength());
        var a:Array<T> = new Array<T>();
        for (n in 0 ... structures_to_read)
        {
            a.push(s.read(riff_file));
        }
        return a;
    }
}
