package com.ludamix.triad.audio;

interface MIDITuning
{
	
	public var frequency : Array<Float>;
	public var notename : Array<String>;
	
	public function frequencyToMidiNote(frequency : Float) : Float; 
	public function midiNoteToFrequency(midiNote : Float) : Float;
	
}

class EvenTemperament implements MIDITuning
{
	
	// Tuning for even temperament mapped to the MIDI notes.
	// Middle C (octave 4) = 60
	
	public var frequency : Array<Float>;
	public var notename : Array<String>;	
	
	public function new()
	{
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
	
}
