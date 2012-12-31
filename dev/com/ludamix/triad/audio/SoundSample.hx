package com.ludamix.triad.audio;

import nme.utils.ByteArray;
import nme.Vector;
import com.ludamix.triad.audio.SampleMipMap;
import com.ludamix.triad.tools.FastFloatBuffer;
import com.ludamix.triad.format.WAV;
import com.ludamix.triad.audio.MIDITuning;

typedef RawSample = {
	sample_left : FastFloatBuffer, // only this side is used for mono
	sample_right : FastFloatBuffer,
	rate_multiplier : Float
};

typedef LoopInfo = {
	loop_mode : Int,
	loop_start : Int,
	loop_end : Int
};

typedef SampleTuning = {
	sample_rate : Int, // mono rate
	base_frequency : Float // hz
};

class SoundSample 
{

	public var mip_levels : Array<RawSample>;
	public var tuning : SampleTuning;
	public var stereo : Bool;
	public var mono_mode : Int; // if the sample is mono, this indicates if it's intended to be paired l/r 
								// with another sample or just doubled in the stereo mix.
	public var loops : Array<LoopInfo>;
	public var name : String;

	public function new()
	{
	
	}
	
	public static inline var LOOP_FORWARD = 0;
	public static inline var LOOP_BACKWARD = 1;
	public static inline var LOOP_PINGPONG = 2;
	public static inline var SUSTAIN_FORWARD = 3;
	public static inline var SUSTAIN_BACKWARD = 4;
	public static inline var SUSTAIN_PINGPONG = 5;
	public static inline var ONE_SHOT = 6;
	public static inline var NO_LOOP = 7;
	
	public static inline var MONOMODE_BOTH = 0;
	public static inline var MONOMODE_LEFT = 1;
	public static inline var MONOMODE_RIGHT = 2;

	private static function defaultLoop(data_length : Int) : LoopInfo
	{
		return { 
			loop_mode : ONE_SHOT,
			loop_start : 0,
			loop_end : data_length - 1
		};	
	}

	public static function ofWAVE(wav : WAVE, name : String, mip_up : Int, mip_down : Int, output_rate : Int)
	{
		
		var wav_data = wav.data;
		
		var midi_unity_note = 0;
		var midi_pitch_fraction = 0;
		
		var loops = new Array<LoopInfo>();
		
		if (wav.header.smpl != null)
		{
			
			if (wav.header.smpl.loop_data!=null && wav.header.smpl.loop_data.length>0)
			{
				for (l in wav.header.smpl.loop_data)
				{
					loops.push( {
						loop_start : wav.header.smpl.loop_data[0].start,
						loop_end : wav.header.smpl.loop_data[0].end,
						loop_mode : wav.header.smpl.loop_data[0].type
					});
				}
			}
			
			midi_unity_note = wav.header.smpl.midi_unity_note;
			midi_pitch_fraction = wav.header.smpl.midi_pitch_fraction;
		}
		
		if (loops.length == 0) loops = [defaultLoop(wav_data.length)];
		
		var sample = new SoundSample();
		sample.mip_levels = SampleMipMap.genRaw(
			SampleMipMap.genMips(wav.data[0], wav.data[1], mip_up, mip_down, 
				Std.int(Math.min(output_rate, wav.header.samplingRate))));
		sample.loops = loops;
		
		var tuning = { base_frequency: EvenTemperament.cache.midiNoteToFrequency( 
			midi_unity_note + midi_pitch_fraction / 0xFFFFFFFF),
			sample_rate : Std.int(Math.min(output_rate, wav.header.samplingRate)) };
		sample.tuning = tuning;
		
		sample.stereo = sample.mip_levels[0].sample_left != sample.mip_levels[0].sample_right;
		sample.name = name;
		sample.mono_mode = MONOMODE_BOTH;
		
		return sample;
	}
	
	public static function ofVector(left : Vector<Float>, right : Vector<Float>, 
		output_rate : Int, sample_rate : Int, base_frequency : Float,
		name : String, mip_up : Int, mip_down : Int, ?loops : Array<LoopInfo> = null)
	{
		var sample = new SoundSample();
		
		sample.mip_levels = SampleMipMap.genRaw(SampleMipMap.genMips(left, right, mip_up, mip_down, 
			Std.int(Math.min(output_rate, sample_rate))));
		sample.tuning = { base_frequency: base_frequency, sample_rate : Std.int(Math.min(output_rate, sample_rate)) };
		sample.stereo = (left != right);
		sample.name = name;
		sample.mono_mode = MONOMODE_BOTH;
		
		if (loops == null) loops = [defaultLoop(left.length)];
		sample.loops = loops;
		
		return sample;
	}

	public static inline function getMipmap(wavelength : Float, sample_rate : Int, base_frequency : Float, 
		sampleset : Array<RawSample>)
	{
		// select an appropriate mipmap
		var ptr = -1;
		var best_dist = 0.;
		for (n in 0...sampleset.length)
		{
			var dist = Math.abs(wavelength - ((sample_rate / sampleset[n].rate_multiplier) / base_frequency));			
			if (dist < best_dist || ptr == -1)
				{ best_dist = dist; ptr = n; }
		}
		return ptr;
	}
	
	public static inline function getLoopLen(loop_pos : Float, 
		buffer : FastFloatBuffer, inc : Float, loop_end : Float) : Int
	{
		
		// Calculates a single loop, starting from the buffer's playhead
		
		var len = buffer.length - buffer.playhead;
		
		var samples = Std.int(Math.min(len, (loop_end - loop_pos) / inc));
		
		// Cut samples in half to account for stereo. Then do some corrections.
		samples >>= 1;
		while ((samples) * inc + loop_pos > loop_end) samples--;
		if (samples < 1 ) samples = 1;
		
		return samples;
		
	}
	
	public static function serializeSamples(st : Array<SoundSample>):ByteArray
	{
		// this is intended for cache-and-recall purposes, not long-term storage.
	
		var b : ByteArray = new ByteArray();
		
		b.writeInt(st.length);
		for (s in st)
		{
			b.writeInt(s.mip_levels.length);
			for (n in s.mip_levels)
			{
				var isStereo = n.sample_left == n.sample_right;
				b.writeBoolean(isStereo);
				b.writeFloat(n.rate_multiplier);
				b.writeInt(n.sample_left.length);
				for (q in 0...n.sample_left.length)
					b.writeShort(Math.round(n.sample_left.get(q)*32767));
				if (isStereo)
				{
					b.writeInt(n.sample_right.length);
					for (q in 0...n.sample_right.length)
						b.writeShort(Math.round(n.sample_right.get(q)*32767));
				}
			}
			b.writeInt(s.tuning.sample_rate);
			b.writeFloat(s.tuning.base_frequency);
			b.writeBoolean(s.stereo);
			b.writeShort(s.mono_mode);
			b.writeInt(s.loops.length);
			for (n in s.loops)
			{
				b.writeInt(n.loop_mode);
				b.writeInt(n.loop_start);
				b.writeInt(n.loop_end);
			}
			b.writeUTF(s.name);
		}		
		b.compress();
		return b;
	}
	
	public static function unserializeSamples(b : ByteArray):Array<SoundSample>	
	{
		b.uncompress();
		
		var result = new Array<SoundSample>();		
		
		var numSamples = b.readInt();
		for (s_idx in 0...numSamples)
		{
			var sample = new SoundSample(); sample.mip_levels = new Array(); result.push(sample);
			var numMips = b.readInt();
			for (n_idx in 0...numMips)
			{
				var mip : RawSample = { sample_left:null, sample_right:null, rate_multiplier:0. };
				sample.mip_levels.push(mip);
				var isStereo = b.readBoolean();
				mip.rate_multiplier = b.readFloat();
				var left_length = b.readInt();
				mip.sample_left = new FastFloatBuffer(left_length);
				for (q in 0...left_length)
					mip.sample_left.set(q, b.readShort()/32767);
				mip.sample_right = mip.sample_left;
				if (isStereo)
				{
					var right_length = b.readInt();
					mip.sample_right = new FastFloatBuffer(right_length);
					for (q in 0...right_length)
						mip.sample_right.set(q, b.readShort()/32767);
				}
			}
			sample.tuning = {sample_rate:0, base_frequency:0.};
			sample.tuning.sample_rate = b.readInt();
			sample.tuning.base_frequency = b.readFloat();
			sample.stereo = b.readBoolean();
			sample.mono_mode = b.readShort();
			var numLoops = b.readInt();
			sample.loops = new Array();
			for (n in 0...numLoops)
			{
				var loop : LoopInfo = { loop_mode:0, loop_start:0, loop_end:0 };
				sample.loops.push(loop);
				loop.loop_mode = b.readInt();
				loop.loop_start = b.readInt();
				loop.loop_end = b.readInt();
			}
			sample.name = b.readUTF();
		}
		return result;
	}

}