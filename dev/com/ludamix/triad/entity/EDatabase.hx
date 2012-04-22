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
 * The system has, built-in:
 * 
 * 	  1. Spawning: An array of "listener templates" is passed in. The templates are combined,
 *       and the "spawn" listener is called by default.
 *    2. Despawning: Entities have to ask to be despawnable via the createDespawnable template.
 *       Then on calling "despawn" they are queued for removal. In the main loop, when flushEntities() is called,
 *       the events in "on_despawn" are performed. This allows a mix of deferred and immediate actions to be taken.
 *    2. Tags and property bags. Apply the createTag and createBag templates.
 * 
 */

typedef ListenerHash = Hash<Array<Dynamic>>; 
typedef EStack = List<ERow>;
typedef EListener = Dynamic->EStack->Dynamic->Dynamic;

class EDatabase
{
	
	public var rows : IntHash<ERow>;
	public var id_increment : Int;
	
	public var tags : Hash<Array<ERow>>;
	public var bags : Array<Dynamic>;
	public var removequeue : Array<ERow>;
	
	public function new()
	{
		rows = new IntHash();
		tags = new Hash();
		bags = new Array();
		removequeue = new Array();
		id_increment = 0;
	}
	
	private function getFreeId()
	{
		while (rows.exists(id_increment))
			id_increment++;
		return id_increment;
	}
	
	public function spawn(listener_objects : Array<Dynamic>, ?andCall = "spawn")
 	{
		// spawns an object based on any number of listener template objects stacked together
		var obj : Dynamic = { };
		for (lo in listener_objects)
		{
			for (f in Reflect.fields(lo))
			{
				var content : Dynamic = Reflect.field(lo, f);
				var existing = Reflect.field(obj, f);
				if (existing == null)
				{
					Reflect.setProperty(obj, f, content);
				}
				else
				{
					for (c in cast(content,Array<Dynamic>)) existing.push(c);
				}
			}
		}
		
		var h = new ListenerHash();
		for (f in Reflect.fields(obj))
		{
			var content = Reflect.field(obj, f);
			h.set(f, content);
		}
		var row = new ERow(getFreeId(), h);
		rows.set(row.id, row);
		if (andCall != null) call(row, andCall);
		return row;
	}
	
	public inline function call(target : ERow, listener : String, ?payload : Dynamic = null,
		?stack : EStack=null) : Dynamic
	{
		if (stack==null)
			return target.call(this, new EStack(), listener, payload);
		else
			return target.call(this, stack, listener, payload);
	}
	
	public function createTags(names_input : Array<String>)
	{
		var names = names_input;
		var do_spawn : Dynamic = null;
		var do_get : Dynamic = null;
		var do_tag : Dynamic = null;
		var do_untag : Dynamic = null;
		var on_despawn : Dynamic = null;
		
		do_get = function(db : EDatabase, stack : EStack, payload : Dynamic) 
		{ if (payload == null) throw "pass in an array"; else 
			{for (name in names) {payload.push(name);} return payload;} }
		do_tag = function(db : EDatabase, stack : EStack, payload : Dynamic) 
		{ 
			names.push(payload);  
			var tagset : Array<ERow> = tags.get(payload);
			if (tagset==null)
			{
				tagset = new Array(); tags.set(payload, tagset);
			}
			tagset.push(stack.last());
		}
		do_untag = function(db : EDatabase, stack : EStack, payload : Dynamic) 
		{ 
			names.remove(payload);  
			var tagset : Array<ERow> = tags.get(payload);
			if (tagset!=null)
			{
				tagset.remove(stack.last());
			}
		}
		do_spawn = function(db : EDatabase, stack : EStack, payload : Dynamic) 
		{
			for (p in names)
			{
				var tagset : Array<ERow> = tags.get(p);
				if (tagset==null)
				{
					tagset = new Array(); tags.set(p, tagset);
				}
				tagset.push(stack.last());
			}
		}
		on_despawn = function(db : EDatabase, stack : EStack, payload : Dynamic) 
		{ 
			for (n in names)
			{
				var tagset : Array<ERow> = tags.get(n);
				if (tagset!=null)
				{
					tagset.remove(stack.last());
				}
			}
		}
		return { tags:[do_get], tag:[do_tag], untag:[do_untag], spawn:[do_spawn], on_despawn:[on_despawn] };
	}
	
	public function createBag(name : String, data : Dynamic)
	{
		var do_spawn : Dynamic = null;
		var do_get : Dynamic = null;
		var on_despawn : Dynamic = null;
		do_spawn = function(db : EDatabase, stack : EStack, payload : Dynamic) 
			{ bags.push(data); }
		do_get = function(db : EDatabase, stack : EStack, payload : Dynamic) 
			{ return data; }
		on_despawn = function(db : EDatabase, stack : EStack, payload : Dynamic) 
			{ bags.remove(data); }
		return { name:[do_get], spawn:[do_spawn], on_despawn:[on_despawn] };		
	}
	
	public function createDespawnable()
	{
		return {
			despawn:[function(db : EDatabase, stack : EStack, payload : Dynamic)
				{ var me = stack.last(); db.removequeue.remove(me); db.removequeue.push(me); } ]
		};
	}
	
	public function flushEntities()
	{
		while(removequeue.length>0)
		{
			var n = removequeue.pop();
			call(n, "on_despawn");
			rows.remove(n.id);
		}
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
		stack : EStack, listener : String, ?payload : Dynamic = null) : Dynamic
	{
		var result = null;
		var lar : Array<Dynamic> = listeners.get(listener);
		if (lar != null)
		{
			stack.add(this);
			for (l in lar)
			{
				var copy = new EStack();
				for (n in stack) copy.add(n);
				result = l(db, copy, payload);
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
