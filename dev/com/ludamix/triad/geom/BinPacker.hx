package com.ludamix.triad.geom;

class BinPacker
{
	
	public var nodes : Array<PackerNode>;
	
	public function new(w:Float,h:Float,stuff : Array<{contents:Dynamic,w:Float,h:Float}>)
	{
		stuff.sort(function(a, b):Int { return Std.int(b.h - a.h); } );
		nodes = new Array();
		
		while (stuff.length > 0)
		{
			var d = stuff.shift();
			var n = new PackerNode(d.contents, 0, 0, d.w, d.h);
			var fail = true;
			var min_y = h;
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
							{ fail = true; n.x = Math.max(n.x + 1, test.r()); 
							  min_y = Math.min(min_y, test.y + test.h - n.y); break; }
						}
					}
				}
				if (fail) n.y+= min_y;
			}
			if (fail) throw "size overflow";
			else 
			{ 
				nodes.push(n);
				nodes.sort(function(a, b) { 
						return Std.int(a.x - b.x);
					} );
			}
		}
	}
	
}

class PackerNode
{
	
	public var x : Float;
	public var y : Float;
	public var w : Float;
	public var h : Float;
	public var contents : Dynamic;
	
	public function new(contents : Dynamic, x,y,w,h)
	{
		this.contents = contents;
		this.x = x;
		this.y = y;
		this.w = w;
		this.h = h;
	}
	
	public inline function l() { return x; }
	public inline function r() { return x+w; }
	public inline function t() { return y; }
	public inline function b() { return y+h; }
	
	public inline function intersect(other : PackerNode)
	{
		return (!((this.r() <= other.l()) || (this.l() >= other.r()) || (this.b() <= other.t()) || (this.t() >= other.b())));
	}
	
	public inline function intersectVert(other : PackerNode)
	{
		return (!((this.b() <= other.t()) || (this.t() >= other.b())));
	}
	
}