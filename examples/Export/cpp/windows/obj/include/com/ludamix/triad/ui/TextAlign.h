#ifndef INCLUDED_com_ludamix_triad_ui_TextAlign
#define INCLUDED_com_ludamix_triad_ui_TextAlign

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS4(com,ludamix,triad,ui,TextAlign)
namespace com{
namespace ludamix{
namespace triad{
namespace ui{


class TextAlign_obj : public hx::EnumBase_obj
{
	typedef hx::EnumBase_obj super;
		typedef TextAlign_obj OBJ_;

	public:
		TextAlign_obj() {};
		HX_DO_ENUM_RTTI;
		static void __boot();
		static void __register();
		::String GetEnumName( ) const { return HX_CSTRING("com.ludamix.triad.ui.TextAlign"); }
		::String __ToString() const { return HX_CSTRING("TextAlign.") + tag; }

		static ::com::ludamix::triad::ui::TextAlign TACenter;
		static inline ::com::ludamix::triad::ui::TextAlign TACenter_dyn() { return TACenter; }
		static ::com::ludamix::triad::ui::TextAlign TAJustify;
		static inline ::com::ludamix::triad::ui::TextAlign TAJustify_dyn() { return TAJustify; }
		static ::com::ludamix::triad::ui::TextAlign TALeft;
		static inline ::com::ludamix::triad::ui::TextAlign TALeft_dyn() { return TALeft; }
		static ::com::ludamix::triad::ui::TextAlign TARight;
		static inline ::com::ludamix::triad::ui::TextAlign TARight_dyn() { return TARight; }
};

} // end namespace com
} // end namespace ludamix
} // end namespace triad
} // end namespace ui

#endif /* INCLUDED_com_ludamix_triad_ui_TextAlign */ 
