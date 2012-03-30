#ifndef INCLUDED_com_ludamix_triad_blitter_BlitterQueueInfos
#define INCLUDED_com_ludamix_triad_blitter_BlitterQueueInfos

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS4(com,ludamix,triad,blitter,BlitterQueueInfos)
HX_DECLARE_CLASS2(nme,display,BitmapData)
HX_DECLARE_CLASS2(nme,display,IBitmapDrawable)
HX_DECLARE_CLASS2(nme,geom,Rectangle)
namespace com{
namespace ludamix{
namespace triad{
namespace blitter{


class BlitterQueueInfos_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef BlitterQueueInfos_obj OBJ_;
		BlitterQueueInfos_obj();
		Void __construct(::nme::display::BitmapData bd,::nme::geom::Rectangle rect,int x,int y);

	public:
		static hx::ObjectPtr< BlitterQueueInfos_obj > __new(::nme::display::BitmapData bd,::nme::geom::Rectangle rect,int x,int y);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		~BlitterQueueInfos_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		::String __ToString() const { return HX_CSTRING("BlitterQueueInfos"); }

		::nme::display::BitmapData bd; /* REM */ 
		::nme::geom::Rectangle rect; /* REM */ 
		int x; /* REM */ 
		int y; /* REM */ 
};

} // end namespace com
} // end namespace ludamix
} // end namespace triad
} // end namespace blitter

#endif /* INCLUDED_com_ludamix_triad_blitter_BlitterQueueInfos */ 
