#ifndef INCLUDED_com_ludamix_triad_ui_RoundRectButtonDef
#define INCLUDED_com_ludamix_triad_ui_RoundRectButtonDef

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS4(com,ludamix,triad,ui,BorderDef)
HX_DECLARE_CLASS4(com,ludamix,triad,ui,HighlightingColorDef)
HX_DECLARE_CLASS4(com,ludamix,triad,ui,RoundRectButtonDef)
HX_DECLARE_CLASS4(com,ludamix,triad,ui,StyledTextDef)
namespace com{
namespace ludamix{
namespace triad{
namespace ui{


class RoundRectButtonDef_obj : public hx::EnumBase_obj
{
	typedef hx::EnumBase_obj super;
		typedef RoundRectButtonDef_obj OBJ_;

	public:
		RoundRectButtonDef_obj() {};
		HX_DO_ENUM_RTTI;
		static void __boot();
		static void __register();
		::String GetEnumName( ) const { return HX_CSTRING("com.ludamix.triad.ui.RoundRectButtonDef"); }
		::String __ToString() const { return HX_CSTRING("RoundRectButtonDef.") + tag; }

		static ::com::ludamix::triad::ui::RoundRectButtonDef RRBorder(::com::ludamix::triad::ui::BorderDef border,::com::ludamix::triad::ui::HighlightingColorDef color,::com::ludamix::triad::ui::StyledTextDef text,double roundnessX,double roundnessY);
		static Dynamic RRBorder_dyn();
		static ::com::ludamix::triad::ui::RoundRectButtonDef RRBorderSimple(::com::ludamix::triad::ui::BorderDef border,::com::ludamix::triad::ui::HighlightingColorDef color,::com::ludamix::triad::ui::StyledTextDef text,double roundness);
		static Dynamic RRBorderSimple_dyn();
		static ::com::ludamix::triad::ui::RoundRectButtonDef RRPlaceholder;
		static inline ::com::ludamix::triad::ui::RoundRectButtonDef RRPlaceholder_dyn() { return RRPlaceholder; }
};

} // end namespace com
} // end namespace ludamix
} // end namespace triad
} // end namespace ui

#endif /* INCLUDED_com_ludamix_triad_ui_RoundRectButtonDef */ 
