#ifndef INCLUDED_com_ludamix_triad_ui_StyledFontDef
#define INCLUDED_com_ludamix_triad_ui_StyledFontDef

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS4(com,ludamix,triad,ui,StyledFontDef)
namespace com{
namespace ludamix{
namespace triad{
namespace ui{


class StyledFontDef_obj : public hx::EnumBase_obj
{
	typedef hx::EnumBase_obj super;
		typedef StyledFontDef_obj OBJ_;

	public:
		StyledFontDef_obj() {};
		HX_DO_ENUM_RTTI;
		static void __boot();
		static void __register();
		::String GetEnumName( ) const { return HX_CSTRING("com.ludamix.triad.ui.StyledFontDef"); }
		::String __ToString() const { return HX_CSTRING("StyledFontDef.") + tag; }

		static ::com::ludamix::triad::ui::StyledFontDef SFEmbed(::String typeface);
		static Dynamic SFEmbed_dyn();
		static ::com::ludamix::triad::ui::StyledFontDef SFSystem(::String typeface);
		static Dynamic SFSystem_dyn();
};

} // end namespace com
} // end namespace ludamix
} // end namespace triad
} // end namespace ui

#endif /* INCLUDED_com_ludamix_triad_ui_StyledFontDef */ 
