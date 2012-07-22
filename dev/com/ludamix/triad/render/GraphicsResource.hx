package com.ludamix.triad.render;
import com.ludamix.triad.geom.BinPacker;
import com.ludamix.triad.grid.AutotileBoard;
import com.ludamix.triad.render.TilePack;
import com.ludamix.triad.render.SpriteRenderer;
import com.ludamix.triad.tools.StringTools;
import nme.Assets;
import nme.display.Bitmap;
import nme.display.BitmapData;
import com.ludamix.triad.format.TriadConfig;
import nme.display.Tilesheet;
import nme.geom.Point;
import nme.geom.Rectangle;

typedef GraphicsResourceData = {tilesheet:XTilesheet,sprite:Array<SpriteDef>,autotile:Array<AutoTileDef>};

class GraphicsResource
{
	
	// entry format:
	// [group=str; (opcodes)]
	// [id=str; (opcodes)]
	//
	// opcodes:
	//  file=str; type=autotile, spritesheet; tilesize=[int;int] masksend=[<masknames...>]; maskrecieve=[<masknames...>]; 
	//	align=<tl, tr, bl, br, center>; alignoffset=[int;int]
	//  rect=[int,int,int,int]; | rectx=int; | recty=int; | rectw=int; | recth=int;
	
	public static function read(file : String, sheetsize : Int, 
		sheet_border : Bool, ?prepend : String) : GraphicsResourceData
	{
		var data : Array<Dynamic> = TriadConfig.parse(file, TCPReject);
		if (data[0] == file)
			throw "you input the filename, not the file";
		
		var idx = 0;
		var group_opcodes = new Hash<Dynamic>();
		
		var sheet_bitmaps = new Array<{bd:BitmapData,offx:Int,offy:Int}>();
		var spritesheets = new Array<SpriteDef>();
		var autotiles = new Array<AutoTileDef>();
		var masknames = new Hash<Int>();
		var maskpos = 1;
		
		var getMask = function(names : Array<String>):Int
		{
			var result = 0;
			for (name in names)
			{
				if (masknames.exists(name))
					result += masknames.get(name);
				else
				{
					masknames.set(name, maskpos);
					result += maskpos;
					maskpos = maskpos << 1;
				}
			}
			return result;
		};
		
		for (d in data)
		{
			if (Reflect.hasField(d, "group"))
			{
				group_opcodes = new Hash();
				for (n in Reflect.fields(d))
				{
					group_opcodes.set(n, Reflect.field(d, n));
				}
			}
			else
			{
				var opcodes = new Hash<Dynamic>();
				for (n in group_opcodes.keys())
					opcodes.set(n, group_opcodes.get(n));
				for (n in Reflect.fields(d))
				{
					opcodes.set(n, Reflect.field(d, n));
				}		
				
				// process opcodes
				
				var file = d.file;
				var img = getFile(prepend+file); 
				var x = 0;
				var y = 0;
				var w = img.width;
				var h = img.height;
				var align = "center";
				var alignx = 0.;
				var aligny = 0.;
				
				if (opcodes.exists("rect"))
				{
					var xywh : Array<Int> = opcodes.get("rect");
					x = xywh[0]; 
					if (xywh.length > 1) y = xywh[1]; 
					if (xywh.length > 2) w = xywh[2]; 
					if (xywh.length > 3) h = xywh[3];
				}
				if (opcodes.exists("rectx")) x = opcodes.get("rectx");
				if (opcodes.exists("recty")) y = opcodes.get("recty");
				if (opcodes.exists("rectw")) w = opcodes.get("rectw");
				if (opcodes.exists("recth")) h = opcodes.get("recth");
				
				var id = Std.string(idx);
				if (opcodes.exists("id")) id = opcodes.get("id");
				var group = "none";
				if (opcodes.exists("group")) group = opcodes.get("group");
				
				var file = opcodes.get("file");
				
				var slice_w = w; var slice_h = h;
				if (opcodes.exists("tilesize")) { var ts = opcodes.get("tilesize"); slice_w = ts[0]; slice_h = ts[1]; }
				var slices = slice(img, new Rectangle(x, y, w, h), slice_w, slice_h);
				
				if (!opcodes.exists("type")) throw "no type declared for " + id;				
				var type = opcodes.get("type");
				
				switch type
				{
					case "autotile":
						
						// verify length and get mask
						
						if (slices.length != 20) throw "autotile should have 20 subtiles in a 10x2 grid";
						var masksend = 0; 
						if (opcodes.exists("masksend")) masksend = getMask(opcodes.get("masksend"));
						var maskrecieve = 0; 
						if (opcodes.exists("maskrecieve")) maskrecieve = getMask(opcodes.get("maskrecieve"));
						
						// reorder the indexes
						
						var atdefs = [0, 1, 0 + 10, 1 + 10, 2, 3, 2 + 10, 3 + 10, 4, 5, 4 + 10, 
									  5 + 10, 6, 7, 6 + 10, 7 + 10, 8, 9, 8 + 10, 9 + 10];
						var nslices = new Array<BitmapData>();
						for (n in 0...atdefs.length)
						{
							nslices.push(slices[atdefs[n]]);
						}
						slices = nslices;
						
						// generate the final entry data
						var sheet_idx = sheet_bitmaps.length;	
						for (n in slices) sheet_bitmaps.push({bd:n,offx:0,offy:0});
						var at = { sheet_idx:sheet_idx, sheet_len:20, masksend:masksend, maskrecieve:maskrecieve,
							id:id, file:file, group:group,
							w:slice_w, h:slice_h, slices:slices }; // (this object is for reference)
						
						// make an AutoTileDef
						var atindexes = new Array<Int>();
						for (n in 0...20)
							atindexes.push(sheet_idx+n);
						
						autotiles.push({name:id,indexes:atindexes,masksend:masksend,maskrecieve:maskrecieve});
						
					case "spritesheet":
						
						// get alignment opcodes
						
						var align = "center";
						if (opcodes.exists("align")) align = opcodes.get("align");
						var alignoffset = [0,0];
						if (opcodes.exists("alignoffset")) alignoffset = opcodes.get("alignoffset");
						switch align
						{
							case "center": alignoffset[0] += slice_w >> 1; alignoffset[1] += slice_h >> 1;
							case "tl":
							case "tr": alignoffset[0] += slice_w;
							case "bl": alignoffset[1] += slice_h;
							case "br": alignoffset[0] += slice_w; alignoffset[1] += slice_h;
							default: throw "invalid align "+align+" in "+id;
						}
						
						// now write the sprite information with adjusted offset data.
						var sheet_idx = sheet_bitmaps.length;
						for (n in slices) sheet_bitmaps.push({bd:n,offx:alignoffset[0],offy:alignoffset[1]});
						var sheet_len = slices.length;
						
						var spr = { offx:alignoffset[0], offy:alignoffset[1], sheet_idx:sheet_idx, sheet_len:sheet_len,
							id:id, file:file, group:group, slices:slices, w:slice_w, h:slice_h}; // reference
						spritesheets.push( { name:id, idx:sheet_idx, sheet:null, frames:sheet_len, 
							xoff:alignoffset[0], yoff:alignoffset[1], w:slice_w, h:slice_h});
						
						// since the sheet contains offset data, all we need is "name, index, len," I guess.
						
						
					default: throw "unrecognized type " + Std.string(opcodes.get("type")+" for "+id);
				}
				
				idx++;
			}
		}
		
		// Now we have spritesheet data, autotile data, and ordered raw bitmaps.
		// So we pack it and emit some final objects.
		
		var tp = new TilePack();
		for (n in sheet_bitmaps)
			tp.add(n.bd,n.offx,n.offy);
		var infos = tp.compute(sheetsize, sheet_border);
		
		var nodes : Array<PackerNode> = infos.nodes;		
		var ts = new XTilesheet(infos.bitmapdata);
		for (n in nodes)
		{
			ts.addTileRect(new Rectangle(n.x, n.y, n.w, n.h), new Point(n.contents.offx, n.contents.offy));
		}
		// since right now we only have one sheet, that's the one we assign to
		for (n in spritesheets)
			n.sheet = ts;
		
		return { tilesheet:ts, sprite:spritesheets, autotile:autotiles };
		
	}
	
	private static function getFile(fname : String) : BitmapData
	{
		var z : BitmapData = null;
		try {
			z = Assets.getBitmapData(fname);
		}
		catch (d:Dynamic) { throw "couldn't find " + fname; }
		return z;
	}
	
	private static function slice(img : BitmapData, rect : Rectangle, slice_w : Int, slice_h : Int) : Array<BitmapData>
	{	
		var x = Std.int(rect.x);
		var y = Std.int(rect.y);
		
		var result = new Array<BitmapData>();
		
		while (y < rect.y+rect.height)
		{
			while (x < rect.x+rect.width)
			{
				var bd = new BitmapData(slice_w, slice_h,true,0);
				bd.copyPixels(img, new Rectangle(x, y, slice_w, slice_h), 
					new Point(0., 0.));
				result.push(bd);
				x += slice_w;
			}
			y += slice_h;
			x = Std.int(rect.x);
		}
		
		return result;
		
	}
	
}