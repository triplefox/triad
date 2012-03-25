package com.ludamix.triad.entity;

/*
 * 
 * A minimalistic, non-serializing, message-passing entity system.
 * 
 * The entities contain only arrays of EListeners - function pointers.
 * A component may live on an entity as attached listeners, or as its own entity, accessed via passthrough listeners.
 * To address common methods like spawn/despawn, listeners are allowed to stack themselves on the same name.
 * 
 * Raw data lives on the database; subclass the database to integrate more data structures.
 * When you need to be clean, you can use listener calls everywhere to attain as much abstraction as necessary;
 * When you need to grab data fast, you can dive into the raw database functionality.
 * 
 * Property bags and tagging are included to assist the creation of entity groups, queues, etc.
 * 
 * (Serializing this system effectively requires serialization of closures and is a major source of complexity)
 * 
 */

typedef ListenerHash = Hash<Array<Dynamic>>; 
typedef EListener = Dynamic->Array<ERow>->Dynamic->Dynamic;

class EDatabase
{
	
	public var rows : IntHash<ERow>;
	public var id_increment : Int;
	
	public var tags : Hash<Array<ERow>>;
	public var bags : Array<Dynamic>;
	
	public function new()
	{
		rows = new IntHash();
		tags = new Hash();
		bags = new Array();
		id_increment = 0;
	}
	
	private function getFreeId()
	{
		while (rows.exists(id_increment))
			id_increment++;
		return id_increment;
	}
	
	public function spawn(listener_object : Dynamic)
 	{
		var h = new ListenerHash();
		for (f in Reflect.fields(listener_object))
			h.set(f, Reflect.field(listener_object, f));
		return new ERow(getFreeId(), h);
	}
	
	public inline function call(target : ERow, listener : String, ?payload : Dynamic = null,
		?stack : Array<ERow>=null) : Dynamic
	{
		if (stack==null)
			return target.call(this, new Array<ERow>(), listener, payload);
		else
			return target.call(this, stack, listener, payload);
	}
	
	public function tag(db : EDatabase, stack : Array<ERow>, payload : {name:String,get:String,remove:String})
	{
		var tagset : Array<ERow> = db.tags.get(payload.name);
		if (tagset==null)
		{
			tagset = new Array(); db.tags.set(payload.name, tagset);
		}
		tagset.push(stack[stack.length - 1]);
		var on_remove : Dynamic = null;
		var on_get : Dynamic = null;
		on_get = function(db : EDatabase, stack : Array<ERow>, _payload : Dynamic) 
		{ return payload.name; }
		on_remove = function(db : EDatabase, stack : Array<ERow>, _payload : Dynamic) 
			{ tagset.remove(stack[stack.length - 1]); 
			  stack[stack.length - 1].unlisten(payload.get,on_get);
			  stack[stack.length - 1].unlisten(payload.remove, on_remove); return true;  }
		stack[stack.length - 1].listen(payload.get, on_get);
		stack[stack.length - 1].listen(payload.remove, on_remove);
		return {tagset:tagset,on_get:on_get,on_remove:on_remove};
	}
	
	public function bag(db : EDatabase, stack : Array<ERow>, payload : { data:Dynamic, get:String, remove:String } )
	{
		var _bag : Dynamic = payload.data;
		bags.push(_bag);
		var on_get : Dynamic = null;
		var on_remove : Dynamic = null;
		on_get = function(db : EDatabase, stack : Array<ERow>, _payload : Dynamic) 
			{ return _bag; }
		on_remove = function(db : EDatabase, stack : Array<ERow>, _payload : Dynamic) 
			{ bags.remove(_bag);
			  stack[stack.length - 1].unlisten(payload.get,on_get);
			  stack[stack.length - 1].unlisten(payload.remove,on_remove); }
		stack[stack.length - 1].listen(payload.get, on_get);
		stack[stack.length - 1].listen(payload.remove, on_remove);
		return {on_get:on_get,on_remove:on_remove};
	}
	
}

class ERow
{
	
	public var id : Int;
	public var listeners : ListenerHash;
	
	public function new(id : Int, ?listeners : ListenerHash = null)
	{
		this.id = id;
		if (listeners == null)
			this.listeners = new ListenerHash();
		else
			this.listeners = listeners;
	}
	
	public inline function call(db : EDatabase,
		stack : Array<ERow>, listener : String, ?payload : Dynamic = null) : Dynamic
	{
		var result = null;
		var lar : Array<Dynamic> = listeners.get(listener);
		if (lar != null)
		{
			stack.push(this);
			for (l in lar)
			{
				result = l(db, stack.copy(), payload);
			}
		}
		return result;
	}
	
	public inline function listen(name : String, call : EListener)
	{
		if (listeners.exists(name))
			listeners.get(name).push(call);
		else
		{
			listeners.set(name, [call]);
		}
	}
	
	public inline function unlisten(listener : String, call: EListener) 
	{ 
		var l = listeners.get(listener);
		l.remove(call); 
		if (l.length < 1)
			listeners.remove(listener);
	}
	
	public inline function unlistenAll(listener : String) { listeners.remove(listener); }
	
	public function listenerNames() 
	{
		var ar = new Array<String>(); for (n in listeners.keys()) ar.push(n); return ar;
	}

}
