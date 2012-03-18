#ifndef INCLUDED_com_ludamix_triad_tools_EColor
#define INCLUDED_com_ludamix_triad_tools_EColor

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS4(com,ludamix,triad,tools,EColor)
namespace com{
namespace ludamix{
namespace triad{
namespace tools{


class EColor_obj : public hx::EnumBase_obj
{
	typedef hx::EnumBase_obj super;
		typedef EColor_obj OBJ_;

	public:
		EColor_obj() {};
		HX_DO_ENUM_RTTI;
		static void __boot();
		static void __register();
		::String GetEnumName( ) const { return HX_CSTRING("com.ludamix.triad.tools.EColor"); }
		::String __ToString() const { return HX_CSTRING("EColor.") + tag; }

		static ::com::ludamix::triad::tools::EColor AliceBlue;
		static inline ::com::ludamix::triad::tools::EColor AliceBlue_dyn() { return AliceBlue; }
		static ::com::ludamix::triad::tools::EColor AntiqueWhite;
		static inline ::com::ludamix::triad::tools::EColor AntiqueWhite_dyn() { return AntiqueWhite; }
		static ::com::ludamix::triad::tools::EColor Aqua;
		static inline ::com::ludamix::triad::tools::EColor Aqua_dyn() { return Aqua; }
		static ::com::ludamix::triad::tools::EColor Aquamarine;
		static inline ::com::ludamix::triad::tools::EColor Aquamarine_dyn() { return Aquamarine; }
		static ::com::ludamix::triad::tools::EColor Azure;
		static inline ::com::ludamix::triad::tools::EColor Azure_dyn() { return Azure; }
		static ::com::ludamix::triad::tools::EColor Beige;
		static inline ::com::ludamix::triad::tools::EColor Beige_dyn() { return Beige; }
		static ::com::ludamix::triad::tools::EColor Bisque;
		static inline ::com::ludamix::triad::tools::EColor Bisque_dyn() { return Bisque; }
		static ::com::ludamix::triad::tools::EColor Black;
		static inline ::com::ludamix::triad::tools::EColor Black_dyn() { return Black; }
		static ::com::ludamix::triad::tools::EColor BlanchedAlmond;
		static inline ::com::ludamix::triad::tools::EColor BlanchedAlmond_dyn() { return BlanchedAlmond; }
		static ::com::ludamix::triad::tools::EColor Blue;
		static inline ::com::ludamix::triad::tools::EColor Blue_dyn() { return Blue; }
		static ::com::ludamix::triad::tools::EColor BlueViolet;
		static inline ::com::ludamix::triad::tools::EColor BlueViolet_dyn() { return BlueViolet; }
		static ::com::ludamix::triad::tools::EColor Brown;
		static inline ::com::ludamix::triad::tools::EColor Brown_dyn() { return Brown; }
		static ::com::ludamix::triad::tools::EColor BurlyWood;
		static inline ::com::ludamix::triad::tools::EColor BurlyWood_dyn() { return BurlyWood; }
		static ::com::ludamix::triad::tools::EColor CadetBlue;
		static inline ::com::ludamix::triad::tools::EColor CadetBlue_dyn() { return CadetBlue; }
		static ::com::ludamix::triad::tools::EColor Chartreuse;
		static inline ::com::ludamix::triad::tools::EColor Chartreuse_dyn() { return Chartreuse; }
		static ::com::ludamix::triad::tools::EColor Chocolate;
		static inline ::com::ludamix::triad::tools::EColor Chocolate_dyn() { return Chocolate; }
		static ::com::ludamix::triad::tools::EColor ColHSV(double h,double s,double v);
		static Dynamic ColHSV_dyn();
		static ::com::ludamix::triad::tools::EColor ColHex(int ui);
		static Dynamic ColHex_dyn();
		static ::com::ludamix::triad::tools::EColor ColPlaceholder;
		static inline ::com::ludamix::triad::tools::EColor ColPlaceholder_dyn() { return ColPlaceholder; }
		static ::com::ludamix::triad::tools::EColor ColRGB(int r,int g,int b);
		static Dynamic ColRGB_dyn();
		static ::com::ludamix::triad::tools::EColor ColString(::String v);
		static Dynamic ColString_dyn();
		static ::com::ludamix::triad::tools::EColor Coral;
		static inline ::com::ludamix::triad::tools::EColor Coral_dyn() { return Coral; }
		static ::com::ludamix::triad::tools::EColor CornflowerBlue;
		static inline ::com::ludamix::triad::tools::EColor CornflowerBlue_dyn() { return CornflowerBlue; }
		static ::com::ludamix::triad::tools::EColor Cornsilk;
		static inline ::com::ludamix::triad::tools::EColor Cornsilk_dyn() { return Cornsilk; }
		static ::com::ludamix::triad::tools::EColor Crimson;
		static inline ::com::ludamix::triad::tools::EColor Crimson_dyn() { return Crimson; }
		static ::com::ludamix::triad::tools::EColor Cyan;
		static inline ::com::ludamix::triad::tools::EColor Cyan_dyn() { return Cyan; }
		static ::com::ludamix::triad::tools::EColor DarkBlue;
		static inline ::com::ludamix::triad::tools::EColor DarkBlue_dyn() { return DarkBlue; }
		static ::com::ludamix::triad::tools::EColor DarkCyan;
		static inline ::com::ludamix::triad::tools::EColor DarkCyan_dyn() { return DarkCyan; }
		static ::com::ludamix::triad::tools::EColor DarkGoldenRod;
		static inline ::com::ludamix::triad::tools::EColor DarkGoldenRod_dyn() { return DarkGoldenRod; }
		static ::com::ludamix::triad::tools::EColor DarkGray;
		static inline ::com::ludamix::triad::tools::EColor DarkGray_dyn() { return DarkGray; }
		static ::com::ludamix::triad::tools::EColor DarkGreen;
		static inline ::com::ludamix::triad::tools::EColor DarkGreen_dyn() { return DarkGreen; }
		static ::com::ludamix::triad::tools::EColor DarkGrey;
		static inline ::com::ludamix::triad::tools::EColor DarkGrey_dyn() { return DarkGrey; }
		static ::com::ludamix::triad::tools::EColor DarkKhaki;
		static inline ::com::ludamix::triad::tools::EColor DarkKhaki_dyn() { return DarkKhaki; }
		static ::com::ludamix::triad::tools::EColor DarkMagenta;
		static inline ::com::ludamix::triad::tools::EColor DarkMagenta_dyn() { return DarkMagenta; }
		static ::com::ludamix::triad::tools::EColor DarkOliveGreen;
		static inline ::com::ludamix::triad::tools::EColor DarkOliveGreen_dyn() { return DarkOliveGreen; }
		static ::com::ludamix::triad::tools::EColor DarkOrchid;
		static inline ::com::ludamix::triad::tools::EColor DarkOrchid_dyn() { return DarkOrchid; }
		static ::com::ludamix::triad::tools::EColor DarkRed;
		static inline ::com::ludamix::triad::tools::EColor DarkRed_dyn() { return DarkRed; }
		static ::com::ludamix::triad::tools::EColor DarkSalmon;
		static inline ::com::ludamix::triad::tools::EColor DarkSalmon_dyn() { return DarkSalmon; }
		static ::com::ludamix::triad::tools::EColor DarkSeaGreen;
		static inline ::com::ludamix::triad::tools::EColor DarkSeaGreen_dyn() { return DarkSeaGreen; }
		static ::com::ludamix::triad::tools::EColor DarkSlateBlue;
		static inline ::com::ludamix::triad::tools::EColor DarkSlateBlue_dyn() { return DarkSlateBlue; }
		static ::com::ludamix::triad::tools::EColor DarkSlateGray;
		static inline ::com::ludamix::triad::tools::EColor DarkSlateGray_dyn() { return DarkSlateGray; }
		static ::com::ludamix::triad::tools::EColor DarkSlateGrey;
		static inline ::com::ludamix::triad::tools::EColor DarkSlateGrey_dyn() { return DarkSlateGrey; }
		static ::com::ludamix::triad::tools::EColor DarkTurquoise;
		static inline ::com::ludamix::triad::tools::EColor DarkTurquoise_dyn() { return DarkTurquoise; }
		static ::com::ludamix::triad::tools::EColor DarkViolet;
		static inline ::com::ludamix::triad::tools::EColor DarkViolet_dyn() { return DarkViolet; }
		static ::com::ludamix::triad::tools::EColor Darkorange;
		static inline ::com::ludamix::triad::tools::EColor Darkorange_dyn() { return Darkorange; }
		static ::com::ludamix::triad::tools::EColor DeepPink;
		static inline ::com::ludamix::triad::tools::EColor DeepPink_dyn() { return DeepPink; }
		static ::com::ludamix::triad::tools::EColor DeepSkyBlue;
		static inline ::com::ludamix::triad::tools::EColor DeepSkyBlue_dyn() { return DeepSkyBlue; }
		static ::com::ludamix::triad::tools::EColor DimGray;
		static inline ::com::ludamix::triad::tools::EColor DimGray_dyn() { return DimGray; }
		static ::com::ludamix::triad::tools::EColor DimGrey;
		static inline ::com::ludamix::triad::tools::EColor DimGrey_dyn() { return DimGrey; }
		static ::com::ludamix::triad::tools::EColor DodgerBlue;
		static inline ::com::ludamix::triad::tools::EColor DodgerBlue_dyn() { return DodgerBlue; }
		static ::com::ludamix::triad::tools::EColor FireBrick;
		static inline ::com::ludamix::triad::tools::EColor FireBrick_dyn() { return FireBrick; }
		static ::com::ludamix::triad::tools::EColor FloralWhite;
		static inline ::com::ludamix::triad::tools::EColor FloralWhite_dyn() { return FloralWhite; }
		static ::com::ludamix::triad::tools::EColor ForestGreen;
		static inline ::com::ludamix::triad::tools::EColor ForestGreen_dyn() { return ForestGreen; }
		static ::com::ludamix::triad::tools::EColor Fuchsia;
		static inline ::com::ludamix::triad::tools::EColor Fuchsia_dyn() { return Fuchsia; }
		static ::com::ludamix::triad::tools::EColor Gainsboro;
		static inline ::com::ludamix::triad::tools::EColor Gainsboro_dyn() { return Gainsboro; }
		static ::com::ludamix::triad::tools::EColor GhostWhite;
		static inline ::com::ludamix::triad::tools::EColor GhostWhite_dyn() { return GhostWhite; }
		static ::com::ludamix::triad::tools::EColor Gold;
		static inline ::com::ludamix::triad::tools::EColor Gold_dyn() { return Gold; }
		static ::com::ludamix::triad::tools::EColor GoldenRod;
		static inline ::com::ludamix::triad::tools::EColor GoldenRod_dyn() { return GoldenRod; }
		static ::com::ludamix::triad::tools::EColor Gray;
		static inline ::com::ludamix::triad::tools::EColor Gray_dyn() { return Gray; }
		static ::com::ludamix::triad::tools::EColor Green;
		static inline ::com::ludamix::triad::tools::EColor Green_dyn() { return Green; }
		static ::com::ludamix::triad::tools::EColor GreenYellow;
		static inline ::com::ludamix::triad::tools::EColor GreenYellow_dyn() { return GreenYellow; }
		static ::com::ludamix::triad::tools::EColor Grey;
		static inline ::com::ludamix::triad::tools::EColor Grey_dyn() { return Grey; }
		static ::com::ludamix::triad::tools::EColor HoneyDew;
		static inline ::com::ludamix::triad::tools::EColor HoneyDew_dyn() { return HoneyDew; }
		static ::com::ludamix::triad::tools::EColor HotPink;
		static inline ::com::ludamix::triad::tools::EColor HotPink_dyn() { return HotPink; }
		static ::com::ludamix::triad::tools::EColor IndianRed;
		static inline ::com::ludamix::triad::tools::EColor IndianRed_dyn() { return IndianRed; }
		static ::com::ludamix::triad::tools::EColor Indigo;
		static inline ::com::ludamix::triad::tools::EColor Indigo_dyn() { return Indigo; }
		static ::com::ludamix::triad::tools::EColor Ivory;
		static inline ::com::ludamix::triad::tools::EColor Ivory_dyn() { return Ivory; }
		static ::com::ludamix::triad::tools::EColor Khaki;
		static inline ::com::ludamix::triad::tools::EColor Khaki_dyn() { return Khaki; }
		static ::com::ludamix::triad::tools::EColor Lavender;
		static inline ::com::ludamix::triad::tools::EColor Lavender_dyn() { return Lavender; }
		static ::com::ludamix::triad::tools::EColor LavenderBlush;
		static inline ::com::ludamix::triad::tools::EColor LavenderBlush_dyn() { return LavenderBlush; }
		static ::com::ludamix::triad::tools::EColor LawnGreen;
		static inline ::com::ludamix::triad::tools::EColor LawnGreen_dyn() { return LawnGreen; }
		static ::com::ludamix::triad::tools::EColor LemonChiffon;
		static inline ::com::ludamix::triad::tools::EColor LemonChiffon_dyn() { return LemonChiffon; }
		static ::com::ludamix::triad::tools::EColor LightBlue;
		static inline ::com::ludamix::triad::tools::EColor LightBlue_dyn() { return LightBlue; }
		static ::com::ludamix::triad::tools::EColor LightCoral;
		static inline ::com::ludamix::triad::tools::EColor LightCoral_dyn() { return LightCoral; }
		static ::com::ludamix::triad::tools::EColor LightCyan;
		static inline ::com::ludamix::triad::tools::EColor LightCyan_dyn() { return LightCyan; }
		static ::com::ludamix::triad::tools::EColor LightGoldenRodYellow;
		static inline ::com::ludamix::triad::tools::EColor LightGoldenRodYellow_dyn() { return LightGoldenRodYellow; }
		static ::com::ludamix::triad::tools::EColor LightGray;
		static inline ::com::ludamix::triad::tools::EColor LightGray_dyn() { return LightGray; }
		static ::com::ludamix::triad::tools::EColor LightGreen;
		static inline ::com::ludamix::triad::tools::EColor LightGreen_dyn() { return LightGreen; }
		static ::com::ludamix::triad::tools::EColor LightGrey;
		static inline ::com::ludamix::triad::tools::EColor LightGrey_dyn() { return LightGrey; }
		static ::com::ludamix::triad::tools::EColor LightPink;
		static inline ::com::ludamix::triad::tools::EColor LightPink_dyn() { return LightPink; }
		static ::com::ludamix::triad::tools::EColor LightSalmon;
		static inline ::com::ludamix::triad::tools::EColor LightSalmon_dyn() { return LightSalmon; }
		static ::com::ludamix::triad::tools::EColor LightSeaGreen;
		static inline ::com::ludamix::triad::tools::EColor LightSeaGreen_dyn() { return LightSeaGreen; }
		static ::com::ludamix::triad::tools::EColor LightSkyBlue;
		static inline ::com::ludamix::triad::tools::EColor LightSkyBlue_dyn() { return LightSkyBlue; }
		static ::com::ludamix::triad::tools::EColor LightSlateGray;
		static inline ::com::ludamix::triad::tools::EColor LightSlateGray_dyn() { return LightSlateGray; }
		static ::com::ludamix::triad::tools::EColor LightSlateGrey;
		static inline ::com::ludamix::triad::tools::EColor LightSlateGrey_dyn() { return LightSlateGrey; }
		static ::com::ludamix::triad::tools::EColor LightSteelBlue;
		static inline ::com::ludamix::triad::tools::EColor LightSteelBlue_dyn() { return LightSteelBlue; }
		static ::com::ludamix::triad::tools::EColor LightYellow;
		static inline ::com::ludamix::triad::tools::EColor LightYellow_dyn() { return LightYellow; }
		static ::com::ludamix::triad::tools::EColor Lime;
		static inline ::com::ludamix::triad::tools::EColor Lime_dyn() { return Lime; }
		static ::com::ludamix::triad::tools::EColor LimeGreen;
		static inline ::com::ludamix::triad::tools::EColor LimeGreen_dyn() { return LimeGreen; }
		static ::com::ludamix::triad::tools::EColor Linen;
		static inline ::com::ludamix::triad::tools::EColor Linen_dyn() { return Linen; }
		static ::com::ludamix::triad::tools::EColor Magenta;
		static inline ::com::ludamix::triad::tools::EColor Magenta_dyn() { return Magenta; }
		static ::com::ludamix::triad::tools::EColor Maroon;
		static inline ::com::ludamix::triad::tools::EColor Maroon_dyn() { return Maroon; }
		static ::com::ludamix::triad::tools::EColor MediumAquaMarine;
		static inline ::com::ludamix::triad::tools::EColor MediumAquaMarine_dyn() { return MediumAquaMarine; }
		static ::com::ludamix::triad::tools::EColor MediumBlue;
		static inline ::com::ludamix::triad::tools::EColor MediumBlue_dyn() { return MediumBlue; }
		static ::com::ludamix::triad::tools::EColor MediumOrchid;
		static inline ::com::ludamix::triad::tools::EColor MediumOrchid_dyn() { return MediumOrchid; }
		static ::com::ludamix::triad::tools::EColor MediumPurple;
		static inline ::com::ludamix::triad::tools::EColor MediumPurple_dyn() { return MediumPurple; }
		static ::com::ludamix::triad::tools::EColor MediumSeaGreen;
		static inline ::com::ludamix::triad::tools::EColor MediumSeaGreen_dyn() { return MediumSeaGreen; }
		static ::com::ludamix::triad::tools::EColor MediumSlateBlue;
		static inline ::com::ludamix::triad::tools::EColor MediumSlateBlue_dyn() { return MediumSlateBlue; }
		static ::com::ludamix::triad::tools::EColor MediumSpringGreen;
		static inline ::com::ludamix::triad::tools::EColor MediumSpringGreen_dyn() { return MediumSpringGreen; }
		static ::com::ludamix::triad::tools::EColor MediumTurquoise;
		static inline ::com::ludamix::triad::tools::EColor MediumTurquoise_dyn() { return MediumTurquoise; }
		static ::com::ludamix::triad::tools::EColor MediumVioletRed;
		static inline ::com::ludamix::triad::tools::EColor MediumVioletRed_dyn() { return MediumVioletRed; }
		static ::com::ludamix::triad::tools::EColor MidnightBlue;
		static inline ::com::ludamix::triad::tools::EColor MidnightBlue_dyn() { return MidnightBlue; }
		static ::com::ludamix::triad::tools::EColor MintCream;
		static inline ::com::ludamix::triad::tools::EColor MintCream_dyn() { return MintCream; }
		static ::com::ludamix::triad::tools::EColor MistyRose;
		static inline ::com::ludamix::triad::tools::EColor MistyRose_dyn() { return MistyRose; }
		static ::com::ludamix::triad::tools::EColor Moccasin;
		static inline ::com::ludamix::triad::tools::EColor Moccasin_dyn() { return Moccasin; }
		static ::com::ludamix::triad::tools::EColor NavajoWhite;
		static inline ::com::ludamix::triad::tools::EColor NavajoWhite_dyn() { return NavajoWhite; }
		static ::com::ludamix::triad::tools::EColor Navy;
		static inline ::com::ludamix::triad::tools::EColor Navy_dyn() { return Navy; }
		static ::com::ludamix::triad::tools::EColor OldLace;
		static inline ::com::ludamix::triad::tools::EColor OldLace_dyn() { return OldLace; }
		static ::com::ludamix::triad::tools::EColor Olive;
		static inline ::com::ludamix::triad::tools::EColor Olive_dyn() { return Olive; }
		static ::com::ludamix::triad::tools::EColor OliveDrab;
		static inline ::com::ludamix::triad::tools::EColor OliveDrab_dyn() { return OliveDrab; }
		static ::com::ludamix::triad::tools::EColor Orange;
		static inline ::com::ludamix::triad::tools::EColor Orange_dyn() { return Orange; }
		static ::com::ludamix::triad::tools::EColor OrangeRed;
		static inline ::com::ludamix::triad::tools::EColor OrangeRed_dyn() { return OrangeRed; }
		static ::com::ludamix::triad::tools::EColor Orchid;
		static inline ::com::ludamix::triad::tools::EColor Orchid_dyn() { return Orchid; }
		static ::com::ludamix::triad::tools::EColor PaleGoldenRod;
		static inline ::com::ludamix::triad::tools::EColor PaleGoldenRod_dyn() { return PaleGoldenRod; }
		static ::com::ludamix::triad::tools::EColor PaleGreen;
		static inline ::com::ludamix::triad::tools::EColor PaleGreen_dyn() { return PaleGreen; }
		static ::com::ludamix::triad::tools::EColor PaleTurquoise;
		static inline ::com::ludamix::triad::tools::EColor PaleTurquoise_dyn() { return PaleTurquoise; }
		static ::com::ludamix::triad::tools::EColor PaleVioletRed;
		static inline ::com::ludamix::triad::tools::EColor PaleVioletRed_dyn() { return PaleVioletRed; }
		static ::com::ludamix::triad::tools::EColor PapayaWhip;
		static inline ::com::ludamix::triad::tools::EColor PapayaWhip_dyn() { return PapayaWhip; }
		static ::com::ludamix::triad::tools::EColor PeachPuff;
		static inline ::com::ludamix::triad::tools::EColor PeachPuff_dyn() { return PeachPuff; }
		static ::com::ludamix::triad::tools::EColor Peru;
		static inline ::com::ludamix::triad::tools::EColor Peru_dyn() { return Peru; }
		static ::com::ludamix::triad::tools::EColor Pink;
		static inline ::com::ludamix::triad::tools::EColor Pink_dyn() { return Pink; }
		static ::com::ludamix::triad::tools::EColor Plum;
		static inline ::com::ludamix::triad::tools::EColor Plum_dyn() { return Plum; }
		static ::com::ludamix::triad::tools::EColor PowderBlue;
		static inline ::com::ludamix::triad::tools::EColor PowderBlue_dyn() { return PowderBlue; }
		static ::com::ludamix::triad::tools::EColor Purple;
		static inline ::com::ludamix::triad::tools::EColor Purple_dyn() { return Purple; }
		static ::com::ludamix::triad::tools::EColor Red;
		static inline ::com::ludamix::triad::tools::EColor Red_dyn() { return Red; }
		static ::com::ludamix::triad::tools::EColor RosyBrown;
		static inline ::com::ludamix::triad::tools::EColor RosyBrown_dyn() { return RosyBrown; }
		static ::com::ludamix::triad::tools::EColor RoyalBlue;
		static inline ::com::ludamix::triad::tools::EColor RoyalBlue_dyn() { return RoyalBlue; }
		static ::com::ludamix::triad::tools::EColor SaddleBrown;
		static inline ::com::ludamix::triad::tools::EColor SaddleBrown_dyn() { return SaddleBrown; }
		static ::com::ludamix::triad::tools::EColor Salmon;
		static inline ::com::ludamix::triad::tools::EColor Salmon_dyn() { return Salmon; }
		static ::com::ludamix::triad::tools::EColor SandyBrown;
		static inline ::com::ludamix::triad::tools::EColor SandyBrown_dyn() { return SandyBrown; }
		static ::com::ludamix::triad::tools::EColor SeaGreen;
		static inline ::com::ludamix::triad::tools::EColor SeaGreen_dyn() { return SeaGreen; }
		static ::com::ludamix::triad::tools::EColor SeaShell;
		static inline ::com::ludamix::triad::tools::EColor SeaShell_dyn() { return SeaShell; }
		static ::com::ludamix::triad::tools::EColor Sienna;
		static inline ::com::ludamix::triad::tools::EColor Sienna_dyn() { return Sienna; }
		static ::com::ludamix::triad::tools::EColor Silver;
		static inline ::com::ludamix::triad::tools::EColor Silver_dyn() { return Silver; }
		static ::com::ludamix::triad::tools::EColor SkyBlue;
		static inline ::com::ludamix::triad::tools::EColor SkyBlue_dyn() { return SkyBlue; }
		static ::com::ludamix::triad::tools::EColor SlateBlue;
		static inline ::com::ludamix::triad::tools::EColor SlateBlue_dyn() { return SlateBlue; }
		static ::com::ludamix::triad::tools::EColor SlateGray;
		static inline ::com::ludamix::triad::tools::EColor SlateGray_dyn() { return SlateGray; }
		static ::com::ludamix::triad::tools::EColor SlateGrey;
		static inline ::com::ludamix::triad::tools::EColor SlateGrey_dyn() { return SlateGrey; }
		static ::com::ludamix::triad::tools::EColor Snow;
		static inline ::com::ludamix::triad::tools::EColor Snow_dyn() { return Snow; }
		static ::com::ludamix::triad::tools::EColor SpringGreen;
		static inline ::com::ludamix::triad::tools::EColor SpringGreen_dyn() { return SpringGreen; }
		static ::com::ludamix::triad::tools::EColor SteelBlue;
		static inline ::com::ludamix::triad::tools::EColor SteelBlue_dyn() { return SteelBlue; }
		static ::com::ludamix::triad::tools::EColor Tan;
		static inline ::com::ludamix::triad::tools::EColor Tan_dyn() { return Tan; }
		static ::com::ludamix::triad::tools::EColor Teal;
		static inline ::com::ludamix::triad::tools::EColor Teal_dyn() { return Teal; }
		static ::com::ludamix::triad::tools::EColor Thistle;
		static inline ::com::ludamix::triad::tools::EColor Thistle_dyn() { return Thistle; }
		static ::com::ludamix::triad::tools::EColor Tomato;
		static inline ::com::ludamix::triad::tools::EColor Tomato_dyn() { return Tomato; }
		static ::com::ludamix::triad::tools::EColor Turquoise;
		static inline ::com::ludamix::triad::tools::EColor Turquoise_dyn() { return Turquoise; }
		static ::com::ludamix::triad::tools::EColor Violet;
		static inline ::com::ludamix::triad::tools::EColor Violet_dyn() { return Violet; }
		static ::com::ludamix::triad::tools::EColor Wheat;
		static inline ::com::ludamix::triad::tools::EColor Wheat_dyn() { return Wheat; }
		static ::com::ludamix::triad::tools::EColor White;
		static inline ::com::ludamix::triad::tools::EColor White_dyn() { return White; }
		static ::com::ludamix::triad::tools::EColor WhiteSmoke;
		static inline ::com::ludamix::triad::tools::EColor WhiteSmoke_dyn() { return WhiteSmoke; }
		static ::com::ludamix::triad::tools::EColor Yellow;
		static inline ::com::ludamix::triad::tools::EColor Yellow_dyn() { return Yellow; }
		static ::com::ludamix::triad::tools::EColor YellowGreen;
		static inline ::com::ludamix::triad::tools::EColor YellowGreen_dyn() { return YellowGreen; }
};

} // end namespace com
} // end namespace ludamix
} // end namespace triad
} // end namespace tools

#endif /* INCLUDED_com_ludamix_triad_tools_EColor */ 
