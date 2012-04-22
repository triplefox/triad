package com.ludamix.triad.tools;

class HashTools
{
	
	public static function valsAsArray(hs : Hash<Dynamic>):Array<Dynamic>
	{
		var ar = new Array<Dynamic>();
		for (n in hs)
			ar.push(n);
		return ar;
	}
	
	public static function keysAsArray(hs : Hash<Dynamic>):Array<String>
	{
		var ar = new Array<String>();
		for (n in hs.keys())
			ar.push(n);
		return ar;
	}
	
	public static function hashFromObjectArray(hs : Dynamic, ar : Array<Dynamic>, namefield : String):Dynamic
	{
		for (n in ar)
		{
			hs.set(Reflect.field(n,namefield), n);
		}
		return hs;
	}
	
	public static function hashFromBoxedObjectArray(hs : Dynamic, ar : Array<{name:String,data:Dynamic}>):Dynamic
	{
		for (n in ar)
		{
			hs.set(n.name, n.data);
		}
		return hs;
	}
	
	public static function objectArrayFromHash(hs : Hash<Dynamic>, ar : Array<Dynamic>, namefield : String):Dynamic
	{
		for (k in hs.keys())
		{
			var data = hs.get(k);
			Reflect.setProperty(data, namefield, k);
			ar.push(data);
		}
		return ar;
	}
	
	public static function boxedObjectArrayFromHash(hs : Hash<Dynamic>, ar : Array<Dynamic>):Dynamic
	{
		for (k in hs.keys())
		{
			var data = hs.get(k);
			ar.push({name:k,data:data});
		}
		return ar;
	}
	
	public static function boxedArrayArrayFromHash(hs : Hash<Dynamic>, ar : Array<Dynamic>):Dynamic
	{
		for (k in hs.keys())
		{
			var data = hs.get(k);
			ar.push([k,data]);
		}
		return ar;
	}
	
}
