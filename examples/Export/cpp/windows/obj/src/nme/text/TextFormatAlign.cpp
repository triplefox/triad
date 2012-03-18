#include <hxcpp.h>

#ifndef INCLUDED_nme_text_TextFormatAlign
#include <nme/text/TextFormatAlign.h>
#endif
namespace nme{
namespace text{

Void TextFormatAlign_obj::__construct()
{
	return null();
}

TextFormatAlign_obj::~TextFormatAlign_obj() { }

Dynamic TextFormatAlign_obj::__CreateEmpty() { return  new TextFormatAlign_obj; }
hx::ObjectPtr< TextFormatAlign_obj > TextFormatAlign_obj::__new()
{  hx::ObjectPtr< TextFormatAlign_obj > result = new TextFormatAlign_obj();
	result->__construct();
	return result;}

Dynamic TextFormatAlign_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< TextFormatAlign_obj > result = new TextFormatAlign_obj();
	result->__construct();
	return result;}

::String TextFormatAlign_obj::LEFT;

::String TextFormatAlign_obj::RIGHT;

::String TextFormatAlign_obj::CENTER;

::String TextFormatAlign_obj::JUSTIFY;


TextFormatAlign_obj::TextFormatAlign_obj()
{
}

void TextFormatAlign_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(TextFormatAlign);
	HX_MARK_END_CLASS();
}

Dynamic TextFormatAlign_obj::__Field(const ::String &inName)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"LEFT") ) { return LEFT; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"RIGHT") ) { return RIGHT; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"CENTER") ) { return CENTER; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"JUSTIFY") ) { return JUSTIFY; }
	}
	return super::__Field(inName);
}

Dynamic TextFormatAlign_obj::__SetField(const ::String &inName,const Dynamic &inValue)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"LEFT") ) { LEFT=inValue.Cast< ::String >(); return inValue; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"RIGHT") ) { RIGHT=inValue.Cast< ::String >(); return inValue; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"CENTER") ) { CENTER=inValue.Cast< ::String >(); return inValue; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"JUSTIFY") ) { JUSTIFY=inValue.Cast< ::String >(); return inValue; }
	}
	return super::__SetField(inName,inValue);
}

void TextFormatAlign_obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("LEFT"),
	HX_CSTRING("RIGHT"),
	HX_CSTRING("CENTER"),
	HX_CSTRING("JUSTIFY"),
	String(null()) };

static ::String sMemberFields[] = {
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(TextFormatAlign_obj::LEFT,"LEFT");
	HX_MARK_MEMBER_NAME(TextFormatAlign_obj::RIGHT,"RIGHT");
	HX_MARK_MEMBER_NAME(TextFormatAlign_obj::CENTER,"CENTER");
	HX_MARK_MEMBER_NAME(TextFormatAlign_obj::JUSTIFY,"JUSTIFY");
};

Class TextFormatAlign_obj::__mClass;

void TextFormatAlign_obj::__register()
{
	Static(__mClass) = hx::RegisterClass(HX_CSTRING("nme.text.TextFormatAlign"), hx::TCanCast< TextFormatAlign_obj> ,sStaticFields,sMemberFields,
	&__CreateEmpty, &__Create,
	&super::__SGetClass(), 0, sMarkStatics);
}

void TextFormatAlign_obj::__boot()
{
	hx::Static(LEFT) = HX_CSTRING("left");
	hx::Static(RIGHT) = HX_CSTRING("right");
	hx::Static(CENTER) = HX_CSTRING("center");
	hx::Static(JUSTIFY) = HX_CSTRING("justify");
}

} // end namespace nme
} // end namespace text
