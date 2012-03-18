#include <hxcpp.h>

#ifndef INCLUDED_com_ludamix_triad_ui_SliderDrawMode
#include <com/ludamix/triad/ui/SliderDrawMode.h>
#endif
namespace com{
namespace ludamix{
namespace triad{
namespace ui{

::com::ludamix::triad::ui::SliderDrawMode SliderDrawMode_obj::SliderCut;

::com::ludamix::triad::ui::SliderDrawMode SliderDrawMode_obj::SliderRepeat;

::com::ludamix::triad::ui::SliderDrawMode SliderDrawMode_obj::SliderStretch;

HX_DEFINE_CREATE_ENUM(SliderDrawMode_obj)

int SliderDrawMode_obj::__FindIndex(::String inName)
{
	if (inName==HX_CSTRING("SliderCut")) return 2;
	if (inName==HX_CSTRING("SliderRepeat")) return 1;
	if (inName==HX_CSTRING("SliderStretch")) return 0;
	return super::__FindIndex(inName);
}

int SliderDrawMode_obj::__FindArgCount(::String inName)
{
	if (inName==HX_CSTRING("SliderCut")) return 0;
	if (inName==HX_CSTRING("SliderRepeat")) return 0;
	if (inName==HX_CSTRING("SliderStretch")) return 0;
	return super::__FindArgCount(inName);
}

Dynamic SliderDrawMode_obj::__Field(const ::String &inName)
{
	if (inName==HX_CSTRING("SliderCut")) return SliderCut;
	if (inName==HX_CSTRING("SliderRepeat")) return SliderRepeat;
	if (inName==HX_CSTRING("SliderStretch")) return SliderStretch;
	return super::__Field(inName);
}

static ::String sStaticFields[] = {
	HX_CSTRING("SliderStretch"),
	HX_CSTRING("SliderRepeat"),
	HX_CSTRING("SliderCut"),
	::String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(SliderDrawMode_obj::SliderCut,"SliderCut");
	HX_MARK_MEMBER_NAME(SliderDrawMode_obj::SliderRepeat,"SliderRepeat");
	HX_MARK_MEMBER_NAME(SliderDrawMode_obj::SliderStretch,"SliderStretch");
};

static ::String sMemberFields[] = { ::String(null()) };
Class SliderDrawMode_obj::__mClass;

Dynamic __Create_SliderDrawMode_obj() { return new SliderDrawMode_obj; }

void SliderDrawMode_obj::__register()
{

Static(__mClass) = hx::RegisterClass(HX_CSTRING("com.ludamix.triad.ui.SliderDrawMode"), hx::TCanCast< SliderDrawMode_obj >,sStaticFields,sMemberFields,
	&__Create_SliderDrawMode_obj, &__Create,
	&super::__SGetClass(), &CreateSliderDrawMode_obj, sMarkStatics);
}

void SliderDrawMode_obj::__boot()
{
Static(SliderCut) = hx::CreateEnum< SliderDrawMode_obj >(HX_CSTRING("SliderCut"),2);
Static(SliderRepeat) = hx::CreateEnum< SliderDrawMode_obj >(HX_CSTRING("SliderRepeat"),1);
Static(SliderStretch) = hx::CreateEnum< SliderDrawMode_obj >(HX_CSTRING("SliderStretch"),0);
}


} // end namespace com
} // end namespace ludamix
} // end namespace triad
} // end namespace ui
