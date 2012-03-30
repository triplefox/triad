package microtone;

class LFSR
{
	// Galois Linear Feedback Shift Register implementation.
	// Used by Atari Pokey to create distorted "noise"
	// by zeroing the square-wave input according to the output
	// of the LFSR.
	
	// table of maximal LFSRs converted from Wikipedia
	// (polynomials->binary bitfield->hex)
	// 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
	// F E D C B A 9 8 7 6 5 4 3 2 1 0
	// (note that the taps are counted from 1, not 0)
	
	public static inline var TAPS2 = 0x3; // 2-bit: 2,1
	public static inline var MAX2 = 0x3;
	public static inline var HALF2 = 0x3;
	public static inline var TAPS3 = 0x7; // 3-bit: 3,2,1
	public static inline var MAX3 = 0x7;
	public static inline var HALF3 = 0x4;
	public static inline var TAPS4 = 0xC; // 4-bit: 4,3
	public static inline var MAX4 = 0xF;
	public static inline var HALF4 = Std.int(TAPS4/2);
	public static inline var TAPS5 = 0x14; // 5-bit: 5,3
	public static inline var MAX5 = 0x1F;
	public static inline var HALF5 = Std.int(TAPS5/2);
	public static inline var TAPS6 = 0x30; // 6-bit: 6,5
	public static inline var MAX6 = 0x3F;
	public static inline var HALF6 = Std.int(TAPS6/2);
	public static inline var TAPS7 = 0x60; // 7-bit: 7,6
	public static inline var MAX7 = 0x7F;
	public static inline var HALF7 = Std.int(TAPS7/2);
	public static inline var TAPS8 = 0xB8; // 8-bit: 8,6,5,4
	public static inline var MAX8 = 0xFF;
	public static inline var HALF8 = Std.int(TAPS8/2);
	public static inline var TAPS9 = 0x110; // 9-bit: 9,5
	public static inline var MAX9 = 0x1FF;
	public static inline var HALF9 = Std.int(TAPS9/2);
	public static inline var TAPS10 = 0x240; // 10-bit: 10,7
	public static inline var MAX10 = 0x3FF;
	public static inline var HALF10 = Std.int(TAPS10/2);
	public static inline var TAPS11 = 0x500; // 11-bit: 11,9
	public static inline var MAX11 = 0x7FF;
	public static inline var HALF11 = Std.int(TAPS11/2);
	public static inline var TAPS12 = 0xE08; // 12-bit: 12,11,10,4
	public static inline var MAX12 = 0xFFF;
	public static inline var HALF12 = Std.int(TAPS12/2);
	public static inline var TAPS13 = 0x1C80; // 13-bit: 13,12,11,8
	public static inline var MAX13 = 0x1FFF;
	public static inline var HALF13 = Std.int(TAPS13/2);
	public static inline var TAPS14 = 0x3802; // 14-bit: 14,13,12,2
	public static inline var MAX14 = 0x3FFF;
	public static inline var HALF14 = Std.int(TAPS14/2);
	public static inline var TAPS15 = 0x6000; // 15-bit: 15,14
	public static inline var MAX15 = 0x7FFF;
	public static inline var HALF15 = Std.int(TAPS15/2);
	public static inline var TAPS16 = 0xB400; // 16-bit: 16,14,13,11
	public static inline var MAX16 = 0xFFFF;
	public static inline var HALF16 = Std.int(TAPS16/2);
	public static inline var TAPS17 = 0x12000; // 17-bit: 17,14
	public static inline var MAX17 = 0x1FFFF;
	public static inline var HALF17 = Std.int(TAPS17/2);
	public static inline var TAPS18 = 0x20400; // 18-bit: 18,11
	public static inline var MAX18 = 0x3FFFF;
	public static inline var HALF18 = Std.int(TAPS18/2);
	public static inline var TAPS19 = 0x72000; // 19-bit: 19,18,17,14
	public static inline var MAX19 = 0x7FFFF;
	public static inline var HALF19 = Std.int(TAPS19/2);

	public static inline var dataTable = [
		[0,0,0],
		[0,0,0],
		[TAPS2,MAX2,HALF2],
		[TAPS3,MAX3,HALF3],
		[TAPS4,MAX4,HALF4],
		[TAPS5,MAX5,HALF5],
		[TAPS6,MAX6,HALF6],
		[TAPS7,MAX7,HALF7],
		[TAPS8,MAX8,HALF8],
		[TAPS9,MAX9,HALF9],
		[TAPS10,MAX10,HALF10],
		[TAPS11,MAX11,HALF11],
		[TAPS12,MAX12,HALF12],
		[TAPS13,MAX13,HALF13],
		[TAPS14,MAX14,HALF14],
		[TAPS15,MAX15,HALF15],
		[TAPS16,MAX16,HALF16],
		[TAPS17,MAX17,HALF17],
		[TAPS18,MAX18,HALF18],
		[TAPS19,MAX19,HALF19]
		];

	public static function genSeed() : Int
	{
		return Std.int(Math.random()*0xFFFFFF);
	}

	public static inline function lfsrAlgorithm(inp : Int, numBits : Int, maxHex : Int, tapsHex : Int)
	{
		// in two parts:
		// ((inp & 1) << numBits) + (inp >> 1) & maxHex) does the right shift, mapping 32 bits into numBits
		// (-(inp & 1) & tapsHex) is the actual LSFR function.
		return (((inp & 1) << numBits) + (inp >> 1) & maxHex) ^ (-(inp & 1) & tapsHex); 
	}
	
	public var seed : Int;

	public function new()
	{
		this.seed = genSeed();
	}

	public inline function noiseGen(numBits : Int)
	{
		var dt = dataTable[numBits];
		seed = lfsrAlgorithm(seed, numBits, dt[1],dt[0]);
		return seed>=dt[2] ? 1 : 0;
	}

	public static function dispBinary(inp : Int)
	{
		var result = new StringBuf();
		for (n in 0...20)
		{
			var pow = 1 << (19-n);
			if (inp & pow == pow)
			{
				inp-=pow;
				result.add("1");
			}
			else result.add("0");
		}
		return result;
	}
	
}

class LFSRUnit implements MTLogicUnit
{

	public var id : String;

	public var ready : Bool;
	public var params : Array<String>;

	public var inSamples : String;
	public var outPCM : String;
	public var bits : String;
	public var chunkiness : String;
	
	public var ct : Int;
	public var cur : Float;
	public var noise : LFSR;
	
	public function new(inSamples,outPCM,bits,chunkiness)
	{
		ready = false;
		this.inSamples = inSamples;
		this.outPCM = outPCM;
		this.bits = bits;
		this.chunkiness = chunkiness;
		noise = new LFSR();
		params = [inSamples,bits,chunkiness];
		ct = 0;
		cur = 0.;
	}
	
	public function onFrame(patchbay : MTPatchbay)
	{
		
	}	

	public function update(patchbay : MTPatchbay)
	{
		var outD : MT32 = patchbay.paramGet(outPCM);
		var ins : Int = patchbay.paramGet(inSamples).data;
		var bitc : Int = patchbay.paramGet(bits).data;
		var chunkc : Int = patchbay.paramGet(chunkiness).data;
		
		outD.reset();

		for (n in 0...ins)
		{
			if (ct%chunkc==0)
			{
				cur = noise.noiseGen(bitc);
			}
			outD.write(cur);
			ct++;
		}
		
		patchbay.paramSet(outPCM,outD);
		
	}	

}
