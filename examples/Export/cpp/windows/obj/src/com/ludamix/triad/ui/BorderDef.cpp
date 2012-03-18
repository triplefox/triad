#include <hxcpp.h>

#ifndef INCLUDED_com_ludamix_triad_tools_EColor
#include <com/ludamix/triad/tools/EColor.h>
#endif
#ifndef INCLUDED_com_ludamix_triad_ui_BorderDef
#include <com/ludamix/triad/ui/BorderDef.h>
#endif
#ifndef INCLUDED_com_ludamix_triad_ui_HighlightingColorDef
#include <com/ludamix/triad/ui/HighlightingColorDef.h>
#endif
namespace com{
namespace ludamix{
namespace triad{
namespace ui{

::com::ludamix::triad::ui::BorderDef  BorderDef_obj::BDColor(::com::ludamix::triad::tools::EColor col)
	{ return hx::CreateEnum< BorderDef_obj >(HX_CSTRING("BDColor"),1,hx::DynamicArray(0,1).Add(col)); }

::com::ludamix::triad::ui::BorderDef  BorderDef_obj::BDColorThickness(::com::ludamix::triad::tools::EColor col,double thickness)
	{ return hx::CreateEnum< BorderDef_obj >(HX_CSTRING("BDColorThickness"),2,hx::DynamicArray(0,2).Add(col).Add(thickness)); }

::com::ludamix::triad::ui::BorderDef  BorderDef_obj::BDColorThicknessHighlights(::com::ludamix::triad::ui::HighlightingColorDef col,double thickness)
	{ return hx::CreateEnum< BorderDef_obj >(HX_CSTRING("BDColorThicknessHighlights"),3,hx::DynamicArray(0,2).Add(col).Add(thickness)); }

::com::ludamix::triad::ui::BorderDef BorderDef_obj::BDPlaceholder;

HX_DEFINE_CREATE_ENUM(BorderDef_obj)

int BorderDef_obj::__FindIndex(::String inName)
{
	if (inName==HX_CSTRING("BDColor")) return 1;
	if (inName==HX_CSTRING("BDColorThickness")) return 2;
	if (inName==HX_CSTRING("BDColorThicknessHighlights")) return 3;
	if (inName==HX_CSTRING("BDPlaceholder")) return 0;
	return super::__FindIndex(inName);
}

STATIC_HX_DEFINE_DYNAMIC_FUNC1(BorderDef_obj,BDColor,return)

STATIC_HX_DEFINE_DYNAMIC_FUNC2(BorderDef_obj,BDColorThickness,return)

STATIC_HX_DEFINE_DYNAMIC_FUNC2(BorderDef_obj,BDColorThicknessHighlights,return)

int BorderDef_obj::__FindArgCount(::String inName)
{
	if (inName==HX_CSTRING("BDColor")) return 1;
	if (inName==HX_CSTRING("BDColorThickness")) return 2;
	if (inName==HX_CSTRING("BDColorThicknessHighlights")) return 2;
	if (inName==HX_CSTRING("BDPlaceholder")) return 0;
	return super::__FindArgCount(inName);
}

Dynamic BorderDef_obj::__Field(const ::String &inName)
{
	if (inName==HX_CSTRING("BDColor")) return BDColor_dyn();
	if (inName==HX_CSTRING("BDColorThickness")) return BDColorThickness_dyn();
	if (inName==HX_CSTRING("BDColorThicknessHighlights")) return BDColorThicknessHighlights_dyn();
	if (inName==HX_CSTRING("BDPlaceholder")) return BDPlaceholder;
	return super::__Field(inName);
}

static ::String sStaticFields[] = {
	HX_CSTRING("BDPlaceholder"),
	HX_CSTRING("BDColor"),
	HX_CSTRING("BDColorThickness"),
	HX_CSTRING("BDColorThicknessHighlights"),
	::String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(BorderDef_obj::BDPlaceholder,"BDPlaceholder");
};

static ::String sMemberFields[] = { ::String(null()) };
Class BorderDef_obj::__mClass;

Dynamic __Create_BorderDef_obj() { return new BorderDef_obj; }

void BorderDef_obj::__register()
{

Static(__mClass) = hx::RegisterClass(HX_CSTRING("com.ludamix.triad.ui.BorderDef"), hx::TCanCast< BorderDef_obj >,sStaticFields,sMemberFields,
	&__Create_BorderDef_obj, &__Create,
	&super::__SGetClass(), &CreateBorderDef_obj, sMarkStatics);
}

void BorderDef_obj::__boot()
{
Static(BDPlaceholder) = hx::CreateEnum< BorderDef_obj >(HX_CSTRING("BDPlaceholder"),0);
}


} // end namespace com
} // end namespace ludamix
} // end namespace triad
} // end namespace ui
