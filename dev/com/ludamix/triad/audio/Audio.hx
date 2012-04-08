package com.ludamix.triad.audio;

import haxe.Timer;
import nme.events.Event;
import nme.Lib;
import nme.media.Sound;
import nme.media.SoundChannel;
import nme.Assets;
import nme.media.SoundTransform;
import nme.net.SharedObject;

enum ChannelMode {
	WaitForTimestamp;
	WaitForTimestampOrDifferent;
	OverwriteAlways;
	OverwriteIfDifferentElseModify;
	ModifyOnly;
}

typedef AudioChannel = {
	snd : String,
	mixgroup : String,
	instance : SoundChannel,
	timestamp : Float,
	vol : Float
}

class Audio
{
	
	public static var channels = new Hash<AudioChannel>();
	
	public static var SFXCHANNEL = "SFX";
	public static var BGMCHANNEL = "BGM";
	
	public static var mix : SharedObject;
	
	public static function mixLevel(group : String) : Float
	{
		var mg = Reflect.field(mix.data, group);
		if (mg == null) throw "Undefined mixgroup " + group;
		else if (mg.on) return Math.pow(mg.vol, 1.7); 
		else return 0.; 
	}
	
	private static function _channelPlay(name:String, soundname : String, mixgroup : String,
		startTime : Float, loops:Int, vol : Float, pan : Float, timestamp : Float)
	{
		var tfm = new flash.media.SoundTransform(mixLevel(mixgroup) * vol, pan);
		var snd = Assets.getSound(soundname);
		if (snd == null ) throw "Undefined sound asset " + soundname;
		var sc = snd.play(startTime,loops,tfm);
		channels.set(name, { vol:vol, snd:soundname, mixgroup:mixgroup, instance:sc, timestamp:Timer.stamp() + timestamp } );
		return sc;
	}
	
	private static function _channelStop(name:String)
	{
		if (channels.exists(name))
			{ channels.get(name).instance.stop(); channels.remove(name); }
	}
	
	private static function _channelModify(name:String, vol : Float, pan : Float)
	{
		if (channels.exists(name))
			{ var ch = channels.get(name);
			  ch.vol = vol;
			  ch.instance.soundTransform = new SoundTransform(mixLevel(ch.mixgroup) * vol, pan); 
			}
	}
	
	private static function _channelTouch(name:String)
	{
		if (channels.exists(name))
			{ var ch = channels.get(name);
			  ch.instance.soundTransform = new SoundTransform(
				mixLevel(ch.mixgroup) * ch.vol, 
				ch.instance.soundTransform.pan); 
			}
	}
	
	private static function _timestampReady(name:String)
	{
		if (channels.exists(name))
			return channels.get(name).timestamp < Timer.stamp();
		else return true;
	}
	
	private static function _soundDifferent(name:String,soundname:String)
	{
		if (channels.exists(name))
			return channels.get(name).snd != soundname;
		else return true;
	}
	
	public static function channelPlay(name:String, soundname : String, mixgroup : String,
		startTime : Float, loops:Int, vol : Float, pan : Float, timestamp : Float, mode : ChannelMode) : SoundChannel
	{
		switch(mode)
		{
			case WaitForTimestamp:
				if (_timestampReady(name)) 
				{ 
					_channelStop(name); 
					return _channelPlay(name, soundname, mixgroup, startTime, loops, vol, pan, timestamp);
				}
			case WaitForTimestampOrDifferent:
				if (_timestampReady(name) || _soundDifferent(name,soundname)) 
				{ 
					_channelStop(name); 
					return _channelPlay(name, soundname, mixgroup, startTime, loops, vol, pan, timestamp);
				}
			case OverwriteAlways:
				_channelStop(name); 
				return _channelPlay(name, soundname, mixgroup, startTime, loops, vol, pan, timestamp);
			case OverwriteIfDifferentElseModify:
				if (_soundDifferent(name,soundname)) 
				{ 
					_channelStop(name); 
					return _channelPlay(name, soundname, mixgroup, startTime, loops, vol, pan, timestamp);
				}
				else
					_channelModify(name, vol, pan);
			case ModifyOnly:
				_channelModify(name, vol, pan);
		}
		return null;
	}
	
	public static function stop(name:String)
	{
		_channelStop(name);
	}
	
	public static function play(name:String, ?vol = 1.0, ?pan = 0., ?timestamp = 0.1)
	{	
		return channelPlay(name, name, SFXCHANNEL, 0, 1, vol, pan, timestamp, WaitForTimestampOrDifferent);
	}
	
	public static function playLoop(name:String, ?vol = 1.0, ?pan = 0., ?timestamp = 0.1)
	{	
		return channelPlay(name, name, SFXCHANNEL, 0, 9999999, vol, pan, timestamp, WaitForTimestampOrDifferent);
	}
	
	public static function ambient(name : String, ?vol = 1.0, ?pan = 0.)
	{
		/* For ambient loops (e.g. wind, birds, etc.) */
		return channelPlay("ambient", name, SFXCHANNEL, 0, 9999999, vol, pan, 0, OverwriteIfDifferentElseModify);
	}
	
	public static function music(name : String, ?vol = 1.0, ?pan = 0.)
	{
		/* For persistent music */
		return channelPlay("music", name, BGMCHANNEL, 0, 9999999, vol, pan, 0, OverwriteIfDifferentElseModify);
	}
	
	public static function setMixgroup(name:String, setOn : Bool)
	{
		var mg = Reflect.field(mix.data, name);
		if (mg == null) throw "Undefined mixgroup " + name;
		mg.on = setOn;
		for (n in channels.keys())
		{
			_channelTouch(n);
		}
		save(mix, name, mg);
		return mg.on;
	}
	
	public static function toggleMixgroup(name:String)
	{
		var mg = Reflect.field(mix.data, name);
		if (mg == null) throw "Undefined mixgroup " + name;
		return setMixgroup(name, !mg.on);
	}
	
	public static function modMixgroup(name:String, level : Float)
	{
		var mg = Reflect.field(mix.data, name);
		if (mg == null) throw "Undefined mixgroup " + name;
		mg.vol = level;
		for (n in channels.keys())
		{
			_channelTouch(n);
		}
		save(mix, name, mg);
		return mg.vol;
	}
	
	public static inline var default_mix = { 
		  SFX : { vol:1.0, on:true },
		  BGM : { vol:1.0, on:true }
		};
	
	public static function init(?defaults : Dynamic = null, ?forceDefaults : Bool = false)
	{	
		mix = SharedObject.getLocal("triad_audio");
		if (Reflect.fields(mix.data).length<1 || forceDefaults==true)
		{ 
			mix.clear(); 
			if (defaults == null) 
				defaults = default_mix;
			for (n in Reflect.fields(defaults)) 
			{
				Reflect.setField(mix.data, n, Reflect.field(defaults, n));
			}
			mix.flush();
		}
	}	

	private static function save(obj : SharedObject, propname : String, value : Dynamic)
	{
		#if flash
			obj.setProperty(propname, value);
		#else
			Reflect.setField(obj.data, propname, value);
			obj.flush();
		#end
	}
	
}