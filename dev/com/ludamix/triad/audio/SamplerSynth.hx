package com.ludamix.triad.audio;

import com.ludamix.triad.audio.dsp.Biquad;
import com.ludamix.triad.audio.dsp.FFT;
import com.ludamix.triad.audio.dsp.IIRFilter;
import com.ludamix.triad.audio.dsp.IIRFilter2;
import com.ludamix.triad.audio.dsp.DSP;
import com.ludamix.triad.audio.dsp.WindowFunction;
import com.ludamix.triad.tools.MathTools;
import com.ludamix.triad.tools.FastFloatBuffer;
import com.ludamix.triad.format.WAV;
import com.ludamix.triad.audio.SFZ;
import nme.Assets;
import nme.utils.ByteArray;
import nme.utils.CompressionAlgorithm;
import com.ludamix.triad.audio.Sequencer;

// I think I need a polymorphic sample format;
// as it is, there's a lot of overlap

typedef RawSample = {
	sample_left : FastFloatBuffer, // only this side is used for mono
	sample_right : FastFloatBuffer,
};

typedef SamplerPatch = {
	sample : RawSample,
	mip_2 : RawSample,
	mip_4 : RawSample,
	mip_8 : RawSample,
	mip_16 : RawSample,
	mip_32 : RawSample,
	mip_64 : RawSample,
	mip_128 : RawSample,
	mip_256 : RawSample,
	mip_512 : RawSample,
	mip_1024 : RawSample,
	sample_rate : Int, // mono rate
	base_frequency : Float, // hz
	stereo : Bool,
	pan : Float,
	loop_mode : Int,
	loop_start : Int,
	loop_end : Int,
	volume : Float,
	envelopes : Array<Envelope>,
	lfos : Array<LFO>,
	modulation_lfo : Float, // multiplier if greater than 0
	arpeggiation_rate : Float, // 0 = off, hz value
};

typedef CopySamples = FastFloatBuffer->Int->Float->Float->Float->Float->FastFloatBuffer->FastFloatBuffer->Float->Float->Float->Float->Void;

class SamplerSynth implements SoftSynth
{
	
	public var buffer : FastFloatBuffer;
	public var followers : Array<EventFollower>;
	public var sequencer : Sequencer;
	
	public var freq : Float;
	public var bufptr : Int;
	
	public var master_volume : Float;
	public var velocity : Float;
	
	public var frame_pitch_adjust : Float;
	public var frame_vol_adjust : Float;
	
	public var arpeggio : Float;
	
	// # of octaves before increasing the interpolation factor; ideal is 1.
	// below 1 it will start filtering the percieved results
	// above 1 cpu usage will be lower but more pitch artifacts may occur
	public var interpolation_tolerance : Float; 
	
	public static inline var ATTACK = 0;
	public static inline var SUSTAIN = 1;
	public static inline var RELEASE = 2;
	public static inline var OFF = 3;
	
	public function new()
	{
		freq = 440.;
		bufptr = 0;
		master_volume = 0.1;
		velocity = 1.0;
		arpeggio = 0.;
	}
	
	public static inline var LOOP_FORWARD = 0;
	public static inline var LOOP_BACKWARD = 1;
	public static inline var LOOP_PINGPONG = 2;
	public static inline var SUSTAIN_FORWARD = 3;
	public static inline var SUSTAIN_BACKWARD = 4;
	public static inline var SUSTAIN_PINGPONG = 5;
	public static inline var ONE_SHOT = 6;
	public static inline var NO_LOOP = 7;
	
	public static inline var AS_PITCH_ADD = 0;
	public static inline var AS_PITCH_MUL = 1;
	public static inline var AS_VOLUME_ADD = 2;
	public static inline var AS_VOLUME_MUL = 3;
	
	// heuristic to ramp down priority when releasing
	public static inline var PRIORITY_RAMPDOWN = 0.95;
	// and ramp up priority when sustaining
	public static inline var PRIORITY_RAMPUP = 1;
	// and ramp down priority this much each time a new voice is added to the channel
	public static inline var PRIORITY_VOICE = 0.95;

	// TODO: replace these silly handwritten mips with a macro, then generate all octaves
	//			(this will allow the lowest outputrates to be useful)
	
	private static function _mip2(sample : FastFloatBuffer) : FastFloatBuffer
	{
		var out = new FastFloatBuffer(sample.length >> 1);
		for (i in 0...sample.length >> 1)
		{
			out.set(i, (sample.get(i << 1) + sample.get((i << 1) + 1))*0.5);
		}
		return out;
	}
	
	private static function _mip4(sample : FastFloatBuffer) : FastFloatBuffer
	{
		var out = new FastFloatBuffer(sample.length >> 2);
		for (i in 0...sample.length >> 2)
		{
			out.set(i, (sample.get(i << 2) + sample.get((i << 2) + 1) + 
						sample.get((i << 2) + 2) + sample.get((i << 2) + 3))*0.25);
		}
		return out;
	}
	
	private static function _mip8(sample : FastFloatBuffer) : FastFloatBuffer
	{
		var out = new FastFloatBuffer(sample.length >> 3);
		for (i in 0...sample.length >> 3)
		{
			out.set(i, (sample.get(i << 3) + sample.get((i << 3) + 1) + 
						sample.get((i << 3) + 2) + sample.get((i << 3) + 3) + 
						sample.get((i << 3) + 4) + sample.get((i << 3) + 5) +
						sample.get((i << 3) + 6) + sample.get((i << 3) + 7))*0.125);
		}
		return out;
	}
	
	private static function _mip16(sample : FastFloatBuffer) : FastFloatBuffer
	{
		var out = new FastFloatBuffer(sample.length >> 4);
		for (i in 0...sample.length >> 4)
		{
			out.set(i, (sample.get(i << 4) + sample.get((i << 4) + 1) + 
						sample.get((i << 4) + 2) + sample.get((i << 4) + 3) + 
						sample.get((i << 4) + 4) + sample.get((i << 4) + 5) +
						sample.get((i << 4) + 6) + sample.get((i << 4) + 7) +
						sample.get((i << 4) + 8) + sample.get((i << 4) + 9) +
						sample.get((i << 4) + 10) + sample.get((i << 4) + 11) +
						sample.get((i << 4) + 12) + sample.get((i << 4) + 13) +
						sample.get((i << 4) + 14) + sample.get((i << 4) + 15))*0.0625);
		}
		return out;
	}
	
	private static function _mip32(sample : FastFloatBuffer) : FastFloatBuffer
	{
		var out = new FastFloatBuffer(sample.length >> 5);
		for (i in 0...sample.length >> 5)
		{
			out.set(i, (sample.get(i << 5) + sample.get((i << 5) + 1) + 
						sample.get((i << 5) + 2) + sample.get((i << 5) + 3) + 
						sample.get((i << 5) + 4) + sample.get((i << 5) + 5) + 
						sample.get((i << 5) + 6) + sample.get((i << 5) + 7) + 
						sample.get((i << 5) + 8) + sample.get((i << 5) + 9) + 
						sample.get((i << 5) + 10) + sample.get((i << 5) + 11) + 
						sample.get((i << 5) + 12) + sample.get((i << 5) + 13) + 
						sample.get((i << 5) + 14) + sample.get((i << 5) + 15) + 
						sample.get((i << 5) + 16) + sample.get((i << 5) + 17) + 
						sample.get((i << 5) + 18) + sample.get((i << 5) + 19) +
						sample.get((i << 5) + 20) + sample.get((i << 5) + 21) +
						sample.get((i << 5) + 22) + sample.get((i << 5) + 23) +
						sample.get((i << 5) + 24) + sample.get((i << 5) + 25) +
						sample.get((i << 5) + 26) + sample.get((i << 5) + 27) +
						sample.get((i << 5) + 28) + sample.get((i << 5) + 29) +
						sample.get((i << 5) + 30) + sample.get((i << 5) + 31))*0.03125);
		}
		return out;
	}
	
	private static function _mip64(sample : FastFloatBuffer) : FastFloatBuffer
	{
		var out = new FastFloatBuffer(sample.length >> 6);
		for (i in 0...sample.length >> 6)
		{
			out.set(i, (sample.get(i << 6) + sample.get((i << 6) + 1) + 
						sample.get((i << 6) + 2) + sample.get((i << 6) + 3) + 
						sample.get((i << 6) + 4) + sample.get((i << 6) + 5) + 
						sample.get((i << 6) + 6) + sample.get((i << 6) + 7) + 
						sample.get((i << 6) + 8) + sample.get((i << 6) + 9) + 
						sample.get((i << 6) + 10) + sample.get((i << 6) + 11) + 
						sample.get((i << 6) + 12) + sample.get((i << 6) + 13) + 
						sample.get((i << 6) + 14) + sample.get((i << 6) + 15) + 
						sample.get((i << 6) + 16) + sample.get((i << 6) + 17) + 
						sample.get((i << 6) + 18) + sample.get((i << 6) + 19) + 
						sample.get((i << 6) + 20) + sample.get((i << 6) + 21) + 
						sample.get((i << 6) + 22) + sample.get((i << 6) + 23) + 
						sample.get((i << 6) + 24) + sample.get((i << 6) + 25) + 
						sample.get((i << 6) + 26) + sample.get((i << 6) + 27) + 
						sample.get((i << 6) + 28) + sample.get((i << 6) + 29) + 
						sample.get((i << 6) + 30) + sample.get((i << 6) + 31) + 
						sample.get((i << 6) + 32) + sample.get((i << 6) + 33) + 
						sample.get((i << 6) + 34) + sample.get((i << 6) + 35) + 
						sample.get((i << 6) + 36) + sample.get((i << 6) + 37) + 
						sample.get((i << 6) + 38) + sample.get((i << 6) + 39) + 
						sample.get((i << 6) + 40) + sample.get((i << 6) + 41) + 
						sample.get((i << 6) + 42) + sample.get((i << 6) + 43) + 
						sample.get((i << 6) + 44) + sample.get((i << 6) + 45) + 
						sample.get((i << 6) + 46) + sample.get((i << 6) + 47) + 
						sample.get((i << 6) + 48) + sample.get((i << 6) + 49) + 
						sample.get((i << 6) + 50) + sample.get((i << 6) + 51) + 
						sample.get((i << 6) + 52) + sample.get((i << 6) + 53) + 
						sample.get((i << 6) + 54) + sample.get((i << 6) + 55) + 
						sample.get((i << 6) + 56) + sample.get((i << 6) + 57) + 
						sample.get((i << 6) + 58) + sample.get((i << 6) + 59) + 
						sample.get((i << 6) + 60) + sample.get((i << 6) + 61) + 
						sample.get((i << 6) + 62) + sample.get((i << 6) + 63))*0.015625);
		}
		return out;
	}
	
	private static function _mip128(sample : FastFloatBuffer) : FastFloatBuffer
	{
		var out = new FastFloatBuffer(sample.length >> 7);
		for (i in 0...sample.length >> 7)
		{
			out.set(i, (sample.get(i << 7) + sample.get((i << 7) + 7) + 
						sample.get((i << 7) + 2) + sample.get((i << 7) + 3) + 
						sample.get((i << 7) + 4) + sample.get((i << 7) + 5) + 
						sample.get((i << 7) + 6) + sample.get((i << 7) + 7) + 
						sample.get((i << 7) + 8) + sample.get((i << 7) + 9) + 
						sample.get((i << 7) + 10) + sample.get((i << 7) + 11) + 
						sample.get((i << 7) + 12) + sample.get((i << 7) + 13) + 
						sample.get((i << 7) + 14) + sample.get((i << 7) + 15) + 
						sample.get((i << 7) + 16) + sample.get((i << 7) + 17) + 
						sample.get((i << 7) + 18) + sample.get((i << 7) + 19) + 
						sample.get((i << 7) + 20) + sample.get((i << 7) + 21) + 
						sample.get((i << 7) + 22) + sample.get((i << 7) + 23) + 
						sample.get((i << 7) + 24) + sample.get((i << 7) + 25) + 
						sample.get((i << 7) + 26) + sample.get((i << 7) + 27) + 
						sample.get((i << 7) + 28) + sample.get((i << 7) + 29) + 
						sample.get((i << 7) + 30) + sample.get((i << 7) + 31) + 
						sample.get((i << 7) + 32) + sample.get((i << 7) + 33) + 
						sample.get((i << 7) + 34) + sample.get((i << 7) + 35) + 
						sample.get((i << 7) + 36) + sample.get((i << 7) + 37) + 
						sample.get((i << 7) + 38) + sample.get((i << 7) + 39) + 
						sample.get((i << 7) + 40) + sample.get((i << 7) + 41) + 
						sample.get((i << 7) + 42) + sample.get((i << 7) + 43) + 
						sample.get((i << 7) + 44) + sample.get((i << 7) + 45) + 
						sample.get((i << 7) + 46) + sample.get((i << 7) + 47) + 
						sample.get((i << 7) + 48) + sample.get((i << 7) + 49) + 
						sample.get((i << 7) + 50) + sample.get((i << 7) + 51) + 
						sample.get((i << 7) + 52) + sample.get((i << 7) + 53) + 
						sample.get((i << 7) + 54) + sample.get((i << 7) + 55) + 
						sample.get((i << 7) + 56) + sample.get((i << 7) + 57) + 
						sample.get((i << 7) + 58) + sample.get((i << 7) + 59) + 
						sample.get((i << 7) + 60) + sample.get((i << 7) + 61) + 
						sample.get((i << 7) + 62) + sample.get((i << 7) + 63) + 
						sample.get((i << 7) + 64) + sample.get((i << 7) + 65) + 
						sample.get((i << 7) + 66) + sample.get((i << 7) + 67) + 
						sample.get((i << 7) + 68) + sample.get((i << 7) + 69) + 
						sample.get((i << 7) + 70) + sample.get((i << 7) + 71) + 
						sample.get((i << 7) + 72) + sample.get((i << 7) + 73) + 
						sample.get((i << 7) + 74) + sample.get((i << 7) + 75) + 
						sample.get((i << 7) + 76) + sample.get((i << 7) + 77) + 
						sample.get((i << 7) + 78) + sample.get((i << 7) + 79) + 
						sample.get((i << 7) + 80) + sample.get((i << 7) + 81) + 
						sample.get((i << 7) + 82) + sample.get((i << 7) + 83) + 
						sample.get((i << 7) + 84) + sample.get((i << 7) + 85) + 
						sample.get((i << 7) + 86) + sample.get((i << 7) + 87) + 
						sample.get((i << 7) + 88) + sample.get((i << 7) + 89) + 
						sample.get((i << 7) + 90) + sample.get((i << 7) + 91) + 
						sample.get((i << 7) + 92) + sample.get((i << 7) + 93) + 
						sample.get((i << 7) + 94) + sample.get((i << 7) + 95) + 
						sample.get((i << 7) + 96) + sample.get((i << 7) + 97) + 
						sample.get((i << 7) + 98) + sample.get((i << 7) + 99) + 
						sample.get((i << 7) + 100) + sample.get((i << 7) + 101) + 
						sample.get((i << 7) + 102) + sample.get((i << 7) + 103) + 
						sample.get((i << 7) + 104) + sample.get((i << 7) + 105) + 
						sample.get((i << 7) + 106) + sample.get((i << 7) + 107) + 
						sample.get((i << 7) + 108) + sample.get((i << 7) + 109) + 
						sample.get((i << 7) + 110) + sample.get((i << 7) + 111) + 
						sample.get((i << 7) + 112) + sample.get((i << 7) + 113) + 
						sample.get((i << 7) + 114) + sample.get((i << 7) + 115) + 
						sample.get((i << 7) + 116) + sample.get((i << 7) + 117) + 
						sample.get((i << 7) + 118) + sample.get((i << 7) + 119) + 
						sample.get((i << 7) + 120) + sample.get((i << 7) + 121) + 
						sample.get((i << 7) + 122) + sample.get((i << 7) + 123) + 
						sample.get((i << 7) + 124) + sample.get((i << 7) + 125) + 
						sample.get((i << 7) + 126) + sample.get((i << 7) + 127))*0.0078125);
		}
		return out;
	}
	
	private static function _mip256(sample : FastFloatBuffer) : FastFloatBuffer
	{
		var out = new FastFloatBuffer(sample.length >> 8);
		for (i in 0...sample.length >> 8)
		{
			out.set(i, (
			sample.get((i << 8) + 0) + sample.get((i << 8) + 1) +
			sample.get((i << 8) + 2) + sample.get((i << 8) + 3) +
			sample.get((i << 8) + 4) + sample.get((i << 8) + 5) +
			sample.get((i << 8) + 6) + sample.get((i << 8) + 7) +
			sample.get((i << 8) + 8) + sample.get((i << 8) + 9) +
			sample.get((i << 8) + 10) + sample.get((i << 8) + 11) +
			sample.get((i << 8) + 12) + sample.get((i << 8) + 13) +
			sample.get((i << 8) + 14) + sample.get((i << 8) + 15) +
			sample.get((i << 8) + 16) + sample.get((i << 8) + 17) +
			sample.get((i << 8) + 18) + sample.get((i << 8) + 19) +
			sample.get((i << 8) + 20) + sample.get((i << 8) + 21) +
			sample.get((i << 8) + 22) + sample.get((i << 8) + 23) +
			sample.get((i << 8) + 24) + sample.get((i << 8) + 25) +
			sample.get((i << 8) + 26) + sample.get((i << 8) + 27) +
			sample.get((i << 8) + 28) + sample.get((i << 8) + 29) +
			sample.get((i << 8) + 30) + sample.get((i << 8) + 31) +
			sample.get((i << 8) + 32) + sample.get((i << 8) + 33) +
			sample.get((i << 8) + 34) + sample.get((i << 8) + 35) +
			sample.get((i << 8) + 36) + sample.get((i << 8) + 37) +
			sample.get((i << 8) + 38) + sample.get((i << 8) + 39) +
			sample.get((i << 8) + 40) + sample.get((i << 8) + 41) +
			sample.get((i << 8) + 42) + sample.get((i << 8) + 43) +
			sample.get((i << 8) + 44) + sample.get((i << 8) + 45) +
			sample.get((i << 8) + 46) + sample.get((i << 8) + 47) +
			sample.get((i << 8) + 48) + sample.get((i << 8) + 49) +
			sample.get((i << 8) + 50) + sample.get((i << 8) + 51) +
			sample.get((i << 8) + 52) + sample.get((i << 8) + 53) +
			sample.get((i << 8) + 54) + sample.get((i << 8) + 55) +
			sample.get((i << 8) + 56) + sample.get((i << 8) + 57) +
			sample.get((i << 8) + 58) + sample.get((i << 8) + 59) +
			sample.get((i << 8) + 60) + sample.get((i << 8) + 61) +
			sample.get((i << 8) + 62) + sample.get((i << 8) + 63) +
			sample.get((i << 8) + 64) + sample.get((i << 8) + 65) +
			sample.get((i << 8) + 66) + sample.get((i << 8) + 67) +
			sample.get((i << 8) + 68) + sample.get((i << 8) + 69) +
			sample.get((i << 8) + 70) + sample.get((i << 8) + 71) +
			sample.get((i << 8) + 72) + sample.get((i << 8) + 73) +
			sample.get((i << 8) + 74) + sample.get((i << 8) + 75) +
			sample.get((i << 8) + 76) + sample.get((i << 8) + 77) +
			sample.get((i << 8) + 78) + sample.get((i << 8) + 79) +
			sample.get((i << 8) + 80) + sample.get((i << 8) + 81) +
			sample.get((i << 8) + 82) + sample.get((i << 8) + 83) +
			sample.get((i << 8) + 84) + sample.get((i << 8) + 85) +
			sample.get((i << 8) + 86) + sample.get((i << 8) + 87) +
			sample.get((i << 8) + 88) + sample.get((i << 8) + 89) +
			sample.get((i << 8) + 90) + sample.get((i << 8) + 91) +
			sample.get((i << 8) + 92) + sample.get((i << 8) + 93) +
			sample.get((i << 8) + 94) + sample.get((i << 8) + 95) +
			sample.get((i << 8) + 96) + sample.get((i << 8) + 97) +
			sample.get((i << 8) + 98) + sample.get((i << 8) + 99) +
			sample.get((i << 8) + 100) + sample.get((i << 8) + 101) +
			sample.get((i << 8) + 102) + sample.get((i << 8) + 103) +
			sample.get((i << 8) + 104) + sample.get((i << 8) + 105) +
			sample.get((i << 8) + 106) + sample.get((i << 8) + 107) +
			sample.get((i << 8) + 108) + sample.get((i << 8) + 109) +
			sample.get((i << 8) + 110) + sample.get((i << 8) + 111) +
			sample.get((i << 8) + 112) + sample.get((i << 8) + 113) +
			sample.get((i << 8) + 114) + sample.get((i << 8) + 115) +
			sample.get((i << 8) + 116) + sample.get((i << 8) + 117) +
			sample.get((i << 8) + 118) + sample.get((i << 8) + 119) +
			sample.get((i << 8) + 120) + sample.get((i << 8) + 121) +
			sample.get((i << 8) + 122) + sample.get((i << 8) + 123) +
			sample.get((i << 8) + 124) + sample.get((i << 8) + 125) +
			sample.get((i << 8) + 126) + sample.get((i << 8) + 127) +
			sample.get((i << 8) + 128) + sample.get((i << 8) + 129) +
			sample.get((i << 8) + 130) + sample.get((i << 8) + 131) +
			sample.get((i << 8) + 132) + sample.get((i << 8) + 133) +
			sample.get((i << 8) + 134) + sample.get((i << 8) + 135) +
			sample.get((i << 8) + 136) + sample.get((i << 8) + 137) +
			sample.get((i << 8) + 138) + sample.get((i << 8) + 139) +
			sample.get((i << 8) + 140) + sample.get((i << 8) + 141) +
			sample.get((i << 8) + 142) + sample.get((i << 8) + 143) +
			sample.get((i << 8) + 144) + sample.get((i << 8) + 145) +
			sample.get((i << 8) + 146) + sample.get((i << 8) + 147) +
			sample.get((i << 8) + 148) + sample.get((i << 8) + 149) +
			sample.get((i << 8) + 150) + sample.get((i << 8) + 151) +
			sample.get((i << 8) + 152) + sample.get((i << 8) + 153) +
			sample.get((i << 8) + 154) + sample.get((i << 8) + 155) +
			sample.get((i << 8) + 156) + sample.get((i << 8) + 157) +
			sample.get((i << 8) + 158) + sample.get((i << 8) + 159) +
			sample.get((i << 8) + 160) + sample.get((i << 8) + 161) +
			sample.get((i << 8) + 162) + sample.get((i << 8) + 163) +
			sample.get((i << 8) + 164) + sample.get((i << 8) + 165) +
			sample.get((i << 8) + 166) + sample.get((i << 8) + 167) +
			sample.get((i << 8) + 168) + sample.get((i << 8) + 169) +
			sample.get((i << 8) + 170) + sample.get((i << 8) + 171) +
			sample.get((i << 8) + 172) + sample.get((i << 8) + 173) +
			sample.get((i << 8) + 174) + sample.get((i << 8) + 175) +
			sample.get((i << 8) + 176) + sample.get((i << 8) + 177) +
			sample.get((i << 8) + 178) + sample.get((i << 8) + 179) +
			sample.get((i << 8) + 180) + sample.get((i << 8) + 181) +
			sample.get((i << 8) + 182) + sample.get((i << 8) + 183) +
			sample.get((i << 8) + 184) + sample.get((i << 8) + 185) +
			sample.get((i << 8) + 186) + sample.get((i << 8) + 187) +
			sample.get((i << 8) + 188) + sample.get((i << 8) + 189) +
			sample.get((i << 8) + 190) + sample.get((i << 8) + 191) +
			sample.get((i << 8) + 192) + sample.get((i << 8) + 193) +
			sample.get((i << 8) + 194) + sample.get((i << 8) + 195) +
			sample.get((i << 8) + 196) + sample.get((i << 8) + 197) +
			sample.get((i << 8) + 198) + sample.get((i << 8) + 199) +
			sample.get((i << 8) + 200) + sample.get((i << 8) + 201) +
			sample.get((i << 8) + 202) + sample.get((i << 8) + 203) +
			sample.get((i << 8) + 204) + sample.get((i << 8) + 205) +
			sample.get((i << 8) + 206) + sample.get((i << 8) + 207) +
			sample.get((i << 8) + 208) + sample.get((i << 8) + 209) +
			sample.get((i << 8) + 210) + sample.get((i << 8) + 211) +
			sample.get((i << 8) + 212) + sample.get((i << 8) + 213) +
			sample.get((i << 8) + 214) + sample.get((i << 8) + 215) +
			sample.get((i << 8) + 216) + sample.get((i << 8) + 217) +
			sample.get((i << 8) + 218) + sample.get((i << 8) + 219) +
			sample.get((i << 8) + 220) + sample.get((i << 8) + 221) +
			sample.get((i << 8) + 222) + sample.get((i << 8) + 223) +
			sample.get((i << 8) + 224) + sample.get((i << 8) + 225) +
			sample.get((i << 8) + 226) + sample.get((i << 8) + 227) +
			sample.get((i << 8) + 228) + sample.get((i << 8) + 229) +
			sample.get((i << 8) + 230) + sample.get((i << 8) + 231) +
			sample.get((i << 8) + 232) + sample.get((i << 8) + 233) +
			sample.get((i << 8) + 234) + sample.get((i << 8) + 235) +
			sample.get((i << 8) + 236) + sample.get((i << 8) + 237) +
			sample.get((i << 8) + 238) + sample.get((i << 8) + 239) +
			sample.get((i << 8) + 240) + sample.get((i << 8) + 241) +
			sample.get((i << 8) + 242) + sample.get((i << 8) + 243) +
			sample.get((i << 8) + 244) + sample.get((i << 8) + 245) +
			sample.get((i << 8) + 246) + sample.get((i << 8) + 247) +
			sample.get((i << 8) + 248) + sample.get((i << 8) + 249) +
			sample.get((i << 8) + 250) + sample.get((i << 8) + 251) +
			sample.get((i << 8) + 252) + sample.get((i << 8) + 253) +
			sample.get((i << 8) + 254) + sample.get((i << 8) + 255))
				*0.00390625);
		}
		return out;
	}
	
	private static function _mip512(sample : FastFloatBuffer) : FastFloatBuffer
	{
		var out = new FastFloatBuffer(sample.length >> 9);
		for (i in 0...sample.length >> 9)
		{
			out.set(i, (
				sample.get((i << 9) + 0) + sample.get((i << 9) + 1) +
				sample.get((i << 9) + 2) + sample.get((i << 9) + 3) +
				sample.get((i << 9) + 4) + sample.get((i << 9) + 5) +
				sample.get((i << 9) + 6) + sample.get((i << 9) + 7) +
				sample.get((i << 9) + 8) + sample.get((i << 9) + 9) +
				sample.get((i << 9) + 10) + sample.get((i << 9) + 11) +
				sample.get((i << 9) + 12) + sample.get((i << 9) + 13) +
				sample.get((i << 9) + 14) + sample.get((i << 9) + 15) +
				sample.get((i << 9) + 16) + sample.get((i << 9) + 17) +
				sample.get((i << 9) + 18) + sample.get((i << 9) + 19) +
				sample.get((i << 9) + 20) + sample.get((i << 9) + 21) +
				sample.get((i << 9) + 22) + sample.get((i << 9) + 23) +
				sample.get((i << 9) + 24) + sample.get((i << 9) + 25) +
				sample.get((i << 9) + 26) + sample.get((i << 9) + 27) +
				sample.get((i << 9) + 28) + sample.get((i << 9) + 29) +
				sample.get((i << 9) + 30) + sample.get((i << 9) + 31) +
				sample.get((i << 9) + 32) + sample.get((i << 9) + 33) +
				sample.get((i << 9) + 34) + sample.get((i << 9) + 35) +
				sample.get((i << 9) + 36) + sample.get((i << 9) + 37) +
				sample.get((i << 9) + 38) + sample.get((i << 9) + 39) +
				sample.get((i << 9) + 40) + sample.get((i << 9) + 41) +
				sample.get((i << 9) + 42) + sample.get((i << 9) + 43) +
				sample.get((i << 9) + 44) + sample.get((i << 9) + 45) +
				sample.get((i << 9) + 46) + sample.get((i << 9) + 47) +
				sample.get((i << 9) + 48) + sample.get((i << 9) + 49) +
				sample.get((i << 9) + 50) + sample.get((i << 9) + 51) +
				sample.get((i << 9) + 52) + sample.get((i << 9) + 53) +
				sample.get((i << 9) + 54) + sample.get((i << 9) + 55) +
				sample.get((i << 9) + 56) + sample.get((i << 9) + 57) +
				sample.get((i << 9) + 58) + sample.get((i << 9) + 59) +
				sample.get((i << 9) + 60) + sample.get((i << 9) + 61) +
				sample.get((i << 9) + 62) + sample.get((i << 9) + 63) +
				sample.get((i << 9) + 64) + sample.get((i << 9) + 65) +
				sample.get((i << 9) + 66) + sample.get((i << 9) + 67) +
				sample.get((i << 9) + 68) + sample.get((i << 9) + 69) +
				sample.get((i << 9) + 70) + sample.get((i << 9) + 71) +
				sample.get((i << 9) + 72) + sample.get((i << 9) + 73) +
				sample.get((i << 9) + 74) + sample.get((i << 9) + 75) +
				sample.get((i << 9) + 76) + sample.get((i << 9) + 77) +
				sample.get((i << 9) + 78) + sample.get((i << 9) + 79) +
				sample.get((i << 9) + 80) + sample.get((i << 9) + 81) +
				sample.get((i << 9) + 82) + sample.get((i << 9) + 83) +
				sample.get((i << 9) + 84) + sample.get((i << 9) + 85) +
				sample.get((i << 9) + 86) + sample.get((i << 9) + 87) +
				sample.get((i << 9) + 88) + sample.get((i << 9) + 89) +
				sample.get((i << 9) + 90) + sample.get((i << 9) + 91) +
				sample.get((i << 9) + 92) + sample.get((i << 9) + 93) +
				sample.get((i << 9) + 94) + sample.get((i << 9) + 95) +
				sample.get((i << 9) + 96) + sample.get((i << 9) + 97) +
				sample.get((i << 9) + 98) + sample.get((i << 9) + 99) +
				sample.get((i << 9) + 100) + sample.get((i << 9) + 101) +
				sample.get((i << 9) + 102) + sample.get((i << 9) + 103) +
				sample.get((i << 9) + 104) + sample.get((i << 9) + 105) +
				sample.get((i << 9) + 106) + sample.get((i << 9) + 107) +
				sample.get((i << 9) + 108) + sample.get((i << 9) + 109) +
				sample.get((i << 9) + 110) + sample.get((i << 9) + 111) +
				sample.get((i << 9) + 112) + sample.get((i << 9) + 113) +
				sample.get((i << 9) + 114) + sample.get((i << 9) + 115) +
				sample.get((i << 9) + 116) + sample.get((i << 9) + 117) +
				sample.get((i << 9) + 118) + sample.get((i << 9) + 119) +
				sample.get((i << 9) + 120) + sample.get((i << 9) + 121) +
				sample.get((i << 9) + 122) + sample.get((i << 9) + 123) +
				sample.get((i << 9) + 124) + sample.get((i << 9) + 125) +
				sample.get((i << 9) + 126) + sample.get((i << 9) + 127) +
				sample.get((i << 9) + 128) + sample.get((i << 9) + 129) +
				sample.get((i << 9) + 130) + sample.get((i << 9) + 131) +
				sample.get((i << 9) + 132) + sample.get((i << 9) + 133) +
				sample.get((i << 9) + 134) + sample.get((i << 9) + 135) +
				sample.get((i << 9) + 136) + sample.get((i << 9) + 137) +
				sample.get((i << 9) + 138) + sample.get((i << 9) + 139) +
				sample.get((i << 9) + 140) + sample.get((i << 9) + 141) +
				sample.get((i << 9) + 142) + sample.get((i << 9) + 143) +
				sample.get((i << 9) + 144) + sample.get((i << 9) + 145) +
				sample.get((i << 9) + 146) + sample.get((i << 9) + 147) +
				sample.get((i << 9) + 148) + sample.get((i << 9) + 149) +
				sample.get((i << 9) + 150) + sample.get((i << 9) + 151) +
				sample.get((i << 9) + 152) + sample.get((i << 9) + 153) +
				sample.get((i << 9) + 154) + sample.get((i << 9) + 155) +
				sample.get((i << 9) + 156) + sample.get((i << 9) + 157) +
				sample.get((i << 9) + 158) + sample.get((i << 9) + 159) +
				sample.get((i << 9) + 160) + sample.get((i << 9) + 161) +
				sample.get((i << 9) + 162) + sample.get((i << 9) + 163) +
				sample.get((i << 9) + 164) + sample.get((i << 9) + 165) +
				sample.get((i << 9) + 166) + sample.get((i << 9) + 167) +
				sample.get((i << 9) + 168) + sample.get((i << 9) + 169) +
				sample.get((i << 9) + 170) + sample.get((i << 9) + 171) +
				sample.get((i << 9) + 172) + sample.get((i << 9) + 173) +
				sample.get((i << 9) + 174) + sample.get((i << 9) + 175) +
				sample.get((i << 9) + 176) + sample.get((i << 9) + 177) +
				sample.get((i << 9) + 178) + sample.get((i << 9) + 179) +
				sample.get((i << 9) + 180) + sample.get((i << 9) + 181) +
				sample.get((i << 9) + 182) + sample.get((i << 9) + 183) +
				sample.get((i << 9) + 184) + sample.get((i << 9) + 185) +
				sample.get((i << 9) + 186) + sample.get((i << 9) + 187) +
				sample.get((i << 9) + 188) + sample.get((i << 9) + 189) +
				sample.get((i << 9) + 190) + sample.get((i << 9) + 191) +
				sample.get((i << 9) + 192) + sample.get((i << 9) + 193) +
				sample.get((i << 9) + 194) + sample.get((i << 9) + 195) +
				sample.get((i << 9) + 196) + sample.get((i << 9) + 197) +
				sample.get((i << 9) + 198) + sample.get((i << 9) + 199) +
				sample.get((i << 9) + 200) + sample.get((i << 9) + 201) +
				sample.get((i << 9) + 202) + sample.get((i << 9) + 203) +
				sample.get((i << 9) + 204) + sample.get((i << 9) + 205) +
				sample.get((i << 9) + 206) + sample.get((i << 9) + 207) +
				sample.get((i << 9) + 208) + sample.get((i << 9) + 209) +
				sample.get((i << 9) + 210) + sample.get((i << 9) + 211) +
				sample.get((i << 9) + 212) + sample.get((i << 9) + 213) +
				sample.get((i << 9) + 214) + sample.get((i << 9) + 215) +
				sample.get((i << 9) + 216) + sample.get((i << 9) + 217) +
				sample.get((i << 9) + 218) + sample.get((i << 9) + 219) +
				sample.get((i << 9) + 220) + sample.get((i << 9) + 221) +
				sample.get((i << 9) + 222) + sample.get((i << 9) + 223) +
				sample.get((i << 9) + 224) + sample.get((i << 9) + 225) +
				sample.get((i << 9) + 226) + sample.get((i << 9) + 227) +
				sample.get((i << 9) + 228) + sample.get((i << 9) + 229) +
				sample.get((i << 9) + 230) + sample.get((i << 9) + 231) +
				sample.get((i << 9) + 232) + sample.get((i << 9) + 233) +
				sample.get((i << 9) + 234) + sample.get((i << 9) + 235) +
				sample.get((i << 9) + 236) + sample.get((i << 9) + 237) +
				sample.get((i << 9) + 238) + sample.get((i << 9) + 239) +
				sample.get((i << 9) + 240) + sample.get((i << 9) + 241) +
				sample.get((i << 9) + 242) + sample.get((i << 9) + 243) +
				sample.get((i << 9) + 244) + sample.get((i << 9) + 245) +
				sample.get((i << 9) + 246) + sample.get((i << 9) + 247) +
				sample.get((i << 9) + 248) + sample.get((i << 9) + 249) +
				sample.get((i << 9) + 250) + sample.get((i << 9) + 251) +
				sample.get((i << 9) + 252) + sample.get((i << 9) + 253) +
				sample.get((i << 9) + 254) + sample.get((i << 9) + 255) +
				sample.get((i << 9) + 256) + sample.get((i << 9) + 257) +
				sample.get((i << 9) + 258) + sample.get((i << 9) + 259) +
				sample.get((i << 9) + 260) + sample.get((i << 9) + 261) +
				sample.get((i << 9) + 262) + sample.get((i << 9) + 263) +
				sample.get((i << 9) + 264) + sample.get((i << 9) + 265) +
				sample.get((i << 9) + 266) + sample.get((i << 9) + 267) +
				sample.get((i << 9) + 268) + sample.get((i << 9) + 269) +
				sample.get((i << 9) + 270) + sample.get((i << 9) + 271) +
				sample.get((i << 9) + 272) + sample.get((i << 9) + 273) +
				sample.get((i << 9) + 274) + sample.get((i << 9) + 275) +
				sample.get((i << 9) + 276) + sample.get((i << 9) + 277) +
				sample.get((i << 9) + 278) + sample.get((i << 9) + 279) +
				sample.get((i << 9) + 280) + sample.get((i << 9) + 281) +
				sample.get((i << 9) + 282) + sample.get((i << 9) + 283) +
				sample.get((i << 9) + 284) + sample.get((i << 9) + 285) +
				sample.get((i << 9) + 286) + sample.get((i << 9) + 287) +
				sample.get((i << 9) + 288) + sample.get((i << 9) + 289) +
				sample.get((i << 9) + 290) + sample.get((i << 9) + 291) +
				sample.get((i << 9) + 292) + sample.get((i << 9) + 293) +
				sample.get((i << 9) + 294) + sample.get((i << 9) + 295) +
				sample.get((i << 9) + 296) + sample.get((i << 9) + 297) +
				sample.get((i << 9) + 298) + sample.get((i << 9) + 299) +
				sample.get((i << 9) + 300) + sample.get((i << 9) + 301) +
				sample.get((i << 9) + 302) + sample.get((i << 9) + 303) +
				sample.get((i << 9) + 304) + sample.get((i << 9) + 305) +
				sample.get((i << 9) + 306) + sample.get((i << 9) + 307) +
				sample.get((i << 9) + 308) + sample.get((i << 9) + 309) +
				sample.get((i << 9) + 310) + sample.get((i << 9) + 311) +
				sample.get((i << 9) + 312) + sample.get((i << 9) + 313) +
				sample.get((i << 9) + 314) + sample.get((i << 9) + 315) +
				sample.get((i << 9) + 316) + sample.get((i << 9) + 317) +
				sample.get((i << 9) + 318) + sample.get((i << 9) + 319) +
				sample.get((i << 9) + 320) + sample.get((i << 9) + 321) +
				sample.get((i << 9) + 322) + sample.get((i << 9) + 323) +
				sample.get((i << 9) + 324) + sample.get((i << 9) + 325) +
				sample.get((i << 9) + 326) + sample.get((i << 9) + 327) +
				sample.get((i << 9) + 328) + sample.get((i << 9) + 329) +
				sample.get((i << 9) + 330) + sample.get((i << 9) + 331) +
				sample.get((i << 9) + 332) + sample.get((i << 9) + 333) +
				sample.get((i << 9) + 334) + sample.get((i << 9) + 335) +
				sample.get((i << 9) + 336) + sample.get((i << 9) + 337) +
				sample.get((i << 9) + 338) + sample.get((i << 9) + 339) +
				sample.get((i << 9) + 340) + sample.get((i << 9) + 341) +
				sample.get((i << 9) + 342) + sample.get((i << 9) + 343) +
				sample.get((i << 9) + 344) + sample.get((i << 9) + 345) +
				sample.get((i << 9) + 346) + sample.get((i << 9) + 347) +
				sample.get((i << 9) + 348) + sample.get((i << 9) + 349) +
				sample.get((i << 9) + 350) + sample.get((i << 9) + 351) +
				sample.get((i << 9) + 352) + sample.get((i << 9) + 353) +
				sample.get((i << 9) + 354) + sample.get((i << 9) + 355) +
				sample.get((i << 9) + 356) + sample.get((i << 9) + 357) +
				sample.get((i << 9) + 358) + sample.get((i << 9) + 359) +
				sample.get((i << 9) + 360) + sample.get((i << 9) + 361) +
				sample.get((i << 9) + 362) + sample.get((i << 9) + 363) +
				sample.get((i << 9) + 364) + sample.get((i << 9) + 365) +
				sample.get((i << 9) + 366) + sample.get((i << 9) + 367) +
				sample.get((i << 9) + 368) + sample.get((i << 9) + 369) +
				sample.get((i << 9) + 370) + sample.get((i << 9) + 371) +
				sample.get((i << 9) + 372) + sample.get((i << 9) + 373) +
				sample.get((i << 9) + 374) + sample.get((i << 9) + 375) +
				sample.get((i << 9) + 376) + sample.get((i << 9) + 377) +
				sample.get((i << 9) + 378) + sample.get((i << 9) + 379) +
				sample.get((i << 9) + 380) + sample.get((i << 9) + 381) +
				sample.get((i << 9) + 382) + sample.get((i << 9) + 383) +
				sample.get((i << 9) + 384) + sample.get((i << 9) + 385) +
				sample.get((i << 9) + 386) + sample.get((i << 9) + 387) +
				sample.get((i << 9) + 388) + sample.get((i << 9) + 389) +
				sample.get((i << 9) + 390) + sample.get((i << 9) + 391) +
				sample.get((i << 9) + 392) + sample.get((i << 9) + 393) +
				sample.get((i << 9) + 394) + sample.get((i << 9) + 395) +
				sample.get((i << 9) + 396) + sample.get((i << 9) + 397) +
				sample.get((i << 9) + 398) + sample.get((i << 9) + 399) +
				sample.get((i << 9) + 400) + sample.get((i << 9) + 401) +
				sample.get((i << 9) + 402) + sample.get((i << 9) + 403) +
				sample.get((i << 9) + 404) + sample.get((i << 9) + 405) +
				sample.get((i << 9) + 406) + sample.get((i << 9) + 407) +
				sample.get((i << 9) + 408) + sample.get((i << 9) + 409) +
				sample.get((i << 9) + 410) + sample.get((i << 9) + 411) +
				sample.get((i << 9) + 412) + sample.get((i << 9) + 413) +
				sample.get((i << 9) + 414) + sample.get((i << 9) + 415) +
				sample.get((i << 9) + 416) + sample.get((i << 9) + 417) +
				sample.get((i << 9) + 418) + sample.get((i << 9) + 419) +
				sample.get((i << 9) + 420) + sample.get((i << 9) + 421) +
				sample.get((i << 9) + 422) + sample.get((i << 9) + 423) +
				sample.get((i << 9) + 424) + sample.get((i << 9) + 425) +
				sample.get((i << 9) + 426) + sample.get((i << 9) + 427) +
				sample.get((i << 9) + 428) + sample.get((i << 9) + 429) +
				sample.get((i << 9) + 430) + sample.get((i << 9) + 431) +
				sample.get((i << 9) + 432) + sample.get((i << 9) + 433) +
				sample.get((i << 9) + 434) + sample.get((i << 9) + 435) +
				sample.get((i << 9) + 436) + sample.get((i << 9) + 437) +
				sample.get((i << 9) + 438) + sample.get((i << 9) + 439) +
				sample.get((i << 9) + 440) + sample.get((i << 9) + 441) +
				sample.get((i << 9) + 442) + sample.get((i << 9) + 443) +
				sample.get((i << 9) + 444) + sample.get((i << 9) + 445) +
				sample.get((i << 9) + 446) + sample.get((i << 9) + 447) +
				sample.get((i << 9) + 448) + sample.get((i << 9) + 449) +
				sample.get((i << 9) + 450) + sample.get((i << 9) + 451) +
				sample.get((i << 9) + 452) + sample.get((i << 9) + 453) +
				sample.get((i << 9) + 454) + sample.get((i << 9) + 455) +
				sample.get((i << 9) + 456) + sample.get((i << 9) + 457) +
				sample.get((i << 9) + 458) + sample.get((i << 9) + 459) +
				sample.get((i << 9) + 460) + sample.get((i << 9) + 461) +
				sample.get((i << 9) + 462) + sample.get((i << 9) + 463) +
				sample.get((i << 9) + 464) + sample.get((i << 9) + 465) +
				sample.get((i << 9) + 466) + sample.get((i << 9) + 467) +
				sample.get((i << 9) + 468) + sample.get((i << 9) + 469) +
				sample.get((i << 9) + 470) + sample.get((i << 9) + 471) +
				sample.get((i << 9) + 472) + sample.get((i << 9) + 473) +
				sample.get((i << 9) + 474) + sample.get((i << 9) + 475) +
				sample.get((i << 9) + 476) + sample.get((i << 9) + 477) +
				sample.get((i << 9) + 478) + sample.get((i << 9) + 479) +
				sample.get((i << 9) + 480) + sample.get((i << 9) + 481) +
				sample.get((i << 9) + 482) + sample.get((i << 9) + 483) +
				sample.get((i << 9) + 484) + sample.get((i << 9) + 485) +
				sample.get((i << 9) + 486) + sample.get((i << 9) + 487) +
				sample.get((i << 9) + 488) + sample.get((i << 9) + 489) +
				sample.get((i << 9) + 490) + sample.get((i << 9) + 491) +
				sample.get((i << 9) + 492) + sample.get((i << 9) + 493) +
				sample.get((i << 9) + 494) + sample.get((i << 9) + 495) +
				sample.get((i << 9) + 496) + sample.get((i << 9) + 497) +
				sample.get((i << 9) + 498) + sample.get((i << 9) + 499) +
				sample.get((i << 9) + 500) + sample.get((i << 9) + 501) +
				sample.get((i << 9) + 502) + sample.get((i << 9) + 503) +
				sample.get((i << 9) + 504) + sample.get((i << 9) + 505) +
				sample.get((i << 9) + 506) + sample.get((i << 9) + 507) +
				sample.get((i << 9) + 508) + sample.get((i << 9) + 509) +
				sample.get((i << 9) + 510) + sample.get((i << 9) + 511))			
				*0.0001953125);
		}
		return out;
	}
	
	private static function _mip1024(sample : FastFloatBuffer) : FastFloatBuffer
	{
		var out = new FastFloatBuffer(sample.length >> 10);
		for (i in 0...sample.length >> 10)
		{
			out.set(i, (
			sample.get((i << 10) + 0) + sample.get((i << 10) + 1) +
			sample.get((i << 10) + 2) + sample.get((i << 10) + 3) +
			sample.get((i << 10) + 4) + sample.get((i << 10) + 5) +
			sample.get((i << 10) + 6) + sample.get((i << 10) + 7) +
			sample.get((i << 10) + 8) + sample.get((i << 10) + 9) +
			sample.get((i << 10) + 10) + sample.get((i << 10) + 11) +
			sample.get((i << 10) + 12) + sample.get((i << 10) + 13) +
			sample.get((i << 10) + 14) + sample.get((i << 10) + 15) +
			sample.get((i << 10) + 16) + sample.get((i << 10) + 17) +
			sample.get((i << 10) + 18) + sample.get((i << 10) + 19) +
			sample.get((i << 10) + 20) + sample.get((i << 10) + 21) +
			sample.get((i << 10) + 22) + sample.get((i << 10) + 23) +
			sample.get((i << 10) + 24) + sample.get((i << 10) + 25) +
			sample.get((i << 10) + 26) + sample.get((i << 10) + 27) +
			sample.get((i << 10) + 28) + sample.get((i << 10) + 29) +
			sample.get((i << 10) + 30) + sample.get((i << 10) + 31) +
			sample.get((i << 10) + 32) + sample.get((i << 10) + 33) +
			sample.get((i << 10) + 34) + sample.get((i << 10) + 35) +
			sample.get((i << 10) + 36) + sample.get((i << 10) + 37) +
			sample.get((i << 10) + 38) + sample.get((i << 10) + 39) +
			sample.get((i << 10) + 40) + sample.get((i << 10) + 41) +
			sample.get((i << 10) + 42) + sample.get((i << 10) + 43) +
			sample.get((i << 10) + 44) + sample.get((i << 10) + 45) +
			sample.get((i << 10) + 46) + sample.get((i << 10) + 47) +
			sample.get((i << 10) + 48) + sample.get((i << 10) + 49) +
			sample.get((i << 10) + 50) + sample.get((i << 10) + 51) +
			sample.get((i << 10) + 52) + sample.get((i << 10) + 53) +
			sample.get((i << 10) + 54) + sample.get((i << 10) + 55) +
			sample.get((i << 10) + 56) + sample.get((i << 10) + 57) +
			sample.get((i << 10) + 58) + sample.get((i << 10) + 59) +
			sample.get((i << 10) + 60) + sample.get((i << 10) + 61) +
			sample.get((i << 10) + 62) + sample.get((i << 10) + 63) +
			sample.get((i << 10) + 64) + sample.get((i << 10) + 65) +
			sample.get((i << 10) + 66) + sample.get((i << 10) + 67) +
			sample.get((i << 10) + 68) + sample.get((i << 10) + 69) +
			sample.get((i << 10) + 70) + sample.get((i << 10) + 71) +
			sample.get((i << 10) + 72) + sample.get((i << 10) + 73) +
			sample.get((i << 10) + 74) + sample.get((i << 10) + 75) +
			sample.get((i << 10) + 76) + sample.get((i << 10) + 77) +
			sample.get((i << 10) + 78) + sample.get((i << 10) + 79) +
			sample.get((i << 10) + 80) + sample.get((i << 10) + 81) +
			sample.get((i << 10) + 82) + sample.get((i << 10) + 83) +
			sample.get((i << 10) + 84) + sample.get((i << 10) + 85) +
			sample.get((i << 10) + 86) + sample.get((i << 10) + 87) +
			sample.get((i << 10) + 88) + sample.get((i << 10) + 89) +
			sample.get((i << 10) + 90) + sample.get((i << 10) + 91) +
			sample.get((i << 10) + 92) + sample.get((i << 10) + 93) +
			sample.get((i << 10) + 94) + sample.get((i << 10) + 95) +
			sample.get((i << 10) + 96) + sample.get((i << 10) + 97) +
			sample.get((i << 10) + 98) + sample.get((i << 10) + 99) +
			sample.get((i << 10) + 100) + sample.get((i << 10) + 101) +
			sample.get((i << 10) + 102) + sample.get((i << 10) + 103) +
			sample.get((i << 10) + 104) + sample.get((i << 10) + 105) +
			sample.get((i << 10) + 106) + sample.get((i << 10) + 107) +
			sample.get((i << 10) + 108) + sample.get((i << 10) + 109) +
			sample.get((i << 10) + 110) + sample.get((i << 10) + 111) +
			sample.get((i << 10) + 112) + sample.get((i << 10) + 113) +
			sample.get((i << 10) + 114) + sample.get((i << 10) + 115) +
			sample.get((i << 10) + 116) + sample.get((i << 10) + 117) +
			sample.get((i << 10) + 118) + sample.get((i << 10) + 119) +
			sample.get((i << 10) + 120) + sample.get((i << 10) + 121) +
			sample.get((i << 10) + 122) + sample.get((i << 10) + 123) +
			sample.get((i << 10) + 124) + sample.get((i << 10) + 125) +
			sample.get((i << 10) + 126) + sample.get((i << 10) + 127) +
			sample.get((i << 10) + 128) + sample.get((i << 10) + 129) +
			sample.get((i << 10) + 130) + sample.get((i << 10) + 131) +
			sample.get((i << 10) + 132) + sample.get((i << 10) + 133) +
			sample.get((i << 10) + 134) + sample.get((i << 10) + 135) +
			sample.get((i << 10) + 136) + sample.get((i << 10) + 137) +
			sample.get((i << 10) + 138) + sample.get((i << 10) + 139) +
			sample.get((i << 10) + 140) + sample.get((i << 10) + 141) +
			sample.get((i << 10) + 142) + sample.get((i << 10) + 143) +
			sample.get((i << 10) + 144) + sample.get((i << 10) + 145) +
			sample.get((i << 10) + 146) + sample.get((i << 10) + 147) +
			sample.get((i << 10) + 148) + sample.get((i << 10) + 149) +
			sample.get((i << 10) + 150) + sample.get((i << 10) + 151) +
			sample.get((i << 10) + 152) + sample.get((i << 10) + 153) +
			sample.get((i << 10) + 154) + sample.get((i << 10) + 155) +
			sample.get((i << 10) + 156) + sample.get((i << 10) + 157) +
			sample.get((i << 10) + 158) + sample.get((i << 10) + 159) +
			sample.get((i << 10) + 160) + sample.get((i << 10) + 161) +
			sample.get((i << 10) + 162) + sample.get((i << 10) + 163) +
			sample.get((i << 10) + 164) + sample.get((i << 10) + 165) +
			sample.get((i << 10) + 166) + sample.get((i << 10) + 167) +
			sample.get((i << 10) + 168) + sample.get((i << 10) + 169) +
			sample.get((i << 10) + 170) + sample.get((i << 10) + 171) +
			sample.get((i << 10) + 172) + sample.get((i << 10) + 173) +
			sample.get((i << 10) + 174) + sample.get((i << 10) + 175) +
			sample.get((i << 10) + 176) + sample.get((i << 10) + 177) +
			sample.get((i << 10) + 178) + sample.get((i << 10) + 179) +
			sample.get((i << 10) + 180) + sample.get((i << 10) + 181) +
			sample.get((i << 10) + 182) + sample.get((i << 10) + 183) +
			sample.get((i << 10) + 184) + sample.get((i << 10) + 185) +
			sample.get((i << 10) + 186) + sample.get((i << 10) + 187) +
			sample.get((i << 10) + 188) + sample.get((i << 10) + 189) +
			sample.get((i << 10) + 190) + sample.get((i << 10) + 191) +
			sample.get((i << 10) + 192) + sample.get((i << 10) + 193) +
			sample.get((i << 10) + 194) + sample.get((i << 10) + 195) +
			sample.get((i << 10) + 196) + sample.get((i << 10) + 197) +
			sample.get((i << 10) + 198) + sample.get((i << 10) + 199) +
			sample.get((i << 10) + 200) + sample.get((i << 10) + 201) +
			sample.get((i << 10) + 202) + sample.get((i << 10) + 203) +
			sample.get((i << 10) + 204) + sample.get((i << 10) + 205) +
			sample.get((i << 10) + 206) + sample.get((i << 10) + 207) +
			sample.get((i << 10) + 208) + sample.get((i << 10) + 209) +
			sample.get((i << 10) + 210) + sample.get((i << 10) + 211) +
			sample.get((i << 10) + 212) + sample.get((i << 10) + 213) +
			sample.get((i << 10) + 214) + sample.get((i << 10) + 215) +
			sample.get((i << 10) + 216) + sample.get((i << 10) + 217) +
			sample.get((i << 10) + 218) + sample.get((i << 10) + 219) +
			sample.get((i << 10) + 220) + sample.get((i << 10) + 221) +
			sample.get((i << 10) + 222) + sample.get((i << 10) + 223) +
			sample.get((i << 10) + 224) + sample.get((i << 10) + 225) +
			sample.get((i << 10) + 226) + sample.get((i << 10) + 227) +
			sample.get((i << 10) + 228) + sample.get((i << 10) + 229) +
			sample.get((i << 10) + 230) + sample.get((i << 10) + 231) +
			sample.get((i << 10) + 232) + sample.get((i << 10) + 233) +
			sample.get((i << 10) + 234) + sample.get((i << 10) + 235) +
			sample.get((i << 10) + 236) + sample.get((i << 10) + 237) +
			sample.get((i << 10) + 238) + sample.get((i << 10) + 239) +
			sample.get((i << 10) + 240) + sample.get((i << 10) + 241) +
			sample.get((i << 10) + 242) + sample.get((i << 10) + 243) +
			sample.get((i << 10) + 244) + sample.get((i << 10) + 245) +
			sample.get((i << 10) + 246) + sample.get((i << 10) + 247) +
			sample.get((i << 10) + 248) + sample.get((i << 10) + 249) +
			sample.get((i << 10) + 250) + sample.get((i << 10) + 251) +
			sample.get((i << 10) + 252) + sample.get((i << 10) + 253) +
			sample.get((i << 10) + 254) + sample.get((i << 10) + 255) +
			sample.get((i << 10) + 256) + sample.get((i << 10) + 257) +
			sample.get((i << 10) + 258) + sample.get((i << 10) + 259) +
			sample.get((i << 10) + 260) + sample.get((i << 10) + 261) +
			sample.get((i << 10) + 262) + sample.get((i << 10) + 263) +
			sample.get((i << 10) + 264) + sample.get((i << 10) + 265) +
			sample.get((i << 10) + 266) + sample.get((i << 10) + 267) +
			sample.get((i << 10) + 268) + sample.get((i << 10) + 269) +
			sample.get((i << 10) + 270) + sample.get((i << 10) + 271) +
			sample.get((i << 10) + 272) + sample.get((i << 10) + 273) +
			sample.get((i << 10) + 274) + sample.get((i << 10) + 275) +
			sample.get((i << 10) + 276) + sample.get((i << 10) + 277) +
			sample.get((i << 10) + 278) + sample.get((i << 10) + 279) +
			sample.get((i << 10) + 280) + sample.get((i << 10) + 281) +
			sample.get((i << 10) + 282) + sample.get((i << 10) + 283) +
			sample.get((i << 10) + 284) + sample.get((i << 10) + 285) +
			sample.get((i << 10) + 286) + sample.get((i << 10) + 287) +
			sample.get((i << 10) + 288) + sample.get((i << 10) + 289) +
			sample.get((i << 10) + 290) + sample.get((i << 10) + 291) +
			sample.get((i << 10) + 292) + sample.get((i << 10) + 293) +
			sample.get((i << 10) + 294) + sample.get((i << 10) + 295) +
			sample.get((i << 10) + 296) + sample.get((i << 10) + 297) +
			sample.get((i << 10) + 298) + sample.get((i << 10) + 299) +
			sample.get((i << 10) + 300) + sample.get((i << 10) + 301) +
			sample.get((i << 10) + 302) + sample.get((i << 10) + 303) +
			sample.get((i << 10) + 304) + sample.get((i << 10) + 305) +
			sample.get((i << 10) + 306) + sample.get((i << 10) + 307) +
			sample.get((i << 10) + 308) + sample.get((i << 10) + 309) +
			sample.get((i << 10) + 310) + sample.get((i << 10) + 311) +
			sample.get((i << 10) + 312) + sample.get((i << 10) + 313) +
			sample.get((i << 10) + 314) + sample.get((i << 10) + 315) +
			sample.get((i << 10) + 316) + sample.get((i << 10) + 317) +
			sample.get((i << 10) + 318) + sample.get((i << 10) + 319) +
			sample.get((i << 10) + 320) + sample.get((i << 10) + 321) +
			sample.get((i << 10) + 322) + sample.get((i << 10) + 323) +
			sample.get((i << 10) + 324) + sample.get((i << 10) + 325) +
			sample.get((i << 10) + 326) + sample.get((i << 10) + 327) +
			sample.get((i << 10) + 328) + sample.get((i << 10) + 329) +
			sample.get((i << 10) + 330) + sample.get((i << 10) + 331) +
			sample.get((i << 10) + 332) + sample.get((i << 10) + 333) +
			sample.get((i << 10) + 334) + sample.get((i << 10) + 335) +
			sample.get((i << 10) + 336) + sample.get((i << 10) + 337) +
			sample.get((i << 10) + 338) + sample.get((i << 10) + 339) +
			sample.get((i << 10) + 340) + sample.get((i << 10) + 341) +
			sample.get((i << 10) + 342) + sample.get((i << 10) + 343) +
			sample.get((i << 10) + 344) + sample.get((i << 10) + 345) +
			sample.get((i << 10) + 346) + sample.get((i << 10) + 347) +
			sample.get((i << 10) + 348) + sample.get((i << 10) + 349) +
			sample.get((i << 10) + 350) + sample.get((i << 10) + 351) +
			sample.get((i << 10) + 352) + sample.get((i << 10) + 353) +
			sample.get((i << 10) + 354) + sample.get((i << 10) + 355) +
			sample.get((i << 10) + 356) + sample.get((i << 10) + 357) +
			sample.get((i << 10) + 358) + sample.get((i << 10) + 359) +
			sample.get((i << 10) + 360) + sample.get((i << 10) + 361) +
			sample.get((i << 10) + 362) + sample.get((i << 10) + 363) +
			sample.get((i << 10) + 364) + sample.get((i << 10) + 365) +
			sample.get((i << 10) + 366) + sample.get((i << 10) + 367) +
			sample.get((i << 10) + 368) + sample.get((i << 10) + 369) +
			sample.get((i << 10) + 370) + sample.get((i << 10) + 371) +
			sample.get((i << 10) + 372) + sample.get((i << 10) + 373) +
			sample.get((i << 10) + 374) + sample.get((i << 10) + 375) +
			sample.get((i << 10) + 376) + sample.get((i << 10) + 377) +
			sample.get((i << 10) + 378) + sample.get((i << 10) + 379) +
			sample.get((i << 10) + 380) + sample.get((i << 10) + 381) +
			sample.get((i << 10) + 382) + sample.get((i << 10) + 383) +
			sample.get((i << 10) + 384) + sample.get((i << 10) + 385) +
			sample.get((i << 10) + 386) + sample.get((i << 10) + 387) +
			sample.get((i << 10) + 388) + sample.get((i << 10) + 389) +
			sample.get((i << 10) + 390) + sample.get((i << 10) + 391) +
			sample.get((i << 10) + 392) + sample.get((i << 10) + 393) +
			sample.get((i << 10) + 394) + sample.get((i << 10) + 395) +
			sample.get((i << 10) + 396) + sample.get((i << 10) + 397) +
			sample.get((i << 10) + 398) + sample.get((i << 10) + 399) +
			sample.get((i << 10) + 400) + sample.get((i << 10) + 401) +
			sample.get((i << 10) + 402) + sample.get((i << 10) + 403) +
			sample.get((i << 10) + 404) + sample.get((i << 10) + 405) +
			sample.get((i << 10) + 406) + sample.get((i << 10) + 407) +
			sample.get((i << 10) + 408) + sample.get((i << 10) + 409) +
			sample.get((i << 10) + 410) + sample.get((i << 10) + 411) +
			sample.get((i << 10) + 412) + sample.get((i << 10) + 413) +
			sample.get((i << 10) + 414) + sample.get((i << 10) + 415) +
			sample.get((i << 10) + 416) + sample.get((i << 10) + 417) +
			sample.get((i << 10) + 418) + sample.get((i << 10) + 419) +
			sample.get((i << 10) + 420) + sample.get((i << 10) + 421) +
			sample.get((i << 10) + 422) + sample.get((i << 10) + 423) +
			sample.get((i << 10) + 424) + sample.get((i << 10) + 425) +
			sample.get((i << 10) + 426) + sample.get((i << 10) + 427) +
			sample.get((i << 10) + 428) + sample.get((i << 10) + 429) +
			sample.get((i << 10) + 430) + sample.get((i << 10) + 431) +
			sample.get((i << 10) + 432) + sample.get((i << 10) + 433) +
			sample.get((i << 10) + 434) + sample.get((i << 10) + 435) +
			sample.get((i << 10) + 436) + sample.get((i << 10) + 437) +
			sample.get((i << 10) + 438) + sample.get((i << 10) + 439) +
			sample.get((i << 10) + 440) + sample.get((i << 10) + 441) +
			sample.get((i << 10) + 442) + sample.get((i << 10) + 443) +
			sample.get((i << 10) + 444) + sample.get((i << 10) + 445) +
			sample.get((i << 10) + 446) + sample.get((i << 10) + 447) +
			sample.get((i << 10) + 448) + sample.get((i << 10) + 449) +
			sample.get((i << 10) + 450) + sample.get((i << 10) + 451) +
			sample.get((i << 10) + 452) + sample.get((i << 10) + 453) +
			sample.get((i << 10) + 454) + sample.get((i << 10) + 455) +
			sample.get((i << 10) + 456) + sample.get((i << 10) + 457) +
			sample.get((i << 10) + 458) + sample.get((i << 10) + 459) +
			sample.get((i << 10) + 460) + sample.get((i << 10) + 461) +
			sample.get((i << 10) + 462) + sample.get((i << 10) + 463) +
			sample.get((i << 10) + 464) + sample.get((i << 10) + 465) +
			sample.get((i << 10) + 466) + sample.get((i << 10) + 467) +
			sample.get((i << 10) + 468) + sample.get((i << 10) + 469) +
			sample.get((i << 10) + 470) + sample.get((i << 10) + 471) +
			sample.get((i << 10) + 472) + sample.get((i << 10) + 473) +
			sample.get((i << 10) + 474) + sample.get((i << 10) + 475) +
			sample.get((i << 10) + 476) + sample.get((i << 10) + 477) +
			sample.get((i << 10) + 478) + sample.get((i << 10) + 479) +
			sample.get((i << 10) + 480) + sample.get((i << 10) + 481) +
			sample.get((i << 10) + 482) + sample.get((i << 10) + 483) +
			sample.get((i << 10) + 484) + sample.get((i << 10) + 485) +
			sample.get((i << 10) + 486) + sample.get((i << 10) + 487) +
			sample.get((i << 10) + 488) + sample.get((i << 10) + 489) +
			sample.get((i << 10) + 490) + sample.get((i << 10) + 491) +
			sample.get((i << 10) + 492) + sample.get((i << 10) + 493) +
			sample.get((i << 10) + 494) + sample.get((i << 10) + 495) +
			sample.get((i << 10) + 496) + sample.get((i << 10) + 497) +
			sample.get((i << 10) + 498) + sample.get((i << 10) + 499) +
			sample.get((i << 10) + 500) + sample.get((i << 10) + 501) +
			sample.get((i << 10) + 502) + sample.get((i << 10) + 503) +
			sample.get((i << 10) + 504) + sample.get((i << 10) + 505) +
			sample.get((i << 10) + 506) + sample.get((i << 10) + 507) +
			sample.get((i << 10) + 508) + sample.get((i << 10) + 509) +
			sample.get((i << 10) + 510) + sample.get((i << 10) + 511) +
			sample.get((i << 10) + 512) + sample.get((i << 10) + 513) +
			sample.get((i << 10) + 514) + sample.get((i << 10) + 515) +
			sample.get((i << 10) + 516) + sample.get((i << 10) + 517) +
			sample.get((i << 10) + 518) + sample.get((i << 10) + 519) +
			sample.get((i << 10) + 520) + sample.get((i << 10) + 521) +
			sample.get((i << 10) + 522) + sample.get((i << 10) + 523) +
			sample.get((i << 10) + 524) + sample.get((i << 10) + 525) +
			sample.get((i << 10) + 526) + sample.get((i << 10) + 527) +
			sample.get((i << 10) + 528) + sample.get((i << 10) + 529) +
			sample.get((i << 10) + 530) + sample.get((i << 10) + 531) +
			sample.get((i << 10) + 532) + sample.get((i << 10) + 533) +
			sample.get((i << 10) + 534) + sample.get((i << 10) + 535) +
			sample.get((i << 10) + 536) + sample.get((i << 10) + 537) +
			sample.get((i << 10) + 538) + sample.get((i << 10) + 539) +
			sample.get((i << 10) + 540) + sample.get((i << 10) + 541) +
			sample.get((i << 10) + 542) + sample.get((i << 10) + 543) +
			sample.get((i << 10) + 544) + sample.get((i << 10) + 545) +
			sample.get((i << 10) + 546) + sample.get((i << 10) + 547) +
			sample.get((i << 10) + 548) + sample.get((i << 10) + 549) +
			sample.get((i << 10) + 550) + sample.get((i << 10) + 551) +
			sample.get((i << 10) + 552) + sample.get((i << 10) + 553) +
			sample.get((i << 10) + 554) + sample.get((i << 10) + 555) +
			sample.get((i << 10) + 556) + sample.get((i << 10) + 557) +
			sample.get((i << 10) + 558) + sample.get((i << 10) + 559) +
			sample.get((i << 10) + 560) + sample.get((i << 10) + 561) +
			sample.get((i << 10) + 562) + sample.get((i << 10) + 563) +
			sample.get((i << 10) + 564) + sample.get((i << 10) + 565) +
			sample.get((i << 10) + 566) + sample.get((i << 10) + 567) +
			sample.get((i << 10) + 568) + sample.get((i << 10) + 569) +
			sample.get((i << 10) + 570) + sample.get((i << 10) + 571) +
			sample.get((i << 10) + 572) + sample.get((i << 10) + 573) +
			sample.get((i << 10) + 574) + sample.get((i << 10) + 575) +
			sample.get((i << 10) + 576) + sample.get((i << 10) + 577) +
			sample.get((i << 10) + 578) + sample.get((i << 10) + 579) +
			sample.get((i << 10) + 580) + sample.get((i << 10) + 581) +
			sample.get((i << 10) + 582) + sample.get((i << 10) + 583) +
			sample.get((i << 10) + 584) + sample.get((i << 10) + 585) +
			sample.get((i << 10) + 586) + sample.get((i << 10) + 587) +
			sample.get((i << 10) + 588) + sample.get((i << 10) + 589) +
			sample.get((i << 10) + 590) + sample.get((i << 10) + 591) +
			sample.get((i << 10) + 592) + sample.get((i << 10) + 593) +
			sample.get((i << 10) + 594) + sample.get((i << 10) + 595) +
			sample.get((i << 10) + 596) + sample.get((i << 10) + 597) +
			sample.get((i << 10) + 598) + sample.get((i << 10) + 599) +
			sample.get((i << 10) + 600) + sample.get((i << 10) + 601) +
			sample.get((i << 10) + 602) + sample.get((i << 10) + 603) +
			sample.get((i << 10) + 604) + sample.get((i << 10) + 605) +
			sample.get((i << 10) + 606) + sample.get((i << 10) + 607) +
			sample.get((i << 10) + 608) + sample.get((i << 10) + 609) +
			sample.get((i << 10) + 610) + sample.get((i << 10) + 611) +
			sample.get((i << 10) + 612) + sample.get((i << 10) + 613) +
			sample.get((i << 10) + 614) + sample.get((i << 10) + 615) +
			sample.get((i << 10) + 616) + sample.get((i << 10) + 617) +
			sample.get((i << 10) + 618) + sample.get((i << 10) + 619) +
			sample.get((i << 10) + 620) + sample.get((i << 10) + 621) +
			sample.get((i << 10) + 622) + sample.get((i << 10) + 623) +
			sample.get((i << 10) + 624) + sample.get((i << 10) + 625) +
			sample.get((i << 10) + 626) + sample.get((i << 10) + 627) +
			sample.get((i << 10) + 628) + sample.get((i << 10) + 629) +
			sample.get((i << 10) + 630) + sample.get((i << 10) + 631) +
			sample.get((i << 10) + 632) + sample.get((i << 10) + 633) +
			sample.get((i << 10) + 634) + sample.get((i << 10) + 635) +
			sample.get((i << 10) + 636) + sample.get((i << 10) + 637) +
			sample.get((i << 10) + 638) + sample.get((i << 10) + 639) +
			sample.get((i << 10) + 640) + sample.get((i << 10) + 641) +
			sample.get((i << 10) + 642) + sample.get((i << 10) + 643) +
			sample.get((i << 10) + 644) + sample.get((i << 10) + 645) +
			sample.get((i << 10) + 646) + sample.get((i << 10) + 647) +
			sample.get((i << 10) + 648) + sample.get((i << 10) + 649) +
			sample.get((i << 10) + 650) + sample.get((i << 10) + 651) +
			sample.get((i << 10) + 652) + sample.get((i << 10) + 653) +
			sample.get((i << 10) + 654) + sample.get((i << 10) + 655) +
			sample.get((i << 10) + 656) + sample.get((i << 10) + 657) +
			sample.get((i << 10) + 658) + sample.get((i << 10) + 659) +
			sample.get((i << 10) + 660) + sample.get((i << 10) + 661) +
			sample.get((i << 10) + 662) + sample.get((i << 10) + 663) +
			sample.get((i << 10) + 664) + sample.get((i << 10) + 665) +
			sample.get((i << 10) + 666) + sample.get((i << 10) + 667) +
			sample.get((i << 10) + 668) + sample.get((i << 10) + 669) +
			sample.get((i << 10) + 670) + sample.get((i << 10) + 671) +
			sample.get((i << 10) + 672) + sample.get((i << 10) + 673) +
			sample.get((i << 10) + 674) + sample.get((i << 10) + 675) +
			sample.get((i << 10) + 676) + sample.get((i << 10) + 677) +
			sample.get((i << 10) + 678) + sample.get((i << 10) + 679) +
			sample.get((i << 10) + 680) + sample.get((i << 10) + 681) +
			sample.get((i << 10) + 682) + sample.get((i << 10) + 683) +
			sample.get((i << 10) + 684) + sample.get((i << 10) + 685) +
			sample.get((i << 10) + 686) + sample.get((i << 10) + 687) +
			sample.get((i << 10) + 688) + sample.get((i << 10) + 689) +
			sample.get((i << 10) + 690) + sample.get((i << 10) + 691) +
			sample.get((i << 10) + 692) + sample.get((i << 10) + 693) +
			sample.get((i << 10) + 694) + sample.get((i << 10) + 695) +
			sample.get((i << 10) + 696) + sample.get((i << 10) + 697) +
			sample.get((i << 10) + 698) + sample.get((i << 10) + 699) +
			sample.get((i << 10) + 700) + sample.get((i << 10) + 701) +
			sample.get((i << 10) + 702) + sample.get((i << 10) + 703) +
			sample.get((i << 10) + 704) + sample.get((i << 10) + 705) +
			sample.get((i << 10) + 706) + sample.get((i << 10) + 707) +
			sample.get((i << 10) + 708) + sample.get((i << 10) + 709) +
			sample.get((i << 10) + 710) + sample.get((i << 10) + 711) +
			sample.get((i << 10) + 712) + sample.get((i << 10) + 713) +
			sample.get((i << 10) + 714) + sample.get((i << 10) + 715) +
			sample.get((i << 10) + 716) + sample.get((i << 10) + 717) +
			sample.get((i << 10) + 718) + sample.get((i << 10) + 719) +
			sample.get((i << 10) + 720) + sample.get((i << 10) + 721) +
			sample.get((i << 10) + 722) + sample.get((i << 10) + 723) +
			sample.get((i << 10) + 724) + sample.get((i << 10) + 725) +
			sample.get((i << 10) + 726) + sample.get((i << 10) + 727) +
			sample.get((i << 10) + 728) + sample.get((i << 10) + 729) +
			sample.get((i << 10) + 730) + sample.get((i << 10) + 731) +
			sample.get((i << 10) + 732) + sample.get((i << 10) + 733) +
			sample.get((i << 10) + 734) + sample.get((i << 10) + 735) +
			sample.get((i << 10) + 736) + sample.get((i << 10) + 737) +
			sample.get((i << 10) + 738) + sample.get((i << 10) + 739) +
			sample.get((i << 10) + 740) + sample.get((i << 10) + 741) +
			sample.get((i << 10) + 742) + sample.get((i << 10) + 743) +
			sample.get((i << 10) + 744) + sample.get((i << 10) + 745) +
			sample.get((i << 10) + 746) + sample.get((i << 10) + 747) +
			sample.get((i << 10) + 748) + sample.get((i << 10) + 749) +
			sample.get((i << 10) + 750) + sample.get((i << 10) + 751) +
			sample.get((i << 10) + 752) + sample.get((i << 10) + 753) +
			sample.get((i << 10) + 754) + sample.get((i << 10) + 755) +
			sample.get((i << 10) + 756) + sample.get((i << 10) + 757) +
			sample.get((i << 10) + 758) + sample.get((i << 10) + 759) +
			sample.get((i << 10) + 760) + sample.get((i << 10) + 761) +
			sample.get((i << 10) + 762) + sample.get((i << 10) + 763) +
			sample.get((i << 10) + 764) + sample.get((i << 10) + 765) +
			sample.get((i << 10) + 766) + sample.get((i << 10) + 767) +
			sample.get((i << 10) + 768) + sample.get((i << 10) + 769) +
			sample.get((i << 10) + 770) + sample.get((i << 10) + 771) +
			sample.get((i << 10) + 772) + sample.get((i << 10) + 773) +
			sample.get((i << 10) + 774) + sample.get((i << 10) + 775) +
			sample.get((i << 10) + 776) + sample.get((i << 10) + 777) +
			sample.get((i << 10) + 778) + sample.get((i << 10) + 779) +
			sample.get((i << 10) + 780) + sample.get((i << 10) + 781) +
			sample.get((i << 10) + 782) + sample.get((i << 10) + 783) +
			sample.get((i << 10) + 784) + sample.get((i << 10) + 785) +
			sample.get((i << 10) + 786) + sample.get((i << 10) + 787) +
			sample.get((i << 10) + 788) + sample.get((i << 10) + 789) +
			sample.get((i << 10) + 790) + sample.get((i << 10) + 791) +
			sample.get((i << 10) + 792) + sample.get((i << 10) + 793) +
			sample.get((i << 10) + 794) + sample.get((i << 10) + 795) +
			sample.get((i << 10) + 796) + sample.get((i << 10) + 797) +
			sample.get((i << 10) + 798) + sample.get((i << 10) + 799) +
			sample.get((i << 10) + 800) + sample.get((i << 10) + 801) +
			sample.get((i << 10) + 802) + sample.get((i << 10) + 803) +
			sample.get((i << 10) + 804) + sample.get((i << 10) + 805) +
			sample.get((i << 10) + 806) + sample.get((i << 10) + 807) +
			sample.get((i << 10) + 808) + sample.get((i << 10) + 809) +
			sample.get((i << 10) + 810) + sample.get((i << 10) + 811) +
			sample.get((i << 10) + 812) + sample.get((i << 10) + 813) +
			sample.get((i << 10) + 814) + sample.get((i << 10) + 815) +
			sample.get((i << 10) + 816) + sample.get((i << 10) + 817) +
			sample.get((i << 10) + 818) + sample.get((i << 10) + 819) +
			sample.get((i << 10) + 820) + sample.get((i << 10) + 821) +
			sample.get((i << 10) + 822) + sample.get((i << 10) + 823) +
			sample.get((i << 10) + 824) + sample.get((i << 10) + 825) +
			sample.get((i << 10) + 826) + sample.get((i << 10) + 827) +
			sample.get((i << 10) + 828) + sample.get((i << 10) + 829) +
			sample.get((i << 10) + 830) + sample.get((i << 10) + 831) +
			sample.get((i << 10) + 832) + sample.get((i << 10) + 833) +
			sample.get((i << 10) + 834) + sample.get((i << 10) + 835) +
			sample.get((i << 10) + 836) + sample.get((i << 10) + 837) +
			sample.get((i << 10) + 838) + sample.get((i << 10) + 839) +
			sample.get((i << 10) + 840) + sample.get((i << 10) + 841) +
			sample.get((i << 10) + 842) + sample.get((i << 10) + 843) +
			sample.get((i << 10) + 844) + sample.get((i << 10) + 845) +
			sample.get((i << 10) + 846) + sample.get((i << 10) + 847) +
			sample.get((i << 10) + 848) + sample.get((i << 10) + 849) +
			sample.get((i << 10) + 850) + sample.get((i << 10) + 851) +
			sample.get((i << 10) + 852) + sample.get((i << 10) + 853) +
			sample.get((i << 10) + 854) + sample.get((i << 10) + 855) +
			sample.get((i << 10) + 856) + sample.get((i << 10) + 857) +
			sample.get((i << 10) + 858) + sample.get((i << 10) + 859) +
			sample.get((i << 10) + 860) + sample.get((i << 10) + 861) +
			sample.get((i << 10) + 862) + sample.get((i << 10) + 863) +
			sample.get((i << 10) + 864) + sample.get((i << 10) + 865) +
			sample.get((i << 10) + 866) + sample.get((i << 10) + 867) +
			sample.get((i << 10) + 868) + sample.get((i << 10) + 869) +
			sample.get((i << 10) + 870) + sample.get((i << 10) + 871) +
			sample.get((i << 10) + 872) + sample.get((i << 10) + 873) +
			sample.get((i << 10) + 874) + sample.get((i << 10) + 875) +
			sample.get((i << 10) + 876) + sample.get((i << 10) + 877) +
			sample.get((i << 10) + 878) + sample.get((i << 10) + 879) +
			sample.get((i << 10) + 880) + sample.get((i << 10) + 881) +
			sample.get((i << 10) + 882) + sample.get((i << 10) + 883) +
			sample.get((i << 10) + 884) + sample.get((i << 10) + 885) +
			sample.get((i << 10) + 886) + sample.get((i << 10) + 887) +
			sample.get((i << 10) + 888) + sample.get((i << 10) + 889) +
			sample.get((i << 10) + 890) + sample.get((i << 10) + 891) +
			sample.get((i << 10) + 892) + sample.get((i << 10) + 893) +
			sample.get((i << 10) + 894) + sample.get((i << 10) + 895) +
			sample.get((i << 10) + 896) + sample.get((i << 10) + 897) +
			sample.get((i << 10) + 898) + sample.get((i << 10) + 899) +
			sample.get((i << 10) + 900) + sample.get((i << 10) + 901) +
			sample.get((i << 10) + 902) + sample.get((i << 10) + 903) +
			sample.get((i << 10) + 904) + sample.get((i << 10) + 905) +
			sample.get((i << 10) + 906) + sample.get((i << 10) + 907) +
			sample.get((i << 10) + 908) + sample.get((i << 10) + 909) +
			sample.get((i << 10) + 910) + sample.get((i << 10) + 911) +
			sample.get((i << 10) + 912) + sample.get((i << 10) + 913) +
			sample.get((i << 10) + 914) + sample.get((i << 10) + 915) +
			sample.get((i << 10) + 916) + sample.get((i << 10) + 917) +
			sample.get((i << 10) + 918) + sample.get((i << 10) + 919) +
			sample.get((i << 10) + 920) + sample.get((i << 10) + 921) +
			sample.get((i << 10) + 922) + sample.get((i << 10) + 923) +
			sample.get((i << 10) + 924) + sample.get((i << 10) + 925) +
			sample.get((i << 10) + 926) + sample.get((i << 10) + 927) +
			sample.get((i << 10) + 928) + sample.get((i << 10) + 929) +
			sample.get((i << 10) + 930) + sample.get((i << 10) + 931) +
			sample.get((i << 10) + 932) + sample.get((i << 10) + 933) +
			sample.get((i << 10) + 934) + sample.get((i << 10) + 935) +
			sample.get((i << 10) + 936) + sample.get((i << 10) + 937) +
			sample.get((i << 10) + 938) + sample.get((i << 10) + 939) +
			sample.get((i << 10) + 940) + sample.get((i << 10) + 941) +
			sample.get((i << 10) + 942) + sample.get((i << 10) + 943) +
			sample.get((i << 10) + 944) + sample.get((i << 10) + 945) +
			sample.get((i << 10) + 946) + sample.get((i << 10) + 947) +
			sample.get((i << 10) + 948) + sample.get((i << 10) + 949) +
			sample.get((i << 10) + 950) + sample.get((i << 10) + 951) +
			sample.get((i << 10) + 952) + sample.get((i << 10) + 953) +
			sample.get((i << 10) + 954) + sample.get((i << 10) + 955) +
			sample.get((i << 10) + 956) + sample.get((i << 10) + 957) +
			sample.get((i << 10) + 958) + sample.get((i << 10) + 959) +
			sample.get((i << 10) + 960) + sample.get((i << 10) + 961) +
			sample.get((i << 10) + 962) + sample.get((i << 10) + 963) +
			sample.get((i << 10) + 964) + sample.get((i << 10) + 965) +
			sample.get((i << 10) + 966) + sample.get((i << 10) + 967) +
			sample.get((i << 10) + 968) + sample.get((i << 10) + 969) +
			sample.get((i << 10) + 970) + sample.get((i << 10) + 971) +
			sample.get((i << 10) + 972) + sample.get((i << 10) + 973) +
			sample.get((i << 10) + 974) + sample.get((i << 10) + 975) +
			sample.get((i << 10) + 976) + sample.get((i << 10) + 977) +
			sample.get((i << 10) + 978) + sample.get((i << 10) + 979) +
			sample.get((i << 10) + 980) + sample.get((i << 10) + 981) +
			sample.get((i << 10) + 982) + sample.get((i << 10) + 983) +
			sample.get((i << 10) + 984) + sample.get((i << 10) + 985) +
			sample.get((i << 10) + 986) + sample.get((i << 10) + 987) +
			sample.get((i << 10) + 988) + sample.get((i << 10) + 989) +
			sample.get((i << 10) + 990) + sample.get((i << 10) + 991) +
			sample.get((i << 10) + 992) + sample.get((i << 10) + 993) +
			sample.get((i << 10) + 994) + sample.get((i << 10) + 995) +
			sample.get((i << 10) + 996) + sample.get((i << 10) + 997) +
			sample.get((i << 10) + 998) + sample.get((i << 10) + 999) +
			sample.get((i << 10) + 1000) + sample.get((i << 10) + 1001) +
			sample.get((i << 10) + 1002) + sample.get((i << 10) + 1003) +
			sample.get((i << 10) + 1004) + sample.get((i << 10) + 1005) +
			sample.get((i << 10) + 1006) + sample.get((i << 10) + 1007) +
			sample.get((i << 10) + 1008) + sample.get((i << 10) + 1009) +
			sample.get((i << 10) + 1010) + sample.get((i << 10) + 1011) +
			sample.get((i << 10) + 1012) + sample.get((i << 10) + 1013) +
			sample.get((i << 10) + 1014) + sample.get((i << 10) + 1015) +
			sample.get((i << 10) + 1016) + sample.get((i << 10) + 1017) +
			sample.get((i << 10) + 1018) + sample.get((i << 10) + 1019) +
			sample.get((i << 10) + 1020) + sample.get((i << 10) + 1021) +
			sample.get((i << 10) + 1022) + sample.get((i << 10) + 1023))
				*0.0009765625);
		}
		return out;
	}
	
	public static function mipMap(raw : RawSample, times : Int): RawSample
	{
		var result_l : FastFloatBuffer = null;
		var result_r : FastFloatBuffer = null;
		if (times == 1)
		{
			result_l = raw.sample_left;
			result_r = raw.sample_right;
		}
		else if (times == 2)
		{
			result_l = _mip2(raw.sample_left);
			if (raw.sample_left == raw.sample_right)
				result_r = result_l;
			else result_r = _mip2(raw.sample_right);
		}
		else if (times == 4)
		{
			result_l = _mip4(raw.sample_left);
			if (raw.sample_left == raw.sample_right)
				result_r = result_l;
			else result_r = _mip4(raw.sample_right);
		}
		else if (times == 8)
		{
			result_l = _mip8(raw.sample_left);
			if (raw.sample_left == raw.sample_right)
				result_r = result_l;
			else result_r = _mip8(raw.sample_right);
		}
		else if (times == 16)
		{
			result_l = _mip16(raw.sample_left);
			if (raw.sample_left == raw.sample_right)
				result_r = result_l;
			else result_r = _mip16(raw.sample_right);
		}
		else if (times == 32)
		{
			result_l = _mip32(raw.sample_left);
			if (raw.sample_left == raw.sample_right)
				result_r = result_l;
			else result_r = _mip32(raw.sample_right);
		}
		else if (times == 64)
		{
			result_l = _mip64(raw.sample_left);
			if (raw.sample_left == raw.sample_right)
				result_r = result_l;
			else result_r = _mip64(raw.sample_right);
		}
		else if (times == 128)
		{
			result_l = _mip128(raw.sample_left);
			if (raw.sample_left == raw.sample_right)
				result_r = result_l;
			else result_r = _mip128(raw.sample_right);
		}
		else if (times == 256)
		{
			result_l = _mip256(raw.sample_left);
			if (raw.sample_left == raw.sample_right)
				result_r = result_l;
			else result_r = _mip256(raw.sample_right);
		}
		else if (times == 512)
		{
			result_l = _mip512(raw.sample_left);
			if (raw.sample_left == raw.sample_right)
				result_r = result_l;
			else result_r = _mip512(raw.sample_right);
		}
		else if (times == 1024)
		{
			result_l = _mip1024(raw.sample_left);
			if (raw.sample_left == raw.sample_right)
				result_r = result_l;
			else result_r = _mip1024(raw.sample_right);
		}
		return { sample_left:result_l, sample_right:result_r };
	}
	
	public static function ofWAVE(tuning : MIDITuning, wav : WAVE)
	{
		var wav_data = wav.data;
		
		var loop_type = SamplerSynth.ONE_SHOT;
		var midi_unity_note = 0;
		var midi_pitch_fraction = 0;
		var loop_start = 0;
		var loop_end = wav_data.length - 1;
		
		if (wav.header.smpl != null)
		{
			if (wav.header.smpl.loop_data!=null && wav.header.smpl.loop_data.length>0)
			{
				switch(wav.header.smpl.loop_data[0].type)
				{
					case 0: loop_type = SamplerSynth.LOOP_FORWARD;
					case 1: loop_type = SamplerSynth.LOOP_PINGPONG;
					case 2: loop_type = SamplerSynth.LOOP_BACKWARD;
				}
			}
			
			midi_unity_note = wav.header.smpl.midi_unity_note;
			midi_pitch_fraction = wav.header.smpl.midi_pitch_fraction;
			loop_start = wav.header.smpl.loop_data[0].start;
			loop_end = wav.header.smpl.loop_data[0].end;
			
		}
		var sample_left = FastFloatBuffer.fromVector(wav_data[0]);
		var sample_right = FastFloatBuffer.fromVector(wav_data[1]);
		var raw = { sample_left:sample_left, sample_right:sample_right};
		return new PatchGenerator(
			{
			sample: raw,
			mip_2: mipMap(raw, 2),
			mip_4: mipMap(raw, 4),
			mip_8: mipMap(raw, 8),
			mip_16: mipMap(raw, 16),
			mip_32: mipMap(raw, 32),
			mip_64: mipMap(raw, 64),
			mip_128: mipMap(raw, 128),
			mip_256: mipMap(raw, 256),
			mip_512: mipMap(raw, 512),
			mip_1024: mipMap(raw, 1024),
			stereo:false,
			pan:0.5,
			loop_mode:loop_type,
			loop_start:loop_start,
			loop_end:loop_end,
			sample_rate:wav.header.samplingRate,
			base_frequency:tuning.midiNoteToFrequency( midi_unity_note + midi_pitch_fraction/0xFFFFFFFF),
			envelopes:[{attack:[1.0],sustain:[1.0],release:[1.0],quantization:0,assigns:[AS_VOLUME_ADD]}],
			volume:1.0,
			lfos:[{frequency:6.,depth:0.5,delay:0.05,attack:0.05,assigns:[AS_PITCH_ADD]}],
			modulation_lfo:1.0,
			arpeggiation_rate:0.0,
			},
			function(settings, seq, ev) : Array<PatchEvent> { return [new PatchEvent(ev,settings)]; }
		);				
	}
	
	public static function defaultPatch() : SamplerPatch
	{
		var samples = new FastFloatBuffer(44100);
		for (n in 0...44100)
		{
			samples.set(n, Math.sin(n / 44100 * Math.PI * 2));
		}
		
		var loop_start = 0;
		var loop_end = samples.length-1;
		var raw = { sample_left:samples, sample_right:samples};
		return { 
				sample: raw,
				mip_2: mipMap(raw, 2),
				mip_4: mipMap(raw, 4),
				mip_8: mipMap(raw, 8),
				mip_16: mipMap(raw, 16),
				mip_32: mipMap(raw, 32),
				mip_64: mipMap(raw, 64),
				mip_128: mipMap(raw, 128),
				mip_256: mipMap(raw, 256),
				mip_512: mipMap(raw, 512),
				mip_1024: mipMap(raw, 1024),
				stereo:false,
				pan:0.5,
				volume:1.0,
				loop_mode:LOOP_FORWARD,
				loop_start:loop_start,
				loop_end:loop_end,
				sample_rate:44100,
				base_frequency:1.,
				envelopes:[{attack:[1.0],sustain:[1.0],release:[1.0],quantization:0,assigns:[AS_VOLUME_ADD]}],
				lfos:[{frequency:6.,depth:0.5,delay:0.05,attack:0.05,assigns:[AS_PITCH_ADD]}],
				modulation_lfo:1.0,
				arpeggiation_rate:0.0,
				}
				;
	}
	
	public function init(sequencer : Sequencer)
	{
		this.sequencer = sequencer;
		this.buffer = sequencer.buffer;
		this.followers = new Array();		
		interpolation_tolerance = 1.02 / sequencer.RATE_MULTIPLE;
	}
	
	public inline function pipeAdjustment(qty : Float, assigns : Array<Int>)
	{
		for (assign in assigns)
		{
			switch(assign)
			{
				case AS_PITCH_ADD: frame_pitch_adjust += qty;
				case AS_PITCH_MUL: frame_pitch_adjust *= qty;
				case AS_VOLUME_ADD: frame_vol_adjust += qty;
				case AS_VOLUME_MUL: frame_vol_adjust *= qty;
			}
		}
	}
	
	public inline function updateEnvelope(patch : SamplerPatch, channel : SequencerChannel, cur_follower : EventFollower)
	{
		var env_num = 0;
		for (env in cur_follower.env)
		{
			if (env.state < 3)
			{
				var patch_env = patch.envelopes[env_num];
				var env_val = env.getTable(patch_env)[env.ptr];
				if (patch_env.quantization != 0)
					env_val = (Math.round(env_val * patch_env.quantization) / patch_env.quantization);	
				pipeAdjustment(env_val, patch_env.assigns);
			}
			env_num++;
		}		
	}
	
	public inline function updateLFO(patch : SamplerPatch, channel : SequencerChannel, cur_follower : EventFollower)
	{
		var lfo_num = 0;
		for (n in patch.lfos)
		{
			var cycle_length = sequencer.secondsToFrames(1. / n.frequency);
			var delay_length = sequencer.secondsToFrames(n.delay);
			var attack_length = sequencer.secondsToFrames(n.attack);
			var modulation_amount = (lfo_num == 0 && patch.modulation_lfo > 0) ? 
				patch.modulation_lfo * channel.modulation : 1.0;
			var mpos = cur_follower.lfo_pos - delay_length;
			if (mpos > 0)
			{
				if (mpos > attack_length)
				{
					pipeAdjustment(Math.sin(2 * Math.PI * mpos / cycle_length) * n.depth * modulation_amount, n.assigns);
				}
				else // ramp up
				{
					pipeAdjustment(Math.sin(2 * Math.PI * mpos / cycle_length) * modulation_amount * 
						(n.depth * (mpos/attack_length)), n.assigns);
				}
			}
			lfo_num++;
		}
		cur_follower.lfo_pos += 1;
	}
	
	public function write()
	{	
		while (followers.length > 0 && followers[followers.length - 1].isOff()) followers.pop();
		if (followers.length < 1) { return false; }
		
		var cur_follower : EventFollower = followers[followers.length - 1];		
		var patch : SamplerPatch = cur_follower.patch_event.patch;
		if (patch.arpeggiation_rate>0.0)
		{
			var available = Lambda.array(Lambda.filter(followers, function(a) { return !a.isOff(); } ));
			cur_follower = available[Std.int(((arpeggio) % 1) * available.length)];
			patch = cur_follower.patch_event.patch;
			arpeggio += sequencer.secondsToFrames(1.0) / (patch.arpeggiation_rate);
		}
		
		progress_follower(cur_follower, true);
		
		for (other_follower in followers)
		{
			if (other_follower != cur_follower) // force silenced followers to progress
			{
				progress_follower(other_follower, false);
			}
		}
		
		return true;
	}
	
	public inline function progress_follower(cur_follower : EventFollower, ?write : Bool)
	{
		var cur_channel = sequencer.channels[cur_follower.patch_event.sequencer_event.channel];
		var patch : SamplerPatch = cur_follower.patch_event.patch;
		
		var pitch_bend = cur_channel.pitch_bend;
		var channel_volume = cur_channel.channel_volume;
		var pan = cur_channel.pan;
		
		var seq_event = cur_follower.patch_event.sequencer_event;
		
		frame_pitch_adjust = 0.;
		frame_vol_adjust = 0.;
		
		updateEnvelope(patch, cur_channel, cur_follower);
		updateLFO(patch, cur_channel, cur_follower);
		
		freq = seq_event.data.freq;
		
		var wl = Std.int(sequencer.waveLengthOfBentFrequency(freq, 
					pitch_bend + Std.int((frame_pitch_adjust * 8192 / sequencer.tuning.bend_semitones))));
		
		freq = sequencer.frequency(wl);
		
		velocity = seq_event.data.velocity / 128;
		
		if (!cur_follower.isOff())
		{
			
			if (cur_follower.env[0].state == RELEASE) // apply the release envelope on top of the release level
				frame_vol_adjust *= cur_follower.release_level;
			var curval = patch.volume * master_volume * channel_volume * cur_channel.velocityCurve(velocity) * 
				frame_vol_adjust;
			
			// get sample and volume data
			var pan_sum = MathTools.limit(0., 1., pan + 2 * (patch.pan - 0.5));
			var left = curval * Math.sin(pan_sum * 2);
			var right = curval * Math.cos(1. - pan_sum) * 2;
			
			var sample : RawSample = patch.sample;
			var loop_start = patch.loop_start;
			var loop_end = patch.loop_end;
			var sample_rate = patch.sample_rate;
			var base_frequency = patch.base_frequency;
			
			if (freq >= sample_rate * 1024)
			{
				sample = patch.mip_1024;
				loop_start *= 1024;
				loop_end *= 1024;
				sample_rate *= 1024;
				base_frequency *= 1024;
			}
			else if (freq >= sample_rate * 512)
			{
				sample = patch.mip_512;
				loop_start *= 512;
				loop_end *= 512;
				sample_rate *= 512;
				base_frequency *= 512;
			}
			else if (freq >= sample_rate * 256)
			{
				sample = patch.mip_256;
				loop_start *= 256;
				loop_end *= 256;
				sample_rate *= 256;
				base_frequency *= 256;
			}
			else if (freq >= sample_rate * 128)
			{
				sample = patch.mip_128;
				loop_start *= 128;
				loop_end *= 128;
				sample_rate *= 128;
				base_frequency *= 128;
			}
			else if (freq >= sample_rate * 64)
			{
				sample = patch.mip_64;
				loop_start *= 64;
				loop_end *= 64;
				sample_rate *= 64;
				base_frequency *= 64;
			}
			else if (freq >= sample_rate * 32)
			{
				sample = patch.mip_32;
				loop_start *= 32;
				loop_end *= 32;
				sample_rate *= 32;
				base_frequency *= 32;
			}
			else if (freq >= sample_rate * 16)
			{
				sample = patch.mip_16;
				loop_start *= 16;
				loop_end *= 16;
				sample_rate *= 16;
				base_frequency *= 16;
			}
			else if (freq >= sample_rate * 8)
			{
				sample = patch.mip_8;
				loop_start *= 8;
				loop_end *= 8;
				sample_rate *= 8;
				base_frequency *= 8;
			}
			else if (freq >= sample_rate * 4)
			{
				sample = patch.mip_4;
				loop_start *= 4;
				loop_end *= 4;
				sample_rate *= 4;
				base_frequency *= 4;
			}
			else if (freq >= sample_rate * 2)
			{
				sample = patch.mip_2;
				loop_start *= 2;
				loop_end *= 2;
				sample_rate *= 2;
				base_frequency *= 2;
			}
			
			var sample_left : FastFloatBuffer = sample.sample_left;
			var sample_right : FastFloatBuffer = sample.sample_right;
			if (!patch.stereo) sample_right = sample_left;
			
			// we are assuming the sample rate is the mono rate.
			
			var base_wl = sample_rate / base_frequency;
			if (wl < 1) wl = 1;
			var inc : Float = base_wl / wl;
			var sample_length : Int = sample.sample_left.length;
			var loop_len = (loop_end - loop_start)+1;
			
			var total_length = buffer.length >> 1;
			var total_inc : Float = inc * total_length;
			
			if (write)
			{
				// TODO: cleanup the function calls so I'm not passing in a gazillion useless arguments
				//		 actually implement all loop modes...
				
				var RESAMPLE_DROP = 0;
				var RESAMPLE_LIN = 1;
				var RESAMPLE_OPT = 3;
				var RESAMPLE_LIN_MONO = 4;
				var resample_type = RESAMPLE_DROP;
				if (inc != 1) 
				{
					if (sample_left == sample_right) 
						resample_type = RESAMPLE_LIN_MONO;
					else 
						resample_type = RESAMPLE_LIN;
				}
				switch(patch.loop_mode)
				{
					// LOOP - repeat loop until envelope reaches OFF
					case LOOP_FORWARD, LOOP_BACKWARD, LOOP_PINGPONG: 
						switch(resample_type)
						{
							case RESAMPLE_DROP: loopForward(copy_samples_drop, cur_follower, loop_end, loop_len, buffer, bufptr, inc, left, right,
								sample_left, sample_right, freq, total_length, sample_length);
							case RESAMPLE_LIN: loopForward(copy_samples_lin, cur_follower, loop_end, loop_len, buffer, bufptr, inc, left, right,
								sample_left, sample_right, freq, total_length, sample_length);
							case RESAMPLE_LIN_MONO: loopForward(copy_samples_lin_mono, cur_follower, loop_end, loop_len, buffer, bufptr, inc, left, right,
								sample_left, sample_right, freq, total_length, sample_length);
							case RESAMPLE_OPT: loopForward(copy_samples_opt2, cur_follower, loop_end, loop_len, buffer, bufptr, inc, left, right,
								sample_left, sample_right, freq, total_length, sample_length);
						}
					// SUSTAIN - loop until release, then play to the first of envelope OFF or sample endpoint
					case SUSTAIN_FORWARD, SUSTAIN_BACKWARD, SUSTAIN_PINGPONG:
						switch(resample_type)
						{
							case RESAMPLE_DROP: loopSustain(copy_samples_drop, cur_follower, loop_end, loop_len, buffer, bufptr, inc, left, right,
								sample_left, sample_right, freq, total_length, sample_length);
							case RESAMPLE_LIN: loopSustain(copy_samples_lin, cur_follower, loop_end, loop_len, buffer, bufptr, inc, left, right,
								sample_left, sample_right, freq, total_length, sample_length);
							case RESAMPLE_LIN_MONO: loopSustain(copy_samples_lin_mono, cur_follower, loop_end, loop_len, buffer, bufptr, inc, left, right,
								sample_left, sample_right, freq, total_length, sample_length);
							case RESAMPLE_OPT: loopSustain(copy_samples_opt2, cur_follower, loop_end, loop_len, buffer, bufptr, inc, left, right,
								sample_left, sample_right, freq, total_length, sample_length);
						}
					// ONE_SHOT - play until the sample endpoint, do not respect note off
					// NO_LOOP - play until the sample endpoint, cut on note off
					case ONE_SHOT, NO_LOOP:
						switch(resample_type)
						{
							case RESAMPLE_DROP: runUnlooped(copy_samples_drop, cur_follower, loop_end, loop_len, buffer, bufptr, inc, left, right,
								sample_left, sample_right, freq, total_length, sample_length);
							case RESAMPLE_LIN: runUnlooped(copy_samples_lin, cur_follower, loop_end, loop_len, buffer, bufptr, inc, left, right,
								sample_left, sample_right, freq, total_length, sample_length);
							case RESAMPLE_LIN_MONO: runUnlooped(copy_samples_lin_mono, cur_follower, loop_end, loop_len, buffer, bufptr, inc, left, right,
								sample_left, sample_right, freq, total_length, sample_length);
							case RESAMPLE_OPT: runUnlooped(copy_samples_opt2, cur_follower, loop_end, loop_len, buffer, bufptr, inc, left, right,
								sample_left, sample_right, freq, total_length, sample_length);
						}
				}		
			}
			else
			{
				cur_follower.pos += total_inc;
				if (cur_follower.pos > sample_length && (patch.loop_mode == ONE_SHOT || cur_follower.env[0].state == RELEASE))
					cur_follower.env[0].state = OFF;
			}
			
			// Envelope advancement. We judge the length of the note based on the master envelope.
			
			var ct = 0;
			for (e in cur_follower.env)
			{
				e.ptr++;
				if (ct == 0) // master envelope treatment
				{
					var master_env : Array<Float> = cur_follower.env[0].getTable(patch.envelopes[0]);
					var master_state = cur_follower.env[0].state;
					var master_ptr = cur_follower.env[0].ptr;
					
					if (master_state!=OFF && master_ptr >= master_env.length)
					{
						// advance to next state if not sustaining
						if (master_state != SUSTAIN || patch.loop_mode == ONE_SHOT || patch.loop_mode == NO_LOOP)
							{master_state += 1; if (master_state == SUSTAIN && 
								patch.envelopes[0].sustain.length < 1) master_state++; }
						else if (master_state == SUSTAIN) // encourage sustains to be retained
							cur_follower.patch_event.sequencer_event.priority += PRIORITY_RAMPUP;
						// allow one shots to play through, ignoring their envelope tail
						if (patch.loop_mode == ONE_SHOT && master_state == OFF && cur_follower.pos < sample_length)
						{
							master_state = RELEASE;
							master_ptr = patch.envelopes[0].release.length - 1;
						}
						else
							master_ptr = 0;
						cur_follower.env[0].state = master_state;
						cur_follower.env[0].ptr = master_ptr;
					}
					// set release level
					if (master_state < RELEASE)
					{
						cur_follower.release_level = frame_vol_adjust;
					}
					else
					{
						cur_follower.patch_event.sequencer_event.priority = 
							Std.int(cur_follower.patch_event.sequencer_event.priority * PRIORITY_RAMPDOWN);
					}
				}
				else // other envelopes are simple...
				{
					if (e.state!=OFF && e.state!=SUSTAIN && e.ptr >= e.getTable(patch.envelopes[ct]).length)
					{ 
						e.state++; e.ptr = 0; 
					}
				}
				ct++;
			}
			
		}
			
	}
	
	private inline function loopForward(copy_samples : CopySamples, cur_follower : EventFollower , loop_end:Int, loop_len, buffer, bufptr, inc, left, right,
		sample_left, sample_right, freq,total_length, sample_length)
	{
		var loop_start = loop_end - loop_len;
		if (cur_follower.pos>loop_end)
			cur_follower.pos = ((cur_follower.pos - loop_start) % loop_len) + loop_start;
		for (n in 0...total_length)
		{
			copy_samples(buffer, bufptr, cur_follower.pos, inc, left, right, sample_left, sample_right, freq,
				loop_start, loop_len, loop_end);
			cur_follower.pos += inc; if (cur_follower.pos >= loop_end) 
				cur_follower.pos = ((cur_follower.pos - loop_start) % loop_len)+loop_start;
			bufptr = (bufptr + 2) % buffer.length;
		}		
	}
	
	private inline function loopSustain(copy_samples : CopySamples, cur_follower: EventFollower, loop_end:Int, 
		loop_len, buffer, bufptr, inc, left, right,
		sample_left, sample_right, freq,total_length, sample_length)
	{
		var loop_start = loop_end - loop_len;
		if (cur_follower.env[0].state < RELEASE) 
		{
			if (cur_follower.pos>loop_end)
				cur_follower.pos = ((cur_follower.pos - loop_start) % loop_len)+loop_start;
			for (n in 0...total_length)
			{
				copy_samples(buffer, bufptr, cur_follower.pos, inc, left, right, sample_left, sample_right, freq,
					loop_start, loop_len, loop_end);
				cur_follower.pos += inc; if (cur_follower.pos >= loop_end) 
					cur_follower.pos = ((cur_follower.pos - loop_start) % loop_len)+loop_start;
				bufptr = (bufptr + 2) % buffer.length;
			}
		}
		else
		{
			for (n in 0...total_length)
			{
				copy_samples(buffer, bufptr, cur_follower.pos, inc, left, right, sample_left, sample_right, freq,
					loop_start, loop_len, loop_end);
				cur_follower.pos += inc;
				bufptr = (bufptr + 2) % buffer.length;
			}
		}
	}
	
	private inline function runUnlooped(copy_samples : CopySamples, cur_follower: EventFollower, loop_end:Int, loop_len, buffer, bufptr, inc, left, right,
		sample_left, sample_right, freq,total_length, sample_length)
	{
		var loop_start = loop_end - loop_len;
		for (n in 0...total_length)
		{
			copy_samples(buffer, bufptr, cur_follower.pos, inc, left, right, sample_left, sample_right, freq,
				loop_start, loop_len, loop_end);
			cur_follower.pos += inc;
			bufptr = (bufptr + 2) % buffer.length;
		}
		if (cur_follower.pos >= sample_length) { cur_follower.env[0].state = OFF; }		
	}
	
	public inline function copy_samples_drop(buffer : FastFloatBuffer, bufptr : Int, 
								pos : Float, inc : Float, 
								left : Float, right : Float, 
								sample_left : FastFloatBuffer, sample_right : FastFloatBuffer, freq : Float,
								loop_start : Float, loop_end : Float, loop_len : Float)
	{
		// Drop
		var a : Int = Std.int(Math.min(pos, sample_left.length - 1));
		buffer.set(bufptr, buffer.get(bufptr) + left * (sample_left.get(a)));
		buffer.set(bufptr + 1, buffer.get(bufptr+1) +  right * (sample_right.get(a)));
	}
	
	/*public inline function copy_samples_nearest(buffer : FastFloatBuffer, bufptr : Int, 
								pos : Float, inc : Float, 
								left : Float, right : Float, 
								sample_left : FastFloatBuffer, sample_right : FastFloatBuffer, freq : Float,
								loop_start : Float, loop_end : Float, loop_len : Float)
	{
		// Nearest
		var a : Int = Math.round(Math.min(pos + inc*0.5, sample_left.length - 1));
		buffer.set(bufptr, buffer.get(bufptr) + left * (sample_left.get(a)));
		buffer.set(bufptr + 1, buffer.get(bufptr + 1) + right * (sample_right.get(a)));
	}*/
	
	public inline function copy_samples_lin(buffer : FastFloatBuffer, bufptr : Int, 
								pos : Float, inc : Float, 
								left : Float, right : Float, 
								sample_left : FastFloatBuffer, sample_right : FastFloatBuffer, freq : Float,
								loop_start : Float, loop_end : Float, loop_len : Float)
	{
		// linear interpolator
		var ideal = Math.min(pos, sample_left.length - 1);
		var a : Int = Std.int(ideal);
		var b : Int = Std.int(Math.min(pos + 1, sample_left.length - 1));
		var interpolation_factor : Float = pos - a;
		buffer.set(bufptr, 
			buffer.get(bufptr) + left * (sample_left.get(a) * (1. -interpolation_factor) + 
				sample_left.get(b) * interpolation_factor));	
		buffer.set(bufptr + 1, 
			buffer.get(bufptr + 1) + right * (sample_right.get(a) * (1. -interpolation_factor) + 
				sample_right.get(b) * interpolation_factor));
	}

	public inline function copy_samples_lin_mono(buffer : FastFloatBuffer, bufptr : Int, 
								pos : Float, inc : Float, 
								left : Float, right : Float, 
								sample_left : FastFloatBuffer, sample_right : FastFloatBuffer, freq : Float,
								loop_start : Float, loop_end : Float, loop_len : Float)
	{
		// linear interpolator(mono sample)
		var ideal = Math.min(pos, sample_left.length - 1);
		var a : Int = Std.int(ideal);
		var b : Int = Std.int(Math.min(pos + 1, sample_left.length - 1));
		var interpolation_factor : Float = pos - a;
		var sd = (sample_left.get(a) * (1. -interpolation_factor) + 
				sample_left.get(b) * interpolation_factor);
		buffer.set(bufptr, buffer.get(bufptr) + left * sd);	
		buffer.set(bufptr + 1, buffer.get(bufptr + 1) + right * sd);
	}
	
	public inline function copy_samples_opt2(buffer : FastFloatBuffer, bufptr : Int, 
								pos : Float, inc : Float, 
								left : Float, right : Float, 
								sample_left : FastFloatBuffer, sample_right : FastFloatBuffer, freq : Float,
								loop_start : Float, loop_end : Float, loop_len : Float)
	{
		// optimal 2x - 4p 4o - experimental. Accurate pitches!!!
		// from http://www.student.oulu.fi/~oniemita/dsp/deip.pdf
		var ideal = Math.min(pos, sample_left.length - 1);
		pos = pos + inc * 0.5;
		if (pos > loop_end)
			pos = ((pos - loop_start) % loop_len) + loop_start;
		var ideal2 = Math.min(pos, sample_left.length - 1);
		
		// this is not correct - we need a real filter to cut the MASSIVE high-freq gain
		left *= 0.0000005;
		right *= 0.0000005;
		
		var x = ideal - Std.int(ideal);
		var z = x - 0.5;
		
		var ym1 = 0.;
		var y0 = sample_left.get(Std.int(ideal));
		var y1 = 0.;
		var y2 = sample_left.get(Std.int(ideal2));
		
		var even1 = y1+y0, odd1 = y1-y0;
		var even2 = y2+ym1, odd2 = y2-ym1;
		var c0 = even1*0.45645918406487612 + even2*0.04354173901996461;
		var c1 = odd1*0.47236675362442071 + odd2*0.17686613581136501;
		var c2 = even1*-0.253674794204558521 + even2*0.25371918651882464;
		var c3 = odd1*-0.37917091811631082 + odd2*0.11952965967158000;
		var c4 = even1 * 0.04252164479749607 + even2 * -0.04289144034653719;
		buffer.set(bufptr, buffer.get(bufptr) + (left * (((c4*z+c3)*z+c2)*z+c1)*z+c0));
		
		var ym1 = 0.;
		var y0 = sample_right.get(Std.int(ideal));
		var y1 = 0.;
		var y2 = sample_right.get(Std.int(ideal2));
		
		var even1 = y1+y0, odd1 = y1-y0;
		var even2 = y2+ym1, odd2 = y2-ym1;
		var c0 = even1*0.45645918406487612 + even2*0.04354173901996461;
		var c1 = odd1*0.47236675362442071 + odd2*0.17686613581136501;
		var c2 = even1*-0.253674794204558521 + even2*0.25371918651882464;
		var c3 = odd1*-0.37917091811631082 + odd2*0.11952965967158000;
		var c4 = even1 * 0.04252164479749607 + even2 * -0.04289144034653719;
		buffer.set(bufptr+1, buffer.get(bufptr+1) + (right * (((c4*z+c3)*z+c2)*z+c1)*z+c0));
	}
	
	public function event(patch_ev : PatchEvent, channel : SequencerChannel)
	{
		var ev = patch_ev.sequencer_event;
		switch(ev.type)
		{
			case SequencerEvent.NOTE_ON: 
				// as the channel adds more voices, the priority of its notes gets squashed.
				// doing this on note ons naturally favors squashing of repetitive drum hits and stacattos,
				// which have plenty of release tails, instead of held notes.
				followers.push(new EventFollower(patch_ev, patch_ev.patch.envelopes.length));
				for (f in channel.allocated)
				{
					patch_ev.sequencer_event.priority = Std.int((patch_ev.sequencer_event.priority * PRIORITY_VOICE));
				}
			case SequencerEvent.NOTE_OFF: 
				for (n in followers) 
				{ 
					if (n.patch_event.sequencer_event.id == ev.id)
					{
						n.setRelease();
					}
				}
		}
		
		for (n in followers) 
		{	
			if (n.patch_event.sequencer_event.channel == channel.id)
				return true; 
		}
		return false;
	}
	
	public function getEvents()
	{
		var result = new Array<SequencerEvent>();
		for ( n in followers )
		{
			result.push(n.patch_event.sequencer_event);
		}
		return result;
	}
	
	public function allOff()
	{
		while (followers.length>0) followers.pop();
	}
	
	public function allRelease()
	{
		for (f in followers) { f.setRelease(); }
	}
	
}
