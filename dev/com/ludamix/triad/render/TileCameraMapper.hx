package com.ludamix.triad.render;

import com.ludamix.triad.grid.IntGrid;
import com.ludamix.triad.render.TilesheetGrid;
import nme.geom.Rectangle;

class TileCameraMapper
{

	public static function copy(input : IntGrid, output : IntGrid, camera_view : Rectangle, screen_view : Rectangle)
	{
		var tile_tl = input.cffp(camera_view.left, camera_view.top);
		var tile_br = input.cffp(camera_view.right, camera_view.bottom);
		var tile_x = Math.floor(tile_tl.x);
		var tile_y = Math.floor(tile_tl.y);
		var tile_w = Math.ceil(tile_br.x - tile_tl.x);
		var tile_h = Math.ceil(tile_br.y - tile_tl.y);
		
		var pop = new Array<Int>();
		for (y in tile_y...tile_y + tile_h)
		{
			for (x in tile_x...tile_x + tile_w)			
			{
				pop.push(input.c2t(x, y));
			}
		}
		
		if (tile_w != output.grid.worldW || tile_h != output.grid.worldH)
			output.resize(tile_w, tile_h, output.grid.twidth, output.grid.theight, pop);
		output.off_x = view.x % output.grid.twidth;
		output.off_y = view.y % output.grid.theight;
		
		var scale_x = screen_view.width / camera_view.width;
		var scale_y = screen_view.height / camera_view.height;
		
		scale_x > scale_y ? grid.scale = scale_x : grid.scale = scale_y;
		
	}

}