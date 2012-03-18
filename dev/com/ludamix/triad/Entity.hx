package com.ludamix.triad;

class Entity
{
	
	public var tagindex : Hash<Array<Dynamic>>;
	public var ids : IntHash<Dynamic>;
	public var idCt : Int;
	public var toDestroy : Array<Int>;

	public function new()
	{
		toDestroy = new Array();
		tagindex = new Hash();
		ids = new IntHash();
		idCt = 0;
	}
	
	public function addEntity() : Dynamic
	{
		while (ids.exists(idCt))
			{idCt++;}
		var ent = {id:idCt,tags:new Array<String>(),onDeath:new Array<Dynamic->Void>()};
		ids.set(idCt,ent);
		idCt++;
		
		return ent;
	}

	public function removeEntity(ent : Dynamic)
	{
		toDestroy.remove(ent.id);
		toDestroy.push(ent.id);
	}
	
	public function removeEntityId(id : Int)
	{
		var ent = ids.get(id);
		if (ent==null)
			throw "Removing entity id that doesn't exist: "+Std.string(id);
		else
			removeEntity(ent);
	}
	
	public function tags(ent : Dynamic, tt : Array<String>)
	{
		for (t in tt)
		{
			tag(ent, t);
		}
	}
	
	public function tag(ent : Dynamic, t : String)
	{
		ent.tags.push(t);
		var tidx = gettagindex(t);
		tidx.push(ent);
	}
	
	public function untag(ent : Dynamic, t : String)
	{
		ent.tags.remove(t);
		var tidx = gettagindex(t);
		tidx.remove(ent);
	}
	
	public function hastag(ent : Dynamic, t : String)
	{
		for (n in cast(ent.tags,Array<Dynamic>))
		{
			if (n==t)
				return true;
		}
		return false;
	}
	
	public function update()
	{
		for (id in toDestroy)
		{
			var ent = ids.get(id);
			ids.remove(id);
			for (t in cast(ent.tags.copy(),Array<Dynamic>))
			{
				untag(ent,t);
			}
			for (d in cast(ent.onDeath, Array<Dynamic>))
				d(ent);
		}
		toDestroy = new Array();
	}

	public inline function index(t : String) : Array<Dynamic>
	{
		var tidx = tagindex.get(t);
		if (tidx == null)
		{
			tidx = new Array();
			tagindex.set(t,tidx);
		}
		return tidx;		
	}

}
