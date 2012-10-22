package com.ludamix.triad.time;

import nme.events.Event;
import nme.Lib;

class EventQueue
{

	public function new(?frame_time_ms : Int = 250) { queue = new Array(); this.frame_time_ms = frame_time_ms; }

	public var queue : Array<Dynamic>;
	public var frame_time_ms : Int;
	public var inter_queue : Dynamic;

	public function add(func : Dynamic)
	{
		// uses closures to run all the events with a frame of gap.
		queue.push(function(time_start : Int) { 
			func(); 
			var time_end = Lib.getTimer();
			if (queue.length > 0)
			{
				if (time_end - time_start < frame_time_ms)
					queue.shift()(time_start);
				else
				{
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