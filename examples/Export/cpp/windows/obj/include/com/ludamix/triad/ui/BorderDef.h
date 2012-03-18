#ifndef INCLUDED_com_ludamix_triad_ui_BorderDef
#define INCLUDED_com_ludamix_triad_ui_BorderDef

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS4(com,ludamix,triad,tools,EColor)
HX_DECLARE_CLASS4(com,ludamix,triad,ui,BorderDef)
HX_DECLARE_CLASS4(com,ludamix,triad,ui,HighlightingColorDef)
namespace com{
namespace ludamix{
namespace triad{
namespace ui{


class BorderDef_obj : public hx::EnumBase_obj
{
	typedef hx::EnumBase_obj super;
		typedef BorderDef_obj OBJ_;

	public:
		BorderDef_obj() {};
		HX_DO_ENUM_RTTI;
		static void __boot();
		static void __register();
		::String GetEnumName( ) const { return HX_CSTRING("com.ludamix.triad.ui.BorderDef"); }
		::String __ToString() const { return HX_CSTRING("BorderDef.") + tag; }

		static ::com::ludamix::triad::ui::BorderDef BDColor(::com::ludamix::triad::tools::EColor col);
		static Dynamic BDColor_dyn();
		static ::com::ludamix::triad::ui::BorderDef BDColorThickness(::com::ludamix::triad::tools::EColor col,double thickness);
		static Dynamic BDColorThickness_dyn();
		static ::com::ludamix::triad::ui::BorderDef BDColorThicknessHighlights(::com::ludamix::triad::ui::HighlightingColorDef col,double thickness);
		static Dynamic BDColorThicknessHighlights_dyn();
		static ::com::ludamix::triad::ui::BorderDef BDPlaceholder;
		static inline ::com::ludamix::triad::ui::BorderDef BDPlaceholder_dyn() { return BDPlaceholder; }
};

} // end namespace com
} // end namespace ludamix
} // end namespace triad
} // end namespace ui

#endif /* INCLUDED_com_ludamix_triad_ui_BorderDef */ 
