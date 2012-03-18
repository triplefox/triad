#ifndef INCLUDED_com_ludamix_triad_ui_Rect9
#define INCLUDED_com_ludamix_triad_ui_Rect9

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS4(com,ludamix,triad,ui,Rect9)
HX_DECLARE_CLASS2(nme,display,BitmapData)
HX_DECLARE_CLASS2(nme,display,DisplayObject)
HX_DECLARE_CLASS2(nme,display,DisplayObjectContainer)
HX_DECLARE_CLASS2(nme,display,IBitmapDrawable)
HX_DECLARE_CLASS2(nme,display,InteractiveObject)
HX_DECLARE_CLASS2(nme,display,Sprite)
HX_DECLARE_CLASS2(nme,events,EventDispatcher)
HX_DECLARE_CLASS2(nme,events,IEventDispatcher)
namespace com{
namespace ludamix{
namespace triad{
namespace ui{


class Rect9_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Rect9_obj OBJ_;
		Rect9_obj();
		Void __construct(::nme::display::BitmapData base,int rectx,int recty,int rectw,int recth);

	public:
		static hx::ObjectPtr< Rect9_obj > __new(::nme::display::BitmapData base,int rectx,int recty,int rectw,int recth);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		~Rect9_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		::String __ToString() const { return HX_CSTRING("Rect9"); }

		Dynamic repeaterRect; /* REM */ 
		virtual int leftX( );
		Dynamic leftX_dyn();

		virtual int topY( );
		Dynamic topY_dyn();

		virtual int leftW( );
		Dynamic leftW_dyn();

		virtual int topH( );
		Dynamic topH_dyn();

		virtual int midX( );
		Dynamic midX_dyn();

		virtual int midY( );
		Dynamic midY_dyn();

		virtual int midW( );
		Dynamic midW_dyn();

		virtual int midH( );
		Dynamic midH_dyn();

		virtual int rightX( );
		Dynamic rightX_dyn();

		virtual int bottomY( );
		Dynamic bottomY_dyn();

		virtual int rightW( );
		Dynamic rightW_dyn();

		virtual int bottomH( );
		Dynamic bottomH_dyn();

		virtual Dynamic xyOf( int x,int y);
		Dynamic xyOf_dyn();

		virtual Dynamic modXYOf( int x,int y,int rectW,int rectH);
		Dynamic modXYOf_dyn();

		virtual Void draw( ::nme::display::Sprite sprite,int rectW,int rectH,bool scale);
		Dynamic draw_dyn();

};

} // end namespace com
} // end namespace ludamix
} // end namespace triad
} // end namespace ui

#endif /* INCLUDED_com_ludamix_triad_ui_Rect9 */ 
