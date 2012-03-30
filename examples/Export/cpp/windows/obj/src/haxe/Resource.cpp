#include <hxcpp.h>

#ifndef INCLUDED_haxe_Resource
#include <haxe/Resource.h>
#endif
#ifndef INCLUDED_haxe_io_Bytes
#include <haxe/io/Bytes.h>
#endif
namespace haxe{

Void Resource_obj::__construct()
{
	return null();
}

Resource_obj::~Resource_obj() { }

Dynamic Resource_obj::__CreateEmpty() { return  new Resource_obj; }
hx::ObjectPtr< Resource_obj > Resource_obj::__new()
{  hx::ObjectPtr< Resource_obj > result = new Resource_obj();
	result->__construct();
	return result;}

Dynamic Resource_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Resource_obj > result = new Resource_obj();
	result->__construct();
	return result;}

Array< ::String > Resource_obj::listNames( ){
	HX_SOURCE_PUSH("Resource_obj::listNames")
	HX_SOURCE_POS("C:\\Motion-Twin\\haxe/std/cpp/_std/haxe/Resource.hx",30)
	return ::__hxcpp_resource_names();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC0(Resource_obj,listNames,return )

::String Resource_obj::getString( ::String name){
	HX_SOURCE_PUSH("Resource_obj::getString")
	HX_SOURCE_POS("C:\\Motion-Twin\\haxe/std/cpp/_std/haxe/Resource.hx",33)
	return ::__hxcpp_resource_string(name);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Resource_obj,getString,return )

::haxe::io::Bytes Resource_obj::getBytes( ::String name){
	HX_SOURCE_PUSH("Resource_obj::getBytes")
	HX_SOURCE_POS("C:\\Motion-Twin\\haxe/std/cpp/_std/haxe/Resource.hx",37)
	Array< unsigned char > array = ::__hxcpp_resource_bytes(name);
	HX_SOURCE_POS("C:\\Motion-Twin\\haxe/std/cpp/_std/haxe/Resource.hx",38)
	if (((array == null()))){
		HX_SOURCE_POS("C:\\Motion-Twin\\haxe/std/cpp/_std/haxe/Resource.hx",38)
		return null();
	}
	HX_SOURCE_POS("C:\\Motion-Twin\\haxe/std/cpp/_std/haxe/Resource.hx",39)
	return ::haxe::io::Bytes_obj::ofData(array);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Resource_obj,getBytes,return )


Resource_obj::Resource_obj()
{
}

void Resource_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Resource);
	HX_MARK_END_CLASS();
}

Dynamic Resource_obj::__Field(const ::String &inName)
{
	switch(inName.length) {
	case 8:
		if (HX_FIELD_EQ(inName,"getBytes") ) { return getBytes_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"listNames") ) { return listNames_dyn(); }
		if (HX_FIELD_EQ(inName,"getString") ) { return getString_dyn(); }
	}
	return super::__Field(inName);
}

Dynamic Resource_obj::__SetField(const ::String &inName,const Dynamic &inValue)
{
	return super::__SetField(inName,inValue);
}

void Resource_obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("listNames"),
	HX_CSTRING("getString"),
	HX_CSTRING("getBytes"),
	String(null()) };

static ::String sMemberFields[] = {
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
};

Class Resource_obj::__mClass;

void Resource_obj::__register()
{
	Static(__mClass) = hx::RegisterClass(HX_CSTRING("haxe.Resource"), hx::TCanCast< Resource_obj> ,sStaticFields,sMemberFields,
	&__CreateEmpty, &__Create,
	&super::__SGetClass(), 0, sMarkStatics);
}

void Resource_obj::__boot()
{
}

} // end namespace haxe
