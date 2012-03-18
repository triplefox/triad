#include <hxcpp.h>

#ifndef INCLUDED_com_ludamix_triad_ui_TextAlign
#include <com/ludamix/triad/ui/TextAlign.h>
#endif
namespace com{
namespace ludamix{
namespace triad{
namespace ui{

::com::ludamix::triad::ui::TextAlign TextAlign_obj::TACenter;

::com::ludamix::triad::ui::TextAlign TextAlign_obj::TAJustify;

::com::ludamix::triad::ui::TextAlign TextAlign_obj::TALeft;

::com::ludamix::triad::ui::TextAlign TextAlign_obj::TARight;

HX_DEFINE_CREATE_ENUM(TextAlign_obj)

int TextAlign_obj::__FindIndex(::String inName)
{
	if (inName==HX_CSTRING("TACenter")) return 2;
	if (inName==HX_CSTRING("TAJustify")) return 3;
	if (inName==HX_CSTRING("TALeft")) return 0;
	if (inName==HX_CSTRING("TARight")) return 1;
	return super::__FindIndex(inName);
}

int TextAlign_obj::__FindArgCount(::String inName)
{
	if (inName==HX_CSTRING("TACenter")) return 0;
	if (inName==HX_CSTRING("TAJustify")) return 0;
	if (inName==HX_CSTRING("TALeft")) return 0;
	if (inName==HX_CSTRING("TARight")) return 0;
	return super::__FindArgCount(inName);
}

Dynamic TextAlign_obj::__Field(const ::String &inName)
{
	if (inName==HX_CSTRING("TACenter")) return TACenter;
	if (inName==HX_CSTRING("TAJustify")) return TAJustify;
	if (inName==HX_CSTRING("TALeft")) return TALeft;
	if (inName==HX_CSTRING("TARight")) return TARight;
	return super::__Field(inName);
}

static ::String sStaticFields[] = {
	HX_CSTRING("TALeft"),
	HX_CSTRING("TARight"),
	HX_CSTRING("TACenter"),
	HX_CSTRING("TAJustify"),
	::String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(TextAlign_obj::TACenter,"TACenter");
	HX_MARK_MEMBER_NAME(TextAlign_obj::TAJustify,"TAJustify");
	HX_MARK_MEMBER_NAME(TextAlign_obj::TALeft,"TALeft");
	HX_MARK_MEMBER_NAME(TextAlign_obj::TARight,"TARight");
};

static ::String sMemberFields[] = { ::String(null()) };
Class TextAlign_obj::__mClass;

Dynamic __Create_TextAlign_obj() { return new TextAlign_obj; }

void TextAlign_obj::__register()
{

Static(__mClass) = hx::RegisterClass(HX_CSTRING("com.ludamix.triad.ui.TextAlign"), hx::TCanCast< TextAlign_obj >,sStaticFields,sMemberFields,
	&__Create_TextAlign_obj, &__Create,
	&super::__SGetClass(), &CreateTextAlign_obj, sMarkStatics);
}

void TextAlign_obj::__boot()
{
Static(TACenter) = hx::CreateEnum< TextAlign_obj >(HX_CSTRING("TACenter"),2);
Static(TAJustify) = hx::CreateEnum< TextAlign_obj >(HX_CSTRING("TAJustify"),3);
Static(TALeft) = hx::CreateEnum< TextAlign_obj >(HX_CSTRING("TALeft"),0);
Static(TARight) = hx::CreateEnum< TextAlign_obj >(HX_CSTRING("TARight"),1);
}


} // end namespace com
} // end namespace ludamix
} // end namespace triad
} // end namespace ui
