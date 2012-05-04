package com.ludamix.triad.tools;

import nme.display.BitmapInt32;

class Color
{
	
	public static inline function ARGB(rgb : Int, alpha : Int) : BitmapInt32
	{
		#if neko
			return { a:0xFF, rgb:rgb };
		#else
			return (alpha << 24) + rgb;
		#end
	}
	
	public static inline function RGBofARGB(argb : BitmapInt32)
	{
		#if neko
			return argb.rgb;
		#else
			return argb | 0xFF000000;
		#end
	}
	
	public static inline function RGBPx(value : Int) 
	{ return { r:RGBred(value), g:RGBgreen(value), b:RGBblue(value) }; }
	
	public static inline function RGBred(value : Int) { return value >> 16; }

	public static inline function RGBgreen(value : Int) { return (value >> 8) & 0xFF; }
	
	public static inline function RGBblue(value : Int) { return (value) & 0xFF;  }
	
	public static inline function buildRGB(r:Int, g:Int, b:Int) : Int 
	{ return (r << 16) + (g << 8) + (b); }
	
	public static inline function RGBtoHSV(RGB:{r : Int, g : Int, b : Int},HSV:{h:Float,s:Float,v:Float})
	{
		var r = RGB.r / 255.; var g = RGB.g / 255.; var b = RGB.b / 255.; // Scale to unity.
		var minVal = Math.min(Math.min(r, g), b);
		var maxVal = Math.max(Math.max(r, g), b);
		var delta = maxVal - minVal;
		HSV.v = maxVal;
		if (delta == 0) {
			HSV.h = 0;
			HSV.s = 0;
		} else {
			HSV.s = delta / maxVal;
			var del_R = (((maxVal - r) / 6.) + (delta / 2.)) / delta;
			var del_G = (((maxVal - g) / 6.) + (delta / 2.)) / delta;
			var del_B = (((maxVal - b) / 6.) + (delta / 2.)) / delta;

			if (r == maxVal) {HSV.h = del_B - del_G;}
			else if (g == maxVal) {HSV.h = (1 / 3) + del_R - del_B;}
			else if (b == maxVal) {HSV.h = (2 / 3) + del_G - del_R;}
			
			if (HSV.h < 0) {HSV.h += 1;}
			if (HSV.h > 1) {HSV.h -= 1;}

		}

	}

	public static inline function HSVtoRGB(HSV:{h:Float,s:Float,v:Float},RGB:{r:Int,g:Int,b:Int})
	{
		var h : Float = HSV.h; var s : Float = HSV.s; var v : Float = HSV.v;

		if (s == 0) {
			RGB.r = Std.int(v * 255);
			RGB.g = Std.int(v * 255);
			RGB.b = Std.int(v * 255);
		} else {
		
			var var_h = h * 6;
			var var_i = Std.int(var_h);
			var var_1 = v * (1. - s);
			var var_2 = v * (1. - s * (var_h - var_i));
			var var_3 = v * (1. - s * (1 - (var_h - var_i)));
			var var_r = 0.;
			var var_g = 0.;
			var var_b = 0.;

			if (var_i == 0) { var_r = v; var_g = var_3; var_b = var_1; }
			else if (var_i == 1) { var_r = var_2; var_g = v; var_b = var_1; }
			else if (var_i == 2) { var_r = var_1; var_g = v; var_b = var_3; }
			else if (var_i == 3) { var_r = var_1; var_g = var_2; var_b = v; }
			else if (var_i == 4) { var_r = var_3; var_g = var_1; var_b = v; }
			else { var_r = v; var_g = var_1; var_b = var_2; };
			
			RGB.r = Std.int(var_r * 255);
			RGB.g = Std.int(var_g * 255);
			RGB.b = Std.int(var_b * 255);
		}
	}
	
	public static function getShifted(c : EColor, hShift : Float, sShift : Float, vShift : Float) : Int
	{
		var hsv = { h:0., s:0., v:0. };
		var rgb = RGBPx(get(c));
		RGBtoHSV(rgb,hsv);
		hsv.v += vShift;
		hsv.s += sShift;
		hsv.h += hShift;
		HSVtoRGB(hsv,rgb);
		return buildRGB(rgb.r, rgb.g, rgb.b);
	}
	
	public static function getMultiplied(c : EColor, hShift : Float, sShift : Float, vShift : Float) : Int
	{
		var hsv = { h:0., s:0., v:0. };
		var rgb = RGBPx(get(c));
		RGBtoHSV(rgb,hsv);
		hsv.v *= vShift;
		hsv.s *= sShift;
		hsv.h *= hShift;
		HSVtoRGB(hsv,rgb);
		return buildRGB(rgb.r, rgb.g, rgb.b);
	}
	
	public static function get(c : EColor) : Int
	{
		switch(c) {
		case ColPlaceholder: return 0xFF00FF;
		case ColRGB(r, g, b): return buildRGB(r, g, b);
		case ColHSV(h, s, v): var t = { r:0, g:0, b:0 };  
							  HSVtoRGB( { h:h, s:s, v:v }, t );  
							  return buildRGB(t.r, t.g, t.b);
		case ColHex(hv): return hv;
		case ColString(v): return Std.parseInt(v);
		case AliceBlue: return 0xF0F8FF;
		case AntiqueWhite: return 0xFAEBD7;
		case Aqua: return 0x00FFFF;
		case Aquamarine: return 0x7FFFD4;
		case Azure: return 0xF0FFFF;
		case Beige: return 0xF5F5DC;
		case Bisque: return 0xFFE4C4;
		case Black: return 0x000000;
		case BlanchedAlmond: return 0xFFEBCD;
		case Blue: return 0x0000FF;
		case BlueViolet: return 0x8A2BE2;
		case Brown: return 0xA52A2A;
		case BurlyWood: return 0xDEB887;
		case CadetBlue: return 0x5F9EA0;
		case Chartreuse: return 0x7FFF00;
		case Chocolate: return 0xD2691E;
		case Coral: return 0xFF7F50;
		case CornflowerBlue: return 0x6495ED;
		case Cornsilk: return 0xFFF8DC;
		case Crimson: return 0xDC143C;
		case Cyan: return 0x00FFFF;
		case DarkBlue: return 0x00008B;
		case DarkCyan: return 0x008B8B;
		case DarkGoldenRod: return 0xB8860B;
		case DarkGray: return 0xA9A9A9;
		case DarkGrey: return 0xA9A9A9;
		case DarkGreen: return 0x006400;
		case DarkKhaki: return 0xBDB76B;
		case DarkMagenta: return 0x8B008B;
		case DarkOliveGreen: return 0x556B2F;
		case Darkorange: return 0xFF8C00;
		case DarkOrchid: return 0x9932CC;
		case DarkRed: return 0x8B0000;
		case DarkSalmon: return 0xE9967A;
		case DarkSeaGreen: return 0x8FBC8F;
		case DarkSlateBlue: return 0x483D8B;
		case DarkSlateGray: return 0x2F4F4F;
		case DarkSlateGrey: return 0x2F4F4F;
		case DarkTurquoise: return 0x00CED1;
		case DarkViolet: return 0x9400D3;
		case DeepPink: return 0xFF1493;
		case DeepSkyBlue: return 0x00BFFF;
		case DimGray: return 0x696969;
		case DimGrey: return 0x696969;
		case DodgerBlue: return 0x1E90FF;
		case FireBrick: return 0xB22222;
		case FloralWhite: return 0xFFFAF0;
		case ForestGreen: return 0x228B22;
		case Fuchsia: return 0xFF00FF;
		case Gainsboro: return 0xDCDCDC;
		case GhostWhite: return 0xF8F8FF;
		case Gold: return 0xFFD700;
		case GoldenRod: return 0xDAA520;
		case Gray: return 0x808080;
		case Grey: return 0x808080;
		case Green: return 0x008000;
		case GreenYellow: return 0xADFF2F;
		case HoneyDew: return 0xF0FFF0;
		case HotPink: return 0xFF69B4;
		case IndianRed : return 0xCD5C5C;
		case Indigo  : return 0x4B0082;
		case Ivory: return 0xFFFFF0;
		case Khaki: return 0xF0E68C;
		case Lavender: return 0xE6E6FA;
		case LavenderBlush: return 0xFFF0F5;
		case LawnGreen: return 0x7CFC00;
		case LemonChiffon: return 0xFFFACD;
		case LightBlue: return 0xADD8E6;
		case LightCoral: return 0xF08080;
		case LightCyan: return 0xE0FFFF;
		case LightGoldenRodYellow: return 0xFAFAD2;
		case LightGray: return 0xD3D3D3;
		case LightGrey: return 0xD3D3D3;
		case LightGreen: return 0x90EE90;
		case LightPink: return 0xFFB6C1;
		case LightSalmon: return 0xFFA07A;
		case LightSeaGreen: return 0x20B2AA;
		case LightSkyBlue: return 0x87CEFA;
		case LightSlateGray: return 0x778899;
		case LightSlateGrey: return 0x778899;
		case LightSteelBlue: return 0xB0C4DE;
		case LightYellow: return 0xFFFFE0;
		case Lime: return 0x00FF00;
		case LimeGreen: return 0x32CD32;
		case Linen: return 0xFAF0E6;
		case Magenta: return 0xFF00FF;
		case Maroon: return 0x800000;
		case MediumAquaMarine: return 0x66CDAA;
		case MediumBlue: return 0x0000CD;
		case MediumOrchid: return 0xBA55D3;
		case MediumPurple: return 0x9370D8;
		case MediumSeaGreen: return 0x3CB371;
		case MediumSlateBlue: return 0x7B68EE;
		case MediumSpringGreen: return 0x00FA9A;
		case MediumTurquoise: return 0x48D1CC;
		case MediumVioletRed: return 0xC71585;
		case MidnightBlue: return 0x191970;
		case MintCream: return 0xF5FFFA;
		case MistyRose: return 0xFFE4E1;
		case Moccasin: return 0xFFE4B5;
		case NavajoWhite: return 0xFFDEAD;
		case Navy: return 0x000080;
		case OldLace: return 0xFDF5E6;
		case Olive: return 0x808000;
		case OliveDrab: return 0x6B8E23;
		case Orange: return 0xFFA500;
		case OrangeRed: return 0xFF4500;
		case Orchid: return 0xDA70D6;
		case PaleGoldenRod: return 0xEEE8AA;
		case PaleGreen: return 0x98FB98;
		case PaleTurquoise: return 0xAFEEEE;
		case PaleVioletRed: return 0xD87093;
		case PapayaWhip: return 0xFFEFD5;
		case PeachPuff: return 0xFFDAB9;
		case Peru: return 0xCD853F;
		case Pink: return 0xFFC0CB;
		case Plum: return 0xDDA0DD;
		case PowderBlue: return 0xB0E0E6;
		case Purple: return 0x800080;
		case Red: return 0xFF0000;
		case RosyBrown: return 0xBC8F8F;
		case RoyalBlue: return 0x4169E1;
		case SaddleBrown: return 0x8B4513;
		case Salmon: return 0xFA8072;
		case SandyBrown: return 0xF4A460;
		case SeaGreen: return 0x2E8B57;
		case SeaShell: return 0xFFF5EE;
		case Sienna: return 0xA0522D;
		case Silver: return 0xC0C0C0;
		case SkyBlue: return 0x87CEEB;
		case SlateBlue: return 0x6A5ACD;
		case SlateGray: return 0x708090;
		case SlateGrey: return 0x708090;
		case Snow: return 0xFFFAFA;
		case SpringGreen: return 0x00FF7F;
		case SteelBlue: return 0x4682B4;
		case Tan: return 0xD2B48C;
		case Teal: return 0x008080;
		case Thistle: return 0xD8BFD8;
		case Tomato: return 0xFF6347;
		case Turquoise: return 0x40E0D0;
		case Violet: return 0xEE82EE;
		case Wheat: return 0xF5DEB3;
		case White: return 0xFFFFFF;
		case WhiteSmoke: return 0xF5F5F5;
		case Yellow: return 0xFFFF00;
		case YellowGreen: return 0x9ACD32;
		}		
	}
	
}

enum EColor {
ColPlaceholder;
ColRGB(r : Int, g : Int, b : Int);
ColHSV(h : Float, s : Float, v : Float);
ColHex(ui : Int);
ColString(v : String);
AliceBlue;
AntiqueWhite;
Aqua;
Aquamarine;
Azure;
Beige;
Bisque;
Black;
BlanchedAlmond;
Blue;
BlueViolet;
Brown;
BurlyWood;
CadetBlue;
Chartreuse;
Chocolate;
Coral;
CornflowerBlue;
Cornsilk;
Crimson;
Cyan;
DarkBlue;
DarkCyan;
DarkGoldenRod;
DarkGray;
DarkGrey;
DarkGreen;
DarkKhaki;
DarkMagenta;
DarkOliveGreen;
Darkorange;
DarkOrchid;
DarkRed;
DarkSalmon;
DarkSeaGreen;
DarkSlateBlue;
DarkSlateGray;
DarkSlateGrey;
DarkTurquoise;
DarkViolet;
DeepPink;
DeepSkyBlue;
DimGray;
DimGrey;
DodgerBlue;
FireBrick;
FloralWhite;
ForestGreen;
Fuchsia;
Gainsboro;
GhostWhite;
Gold;
GoldenRod;
Gray;
Grey;
Green;
GreenYellow;
HoneyDew;
HotPink;
IndianRed ;
Indigo  ;
Ivory;
Khaki;
Lavender;
LavenderBlush;
LawnGreen;
LemonChiffon;
LightBlue;
LightCoral;
LightCyan;
LightGoldenRodYellow;
LightGray;
LightGrey;
LightGreen;
LightPink;
LightSalmon;
LightSeaGreen;
LightSkyBlue;
LightSlateGray;
LightSlateGrey;
LightSteelBlue;
LightYellow;
Lime;
LimeGreen;
Linen;
Magenta;
Maroon;
MediumAquaMarine;
MediumBlue;
MediumOrchid;
MediumPurple;
MediumSeaGreen;
MediumSlateBlue;
MediumSpringGreen;
MediumTurquoise;
MediumVioletRed;
MidnightBlue;
MintCream;
MistyRose;
Moccasin;
NavajoWhite;
Navy;
OldLace;
Olive;
OliveDrab;
Orange;
OrangeRed;
Orchid;
PaleGoldenRod;
PaleGreen;
PaleTurquoise;
PaleVioletRed;
PapayaWhip;
PeachPuff;
Peru;
Pink;
Plum;
PowderBlue;
Purple;
Red;
RosyBrown;
RoyalBlue;
SaddleBrown;
Salmon;
SandyBrown;
SeaGreen;
SeaShell;
Sienna;
Silver;
SkyBlue;
SlateBlue;
SlateGray;
SlateGrey;
Snow;
SpringGreen;
SteelBlue;
Tan;
Teal;
Thistle;
Tomato;
Turquoise;
Violet;
Wheat;
White;
WhiteSmoke;
Yellow;
YellowGreen;
}
