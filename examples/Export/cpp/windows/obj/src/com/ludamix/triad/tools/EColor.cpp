#include <hxcpp.h>

#ifndef INCLUDED_com_ludamix_triad_tools_EColor
#include <com/ludamix/triad/tools/EColor.h>
#endif
namespace com{
namespace ludamix{
namespace triad{
namespace tools{

::com::ludamix::triad::tools::EColor EColor_obj::AliceBlue;

::com::ludamix::triad::tools::EColor EColor_obj::AntiqueWhite;

::com::ludamix::triad::tools::EColor EColor_obj::Aqua;

::com::ludamix::triad::tools::EColor EColor_obj::Aquamarine;

::com::ludamix::triad::tools::EColor EColor_obj::Azure;

::com::ludamix::triad::tools::EColor EColor_obj::Beige;

::com::ludamix::triad::tools::EColor EColor_obj::Bisque;

::com::ludamix::triad::tools::EColor EColor_obj::Black;

::com::ludamix::triad::tools::EColor EColor_obj::BlanchedAlmond;

::com::ludamix::triad::tools::EColor EColor_obj::Blue;

::com::ludamix::triad::tools::EColor EColor_obj::BlueViolet;

::com::ludamix::triad::tools::EColor EColor_obj::Brown;

::com::ludamix::triad::tools::EColor EColor_obj::BurlyWood;

::com::ludamix::triad::tools::EColor EColor_obj::CadetBlue;

::com::ludamix::triad::tools::EColor EColor_obj::Chartreuse;

::com::ludamix::triad::tools::EColor EColor_obj::Chocolate;

::com::ludamix::triad::tools::EColor  EColor_obj::ColHSV(double h,double s,double v)
	{ return hx::CreateEnum< EColor_obj >(HX_CSTRING("ColHSV"),2,hx::DynamicArray(0,3).Add(h).Add(s).Add(v)); }

::com::ludamix::triad::tools::EColor  EColor_obj::ColHex(int ui)
	{ return hx::CreateEnum< EColor_obj >(HX_CSTRING("ColHex"),3,hx::DynamicArray(0,1).Add(ui)); }

::com::ludamix::triad::tools::EColor EColor_obj::ColPlaceholder;

::com::ludamix::triad::tools::EColor  EColor_obj::ColRGB(int r,int g,int b)
	{ return hx::CreateEnum< EColor_obj >(HX_CSTRING("ColRGB"),1,hx::DynamicArray(0,3).Add(r).Add(g).Add(b)); }

::com::ludamix::triad::tools::EColor  EColor_obj::ColString(::String v)
	{ return hx::CreateEnum< EColor_obj >(HX_CSTRING("ColString"),4,hx::DynamicArray(0,1).Add(v)); }

::com::ludamix::triad::tools::EColor EColor_obj::Coral;

::com::ludamix::triad::tools::EColor EColor_obj::CornflowerBlue;

::com::ludamix::triad::tools::EColor EColor_obj::Cornsilk;

::com::ludamix::triad::tools::EColor EColor_obj::Crimson;

::com::ludamix::triad::tools::EColor EColor_obj::Cyan;

::com::ludamix::triad::tools::EColor EColor_obj::DarkBlue;

::com::ludamix::triad::tools::EColor EColor_obj::DarkCyan;

::com::ludamix::triad::tools::EColor EColor_obj::DarkGoldenRod;

::com::ludamix::triad::tools::EColor EColor_obj::DarkGray;

::com::ludamix::triad::tools::EColor EColor_obj::DarkGreen;

::com::ludamix::triad::tools::EColor EColor_obj::DarkGrey;

::com::ludamix::triad::tools::EColor EColor_obj::DarkKhaki;

::com::ludamix::triad::tools::EColor EColor_obj::DarkMagenta;

::com::ludamix::triad::tools::EColor EColor_obj::DarkOliveGreen;

::com::ludamix::triad::tools::EColor EColor_obj::DarkOrchid;

::com::ludamix::triad::tools::EColor EColor_obj::DarkRed;

::com::ludamix::triad::tools::EColor EColor_obj::DarkSalmon;

::com::ludamix::triad::tools::EColor EColor_obj::DarkSeaGreen;

::com::ludamix::triad::tools::EColor EColor_obj::DarkSlateBlue;

::com::ludamix::triad::tools::EColor EColor_obj::DarkSlateGray;

::com::ludamix::triad::tools::EColor EColor_obj::DarkSlateGrey;

::com::ludamix::triad::tools::EColor EColor_obj::DarkTurquoise;

::com::ludamix::triad::tools::EColor EColor_obj::DarkViolet;

::com::ludamix::triad::tools::EColor EColor_obj::Darkorange;

::com::ludamix::triad::tools::EColor EColor_obj::DeepPink;

::com::ludamix::triad::tools::EColor EColor_obj::DeepSkyBlue;

::com::ludamix::triad::tools::EColor EColor_obj::DimGray;

::com::ludamix::triad::tools::EColor EColor_obj::DimGrey;

::com::ludamix::triad::tools::EColor EColor_obj::DodgerBlue;

::com::ludamix::triad::tools::EColor EColor_obj::FireBrick;

::com::ludamix::triad::tools::EColor EColor_obj::FloralWhite;

::com::ludamix::triad::tools::EColor EColor_obj::ForestGreen;

::com::ludamix::triad::tools::EColor EColor_obj::Fuchsia;

::com::ludamix::triad::tools::EColor EColor_obj::Gainsboro;

::com::ludamix::triad::tools::EColor EColor_obj::GhostWhite;

::com::ludamix::triad::tools::EColor EColor_obj::Gold;

::com::ludamix::triad::tools::EColor EColor_obj::GoldenRod;

::com::ludamix::triad::tools::EColor EColor_obj::Gray;

::com::ludamix::triad::tools::EColor EColor_obj::Green;

::com::ludamix::triad::tools::EColor EColor_obj::GreenYellow;

::com::ludamix::triad::tools::EColor EColor_obj::Grey;

::com::ludamix::triad::tools::EColor EColor_obj::HoneyDew;

::com::ludamix::triad::tools::EColor EColor_obj::HotPink;

::com::ludamix::triad::tools::EColor EColor_obj::IndianRed;

::com::ludamix::triad::tools::EColor EColor_obj::Indigo;

::com::ludamix::triad::tools::EColor EColor_obj::Ivory;

::com::ludamix::triad::tools::EColor EColor_obj::Khaki;

::com::ludamix::triad::tools::EColor EColor_obj::Lavender;

::com::ludamix::triad::tools::EColor EColor_obj::LavenderBlush;

::com::ludamix::triad::tools::EColor EColor_obj::LawnGreen;

::com::ludamix::triad::tools::EColor EColor_obj::LemonChiffon;

::com::ludamix::triad::tools::EColor EColor_obj::LightBlue;

::com::ludamix::triad::tools::EColor EColor_obj::LightCoral;

::com::ludamix::triad::tools::EColor EColor_obj::LightCyan;

::com::ludamix::triad::tools::EColor EColor_obj::LightGoldenRodYellow;

::com::ludamix::triad::tools::EColor EColor_obj::LightGray;

::com::ludamix::triad::tools::EColor EColor_obj::LightGreen;

::com::ludamix::triad::tools::EColor EColor_obj::LightGrey;

::com::ludamix::triad::tools::EColor EColor_obj::LightPink;

::com::ludamix::triad::tools::EColor EColor_obj::LightSalmon;

::com::ludamix::triad::tools::EColor EColor_obj::LightSeaGreen;

::com::ludamix::triad::tools::EColor EColor_obj::LightSkyBlue;

::com::ludamix::triad::tools::EColor EColor_obj::LightSlateGray;

::com::ludamix::triad::tools::EColor EColor_obj::LightSlateGrey;

::com::ludamix::triad::tools::EColor EColor_obj::LightSteelBlue;

::com::ludamix::triad::tools::EColor EColor_obj::LightYellow;

::com::ludamix::triad::tools::EColor EColor_obj::Lime;

::com::ludamix::triad::tools::EColor EColor_obj::LimeGreen;

::com::ludamix::triad::tools::EColor EColor_obj::Linen;

::com::ludamix::triad::tools::EColor EColor_obj::Magenta;

::com::ludamix::triad::tools::EColor EColor_obj::Maroon;

::com::ludamix::triad::tools::EColor EColor_obj::MediumAquaMarine;

::com::ludamix::triad::tools::EColor EColor_obj::MediumBlue;

::com::ludamix::triad::tools::EColor EColor_obj::MediumOrchid;

::com::ludamix::triad::tools::EColor EColor_obj::MediumPurple;

::com::ludamix::triad::tools::EColor EColor_obj::MediumSeaGreen;

::com::ludamix::triad::tools::EColor EColor_obj::MediumSlateBlue;

::com::ludamix::triad::tools::EColor EColor_obj::MediumSpringGreen;

::com::ludamix::triad::tools::EColor EColor_obj::MediumTurquoise;

::com::ludamix::triad::tools::EColor EColor_obj::MediumVioletRed;

::com::ludamix::triad::tools::EColor EColor_obj::MidnightBlue;

::com::ludamix::triad::tools::EColor EColor_obj::MintCream;

::com::ludamix::triad::tools::EColor EColor_obj::MistyRose;

::com::ludamix::triad::tools::EColor EColor_obj::Moccasin;

::com::ludamix::triad::tools::EColor EColor_obj::NavajoWhite;

::com::ludamix::triad::tools::EColor EColor_obj::Navy;

::com::ludamix::triad::tools::EColor EColor_obj::OldLace;

::com::ludamix::triad::tools::EColor EColor_obj::Olive;

::com::ludamix::triad::tools::EColor EColor_obj::OliveDrab;

::com::ludamix::triad::tools::EColor EColor_obj::Orange;

::com::ludamix::triad::tools::EColor EColor_obj::OrangeRed;

::com::ludamix::triad::tools::EColor EColor_obj::Orchid;

::com::ludamix::triad::tools::EColor EColor_obj::PaleGoldenRod;

::com::ludamix::triad::tools::EColor EColor_obj::PaleGreen;

::com::ludamix::triad::tools::EColor EColor_obj::PaleTurquoise;

::com::ludamix::triad::tools::EColor EColor_obj::PaleVioletRed;

::com::ludamix::triad::tools::EColor EColor_obj::PapayaWhip;

::com::ludamix::triad::tools::EColor EColor_obj::PeachPuff;

::com::ludamix::triad::tools::EColor EColor_obj::Peru;

::com::ludamix::triad::tools::EColor EColor_obj::Pink;

::com::ludamix::triad::tools::EColor EColor_obj::Plum;

::com::ludamix::triad::tools::EColor EColor_obj::PowderBlue;

::com::ludamix::triad::tools::EColor EColor_obj::Purple;

::com::ludamix::triad::tools::EColor EColor_obj::Red;

::com::ludamix::triad::tools::EColor EColor_obj::RosyBrown;

::com::ludamix::triad::tools::EColor EColor_obj::RoyalBlue;

::com::ludamix::triad::tools::EColor EColor_obj::SaddleBrown;

::com::ludamix::triad::tools::EColor EColor_obj::Salmon;

::com::ludamix::triad::tools::EColor EColor_obj::SandyBrown;

::com::ludamix::triad::tools::EColor EColor_obj::SeaGreen;

::com::ludamix::triad::tools::EColor EColor_obj::SeaShell;

::com::ludamix::triad::tools::EColor EColor_obj::Sienna;

::com::ludamix::triad::tools::EColor EColor_obj::Silver;

::com::ludamix::triad::tools::EColor EColor_obj::SkyBlue;

::com::ludamix::triad::tools::EColor EColor_obj::SlateBlue;

::com::ludamix::triad::tools::EColor EColor_obj::SlateGray;

::com::ludamix::triad::tools::EColor EColor_obj::SlateGrey;

::com::ludamix::triad::tools::EColor EColor_obj::Snow;

::com::ludamix::triad::tools::EColor EColor_obj::SpringGreen;

::com::ludamix::triad::tools::EColor EColor_obj::SteelBlue;

::com::ludamix::triad::tools::EColor EColor_obj::Tan;

::com::ludamix::triad::tools::EColor EColor_obj::Teal;

::com::ludamix::triad::tools::EColor EColor_obj::Thistle;

::com::ludamix::triad::tools::EColor EColor_obj::Tomato;

::com::ludamix::triad::tools::EColor EColor_obj::Turquoise;

::com::ludamix::triad::tools::EColor EColor_obj::Violet;

::com::ludamix::triad::tools::EColor EColor_obj::Wheat;

::com::ludamix::triad::tools::EColor EColor_obj::White;

::com::ludamix::triad::tools::EColor EColor_obj::WhiteSmoke;

::com::ludamix::triad::tools::EColor EColor_obj::Yellow;

::com::ludamix::triad::tools::EColor EColor_obj::YellowGreen;

HX_DEFINE_CREATE_ENUM(EColor_obj)

int EColor_obj::__FindIndex(::String inName)
{
	if (inName==HX_CSTRING("AliceBlue")) return 5;
	if (inName==HX_CSTRING("AntiqueWhite")) return 6;
	if (inName==HX_CSTRING("Aqua")) return 7;
	if (inName==HX_CSTRING("Aquamarine")) return 8;
	if (inName==HX_CSTRING("Azure")) return 9;
	if (inName==HX_CSTRING("Beige")) return 10;
	if (inName==HX_CSTRING("Bisque")) return 11;
	if (inName==HX_CSTRING("Black")) return 12;
	if (inName==HX_CSTRING("BlanchedAlmond")) return 13;
	if (inName==HX_CSTRING("Blue")) return 14;
	if (inName==HX_CSTRING("BlueViolet")) return 15;
	if (inName==HX_CSTRING("Brown")) return 16;
	if (inName==HX_CSTRING("BurlyWood")) return 17;
	if (inName==HX_CSTRING("CadetBlue")) return 18;
	if (inName==HX_CSTRING("Chartreuse")) return 19;
	if (inName==HX_CSTRING("Chocolate")) return 20;
	if (inName==HX_CSTRING("ColHSV")) return 2;
	if (inName==HX_CSTRING("ColHex")) return 3;
	if (inName==HX_CSTRING("ColPlaceholder")) return 0;
	if (inName==HX_CSTRING("ColRGB")) return 1;
	if (inName==HX_CSTRING("ColString")) return 4;
	if (inName==HX_CSTRING("Coral")) return 21;
	if (inName==HX_CSTRING("CornflowerBlue")) return 22;
	if (inName==HX_CSTRING("Cornsilk")) return 23;
	if (inName==HX_CSTRING("Crimson")) return 24;
	if (inName==HX_CSTRING("Cyan")) return 25;
	if (inName==HX_CSTRING("DarkBlue")) return 26;
	if (inName==HX_CSTRING("DarkCyan")) return 27;
	if (inName==HX_CSTRING("DarkGoldenRod")) return 28;
	if (inName==HX_CSTRING("DarkGray")) return 29;
	if (inName==HX_CSTRING("DarkGreen")) return 31;
	if (inName==HX_CSTRING("DarkGrey")) return 30;
	if (inName==HX_CSTRING("DarkKhaki")) return 32;
	if (inName==HX_CSTRING("DarkMagenta")) return 33;
	if (inName==HX_CSTRING("DarkOliveGreen")) return 34;
	if (inName==HX_CSTRING("DarkOrchid")) return 36;
	if (inName==HX_CSTRING("DarkRed")) return 37;
	if (inName==HX_CSTRING("DarkSalmon")) return 38;
	if (inName==HX_CSTRING("DarkSeaGreen")) return 39;
	if (inName==HX_CSTRING("DarkSlateBlue")) return 40;
	if (inName==HX_CSTRING("DarkSlateGray")) return 41;
	if (inName==HX_CSTRING("DarkSlateGrey")) return 42;
	if (inName==HX_CSTRING("DarkTurquoise")) return 43;
	if (inName==HX_CSTRING("DarkViolet")) return 44;
	if (inName==HX_CSTRING("Darkorange")) return 35;
	if (inName==HX_CSTRING("DeepPink")) return 45;
	if (inName==HX_CSTRING("DeepSkyBlue")) return 46;
	if (inName==HX_CSTRING("DimGray")) return 47;
	if (inName==HX_CSTRING("DimGrey")) return 48;
	if (inName==HX_CSTRING("DodgerBlue")) return 49;
	if (inName==HX_CSTRING("FireBrick")) return 50;
	if (inName==HX_CSTRING("FloralWhite")) return 51;
	if (inName==HX_CSTRING("ForestGreen")) return 52;
	if (inName==HX_CSTRING("Fuchsia")) return 53;
	if (inName==HX_CSTRING("Gainsboro")) return 54;
	if (inName==HX_CSTRING("GhostWhite")) return 55;
	if (inName==HX_CSTRING("Gold")) return 56;
	if (inName==HX_CSTRING("GoldenRod")) return 57;
	if (inName==HX_CSTRING("Gray")) return 58;
	if (inName==HX_CSTRING("Green")) return 60;
	if (inName==HX_CSTRING("GreenYellow")) return 61;
	if (inName==HX_CSTRING("Grey")) return 59;
	if (inName==HX_CSTRING("HoneyDew")) return 62;
	if (inName==HX_CSTRING("HotPink")) return 63;
	if (inName==HX_CSTRING("IndianRed")) return 64;
	if (inName==HX_CSTRING("Indigo")) return 65;
	if (inName==HX_CSTRING("Ivory")) return 66;
	if (inName==HX_CSTRING("Khaki")) return 67;
	if (inName==HX_CSTRING("Lavender")) return 68;
	if (inName==HX_CSTRING("LavenderBlush")) return 69;
	if (inName==HX_CSTRING("LawnGreen")) return 70;
	if (inName==HX_CSTRING("LemonChiffon")) return 71;
	if (inName==HX_CSTRING("LightBlue")) return 72;
	if (inName==HX_CSTRING("LightCoral")) return 73;
	if (inName==HX_CSTRING("LightCyan")) return 74;
	if (inName==HX_CSTRING("LightGoldenRodYellow")) return 75;
	if (inName==HX_CSTRING("LightGray")) return 76;
	if (inName==HX_CSTRING("LightGreen")) return 78;
	if (inName==HX_CSTRING("LightGrey")) return 77;
	if (inName==HX_CSTRING("LightPink")) return 79;
	if (inName==HX_CSTRING("LightSalmon")) return 80;
	if (inName==HX_CSTRING("LightSeaGreen")) return 81;
	if (inName==HX_CSTRING("LightSkyBlue")) return 82;
	if (inName==HX_CSTRING("LightSlateGray")) return 83;
	if (inName==HX_CSTRING("LightSlateGrey")) return 84;
	if (inName==HX_CSTRING("LightSteelBlue")) return 85;
	if (inName==HX_CSTRING("LightYellow")) return 86;
	if (inName==HX_CSTRING("Lime")) return 87;
	if (inName==HX_CSTRING("LimeGreen")) return 88;
	if (inName==HX_CSTRING("Linen")) return 89;
	if (inName==HX_CSTRING("Magenta")) return 90;
	if (inName==HX_CSTRING("Maroon")) return 91;
	if (inName==HX_CSTRING("MediumAquaMarine")) return 92;
	if (inName==HX_CSTRING("MediumBlue")) return 93;
	if (inName==HX_CSTRING("MediumOrchid")) return 94;
	if (inName==HX_CSTRING("MediumPurple")) return 95;
	if (inName==HX_CSTRING("MediumSeaGreen")) return 96;
	if (inName==HX_CSTRING("MediumSlateBlue")) return 97;
	if (inName==HX_CSTRING("MediumSpringGreen")) return 98;
	if (inName==HX_CSTRING("MediumTurquoise")) return 99;
	if (inName==HX_CSTRING("MediumVioletRed")) return 100;
	if (inName==HX_CSTRING("MidnightBlue")) return 101;
	if (inName==HX_CSTRING("MintCream")) return 102;
	if (inName==HX_CSTRING("MistyRose")) return 103;
	if (inName==HX_CSTRING("Moccasin")) return 104;
	if (inName==HX_CSTRING("NavajoWhite")) return 105;
	if (inName==HX_CSTRING("Navy")) return 106;
	if (inName==HX_CSTRING("OldLace")) return 107;
	if (inName==HX_CSTRING("Olive")) return 108;
	if (inName==HX_CSTRING("OliveDrab")) return 109;
	if (inName==HX_CSTRING("Orange")) return 110;
	if (inName==HX_CSTRING("OrangeRed")) return 111;
	if (inName==HX_CSTRING("Orchid")) return 112;
	if (inName==HX_CSTRING("PaleGoldenRod")) return 113;
	if (inName==HX_CSTRING("PaleGreen")) return 114;
	if (inName==HX_CSTRING("PaleTurquoise")) return 115;
	if (inName==HX_CSTRING("PaleVioletRed")) return 116;
	if (inName==HX_CSTRING("PapayaWhip")) return 117;
	if (inName==HX_CSTRING("PeachPuff")) return 118;
	if (inName==HX_CSTRING("Peru")) return 119;
	if (inName==HX_CSTRING("Pink")) return 120;
	if (inName==HX_CSTRING("Plum")) return 121;
	if (inName==HX_CSTRING("PowderBlue")) return 122;
	if (inName==HX_CSTRING("Purple")) return 123;
	if (inName==HX_CSTRING("Red")) return 124;
	if (inName==HX_CSTRING("RosyBrown")) return 125;
	if (inName==HX_CSTRING("RoyalBlue")) return 126;
	if (inName==HX_CSTRING("SaddleBrown")) return 127;
	if (inName==HX_CSTRING("Salmon")) return 128;
	if (inName==HX_CSTRING("SandyBrown")) return 129;
	if (inName==HX_CSTRING("SeaGreen")) return 130;
	if (inName==HX_CSTRING("SeaShell")) return 131;
	if (inName==HX_CSTRING("Sienna")) return 132;
	if (inName==HX_CSTRING("Silver")) return 133;
	if (inName==HX_CSTRING("SkyBlue")) return 134;
	if (inName==HX_CSTRING("SlateBlue")) return 135;
	if (inName==HX_CSTRING("SlateGray")) return 136;
	if (inName==HX_CSTRING("SlateGrey")) return 137;
	if (inName==HX_CSTRING("Snow")) return 138;
	if (inName==HX_CSTRING("SpringGreen")) return 139;
	if (inName==HX_CSTRING("SteelBlue")) return 140;
	if (inName==HX_CSTRING("Tan")) return 141;
	if (inName==HX_CSTRING("Teal")) return 142;
	if (inName==HX_CSTRING("Thistle")) return 143;
	if (inName==HX_CSTRING("Tomato")) return 144;
	if (inName==HX_CSTRING("Turquoise")) return 145;
	if (inName==HX_CSTRING("Violet")) return 146;
	if (inName==HX_CSTRING("Wheat")) return 147;
	if (inName==HX_CSTRING("White")) return 148;
	if (inName==HX_CSTRING("WhiteSmoke")) return 149;
	if (inName==HX_CSTRING("Yellow")) return 150;
	if (inName==HX_CSTRING("YellowGreen")) return 151;
	return super::__FindIndex(inName);
}

STATIC_HX_DEFINE_DYNAMIC_FUNC3(EColor_obj,ColHSV,return)

STATIC_HX_DEFINE_DYNAMIC_FUNC1(EColor_obj,ColHex,return)

STATIC_HX_DEFINE_DYNAMIC_FUNC3(EColor_obj,ColRGB,return)

STATIC_HX_DEFINE_DYNAMIC_FUNC1(EColor_obj,ColString,return)

int EColor_obj::__FindArgCount(::String inName)
{
	if (inName==HX_CSTRING("AliceBlue")) return 0;
	if (inName==HX_CSTRING("AntiqueWhite")) return 0;
	if (inName==HX_CSTRING("Aqua")) return 0;
	if (inName==HX_CSTRING("Aquamarine")) return 0;
	if (inName==HX_CSTRING("Azure")) return 0;
	if (inName==HX_CSTRING("Beige")) return 0;
	if (inName==HX_CSTRING("Bisque")) return 0;
	if (inName==HX_CSTRING("Black")) return 0;
	if (inName==HX_CSTRING("BlanchedAlmond")) return 0;
	if (inName==HX_CSTRING("Blue")) return 0;
	if (inName==HX_CSTRING("BlueViolet")) return 0;
	if (inName==HX_CSTRING("Brown")) return 0;
	if (inName==HX_CSTRING("BurlyWood")) return 0;
	if (inName==HX_CSTRING("CadetBlue")) return 0;
	if (inName==HX_CSTRING("Chartreuse")) return 0;
	if (inName==HX_CSTRING("Chocolate")) return 0;
	if (inName==HX_CSTRING("ColHSV")) return 3;
	if (inName==HX_CSTRING("ColHex")) return 1;
	if (inName==HX_CSTRING("ColPlaceholder")) return 0;
	if (inName==HX_CSTRING("ColRGB")) return 3;
	if (inName==HX_CSTRING("ColString")) return 1;
	if (inName==HX_CSTRING("Coral")) return 0;
	if (inName==HX_CSTRING("CornflowerBlue")) return 0;
	if (inName==HX_CSTRING("Cornsilk")) return 0;
	if (inName==HX_CSTRING("Crimson")) return 0;
	if (inName==HX_CSTRING("Cyan")) return 0;
	if (inName==HX_CSTRING("DarkBlue")) return 0;
	if (inName==HX_CSTRING("DarkCyan")) return 0;
	if (inName==HX_CSTRING("DarkGoldenRod")) return 0;
	if (inName==HX_CSTRING("DarkGray")) return 0;
	if (inName==HX_CSTRING("DarkGreen")) return 0;
	if (inName==HX_CSTRING("DarkGrey")) return 0;
	if (inName==HX_CSTRING("DarkKhaki")) return 0;
	if (inName==HX_CSTRING("DarkMagenta")) return 0;
	if (inName==HX_CSTRING("DarkOliveGreen")) return 0;
	if (inName==HX_CSTRING("DarkOrchid")) return 0;
	if (inName==HX_CSTRING("DarkRed")) return 0;
	if (inName==HX_CSTRING("DarkSalmon")) return 0;
	if (inName==HX_CSTRING("DarkSeaGreen")) return 0;
	if (inName==HX_CSTRING("DarkSlateBlue")) return 0;
	if (inName==HX_CSTRING("DarkSlateGray")) return 0;
	if (inName==HX_CSTRING("DarkSlateGrey")) return 0;
	if (inName==HX_CSTRING("DarkTurquoise")) return 0;
	if (inName==HX_CSTRING("DarkViolet")) return 0;
	if (inName==HX_CSTRING("Darkorange")) return 0;
	if (inName==HX_CSTRING("DeepPink")) return 0;
	if (inName==HX_CSTRING("DeepSkyBlue")) return 0;
	if (inName==HX_CSTRING("DimGray")) return 0;
	if (inName==HX_CSTRING("DimGrey")) return 0;
	if (inName==HX_CSTRING("DodgerBlue")) return 0;
	if (inName==HX_CSTRING("FireBrick")) return 0;
	if (inName==HX_CSTRING("FloralWhite")) return 0;
	if (inName==HX_CSTRING("ForestGreen")) return 0;
	if (inName==HX_CSTRING("Fuchsia")) return 0;
	if (inName==HX_CSTRING("Gainsboro")) return 0;
	if (inName==HX_CSTRING("GhostWhite")) return 0;
	if (inName==HX_CSTRING("Gold")) return 0;
	if (inName==HX_CSTRING("GoldenRod")) return 0;
	if (inName==HX_CSTRING("Gray")) return 0;
	if (inName==HX_CSTRING("Green")) return 0;
	if (inName==HX_CSTRING("GreenYellow")) return 0;
	if (inName==HX_CSTRING("Grey")) return 0;
	if (inName==HX_CSTRING("HoneyDew")) return 0;
	if (inName==HX_CSTRING("HotPink")) return 0;
	if (inName==HX_CSTRING("IndianRed")) return 0;
	if (inName==HX_CSTRING("Indigo")) return 0;
	if (inName==HX_CSTRING("Ivory")) return 0;
	if (inName==HX_CSTRING("Khaki")) return 0;
	if (inName==HX_CSTRING("Lavender")) return 0;
	if (inName==HX_CSTRING("LavenderBlush")) return 0;
	if (inName==HX_CSTRING("LawnGreen")) return 0;
	if (inName==HX_CSTRING("LemonChiffon")) return 0;
	if (inName==HX_CSTRING("LightBlue")) return 0;
	if (inName==HX_CSTRING("LightCoral")) return 0;
	if (inName==HX_CSTRING("LightCyan")) return 0;
	if (inName==HX_CSTRING("LightGoldenRodYellow")) return 0;
	if (inName==HX_CSTRING("LightGray")) return 0;
	if (inName==HX_CSTRING("LightGreen")) return 0;
	if (inName==HX_CSTRING("LightGrey")) return 0;
	if (inName==HX_CSTRING("LightPink")) return 0;
	if (inName==HX_CSTRING("LightSalmon")) return 0;
	if (inName==HX_CSTRING("LightSeaGreen")) return 0;
	if (inName==HX_CSTRING("LightSkyBlue")) return 0;
	if (inName==HX_CSTRING("LightSlateGray")) return 0;
	if (inName==HX_CSTRING("LightSlateGrey")) return 0;
	if (inName==HX_CSTRING("LightSteelBlue")) return 0;
	if (inName==HX_CSTRING("LightYellow")) return 0;
	if (inName==HX_CSTRING("Lime")) return 0;
	if (inName==HX_CSTRING("LimeGreen")) return 0;
	if (inName==HX_CSTRING("Linen")) return 0;
	if (inName==HX_CSTRING("Magenta")) return 0;
	if (inName==HX_CSTRING("Maroon")) return 0;
	if (inName==HX_CSTRING("MediumAquaMarine")) return 0;
	if (inName==HX_CSTRING("MediumBlue")) return 0;
	if (inName==HX_CSTRING("MediumOrchid")) return 0;
	if (inName==HX_CSTRING("MediumPurple")) return 0;
	if (inName==HX_CSTRING("MediumSeaGreen")) return 0;
	if (inName==HX_CSTRING("MediumSlateBlue")) return 0;
	if (inName==HX_CSTRING("MediumSpringGreen")) return 0;
	if (inName==HX_CSTRING("MediumTurquoise")) return 0;
	if (inName==HX_CSTRING("MediumVioletRed")) return 0;
	if (inName==HX_CSTRING("MidnightBlue")) return 0;
	if (inName==HX_CSTRING("MintCream")) return 0;
	if (inName==HX_CSTRING("MistyRose")) return 0;
	if (inName==HX_CSTRING("Moccasin")) return 0;
	if (inName==HX_CSTRING("NavajoWhite")) return 0;
	if (inName==HX_CSTRING("Navy")) return 0;
	if (inName==HX_CSTRING("OldLace")) return 0;
	if (inName==HX_CSTRING("Olive")) return 0;
	if (inName==HX_CSTRING("OliveDrab")) return 0;
	if (inName==HX_CSTRING("Orange")) return 0;
	if (inName==HX_CSTRING("OrangeRed")) return 0;
	if (inName==HX_CSTRING("Orchid")) return 0;
	if (inName==HX_CSTRING("PaleGoldenRod")) return 0;
	if (inName==HX_CSTRING("PaleGreen")) return 0;
	if (inName==HX_CSTRING("PaleTurquoise")) return 0;
	if (inName==HX_CSTRING("PaleVioletRed")) return 0;
	if (inName==HX_CSTRING("PapayaWhip")) return 0;
	if (inName==HX_CSTRING("PeachPuff")) return 0;
	if (inName==HX_CSTRING("Peru")) return 0;
	if (inName==HX_CSTRING("Pink")) return 0;
	if (inName==HX_CSTRING("Plum")) return 0;
	if (inName==HX_CSTRING("PowderBlue")) return 0;
	if (inName==HX_CSTRING("Purple")) return 0;
	if (inName==HX_CSTRING("Red")) return 0;
	if (inName==HX_CSTRING("RosyBrown")) return 0;
	if (inName==HX_CSTRING("RoyalBlue")) return 0;
	if (inName==HX_CSTRING("SaddleBrown")) return 0;
	if (inName==HX_CSTRING("Salmon")) return 0;
	if (inName==HX_CSTRING("SandyBrown")) return 0;
	if (inName==HX_CSTRING("SeaGreen")) return 0;
	if (inName==HX_CSTRING("SeaShell")) return 0;
	if (inName==HX_CSTRING("Sienna")) return 0;
	if (inName==HX_CSTRING("Silver")) return 0;
	if (inName==HX_CSTRING("SkyBlue")) return 0;
	if (inName==HX_CSTRING("SlateBlue")) return 0;
	if (inName==HX_CSTRING("SlateGray")) return 0;
	if (inName==HX_CSTRING("SlateGrey")) return 0;
	if (inName==HX_CSTRING("Snow")) return 0;
	if (inName==HX_CSTRING("SpringGreen")) return 0;
	if (inName==HX_CSTRING("SteelBlue")) return 0;
	if (inName==HX_CSTRING("Tan")) return 0;
	if (inName==HX_CSTRING("Teal")) return 0;
	if (inName==HX_CSTRING("Thistle")) return 0;
	if (inName==HX_CSTRING("Tomato")) return 0;
	if (inName==HX_CSTRING("Turquoise")) return 0;
	if (inName==HX_CSTRING("Violet")) return 0;
	if (inName==HX_CSTRING("Wheat")) return 0;
	if (inName==HX_CSTRING("White")) return 0;
	if (inName==HX_CSTRING("WhiteSmoke")) return 0;
	if (inName==HX_CSTRING("Yellow")) return 0;
	if (inName==HX_CSTRING("YellowGreen")) return 0;
	return super::__FindArgCount(inName);
}

Dynamic EColor_obj::__Field(const ::String &inName)
{
	if (inName==HX_CSTRING("AliceBlue")) return AliceBlue;
	if (inName==HX_CSTRING("AntiqueWhite")) return AntiqueWhite;
	if (inName==HX_CSTRING("Aqua")) return Aqua;
	if (inName==HX_CSTRING("Aquamarine")) return Aquamarine;
	if (inName==HX_CSTRING("Azure")) return Azure;
	if (inName==HX_CSTRING("Beige")) return Beige;
	if (inName==HX_CSTRING("Bisque")) return Bisque;
	if (inName==HX_CSTRING("Black")) return Black;
	if (inName==HX_CSTRING("BlanchedAlmond")) return BlanchedAlmond;
	if (inName==HX_CSTRING("Blue")) return Blue;
	if (inName==HX_CSTRING("BlueViolet")) return BlueViolet;
	if (inName==HX_CSTRING("Brown")) return Brown;
	if (inName==HX_CSTRING("BurlyWood")) return BurlyWood;
	if (inName==HX_CSTRING("CadetBlue")) return CadetBlue;
	if (inName==HX_CSTRING("Chartreuse")) return Chartreuse;
	if (inName==HX_CSTRING("Chocolate")) return Chocolate;
	if (inName==HX_CSTRING("ColHSV")) return ColHSV_dyn();
	if (inName==HX_CSTRING("ColHex")) return ColHex_dyn();
	if (inName==HX_CSTRING("ColPlaceholder")) return ColPlaceholder;
	if (inName==HX_CSTRING("ColRGB")) return ColRGB_dyn();
	if (inName==HX_CSTRING("ColString")) return ColString_dyn();
	if (inName==HX_CSTRING("Coral")) return Coral;
	if (inName==HX_CSTRING("CornflowerBlue")) return CornflowerBlue;
	if (inName==HX_CSTRING("Cornsilk")) return Cornsilk;
	if (inName==HX_CSTRING("Crimson")) return Crimson;
	if (inName==HX_CSTRING("Cyan")) return Cyan;
	if (inName==HX_CSTRING("DarkBlue")) return DarkBlue;
	if (inName==HX_CSTRING("DarkCyan")) return DarkCyan;
	if (inName==HX_CSTRING("DarkGoldenRod")) return DarkGoldenRod;
	if (inName==HX_CSTRING("DarkGray")) return DarkGray;
	if (inName==HX_CSTRING("DarkGreen")) return DarkGreen;
	if (inName==HX_CSTRING("DarkGrey")) return DarkGrey;
	if (inName==HX_CSTRING("DarkKhaki")) return DarkKhaki;
	if (inName==HX_CSTRING("DarkMagenta")) return DarkMagenta;
	if (inName==HX_CSTRING("DarkOliveGreen")) return DarkOliveGreen;
	if (inName==HX_CSTRING("DarkOrchid")) return DarkOrchid;
	if (inName==HX_CSTRING("DarkRed")) return DarkRed;
	if (inName==HX_CSTRING("DarkSalmon")) return DarkSalmon;
	if (inName==HX_CSTRING("DarkSeaGreen")) return DarkSeaGreen;
	if (inName==HX_CSTRING("DarkSlateBlue")) return DarkSlateBlue;
	if (inName==HX_CSTRING("DarkSlateGray")) return DarkSlateGray;
	if (inName==HX_CSTRING("DarkSlateGrey")) return DarkSlateGrey;
	if (inName==HX_CSTRING("DarkTurquoise")) return DarkTurquoise;
	if (inName==HX_CSTRING("DarkViolet")) return DarkViolet;
	if (inName==HX_CSTRING("Darkorange")) return Darkorange;
	if (inName==HX_CSTRING("DeepPink")) return DeepPink;
	if (inName==HX_CSTRING("DeepSkyBlue")) return DeepSkyBlue;
	if (inName==HX_CSTRING("DimGray")) return DimGray;
	if (inName==HX_CSTRING("DimGrey")) return DimGrey;
	if (inName==HX_CSTRING("DodgerBlue")) return DodgerBlue;
	if (inName==HX_CSTRING("FireBrick")) return FireBrick;
	if (inName==HX_CSTRING("FloralWhite")) return FloralWhite;
	if (inName==HX_CSTRING("ForestGreen")) return ForestGreen;
	if (inName==HX_CSTRING("Fuchsia")) return Fuchsia;
	if (inName==HX_CSTRING("Gainsboro")) return Gainsboro;
	if (inName==HX_CSTRING("GhostWhite")) return GhostWhite;
	if (inName==HX_CSTRING("Gold")) return Gold;
	if (inName==HX_CSTRING("GoldenRod")) return GoldenRod;
	if (inName==HX_CSTRING("Gray")) return Gray;
	if (inName==HX_CSTRING("Green")) return Green;
	if (inName==HX_CSTRING("GreenYellow")) return GreenYellow;
	if (inName==HX_CSTRING("Grey")) return Grey;
	if (inName==HX_CSTRING("HoneyDew")) return HoneyDew;
	if (inName==HX_CSTRING("HotPink")) return HotPink;
	if (inName==HX_CSTRING("IndianRed")) return IndianRed;
	if (inName==HX_CSTRING("Indigo")) return Indigo;
	if (inName==HX_CSTRING("Ivory")) return Ivory;
	if (inName==HX_CSTRING("Khaki")) return Khaki;
	if (inName==HX_CSTRING("Lavender")) return Lavender;
	if (inName==HX_CSTRING("LavenderBlush")) return LavenderBlush;
	if (inName==HX_CSTRING("LawnGreen")) return LawnGreen;
	if (inName==HX_CSTRING("LemonChiffon")) return LemonChiffon;
	if (inName==HX_CSTRING("LightBlue")) return LightBlue;
	if (inName==HX_CSTRING("LightCoral")) return LightCoral;
	if (inName==HX_CSTRING("LightCyan")) return LightCyan;
	if (inName==HX_CSTRING("LightGoldenRodYellow")) return LightGoldenRodYellow;
	if (inName==HX_CSTRING("LightGray")) return LightGray;
	if (inName==HX_CSTRING("LightGreen")) return LightGreen;
	if (inName==HX_CSTRING("LightGrey")) return LightGrey;
	if (inName==HX_CSTRING("LightPink")) return LightPink;
	if (inName==HX_CSTRING("LightSalmon")) return LightSalmon;
	if (inName==HX_CSTRING("LightSeaGreen")) return LightSeaGreen;
	if (inName==HX_CSTRING("LightSkyBlue")) return LightSkyBlue;
	if (inName==HX_CSTRING("LightSlateGray")) return LightSlateGray;
	if (inName==HX_CSTRING("LightSlateGrey")) return LightSlateGrey;
	if (inName==HX_CSTRING("LightSteelBlue")) return LightSteelBlue;
	if (inName==HX_CSTRING("LightYellow")) return LightYellow;
	if (inName==HX_CSTRING("Lime")) return Lime;
	if (inName==HX_CSTRING("LimeGreen")) return LimeGreen;
	if (inName==HX_CSTRING("Linen")) return Linen;
	if (inName==HX_CSTRING("Magenta")) return Magenta;
	if (inName==HX_CSTRING("Maroon")) return Maroon;
	if (inName==HX_CSTRING("MediumAquaMarine")) return MediumAquaMarine;
	if (inName==HX_CSTRING("MediumBlue")) return MediumBlue;
	if (inName==HX_CSTRING("MediumOrchid")) return MediumOrchid;
	if (inName==HX_CSTRING("MediumPurple")) return MediumPurple;
	if (inName==HX_CSTRING("MediumSeaGreen")) return MediumSeaGreen;
	if (inName==HX_CSTRING("MediumSlateBlue")) return MediumSlateBlue;
	if (inName==HX_CSTRING("MediumSpringGreen")) return MediumSpringGreen;
	if (inName==HX_CSTRING("MediumTurquoise")) return MediumTurquoise;
	if (inName==HX_CSTRING("MediumVioletRed")) return MediumVioletRed;
	if (inName==HX_CSTRING("MidnightBlue")) return MidnightBlue;
	if (inName==HX_CSTRING("MintCream")) return MintCream;
	if (inName==HX_CSTRING("MistyRose")) return MistyRose;
	if (inName==HX_CSTRING("Moccasin")) return Moccasin;
	if (inName==HX_CSTRING("NavajoWhite")) return NavajoWhite;
	if (inName==HX_CSTRING("Navy")) return Navy;
	if (inName==HX_CSTRING("OldLace")) return OldLace;
	if (inName==HX_CSTRING("Olive")) return Olive;
	if (inName==HX_CSTRING("OliveDrab")) return OliveDrab;
	if (inName==HX_CSTRING("Orange")) return Orange;
	if (inName==HX_CSTRING("OrangeRed")) return OrangeRed;
	if (inName==HX_CSTRING("Orchid")) return Orchid;
	if (inName==HX_CSTRING("PaleGoldenRod")) return PaleGoldenRod;
	if (inName==HX_CSTRING("PaleGreen")) return PaleGreen;
	if (inName==HX_CSTRING("PaleTurquoise")) return PaleTurquoise;
	if (inName==HX_CSTRING("PaleVioletRed")) return PaleVioletRed;
	if (inName==HX_CSTRING("PapayaWhip")) return PapayaWhip;
	if (inName==HX_CSTRING("PeachPuff")) return PeachPuff;
	if (inName==HX_CSTRING("Peru")) return Peru;
	if (inName==HX_CSTRING("Pink")) return Pink;
	if (inName==HX_CSTRING("Plum")) return Plum;
	if (inName==HX_CSTRING("PowderBlue")) return PowderBlue;
	if (inName==HX_CSTRING("Purple")) return Purple;
	if (inName==HX_CSTRING("Red")) return Red;
	if (inName==HX_CSTRING("RosyBrown")) return RosyBrown;
	if (inName==HX_CSTRING("RoyalBlue")) return RoyalBlue;
	if (inName==HX_CSTRING("SaddleBrown")) return SaddleBrown;
	if (inName==HX_CSTRING("Salmon")) return Salmon;
	if (inName==HX_CSTRING("SandyBrown")) return SandyBrown;
	if (inName==HX_CSTRING("SeaGreen")) return SeaGreen;
	if (inName==HX_CSTRING("SeaShell")) return SeaShell;
	if (inName==HX_CSTRING("Sienna")) return Sienna;
	if (inName==HX_CSTRING("Silver")) return Silver;
	if (inName==HX_CSTRING("SkyBlue")) return SkyBlue;
	if (inName==HX_CSTRING("SlateBlue")) return SlateBlue;
	if (inName==HX_CSTRING("SlateGray")) return SlateGray;
	if (inName==HX_CSTRING("SlateGrey")) return SlateGrey;
	if (inName==HX_CSTRING("Snow")) return Snow;
	if (inName==HX_CSTRING("SpringGreen")) return SpringGreen;
	if (inName==HX_CSTRING("SteelBlue")) return SteelBlue;
	if (inName==HX_CSTRING("Tan")) return Tan;
	if (inName==HX_CSTRING("Teal")) return Teal;
	if (inName==HX_CSTRING("Thistle")) return Thistle;
	if (inName==HX_CSTRING("Tomato")) return Tomato;
	if (inName==HX_CSTRING("Turquoise")) return Turquoise;
	if (inName==HX_CSTRING("Violet")) return Violet;
	if (inName==HX_CSTRING("Wheat")) return Wheat;
	if (inName==HX_CSTRING("White")) return White;
	if (inName==HX_CSTRING("WhiteSmoke")) return WhiteSmoke;
	if (inName==HX_CSTRING("Yellow")) return Yellow;
	if (inName==HX_CSTRING("YellowGreen")) return YellowGreen;
	return super::__Field(inName);
}

static ::String sStaticFields[] = {
	HX_CSTRING("ColPlaceholder"),
	HX_CSTRING("ColRGB"),
	HX_CSTRING("ColHSV"),
	HX_CSTRING("ColHex"),
	HX_CSTRING("ColString"),
	HX_CSTRING("AliceBlue"),
	HX_CSTRING("AntiqueWhite"),
	HX_CSTRING("Aqua"),
	HX_CSTRING("Aquamarine"),
	HX_CSTRING("Azure"),
	HX_CSTRING("Beige"),
	HX_CSTRING("Bisque"),
	HX_CSTRING("Black"),
	HX_CSTRING("BlanchedAlmond"),
	HX_CSTRING("Blue"),
	HX_CSTRING("BlueViolet"),
	HX_CSTRING("Brown"),
	HX_CSTRING("BurlyWood"),
	HX_CSTRING("CadetBlue"),
	HX_CSTRING("Chartreuse"),
	HX_CSTRING("Chocolate"),
	HX_CSTRING("Coral"),
	HX_CSTRING("CornflowerBlue"),
	HX_CSTRING("Cornsilk"),
	HX_CSTRING("Crimson"),
	HX_CSTRING("Cyan"),
	HX_CSTRING("DarkBlue"),
	HX_CSTRING("DarkCyan"),
	HX_CSTRING("DarkGoldenRod"),
	HX_CSTRING("DarkGray"),
	HX_CSTRING("DarkGrey"),
	HX_CSTRING("DarkGreen"),
	HX_CSTRING("DarkKhaki"),
	HX_CSTRING("DarkMagenta"),
	HX_CSTRING("DarkOliveGreen"),
	HX_CSTRING("Darkorange"),
	HX_CSTRING("DarkOrchid"),
	HX_CSTRING("DarkRed"),
	HX_CSTRING("DarkSalmon"),
	HX_CSTRING("DarkSeaGreen"),
	HX_CSTRING("DarkSlateBlue"),
	HX_CSTRING("DarkSlateGray"),
	HX_CSTRING("DarkSlateGrey"),
	HX_CSTRING("DarkTurquoise"),
	HX_CSTRING("DarkViolet"),
	HX_CSTRING("DeepPink"),
	HX_CSTRING("DeepSkyBlue"),
	HX_CSTRING("DimGray"),
	HX_CSTRING("DimGrey"),
	HX_CSTRING("DodgerBlue"),
	HX_CSTRING("FireBrick"),
	HX_CSTRING("FloralWhite"),
	HX_CSTRING("ForestGreen"),
	HX_CSTRING("Fuchsia"),
	HX_CSTRING("Gainsboro"),
	HX_CSTRING("GhostWhite"),
	HX_CSTRING("Gold"),
	HX_CSTRING("GoldenRod"),
	HX_CSTRING("Gray"),
	HX_CSTRING("Grey"),
	HX_CSTRING("Green"),
	HX_CSTRING("GreenYellow"),
	HX_CSTRING("HoneyDew"),
	HX_CSTRING("HotPink"),
	HX_CSTRING("IndianRed"),
	HX_CSTRING("Indigo"),
	HX_CSTRING("Ivory"),
	HX_CSTRING("Khaki"),
	HX_CSTRING("Lavender"),
	HX_CSTRING("LavenderBlush"),
	HX_CSTRING("LawnGreen"),
	HX_CSTRING("LemonChiffon"),
	HX_CSTRING("LightBlue"),
	HX_CSTRING("LightCoral"),
	HX_CSTRING("LightCyan"),
	HX_CSTRING("LightGoldenRodYellow"),
	HX_CSTRING("LightGray"),
	HX_CSTRING("LightGrey"),
	HX_CSTRING("LightGreen"),
	HX_CSTRING("LightPink"),
	HX_CSTRING("LightSalmon"),
	HX_CSTRING("LightSeaGreen"),
	HX_CSTRING("LightSkyBlue"),
	HX_CSTRING("LightSlateGray"),
	HX_CSTRING("LightSlateGrey"),
	HX_CSTRING("LightSteelBlue"),
	HX_CSTRING("LightYellow"),
	HX_CSTRING("Lime"),
	HX_CSTRING("LimeGreen"),
	HX_CSTRING("Linen"),
	HX_CSTRING("Magenta"),
	HX_CSTRING("Maroon"),
	HX_CSTRING("MediumAquaMarine"),
	HX_CSTRING("MediumBlue"),
	HX_CSTRING("MediumOrchid"),
	HX_CSTRING("MediumPurple"),
	HX_CSTRING("MediumSeaGreen"),
	HX_CSTRING("MediumSlateBlue"),
	HX_CSTRING("MediumSpringGreen"),
	HX_CSTRING("MediumTurquoise"),
	HX_CSTRING("MediumVioletRed"),
	HX_CSTRING("MidnightBlue"),
	HX_CSTRING("MintCream"),
	HX_CSTRING("MistyRose"),
	HX_CSTRING("Moccasin"),
	HX_CSTRING("NavajoWhite"),
	HX_CSTRING("Navy"),
	HX_CSTRING("OldLace"),
	HX_CSTRING("Olive"),
	HX_CSTRING("OliveDrab"),
	HX_CSTRING("Orange"),
	HX_CSTRING("OrangeRed"),
	HX_CSTRING("Orchid"),
	HX_CSTRING("PaleGoldenRod"),
	HX_CSTRING("PaleGreen"),
	HX_CSTRING("PaleTurquoise"),
	HX_CSTRING("PaleVioletRed"),
	HX_CSTRING("PapayaWhip"),
	HX_CSTRING("PeachPuff"),
	HX_CSTRING("Peru"),
	HX_CSTRING("Pink"),
	HX_CSTRING("Plum"),
	HX_CSTRING("PowderBlue"),
	HX_CSTRING("Purple"),
	HX_CSTRING("Red"),
	HX_CSTRING("RosyBrown"),
	HX_CSTRING("RoyalBlue"),
	HX_CSTRING("SaddleBrown"),
	HX_CSTRING("Salmon"),
	HX_CSTRING("SandyBrown"),
	HX_CSTRING("SeaGreen"),
	HX_CSTRING("SeaShell"),
	HX_CSTRING("Sienna"),
	HX_CSTRING("Silver"),
	HX_CSTRING("SkyBlue"),
	HX_CSTRING("SlateBlue"),
	HX_CSTRING("SlateGray"),
	HX_CSTRING("SlateGrey"),
	HX_CSTRING("Snow"),
	HX_CSTRING("SpringGreen"),
	HX_CSTRING("SteelBlue"),
	HX_CSTRING("Tan"),
	HX_CSTRING("Teal"),
	HX_CSTRING("Thistle"),
	HX_CSTRING("Tomato"),
	HX_CSTRING("Turquoise"),
	HX_CSTRING("Violet"),
	HX_CSTRING("Wheat"),
	HX_CSTRING("White"),
	HX_CSTRING("WhiteSmoke"),
	HX_CSTRING("Yellow"),
	HX_CSTRING("YellowGreen"),
	::String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(EColor_obj::AliceBlue,"AliceBlue");
	HX_MARK_MEMBER_NAME(EColor_obj::AntiqueWhite,"AntiqueWhite");
	HX_MARK_MEMBER_NAME(EColor_obj::Aqua,"Aqua");
	HX_MARK_MEMBER_NAME(EColor_obj::Aquamarine,"Aquamarine");
	HX_MARK_MEMBER_NAME(EColor_obj::Azure,"Azure");
	HX_MARK_MEMBER_NAME(EColor_obj::Beige,"Beige");
	HX_MARK_MEMBER_NAME(EColor_obj::Bisque,"Bisque");
	HX_MARK_MEMBER_NAME(EColor_obj::Black,"Black");
	HX_MARK_MEMBER_NAME(EColor_obj::BlanchedAlmond,"BlanchedAlmond");
	HX_MARK_MEMBER_NAME(EColor_obj::Blue,"Blue");
	HX_MARK_MEMBER_NAME(EColor_obj::BlueViolet,"BlueViolet");
	HX_MARK_MEMBER_NAME(EColor_obj::Brown,"Brown");
	HX_MARK_MEMBER_NAME(EColor_obj::BurlyWood,"BurlyWood");
	HX_MARK_MEMBER_NAME(EColor_obj::CadetBlue,"CadetBlue");
	HX_MARK_MEMBER_NAME(EColor_obj::Chartreuse,"Chartreuse");
	HX_MARK_MEMBER_NAME(EColor_obj::Chocolate,"Chocolate");
	HX_MARK_MEMBER_NAME(EColor_obj::ColPlaceholder,"ColPlaceholder");
	HX_MARK_MEMBER_NAME(EColor_obj::Coral,"Coral");
	HX_MARK_MEMBER_NAME(EColor_obj::CornflowerBlue,"CornflowerBlue");
	HX_MARK_MEMBER_NAME(EColor_obj::Cornsilk,"Cornsilk");
	HX_MARK_MEMBER_NAME(EColor_obj::Crimson,"Crimson");
	HX_MARK_MEMBER_NAME(EColor_obj::Cyan,"Cyan");
	HX_MARK_MEMBER_NAME(EColor_obj::DarkBlue,"DarkBlue");
	HX_MARK_MEMBER_NAME(EColor_obj::DarkCyan,"DarkCyan");
	HX_MARK_MEMBER_NAME(EColor_obj::DarkGoldenRod,"DarkGoldenRod");
	HX_MARK_MEMBER_NAME(EColor_obj::DarkGray,"DarkGray");
	HX_MARK_MEMBER_NAME(EColor_obj::DarkGreen,"DarkGreen");
	HX_MARK_MEMBER_NAME(EColor_obj::DarkGrey,"DarkGrey");
	HX_MARK_MEMBER_NAME(EColor_obj::DarkKhaki,"DarkKhaki");
	HX_MARK_MEMBER_NAME(EColor_obj::DarkMagenta,"DarkMagenta");
	HX_MARK_MEMBER_NAME(EColor_obj::DarkOliveGreen,"DarkOliveGreen");
	HX_MARK_MEMBER_NAME(EColor_obj::DarkOrchid,"DarkOrchid");
	HX_MARK_MEMBER_NAME(EColor_obj::DarkRed,"DarkRed");
	HX_MARK_MEMBER_NAME(EColor_obj::DarkSalmon,"DarkSalmon");
	HX_MARK_MEMBER_NAME(EColor_obj::DarkSeaGreen,"DarkSeaGreen");
	HX_MARK_MEMBER_NAME(EColor_obj::DarkSlateBlue,"DarkSlateBlue");
	HX_MARK_MEMBER_NAME(EColor_obj::DarkSlateGray,"DarkSlateGray");
	HX_MARK_MEMBER_NAME(EColor_obj::DarkSlateGrey,"DarkSlateGrey");
	HX_MARK_MEMBER_NAME(EColor_obj::DarkTurquoise,"DarkTurquoise");
	HX_MARK_MEMBER_NAME(EColor_obj::DarkViolet,"DarkViolet");
	HX_MARK_MEMBER_NAME(EColor_obj::Darkorange,"Darkorange");
	HX_MARK_MEMBER_NAME(EColor_obj::DeepPink,"DeepPink");
	HX_MARK_MEMBER_NAME(EColor_obj::DeepSkyBlue,"DeepSkyBlue");
	HX_MARK_MEMBER_NAME(EColor_obj::DimGray,"DimGray");
	HX_MARK_MEMBER_NAME(EColor_obj::DimGrey,"DimGrey");
	HX_MARK_MEMBER_NAME(EColor_obj::DodgerBlue,"DodgerBlue");
	HX_MARK_MEMBER_NAME(EColor_obj::FireBrick,"FireBrick");
	HX_MARK_MEMBER_NAME(EColor_obj::FloralWhite,"FloralWhite");
	HX_MARK_MEMBER_NAME(EColor_obj::ForestGreen,"ForestGreen");
	HX_MARK_MEMBER_NAME(EColor_obj::Fuchsia,"Fuchsia");
	HX_MARK_MEMBER_NAME(EColor_obj::Gainsboro,"Gainsboro");
	HX_MARK_MEMBER_NAME(EColor_obj::GhostWhite,"GhostWhite");
	HX_MARK_MEMBER_NAME(EColor_obj::Gold,"Gold");
	HX_MARK_MEMBER_NAME(EColor_obj::GoldenRod,"GoldenRod");
	HX_MARK_MEMBER_NAME(EColor_obj::Gray,"Gray");
	HX_MARK_MEMBER_NAME(EColor_obj::Green,"Green");
	HX_MARK_MEMBER_NAME(EColor_obj::GreenYellow,"GreenYellow");
	HX_MARK_MEMBER_NAME(EColor_obj::Grey,"Grey");
	HX_MARK_MEMBER_NAME(EColor_obj::HoneyDew,"HoneyDew");
	HX_MARK_MEMBER_NAME(EColor_obj::HotPink,"HotPink");
	HX_MARK_MEMBER_NAME(EColor_obj::IndianRed,"IndianRed");
	HX_MARK_MEMBER_NAME(EColor_obj::Indigo,"Indigo");
	HX_MARK_MEMBER_NAME(EColor_obj::Ivory,"Ivory");
	HX_MARK_MEMBER_NAME(EColor_obj::Khaki,"Khaki");
	HX_MARK_MEMBER_NAME(EColor_obj::Lavender,"Lavender");
	HX_MARK_MEMBER_NAME(EColor_obj::LavenderBlush,"LavenderBlush");
	HX_MARK_MEMBER_NAME(EColor_obj::LawnGreen,"LawnGreen");
	HX_MARK_MEMBER_NAME(EColor_obj::LemonChiffon,"LemonChiffon");
	HX_MARK_MEMBER_NAME(EColor_obj::LightBlue,"LightBlue");
	HX_MARK_MEMBER_NAME(EColor_obj::LightCoral,"LightCoral");
	HX_MARK_MEMBER_NAME(EColor_obj::LightCyan,"LightCyan");
	HX_MARK_MEMBER_NAME(EColor_obj::LightGoldenRodYellow,"LightGoldenRodYellow");
	HX_MARK_MEMBER_NAME(EColor_obj::LightGray,"LightGray");
	HX_MARK_MEMBER_NAME(EColor_obj::LightGreen,"LightGreen");
	HX_MARK_MEMBER_NAME(EColor_obj::LightGrey,"LightGrey");
	HX_MARK_MEMBER_NAME(EColor_obj::LightPink,"LightPink");
	HX_MARK_MEMBER_NAME(EColor_obj::LightSalmon,"LightSalmon");
	HX_MARK_MEMBER_NAME(EColor_obj::LightSeaGreen,"LightSeaGreen");
	HX_MARK_MEMBER_NAME(EColor_obj::LightSkyBlue,"LightSkyBlue");
	HX_MARK_MEMBER_NAME(EColor_obj::LightSlateGray,"LightSlateGray");
	HX_MARK_MEMBER_NAME(EColor_obj::LightSlateGrey,"LightSlateGrey");
	HX_MARK_MEMBER_NAME(EColor_obj::LightSteelBlue,"LightSteelBlue");
	HX_MARK_MEMBER_NAME(EColor_obj::LightYellow,"LightYellow");
	HX_MARK_MEMBER_NAME(EColor_obj::Lime,"Lime");
	HX_MARK_MEMBER_NAME(EColor_obj::LimeGreen,"LimeGreen");
	HX_MARK_MEMBER_NAME(EColor_obj::Linen,"Linen");
	HX_MARK_MEMBER_NAME(EColor_obj::Magenta,"Magenta");
	HX_MARK_MEMBER_NAME(EColor_obj::Maroon,"Maroon");
	HX_MARK_MEMBER_NAME(EColor_obj::MediumAquaMarine,"MediumAquaMarine");
	HX_MARK_MEMBER_NAME(EColor_obj::MediumBlue,"MediumBlue");
	HX_MARK_MEMBER_NAME(EColor_obj::MediumOrchid,"MediumOrchid");
	HX_MARK_MEMBER_NAME(EColor_obj::MediumPurple,"MediumPurple");
	HX_MARK_MEMBER_NAME(EColor_obj::MediumSeaGreen,"MediumSeaGreen");
	HX_MARK_MEMBER_NAME(EColor_obj::MediumSlateBlue,"MediumSlateBlue");
	HX_MARK_MEMBER_NAME(EColor_obj::MediumSpringGreen,"MediumSpringGreen");
	HX_MARK_MEMBER_NAME(EColor_obj::MediumTurquoise,"MediumTurquoise");
	HX_MARK_MEMBER_NAME(EColor_obj::MediumVioletRed,"MediumVioletRed");
	HX_MARK_MEMBER_NAME(EColor_obj::MidnightBlue,"MidnightBlue");
	HX_MARK_MEMBER_NAME(EColor_obj::MintCream,"MintCream");
	HX_MARK_MEMBER_NAME(EColor_obj::MistyRose,"MistyRose");
	HX_MARK_MEMBER_NAME(EColor_obj::Moccasin,"Moccasin");
	HX_MARK_MEMBER_NAME(EColor_obj::NavajoWhite,"NavajoWhite");
	HX_MARK_MEMBER_NAME(EColor_obj::Navy,"Navy");
	HX_MARK_MEMBER_NAME(EColor_obj::OldLace,"OldLace");
	HX_MARK_MEMBER_NAME(EColor_obj::Olive,"Olive");
	HX_MARK_MEMBER_NAME(EColor_obj::OliveDrab,"OliveDrab");
	HX_MARK_MEMBER_NAME(EColor_obj::Orange,"Orange");
	HX_MARK_MEMBER_NAME(EColor_obj::OrangeRed,"OrangeRed");
	HX_MARK_MEMBER_NAME(EColor_obj::Orchid,"Orchid");
	HX_MARK_MEMBER_NAME(EColor_obj::PaleGoldenRod,"PaleGoldenRod");
	HX_MARK_MEMBER_NAME(EColor_obj::PaleGreen,"PaleGreen");
	HX_MARK_MEMBER_NAME(EColor_obj::PaleTurquoise,"PaleTurquoise");
	HX_MARK_MEMBER_NAME(EColor_obj::PaleVioletRed,"PaleVioletRed");
	HX_MARK_MEMBER_NAME(EColor_obj::PapayaWhip,"PapayaWhip");
	HX_MARK_MEMBER_NAME(EColor_obj::PeachPuff,"PeachPuff");
	HX_MARK_MEMBER_NAME(EColor_obj::Peru,"Peru");
	HX_MARK_MEMBER_NAME(EColor_obj::Pink,"Pink");
	HX_MARK_MEMBER_NAME(EColor_obj::Plum,"Plum");
	HX_MARK_MEMBER_NAME(EColor_obj::PowderBlue,"PowderBlue");
	HX_MARK_MEMBER_NAME(EColor_obj::Purple,"Purple");
	HX_MARK_MEMBER_NAME(EColor_obj::Red,"Red");
	HX_MARK_MEMBER_NAME(EColor_obj::RosyBrown,"RosyBrown");
	HX_MARK_MEMBER_NAME(EColor_obj::RoyalBlue,"RoyalBlue");
	HX_MARK_MEMBER_NAME(EColor_obj::SaddleBrown,"SaddleBrown");
	HX_MARK_MEMBER_NAME(EColor_obj::Salmon,"Salmon");
	HX_MARK_MEMBER_NAME(EColor_obj::SandyBrown,"SandyBrown");
	HX_MARK_MEMBER_NAME(EColor_obj::SeaGreen,"SeaGreen");
	HX_MARK_MEMBER_NAME(EColor_obj::SeaShell,"SeaShell");
	HX_MARK_MEMBER_NAME(EColor_obj::Sienna,"Sienna");
	HX_MARK_MEMBER_NAME(EColor_obj::Silver,"Silver");
	HX_MARK_MEMBER_NAME(EColor_obj::SkyBlue,"SkyBlue");
	HX_MARK_MEMBER_NAME(EColor_obj::SlateBlue,"SlateBlue");
	HX_MARK_MEMBER_NAME(EColor_obj::SlateGray,"SlateGray");
	HX_MARK_MEMBER_NAME(EColor_obj::SlateGrey,"SlateGrey");
	HX_MARK_MEMBER_NAME(EColor_obj::Snow,"Snow");
	HX_MARK_MEMBER_NAME(EColor_obj::SpringGreen,"SpringGreen");
	HX_MARK_MEMBER_NAME(EColor_obj::SteelBlue,"SteelBlue");
	HX_MARK_MEMBER_NAME(EColor_obj::Tan,"Tan");
	HX_MARK_MEMBER_NAME(EColor_obj::Teal,"Teal");
	HX_MARK_MEMBER_NAME(EColor_obj::Thistle,"Thistle");
	HX_MARK_MEMBER_NAME(EColor_obj::Tomato,"Tomato");
	HX_MARK_MEMBER_NAME(EColor_obj::Turquoise,"Turquoise");
	HX_MARK_MEMBER_NAME(EColor_obj::Violet,"Violet");
	HX_MARK_MEMBER_NAME(EColor_obj::Wheat,"Wheat");
	HX_MARK_MEMBER_NAME(EColor_obj::White,"White");
	HX_MARK_MEMBER_NAME(EColor_obj::WhiteSmoke,"WhiteSmoke");
	HX_MARK_MEMBER_NAME(EColor_obj::Yellow,"Yellow");
	HX_MARK_MEMBER_NAME(EColor_obj::YellowGreen,"YellowGreen");
};

static ::String sMemberFields[] = { ::String(null()) };
Class EColor_obj::__mClass;

Dynamic __Create_EColor_obj() { return new EColor_obj; }

void EColor_obj::__register()
{

Static(__mClass) = hx::RegisterClass(HX_CSTRING("com.ludamix.triad.tools.EColor"), hx::TCanCast< EColor_obj >,sStaticFields,sMemberFields,
	&__Create_EColor_obj, &__Create,
	&super::__SGetClass(), &CreateEColor_obj, sMarkStatics);
}

void EColor_obj::__boot()
{
Static(AliceBlue) = hx::CreateEnum< EColor_obj >(HX_CSTRING("AliceBlue"),5);
Static(AntiqueWhite) = hx::CreateEnum< EColor_obj >(HX_CSTRING("AntiqueWhite"),6);
Static(Aqua) = hx::CreateEnum< EColor_obj >(HX_CSTRING("Aqua"),7);
Static(Aquamarine) = hx::CreateEnum< EColor_obj >(HX_CSTRING("Aquamarine"),8);
Static(Azure) = hx::CreateEnum< EColor_obj >(HX_CSTRING("Azure"),9);
Static(Beige) = hx::CreateEnum< EColor_obj >(HX_CSTRING("Beige"),10);
Static(Bisque) = hx::CreateEnum< EColor_obj >(HX_CSTRING("Bisque"),11);
Static(Black) = hx::CreateEnum< EColor_obj >(HX_CSTRING("Black"),12);
Static(BlanchedAlmond) = hx::CreateEnum< EColor_obj >(HX_CSTRING("BlanchedAlmond"),13);
Static(Blue) = hx::CreateEnum< EColor_obj >(HX_CSTRING("Blue"),14);
Static(BlueViolet) = hx::CreateEnum< EColor_obj >(HX_CSTRING("BlueViolet"),15);
Static(Brown) = hx::CreateEnum< EColor_obj >(HX_CSTRING("Brown"),16);
Static(BurlyWood) = hx::CreateEnum< EColor_obj >(HX_CSTRING("BurlyWood"),17);
Static(CadetBlue) = hx::CreateEnum< EColor_obj >(HX_CSTRING("CadetBlue"),18);
Static(Chartreuse) = hx::CreateEnum< EColor_obj >(HX_CSTRING("Chartreuse"),19);
Static(Chocolate) = hx::CreateEnum< EColor_obj >(HX_CSTRING("Chocolate"),20);
Static(ColPlaceholder) = hx::CreateEnum< EColor_obj >(HX_CSTRING("ColPlaceholder"),0);
Static(Coral) = hx::CreateEnum< EColor_obj >(HX_CSTRING("Coral"),21);
Static(CornflowerBlue) = hx::CreateEnum< EColor_obj >(HX_CSTRING("CornflowerBlue"),22);
Static(Cornsilk) = hx::CreateEnum< EColor_obj >(HX_CSTRING("Cornsilk"),23);
Static(Crimson) = hx::CreateEnum< EColor_obj >(HX_CSTRING("Crimson"),24);
Static(Cyan) = hx::CreateEnum< EColor_obj >(HX_CSTRING("Cyan"),25);
Static(DarkBlue) = hx::CreateEnum< EColor_obj >(HX_CSTRING("DarkBlue"),26);
Static(DarkCyan) = hx::CreateEnum< EColor_obj >(HX_CSTRING("DarkCyan"),27);
Static(DarkGoldenRod) = hx::CreateEnum< EColor_obj >(HX_CSTRING("DarkGoldenRod"),28);
Static(DarkGray) = hx::CreateEnum< EColor_obj >(HX_CSTRING("DarkGray"),29);
Static(DarkGreen) = hx::CreateEnum< EColor_obj >(HX_CSTRING("DarkGreen"),31);
Static(DarkGrey) = hx::CreateEnum< EColor_obj >(HX_CSTRING("DarkGrey"),30);
Static(DarkKhaki) = hx::CreateEnum< EColor_obj >(HX_CSTRING("DarkKhaki"),32);
Static(DarkMagenta) = hx::CreateEnum< EColor_obj >(HX_CSTRING("DarkMagenta"),33);
Static(DarkOliveGreen) = hx::CreateEnum< EColor_obj >(HX_CSTRING("DarkOliveGreen"),34);
Static(DarkOrchid) = hx::CreateEnum< EColor_obj >(HX_CSTRING("DarkOrchid"),36);
Static(DarkRed) = hx::CreateEnum< EColor_obj >(HX_CSTRING("DarkRed"),37);
Static(DarkSalmon) = hx::CreateEnum< EColor_obj >(HX_CSTRING("DarkSalmon"),38);
Static(DarkSeaGreen) = hx::CreateEnum< EColor_obj >(HX_CSTRING("DarkSeaGreen"),39);
Static(DarkSlateBlue) = hx::CreateEnum< EColor_obj >(HX_CSTRING("DarkSlateBlue"),40);
Static(DarkSlateGray) = hx::CreateEnum< EColor_obj >(HX_CSTRING("DarkSlateGray"),41);
Static(DarkSlateGrey) = hx::CreateEnum< EColor_obj >(HX_CSTRING("DarkSlateGrey"),42);
Static(DarkTurquoise) = hx::CreateEnum< EColor_obj >(HX_CSTRING("DarkTurquoise"),43);
Static(DarkViolet) = hx::CreateEnum< EColor_obj >(HX_CSTRING("DarkViolet"),44);
Static(Darkorange) = hx::CreateEnum< EColor_obj >(HX_CSTRING("Darkorange"),35);
Static(DeepPink) = hx::CreateEnum< EColor_obj >(HX_CSTRING("DeepPink"),45);
Static(DeepSkyBlue) = hx::CreateEnum< EColor_obj >(HX_CSTRING("DeepSkyBlue"),46);
Static(DimGray) = hx::CreateEnum< EColor_obj >(HX_CSTRING("DimGray"),47);
Static(DimGrey) = hx::CreateEnum< EColor_obj >(HX_CSTRING("DimGrey"),48);
Static(DodgerBlue) = hx::CreateEnum< EColor_obj >(HX_CSTRING("DodgerBlue"),49);
Static(FireBrick) = hx::CreateEnum< EColor_obj >(HX_CSTRING("FireBrick"),50);
Static(FloralWhite) = hx::CreateEnum< EColor_obj >(HX_CSTRING("FloralWhite"),51);
Static(ForestGreen) = hx::CreateEnum< EColor_obj >(HX_CSTRING("ForestGreen"),52);
Static(Fuchsia) = hx::CreateEnum< EColor_obj >(HX_CSTRING("Fuchsia"),53);
Static(Gainsboro) = hx::CreateEnum< EColor_obj >(HX_CSTRING("Gainsboro"),54);
Static(GhostWhite) = hx::CreateEnum< EColor_obj >(HX_CSTRING("GhostWhite"),55);
Static(Gold) = hx::CreateEnum< EColor_obj >(HX_CSTRING("Gold"),56);
Static(GoldenRod) = hx::CreateEnum< EColor_obj >(HX_CSTRING("GoldenRod"),57);
Static(Gray) = hx::CreateEnum< EColor_obj >(HX_CSTRING("Gray"),58);
Static(Green) = hx::CreateEnum< EColor_obj >(HX_CSTRING("Green"),60);
Static(GreenYellow) = hx::CreateEnum< EColor_obj >(HX_CSTRING("GreenYellow"),61);
Static(Grey) = hx::CreateEnum< EColor_obj >(HX_CSTRING("Grey"),59);
Static(HoneyDew) = hx::CreateEnum< EColor_obj >(HX_CSTRING("HoneyDew"),62);
Static(HotPink) = hx::CreateEnum< EColor_obj >(HX_CSTRING("HotPink"),63);
Static(IndianRed) = hx::CreateEnum< EColor_obj >(HX_CSTRING("IndianRed"),64);
Static(Indigo) = hx::CreateEnum< EColor_obj >(HX_CSTRING("Indigo"),65);
Static(Ivory) = hx::CreateEnum< EColor_obj >(HX_CSTRING("Ivory"),66);
Static(Khaki) = hx::CreateEnum< EColor_obj >(HX_CSTRING("Khaki"),67);
Static(Lavender) = hx::CreateEnum< EColor_obj >(HX_CSTRING("Lavender"),68);
Static(LavenderBlush) = hx::CreateEnum< EColor_obj >(HX_CSTRING("LavenderBlush"),69);
Static(LawnGreen) = hx::CreateEnum< EColor_obj >(HX_CSTRING("LawnGreen"),70);
Static(LemonChiffon) = hx::CreateEnum< EColor_obj >(HX_CSTRING("LemonChiffon"),71);
Static(LightBlue) = hx::CreateEnum< EColor_obj >(HX_CSTRING("LightBlue"),72);
Static(LightCoral) = hx::CreateEnum< EColor_obj >(HX_CSTRING("LightCoral"),73);
Static(LightCyan) = hx::CreateEnum< EColor_obj >(HX_CSTRING("LightCyan"),74);
Static(LightGoldenRodYellow) = hx::CreateEnum< EColor_obj >(HX_CSTRING("LightGoldenRodYellow"),75);
Static(LightGray) = hx::CreateEnum< EColor_obj >(HX_CSTRING("LightGray"),76);
Static(LightGreen) = hx::CreateEnum< EColor_obj >(HX_CSTRING("LightGreen"),78);
Static(LightGrey) = hx::CreateEnum< EColor_obj >(HX_CSTRING("LightGrey"),77);
Static(LightPink) = hx::CreateEnum< EColor_obj >(HX_CSTRING("LightPink"),79);
Static(LightSalmon) = hx::CreateEnum< EColor_obj >(HX_CSTRING("LightSalmon"),80);
Static(LightSeaGreen) = hx::CreateEnum< EColor_obj >(HX_CSTRING("LightSeaGreen"),81);
Static(LightSkyBlue) = hx::CreateEnum< EColor_obj >(HX_CSTRING("LightSkyBlue"),82);
Static(LightSlateGray) = hx::CreateEnum< EColor_obj >(HX_CSTRING("LightSlateGray"),83);
Static(LightSlateGrey) = hx::CreateEnum< EColor_obj >(HX_CSTRING("LightSlateGrey"),84);
Static(LightSteelBlue) = hx::CreateEnum< EColor_obj >(HX_CSTRING("LightSteelBlue"),85);
Static(LightYellow) = hx::CreateEnum< EColor_obj >(HX_CSTRING("LightYellow"),86);
Static(Lime) = hx::CreateEnum< EColor_obj >(HX_CSTRING("Lime"),87);
Static(LimeGreen) = hx::CreateEnum< EColor_obj >(HX_CSTRING("LimeGreen"),88);
Static(Linen) = hx::CreateEnum< EColor_obj >(HX_CSTRING("Linen"),89);
Static(Magenta) = hx::CreateEnum< EColor_obj >(HX_CSTRING("Magenta"),90);
Static(Maroon) = hx::CreateEnum< EColor_obj >(HX_CSTRING("Maroon"),91);
Static(MediumAquaMarine) = hx::CreateEnum< EColor_obj >(HX_CSTRING("MediumAquaMarine"),92);
Static(MediumBlue) = hx::CreateEnum< EColor_obj >(HX_CSTRING("MediumBlue"),93);
Static(MediumOrchid) = hx::CreateEnum< EColor_obj >(HX_CSTRING("MediumOrchid"),94);
Static(MediumPurple) = hx::CreateEnum< EColor_obj >(HX_CSTRING("MediumPurple"),95);
Static(MediumSeaGreen) = hx::CreateEnum< EColor_obj >(HX_CSTRING("MediumSeaGreen"),96);
Static(MediumSlateBlue) = hx::CreateEnum< EColor_obj >(HX_CSTRING("MediumSlateBlue"),97);
Static(MediumSpringGreen) = hx::CreateEnum< EColor_obj >(HX_CSTRING("MediumSpringGreen"),98);
Static(MediumTurquoise) = hx::CreateEnum< EColor_obj >(HX_CSTRING("MediumTurquoise"),99);
Static(MediumVioletRed) = hx::CreateEnum< EColor_obj >(HX_CSTRING("MediumVioletRed"),100);
Static(MidnightBlue) = hx::CreateEnum< EColor_obj >(HX_CSTRING("MidnightBlue"),101);
Static(MintCream) = hx::CreateEnum< EColor_obj >(HX_CSTRING("MintCream"),102);
Static(MistyRose) = hx::CreateEnum< EColor_obj >(HX_CSTRING("MistyRose"),103);
Static(Moccasin) = hx::CreateEnum< EColor_obj >(HX_CSTRING("Moccasin"),104);
Static(NavajoWhite) = hx::CreateEnum< EColor_obj >(HX_CSTRING("NavajoWhite"),105);
Static(Navy) = hx::CreateEnum< EColor_obj >(HX_CSTRING("Navy"),106);
Static(OldLace) = hx::CreateEnum< EColor_obj >(HX_CSTRING("OldLace"),107);
Static(Olive) = hx::CreateEnum< EColor_obj >(HX_CSTRING("Olive"),108);
Static(OliveDrab) = hx::CreateEnum< EColor_obj >(HX_CSTRING("OliveDrab"),109);
Static(Orange) = hx::CreateEnum< EColor_obj >(HX_CSTRING("Orange"),110);
Static(OrangeRed) = hx::CreateEnum< EColor_obj >(HX_CSTRING("OrangeRed"),111);
Static(Orchid) = hx::CreateEnum< EColor_obj >(HX_CSTRING("Orchid"),112);
Static(PaleGoldenRod) = hx::CreateEnum< EColor_obj >(HX_CSTRING("PaleGoldenRod"),113);
Static(PaleGreen) = hx::CreateEnum< EColor_obj >(HX_CSTRING("PaleGreen"),114);
Static(PaleTurquoise) = hx::CreateEnum< EColor_obj >(HX_CSTRING("PaleTurquoise"),115);
Static(PaleVioletRed) = hx::CreateEnum< EColor_obj >(HX_CSTRING("PaleVioletRed"),116);
Static(PapayaWhip) = hx::CreateEnum< EColor_obj >(HX_CSTRING("PapayaWhip"),117);
Static(PeachPuff) = hx::CreateEnum< EColor_obj >(HX_CSTRING("PeachPuff"),118);
Static(Peru) = hx::CreateEnum< EColor_obj >(HX_CSTRING("Peru"),119);
Static(Pink) = hx::CreateEnum< EColor_obj >(HX_CSTRING("Pink"),120);
Static(Plum) = hx::CreateEnum< EColor_obj >(HX_CSTRING("Plum"),121);
Static(PowderBlue) = hx::CreateEnum< EColor_obj >(HX_CSTRING("PowderBlue"),122);
Static(Purple) = hx::CreateEnum< EColor_obj >(HX_CSTRING("Purple"),123);
Static(Red) = hx::CreateEnum< EColor_obj >(HX_CSTRING("Red"),124);
Static(RosyBrown) = hx::CreateEnum< EColor_obj >(HX_CSTRING("RosyBrown"),125);
Static(RoyalBlue) = hx::CreateEnum< EColor_obj >(HX_CSTRING("RoyalBlue"),126);
Static(SaddleBrown) = hx::CreateEnum< EColor_obj >(HX_CSTRING("SaddleBrown"),127);
Static(Salmon) = hx::CreateEnum< EColor_obj >(HX_CSTRING("Salmon"),128);
Static(SandyBrown) = hx::CreateEnum< EColor_obj >(HX_CSTRING("SandyBrown"),129);
Static(SeaGreen) = hx::CreateEnum< EColor_obj >(HX_CSTRING("SeaGreen"),130);
Static(SeaShell) = hx::CreateEnum< EColor_obj >(HX_CSTRING("SeaShell"),131);
Static(Sienna) = hx::CreateEnum< EColor_obj >(HX_CSTRING("Sienna"),132);
Static(Silver) = hx::CreateEnum< EColor_obj >(HX_CSTRING("Silver"),133);
Static(SkyBlue) = hx::CreateEnum< EColor_obj >(HX_CSTRING("SkyBlue"),134);
Static(SlateBlue) = hx::CreateEnum< EColor_obj >(HX_CSTRING("SlateBlue"),135);
Static(SlateGray) = hx::CreateEnum< EColor_obj >(HX_CSTRING("SlateGray"),136);
Static(SlateGrey) = hx::CreateEnum< EColor_obj >(HX_CSTRING("SlateGrey"),137);
Static(Snow) = hx::CreateEnum< EColor_obj >(HX_CSTRING("Snow"),138);
Static(SpringGreen) = hx::CreateEnum< EColor_obj >(HX_CSTRING("SpringGreen"),139);
Static(SteelBlue) = hx::CreateEnum< EColor_obj >(HX_CSTRING("SteelBlue"),140);
Static(Tan) = hx::CreateEnum< EColor_obj >(HX_CSTRING("Tan"),141);
Static(Teal) = hx::CreateEnum< EColor_obj >(HX_CSTRING("Teal"),142);
Static(Thistle) = hx::CreateEnum< EColor_obj >(HX_CSTRING("Thistle"),143);
Static(Tomato) = hx::CreateEnum< EColor_obj >(HX_CSTRING("Tomato"),144);
Static(Turquoise) = hx::CreateEnum< EColor_obj >(HX_CSTRING("Turquoise"),145);
Static(Violet) = hx::CreateEnum< EColor_obj >(HX_CSTRING("Violet"),146);
Static(Wheat) = hx::CreateEnum< EColor_obj >(HX_CSTRING("Wheat"),147);
Static(White) = hx::CreateEnum< EColor_obj >(HX_CSTRING("White"),148);
Static(WhiteSmoke) = hx::CreateEnum< EColor_obj >(HX_CSTRING("WhiteSmoke"),149);
Static(Yellow) = hx::CreateEnum< EColor_obj >(HX_CSTRING("Yellow"),150);
Static(YellowGreen) = hx::CreateEnum< EColor_obj >(HX_CSTRING("YellowGreen"),151);
}


} // end namespace com
} // end namespace ludamix
} // end namespace triad
} // end namespace tools
