#include <hxcpp.h>

#ifndef INCLUDED_nme_Loader
#include <nme/Loader.h>
#endif
#ifndef INCLUDED_nme_text_Font
#include <nme/text/Font.h>
#endif
#ifndef INCLUDED_nme_text_FontStyle
#include <nme/text/FontStyle.h>
#endif
#ifndef INCLUDED_nme_text_FontType
#include <nme/text/FontType.h>
#endif
namespace nme{
namespace text{

Void Font_obj::__construct(::String inFilename)
{
{
	HX_SOURCE_POS("C:\\Motion-Twin\\haxe\\lib\\nme/3,2,0/nme/text/Font.hx",18)
	this->fontName = inFilename;
}
;
	return null();
}

Font_obj::~Font_obj() { }

Dynamic Font_obj::__CreateEmpty() { return  new Font_obj; }
hx::ObjectPtr< Font_obj > Font_obj::__new(::String inFilename)
{  hx::ObjectPtr< Font_obj > result = new Font_obj();
	result->__construct(inFilename);
	return result;}

Dynamic Font_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Font_obj > result = new Font_obj();
	result->__construct(inArgs[0]);
	return result;}

Dynamic Font_obj::load( ::String inFilename){
	HX_SOURCE_PUSH("Font_obj::load")
	HX_SOURCE_POS("C:\\Motion-Twin\\haxe\\lib\\nme/3,2,0/nme/text/Font.hx",28)
	Dynamic result = ::nme::text::Font_obj::freetype_import_font(inFilename,null(),(int)20480);
	HX_SOURCE_POS("C:\\Motion-Twin\\haxe\\lib\\nme/3,2,0/nme/text/Font.hx",29)
	return result;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Font_obj,load,return )

Dynamic Font_obj::freetype_import_font;


Font_obj::Font_obj()
{
}

void Font_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Font);
	HX_MARK_MEMBER_NAME(fontName,"fontName");
	HX_MARK_MEMBER_NAME(fontStyle,"fontStyle");
	HX_MARK_MEMBER_NAME(fontType,"fontType");
	HX_MARK_END_CLASS();
}

Dynamic Font_obj::__Field(const ::String &inName)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"load") ) { return load_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"fontName") ) { return fontName; }
		if (HX_FIELD_EQ(inName,"fontType") ) { return fontType; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"fontStyle") ) { return fontStyle; }
		break;
	case 20:
		if (HX_FIELD_EQ(inName,"freetype_import_font") ) { return freetype_import_font; }
	}
	return super::__Field(inName);
}

Dynamic Font_obj::__SetField(const ::String &inName,const Dynamic &inValue)
{
	switch(inName.length) {
	case 8:
		if (HX_FIELD_EQ(inName,"fontName") ) { fontName=inValue.Cast< ::String >(); return inValue; }
		if (HX_FIELD_EQ(inName,"fontType") ) { fontType=inValue.Cast< ::nme::text::FontType >(); return inValue; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"fontStyle") ) { fontStyle=inValue.Cast< ::nme::text::FontStyle >(); return inValue; }
		break;
	case 20:
		if (HX_FIELD_EQ(inName,"freetype_import_font") ) { freetype_import_font=inValue.Cast< Dynamic >(); return inValue; }
	}
	return super::__SetField(inName,inValue);
}

void Font_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("fontName"));
	outFields->push(HX_CSTRING("fontStyle"));
	outFields->push(HX_CSTRING("fontType"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("load"),
	HX_CSTRING("freetype_import_font"),
	String(null()) };

static ::String sMemberFields[] = {
	HX_CSTRING("fontName"),
	HX_CSTRING("fontStyle"),
	HX_CSTRING("fontType"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Font_obj::freetype_import_font,"freetype_import_font");
};

Class Font_obj::__mClass;

void Font_obj::__register()
{
	Static(__mClass) = hx::RegisterClass(HX_CSTRING("nme.text.Font"), hx::TCanCast< Font_obj> ,sStaticFields,sMemberFields,
	&__CreateEmpty, &__Create,
	&super::__SGetClass(), 0, sMarkStatics);
}

void Font_obj::__boot()
{
	hx::Static(freetype_import_font) = ::nme::Loader_obj::load(HX_CSTRING("freetype_import_font"),(int)3);
}

} // end namespace nme
} // end namespace text
