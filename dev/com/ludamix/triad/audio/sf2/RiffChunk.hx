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
using com.ludamix.triad.audio.sf2.ArrayExtensions;

class RiffChunk
{
    public var chunkID:String;
    public var chunkSize:Int;
    public var dataOffset:UInt; // data offset in the file
    public var riffFile:ByteArray;

    public static function getTopLevelChunk(file:ByteArray) : RiffChunk
    {
        var r:RiffChunk = new RiffChunk(file);
        r.readChunk();
        return r;
    }

    private function new(file:ByteArray) 
    {
        riffFile = file;
        chunkID = "????";
        chunkSize = 0;
        dataOffset = 0;
    }

    public function readChunkID() : String
    {
        return riffFile.readString(4);
    }

    private function readChunk() 
    {
        this.chunkID = readChunkID();
        this.chunkSize = riffFile.readInt(); 
        this.dataOffset = riffFile.position;
    }

    public function getNextSubChunk() : RiffChunk
    {
        if(riffFile.position + 8 < dataOffset + chunkSize) 
        {
            var chunk:RiffChunk = new RiffChunk(riffFile);
            chunk.readChunk();
            return chunk;
        }
        return null;
    }

    public function getData() : ByteArray
    {
        riffFile.position = dataOffset;
        var data:ByteArray = new ByteArray();
        riffFile.readBytes(data, 0, chunkSize);
        if(cast(data.length,Int) != chunkSize) 
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
        riffFile.position = dataOffset;
        if(s.getLength() != chunkSize) 
        {
            throw "Chunk size is: " + chunkSize + " so can't read structure of: " + s.getLength();
        }
        return s.read(riffFile);
    }

    public function getDataAsStructureArray<T>(s:StructureBuilder<T>) : Array<T>
    {
        riffFile.position = dataOffset;
        if(chunkSize % s.getLength() != 0) 
        {
            throw "Chunk size is: " + chunkSize + " not a multiple of structure size: " + s.getLength();
        }
        var structuresToRead:Int = Std.int(chunkSize / s.getLength());
        var a:Array<T> = new Array<T>();
        for (n in 0 ... structuresToRead)
        {
            a.push(s.read(riffFile));
        }
        return a;
    }
}
