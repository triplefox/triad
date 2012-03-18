#include <hxcpp.h>

#ifndef INCLUDED_com_ludamix_triad_tools_EColor
#include <com/ludamix/triad/tools/EColor.h>
#endif
#ifndef INCLUDED_com_ludamix_triad_ui_StyledFontDef
#include <com/ludamix/triad/ui/StyledFontDef.h>
#endif
#ifndef INCLUDED_com_ludamix_triad_ui_StyledTextDef
#include <com/ludamix/triad/ui/StyledTextDef.h>
#endif
#ifndef INCLUDED_com_ludamix_triad_ui_TextAlign
#include <com/ludamix/triad/ui/TextAlign.h>
#endif
#ifndef INCLUDED_nme_text_TextFieldAutoSize
#include <nme/text/TextFieldAutoSize.h>
#endif
namespace com{
namespace ludamix{
namespace triad{
namespace ui{

::com::ludamix::triad::ui::StyledTextDef  StyledTextDef_obj::STAutosize(double size,::com::ludamix::triad::ui::StyledFontDef font,::com::ludamix::triad::tools::EColor color,bool wordwrap,::com::ludamix::triad::ui::TextAlign align,::nme::text::TextFieldAutoSize autosize)
	{ return hx::CreateEnum< StyledTextDef_obj >(HX_CSTRING("STAutosize"),3,hx::DynamicArray(0,6).Add(size).Add(font).Add(color).Add(wordwrap).Add(align).Add(autosize)); }

::com::ludamix::triad::ui::StyledTextDef  StyledTextDef_obj::STFixed(double size,::com::ludamix::triad::ui::StyledFontDef font,::com::ludamix::triad::tools::EColor color,bool wordwrap,::com::ludamix::triad::ui::TextAlign align)
	{ return hx::CreateEnum< StyledTextDef_obj >(HX_CSTRING("STFixed"),2,hx::DynamicArray(0,5).Add(size).Add(font).Add(color).Add(wordwrap).Add(align)); }

::com::ludamix::triad::ui::StyledTextDef StyledTextDef_obj::STPlaceholder;

::com::ludamix::triad::ui::StyledTextDef StyledTextDef_obj::STPlaceholderAutosize;

HX_DEFINE_CREATE_ENUM(StyledTextDef_obj)

int StyledTextDef_obj::__FindIndex(::String inName)
{
	if (inName==HX_CSTRING("STAutosize")) return 3;
	if (inName==HX_CSTRING("STFixed")) return 2;
	if (inName==HX_CSTRING("STPlaceholder")) return 0;
	if (inName==HX_CSTRING("STPlaceholderAutosize")) return 1;
	return super::__FindIndex(inName);
}

STATIC_HX_DEFINE_DYNAMIC_FUNC6(StyledTextDef_obj,STAutosize,return)

STATIC_HX_DEFINE_DYNAMIC_FUNC5(StyledTextDef_obj,STFixed,return)

int StyledTextDef_obj::__FindArgCount(::String inName)
{
	if (inName==HX_CSTRING("STAutosize")) return 6;
	if (inName==HX_CSTRING("STFixed")) return 5;
	if (inName==HX_CSTRING("STPlaceholder")) return 0;
	if (inName==HX_CSTRING("STPlaceholderAutosize")) return 0;
	return super::__FindArgCount(inName);
}

Dynamic StyledTextDef_obj::__Field(const ::String &inName)
{
	if (inName==HX_CSTRING("STAutosize")) return STAutosize_dyn();
	if (inName==HX_CSTRING("STFixed")) return STFixed_dyn();
	if (inName==HX_CSTRING("STPlaceholder")) return STPlaceholder;
	if (inName==HX_CSTRING("STPlaceholderAutosize")) return STPlaceholderAutosize;
	return super::__Field(inName);
}

static ::String sStaticFields[] = {
	HX_CSTRING("STPlaceholder"),
	HX_CSTRING("STPlaceholderAutosize"),
	HX_CSTRING("STFixed"),
	HX_CSTRING("STAutosize"),
	::String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(StyledTextDef_obj::STPlaceholder,"STPlaceholder");
	HX_MARK_MEMBER_NAME(StyledTextDef_obj::STPlaceholderAutosize,"STPlaceholderAutosize");
};

static ::String sMemberFields[] = { ::String(null()) };
Class StyledTextDef_obj::__mClass;

Dynamic __Create_StyledTextDef_obj() { return new StyledTextDef_obj; }

void StyledTextDef_obj::__register()
{

Static(__mClass) = hx::RegisterClass(HX_CSTRING("com.ludamix.triad.ui.StyledTextDef"), hx::TCanCast< StyledTextDef_obj >,sStaticFields,sMemberFields,
	&__Create_StyledTextDef_obj, &__Create,
	&super::__SGetClass(), &CreateStyledTextDef_obj, sMarkStatics);
}

void StyledTextDef_obj::__boot()
{
Static(STPlaceholder) = hx::CreateEnum< StyledTextDef_obj >(HX_CSTRING("STPlaceholder"),0);
Static(STPlaceholderAutosize) = hx::CreateEnum< StyledTextDef_obj >(HX_CSTRING("STPlaceholderAutosize"),1);
}


} // end namespace com
} // end namespace ludamix
} // end namespace triad
} // end namespace ui
