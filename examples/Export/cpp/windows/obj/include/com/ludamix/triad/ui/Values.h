#ifndef INCLUDED_com_ludamix_triad_ui_Values
#define INCLUDED_com_ludamix_triad_ui_Values

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS4(com,ludamix,triad,ui,BorderDef)
HX_DECLARE_CLASS4(com,ludamix,triad,ui,HighlightingColorDef)
HX_DECLARE_CLASS4(com,ludamix,triad,ui,Values)
namespace com{
namespace ludamix{
namespace triad{
namespace ui{


class Values_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Values_obj OBJ_;
		Values_obj();
		Void __construct();

	public:
		static hx::ObjectPtr< Values_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		~Values_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		::String __ToString() const { return HX_CSTRING("Values"); }

		static Dynamic highlightingColor( ::com::ludamix::triad::ui::HighlightingColorDef hc);
		static Dynamic highlightingColor_dyn();

		static Dynamic border( ::com::ludamix::triad::ui::BorderDef b);
		static Dynamic border_dyn();

};

} // end namespace com
} // end namespace ludamix
} // end namespace triad
} // end namespace ui

#endif /* INCLUDED_com_ludamix_triad_ui_Values */ 
