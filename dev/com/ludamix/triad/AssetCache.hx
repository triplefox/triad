package com.ludamix.triad;

#if macro
import haxe.macro.Expr;
import haxe.macro.Context;
import neko.Sys;
#else
import haxe.io.Bytes;
import nme.Assets;
import nme.display.BitmapData;
import nme.events.TimerEvent;
import nme.media.Sound;
import nme.net.URLRequest;
import nme.text.Font;
import nme.utils.Timer;
#end

#if neko
import neko.FileSystem;
import neko.io.File;
#else cpp
import cpp.FileSystem;
import cpp.io.File;
#end

#if flash
typedef AssetCache = Assets;
#else
class AssetCache
{

	@:macro public static function getAssetPath()
	{
		// to support this properly I have to dive into all the code in InstallerBase so that the nmml is
		// correctly parsed. Lots of XML junk to work through.
		
		// I also have to distinguish between "name" "rename" and "path" refs now.
		// On the bright side, now I can return a precompiled list of all assets!
		
		return {pos:Context.currentPos(),expr:EConst(CString(Sys.getCwd()))};
	}	
	
	
	#if macro #else
	public static var t : Timer;
	public static var statCache : Hash<FileStat>;
	public static var onChange : Void->Void;
	public static var asset_path = getAssetPath();
	private static inline var sep = "/";
	
	public static function initPoll(onChange)
	{
		AssetCache.onChange = onChange;
		t = new Timer(100);
		t.addEventListener(TimerEvent.TIMER, doPoll);
		t.start();
		statCache = new Hash();
		initialRecursion("");
	}
	
	private static function initialRecursion(dir:String)
	{
		trace(dir);
		for (n in FileSystem.readDirectory(asset_path + dir))
		{
			statCache.set(dir + sep + n, FileSystem.stat(asset_path + dir + sep + n));
			if (FileSystem.isDirectory(asset_path + dir + sep + n))
			{
				initialRecursion(dir + sep + n);
			}
		}
	}
	
	public static function doPoll(_):Void 
	{
		var change = false;
		for (n in statCache.keys())
		{
			var cs = FileSystem.stat(asset_path + sep + n);
			if (cs.mtime.getTime() != statCache.get(n).mtime.getTime())
				{ statCache.set(n, cs); change = true; }
		}
		if (change) onChange();
	}
	
	public static function getText(id)
	{
		return File.getContent(asset_path + sep + id);		
	}
	
	public static function getBitmapData(id, ?useCache=true)
	{
		return BitmapData.load(asset_path + sep + id);		
	}
	
	public static function getBytes(id)
	{
		return Bytes.ofString(File.getContent(asset_path + sep + id));		
	}
	
	public static function getFont(id)
	{
		return Font.load(asset_path + sep + id);
	}
	
	public static function getSound(id)
	{
		// we don't have a synchronous means of updating sound assets...
		return Assets.getSound(id);
	}
	#end
	
}
#end