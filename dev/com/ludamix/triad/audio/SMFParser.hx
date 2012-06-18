package com.ludamix.triad.audio;

import haxe.io.Bytes;
import haxe.io.BytesInput;
import haxe.io.Input;
import nme.utils.ByteArray;
import haxe.Timer;
import com.ludamix.triad.audio.Sequencer;
import com.ludamix.triad.format.SMF;

/* TODO: Understand more events.
   TODO: Make a streamable MIDI implementation? Main reason to do so is for more dynamic tracks.
 */

class SMFParser
{
	
	// SMF parser based in part upon the code in SiON, as well as a variety of online tutorials and references.
	// Should read type 0 and type 1 SMF.
	
	// This is, at present, not a streaming parser. 
	// It reads the SMF as one batch and translates it to Triad sequencer events directly.
	
	// Example in https://github.com/triplefox/triad/blob/master/examples/Source/SynthTest.hx
	
	public static function load(sequencer : Sequencer, bytes:ByteArray, ?remove_intro=true) : Array<SequencerEvent>
	{
		
		var parser = new SMFParser(sequencer, bytes);
		
		return parser.run(remove_intro);
		
	}
	
	public function new(sequencer, ?bytes) 
		{ this.sequencer = sequencer;  this.bytes = bytes; }

	public var smf : SMF;
	
	public var events:Array<SequencerEvent>;
	public var bytes : ByteArray;
	public var sequencer : Sequencer;

	public var note_uniques : IntHash<Int>;
	public var id_count : Int;
	public var errors : Array<String>;
	
	public function run(remove_intro : Bool)
	{
		
		errors = new Array();
		
		// Read SMF headers and track chunks.
		
		bytes.position = 0;
		smf = SMF.read(bytes);
		
		events = new Array();
		
		// Set up note uniqueness table. Doing this allows multiple ons and offs overlapping on the same note
		// (A situation which is common when long releases are present)
		
		note_uniques = new IntHash();
		id_count = 0;
		for ( n in 0...128 )
		{
			for (c in 0...16)
			{
				note_uniques.set(n + (c << 16 ), id_count);
				id_count++;
			}
		}		
		
		// now we use the tick delta timings and tempo mapping to convert into sequencer frames, and
		// do the final filtering.
		
		for (track in smf.tracks)
		{
			var tempos_future = smf.tempos.copy();
			if (tempos_future.length == 0) // uh oh...fill in a default
				{tempos_future = [ { tick:0, tempo:120 * 60000000, bpm:120.0 } ]; errors.push("no tempo found");}
			var tempos_past = new Array<{tick:Int,tempo:Int,bpm:Float}>();
			var ticks = 0;
			var frames = 0.;
			var res_multiplier = 1 / smf.resolution;
			var highest_event_frame = -1.;
			tempos_past.push(tempos_future.shift());
			for (n in track)
			{
				
				var tick_delta = n.tick;
				
				while (tempos_future.length > 0 && (ticks+tick_delta) > tempos_future[0].tick)
				{
					// rewrite the tick delta as we traverse over any number of tempos
					var lt = tempos_past[tempos_past.length - 1];
					tempos_past.push(tempos_future.shift());
					var ct = tempos_past[tempos_past.length - 1];
					tick_delta = ticks + tick_delta - ct.tick;
					frames += (ct.tick - ticks) * sequencer.BPMToFrames(res_multiplier, lt.bpm);
					ticks = ct.tick;
					events.push(new SequencerEvent(SequencerEvent.SET_BPM, ct.bpm, 0, 0, frames, 0));
				}
				
				ticks += tick_delta;
				frames += tick_delta * sequencer.BPMToFrames(res_multiplier, tempos_past[tempos_past.length-1].bpm);
				
				var result = filter(n, ticks, frames, sequencer);
				if (result != null) 
				{
					if (frames > highest_event_frame) // insert at end
					{
						events.push(result);
						highest_event_frame = frames;
					}
					else // cheap heuristic to get it presorted
					{
						var cpos = Std.int(frames/highest_event_frame*events.length);
						if (cpos >= events.length) cpos = events.length - 1;
						if (frames > events[cpos].frame) {while (frames > events[cpos].frame) cpos--;}
						if (frames < events[cpos].frame) {while (frames < events[cpos].frame) cpos++;}
						events.insert(cpos, result);
					}
				}
				
			}
		}
		
		if (remove_intro) // most of the time, we have no reason to ever want a big delay at the start of the file.
		{
			if (events.length > 0)
			{
				var firstframe = events[0].frame;
				for (n in events) n.frame -= firstframe;
			}
		}
		
		return events;
		
	}
	
	public inline function filter(smf:SMFEvent, ticks : Int, frames : Float, 
		sequencer : Sequencer)
	{
		if (smf.type == SMF.NOTE_ON && smf.data.velocity == 0) // optimize - part of specced behavior
			smf.type = SMF.NOTE_OFF;
		
		switch(smf.type)
		{
			case SMF.NOTE_ON:
				var unique_calc = smf.data.note + (smf.channel << 16);
				var note_id = note_uniques.get(unique_calc);
				return (new SequencerEvent(SequencerEvent.NOTE_ON,
					{freq:sequencer.tuning.midiNoteToFrequency(smf.data.note),velocity:smf.data.velocity},
												smf.channel,
												note_id,
												frames,
												Std.int(frames)));
			case SMF.NOTE_OFF:
				var unique_calc = smf.data.note + (smf.channel << 16);
				var note_id = note_uniques.get(unique_calc);
				id_count++;
				note_uniques.set(unique_calc, id_count);
				return (new SequencerEvent(SequencerEvent.NOTE_OFF,
					{freq:sequencer.tuning.midiNoteToFrequency(smf.data.note),velocity:smf.data.velocity},
												smf.channel,
												note_id,
												frames,
												Std.int(frames)));
			case SMF.PITCH_BEND:
				return (new SequencerEvent(SequencerEvent.PITCH_BEND,
												smf.data - 8192,
												smf.channel,
												SequencerEvent.CHANNEL_EVENT,
												frames,
												-1));
			case SMF.PROGRAM_CHANGE:
				return (new SequencerEvent(SequencerEvent.SET_PATCH,
												smf.data,
												smf.channel,
												SequencerEvent.CHANNEL_EVENT,
												frames,
												-1));
			case SMF.CONTROL_CHANGE:
				switch(smf.data.controller)
				{
					case SMF.CC_VOLUME:
						return (new SequencerEvent(SequencerEvent.VOLUME,
														smf.data.value/128,
														smf.channel,
														SequencerEvent.CHANNEL_EVENT,
														frames,
														-1));			
					case SMF.CC_MODULATION:
						return (new SequencerEvent(SequencerEvent.MODULATION,
														smf.data.value/128,
														smf.channel,
														SequencerEvent.CHANNEL_EVENT,
														frames,
														-1));			
					case SMF.CC_PAN:
						return (new SequencerEvent(SequencerEvent.PAN,
														smf.data.value/128,
														smf.channel,
														SequencerEvent.CHANNEL_EVENT,
														frames,
														-1));
					case SMF.CC_BANK_SELECT_LSB: // we assume this is the same as program change...
						return (new SequencerEvent(SequencerEvent.SET_PATCH,
												smf.data,
												smf.channel,
												SequencerEvent.CHANNEL_EVENT,
												frames,
												-1));
					case SMF.CC_SUSTAIN_PEDAL:
						return (new SequencerEvent(SequencerEvent.SUSTAIN_PEDAL,
												smf.data,
												smf.channel,
												SequencerEvent.CHANNEL_EVENT,
												frames,
												-1));
					case SMF.CC_ALL_NOTES_OFF:
						return (new SequencerEvent(SequencerEvent.ALL_NOTES_OFF,
												smf.data,
												smf.channel,
												SequencerEvent.CHANNEL_EVENT,
												frames,
												-1));
					default:
						errors.push(["unimplemented cc", smf.data].join(" "));
						return null;
				}
			default:
				errors.push(["unimplemented", smf.type].join(" "));
				return null;
		}
	}
		
	
}
