#include <hxcpp.h>

#ifndef INCLUDED_com_ludamix_triad_ui_StyledFontDef
#include <com/ludamix/triad/ui/StyledFontDef.h>
#endif
namespace com{
namespace ludamix{
namespace triad{
namespace ui{

::com::ludamix::triad::ui::StyledFontDef  StyledFontDef_obj::SFEmbed(::String typeface)
	{ return hx::CreateEnum< StyledFontDef_obj >(HX_CSTRING("SFEmbed"),1,hx::DynamicArray(0,1).Add(typeface)); }

::com::ludamix::triad::ui::StyledFontDef  StyledFontDef_obj::SFSystem(::String typeface)
	{ return hx::CreateEnum< StyledFontDef_obj >(HX_CSTRING("SFSystem"),0,hx::DynamicArray(0,1).Add(typeface)); }

HX_DEFINE_CREATE_ENUM(StyledFontDef_obj)

int StyledFontDef_obj::__FindIndex(::String inName)
{
	if (inName==HX_CSTRING("SFEmbed")) return 1;
	if (inName==HX_CSTRING("SFSystem")) return 0;
	return super::__FindIndex(inName);
}

STATIC_HX_DEFINE_DYNAMIC_FUNC1(StyledFontDef_obj,SFEmbed,return)

STATIC_HX_DEFINE_DYNAMIC_FUNC1(StyledFontDef_obj,SFSystem,return)

int StyledFontDef_obj::__FindArgCount(::String inName)
{
	if (inName==HX_CSTRING("SFEmbed")) return 1;
	if (inName==HX_CSTRING("SFSystem")) return 1;
	return super::__FindArgCount(inName);
}

Dynamic StyledFontDef_obj::__Field(const ::String &inName)
{
	if (inName==HX_CSTRING("SFEmbed")) return SFEmbed_dyn();
	if (inName==HX_CSTRING("SFSystem")) return SFSystem_dyn();
	return super::__Field(inName);
}

static ::String sStaticFields[] = {
	HX_CSTRING("SFSystem"),
	HX_CSTRING("SFEmbed"),
	::String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
};

static ::String sMemberFields[] = { ::String(null()) };
Class StyledFontDef_obj::__mClass;

Dynamic __Create_StyledFontDef_obj() { return new StyledFontDef_obj; }

void StyledFontDef_obj::__register()
{

Static(__mClass) = hx::RegisterClass(HX_CSTRING("com.ludamix.triad.ui.StyledFontDef"), hx::TCanCast< StyledFontDef_obj >,sStaticFields,sMemberFields,
	&__Create_StyledFontDef_obj, &__Create,
	&super::__SGetClass(), &CreateStyledFontDef_obj, sMarkStatics);
}

void StyledFontDef_obj::__boot()
{
}


} // end namespace com
} // end namespace ludamix
} // end namespace triad
} // end namespace ui
