package com.ludamix.triad.format;

import nme.utils.ByteArray;
import nme.Vector;

enum StructType {
	STByte;
	STUByte;
	STShort;
	STUShort;
	STInt;
	STUInt;
	STFloat;
	STDouble;
	STASCII(len : Int);
	STUTF8;
	STUTF8Length(len : Int);
	STString(len : Int, encoding : String);
	STBooleanNonZeroByte;
	STBooleanArrayByte(names : Array<String>);
}

enum StructArrayType {
	SATVector(type : StructType);
	SATArray(type : StructType);
}

enum StructDef {
	SDField(type : StructType);
	SDArrayByteLength(type : StructArrayType, len : Int, pad_alignment_to_type : Bool);
	SDArrayTypeLength(type : StructArrayType, len : Int, pad_alignment_to_type : Bool);
}

typedef FourByteChunk = {name:String, position:Int, len:Int};

enum NamedStructDef {
	NamedSD(name : String, sd : StructDef);
}

class ExtendedByteArray
{
	
	public static function fromByteArray(bytearray : ByteArray)
	{
		var eba = new ExtendedByteArray();
		eba.b = bytearray;
		return eba;
	}
	
	public var b : ByteArray;
	
	private function new() {}
	
	public inline function get4ByteChunks(chunk_len : Int)
	{
		var chunk_end : Int = b.position + chunk_len;
		var chunks = new Array<FourByteChunk>();
		while (Std.int(b.position)<chunk_end)
		{
			var name = b.readMultiByte(4, "us-ascii");
			var len = b.readUnsignedInt();
			
			chunks.push( { name:name, position:b.position, len:len } );
			b.position += len;
		}
		// if you get an EOF - check your endianness!
		
		return chunks;
	}
	
	public function sizeOfType(t : StructType)
	{
		switch(t)
		{
			case STByte, STUByte, STBooleanNonZeroByte: return 1;
			case STBooleanArrayByte(_): return 1;
			case STShort, STUShort: return 2;
			case STInt, STUInt: return 4;
			case STFloat: return 4;
			case STDouble: return 8;
			case STString(len, encoding): return len;
			case STASCII(len), STUTF8Length(len): return len;
			case STUTF8: return 0;
		}
	}
	
	public function nameOfType(t : StructType)
	{
		switch(t)
		{
			case STBooleanArrayByte(names): return "Boolean array ("+names.join(", ")+")";
			case STBooleanNonZeroByte: return "Boolean (when non-zero)";
			case STByte: return "Byte";
			case STUByte: return "Unsigned Byte";
			case STShort: return "Short";
			case STUShort: return "Unsigned Short";
			case STInt: return "Int";
			case STUInt: return "Unsigned Int";
			case STFloat: return "Float";
			case STDouble: return "Double";
			case STString(len, encoding): return "String "+encoding;
			case STASCII(len): return "String ASCII";
			case STUTF8: return "String UTF8";
			case STUTF8Length(len): return "String UTF8(length "+Std.string(len)+")";
		}
	}
	
	private function typedArray(type : StructArrayType, len : Int) : Dynamic
	{
		switch(type)
		{
			case SATArray(i_type):
				switch(i_type)
				{
					case STBooleanArrayByte(names):
						var ar = new Array<Dynamic>();
						for (entry in 0...len)
						{
							var fields : Dynamic = { };
							ar.push(fields);
							var val = b.readUnsignedByte();
							for (n in names) 
							{
								Reflect.setProperty(fields, n, val & 1);
								val >> 1;
							}
						}
						return ar;
					case STBooleanNonZeroByte: var ar = new Array<Bool>();
						for (entry in 0...len) ar.push(b.readBoolean());
						return ar;
					case STString(i_len, encoding): var ar = new Array<String>();
						for (entry in 0...len) ar.push(b.readMultiByte(i_len, encoding));
						return ar;
					case STASCII(i_len): var ar = new Array<String>();
						for (entry in 0...len) ar.push(b.readMultiByte(i_len, "us-ascii"));
						return ar;
					case STUTF8: var ar = new Array<String>();
						for (entry in 0...len) ar.push(b.readUTF());
						return ar;
					case STUTF8Length(i_len): var ar = new Array<String>();
						for (entry in 0...len) ar.push(b.readUTFBytes(i_len));
						return ar;
					case STByte: var ar = new Array<Int>();
						for (entry in 0...len) ar.push(b.readByte());
						return ar;
					case STUByte: var ar = new Array<Int>();
						for (entry in 0...len) ar.push(b.readUnsignedByte());
						return ar;
					case STInt: var ar = new Array<Int>();
						for (entry in 0...len) ar.push(b.readInt());
						return ar;
					case STUInt: var ar = new Array<Int>();
						for (entry in 0...len) ar.push(b.readUnsignedInt());
						return ar;
					case STShort: var ar = new Array<Int>();
						for (entry in 0...len) ar.push(b.readShort());
						return ar;
					case STUShort: var ar = new Array<Int>();
						for (entry in 0...len) ar.push(b.readUnsignedShort());
						return ar;
					case STFloat: var ar = new Array<Float>();
						for (entry in 0...len) ar.push(b.readFloat());
						return ar;
					case STDouble: var ar = new Array<Float>();
						for (entry in 0...len) ar.push(b.readDouble());
						return ar;
				}
			case SATVector(i_type):
				switch(i_type)
				{
					case STBooleanArrayByte(names):
						var ar = new Vector<Dynamic>();
						for (entry in 0...len)
						{
							var fields : Dynamic = { };
							ar.push(fields);
							var val = b.readUnsignedByte();
							for (n in names) 
							{
								Reflect.setProperty(fields, n, val & 1);
								val >> 1;
							}
						}
						return ar;
					case STBooleanNonZeroByte: var ar = new Vector<Bool>();
						for (entry in 0...len) ar.push(b.readBoolean());
						return ar;
					case STString(i_len, encoding): var ar = new Vector<String>();
						for (entry in 0...len) ar.push(b.readMultiByte(i_len, encoding));
						return ar;
					case STASCII(i_len): var ar = new Vector<String>();
						for (entry in 0...len) ar.push(b.readMultiByte(i_len, "us-ascii"));
						return ar;
					case STUTF8: var ar = new Vector<String>();
						for (entry in 0...len) ar.push(b.readUTF());
						return ar;
					case STUTF8Length(i_len): var ar = new Vector<String>();
						for (entry in 0...len) ar.push(b.readUTFBytes(i_len));
						return ar;
					case STByte: var ar = new Vector<Int>();
						for (entry in 0...len) ar.push(b.readByte());
						return ar;
					case STUByte: var ar = new Vector<Int>();
						for (entry in 0...len) ar.push(b.readUnsignedByte());
						return ar;
					case STInt: var ar = new Vector<Int>();
						for (entry in 0...len) ar.push(b.readInt());
						return ar;
					case STUInt: var ar = new Vector<Int>();
						for (entry in 0...len) ar.push(b.readUnsignedInt());
						return ar;
					case STShort: var ar = new Vector<Int>();
						for (entry in 0...len) ar.push(b.readShort());
						return ar;
					case STUShort: var ar = new Vector<Int>();
						for (entry in 0...len) ar.push(b.readUnsignedShort());
						return ar;
					case STFloat: var ar = new Vector<Float>();
						for (entry in 0...len) ar.push(b.readFloat());
						return ar;
					case STDouble: var ar = new Vector<Float>();
						for (entry in 0...len) ar.push(b.readDouble());
						return ar;
				}		
		}
	}
	
	public function getStruct(sd : Array<NamedStructDef>) : Dynamic
	{
		var result : Dynamic = { };
		for (entry in sd)
		{
			switch(entry)
			{
				case NamedSD(name,def): Reflect.setProperty(result, name, getField(def));
			}
		}
		return result;
	}
	
	public function getFieldArray(sa : Array<NamedStructDef>) : Array<Dynamic>
	{
		var result = new Array<Dynamic>();
		for (s in sa) switch(s) { case NamedSD(name, sd): result.push(getField(sd)); }
		return result;
	}
	
	public function getField(s : StructDef) : Dynamic
	{
		switch(s)
		{
			case SDArrayByteLength(type, len, pad_alignment_to_type):
				var size = 0;
				var it : StructType;
				switch(type)
				{
					case SATArray(i_type): it = i_type; 
					case SATVector(i_type): it = i_type;
				}
				size = sizeOfType(it);
				var type_len : Float = len / size;
				if (Std.int(type_len) != type_len)
				{
					if (pad_alignment_to_type) type_len++;
					else throw "Misaligned array of " + nameOfType(it);
				}
				len = Std.int(type_len);
				return typedArray(type, len);
			case SDArrayTypeLength(type, len, pad_alignment_to_type):
				return typedArray(type, len);
			case SDField(type):
				switch(type)
				{
					case STBooleanArrayByte(names):
						var fields : Dynamic = { };
						var val = b.readUnsignedByte();
						for (n in names) 
						{
							Reflect.setProperty(fields, n, val & 1);
							val >> 1;
						}
						return fields;
					case STBooleanNonZeroByte: return b.readBoolean();
					case STString(i_len, encoding): return b.readMultiByte(i_len, encoding);
					case STASCII(i_len): return b.readMultiByte(i_len, "us-ascii");
					case STUTF8: return b.readUTF();
					case STUTF8Length(i_len): return b.readUTFBytes(i_len);
					case STByte: return b.readByte();
					case STUByte: return b.readUnsignedByte();
					case STInt: return b.readInt();
					case STUInt: return b.readUnsignedInt();
					case STShort: return b.readShort();
					case STUShort: return b.readUnsignedShort();
					case STFloat: return b.readFloat();
					case STDouble: return b.readDouble();
				}
		}
	}
	
}