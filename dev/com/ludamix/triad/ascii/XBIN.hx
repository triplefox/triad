package com.ludamix.triad.ascii;

import com.ludamix.triad.tools.Color;
import haxe.io.Bytes;
import haxe.io.BytesInput;
import haxe.io.BytesOutput;
import haxe.io.Eof;
import nme.utils.ByteArray;

class XBIN
{
	
	// The XBIN ASCII art format: supports textmode images of up to 65536x65536 /w palette and character data.
	
	// XBIN compression uses an optional interleaved RLE scheme.
	
	public var width : Int;
	public var height : Int;
	public var font_height : Int; // each row of height adds an additional byte per character
	
	public var flag_palette : Bool;
	public var flag_font : Bool;
	public var flag_compress : Bool;
	public var flag_nonblink : Bool;
	public var flag_512chars : Bool;
	
	public var palette : Array<Int>;
	public var font : Array<Bytes>;
	public var image : Array<Int>;
	
	public function new()
	{
		this.width = 1;
		this.height = 1;
		this.font_height = 1;
		this.flag_palette = false;
		this.flag_font = false;
		this.flag_compress = false;
		this.flag_nonblink = false;
		this.flag_512chars = false;
		this.palette = null;
		this.font = null;
		this.image = null;
	}
	
	public function initImage(width : Int, height : Int, compress : Bool, initvalue : Int)
	{
		this.width = width;
		this.height = height;
		this.flag_compress = compress;
		this.image = new Array();
		for (n in 0...width * height)
		{
			image.push(initvalue);
		}
	}
	
	public function palette8() : Array<Int>
	{
		// converts internal 6-bit RGB (0-63) to 8-bit RGB (0-255).
		
		var pal = new Array<Int>();
		for (p in palette)
		{
			var c = Color.RGBPx(p);
			c.r *= 4;			
			c.g *= 4;
			c.b *= 4;
			pal.push(Color.buildRGB(c.r, c.g, c.b));
		}
		return pal;
	}
	
	public function image24() : Array<Int>
	{
		// converts image from character, attr to bg, fg, character.
		
		var img = new Array<Int>();
		for (i in image)
		{
			var col = i >> 8;
			var char = i & 0xFF;
			var bg = (col & 0xF0) >> 4;
			var fg = col & 0x0F;
			img.push((bg << 16) + (fg << 8) + (char));		
		}
		return img;
	}
	
	static inline var STATE_UNCOMPRESSED = 0;
	static inline var STATE_CHARACTER = 1;
	static inline var STATE_ATTRIBUTE = 2;
	static inline var STATE_BOTH = 3;
	
	public static function load(input : Bytes) : XBIN
	{
		var file : BytesInput = new BytesInput(input);
		
		var head = file.readString(5);
		if (head != "XBIN" + String.fromCharCode(26))
			throw "malformed header, expected XBIN+EOF, got " + head;
		var x = new XBIN();
		x.width = file.readUInt16();
		x.height = file.readUInt16();
		x.font_height = file.readByte();
		var flags = file.readByte();
		x.flag_palette = (flags & (1 << 0)) > 0;
		x.flag_font = (flags & (1 << 1)) > 0;
		x.flag_compress = (flags & (1 << 2)) > 0;
		x.flag_nonblink = (flags & (1 << 3)) > 0;
		x.flag_512chars = (flags & (1 << 4)) > 0;
		
		if (x.flag_palette)
		{
			x.palette = new Array();
			for (n in 0...16)
			{
				x.palette.push(file.readUInt24());
			}
		}
		if (x.flag_font)
		{
			x.font = new Array();
			var char_count = x.flag_512chars ? 512 : 256;
			for (n in 0...char_count)
			{
				var bufo = new BytesOutput();
				for (i in 0...x.font_height)
					bufo.writeByte(file.readByte());
				x.font.push(bufo.getBytes());
			}
		}
		
		x.image = new Array();
		
		try {
			if (x.flag_compress)
			{
				while (true)
				{
					var repeat = file.readByte();
					var repeat_counter = 1 + (repeat & 63); // 6-bit LSB and we assume a minimum runlength of 1
					var repeat_flag = repeat >> 6; // 2-bit MSB
					switch(repeat_flag)
					{
						case STATE_UNCOMPRESSED: // no compression: just read the number of pairs indicated by the repeat value
							while (repeat_counter > 0)
							{
								x.image.push(file.readUInt16());
								repeat_counter--;
							}
						case STATE_CHARACTER: // character compression, attr changes
							var val = file.readByte();
							while (repeat_counter > 0)
							{
								x.image.push(val + (file.readByte() << 8));
								repeat_counter--;
							}
						case STATE_ATTRIBUTE: // attr compression, character changes
							var val = file.readByte() << 8;
							while (repeat_counter > 0)
							{
								x.image.push(val + file.readByte());
								repeat_counter--;
							}
						case STATE_BOTH: // char+attr compressed
							var val = file.readUInt16();
							while (repeat_counter > 0)
							{
								x.image.push(val);
								repeat_counter--;
							}
					}
				}
			}	
			else
			{
				while(true)
					x.image.push(file.readUInt16());
			}
		}
		catch (e : Eof) { if (x.image.length<1) x.image = null; }
		return x;
	}
	
	public function save() : Bytes
	{
		var file = new BytesOutput();
		
		file.writeString("XBIN" + String.fromCharCode(26));
		file.writeUInt16(width);
		file.writeUInt16(height);
		file.writeByte(font_height);
		var flags = 0;
		if (flag_palette) flags += 1 << 0;
		if (flag_font) flags += 1 << 1;
		if (flag_compress) flags += 1 << 2;
		if (flag_nonblink) flags += 1 << 3;
		if (flag_512chars) flags += 1 << 4;
		file.writeByte(flags);
		
		if (flag_palette)
		{
			for (n in 0...palette.length)
				file.writeInt24(palette[n]);
		}
		
		if (flag_font)
		{
			for (n in 0...font.length)
			{
				var bufi = new BytesInput(font[n]);
				for (i in 0...font_height)
					file.writeByte(bufi.readByte());
			}
		}
		
		if (flag_compress)
		{
			
			// General strategy:
			// We start in UNCOMPRESSED state.
			// We consume data until we discover something that *violates* our current state.
			// Then we transition by popping the last values, committing, and pushing them into the next state.
			
			var fsm = { state:STATE_UNCOMPRESSED, fields: new Array<Int>()};
			var pos = 0;
			var x = 0;
			var y = 0;
			
			var getChar = function(field) { return field & 0xFF; }
			var getAttr = function(field) { return field >> 8; }
			
			var commit = function() {
				
				if (fsm.fields.length == 0) { return; }
				
				file.writeByte((fsm.state << 6) + fsm.fields.length-1);
				
				switch(fsm.state)
				{
					case STATE_UNCOMPRESSED:
						for (n in 0...fsm.fields.length)
							file.writeUInt16(fsm.fields[n]);
					case STATE_CHARACTER:
						file.writeByte(getChar(fsm.fields[0]));
						for (n in 0...fsm.fields.length)
							file.writeByte(getAttr(fsm.fields[n]));
					case STATE_ATTRIBUTE:
						file.writeByte(getAttr(fsm.fields[0]));
						for (n in 0...fsm.fields.length)
							file.writeByte(getChar(fsm.fields[n]));
					case STATE_BOTH:
						file.writeUInt16(fsm.fields[0]);
				}
				
				fsm.state = STATE_UNCOMPRESSED;
				fsm.fields = new Array<Int>();
			};
			var statematch = function(tchar, tattr) {
				if (tchar == getChar(image[pos]) && tattr == getAttr(image[pos]))
					return STATE_BOTH;
				else if (tchar == getChar(image[pos]) && tattr != getAttr(image[pos]))
					return STATE_CHARACTER;
				else if (tchar != getChar(image[pos]) && tattr == getAttr(image[pos]))
					return STATE_ATTRIBUTE;
				else
					return STATE_UNCOMPRESSED;
			};
			var transition = function() {
				var tfield = fsm.fields.pop();
				commit();
				fsm.fields.push(tfield);
				fsm.state = statematch(getChar(tfield), getAttr(tfield));
			};
			
			while (pos < image.length)
			{
				if (fsm.fields.length < 1)
					{ fsm.state = STATE_UNCOMPRESSED; }
				else
				{
					var tfield = fsm.fields[fsm.fields.length - 1];
					if (fsm.state!=(statematch(getChar(tfield), getAttr(tfield)))) transition();
				}
				fsm.fields.push(image[pos]);
				pos += 1; x += 1;
				if (x >= width)
					{ y += 1; x = 0; commit(); } // terminate at the end of a row
				if (fsm.fields.length>=64)
					{ commit(); } // terminate because of length limitations in 6 bits
			}
			commit();
			
		}
		else
		{
			if (image != null)
			{
				for (n in 0...image.length)
					file.writeInt16(image[n]);
			}
		}
		
		return file.getBytes();
	}
	
	
}