package com.ludamix.triad;

import nme.events.Event;
import nme.events.KeyboardEvent;
import nme.events.MouseEvent;
import nme.Lib;
import haxe.Serializer;
import haxe.Unserializer;
import nme.net.SharedObject;
import nme.ui.Keyboard;

typedef KeyInfos = {keyCode:Int,charCode:Int};

class ButtonManager
{
	
	public var mappings : Hash<{state:Int,code:KeyInfos,group:String}>;
	public var defaultmappings : Hash<{state:Int,code:KeyInfos,group:String}>;	
	public var events : Array<{button:String,state:Int,ctrl:Bool,shift:Bool}>;
	public var nextevents : Array<Dynamic>;
	public var mouseLeft : Int;
	
	public var version : Int;
	public var so : SharedObject;
	
	// states
	public static inline var UP = 0;
	public static inline var DOWN = 1;
	
	public static inline var MOUSE = -1;
	
	public function new(inmappings : Array<{name:String,code:KeyInfos,group:String}>, version : Int)
	{
		
		so = SharedObject.getLocal("triad_button");
		this.version = version;
		
		defaultmappings = new Hash();
		defaultmappings.set("mouse", { code: {keyCode:-1,charCode:-1}, state:UP, group:"mouse" } );
		for (n in inmappings)
		{
			defaultmappings.set(n.name, {code:n.code,state:UP,group:n.group});
		}
		defaults();
		
		if (Reflect.field(so.data,"serialized")!=null)
		{
			unserialize(so.data.serialized);
		}
		
		events = new Array();
		nextevents = new Array();
		
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, onDown);
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, onUp);
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_DOWN, onMDown);
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_UP, onMUp);
		
		Lib.current.stage.addEventListener(Event.ENTER_FRAME, update);
		
	}
	
	private var toBind : String;
	private var onComplete : String->Void;
	
	private inline function keyOrChar(ev : KeyboardEvent)
	{
		// we lose some support for extended keys by doing this, but it doesn't seem easy to support both
		#if flash
			return ev.keyCode;
		#else
			return ev.charCode;
		#end
	}
	
	private function bind(ev : KeyboardEvent) : Void
	{
		if (ev.keyCode == Keyboard.ESCAPE)
		{
			onComplete("Cancelled");
		}
		else
		{
			mappings.set(toBind, { state:UP, code: { keyCode:ev.keyCode, charCode:ev.charCode }, 
									group:mappings.get(toBind).group } );
			save();
			onComplete(["Bound", toBind, "to", keyNameOf({ keyCode:ev.keyCode, charCode:ev.charCode })].join(" "));
		}
		
		Lib.current.stage.removeEventListener(KeyboardEvent.KEY_DOWN,
		bind, false);
		toBind = null;
		onComplete = null;
	}
	
	public function cancelBind(?message : String = "Cancelled")
	{
		onComplete(message);
		Lib.current.stage.removeEventListener(KeyboardEvent.KEY_DOWN,
		bind, false);
		toBind = null;
		onComplete = null;
	}
	
	public function startBind(toBind : String, onComplete : String->Void) : String
	{ 
		if (this.toBind != null)
			return "Can't bind two keys at once!";
		this.toBind = toBind;
		this.onComplete = onComplete;
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN,
		bind , false, 1, false);
		return ["Press the key for", toBind,"(ESC to cancel)"].join(" ");
	}
	
	public function save()
	{
		#if flash
			so.setProperty("serialized", serialize());
		#else
			Reflect.setField(so.data, "serialized", serialize());
			so.flush();
		#end
	}
	
	public function serialize() : String
	{
		return Serializer.run({version:this.version,mappings:mappings});
	}
	
	public function unserialize(inp : String)
	{
		// we overwrite instead of replacing to preserve any "new default" keybinds
		var saved : { version:Int, mappings:Hash<{state:Int,group:String,code:KeyInfos}> } = Unserializer.run(inp);
		if (saved.version == this.version)
		{
			this.mappings = saved.mappings;
		}
	}
	
	public function defaults()
	{
		this.mappings = new Hash();
		for (n in this.defaultmappings.keys())
		{
			var o = this.defaultmappings.get(n);
			this.mappings.set(n, {state:o.state,code:o.code,group:o.group});
		}
	}
	
	public inline function keyMatches(a : KeyInfos, b : KeyInfos)
	{
		return (a.charCode == b.charCode) && (a.keyCode == b.keyCode);
	}
	
	public function onDown(ev : KeyboardEvent)
	{
		for (n in mappings.keys())
		{
			if (keyMatches({ keyCode:ev.keyCode, charCode:ev.charCode }, mappings.get(n).code))
				setDown(n,ev.ctrlKey,ev.shiftKey);
		}
	}
	
	public function onUp(ev : KeyboardEvent)
	{
		for (n in mappings.keys())
		{
			if (keyMatches({ keyCode:ev.keyCode, charCode:ev.charCode }, mappings.get(n).code))
				setUp(n,ev.ctrlKey,ev.shiftKey);
		}
	}
		
	public function onMDown(ev : MouseEvent)
	{
		mouseLeft = DOWN;
		nextevents.push({button:"mouse",state:DOWN,ctrl:ev.ctrlKey,shift:ev.shiftKey});
	}
	
	public function onMUp(ev : MouseEvent)
	{
		mouseLeft = UP;
		nextevents.push({button:"mouse",state:UP,ctrl:ev.ctrlKey,shift:ev.shiftKey});
	}
	
	public function setDown(mapping : String,ctrl:Bool,shift:Bool)
	{
		mappings.get(mapping).state = DOWN;
		nextevents.push({button:mapping,state:DOWN,ctrl:ctrl,shift:shift});
	}
	
	public function setUp(mapping : String,ctrl:Bool,shift:Bool)
	{
		mappings.get(mapping).state = UP;
		nextevents.push({button:mapping,state:UP,ctrl:ctrl,shift:shift});
	}
	
	public function update(ev : Event)
	{
		events = new Array();
		for (n in nextevents)
			events.push(n);
		nextevents = new Array();
	}
	
	public function kill()
	{
		
		Lib.current.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onDown);
		Lib.current.stage.removeEventListener(KeyboardEvent.KEY_UP, onUp);
		Lib.current.stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMDown);
		Lib.current.stage.removeEventListener(MouseEvent.MOUSE_UP, onMUp);
		
	}
	
	public function isPressed(key : String)
	{
		return mappings.get(key).state == DOWN;
	}
	
	public function getBindings(?includeMouse = false)
	{
		var set = new Array<{name:String,code:KeyInfos,group:String}>();
		for (k in mappings.keys())
		{
			var bind = mappings.get(k);
			if (includeMouse || k!="mouse")
				set.push( { name:k, code:bind.code, group:bind.group } );
		}
		set.sort(function(a:Dynamic, b:Dynamic) { 
			if (a.group == b.group) return { a.name < b.name ? 1 : -1; }
			else return a.group < b.group ? 1 : -1; } );
		return set;
	}
	
	public static inline function keyNameOf(code : KeyInfos) { 
		if (code.charCode != 0)
			return charcodes[code.charCode];
		else
			return keycodes[code.keyCode];
	}

	public static var keycodes = [
		"~0",
		"~1",
		"~2",
		"Break",
		"~4",
		"~5",
		"~6",
		"~7",
		"Backspace",
		"Tab",
		"~10",
		"~11",
		"~12",
		"Enter",
		"~14",
		"~15",
		"Shift",
		"Ctrl",
		"Alt",
		"Pause",
		"Capslock",
		"~21",
		"~22",
		"~23",
		"~24",
		"~25",
		"~26",
		"Esc",
		"~28",
		"~29",
		"~30",
		"~31",
		"Spacebar",
		"Page Up",
		"Page Down",
		"End",
		"Home",
		"Left",
		"Up",
		"Right",
		"Down",
		"~41",
		"~42",
		"~43",
		"~44",
		"Insert",
		"Delete",
		"~47",
		"0",
		"1",
		"2",
		"3",
		"4",
		"5",
		"6",
		"7",
		"8",
		"9",
		"~58",
		"~59",
		"~60",
		"~61",
		"~62",
		"~63",
		"~64",
		"A",
		"B",
		"C",
		"D",
		"E",
		"F",
		"G",
		"H",
		"I",
		"J",
		"K",
		"L",
		"M",
		"N",
		"O",
		"P",
		"Q",
		"R",
		"S",
		"T",
		"U",
		"V",
		"W",
		"X",
		"Y",
		"Z",
		"Command",
		"~92",
		"Option",
		"~94",
		"~95",
		"0 (numpad)",
		"1 (numpad)",
		"2 (numpad)",
		"3 (numpad)",
		"4 (numpad)",
		"5 (numpad)",
		"6 (numpad)",
		"7 (numpad)",
		"8 (numpad)",
		"9 (numpad)",
		"* (numpad)",
		"+ (numpad)",
		"- (numpad)",
		". (numpad)",
		"/ (numpad)",
		"~111",
		"F1",
		"F2",
		"F3",
		"F4",
		"F5",
		"F6",
		"F7",
		"F8",
		"F9",
		"F10",
		"F11",
		"F12",
		"~124",
		"~125",
		"~126",
		"~127",
		"~128",
		"~129",
		"~130",
		"~131",
		"~132",
		"~133",
		"~134",
		"~135",
		"~136",
		"~137",
		"~138",
		"~139",
		"~140",
		"~141",
		"~142",
		"~143",
		"Num Lock",
		"Scroll Lock",
		"~146",
		"~147",
		"~148",
		"~149",
		"~150",
		"~151",
		"~152",
		"~153",
		"~154",
		"~155",
		"~156",
		"~157",
		"~158",
		"~159",
		"~160",
		"~161",
		"~162",
		"~163",
		"~164",
		"~165",
		"~166",
		"~167",
		"~168",
		"~169",
		"~170",
		"~171",
		"~172",
		"Mute",
		"Volume -",
		"Volume +",
		"Fast-Forward",
		"Rewind",
		"Stop",
		"Play",
		"~180",
		"~181",
		"~182",
		"~183",
		"~184",
		"~185",
		";",
		"=",
		",",
		"-",
		".",
		"/",
		"`",
		"~193",
		"~194",
		"~195",
		"~196",
		"~197",
		"~198",
		"~199",
		"~200",
		"~201",
		"~202",
		"~203",
		"~204",
		"~205",
		"~206",
		"~207",
		"~208",
		"~209",
		"~210",
		"~211",
		"~212",
		"~213",
		"~214",
		"~215",
		"~216",
		"~217",
		"~218",
		"[",
		"\\",
		"]",
		"'",
		"~223",
		"~224",
		"~225",
		"~226",
		"~227",
		"~228",
		"~229",
		"~230",
		"~231",
		"~232",
		"~233",
		"~234",
		"~235",
		"~236",
		"~237",
		"~238",
		"~239",
		"~240",
		"~241",
		"~242",
		"~243",
		"~244",
		"~245",
		"~246",
		"~247",
		"~248",
		"~249",
		"~250",
		"~251",
		"~252",
		"~253",
		"~254",
		"Enable/Disable Touchpad",	
	];
	public static var charcodes = [
		"~0",
		"~1",
		"~2",
		"Break",
		"~4",
		"~5",
		"~6",
		"~7",
		"Backspace",
		"Tab",
		"~10",
		"~11",
		"~12",
		"Enter",
		"~14",
		"~15",
		"Shift",
		"Ctrl",
		"Alt",
		"Pause",
		"Capslock",
		"~21",
		"~22",
		"~23",
		"~24",
		"~25",
		"~26",
		"Esc",
		"~28",
		"~29",
		"~30",
		"~31",
		"Spacebar",
		"!",
		'"',
		"#",
		"$",
		"%",
		"&",
		"'",
		"(",
		")",
		"*",
		"+",
		",",
		"-",
		".",
		"/",
		"0",
		"1",
		"2",
		"3",
		"4",
		"5",
		"6",
		"7",
		"8",
		"9",
		":",
		";",
		"<",
		"=",
		">",
		"?",
		"@",
		"A",
		"B",
		"C",
		"D",
		"E",
		"F",
		"G",
		"H",
		"I",
		"J",
		"K",
		"L",
		"M",
		"N",
		"O",
		"P",
		"Q",
		"R",
		"S",
		"T",
		"U",
		"V",
		"W",
		"X",
		"Y",
		"Z",
		"[",
		"\\",
		"]",
		"^",
		"_",
		"`",
		"a",
		"b",
		"c",
		"d",
		"e",
		"f",
		"g",
		"h",
		"i",
		"j",
		"k",
		"l",
		"m",
		"n",
		"o",
		"p",
		"q",
		"r",
		"s",
		"t",
		"u",
		"v",
		"w",
		"x",
		"y",
		"z",
		"{",
		"|",
		"}",
		"~",
		"Delete",
		"~128",
		"~129",
		"~130",
		"~131",
		"~132",
		"~133",
		"~134",
		"~135",
		"~136",
		"~137",
		"~138",
		"~139",
		"~140",
		"~141",
		"~142",
		"~143",
		"Num Lock",
		"Scroll Lock",
		"~146",
		"~147",
		"~148",
		"~149",
		"~150",
		"~151",
		"~152",
		"~153",
		"~154",
		"~155",
		"~156",
		"~157",
		"~158",
		"~159",
		"~160",
		"~161",
		"~162",
		"~163",
		"~164",
		"~165",
		"~166",
		"~167",
		"~168",
		"~169",
		"~170",
		"~171",
		"~172",
		"Mute",
		"Volume -",
		"Volume +",
		"Fast-Forward",
		"Rewind",
		"Stop",
		"Play",
		"~180",
		"~181",
		"~182",
		"~183",
		"~184",
		"~185",
		";",
		"=",
		",",
		"-",
		".",
		"/",
		"`",
		"~193",
		"~194",
		"~195",
		"~196",
		"~197",
		"~198",
		"~199",
		"~200",
		"~201",
		"~202",
		"~203",
		"~204",
		"~205",
		"~206",
		"~207",
		"~208",
		"~209",
		"~210",
		"~211",
		"~212",
		"~213",
		"~214",
		"~215",
		"~216",
		"~217",
		"~218",
		"[",
		"\\",
		"]",
		"'",
		"~223",
		"~224",
		"~225",
		"~226",
		"~227",
		"~228",
		"~229",
		"~230",
		"~231",
		"~232",
		"~233",
		"~234",
		"~235",
		"~236",
		"~237",
		"~238",
		"~239",
		"~240",
		"~241",
		"~242",
		"~243",
		"~244",
		"~245",
		"~246",
		"~247",
		"~248",
		"~249",
		"~250",
		"~251",
		"~252",
		"~253",
		"~254",
		"~255",	
		"~256",	
		"~257",	
		"~258",	
		"~259",	
		"~260",	
		"~261",	
		"~262",	
		"~263",	
		"~264",	
		"~266",	
		"~267",	
		"~268",	
		"~269",	
		"~270",	
		"~271",	
		"~272",	
		"~273",	
		"~274",	
		"~276",	
		"~277",	
		"~278",	
		"~279",	
		"~270",	
		"~271",	
		"~272",	
		"~273",	
		"~274",	
		"~276",	
		"~277",	
		"~278",	
		"~279",	
		"~280",	
		"~281",	
		"~282",	
		"~283",	
		"~284",	
		"~286",	
		"~287",	
		"~288",	
		"~289",	
		"~290",	
		"~291",	
		"~292",	
		"~293",	
		"~294",	
		"~296",	
		"~297",	
		"~298",	
		"~299"
	];

}