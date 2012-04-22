package com.ludamix.triad.ui;

import nme.text.TextField;
import nme.text.TextFieldAutoSize;
import nme.text.TextFormat;
import nme.text.TextFormatAlign;

typedef CascadingTextDef = {
	field : Array<Dynamic>, format : Array<Dynamic>
}

class CascadingText extends TextField
{
	
	// a very, very simple form of "cascading styles" for both the textfield params and textformat.
	
	public function new(field : Array <Dynamic>, 
			format : Array<Dynamic>)
	{
		super();
		
		for (n in field)
		{
			for (f in Reflect.fields(n))
				Reflect.setProperty(this, f, Reflect.field(n, f));
		}
		
		var tformat = new TextFormat();
		
		for (n in format)
		{
			for (f in Reflect.fields(n))
				Reflect.setProperty(tformat, f, Reflect.field(n, f));
		}
		
		this.setTextFormat(tformat);
		this.defaultTextFormat = tformat;
		
	}
	
	// Tools to speed the creation of specialized cascades:
	
	public static function inject(ar : Array<Dynamic>, ?params : Dynamic = null)
	{
		if (params == null) return ar;
		var cp = ar.copy();
		cp.push(params);
		return cp;
	}
	
	public static function injectDef(def : CascadingTextDef, ?field:Dynamic=null, ?format:Dynamic=null) : CascadingTextDef
	{
		return {field:inject(def.field,field),format:inject(def.format,format)};
	}
	
}
