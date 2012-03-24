package com.ludamix.triad;

import haxe.io.Bytes;
import haxe.Resource;
import nme.Assets;
import nme.display.BitmapData;
import nme.events.TimerEvent;
import nme.media.Sound;
import nme.text.Font;
import nme.utils.Timer;
#if neko
	import neko.FileSystem;
	import neko.io.File;
#else cpp
	import cpp.FileSystem;
	import cpp.io.File;
#end

typedef ChangedAsset = {id:String,path:String,type:String,stat:FileStat};

class AssetCache
{
	
	// A layer over the Asset functionality to provide fast iterations.
	// You have to provide your own integration. (MVC-style architecture helps!)
	
	#if flash
	public static function initPoll(_, __, ___){}
	#else
	
	private static var t : Timer;
	private static var statCache : Hash<ChangedAsset>;
	private static var onChange : Array<ChangedAsset>->Void;
	private static var resourceNames : Hash<String>;
	private static var resourceTypes : Hash<String>;
	
	public static function initPoll(onChange, src_pathname:String, rename_pathname:String)
	{
		Reflect.field(nme.installer.Assets, "initialize")();
		resourceNames = Reflect.field(nme.installer.Assets, "resourceNames");
		resourceTypes = Reflect.field(nme.installer.Assets, "resourceTypes");
		AssetCache.onChange = onChange;
		t = new Timer(100);
		t.addEventListener(TimerEvent.TIMER, doPoll);
		t.start();
		statCache = new Hash();
		for (id in resourceNames.keys())
		{
			var path = resourceNames.get(id);
			path = StringTools.replace(path, src_pathname, rename_pathname);
			resourceNames.set(id, path);
			statCache.set(id, { id:id, path:path, type:resourceTypes.get(id), stat:FileSystem.stat(path)});
		}
	}
	
	public static function doPoll(_):Void 
	{
		var change = new Array<ChangedAsset>();
		for (n in statCache)
		{
			var check = FileSystem.stat(n.path);
			if (check.mtime.getTime() != n.stat.mtime.getTime())
				{ n.stat = check;  change.push(n); }
		}
		if (change.length>0) onChange(change);
	}
	#end
	
	public static inline function getText(id)
	{
		return nme.installer.Assets.getText(id);
	}
	
	public static inline function getBitmapData(id, ?useCache=true)
	{
		return nme.installer.Assets.getBitmapData(id,false);
	}
	
	public static inline function getBytes(id)
	{
		return nme.installer.Assets.getBytes(id);
	}
	
	public static inline function getFont(id)
	{
		return nme.installer.Assets.getFont(id);
	}
	
	public static inline function getSound(id)
	{
		return nme.installer.Assets.getSound(id);
	}
	
}