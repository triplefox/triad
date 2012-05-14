/*
 * Rewritten by James Hofmann (smpl chunk, usage of Bytearray) (C) 2012
 * 
 * format - haXe File Formats
 *
 *  WAVE File Format
 *  Copyright (C) 2009 Robin Palotai
 *
 * Copyright (c) 2009, The haXe Project Contributors
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *	- Redistributions of source code must retain the above copyright
 *	  notice, this list of conditions and the following disclaimer.
 *	- Redistributions in binary form must reproduce the above copyright
 *	  notice, this list of conditions and the following disclaimer in the
 *	  documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE HAXE PROJECT CONTRIBUTORS "AS IS" AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE HAXE PROJECT CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
 * DAMAGE.
 */
package com.ludamix.triad.format;
import com.ludamix.triad.audio.Codec;
import com.ludamix.triad.format.ExtendedByteArray;
import nme.utils.ByteArray;
import nme.Vector;
import nme.utils.Endian;

private typedef IFFSubChunk = {name:String,idx:Int,len:Int,bytes:haxe.io.Bytes};

typedef WAVE = {
	header : WAVEHeader,
	data : Array<Vector<Float>>,
}

typedef SMPLLoopData = {
	cue_point_id:Int, 
	type:Int, 
	start:Int, 
	end:Int, 
	fraction:Int, 
	play_count:Int
};

typedef SMPLChunk = {
	manufacturer : Int,
	product : Int,
	sample_period : Int,
	midi_unity_note : Int,
	midi_pitch_fraction : Int,
	smpte_format : Int,
	smpte_offset : Int,
	num_sampler_loops : Int,
	sampler_data : Int,
	loop_data : Array<SMPLLoopData>
};

typedef WAVEHeader = {
	format : WAVEFormat,
	channels : Int,
	samplingRate : Int,
	byteRate : Int,		// samplingRate * channels * bitsPerSample / 8
	blockAlign : Int,	 // channels * bitsPerSample / 8
	bitsPerSample : Int,
	smpl : SMPLChunk
}

enum WAVEFormat {
	WF_PCM;
}

class WAV {

	public static function read(ba : ByteArray) : WAVE {
		
		ba.endian = Endian.LITTLE_ENDIAN;
		var eba = ExtendedByteArray.fromByteArray(ba);
		
		var head = eba.getStruct([
			NamedSD("riff", SDField(STASCII(4))),
			NamedSD("len", SDField(STInt)),
			NamedSD("wave", SDField(STASCII(4))),
		]);
		
		if (head.riff !="RIFF") throw "RIFF header expected";
		if (head.wave != "WAVE") throw "WAVE signature not found";
		var chunks : Array<FourByteChunk> = eba.get4ByteChunks(head.len - 4);
		
		// fmt
		var fmt_chk : FourByteChunk = null;
		for (c in Lambda.filter(chunks, function(chk) { return chk.name == "fmt "; } )) { fmt_chk = c; }
		if (fmt_chk == null) throw "expected fmt subchunk";
		
		ba.position = fmt_chk.position;
		
		var fmt_data = eba.getStruct([
			NamedSD("format", SDField(STUShort)),
			NamedSD("channels", SDField(STUShort)),
			NamedSD("samplingRate",SDField(STUInt)),
			NamedSD("byteRate",SDField(STUInt)),
			NamedSD("blockAlign",SDField(STUShort)),
			NamedSD("bitsPerSample",SDField(STUShort)),
		]);
			
		var format = switch (fmt_data.format) {
			case 1: WF_PCM;
			default: throw "only PCM (uncompressed) WAV files are supported - got "+Std.string(fmt_data.format);
		}
		var data_chk : FourByteChunk = null;
		var smpl : SMPLChunk = null;
		
		for (chk in chunks)
		{
			ba.position = chk.position;
			if (chk.name == "smpl") // sampler data
			{
				smpl = eba.getStruct([
					NamedSD("manufacturer",SDField(STUInt)),
					NamedSD("product",SDField(STUInt)),
					NamedSD("sample_period",SDField(STUInt)),
					NamedSD("midi_unity_note",SDField(STUInt)),
					NamedSD("midi_pitch_fraction",SDField(STUInt)),
					NamedSD("smpte_format",SDField(STUInt)),
					NamedSD("smpte_offset",SDField(STUInt)),
					NamedSD("num_sampler_loops",SDField(STUInt)),
					NamedSD("sampler_data",SDField(STUInt)),
				]);
				smpl.loop_data = new Array<SMPLLoopData>();
				for (n in 0...smpl.num_sampler_loops)
				{
					smpl.loop_data.push(
						eba.getStruct([
							NamedSD("cue_point_id",SDField(STUInt)),
							NamedSD("type",SDField(STUInt)),
							NamedSD("start",SDField(STUInt)),
							NamedSD("end",SDField(STUInt)),
							NamedSD("fraction",SDField(STUInt)),
							NamedSD("play_count",SDField(STUInt))
						])
					);
				}
			}
			else if (chk.name == "data")
			{
				data_chk = chk;
			}
		}
		
		var header : WAVEHeader = {
				format: format,
				channels: fmt_data.channels,
				samplingRate: fmt_data.samplingRate,
				byteRate: fmt_data.byteRate,
				blockAlign: fmt_data.blockAlign,
				bitsPerSample: fmt_data.bitsPerSample,
				smpl: smpl
		};
		return {
			header:header,
			data: Codec.WAV(header, ba, data_chk)
		}
		
	}

	public static function write(wav : WAVE) 
	{
		var hdr = wav.header;
		var buf : WAVBuffer = new WAVBuffer(wav.header);
		if (hdr.bitsPerSample == 32)
		{
			for (n in 0...wav.data[0].length)
			{
				for (c in 0...hdr.channels)
				{
					buf.writeFloatAsInt32(wav.data[c][n]);
				}
			}
		}
		else if (hdr.bitsPerSample == 16)
		{
			for (n in 0...wav.data[0].length)
			{
				for (c in 0...hdr.channels)
				{
					buf.writeFloatAsInt16(wav.data[c][n]);
				}
			}
		}
		else if (hdr.bitsPerSample == 8)
		{
			for (n in 0...wav.data[0].length)
			{
				for (c in 0...hdr.channels)
				{
					buf.writeFloatAsInt8(wav.data[c][n]);
				}
			}
		}
		else throw "I only know how to write 8, 16, and 32-bit PCM";
		
		return buf.toByteArray();
	}
	
	public static function writeStream(header : WAVEHeader) : WAVBuffer
	{
		return new WAVBuffer(header);
	}
	
}

class WAVBuffer
{
	public var header : WAVEHeader;
	public var ba : ByteArray;
	public var data_byte_offset: Int; 
	public var riff_byte_offset: Int;
	public var written : Int;
	
	public function new(header : WAVEHeader)
	{
		this.header = header;
		ba = new ByteArray();
		ba.endian = Endian.LITTLE_ENDIAN;
		
		ba.writeMultiByte("RIFF", "us-ascii");
		riff_byte_offset = ba.position;
		ba.writeInt(36 + 0);
		ba.writeMultiByte("WAVE", "us-ascii");

		ba.writeMultiByte("fmt ", "us-ascii");
		ba.writeInt(16);
		ba.writeShort(1);
		ba.writeShort(header.channels);
		ba.writeInt(header.samplingRate);
		ba.writeInt(header.byteRate);
		ba.writeShort(header.blockAlign);
		ba.writeShort(header.bitsPerSample);
		
		ba.writeMultiByte("data", "us-ascii");
		data_byte_offset = ba.position;
		ba.writeInt(0);
		
	}
	
	public static inline var MUL_32 = 4294967296.;
	public static inline var MUL_16 = 65536.;
	public static inline var MUL_8 = 256.;
	
	public inline function writeFloatAsInt32(v : Float):Void 
	{
		ba.writeInt(Std.int(v * MUL_32));
		written+=4;
	}
	
	public inline function writeFloatAsInt16(v : Float):Void 
	{
		ba.writeShort(Std.int(v * MUL_16));
		written+=2;
	}
	
	public inline function writeFloatAsInt8(v : Float):Void 
	{
		ba.writeByte(Std.int(v * MUL_8));
		written++;
	}
	
	public function toByteArray()
	{
		ba.position = riff_byte_offset;
		ba.writeInt(36 + written);
		ba.position = data_byte_offset;
		ba.writeInt(written);
		ba.position = ba.length;
		return ba;
	}

}

