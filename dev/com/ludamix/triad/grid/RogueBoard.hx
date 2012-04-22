package com.ludamix.triad.grid;
import com.ludamix.triad.ascii.ASCIIMap;
import com.ludamix.triad.grid.ObjectGrid;
import com.ludamix.triad.entity.EDatabase;

typedef RogueTileLayers = Array<ObjectGrid<Dynamic>>;

class RogueActor
{
	public var id:ERow; public var x:Int; public var y:Int; public var repr:RogueActor->RogueRepr;
	public function new(id, x, y, repr) { this.id = id; this.x = x; this.y = y; this.repr = repr; }
}

class RogueRepr 
{ 
	public var char : Int; public var bg : Int; public var fg : Int; public var priority : Int;
	public function new(char, bg, fg, priority) { this.char = char; this.bg = bg; this.fg = fg; this.priority = priority; } 
}

class RogueBoard
{
	
	// A highly generalized board for a roguelike-type game, or any game using tile scale for all actors.
	
	public var tiles : RogueTileLayers;
	public var actors : Array<RogueActor>;
	public var actorsSpatial : Hash<Array<RogueActor>>;
	public var reprOutsideWorld : RogueRepr;
	public var dirty : Array<Bool>;
	
	public function setTile(x : Int, y : Int, z : Int, data : Dynamic)
	{
		var pos = tiles[z].c21(x, y);
		tiles[z].world[pos] = data;
		dirty[pos] = true;
	}
	
	public inline function setDirty(x : Int, y : Int)
	{
		var pos = tiles[0].c21(x, y);
		dirty[pos] = true;
	}
	
	public function new(w,h,pop,layers,reprOutsideWorld)
	{
		tiles = new Array();
		for (n in 0...layers)
			tiles.push(new ObjectGrid(w, h, 1, 1, pop));
		actors = new Array();
		actorsSpatial = new Hash();
		dirty = new Array();
		for (n in 0...w * h) dirty.push(true);
		this.reprOutsideWorld = reprOutsideWorld;
	}
	
	public inline function layer(idx : Int) : ObjectGrid<Dynamic> { return tiles[idx]; }
	
	public inline function infos(x, y)
	{
		var _tiles = new Array<Dynamic>();
		if (!outOfBounds(x,y))
		{
			for (layer in this.tiles)
			{
				_tiles.push(layer.c2t(x, y));
			}
		}
		var _actors = actorsSpatial.get(spatialPos(x,y));
		if (_actors == null)
			return {tiles:_tiles,actors:[]};
		else if (_actors.length > 0)
			return {tiles:_tiles,actors:_actors.copy()};
		else
			return {tiles:_tiles,actors:_actors};
	}
	
	public function cameraTL(x, y, w, h, amap : ASCIIMap)
	{
		var pos = 0;
		var final = new RogueRepr(
			reprOutsideWorld.char, reprOutsideWorld.bg, reprOutsideWorld.fg, reprOutsideWorld.priority);
		for (yy in 0...h)
		{
			for (xx in 0...w)
			{
				if (dirty[pos])
				{
					dirty[pos] = false;
					var candidates = new Array<RogueRepr>();
					var info = infos(x + xx, y + yy);
					for (a in info.actors)
					{
						candidates.push(a.repr(a));
					}
					if (info.tiles.length < 1)
					{
						candidates.push(reprOutsideWorld);
					}
					else
						{for (n in 0...info.tiles.length) candidates.push(info.tiles[n].repr); };
					if (candidates.length>1)
						candidates.sort(function(a, b) { return a.priority - b.priority; } );
					for (n in candidates)
					{
						if (n.char >= 0) final.char = n.char;
						if (n.bg >= 0) final.bg = n.bg;
						if (n.fg >= 0) final.fg = n.fg;
					}
					amap.char.world[amap.char.c21(xx, yy)] = ASCIIMap.encode(final.bg, final.fg, final.char);
				}
				pos++;
			}
		}
	}
	
	public inline function outOfBounds(x, y)
	{
		return (x < 0 || y < 0 || x >= tiles[0].worldW || y >= tiles[0].worldH);
	}
	
	public function cameraC(x, y, w, h, amap : ASCIIMap)
	{
		return cameraTL(x - (w >> 1), y - (h >> 1), w, h, amap);
	}
	
	private inline function spatialPos(x, y) { return Std.string(x) + "_" + Std.string(y); }
	
	private inline function spatialActorSet(act : RogueActor)
	{
		var pos = spatialPos(act.x, act.y);
		var aar = actorsSpatial.get(pos);
		if (aar == null)
			{ aar = new Array<RogueActor>(); actorsSpatial.set(pos, aar); }
		aar.push(act);
		if (!outOfBounds(act.x,act.y))
			dirty[tiles[0].c21(act.x,act.y)] = true;
	}
	
	private inline function spatialActorRemove(act : RogueActor)
	{
		var pos = spatialPos(act.x, act.y);
		var aar = actorsSpatial.get(pos);
		aar.remove(act);
		if (!outOfBounds(act.x,act.y))
			dirty[tiles[0].c21(act.x,act.y)] = true;
	}
	
	public function createActor(x : Int, y : Int, repr : Dynamic->RogueRepr)
	{
		var act = new RogueActor(null, x, y, repr);
		var self = this;
		return {
			spawn:[function(db : EDatabase, stack : EStack, payload : Dynamic)
				{ act.id = stack.last(); actors.push( act ); spatialActorSet(act); } ],
			on_despawn:[function(db : EDatabase, stack : EStack, payload : Dynamic)
				{ actors.remove( act ); spatialActorRemove(act); } ],
			move:[function(db : EDatabase, stack : EStack, payload : Dynamic)
				{ spatialActorRemove(act);  act.x += payload.x; act.y += payload.y; spatialActorSet(act);  } ],
			move_wraparound:[function(db : EDatabase, stack : EStack, payload : Dynamic)
				{ spatialActorRemove(act); 
				  act.x = (act.x + payload.x) % layer(0).worldW;
				  act.y = (act.y + payload.y) % layer(0).worldH;
				  spatialActorSet(act); } ],
			teleport:[function(db : EDatabase, stack : EStack, payload : Dynamic)
				{ spatialActorRemove(act);  act.x = payload.x; act.y = payload.y; spatialActorSet(act);  } ],
			up:[function(db : EDatabase, stack : EStack, payload : Dynamic)
				{ stack.last().call(db, stack, "move", { x:0, y: -1 } ); } ],
			down:[function(db : EDatabase, stack : EStack, payload : Dynamic)
				{ stack.last().call(db, stack, "move", {x:0,y:1} ); } ],
			left:[function(db : EDatabase, stack : EStack, payload : Dynamic)
				{ stack.last().call(db, stack, "move", {x:-1,y:0} ); } ],
			right:[function(db : EDatabase, stack : EStack, payload : Dynamic)
				{ stack.last().call(db, stack, "move", {x:1,y:0} ); } ],
			position:[function(db : EDatabase, stack : EStack, payload : Dynamic)
				{ return { x:act.x, y:act.y }; } ],
			position_wraparound:[function(db : EDatabase, stack : EStack, payload : Dynamic)
				{ return { x:act.x%layer(0).worldW, y:act.y%layer(0).worldH }; } ],
			board:[function(db : EDatabase, stack : EStack, payload : Dynamic)
				{ return self; } ],
			actor:[function(db : EDatabase, stack : EStack, payload : Dynamic)
				{ return act; } ],
			};
	}
	
}