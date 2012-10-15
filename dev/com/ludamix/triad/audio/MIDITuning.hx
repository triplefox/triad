package com.ludamix.triad.audio;

interface MIDITuning
{
	
	public var frequency : Array<Float>;
	public var notename : Array<String>;
	public var bend_semitones : Int;
	
	public function frequencyToMidiNote(frequency : Float) : Float; 
	public function midiNoteToFrequency(midiNote : Float) : Float;
	public function midiNoteBentToFrequency(midiNote : Float, pitch_bend : Int) : Float;
	
}

class EvenTemperament implements MIDITuning
{
	
	// Tuning for even temperament mapped to the MIDI notes.
	// Middle C (octave 4) = 60
	
	public var frequency : Array<Float>;
	public var notename : Array<String>;	
	
	public var bend_semitones : Int;
	
	public static var cache = new EvenTemperament();
	
	public function new()
	{
		bend_semitones = 2;
		
		var octave : Int = -1;
		var semitone : Int = 0;
		
		var notes = ["C","C#","D","D#","E","F","F#","G","G#","A","A#","B"];
		
		frequency = new Array();
		notename = new Array();
		
		for (n in 0...127)
		{
			frequency.push(midiNoteToFrequency(n));
			
			var note = notes[semitone]+Std.string(octave);
			notename[n] = note;
			
			semitone++;
			if (semitone>=12)
			{
				octave++;
				semitone = 0;
			}
		}
	}

	public inline function frequencyToMidiNote(frequency : Float)
	{
		return 69 + 12*(Math.log(frequency/440.)/Math.log(2));		
	}

	public inline function midiNoteToFrequency(midiNote : Float)
	{
		return (Math.pow(2,(midiNote-69)/12)*440);
	}
	
	public inline function midiNoteBentToFrequency(midiNote : Float, pitch_bend : Int) : Float
	{
		return midiNoteToFrequency(midiNote+(pitch_bend)/8192*bend_semitones);
	}
	
}
