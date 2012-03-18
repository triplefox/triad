#ifndef INCLUDED_com_ludamix_triad_ui_RoundRectButton
#define INCLUDED_com_ludamix_triad_ui_RoundRectButton

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <nme/display/Sprite.h>
HX_DECLARE_CLASS4(com,ludamix,triad,ui,RoundRectButton)
HX_DECLARE_CLASS4(com,ludamix,triad,ui,RoundRectButtonDef)
HX_DECLARE_CLASS4(com,ludamix,triad,ui,StyledText)
HX_DECLARE_CLASS2(nme,display,DisplayObject)
HX_DECLARE_CLASS2(nme,display,DisplayObjectContainer)
HX_DECLARE_CLASS2(nme,display,IBitmapDrawable)
HX_DECLARE_CLASS2(nme,display,InteractiveObject)
HX_DECLARE_CLASS2(nme,display,Sprite)
HX_DECLARE_CLASS2(nme,events,Event)
HX_DECLARE_CLASS2(nme,events,EventDispatcher)
HX_DECLARE_CLASS2(nme,events,IEventDispatcher)
HX_DECLARE_CLASS2(nme,events,MouseEvent)
HX_DECLARE_CLASS2(nme,geom,Point)
HX_DECLARE_CLASS2(nme,text,TextField)
namespace com{
namespace ludamix{
namespace triad{
namespace ui{


class RoundRectButton_obj : public ::nme::display::Sprite_obj{
	public:
		typedef ::nme::display::Sprite_obj super;
		typedef RoundRectButton_obj OBJ_;
		RoundRectButton_obj();
		Void __construct(::nme::geom::Point center,double w,double h,::String text,::com::ludamix::triad::ui::RoundRectButtonDef def);

	public:
		static hx::ObjectPtr< RoundRectButton_obj > __new(::nme::geom::Point center,double w,double h,::String text,::com::ludamix::triad::ui::RoundRectButtonDef def);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		~RoundRectButton_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		::String __ToString() const { return HX_CSTRING("RoundRectButton"); }

		Dynamic def; /* REM */ 
		double bw; /* REM */ 
		double bh; /* REM */ 
		::com::ludamix::triad::ui::StyledText header; /* REM */ 
		virtual Void onOff( ::nme::events::MouseEvent ev);
		Dynamic onOff_dyn();

		virtual Void onOver( ::nme::events::MouseEvent ev);
		Dynamic onOver_dyn();

		virtual Void onDown( ::nme::events::MouseEvent ev);
		Dynamic onDown_dyn();

};

} // end namespace com
} // end namespace ludamix
} // end namespace triad
} // end namespace ui

#endif /* INCLUDED_com_ludamix_triad_ui_RoundRectButton */ 
