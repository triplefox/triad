package com.ludamix.triad.geom;

class BinPacker
{
	
	public var nodes : Array<PackerNode>;
	
	public function new(w:Float,h:Float,stuff : Array<{contents:Dynamic,w:Float,h:Float}>)
	{
		stuff.sort(function(a, b):Int { return a.w * a.h - b.w * b.h; } );
		nodes.push(new PackerNode(0, 0, w, h));
		while (stuff.length > 0)
		{
			var d = stuff.shift();
			
			var findNode = function(cur : PackerNode) {
				if (!cur.occupied() && d.w<=cur.w && d.h<=cur.h) return cur;
				var right = findNode(cur.right);
				if (right != null) return right;
				var down = findNode(cur.down);
				return down;
			}
			
			var cur = findNode(nodes[0]);
			if (cur == null) throw "size overflow";
			cur.add(d.contents, d.w, d.h);
		}
	}
	
}

class PackerNode
{
	
	public var down : PackerNode;
	public var right : PackerNode;
	public var x : Float;
	public var y : Float;
	public var w : Float;
	public var h : Float;
	public var contents : Dynamic;
	
	public function new(x,y,w,h)
	{
		this.x = x;
		this.y = y;
		this.w = w;
		this.h = h;
	}
	
	public inline function add(contents : Dynamic, contents_w : Float, contents_h : Float)
	{
		this.contents = contents;
		var nw = contents_w;
		var nh = contents_h;
		down = new PackerNode(x,y+nh,w, h - nh);
		right = new PackerNode(x + nw, y, w - nw, h);
		this.w = nw;
		this.h = nh;
		return [down, right];
	}
	
	public inline function occupied()
	{
		contents != null;
	}
	
}