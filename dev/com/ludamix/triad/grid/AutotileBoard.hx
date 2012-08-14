package com.ludamix.triad.grid;

import com.ludamix.triad.render.GraphicsResource;
import com.ludamix.triad.grid.IntGrid;
import nme.display.BitmapData;
import nme.display.Graphics;
import nme.display.Tilesheet;
import nme.geom.Rectangle;
import nme.Vector;

class AutotileBoard
{
	
	// A layer compatible with TilesheetGrid, allowing the creation of composite tiles from 4 smaller ones.
	
	public var defs : Array<AutoTileDef>;
	public var source : IntGrid;
	public var result : IntGrid;
	
	public function new(worldw : Int, worldh : Int, twidth : Float, theight : Float, populate : Array<Int>,
		defs : Array<AutoTileDef>)
	{
		this.defs = defs;
		source = new IntGrid(worldw, worldh, twidth, theight, populate);
		var pop = new Array<Int>(); for (n in 0...worldw * 2 * worldh * 2) pop.push(0);
		result = new IntGrid(worldw*2,worldh*2,twidth/2,theight/2,pop);
	}
	
	public inline function recacheAll()
	{
		var x = 0;
		var y = 0;
		
		while (Std.int(result.world.length) < Std.int(source.world.length) * 4)
		{
			result.world.push(0);
		}
		while (Std.int(result.world.length) > Std.int(source.world.length) * 4)
		{
			result.world.pop();
		}
		
		for (n in 0...source.world.length)
		{
			rewriteAutoTiling( { x:x, y:y }, source.world[n]);
			x++; if (x >= source.worldW) { x = 0; y++; }
		}
	}
	
	public inline function getFallback(x : Int, y : Int) : Int
	{
		if (x < 0) x = 0;
		else if (x >= source.worldW) x = source.worldW - 1;
		if (y < 0) y = 0;
		else if (y >= source.worldH) y = source.worldH - 1;
		
		return source.c2t(x, y);
	}
	
	public inline function recachePartial(idx : Int)
	{
		var p = source.c1p(idx);
		p.x -= 1; p.y -= 1; rewriteAutoTiling(p, getFallback(p.x, p.y));
		p.x += 1; rewriteAutoTiling(p, getFallback(p.x, p.y));
		p.x += 1; rewriteAutoTiling(p, getFallback(p.x, p.y));
		p.y += 1; p.x -= 2; rewriteAutoTiling(p, getFallback(p.x, p.y));
		p.x += 1; rewriteAutoTiling(p, getFallback(p.x, p.y));
		p.x += 1; rewriteAutoTiling(p, getFallback(p.x, p.y));
		p.y += 1; p.x -= 2; rewriteAutoTiling(p, getFallback(p.x, p.y));
		p.x += 1; rewriteAutoTiling(p, getFallback(p.x, p.y));
		p.x += 1; rewriteAutoTiling(p, getFallback(p.x, p.y));
	}
	
	private inline function c2tSafe(x : Int, y : Int, fallback) : Int
	{
		if (source.tileInBounds(x, y)) return source.c2t(x, y);
		else return fallback;
	}
	
	public inline function rewriteAutoTiling(p : { x:Int, y:Int }, fallback : Int)
	{
		// build the mask information
		
		if (p.x >= 0 && p.x < source.worldW && p.y >= 0 && p.y < source.worldH)
		{
			var center = defs[c2tSafe(p.x    , p.y    , fallback)];
			
			var m_c = center.maskrecieve;
			
			var m_tl = (defs[c2tSafe(p.x - 1, p.y - 1, fallback)].masksend & m_c)>0;
			var m_t  = (defs[c2tSafe(p.x    , p.y - 1, fallback)].masksend & m_c)>0;
			var m_tr = (defs[c2tSafe(p.x + 1, p.y - 1, fallback)].masksend & m_c)>0;
			var m_l  = (defs[c2tSafe(p.x - 1, p.y    , fallback)].masksend & m_c)>0;
			var m_r  = (defs[c2tSafe(p.x + 1, p.y    , fallback)].masksend & m_c)>0;
			var m_bl = (defs[c2tSafe(p.x - 1, p.y + 1, fallback)].masksend & m_c)>0;
			var m_b  = (defs[c2tSafe(p.x    , p.y + 1, fallback)].masksend & m_c)>0;
			var m_br = (defs[c2tSafe(p.x + 1, p.y + 1, fallback)].masksend & m_c) > 0;
			
			// get and assign the indexes for each subtile.
			
			var si = center.indexes;
			
			var idx_tl = result.c21(p.x * 2, p.y * 2);
			var idx_bl = result.c21(p.x * 2, p.y * 2 + 1);
			result.world[idx_tl]     = si[computeMask(m_l, m_t, m_tl, 0)];		
			result.world[idx_tl + 1] = si[computeMask(m_r, m_t, m_tr, 1)];		
			result.world[idx_bl]     = si[computeMask(m_l, m_b, m_bl, 2)];
			result.world[idx_bl + 1] = si[computeMask(m_r, m_b, m_br, 3)];
			
			return result;
		}
		else
		{
			return result;
		}
	}
	
	// given this arrangement of tiles in a single continuous strip 0-20:
	// /\ \/ -- -- || || \/ /\ ** **
	// outer horiz verti inner solid
	// rewriteAutoTiling does the boilerplate of creating the booleans from the mask defs.
	// computeMask will compute the correct tile index from the mask created by edges a, b, ab and the
	// corner index 0-4, where a is the horiz direction and b is the verti direction.
	// then the end of rewriteAutoTiling converts the directives into updates for TileSheetGrid.
	
	public static inline function computeMask(a : Bool, b : Bool, ab : Bool, corner : Int)
	{
		var sides = (a ? 4 : 0) + (b ? 8 : 0);
		if (sides == 12) { return (ab ? 16 : 12) + corner; }
		else return sides + corner;
	}
	
	public inline function set1(idx : Int, val : Int):Void { source.world[idx] = val; recachePartial(idx); }
	public inline function set2(x : Int, y : Int, val : Int):Void { var idx = source.c21(x, y); set1(idx,val); }
	public inline function setff(x : Float, y : Float, val : Int):Void { var idx = source.cff1(x, y); set1(idx, val); }
	public inline function set2wrap(x : Int, y : Int, val : Int):Void { 
		while (x < 0) x += source.worldW;
		while (y < 0) y += source.worldH;
		while (x >= source.worldW) x -= source.worldW;
		while (y >= source.worldH) y -= source.worldH;
		var idx = source.c21(x, y); set1(idx, val); 
	}
	public inline function setffwrap(x : Float, y : Float, val : Int):Void { 
		while (x < 0) x += source.worldW * source.twidth;
		while (y < 0) y += source.worldH * source.theight;
		while (x >= source.worldW * source.twidth) x -= source.worldW * source.twidth;
		while (y >= source.worldH * source.theight) y -= source.worldH * source.theight;
		var idx = source.cff1(x, y); set1(idx, val); 
	}
	
}