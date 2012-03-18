package com.ludamix.triad.ui;
import nme.display.Sprite;
import nme.events.MouseEvent;

class CheckBox extends Sprite
{
	
	public var on : Button;
	public var off : Button;
	
	public var state(default,update) : Bool;
	
	public var sendState : Bool->Void;
	
	public function new(on_sb, off_sb, startState, sendState)
	{
		super();
		
		this.on = on_sb;
		this.off = off_sb;
		this.addChild(on);
		this.addChild(off);
		
		this.state = startState;
		
		this.addEventListener(MouseEvent.CLICK, onClick);
		this.sendState = sendState;
		
	}
	
	public function update(nstate : Bool):Bool
	{
		on.visible = nstate;
		off.visible = !nstate;
		this.state = nstate;
		return nstate;
	}

	public function onClick(_)
	{
		state = !state;
		sendState(state);
	}
	
}