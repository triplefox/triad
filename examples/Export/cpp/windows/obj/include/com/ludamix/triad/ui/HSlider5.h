#ifndef INCLUDED_com_ludamix_triad_ui_HSlider5
#define INCLUDED_com_ludamix_triad_ui_HSlider5

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <nme/display/Sprite.h>
HX_DECLARE_CLASS4(com,ludamix,triad,ui,HSlider5)
HX_DECLARE_CLASS4(com,ludamix,triad,ui,SliderDrawMode)
HX_DECLARE_CLASS2(nme,display,BitmapData)
HX_DECLARE_CLASS2(nme,display,DisplayObject)
HX_DECLARE_CLASS2(nme,display,DisplayObjectContainer)
HX_DECLARE_CLASS2(nme,display,IBitmapDrawable)
HX_DECLARE_CLASS2(nme,display,InteractiveObject)
HX_DECLARE_CLASS2(nme,display,Sprite)
HX_DECLARE_CLASS2(nme,events,Event)
HX_DECLARE_CLASS2(nme,events,EventDispatcher)
HX_DECLARE_CLASS2(nme,events,IEventDispatcher)
HX_DECLARE_CLASS2(nme,events,MouseEvent)
namespace com{
namespace ludamix{
namespace triad{
namespace ui{


class HSlider5_obj : public ::nme::display::Sprite_obj{
	public:
		typedef ::nme::display::Sprite_obj super;
		typedef HSlider5_obj OBJ_;
		HSlider5_obj();
		Void __construct(::nme::display::BitmapData base,int tileW,int tileH,int sliderW,double highlighted,::com::ludamix::triad::ui::SliderDrawMode drawmode,Dynamic onSet);

	public:
		static hx::ObjectPtr< HSlider5_obj > __new(::nme::display::BitmapData base,int tileW,int tileH,int sliderW,double highlighted,::com::ludamix::triad::ui::SliderDrawMode drawmode,Dynamic onSet);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		~HSlider5_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		::String __ToString() const { return HX_CSTRING("HSlider5"); }

		Array< ::nme::display::BitmapData > slices; /* REM */ 
		int tileW; /* REM */ 
		int tileH; /* REM */ 
		int sliderW; /* REM */ 
		Dynamic onSet; /* REM */ 
	Dynamic &onSet_dyn() { return onSet;}
		::com::ludamix::triad::ui::SliderDrawMode drawMode; /* REM */ 
		virtual Void draw( double highlighted);
		Dynamic draw_dyn();

		virtual Void onFrame( ::nme::events::Event e);
		Dynamic onFrame_dyn();

		virtual Void onDown( ::nme::events::MouseEvent e);
		Dynamic onDown_dyn();

		virtual Void onUp( ::nme::events::MouseEvent e);
		Dynamic onUp_dyn();

		static int CLCAP; /* REM */ 
		static int CBAR; /* REM */ 
		static int CRCAP; /* REM */ 
		static int HLCAP; /* REM */ 
		static int HBAR; /* REM */ 
		static int HRCAP; /* REM */ 
		static int HANDLE; /* REM */ 
};

} // end namespace com
} // end namespace ludamix
} // end namespace triad
} // end namespace ui

#endif /* INCLUDED_com_ludamix_triad_ui_HSlider5 */ 
