package com.ludamix.triad.time;

import nme.events.Event;
import nme.Lib;

class EventQueue
{

	public function new(?frame_time_ms : Int = 250, ?stack_max : Int = 1024) 
	{ queue = new Array(); this.frame_time_ms = frame_time_ms; this.stack_max = stack_max; }

	public var queue : Array<Dynamic>;
	public var frame_time_ms : Int;
	public var inter_queue : Dynamic;
	public var stack_count : Int;
	public var stack_max : Int;

	public function add(func : Dynamic)
	{
		// uses closures to run all the events with a frame of gap.
		stack_count = 0;
		queue.push(function(time_start : Int) { 
			stack_count++;
			func(); 
			var time_end = Lib.getTimer();
			if (queue.length > 0)
			{
				if (time_end - time_start < frame_time_ms && stack_count<stack_max)
					queue.shift()(time_start);
				else
				{
					stack_count = 0;
					var inner_func : Dynamic = null;
					inner_func = function(_) {
						Lib.current.removeEventListener(Event.ENTER_FRAME, inner_func);
						queue.shift()(Lib.getTimer());
					};
					if (inter_queue!=null) inter_queue();
					Lib.current.addEventListener(Event.ENTER_FRAME, inner_func);
				}
			}
		});
	}
	
	public function start() { queue.shift()(Lib.getTimer()); }
	
}