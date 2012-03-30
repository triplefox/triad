#ifndef INCLUDED_com_ludamix_triad_blitter_BlitterTileInfos
#define INCLUDED_com_ludamix_triad_blitter_BlitterTileInfos

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS4(com,ludamix,triad,blitter,BlitterTileInfos)
HX_DECLARE_CLASS2(nme,display,BitmapData)
HX_DECLARE_CLASS2(nme,display,IBitmapDrawable)
HX_DECLARE_CLASS2(nme,geom,Rectangle)
namespace com{
namespace ludamix{
namespace triad{
namespace blitter{


class BlitterTileInfos_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef BlitterTileInfos_obj OBJ_;
		BlitterTileInfos_obj();
		Void __construct(::nme::display::BitmapData bd,::nme::geom::Rectangle rect);

	public:
		static hx::ObjectPtr< BlitterTileInfos_obj > __new(::nme::display::BitmapData bd,::nme::geom::Rectangle rect);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		~BlitterTileInfos_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		::String __ToString() const { return HX_CSTRING("BlitterTileInfos"); }

		::nme::display::BitmapData bd; /* REM */ 
		::nme::geom::Rectangle rect; /* REM */ 
};

} // end namespace com
} // end namespace ludamix
} // end namespace triad
} // end namespace blitter

#endif /* INCLUDED_com_ludamix_triad_blitter_BlitterTileInfos */ 
