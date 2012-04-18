package com.ludamix.triad.audio;
import nme.Vector;
import com.ludamix.triad.format.wav.Data;
import haxe.io.BytesInput;

class Codec
{
	
	public static function WAV(wav : WAVE) : Array<Vector<Float>>
	{
		// this is actually assuming PCM data right now. Hmm.
		
		var vec = new Vector<Float>();
		var vec_right = new Vector<Float>();
		var wi = new BytesInput(wav.data);
		if (wav.header.channels != 2)
			vec_right = vec;
		
		if (wav.header.bitsPerSample == 32)
		{
			var size = Math.pow(2, 32);
			var samples = Std.int(wav.data.length / 4);
			if (wav.header.channels == 2)
			{
				for (n in 0...samples>>1)
				{
					vec.push((haxe.Int32.toInt(wi.readInt32()))/size);
					vec_right.push((haxe.Int32.toInt(wi.readInt32()))/size);
				}
			}
			else
			{
				for (n in 0...samples)
				{
					vec.push((haxe.Int32.toInt(wi.readInt32()))/size);
				}
			}
		}
		else if (wav.header.bitsPerSample == 16)
		{
			var size = Math.pow(2, 16);
			var samples = Std.int(wav.data.length/2);
			if (wav.header.channels == 2)
			{
				for (n in 0...samples>>1)
				{
					vec.push(wi.readInt16()/size);
					vec_right.push(wi.readInt16()/size);
				}
			}
			else
			{
				for (n in 0...samples)
				{
					vec.push(wi.readInt16()/size);
				}
			}
		}
		else if (wav.header.bitsPerSample == 8)
		{
			var size = Math.pow(2, 8);
			var samples = Std.int(wav.data.length);
			if (wav.header.channels == 2)
			{
				for (n in 0...samples>>1)
				{
					vec.push(wi.readInt8()/size);
					vec_right.push(wi.readInt8()/size);
				}
			}
			else
			{
				for (n in 0...samples)
				{
					vec.push(wi.readInt8()/size);
				}
			}
		}
		else throw wav.header.bitsPerSample + " bits per sample? really?";
		
		return [vec, vec_right];
	}
	
	
}