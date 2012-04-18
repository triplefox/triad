/*
 * Extended by James Hofmann to support "smpl" blocks (C) 2012
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
package com.ludamix.triad.format.wav;
import com.ludamix.triad.format.wav.Data;
import haxe.Int32;
import haxe.io.Bytes;

private typedef IFFSubChunk = {name:String,idx:Int,len:Int,bytes:haxe.io.Bytes};

class Reader {

	var i : haxe.io.Input;
	var version : Int;

	public function new(i) {
		this.i = i;
		i.bigEndian = false;
	}
	
	private function readSubChunks(chunk_len : Int)
	{
		var pos = 0;
		var chunks = new Array<IFFSubChunk>();
		var idx = 0;
		while (pos<chunk_len)
		{
			var name = i.readString(4);
			var len = Int32.toInt(i.readInt32());
			var bytes = i.read(len);
			
			chunks.push( { name:name, idx:idx, len:len, bytes:bytes } );
			pos += 4 + 4 + len;
			idx++;
		}
		
		return chunks;
	}

	public function read() : WAVE {

		if (i.readString(4) != "RIFF")
			throw "RIFF header expected";

		var len = Int32.toInt(i.readInt32());
		
		if (i.readString(4) != "WAVE")
			throw "WAVE signature not found";
		
		var chunks = readSubChunks(len - 4);
		
		// fmt
		var fmt_chk : IFFSubChunk = null;
		for (c in Lambda.filter(chunks, function(chk) { return chk.name == "fmt "; } )) { fmt_chk = c; }
		if (fmt_chk == null) throw "expected fmt subchunk";
		
		var sub_i = new haxe.io.BytesInput(fmt_chk.bytes);
		
		var format = switch (sub_i.readUInt16()) {
			case 1: WF_PCM;
			default: throw "only PCM (uncompressed) WAV files are supported";
		}
		var channels = sub_i.readUInt16();
		var samplingRate = Int32.toInt(sub_i.readInt32());
		var byteRate = Int32.toInt(sub_i.readInt32());
		var blockAlign = sub_i.readUInt16();
		var bitsPerSample = sub_i.readUInt16();			
		var data : Bytes = null;
		var smpl : SMPLChunk = null;
		
		for (chk in chunks)
		{
			var sub_i = new haxe.io.BytesInput(chk.bytes);
			if (chk.name == "smpl") // sampler data
			{
				smpl = { 
					manufacturer : Int32.toInt(sub_i.readInt32()),
					product : Int32.toInt(sub_i.readInt32()),
					sample_period : Int32.toInt(sub_i.readInt32()),
					midi_unity_note : Int32.toInt(sub_i.readInt32()),
					midi_pitch_fraction : Int32.toInt(sub_i.readInt32()),
					smpte_format : Int32.toInt(sub_i.readInt32()),
					smpte_offset : Int32.toInt(sub_i.readInt32()),
					num_sampler_loops : Int32.toInt(sub_i.readInt32()),
					sampler_data : Int32.toInt(sub_i.readInt32()),
					loop_data : new Array<SMPLLoopData>()				
					};
				for (n in 0...smpl.num_sampler_loops)
				{
					smpl.loop_data.push(
						{
							cue_point_id:Int32.toInt(sub_i.readInt32()), 
							type:Int32.toInt(sub_i.readInt32()), 
							start:Int32.toInt(sub_i.readInt32()), 
							end:Int32.toInt(sub_i.readInt32()), 
							fraction:Int32.toInt(sub_i.readInt32()), 
							play_count:Int32.toInt(sub_i.readInt32())		
						}
					);
				}
			}
			else if (chk.name == "data")
			{
				data = sub_i.read(chk.len);
			}
		}
		
		return {
			header: {
				format: format,
				channels: channels,
				samplingRate: samplingRate,
				byteRate: byteRate,
				blockAlign: blockAlign,
				bitsPerSample: bitsPerSample,
				smpl: smpl
			},
			data: data
		}
		
	}

}
