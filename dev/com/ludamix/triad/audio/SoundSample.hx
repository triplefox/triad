package com.ludamix.triad.audio;

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
	public var mono_mode : Int; // if the sample is mono, this indicates if it's intended to be paired.
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

	public static function ofWAVE(wav : WAVE, name : String, mip_levels : Int)
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
		sample.mip_levels = SampleMipMap.genRaw(SampleMipMap.genMips(wav.data[0], wav.data[1], mip_levels));
		sample.loops = loops;
		
		var tuning = { base_frequency: EvenTemperament.cache.midiNoteToFrequency( 
			midi_unity_note + midi_pitch_fraction / 0xFFFFFFFF),
			sample_rate : wav.header.samplingRate };
		sample.tuning = tuning;
		
		sample.stereo = sample.mip_levels[0].sample_left != sample.mip_levels[0].sample_right;
		sample.name = name;
		sample.mono_mode = MONOMODE_BOTH;
		
		return sample;
	}
	
	public static function ofVector(left : Vector<Float>, right : Vector<Float>, 
		sample_rate : Int, base_frequency : Float,
		name : String, mip_levels : Int, ?loops : Array<LoopInfo> = null)
	{
		var sample = new SoundSample();
		
		sample.mip_levels = SampleMipMap.genRaw(SampleMipMap.genMips(left, right, mip_levels));
		sample.tuning = { base_frequency: base_frequency, sample_rate : sample_rate };
		sample.stereo = (left != right);
		sample.name = name;
		sample.mono_mode = MONOMODE_BOTH;
		
		if (loops == null) loops = [defaultLoop(left.length)];
		sample.loops = loops;
		
		return sample;
	}

}