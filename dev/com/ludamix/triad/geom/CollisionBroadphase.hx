package com.ludamix.triad.geom;
import com.ludamix.triad.tools.MathTools;

class BroadphaseNode
{

	public var point : SubINode;
	public var velocity : SubIPoint;
	public var aabb : AABB;
	public var history : Array<SubIPoint>;
	public var history_size : Int;
	public var id : Int;
	public var masksend : Int;
	public var maskrecieve : Int;
	
	public function new(point,aabb,velocity,id,masksend,maskrecieve,history_size)
	{
		this.point = point;
		this.aabb = aabb;
		this.velocity = velocity;
		this.id = id;
		this.masksend = masksend;
		this.maskrecieve = maskrecieve;
		this.history_size = history_size;
		if (history_size>0)
			this.history = new Array();
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
			nodes_pool.push(new BroadphaseNode(new SubINode(0,0,null),null,new SubIPoint(0,0),n,1,1,0));
		for (n in 0...contact_poolsize)
			contacts_pool.push(new BroadphaseContact());
		
	}
	
	public function add(point : SubINode, aabb : AABB, velocity : SubIPoint,
		id : Int, masksend : Int, maskrecieve : Int, history_size : Int) : BroadphaseNode
	{
		var n : BroadphaseNode = null;
		if (nodes_pool.length > 0)
			{ n = nodes_pool.pop(); n.aabb = aabb; n.point = point; n.id = id; n.velocity = velocity;
			  n.maskrecieve = maskrecieve; n.masksend = masksend; n.history_size = history_size; }
		else
			n = new BroadphaseNode(point, aabb, velocity, id, masksend, maskrecieve, history_size);
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
		var temp_point = new SubIPoint(0, 0);
		
		// TODO: integrate getRejectionVector (need some mechanism to test for pushout control)
		// history rollbacks(see below)
		
		// we should rework this so that we can do additional passes that move+iterate on historical data.
		// for right now, history is stubbed out until a testcase arises. The usual testcase is a game in which
		// some kind of disappearing/reappearing barrier occurs, trapping the player - a few frames of historical data
		// is sufficient to allow the player to move fluidly as barriers close.
		
		// The general concept is that after the initial broadphase, nodes with a null movement vector are treated
		// to an indefinite number of other passes that reinsert them in the nodelist at new positions, 
		// scanning for contacts while doing the insert.
		// Every time we detect contacts, the position is rejected and we restart the insert with the next history node,
		// until none are left (at which point we use the original position)
		
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
	
	private function getRejectionVector(node : BroadphaseNode, others : Array<AABB>)
	{
		/*
		 * Project the node into the "others."
		 * We do this in several passes, each one produces new candidate velocities.
		 * We continue until all candidates are eliminated, or all candidates pass.
		 * If candidates pass, use a heuristic to find the candidate with the nearest result to the original velocity.
		 * If no candidates exist but the node has historical data, we let the broadphase know it should try iterating
		 * through that data.
		 * */
		
		var original = new AABB(node.point.x + node.aabb.x, node.point.y + node.aabb.y, node.aabb.w, node.aabb.h);
		var projection = new AABB(original.x + node.velocity.x, original.y + node.velocity.y, original.w, original.h);		
		
		var candidates = new Array<AABB>();
		
		// generate initial candidates by testing against each box.
		for (o in others)
		{
			var result = projection.separatingAxis(o);
			var add = true;
			for (c in candidates) { if (c.x == result.x && c.y == result.y) { add = false; break; }}
			if (add) candidates.push(result);
		}
		
		// modify candidates by allowing them to be projected a second time.
		for (c in candidates)
		{
			for (o in others)
			{
				var result = c.separatingAxis(o);
				c.x = result.x;
				c.y = result.y;
			}
		}
		
		// eliminate candidates that are still overlapping after second pass.
		var ncandidates = new Array<AABB>();
		for (c in candidates)
		{
			var fail = false;
			for (o in others)
			{
				if (c.intersectsAABB(o)) { fail = true; break; }
			}
			if (!fail)
				ncandidates.push(c);
		}
		candidates = ncandidates;
		
		// if no more candidates remain, go back one step through history and ask for the check to be run again
		// by returning a null, until we run out of history.
		if (candidates.length == 0)
		{
			if (node.history_size > 0) throw "history is currently unsupported";
			if (node.history == null || node.history.length<1) { return new SubIPoint(0, 0); }
			else return null;
		}
		else // find the nearest candidate to the original.
		{
			var b = candidates.shift();
			var best = { dist:MathTools.sqrDist(b.x, b.y, projection.x, projection.y), aabb:b };
			for (c in candidates)
			{
				var dist = MathTools.sqrDist(c.x, c.y, projection.x, projection.y);
				if (dist < best.dist) { best.dist = dist; best.aabb = c; }
			}
			node.point.x = best.aabb.x;
			node.point.y = best.aabb.y;
			return new SubIPoint(best.aabb.x - original.x, best.aabb.y - original.y);
		}
	}	

}