#ifndef INCLUDED_com_ludamix_triad_blitter_Blitter
#define INCLUDED_com_ludamix_triad_blitter_Blitter

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <nme/display/Bitmap.h>
HX_DECLARE_CLASS0(Hash)
HX_DECLARE_CLASS4(com,ludamix,triad,blitter,Blitter)
HX_DECLARE_CLASS2(nme,display,Bitmap)
HX_DECLARE_CLASS2(nme,display,BitmapData)
HX_DECLARE_CLASS2(nme,display,DisplayObject)
HX_DECLARE_CLASS2(nme,display,IBitmapDrawable)
HX_DECLARE_CLASS2(nme,events,EventDispatcher)
HX_DECLARE_CLASS2(nme,events,IEventDispatcher)
HX_DECLARE_CLASS2(nme,geom,Rectangle)
namespace com{
namespace ludamix{
namespace triad{
namespace blitter{


class Blitter_obj : public ::nme::display::Bitmap_obj{
	public:
		typedef ::nme::display::Bitmap_obj super;
		typedef Blitter_obj OBJ_;
		Blitter_obj();
		Void __construct(int width,int height,bool transparent,int color,Dynamic __o_zlevels);

	public:
		static hx::ObjectPtr< Blitter_obj > __new(int width,int height,bool transparent,int color,Dynamic __o_zlevels);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		~Blitter_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		::String __ToString() const { return HX_CSTRING("Blitter"); }

		::Hash spriteCache; /* REM */ 
		Dynamic spriteQueue; /* REM */ 
		Array< ::nme::geom::Rectangle > eraseQueue; /* REM */ 
		int fillColor; /* REM */ 
		virtual int getFillColor( );
		Dynamic getFillColor_dyn();

		virtual Void store( ::String name,::nme::display::BitmapData data);
		Dynamic store_dyn();

		virtual Void storeTiles( ::nme::display::BitmapData bd,int twidth,int theight,Dynamic naming);
		Dynamic storeTiles_dyn();

		virtual Void queueName( ::String spr,int x,int y,int z);
		Dynamic queueName_dyn();

		virtual Void queueBD( ::nme::display::BitmapData spr,int x,int y,int z);
		Dynamic queueBD_dyn();

		virtual Void update( );
		Dynamic update_dyn();

};

} // end namespace com
} // end namespace ludamix
} // end namespace triad
} // end namespace blitter

#endif /* INCLUDED_com_ludamix_triad_blitter_Blitter */ 
