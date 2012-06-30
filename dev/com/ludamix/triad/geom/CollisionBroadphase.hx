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
	
	public function add(point : SubINode, aabb : AABB, id : Int, masksend : Int, maskrecieve : Int) : BroadphaseNode
	{
		var n : BroadphaseNode = null;
		if (nodes_pool.length > 0)
			{ n = nodes_pool.pop(); n.aabb = aabb; n.point = point; n.id = id;
			  n.maskrecieve = maskrecieve; n.masksend = masksend; }
		else
			n = new BroadphaseNode(point, aabb, id, masksend, maskrecieve);
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
		if (contacts_pool.length > 0) return contacts_pool.pop();
		else return new BroadphaseContact();
	}
	
	private static function emptyTest(a : AABB) : Array<Int> { return null; }
	
	public function update(?additional_test : AABB->Array<Int> = null) : Array<BroadphaseContact>
	{
		if (additional_test == null) additional_test = emptyTest;
	
		contacts_pool.concat(contacts);
		contacts = new Array();
		
		// sort and prune implementation
		
		nodes.sort(nodeSorter);
		
		var pivot_rect = new AABB(0, 0, 1, 1);
		var compare_rect = new AABB(0, 0, 1, 1);
		var temp_point = new SubIPoint(0,0);
		
		for (idx in 0...nodes.length-1)
		{
			var n : BroadphaseNode = nodes[idx];
			n.point.rectNoAlloc(n.aabb, pivot_rect, temp_point);
			var test_result = additional_test(pivot_rect);
			if (test_result != null) 
			{
				for (r in test_result)
				{
					var contact = getContact(); contact.a = n.id; contact.b = r;
					contacts.push(contact);
				}
			}
			var lookahead = idx + 1;
			while(lookahead < nodes.length)
			{
				var m = nodes[lookahead];
				m.point.rectNoAlloc(m.aabb, compare_rect, temp_point);
				if (compare_rect.l() <= pivot_rect.r())
				{
					if ((m.maskrecieve & n.masksend) > 0 && compare_rect.intersectsAABB(pivot_rect))
					{
						var contact = getContact(); contact.a = n.id; contact.b = m.id;
						contacts.push(contact);
					}
				}
				else break;
				lookahead++;
			}
		}
		
		return contacts;
	}

}