package com.ludamix.triad.audio;
import com.ludamix.triad.audio.Interpolator;
import haxe.macro.Context;
import haxe.macro.Expr;

enum CopyLoopChannel { CLCMirror; CLCSplit; }
enum CopyLoopEnforcement { CLEIgnore; CLECut; CLELoop; }

enum CopyLoopAction 
{
	CLASampleRequest(decrement : Int, inner : Array<CopyLoopAction>);
	CLAGetPosition(num_input_vars : Int, channel_mode : CopyLoopChannel);
	CLARead(channel : CopyLoopChannel, times : Int, loop_enforce_mode : CopyLoopEnforcement);
	CLAIncrementPosition;
}

class CopyLoop
{

#if macro

	public static var var_names = ["a","b","c","d","e","f","g","h"];

	public static function parseLoopAction(act : CopyLoopAction, copy_functions : Array<String>) : String
	{
		switch act
		{
			case CLASampleRequest(decrement, inner):
				// Build a loop with the desired decrement count
				var opening = "";
				var closing = "}";
				var body = new Array<String>();
				if (decrement == 0) { opening = "for (n in 0...samples_requested) {"; }
				else { opening = "for (n in 0...samples_requested-"+Std.string(decrement) + ") {"; }
				for (i in inner)
				{
					body.push(parseLoopAction(i, copy_functions));
				}
				body.insert(0, opening);
				body.push(closing);
				return body.join("\n");
			case CLARead(channel, times, loop_enforce_mode):
				
				var st = "";
				
				var writeRead = function(smp : String)
				{
					// read the data into temp variables
					for (time in 0...times)
					{
						var advance = time < times - 1;
						st += var_names[time] + " = " + smp + ".read(); ";
						if (advance) 
						{
							st += smp + ".advancePlayheadUnbounded();";
						
							// loop enforcement
							switch loop_enforce_mode
							{
								case CLEIgnore:
								case CLECut:
									st += "if (" + smp + ".playhead > " + smp + ".length) " + smp +
										".playhead = Std.int("+smp+".length) - 1;";
								case CLELoop:
									st += "if (" + smp + ".playhead > " + smp + ".length) {" + smp +
										".playhead = Std.int("+smp+".length) - Std.int(loop_len);}";
							}
						}
						
						st += "\n";						
					}
				};
				var writeCopy = function(smp : String, volume_name : Array<String>)
				{
					// apply each copy function and add the result to the output buffer.
					
					var vars = new Array<String>();
					for (time in 0...times)
						vars.push(var_names[time]);
					if (times > 1)
						vars.push("x");
					
					var copystuff = "";
					for (fn in copy_functions) copystuff += fn + "(";
					copystuff += vars.join(", ");
					for (fn in copy_functions) copystuff += ")";
					
					if (volume_name.length > 1) // introduce an intermediate step so that we interp only once
					{
						if (copystuff!="a") // don't allow the assign to self case
							st += "a = " + copystuff+";\n";
						for (v in volume_name)						
							st += "buffer.add( a * " + v + "); buffer.advancePlayheadUnbounded();\n";
					}
					else // add directly.
					{
						st += "buffer.add(" + copystuff + " * " + volume_name[0] + "); ";
						st += "buffer.advancePlayheadUnbounded();\n";
					}
					
				}
				
				if (channel == CLCMirror) 
				{
					writeRead("sample_left");
					writeCopy("sample_left",["left","right"]);
				}
				else
				{
					writeRead("sample_left");
					writeCopy("sample_left",["left"]);
					writeRead("sample_right");
					writeCopy("sample_right",["right"]);
				}
				
				return st;
			case CLAGetPosition(num_input_vars, channel_mode):
				var _s = "sample_left.playhead = Std.int(pos);";
				if (num_input_vars > 1)
					_s += " x = pos - sample_left.playhead;";
				if (channel_mode==CLCSplit) _s+="sample_right.playhead = sample_left.playhead;";
				return _s;
			case CLAIncrementPosition:
				return "pos+=inc;";
		}
	}

	public static function _copyLoop(num_samples : Int, channel_behavior : String, copy_functions : Array<String>,
		endpoint_behavior : String) : Expr
	{
		
		var endpoint : CopyLoopEnforcement = CLECut;
		switch endpoint_behavior
		{
			case "cut": endpoint = CLECut;
			case "loop": endpoint = CLELoop;
			default: throw "endpoint behavior must be cut or loop";
		}
		var channel : CopyLoopChannel = CLCMirror;
		switch channel_behavior
		{
			case "mirror": channel = CLCMirror;
			case "split": channel = CLCSplit;
			default: throw "channel behavior must be mirror or split";
		}
		
		var cpos = Context.currentPos();
		
		var combi = new Array<String>();
		
		if (num_samples == 1)
		{
			for (n in [
					 CLASampleRequest(0, 
						[CLAGetPosition(num_samples, channel),
						CLARead(channel,1,CLEIgnore),
						CLAIncrementPosition]),
					])
			combi.push(parseLoopAction(n,copy_functions));
		}
		else if (num_samples == 2)
		{
			for (n in [
					 CLASampleRequest(1, 
						[CLAGetPosition(num_samples, channel),
						CLARead(channel,2,CLEIgnore),
						CLAIncrementPosition]),
						CLAGetPosition(num_samples, channel),
						CLARead(channel,2,endpoint),
						CLAIncrementPosition])
			combi.push(parseLoopAction(n,copy_functions));
		}
		else if (num_samples == 4)
		{
			for (n in [
					 CLASampleRequest(1, 
						[CLAGetPosition(num_samples, channel),
						CLARead(channel,4,CLEIgnore),
						CLAIncrementPosition]),
					CLAGetPosition(num_samples, channel),
					CLARead(channel,4,endpoint),
					CLAIncrementPosition])
			combi.push(parseLoopAction(n,copy_functions));
		}
		else throw "bad # of samples "+Std.string(num_samples);
		
		//trace(combi.join("\n")); Context.error("mooo", cpos); // for debugging		
		
		// finish by making a block with the var decls (which seem to be quite sensitive to context)
		var bk = new Array<Expr>();
		for (n in 0...num_samples) bk.push({expr:EVars([ { type:null, name:var_names[n], expr:
			{expr:EConst(Constant.CFloat("0.0")), pos:cpos }} ]), pos:cpos } );
		if (num_samples>1)
			bk.push({expr:EVars([ { type:null, name:"x", expr:
			{expr:EConst(Constant.CFloat("0.0")), pos:cpos }} ]), pos:cpos } );
		bk.push(Context.parse("{"+combi.join("\n")+"}", cpos));
		return { expr:EBlock(bk), pos:cpos };
	}	

#end
	
	@:macro public static function copyLoop(num_samples : Int, channel_behavior : String, copy_functions : Array<String>,
		endpoint_behavior : String) : Expr
	{
		return _copyLoop(num_samples, channel_behavior, copy_functions, endpoint_behavior);
	}

}