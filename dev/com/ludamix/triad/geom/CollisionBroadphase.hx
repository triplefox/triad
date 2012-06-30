package com.ludamix.triad.geom;

class BroadphaseNode
{

	public var point : SubINode;
	public var aabb : AABB;
	public var id : Int;
	public var masksend : Int;
	public var maskrecieve : Int;
	
	public function new(point,aabb,id,masksend,maskrecieve)
	{
		this.point = point;
		this.aabb = aabb;
		this.id = id;
		this.masksend = masksend;
		this.maskrecieve = maskrecieve;
	}

}

class BroadphaseContact
{
	public var a : Int; public var b : Int;
	public function new() { a = 0; b = 0; }
}

class CollisionBroadphase
{

	public var nodes_pool : Array<BroadphaseNode>;
	public var nodes : Array<BroadphaseNode>;
	
	public var contacts_pool : Array<BroadphaseContact>;
	public var contacts : Array<BroadphaseContact>;

	public function new(?node_poolsize : Int = 32, ?contact_poolsize : Int = 32)
	{
		nodes_pool = new Array(); nodes = new Array();
		contacts_pool = new Array(); contacts = new Array();
	
		for (n in 0...node_poolsize)
			nodes_pool.push(new BroadphaseNode(new SubINode(0,0,null),null,n,1,1));
		for (n in 0...contact_poolsize)
			contacts_pool.push(new BroadphaseContact());
		
	}
	
	public function add(point : SubINode, aabb : AABB, id : Int, mask : Int) : BroadphaseNode
	{
		var n : BroadphaseNode = null;
		if (nodes_pool.length > 0)
			{ n = nodes_pool.pop(); n.aabb = aabb; n.point = point; n.id = id; n.mask = mask; }
		else
			n = new BroadphaseNode(point, aabb, id, mask);
		nodes.push(n);
		return n;
	}
	
	public function remove(n : BroadphaseNode)
	{
		nodes.remove(n);
		nodes_pool.push(n);
	}
	
	private function nodeSorter(a : BroadphaseNode, b : BroadphaseNode) : Int { return b.point.x - a.point.x; }
	
	private inline function getContact() 
	{
		if (contacts_pool.length > 0) return contacts.pop();
		else return new BroadphaseContact();
	}
	
	private function emptyTest(a : AABB) : Array<Int> { return null; }
	
	public function update(?additional_test : AABB->Array<Int> = emptyTest) : Array<BroadphaseContact>
	{
		contacts_pool.concat(contacts);
		contacts = new Array();
		
		// sort and prune implementation
		
		nodes.sort(nodeSorter);
		
		var temp_rect = new AABB(0, 0, 1, 1);
		var temp_rect_2 = new AABB(0, 0, 1, 1);
		var temp_point = new SubIPoint(0,0);
		
		for (idx in 0...nodes.length)
		{
			var n : BroadphaseNode = nodes[idx];
			var pivot_rect : AABB = n.point.rectNoAlloc(n.aabb, temp_rect, temp_point);
			var test_result = emptyTest(pivot_rect);
			for (r in test_result)
			{
				var contact = getContact(); contact.a = n.id; contact.b = r;
				contacts.push(contact);
			}
			for (lookahead in idx...nodes.length)
			{
				var m = nodes[lookahead];
				var compare_rect : AABB = m.point.rectNoAlloc(m.aabb, temp_rect_2, temp_point);
				if (compare_rect.l() <= pivot_rect.r())
				{
					if ((m.maskrecieve & n.masksend) > 0 && compare_rect.intersectsAABB(pivot_rect))
					{
						var contact = getContact(); contact.a = n.id; contact.b = m.id;
						contacts.push(contact);
					}
				}
				else break;
			}
		}
		
	}

}