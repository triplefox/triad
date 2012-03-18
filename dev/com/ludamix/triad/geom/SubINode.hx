package com.ludamix.triad.geom;

class SubINode extends SubIPoint
{
	
	/*
	 * A node containing a tree relationship.
	 * 
	 * Ideal for the "top-level" container of sprites; define the static bounds and points as a Framing,
	 * then composite them with a SubINode for real-time positioning.
	 * 
	 * Example:
	 * 
	 * var cameraPos = SubINode.fromFloat(0.,0.);
	 * var playerPos = SubINode.fromFloat(0.,0.);
	 * 
	 * var camFrame = Framing.fromDef({tlrects:null,crects:{x:0.,y:0.,w:512,h:512},points:null});
	 * var playerFrame = Framing.fromDef({tlrects:null,crects:{x:0.,y:0.,w:32,h:32},points:null});
	 * 
	 * var camRel = cameraPos.rect(camFrame);
	 * var playerRel = playerPos.rect(playerFrame);
	 * 
	 * var spriteXY = playerRel.tlGen();
	 * spriteXY.sub(camRel.tlGen());
	 * 
	 * */
	
	public var parent : SubINode;
	
	public function new(x : Int, y : Int, ?parent : SubINode = null)
	{
		this.parent = parent;
		super(x, y);
	}
	
	public static override function fromInt(x:Int, y:Int, ?parent : SubINode = null)
	{
		return new SubINode(SubIPoint.shift(x), SubIPoint.shift(y), parent);		
	}
	
	public static override function fromFloat(x:Int, y:Int, ?parent : SubINode = null)
	{
		return new SubINode(SubIPoint.shiftF(x), SubIPoint.shiftF(y), parent);		
	}
	
	public inline function pos(fp : SubIPoint)
	{
		var cur = this;
		var x = cur.x;
		var y = cur.y;
		while (cur.parent != null)
		{
			cur = cur.parent;
			x += cur.x;
			y += cur.y;
		}
		fp.x = x;
		fp.y = y;
	}
	
	public inline function addpos(fp : SubIPoint)
	{
		var cur = this;
		var x = cur.x;
		var y = cur.y;
		while (cur.parent != null)
		{
			cur = cur.parent;
			x += cur.x;
			y += cur.y;
		}
		fp.x += x;
		fp.y += y;
	}
	
	public inline function rectNoAlloc(pivot : AABB, result : AABB, tmp : SubIPoint)
	{
		pos(tmp);
		result.x = tmp.x + pivot.x;
		result.y = tmp.y + pivot.y;
		result.w = pivot.w;
		result.h = pivot.h;
	}
	
	public inline function rect(pivot : AABB)
	{
		var tmp = new SubIPoint(this.x, this.y);
		var result = new AABB(0, 0, 0, 0);
		rectNoAlloc(pivot, result, tmp);
		return result;
	}
		
	public inline function hotpointNoAlloc(pivot : SubIPoint, result : SubIPoint)
	{
		pos(result);
		result.add(pivot);
	}
	
	public inline function hotpoint(pivot : SubIPoint)
	{
		var result = new SubIPoint(pivot.x, pivot.y);
		addpos(result);
		return result;
	}
	
}
