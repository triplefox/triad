package com.ludamix.triad.audio;
import com.ludamix.triad.format.ExtendedByteArray;
import nme.utils.ByteArray;
import nme.Vector;
import com.ludamix.triad.format.wav.Data;
import haxe.io.BytesInput;

class Codec
{
	
	public static function WAV(wav : WAVEHeader, data : ByteArray, data_chk : FourByteChunk) : Array<Vector<Float>>
	{
		data.position = data_chk.position;
		
		// this is actually assuming PCM data right now. Hmm.
		
		var vec = new Vector<Float>();
		var vec_right = new Vector<Float>();
		if (wav.channels != 2)
			vec_right = vec;
		
		if (wav.bitsPerSample == 32)
		{
			var size = 1./Math.pow(2, 32);
			var samples = Std.int(data_chk.len / 4);
			if (wav.channels == 2)
			{
				for (n in 0...samples>>1)
				{
					vec.push(data.readInt()*size);
					vec_right.push(data.readInt()*size);
				}
			}
			else
			{
				for (n in 0...samples)
				{
					vec.push(data.readInt()*size);
				}
			}
		}
		else if (wav.bitsPerSample == 16)
		{
			var size = 1./Math.pow(2, 16);
			var samples = Std.int(data_chk.len/2);
			if (wav.channels == 2)
			{
				for (n in 0...samples>>1)
				{
					vec.push(data.readShort()*size);
					vec_right.push(data.readShort()*size);
				}
			}
			else
			{
				for (n in 0...samples)
				{
					vec.push(data.readShort()*size);
				}
			}
		}
		else if (wav.bitsPerSample == 8)
		{
			var size = 1./Math.pow(2, 8);
			var samples = Std.int(data_chk.len);
			if (wav.channels == 2)
			{
				for (n in 0...samples>>1)
				{
					vec.push(data.readByte()*size);
					vec_right.push(data.readByte()*size);
				}
			}
			else
			{
				for (n in 0...samples)
				{
					vec.push(data.readByte()*size);
				}
			}
		}
		else throw wav.bitsPerSample + " bits per sample? really?";
		
		return [vec, vec_right];
	}
	
	
}