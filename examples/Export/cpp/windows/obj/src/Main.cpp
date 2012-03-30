#include <hxcpp.h>

#ifndef INCLUDED_ASCIITest
#include <ASCIITest.h>
#endif
#ifndef INCLUDED_Main
#include <Main.h>
#endif

Void Main_obj::__construct()
{
	return null();
}

Main_obj::~Main_obj() { }

Dynamic Main_obj::__CreateEmpty() { return  new Main_obj; }
hx::ObjectPtr< Main_obj > Main_obj::__new()
{  hx::ObjectPtr< Main_obj > result = new Main_obj();
	result->__construct();
	return result;}

Dynamic Main_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Main_obj > result = new Main_obj();
	result->__construct();
	return result;}

::ASCIITest Main_obj::example;

int Main_obj::W;

int Main_obj::H;

Void Main_obj::main( ){
{
		HX_SOURCE_PUSH("Main_obj::main")
		HX_SOURCE_POS("Source/Main.hx",18)
		::Main_obj::example = ::ASCIITest_obj::__new();
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC0(Main_obj,main,(void))


Main_obj::Main_obj()
{
}

void Main_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Main);
	HX_MARK_END_CLASS();
}

Dynamic Main_obj::__Field(const ::String &inName)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"W") ) { return W; }
		if (HX_FIELD_EQ(inName,"H") ) { return H; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"main") ) { return main_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"example") ) { return example; }
	}
	return super::__Field(inName);
}

Dynamic Main_obj::__SetField(const ::String &inName,const Dynamic &inValue)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"W") ) { W=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"H") ) { H=inValue.Cast< int >(); return inValue; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"example") ) { example=inValue.Cast< ::ASCIITest >(); return inValue; }
	}
	return super::__SetField(inName,inValue);
}

void Main_obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("example"),
	HX_CSTRING("W"),
	HX_CSTRING("H"),
	HX_CSTRING("main"),
	String(null()) };

static ::String sMemberFields[] = {
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Main_obj::example,"example");
	HX_MARK_MEMBER_NAME(Main_obj::W,"W");
	HX_MARK_MEMBER_NAME(Main_obj::H,"H");
};

Class Main_obj::__mClass;

void Main_obj::__register()
{
	Static(__mClass) = hx::RegisterClass(HX_CSTRING("Main"), hx::TCanCast< Main_obj> ,sStaticFields,sMemberFields,
	&__CreateEmpty, &__Create,
	&super::__SGetClass(), 0, sMarkStatics);
}

void Main_obj::__boot()
{
	hx::Static(example);
	hx::Static(W) = (int)720;
	hx::Static(H) = (int)400;
}

