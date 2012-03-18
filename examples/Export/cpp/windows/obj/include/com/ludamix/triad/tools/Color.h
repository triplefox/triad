#ifndef INCLUDED_com_ludamix_triad_tools_Color
#define INCLUDED_com_ludamix_triad_tools_Color

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS4(com,ludamix,triad,tools,Color)
HX_DECLARE_CLASS4(com,ludamix,triad,tools,EColor)
namespace com{
namespace ludamix{
namespace triad{
namespace tools{


class Color_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Color_obj OBJ_;
		Color_obj();
		Void __construct();

	public:
		static hx::ObjectPtr< Color_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		~Color_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		::String __ToString() const { return HX_CSTRING("Color"); }

		static int ARGB( int rgb,int alpha);
		static Dynamic ARGB_dyn();

		static int RGBofARGB( int argb);
		static Dynamic RGBofARGB_dyn();

		static Dynamic RGBPx( int value);
		static Dynamic RGBPx_dyn();

		static int RGBred( int value);
		static Dynamic RGBred_dyn();

		static int RGBgreen( int value);
		static Dynamic RGBgreen_dyn();

		static int RGBblue( int value);
		static Dynamic RGBblue_dyn();

		static int buildRGB( int r,int g,int b);
		static Dynamic buildRGB_dyn();

		static Void RGBtoHSV( Dynamic RGB,Dynamic HSV);
		static Dynamic RGBtoHSV_dyn();

		static Void HSVtoRGB( Dynamic HSV,Dynamic RGB);
		static Dynamic HSVtoRGB_dyn();

		static int getShifted( ::com::ludamix::triad::tools::EColor c,double hShift,double sShift,double vShift);
		static Dynamic getShifted_dyn();

		static int get( ::com::ludamix::triad::tools::EColor c);
		static Dynamic get_dyn();

};

} // end namespace com
} // end namespace ludamix
} // end namespace triad
} // end namespace tools

#endif /* INCLUDED_com_ludamix_triad_tools_Color */ 
