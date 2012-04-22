package com.ludamix.triad.ui;

import nme.display.DisplayObject;
import nme.display.Sprite;
import nme.events.MouseEvent;
class Button extends Sprite
{
	
	// replaces SimpleButton, which is a bit buggy in NME.
	
	public var upDO : DisplayObject;
	public var downDO : DisplayObject;
	public var overDO : DisplayObject;
	
	public var onClick : Dynamic->Void;
	
	public function new(up : DisplayObject, over : DisplayObject, down : DisplayObject)
	{
		super();
		
		this.upDO = up;
		this.overDO = over;
		this.downDO = down;
		
		this.addChild(up);
		this.addChild(down);
		this.addChild(over);
		
		down.visible = false;
		up.visible = true;
		over.visible = false;
		
		this.addEventListener(MouseEvent.MOUSE_DOWN, doUpdate);
		this.addEventListener(MouseEvent.MOUSE_UP, doUpdate);
		this.addEventListener(MouseEvent.MOUSE_MOVE, doUpdate);
		this.addEventListener(MouseEvent.MOUSE_OVER, doUpdate);
		this.addEventListener(MouseEvent.MOUSE_OUT, doOut);
		this.addEventListener(MouseEvent.CLICK, doClick);
		this.mouseEnabled = true;
		this.mouseChildren = false;
		
	}
	
	public function doClick(_)
	{
		if (onClick != null) onClick(_);
	}
	
	public function doUpdate(e : MouseEvent)
	{
		if (e.buttonDown)
		{
			this.upDO.visible = false;
			this.downDO.visible = true;
			this.overDO.visible = false;
		}
		else
		{
			this.upDO.visible = false;
			this.downDO.visible = false;
			this.overDO.visible = true;
		}
	}
	
	public function doOut(_)
	{
		this.upDO.visible = true;
		this.downDO.visible = false;
		this.overDO.visible = false;
	}
	
	public function inject(data : Dynamic)
	{
		for (element in [this.upDO, this.downDO, this.overDO])
		{
			for (f in Reflect.fields(data))
				Reflect.setProperty(element, f, Reflect.field(data, f));
		}
	}
	
}
