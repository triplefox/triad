package com.ludamix.triad.geom;

typedef BinPackerInput = { contents:Dynamic, w:Float, h:Float };
typedef BinPackerStuff = { > BinPackerInput, id : Int};

class BinPacker
{
	
	public var nodes : Array<PackerNode>;
	
	public function new(w:Float,h:Float,inputs: Array<BinPackerInput>, ?skipx=1, ?always_rescan=false)
	{
		// take the inputs and assign ids, then sort by height(this helps pack efficiency)
		
		var stuff = new Array<BinPackerStuff>();
		
		var id = 0;
		for (n in inputs)
			{ stuff.push( { contents:n.contents, w:n.w, h:n.h, id:id } ); id++; }
		stuff.sort(function(a, b):Int { return Std.int(b.h - a.h); } );
		nodes = new Array();
		
		var starty = 0.;
		
		while (stuff.length > 0)
		{
			var d = stuff.shift();
			var n = new PackerNode(d.contents, 0, starty, d.w, d.h, d.id);
			var fail = true;
			var min_y = h;
			
			// collision test - run through each line left to right, top to bottom;
			// we use a sort+prune to optimize the collision
			
			while (n.b() < h && fail)
			{
				n.x = 0.;
				var left = 0;
				var right = 0;
				while (n.r() < w && fail)
				{
					fail = false;
					while (left < nodes.length && nodes[left].r() <= n.l())
						left++;
					while (right < nodes.length && nodes[right].l() <= n.r())
						right++;
					for (test_idx in left...right)
					{
						var test = nodes[test_idx];
						if (test.intersect(n))
						{
							{ fail = true; n.x = Math.max(n.x + skipx, test.r()); 
							  min_y = Math.min(min_y, test.y + test.h - n.y); break; }
						}
					}
				}
				if (fail) n.y+= min_y;
			}
			if (fail) throw "size overflow";
			else 
			{ 
				if (!always_rescan) starty = n.y; // we never look back at previous finished lines with this optimization
				nodes.push(n);
				nodes.sort(function(a, b) { 
						return Std.int(a.x - b.x);
					} );
			}
		}
		// make the nodes match the original input order
		nodes.sort(function(a, b) { return a.id - b.id; } );
	}
	
}

class PackerNode
{
	
	public var x : Float;
	public var y : Float;
	public var w : Float;
	public var h : Float;
	public var contents : Dynamic;
	public var id : Int;
	
	public function new(contents : Dynamic, x,y,w,h,id)
	{
		this.contents = contents;
		this.x = x;
		this.y = y;
		this.w = w;
		this.h = h;
		this.id = id;
	}
	
	@:extern public inline function l() { return x; }
	@:extern public inline function r() { return x+w; }
	@:extern public inline function t() { return y; }
	@:extern public inline function b() { return y+h; }
	
	@:extern public inline function intersect(other : PackerNode)
	{
		return (!((this.r() <= other.l()) || (this.l() >= other.r()) || (this.b() <= other.t()) || (this.t() >= other.b())));
	}
	
}