#ifndef INCLUDED_com_ludamix_triad_ui_StyledTextDef
#define INCLUDED_com_ludamix_triad_ui_StyledTextDef

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS4(com,ludamix,triad,tools,EColor)
HX_DECLARE_CLASS4(com,ludamix,triad,ui,StyledFontDef)
HX_DECLARE_CLASS4(com,ludamix,triad,ui,StyledTextDef)
HX_DECLARE_CLASS4(com,ludamix,triad,ui,TextAlign)
HX_DECLARE_CLASS2(nme,text,TextFieldAutoSize)
namespace com{
namespace ludamix{
namespace triad{
namespace ui{


class StyledTextDef_obj : public hx::EnumBase_obj
{
	typedef hx::EnumBase_obj super;
		typedef StyledTextDef_obj OBJ_;

	public:
		StyledTextDef_obj() {};
		HX_DO_ENUM_RTTI;
		static void __boot();
		static void __register();
		::String GetEnumName( ) const { return HX_CSTRING("com.ludamix.triad.ui.StyledTextDef"); }
		::String __ToString() const { return HX_CSTRING("StyledTextDef.") + tag; }

		static ::com::ludamix::triad::ui::StyledTextDef STAutosize(double size,::com::ludamix::triad::ui::StyledFontDef font,::com::ludamix::triad::tools::EColor color,bool wordwrap,::com::ludamix::triad::ui::TextAlign align,::nme::text::TextFieldAutoSize autosize);
		static Dynamic STAutosize_dyn();
		static ::com::ludamix::triad::ui::StyledTextDef STFixed(double size,::com::ludamix::triad::ui::StyledFontDef font,::com::ludamix::triad::tools::EColor color,bool wordwrap,::com::ludamix::triad::ui::TextAlign align);
		static Dynamic STFixed_dyn();
		static ::com::ludamix::triad::ui::StyledTextDef STPlaceholder;
		static inline ::com::ludamix::triad::ui::StyledTextDef STPlaceholder_dyn() { return STPlaceholder; }
		static ::com::ludamix::triad::ui::StyledTextDef STPlaceholderAutosize;
		static inline ::com::ludamix::triad::ui::StyledTextDef STPlaceholderAutosize_dyn() { return STPlaceholderAutosize; }
};

} // end namespace com
} // end namespace ludamix
} // end namespace triad
} // end namespace ui

#endif /* INCLUDED_com_ludamix_triad_ui_StyledTextDef */ 
