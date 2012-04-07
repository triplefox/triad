package com.ludamix.triad.io;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.events.Event;
import flash.net.FileReference;
import flash.net.FileFilter;
import flash.utils.ByteArray;
import flash.display.Loader;
import haxe.io.Bytes;

class FlashIO
{
	
	public static function loadBytes(ev : Dynamic, fileFilterName : String, fileFilterType : String,
		cback : Bytes->Void) { var fio = new FlashIOInst(); fio.loadBytes(ev, fileFilterName, fileFilterType, cback); }

	public static function loadImage(ev : Dynamic,
		cback : Bitmap->Void) { var fio = new FlashIOInst(); fio.loadImage(ev, cback); }
	
	public static function exportBytes(bytes : Bytes, filename : String) 
	{ var fio = new FlashIOInst(); fio.exportBytes(bytes, filename); }

}

class FlashIOInst
{
	
	public function new() {}
	
	public var fr : FileReference;
	public var loader : Loader;
	public var cback : Dynamic;
	
	public function loadBytes(ev : Dynamic, fileFilterName : String, fileFilterType : String,
		cback : Bytes->Void)
	{
		this.cback = cback;
		fr = new flash.net.FileReference();
		fr.addEventListener(Event.SELECT, loadBytes2);
		fr.addEventListener(Event.COMPLETE, loadBytes3);
		var filter:FileFilter = new FileFilter(fileFilterName, fileFilterType);
		fr.browse([filter]);
	}
	
	private function loadBytes2(ev : Dynamic)
	{
		fr.removeEventListener(Event.SELECT, loadBytes2);
		fr.load();		
	}
	
	private function loadBytes3(ev : Dynamic)
	{
		fr.removeEventListener(Event.COMPLETE, loadBytes3);
		var bytear : ByteArray = fr.data;
		bytear.position = 0;
		cback(Bytes.ofData(bytear));
	}	
	
	public function loadImage(ev : Dynamic, cback : Bitmap->Void)
	{
		this.cback = cback;
		fr = new flash.net.FileReference();
		fr.addEventListener(Event.SELECT, loadImage2);
		fr.addEventListener(Event.COMPLETE, loadImage3);
		fr.browse();
	}
	
	private function loadImage2(ev : Event)
	{
		fr.removeEventListener(Event.SELECT, loadImage2);
		fr.load();
	}
	
	private function loadImage3(ev : Event)
	{
		fr.removeEventListener(Event.COMPLETE, loadImage3);
		loader = new Loader();
		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadImage4);
		loader.loadBytes(fr.data);
	}
	
	private function loadImage4(ev : Event)
	{
		loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadImage4);
		cback(cast(loader.content, Bitmap));
	}

	public function exportBytes(bytes : Bytes, filename : String)
	{
		fr = new flash.net.FileReference();
		fr.save(bytes.getData(),filename);
	}	
	
}