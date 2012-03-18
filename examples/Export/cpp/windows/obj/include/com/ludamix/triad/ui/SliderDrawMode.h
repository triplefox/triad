#ifndef INCLUDED_com_ludamix_triad_ui_SliderDrawMode
#define INCLUDED_com_ludamix_triad_ui_SliderDrawMode

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS4(com,ludamix,triad,ui,SliderDrawMode)
namespace com{
namespace ludamix{
namespace triad{
namespace ui{


class SliderDrawMode_obj : public hx::EnumBase_obj
{
	typedef hx::EnumBase_obj super;
		typedef SliderDrawMode_obj OBJ_;

	public:
		SliderDrawMode_obj() {};
		HX_DO_ENUM_RTTI;
		static void __boot();
		static void __register();
		::String GetEnumName( ) const { return HX_CSTRING("com.ludamix.triad.ui.SliderDrawMode"); }
		::String __ToString() const { return HX_CSTRING("SliderDrawMode.") + tag; }

		static ::com::ludamix::triad::ui::SliderDrawMode SliderCut;
		static inline ::com::ludamix::triad::ui::SliderDrawMode SliderCut_dyn() { return SliderCut; }
		static ::com::ludamix::triad::ui::SliderDrawMode SliderRepeat;
		static inline ::com::ludamix::triad::ui::SliderDrawMode SliderRepeat_dyn() { return SliderRepeat; }
		static ::com::ludamix::triad::ui::SliderDrawMode SliderStretch;
		static inline ::com::ludamix::triad::ui::SliderDrawMode SliderStretch_dyn() { return SliderStretch; }
};

} // end namespace com
} // end namespace ludamix
} // end namespace triad
} // end namespace ui

#endif /* INCLUDED_com_ludamix_triad_ui_SliderDrawMode */ 
