package com.ludamix.triad.format;

/*

TriadConfig

This is a light, "low-punishment" configuration/serialization syntax.

Unlike JSON's requirement of sequence vs. key-value specification, 
it can determine which one is intended, or create a Lua table-esque mixture in the ambiguous case.

Example:
	
	Plain text strings are mostly transparent. Leading and ending whitespace are trimmed.
	If I want to maximize string flexibility, I open a "long string":
		[" Now I can use ; __ = and [] as often as I please. 
			As well, whitespace is preserved exactly within the markers. "];
	
	A key-value = Hello world!;
	My First Sequence = [1;2;3;4;5;6]
	Nested sequences = [[a;b;c][e;f;g]]
	Null value = __;
	Nested key-value stores = [
		Key One=Moo;
		Key Two=[ 1.3; 5.6; 7.8; ["Some string data"] ]
	]
	13.3=Numeric key;

Spec:

	These sigils are recognized:
		[ ] ; = [" "]
	The backslash character \ is used to escape these sigils.
	
	The reference implementation follows these passes:
	
	1. The sigils and the characters between them are tokenized.
		[ ] ; = act as delimiters.
		The Atom type is defined as either a null, string, integer, or floating point number. 
			They are intialized as "unparsed" strings.
		When [" is encountered, characters until a corresponding "] are accumulated into a single string Atom.
	2. (recursive) Rewrite unparsed atoms.
		Leading and ending whitespace(including newlines) is trimmed.
		The characters "__" (with no additional text after trim) are turned into a null. To escape "__" use a long string.
		Numbers are parsed.
		Delimiters are stripped.
		Each [ ] pairing forms a tree of Sequences, which contain any number of Atoms and Sequences.
	3. The tokens of each Sequence are rewritten according to these rules:
		Atom = Atom, Sequence = Atom, Atom = Sequence, Sequence = Sequence are rewritten to KeyValue. 
		The mapping of non-string keys is implementation-defined.
		KeyValue chaining is not allowed - i.e. you cannot do Moo=Foo=Boo.
	4. Native values are emitted according to these rules:
		If a Sequence is empty, it's a list.
		If a Sequence contains only KeyValue types, it's a key-value store.
			Overlapping keys will throw errors.
		If a Sequence contains only Atom types, it's a list.
		If a Sequence contains mixed KeyValue and Atom types, it's a Table with both dictionary and list representation,
		where the list is in order and the dictionary names by index(starting at 0) where a key is not available.
	
	A non-mixed parsing mode is possible, eliminating Table and giving the options of:
		error on mixed container
		auto-coercion to list
		auto-coercion to key-value
	
*/

typedef LXString = com.ludamix.triad.tools.StringTools;
typedef HXString = StringTools;

enum TCType
{
	TCUnparsedAtom(data:String);
	TCAtom(data:Dynamic);
	TCOpenSequence;
	TCCloseSequence;
	TCDelimit;
	TCAssign;
	TCKeyValue(key:Dynamic, val:Dynamic);
	TCSequence(data : Array<Dynamic>);
}

enum TCParseMode
{
	TCPTable;
	TCPList;
	TCPKeyValue;
	TCPReject;
}

class TriadConfig
{
	
	private static function pass1(str : String) : Array<TCType>
	{
		var toks = new Array<TCType>();
		var ct = 0;
		var accumulator = "";
		var doDelimit = function() { toks.push(TCUnparsedAtom(accumulator)); accumulator = ""; }
		var matchLookahead = function(m : String)
		{
			if (str.length <= ct + 1) { return false; }
			else return m == str.charAt(ct + 1);
		}
		var advance = function() { doDelimit(); ct++; }
		var tokAdvance = function(tok : TCType) { doDelimit(); toks.push(tok); ct++; }
		var longString = function() 
		{
			while (ct < str.length)
			{
				var c = str.charAt(ct);
				
				if (c == "\\") { ct++; c = str.charAt(ct); accumulator+=c; ct++; }
				else if (c == '"') { matchLookahead(']') ? 
					{ ct+=3; toks.push(TCAtom(accumulator)); accumulator = ""; return; } : 
					{ accumulator += c; ct++; } }
				else { accumulator += c; ct++; }
			}
		}
		
		while (ct < str.length)
		{
			var c = str.charAt(ct);
			
			if (c == "\\") { ct++; c = str.charAt(ct); accumulator+=c; ct++; }
			else if (c == ";") { tokAdvance(TCDelimit); }
			else if (c == "[") { matchLookahead('"') ? { ct--;  doDelimit(); ct += 3; longString(); } : 
								 tokAdvance(TCOpenSequence); }
			else if (c == "]") { tokAdvance(TCCloseSequence); }
			else if (c == "=") { tokAdvance(TCAssign); }
			else { accumulator += c; ct++; }
		}
		
		if (accumulator.length > 0)
			doDelimit();
			
		return toks;
	}
	
	private static function pass2(toks : Array<TCType>) : Array<TCType>
	{
		var result = new Array<TCType>();
		while(toks.length>0)
		{
			var t = toks.shift();
			switch t
			{
				case TCUnparsedAtom(data): 
					var data = LXString.parseIntFloatString(HXString.trim(data));
					if (data == "__") data = null;
					if (data != "")
						result.push(TCAtom(data));
				case TCAtom(data): result.push(t);
				case TCOpenSequence: result.push(TCSequence(pass2(toks)));
				case TCCloseSequence: return pass3(result);
				case TCAssign: result.push(t);
				case TCDelimit:
				case TCKeyValue(key, val): throw "shouldn't get here";
				case TCSequence(data): throw "shouldn't get here";
			}
		}
		return pass3(result);
	}
	
	private static function pass3(toks : Array<TCType>)
	{
		
		var result = new Array<TCType>();
		while (toks.length > 0)
		{
			var t = toks.shift();
			if (t == TCAssign)
			{
				if (result.length == 0) throw "Error: Assignment without key";
				var lookbehind = result.pop();
				var key = "";
				switch lookbehind
				{
					case TCAtom(data): key = Std.string(data);
					case TCSequence(data): key = Std.string(data);
					case TCAssign: throw "Error: Double assignment";
					case TCUnparsedAtom(data): throw "shouldn't get here";
					case TCKeyValue(key, val): throw "Error: Assignment to key-value is not allowed";
					case TCOpenSequence, TCCloseSequence, TCDelimit: throw "shouldn't get here";
				}
				if (toks.length == 0) throw "Error: Assignment without value";
				var lookahead = toks.shift();
				var val : Dynamic = null;
				switch lookahead
				{
					case TCAtom(data): val = lookahead;
					case TCSequence(data): val = lookahead;
					case TCAssign: throw "Error: Double assignment";
					case TCUnparsedAtom(data): throw "shouldn't get here";
					case TCKeyValue(key, val): throw "Error: Assignment of key-value is not allowed";
					case TCOpenSequence, TCCloseSequence, TCDelimit: throw "shouldn't get here";
				}
				result.push(TCKeyValue(key, val));
			}
			else result.push(t);
		}
		return result;
	}
	
	public static function pass4(tok : Array<Dynamic>, parse_mode : TCParseMode) : Dynamic
	{
		var isList = true;
		var isKV = true;
		var result_list = new Array<Dynamic>();
		var result_dict : Dynamic = { };
		var idx = 0;
		
		var setProp = function(key, val) : Void
		{
			if (Reflect.hasField(result_dict, key)) throw "Error: Duplicate key name " + key;
			Reflect.setProperty(result_dict, key, val);
		}
		
		for (n in tok)
		{
			switch n
			{
				case TCKeyValue(key, val): isList = false;
					var d : Dynamic = null;
					switch val
					{
						case TCAtom(data): d = data;
						case TCSequence(data): d = pass4(data, parse_mode);
						case TCUnparsedAtom(data): throw "shouldn't get here";
						case TCKeyValue(key, val): throw "shouldn't get here";
						case TCAssign, TCOpenSequence, TCCloseSequence, TCDelimit: throw "shouldn't get here";						
					}
					result_list.push(d); setProp(key, d);
				case TCAtom(data): isKV = false;
					result_list.push(data); setProp(Std.string(idx), data);
				case TCSequence(data): isKV = false; var d = pass4(data, parse_mode);
					result_list.push(d); setProp(Std.string(idx), d);
				case TCUnparsedAtom(data): throw "shouldn't get here";
				case TCOpenSequence, TCCloseSequence, TCDelimit, TCAssign: throw "shouldn't get here";
			}
			idx++;
		}
		if (isList) return result_list;
		if (isKV) return result_dict;
		switch(parse_mode)
		{
			case TCPTable: return {list:result_list, dict:result_dict};
			case TCPList: return result_list;
			case TCPKeyValue: return result_dict;
			case TCPReject: throw "Error: Mixture of sequence and key-value data.";
		}
	}
	
	public static function parse(str : String, parse_mode : TCParseMode)
	{
		return pass4(pass2(pass1(str)), parse_mode);
	}
	
}
