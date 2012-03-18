#include <hxcpp.h>

#ifndef INCLUDED_nme_text_FontType
#include <nme/text/FontType.h>
#endif
namespace nme{
namespace text{

::nme::text::FontType FontType_obj::DEVICE;

::nme::text::FontType FontType_obj::EMBEDDED;

::nme::text::FontType FontType_obj::EMBEDDED_CFF;

HX_DEFINE_CREATE_ENUM(FontType_obj)

int FontType_obj::__FindIndex(::String inName)
{
	if (inName==HX_CSTRING("DEVICE")) return 0;
	if (inName==HX_CSTRING("EMBEDDED")) return 1;
	if (inName==HX_CSTRING("EMBEDDED_CFF")) return 2;
	return super::__FindIndex(inName);
}

int FontType_obj::__FindArgCount(::String inName)
{
	if (inName==HX_CSTRING("DEVICE")) return 0;
	if (inName==HX_CSTRING("EMBEDDED")) return 0;
	if (inName==HX_CSTRING("EMBEDDED_CFF")) return 0;
	return super::__FindArgCount(inName);
}

Dynamic FontType_obj::__Field(const ::String &inName)
{
	if (inName==HX_CSTRING("DEVICE")) return DEVICE;
	if (inName==HX_CSTRING("EMBEDDED")) return EMBEDDED;
	if (inName==HX_CSTRING("EMBEDDED_CFF")) return EMBEDDED_CFF;
	return super::__Field(inName);
}

static ::String sStaticFields[] = {
	HX_CSTRING("DEVICE"),
	HX_CSTRING("EMBEDDED"),
	HX_CSTRING("EMBEDDED_CFF"),
	::String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(FontType_obj::DEVICE,"DEVICE");
	HX_MARK_MEMBER_NAME(FontType_obj::EMBEDDED,"EMBEDDED");
	HX_MARK_MEMBER_NAME(FontType_obj::EMBEDDED_CFF,"EMBEDDED_CFF");
};

static ::String sMemberFields[] = { ::String(null()) };
Class FontType_obj::__mClass;

Dynamic __Create_FontType_obj() { return new FontType_obj; }

void FontType_obj::__register()
{

Static(__mClass) = hx::RegisterClass(HX_CSTRING("nme.text.FontType"), hx::TCanCast< FontType_obj >,sStaticFields,sMemberFields,
	&__Create_FontType_obj, &__Create,
	&super::__SGetClass(), &CreateFontType_obj, sMarkStatics);
}

void FontType_obj::__boot()
{
Static(DEVICE) = hx::CreateEnum< FontType_obj >(HX_CSTRING("DEVICE"),0);
Static(EMBEDDED) = hx::CreateEnum< FontType_obj >(HX_CSTRING("EMBEDDED"),1);
Static(EMBEDDED_CFF) = hx::CreateEnum< FontType_obj >(HX_CSTRING("EMBEDDED_CFF"),2);
}


} // end namespace nme
} // end namespace text
