#include <hxcpp.h>

#ifndef INCLUDED_com_ludamix_triad_ui_BorderDef
#include <com/ludamix/triad/ui/BorderDef.h>
#endif
#ifndef INCLUDED_com_ludamix_triad_ui_HighlightingColorDef
#include <com/ludamix/triad/ui/HighlightingColorDef.h>
#endif
#ifndef INCLUDED_com_ludamix_triad_ui_RoundRectButtonDef
#include <com/ludamix/triad/ui/RoundRectButtonDef.h>
#endif
#ifndef INCLUDED_com_ludamix_triad_ui_StyledTextDef
#include <com/ludamix/triad/ui/StyledTextDef.h>
#endif
namespace com{
namespace ludamix{
namespace triad{
namespace ui{

::com::ludamix::triad::ui::RoundRectButtonDef  RoundRectButtonDef_obj::RRBorder(::com::ludamix::triad::ui::BorderDef border,::com::ludamix::triad::ui::HighlightingColorDef color,::com::ludamix::triad::ui::StyledTextDef text,double roundnessX,double roundnessY)
	{ return hx::CreateEnum< RoundRectButtonDef_obj >(HX_CSTRING("RRBorder"),2,hx::DynamicArray(0,5).Add(border).Add(color).Add(text).Add(roundnessX).Add(roundnessY)); }

::com::ludamix::triad::ui::RoundRectButtonDef  RoundRectButtonDef_obj::RRBorderSimple(::com::ludamix::triad::ui::BorderDef border,::com::ludamix::triad::ui::HighlightingColorDef color,::com::ludamix::triad::ui::StyledTextDef text,double roundness)
	{ return hx::CreateEnum< RoundRectButtonDef_obj >(HX_CSTRING("RRBorderSimple"),1,hx::DynamicArray(0,4).Add(border).Add(color).Add(text).Add(roundness)); }

::com::ludamix::triad::ui::RoundRectButtonDef RoundRectButtonDef_obj::RRPlaceholder;

HX_DEFINE_CREATE_ENUM(RoundRectButtonDef_obj)

int RoundRectButtonDef_obj::__FindIndex(::String inName)
{
	if (inName==HX_CSTRING("RRBorder")) return 2;
	if (inName==HX_CSTRING("RRBorderSimple")) return 1;
	if (inName==HX_CSTRING("RRPlaceholder")) return 0;
	return super::__FindIndex(inName);
}

STATIC_HX_DEFINE_DYNAMIC_FUNC5(RoundRectButtonDef_obj,RRBorder,return)

STATIC_HX_DEFINE_DYNAMIC_FUNC4(RoundRectButtonDef_obj,RRBorderSimple,return)

int RoundRectButtonDef_obj::__FindArgCount(::String inName)
{
	if (inName==HX_CSTRING("RRBorder")) return 5;
	if (inName==HX_CSTRING("RRBorderSimple")) return 4;
	if (inName==HX_CSTRING("RRPlaceholder")) return 0;
	return super::__FindArgCount(inName);
}

Dynamic RoundRectButtonDef_obj::__Field(const ::String &inName)
{
	if (inName==HX_CSTRING("RRBorder")) return RRBorder_dyn();
	if (inName==HX_CSTRING("RRBorderSimple")) return RRBorderSimple_dyn();
	if (inName==HX_CSTRING("RRPlaceholder")) return RRPlaceholder;
	return super::__Field(inName);
}

static ::String sStaticFields[] = {
	HX_CSTRING("RRPlaceholder"),
	HX_CSTRING("RRBorderSimple"),
	HX_CSTRING("RRBorder"),
	::String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(RoundRectButtonDef_obj::RRPlaceholder,"RRPlaceholder");
};

static ::String sMemberFields[] = { ::String(null()) };
Class RoundRectButtonDef_obj::__mClass;

Dynamic __Create_RoundRectButtonDef_obj() { return new RoundRectButtonDef_obj; }

void RoundRectButtonDef_obj::__register()
{

Static(__mClass) = hx::RegisterClass(HX_CSTRING("com.ludamix.triad.ui.RoundRectButtonDef"), hx::TCanCast< RoundRectButtonDef_obj >,sStaticFields,sMemberFields,
	&__Create_RoundRectButtonDef_obj, &__Create,
	&super::__SGetClass(), &CreateRoundRectButtonDef_obj, sMarkStatics);
}

void RoundRectButtonDef_obj::__boot()
{
Static(RRPlaceholder) = hx::CreateEnum< RoundRectButtonDef_obj >(HX_CSTRING("RRPlaceholder"),0);
}


} // end namespace com
} // end namespace ludamix
} // end namespace triad
} // end namespace ui
