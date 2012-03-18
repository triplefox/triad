#include <hxcpp.h>

#ifndef INCLUDED_com_ludamix_triad_tools_EColor
#include <com/ludamix/triad/tools/EColor.h>
#endif
#ifndef INCLUDED_com_ludamix_triad_ui_HighlightingColorDef
#include <com/ludamix/triad/ui/HighlightingColorDef.h>
#endif
namespace com{
namespace ludamix{
namespace triad{
namespace ui{

::com::ludamix::triad::ui::HighlightingColorDef  HighlightingColorDef_obj::HCDualcolor(::com::ludamix::triad::tools::EColor off,::com::ludamix::triad::tools::EColor down)
	{ return hx::CreateEnum< HighlightingColorDef_obj >(HX_CSTRING("HCDualcolor"),9,hx::DynamicArray(0,2).Add(off).Add(down)); }

::com::ludamix::triad::ui::HighlightingColorDef  HighlightingColorDef_obj::HCHueSatShift(::com::ludamix::triad::tools::EColor primary,double strength)
	{ return hx::CreateEnum< HighlightingColorDef_obj >(HX_CSTRING("HCHueSatShift"),4,hx::DynamicArray(0,2).Add(primary).Add(strength)); }

::com::ludamix::triad::ui::HighlightingColorDef  HighlightingColorDef_obj::HCHueSatValShift(::com::ludamix::triad::tools::EColor primary,double strength)
	{ return hx::CreateEnum< HighlightingColorDef_obj >(HX_CSTRING("HCHueSatValShift"),7,hx::DynamicArray(0,2).Add(primary).Add(strength)); }

::com::ludamix::triad::ui::HighlightingColorDef  HighlightingColorDef_obj::HCHueShift(::com::ludamix::triad::tools::EColor primary,double strength)
	{ return hx::CreateEnum< HighlightingColorDef_obj >(HX_CSTRING("HCHueShift"),1,hx::DynamicArray(0,2).Add(primary).Add(strength)); }

::com::ludamix::triad::ui::HighlightingColorDef  HighlightingColorDef_obj::HCHueValShift(::com::ludamix::triad::tools::EColor primary,double strength)
	{ return hx::CreateEnum< HighlightingColorDef_obj >(HX_CSTRING("HCHueValShift"),5,hx::DynamicArray(0,2).Add(primary).Add(strength)); }

::com::ludamix::triad::ui::HighlightingColorDef  HighlightingColorDef_obj::HCMono(::com::ludamix::triad::tools::EColor c)
	{ return hx::CreateEnum< HighlightingColorDef_obj >(HX_CSTRING("HCMono"),10,hx::DynamicArray(0,1).Add(c)); }

::com::ludamix::triad::ui::HighlightingColorDef HighlightingColorDef_obj::HCPlaceholder;

::com::ludamix::triad::ui::HighlightingColorDef  HighlightingColorDef_obj::HCSatShift(::com::ludamix::triad::tools::EColor primary,double strength)
	{ return hx::CreateEnum< HighlightingColorDef_obj >(HX_CSTRING("HCSatShift"),2,hx::DynamicArray(0,2).Add(primary).Add(strength)); }

::com::ludamix::triad::ui::HighlightingColorDef  HighlightingColorDef_obj::HCSatValShift(::com::ludamix::triad::tools::EColor primary,double strength)
	{ return hx::CreateEnum< HighlightingColorDef_obj >(HX_CSTRING("HCSatValShift"),6,hx::DynamicArray(0,2).Add(primary).Add(strength)); }

::com::ludamix::triad::ui::HighlightingColorDef  HighlightingColorDef_obj::HCTricolor(::com::ludamix::triad::tools::EColor off,::com::ludamix::triad::tools::EColor highlighted,::com::ludamix::triad::tools::EColor down)
	{ return hx::CreateEnum< HighlightingColorDef_obj >(HX_CSTRING("HCTricolor"),8,hx::DynamicArray(0,3).Add(off).Add(highlighted).Add(down)); }

::com::ludamix::triad::ui::HighlightingColorDef  HighlightingColorDef_obj::HCValShift(::com::ludamix::triad::tools::EColor primary,double strength)
	{ return hx::CreateEnum< HighlightingColorDef_obj >(HX_CSTRING("HCValShift"),3,hx::DynamicArray(0,2).Add(primary).Add(strength)); }

HX_DEFINE_CREATE_ENUM(HighlightingColorDef_obj)

int HighlightingColorDef_obj::__FindIndex(::String inName)
{
	if (inName==HX_CSTRING("HCDualcolor")) return 9;
	if (inName==HX_CSTRING("HCHueSatShift")) return 4;
	if (inName==HX_CSTRING("HCHueSatValShift")) return 7;
	if (inName==HX_CSTRING("HCHueShift")) return 1;
	if (inName==HX_CSTRING("HCHueValShift")) return 5;
	if (inName==HX_CSTRING("HCMono")) return 10;
	if (inName==HX_CSTRING("HCPlaceholder")) return 0;
	if (inName==HX_CSTRING("HCSatShift")) return 2;
	if (inName==HX_CSTRING("HCSatValShift")) return 6;
	if (inName==HX_CSTRING("HCTricolor")) return 8;
	if (inName==HX_CSTRING("HCValShift")) return 3;
	return super::__FindIndex(inName);
}

STATIC_HX_DEFINE_DYNAMIC_FUNC2(HighlightingColorDef_obj,HCDualcolor,return)

STATIC_HX_DEFINE_DYNAMIC_FUNC2(HighlightingColorDef_obj,HCHueSatShift,return)

STATIC_HX_DEFINE_DYNAMIC_FUNC2(HighlightingColorDef_obj,HCHueSatValShift,return)

STATIC_HX_DEFINE_DYNAMIC_FUNC2(HighlightingColorDef_obj,HCHueShift,return)

STATIC_HX_DEFINE_DYNAMIC_FUNC2(HighlightingColorDef_obj,HCHueValShift,return)

STATIC_HX_DEFINE_DYNAMIC_FUNC1(HighlightingColorDef_obj,HCMono,return)

STATIC_HX_DEFINE_DYNAMIC_FUNC2(HighlightingColorDef_obj,HCSatShift,return)

STATIC_HX_DEFINE_DYNAMIC_FUNC2(HighlightingColorDef_obj,HCSatValShift,return)

STATIC_HX_DEFINE_DYNAMIC_FUNC3(HighlightingColorDef_obj,HCTricolor,return)

STATIC_HX_DEFINE_DYNAMIC_FUNC2(HighlightingColorDef_obj,HCValShift,return)

int HighlightingColorDef_obj::__FindArgCount(::String inName)
{
	if (inName==HX_CSTRING("HCDualcolor")) return 2;
	if (inName==HX_CSTRING("HCHueSatShift")) return 2;
	if (inName==HX_CSTRING("HCHueSatValShift")) return 2;
	if (inName==HX_CSTRING("HCHueShift")) return 2;
	if (inName==HX_CSTRING("HCHueValShift")) return 2;
	if (inName==HX_CSTRING("HCMono")) return 1;
	if (inName==HX_CSTRING("HCPlaceholder")) return 0;
	if (inName==HX_CSTRING("HCSatShift")) return 2;
	if (inName==HX_CSTRING("HCSatValShift")) return 2;
	if (inName==HX_CSTRING("HCTricolor")) return 3;
	if (inName==HX_CSTRING("HCValShift")) return 2;
	return super::__FindArgCount(inName);
}

Dynamic HighlightingColorDef_obj::__Field(const ::String &inName)
{
	if (inName==HX_CSTRING("HCDualcolor")) return HCDualcolor_dyn();
	if (inName==HX_CSTRING("HCHueSatShift")) return HCHueSatShift_dyn();
	if (inName==HX_CSTRING("HCHueSatValShift")) return HCHueSatValShift_dyn();
	if (inName==HX_CSTRING("HCHueShift")) return HCHueShift_dyn();
	if (inName==HX_CSTRING("HCHueValShift")) return HCHueValShift_dyn();
	if (inName==HX_CSTRING("HCMono")) return HCMono_dyn();
	if (inName==HX_CSTRING("HCPlaceholder")) return HCPlaceholder;
	if (inName==HX_CSTRING("HCSatShift")) return HCSatShift_dyn();
	if (inName==HX_CSTRING("HCSatValShift")) return HCSatValShift_dyn();
	if (inName==HX_CSTRING("HCTricolor")) return HCTricolor_dyn();
	if (inName==HX_CSTRING("HCValShift")) return HCValShift_dyn();
	return super::__Field(inName);
}

static ::String sStaticFields[] = {
	HX_CSTRING("HCPlaceholder"),
	HX_CSTRING("HCHueShift"),
	HX_CSTRING("HCSatShift"),
	HX_CSTRING("HCValShift"),
	HX_CSTRING("HCHueSatShift"),
	HX_CSTRING("HCHueValShift"),
	HX_CSTRING("HCSatValShift"),
	HX_CSTRING("HCHueSatValShift"),
	HX_CSTRING("HCTricolor"),
	HX_CSTRING("HCDualcolor"),
	HX_CSTRING("HCMono"),
	::String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(HighlightingColorDef_obj::HCPlaceholder,"HCPlaceholder");
};

static ::String sMemberFields[] = { ::String(null()) };
Class HighlightingColorDef_obj::__mClass;

Dynamic __Create_HighlightingColorDef_obj() { return new HighlightingColorDef_obj; }

void HighlightingColorDef_obj::__register()
{

Static(__mClass) = hx::RegisterClass(HX_CSTRING("com.ludamix.triad.ui.HighlightingColorDef"), hx::TCanCast< HighlightingColorDef_obj >,sStaticFields,sMemberFields,
	&__Create_HighlightingColorDef_obj, &__Create,
	&super::__SGetClass(), &CreateHighlightingColorDef_obj, sMarkStatics);
}

void HighlightingColorDef_obj::__boot()
{
Static(HCPlaceholder) = hx::CreateEnum< HighlightingColorDef_obj >(HX_CSTRING("HCPlaceholder"),0);
}


} // end namespace com
} // end namespace ludamix
} // end namespace triad
} // end namespace ui
