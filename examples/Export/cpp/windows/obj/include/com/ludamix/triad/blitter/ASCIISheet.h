#ifndef INCLUDED_com_ludamix_triad_blitter_ASCIISheet
#define INCLUDED_com_ludamix_triad_blitter_ASCIISheet

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS4(com,ludamix,triad,blitter,ASCIISheet)
HX_DECLARE_CLASS4(com,ludamix,triad,blitter,BlitterTileInfos)
HX_DECLARE_CLASS2(nme,display,BitmapData)
HX_DECLARE_CLASS2(nme,display,IBitmapDrawable)
namespace com{
namespace ludamix{
namespace triad{
namespace blitter{


class ASCIISheet_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef ASCIISheet_obj OBJ_;
		ASCIISheet_obj();
		Void __construct(::nme::display::BitmapData sheet,int twidth,int theight,Array< int > palette);

	public:
		static hx::ObjectPtr< ASCIISheet_obj > __new(::nme::display::BitmapData sheet,int twidth,int theight,Array< int > palette);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		~ASCIISheet_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		::String __ToString() const { return HX_CSTRING("ASCIISheet"); }

		Array< Array< Array< ::com::ludamix::triad::blitter::BlitterTileInfos > > > chars; /* REM */ 
		Array< int > palette; /* REM */ 
		int twidth; /* REM */ 
		int theight; /* REM */ 
		virtual Void storeTiles( ::nme::display::BitmapData bd,int twidth,int theight,int fct);
		Dynamic storeTiles_dyn();

};

} // end namespace com
} // end namespace ludamix
} // end namespace triad
} // end namespace blitter

#endif /* INCLUDED_com_ludamix_triad_blitter_ASCIISheet */ 
