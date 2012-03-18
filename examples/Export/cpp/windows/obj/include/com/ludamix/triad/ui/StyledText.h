#ifndef INCLUDED_com_ludamix_triad_ui_StyledText
#define INCLUDED_com_ludamix_triad_ui_StyledText

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <nme/text/TextField.h>
HX_DECLARE_CLASS4(com,ludamix,triad,ui,StyledText)
HX_DECLARE_CLASS4(com,ludamix,triad,ui,StyledTextDef)
HX_DECLARE_CLASS2(nme,display,DisplayObject)
HX_DECLARE_CLASS2(nme,display,IBitmapDrawable)
HX_DECLARE_CLASS2(nme,display,InteractiveObject)
HX_DECLARE_CLASS2(nme,events,EventDispatcher)
HX_DECLARE_CLASS2(nme,events,IEventDispatcher)
HX_DECLARE_CLASS2(nme,geom,Point)
HX_DECLARE_CLASS2(nme,text,TextField)
namespace com{
namespace ludamix{
namespace triad{
namespace ui{


class StyledText_obj : public ::nme::text::TextField_obj{
	public:
		typedef ::nme::text::TextField_obj super;
		typedef StyledText_obj OBJ_;
		StyledText_obj();
		Void __construct(::nme::geom::Point center,double w,double h,::String text,::com::ludamix::triad::ui::StyledTextDef def,Dynamic selectable);

	public:
		static hx::ObjectPtr< StyledText_obj > __new(::nme::geom::Point center,double w,double h,::String text,::com::ludamix::triad::ui::StyledTextDef def,Dynamic selectable);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		~StyledText_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		::String __ToString() const { return HX_CSTRING("StyledText"); }

		::nme::geom::Point center; /* REM */ 
		double bw; /* REM */ 
		double bh; /* REM */ 
		virtual Void reposition( );
		Dynamic reposition_dyn();

		static ::com::ludamix::triad::ui::StyledText topleft( ::nme::geom::Point tl,double w,double h,::String text,::com::ludamix::triad::ui::StyledTextDef def);
		static Dynamic topleft_dyn();

		static ::com::ludamix::triad::ui::StyledText bottomleft( ::nme::geom::Point bl,double w,double h,::String text,::com::ludamix::triad::ui::StyledTextDef def);
		static Dynamic bottomleft_dyn();

		static ::com::ludamix::triad::ui::StyledText bottomright( ::nme::geom::Point br,double w,double h,::String text,::com::ludamix::triad::ui::StyledTextDef def);
		static Dynamic bottomright_dyn();

		static ::com::ludamix::triad::ui::StyledText topright( ::nme::geom::Point br,double w,double h,::String text,::com::ludamix::triad::ui::StyledTextDef def);
		static Dynamic topright_dyn();

};

} // end namespace com
} // end namespace ludamix
} // end namespace triad
} // end namespace ui

#endif /* INCLUDED_com_ludamix_triad_ui_StyledText */ 
