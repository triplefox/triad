package com.ludamix.triad.tools;

class GeomTools
{

	public static inline var PAD = 0.000001;

	// some basic vector functions

	public static inline function dot2D(ax : Float, ay : Float, bx : Float, by : Float):Float
	{ return ax * bx + ay * by; }
	
	public static inline function cross2D(ax : Float, ay : Float, bx : Float, by : Float):Float
	{ return ax * by - bx * ay; }
	
	public static inline function unit2D(ax : Float, ay : Float) 
	{ var d = MathTools.dist(0., 0., ax, ay); return { x:ax/d, y:ay/d }; }
	
	public static inline function perpendicular2D(ax : Float, ay : Float) { return { x: -ay, y:ax }; }
	
	public static inline function projection2D2D(ax : Float, ay : Float, bx : Float, by : Float)
	{
		var u = unit2D(bx, by);
		return dot2D(ax, ay, u.x, u.y);
	}

	// functions to project a line segment onto an offset axis...meant for SAT
	
	public static inline function projectSegmentAABB(x1 : Float, y1 : Float, 
		x2 : Float, y2 : Float, left : Float, top : Float, right : Float, bottom : Float) : 
			Array<{ x1:Float, y1:Float, x2:Float, y2:Float }>
	{		
		// note - this really isn't ideal to use for collision because it's possible for the segment to escape
		// in between the edges of two flush AABBs - use a small AABB instead (e.g. 2x2) and it'll be fine
		if (AABBPoint(x2, y2, left, top, right, bottom))
		{
			// return all candidates (leave it to the top level to figure out which is preferred)
			return [ { x2:x2, y2:top - PAD, x1:x1, y1:y1 },			
				{ x2:x2, y2:bottom + PAD, x1:x1, y1:y1 },			
				{ x2:left - PAD, y2:y2, x1:x1, y1:y1 },				
				{ x2:right + PAD, y2:y2, x1:x1, y1:y1 } ];				
		}
		else return [{ x1:x1, y1:y1, x2:x2, y2:y2 }];
		
	}
	
	public static inline function projectAABBAABB(prev_x : Float, prev_y : Float,
		cur_x : Float, cur_y : Float, width : Float, height : Float,
		bleft : Float, btop : Float, bright : Float, bbottom : Float) : 
			Array<{ x1:Float, y1:Float, x2:Float, y2:Float }>
	{
		if (AABBAABB(cur_x, cur_y, cur_x+width, cur_y+height, bleft, btop, bright, bbottom))
		{
			// return all candidates (leave it to the top level to figure out which is preferred)
			return [ { x2:cur_x, y2:btop - height - PAD, x1:prev_x, y1:prev_y },			
				{ x2:cur_x, y2:bbottom + PAD, x1:prev_x, y1:prev_y },			
				{ x2:bleft - width - PAD, y2:cur_y, x1:prev_x, y1:prev_y },				
				{ x2:bright + PAD, y2:cur_y, x1:prev_x, y1:prev_y } ];				
		}
		else return [{ x1:prev_x, y1:prev_y, x2:cur_x, y2:cur_y }];
		
	}
	
	// Finds the nearest point to another point "o" on the segment defined by ax ay bx by
	// this and projectSegmentCircle are ports of Python code. NOT TESTED YET
	public static inline function closestPointOnSegment(ax : Float, ay : Float, bx : Float, by : Float, 
		ox : Float, oy : Float)
	{
		var vx = bx - ax;
		var vy = by - ay;
		
		var pvx = ox - ax;
		var pvy = oy - ay;
		
		var v_dist_sqr = MathTools.sqrDist(0., 0., vx, vy);
		
		if (v_dist_sqr<=0)
			throw "Invalid segment length";
		var dist = Math.sqrt(v_dist_sqr);
		
		var unit = unit2D(vx, vy);		
		var proj = dot2D(pvx, pvy, dist, dist);
		
        if (proj <= 0) return { x:ax, y:by };
        else if (proj >= Math.sqrt(dist)) return { x:bx, y:by };
        else
		{
			var jx = unit.x * proj;
			var jy = unit.y * proj;
			
			return { x:jx + ax, y:jy + ay };
		}
	}

    public static inline function projectSegmentCircle(ax : Float, ay : Float, bx : Float, by : Float, 
												cx : Float, cy : Float, cradius : Float)
	{
        var closest = closestPointOnSegment(ax, ay, bx, by, cx, cy);
        var vx = cx - closest.x;
        var vy = cy - closest.y;
		var v_len = MathTools.dist(0., 0., vx, vy);
		
        if (v_len > cradius) return { x:0., y:0. };
        else if (v_len <= 0) { throw "Circle's center is exactly on segment"; return null; }
		else
		{
			var offset = unit2D(vx, vy);
			var multiplier = (cradius - v_len);
			offset.x *= multiplier;
			offset.y *= multiplier;
			return offset;
		}
	}
	
	// functions to detect a collision
	
	public static inline function AABBPoint(x : Float, y : Float,
									left : Float, top : Float, right : Float, bottom : Float)
	{
		return (!(x < left || y < top || x > right || y > bottom ));
	}
	
	public static inline function AABBAABB(aleft : Float, atop : Float, aright : Float, abottom : Float,
									bleft : Float, btop : Float, bright : Float, bbottom : Float)
	{
		return (!(aright < bleft || abottom < btop || aleft > bright || atop > bbottom ));
	}

	public static inline function AABBCircleNearest(aleft : Float, atop : Float, aright : Float, abottom : Float,
									bx : Float, by : Float, bradius : Float) : {x:Float,y:Float}
	{
		var closest_x = bx;
		var closest_y = by;
		
		if (closest_x < aleft) closest_x = aleft;
		else if (closest_x > aright) closest_x = aright;
		if (closest_y < atop) closest_x = atop;
		else if (closest_y > abottom) closest_x = abottom;
		
		var diff_x = closest_x - bx;
		var diff_y = closest_y - by;
		
		if (diff_x * diff_x + diff_y * diff_y > bradius * bradius) return { x:closest_x, y:closest_y };
		else return null;
	}
	
	public static inline function AABBCircle(aleft : Float, atop : Float, aright : Float, abottom : Float,
									bx : Float, by : Float, bradius : Float) : Bool
	{
		return (AABBCircleNearest(aleft, atop, aright, abottom, bx, by, bradius) != null);
	}
	
	public static inline function CircleCircle(ax : Float, ay : Float, aradius : Float,
										bx : Float, by : Float, bradius : Float)
	{
		return (MathTools.sqrDist(ax, ay, bx, by) <= (aradius + bradius)*(aradius + bradius));
	}
	
}