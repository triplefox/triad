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
import com.ludamix.triad.audio.Codec;
import com.ludamix.triad.format.ExtendedByteArray;
import com.ludamix.triad.format.wav.Data;
import haxe.Int32;
import nme.utils.ByteArray;
import nme.Vector;
import nme.utils.Endian;

private typedef IFFSubChunk = {name:String,idx:Int,len:Int,bytes:haxe.io.Bytes};

class Reader {

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

}
