#ifndef INCLUDED_com_ludamix_triad_blitter_ASCIIMap
#define INCLUDED_com_ludamix_triad_blitter_ASCIIMap

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <nme/display/Bitmap.h>
HX_DECLARE_CLASS4(com,ludamix,triad,blitter,ASCIIMap)
HX_DECLARE_CLASS4(com,ludamix,triad,blitter,ASCIISheet)
HX_DECLARE_CLASS4(com,ludamix,triad,grid,AbstractGrid)
HX_DECLARE_CLASS4(com,ludamix,triad,grid,IntGrid)
HX_DECLARE_CLASS2(nme,display,Bitmap)
HX_DECLARE_CLASS2(nme,display,DisplayObject)
HX_DECLARE_CLASS2(nme,display,IBitmapDrawable)
HX_DECLARE_CLASS2(nme,events,EventDispatcher)
HX_DECLARE_CLASS2(nme,events,IEventDispatcher)
namespace com{
namespace ludamix{
namespace triad{
namespace blitter{


class ASCIIMap_obj : public ::nme::display::Bitmap_obj{
	public:
		typedef ::nme::display::Bitmap_obj super;
		typedef ASCIIMap_obj OBJ_;
		ASCIIMap_obj();
		Void __construct(::com::ludamix::triad::blitter::ASCIISheet sheet,int mapwidth,int mapheight);

	public:
		static hx::ObjectPtr< ASCIIMap_obj > __new(::com::ludamix::triad::blitter::ASCIISheet sheet,int mapwidth,int mapheight);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		~ASCIIMap_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		::String __ToString() const { return HX_CSTRING("ASCIIMap"); }

		::com::ludamix::triad::blitter::ASCIISheet sheet; /* REM */ 
		::com::ludamix::triad::grid::IntGrid _char; /* REM */ 
		::com::ludamix::triad::grid::IntGrid swap; /* REM */ 
		virtual Void update( );
		Dynamic update_dyn();

		static int encode( int bg_color,int fg_color,int _char);
		static Dynamic encode_dyn();

		static Dynamic decode( int packed);
		static Dynamic decode_dyn();

};

} // end namespace com
} // end namespace ludamix
} // end namespace triad
} // end namespace blitter

#endif /* INCLUDED_com_ludamix_triad_blitter_ASCIIMap */ 
