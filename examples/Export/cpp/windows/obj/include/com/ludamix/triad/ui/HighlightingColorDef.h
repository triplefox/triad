#ifndef INCLUDED_com_ludamix_triad_ui_HighlightingColorDef
#define INCLUDED_com_ludamix_triad_ui_HighlightingColorDef

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS4(com,ludamix,triad,tools,EColor)
HX_DECLARE_CLASS4(com,ludamix,triad,ui,HighlightingColorDef)
namespace com{
namespace ludamix{
namespace triad{
namespace ui{


class HighlightingColorDef_obj : public hx::EnumBase_obj
{
	typedef hx::EnumBase_obj super;
		typedef HighlightingColorDef_obj OBJ_;

	public:
		HighlightingColorDef_obj() {};
		HX_DO_ENUM_RTTI;
		static void __boot();
		static void __register();
		::String GetEnumName( ) const { return HX_CSTRING("com.ludamix.triad.ui.HighlightingColorDef"); }
		::String __ToString() const { return HX_CSTRING("HighlightingColorDef.") + tag; }

		static ::com::ludamix::triad::ui::HighlightingColorDef HCDualcolor(::com::ludamix::triad::tools::EColor off,::com::ludamix::triad::tools::EColor down);
		static Dynamic HCDualcolor_dyn();
		static ::com::ludamix::triad::ui::HighlightingColorDef HCHueSatShift(::com::ludamix::triad::tools::EColor primary,double strength);
		static Dynamic HCHueSatShift_dyn();
		static ::com::ludamix::triad::ui::HighlightingColorDef HCHueSatValShift(::com::ludamix::triad::tools::EColor primary,double strength);
		static Dynamic HCHueSatValShift_dyn();
		static ::com::ludamix::triad::ui::HighlightingColorDef HCHueShift(::com::ludamix::triad::tools::EColor primary,double strength);
		static Dynamic HCHueShift_dyn();
		static ::com::ludamix::triad::ui::HighlightingColorDef HCHueValShift(::com::ludamix::triad::tools::EColor primary,double strength);
		static Dynamic HCHueValShift_dyn();
		static ::com::ludamix::triad::ui::HighlightingColorDef HCMono(::com::ludamix::triad::tools::EColor c);
		static Dynamic HCMono_dyn();
		static ::com::ludamix::triad::ui::HighlightingColorDef HCPlaceholder;
		static inline ::com::ludamix::triad::ui::HighlightingColorDef HCPlaceholder_dyn() { return HCPlaceholder; }
		static ::com::ludamix::triad::ui::HighlightingColorDef HCSatShift(::com::ludamix::triad::tools::EColor primary,double strength);
		static Dynamic HCSatShift_dyn();
		static ::com::ludamix::triad::ui::HighlightingColorDef HCSatValShift(::com::ludamix::triad::tools::EColor primary,double strength);
		static Dynamic HCSatValShift_dyn();
		static ::com::ludamix::triad::ui::HighlightingColorDef HCTricolor(::com::ludamix::triad::tools::EColor off,::com::ludamix::triad::tools::EColor highlighted,::com::ludamix::triad::tools::EColor down);
		static Dynamic HCTricolor_dyn();
		static ::com::ludamix::triad::ui::HighlightingColorDef HCValShift(::com::ludamix::triad::tools::EColor primary,double strength);
		static Dynamic HCValShift_dyn();
};

} // end namespace com
} // end namespace ludamix
} // end namespace triad
} // end namespace ui

#endif /* INCLUDED_com_ludamix_triad_ui_HighlightingColorDef */ 
