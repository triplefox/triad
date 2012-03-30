#include <hxcpp.h>

#ifndef INCLUDED_AssetReloading
#include <AssetReloading.h>
#endif
#ifndef INCLUDED_Lambda
#include <Lambda.h>
#endif
#ifndef INCLUDED_List
#include <List.h>
#endif
#ifndef INCLUDED_com_ludamix_triad_AssetCache
#include <com/ludamix/triad/AssetCache.h>
#endif
#ifndef INCLUDED_haxe_Log
#include <haxe/Log.h>
#endif

Void AssetReloading_obj::__construct()
{
{
	HX_SOURCE_POS("Source/AssetReloading.hx",7)
	::com::ludamix::triad::AssetCache_obj::initPoll(this->onChange_dyn(),HX_CSTRING("assets"),HX_CSTRING("../../../../Assets"));
}
;
	return null();
}

AssetReloading_obj::~AssetReloading_obj() { }

Dynamic AssetReloading_obj::__CreateEmpty() { return  new AssetReloading_obj; }
hx::ObjectPtr< AssetReloading_obj > AssetReloading_obj::__new()
{  hx::ObjectPtr< AssetReloading_obj > result = new AssetReloading_obj();
	result->__construct();
	return result;}

Dynamic AssetReloading_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< AssetReloading_obj > result = new AssetReloading_obj();
	result->__construct();
	return result;}

Void AssetReloading_obj::onChange( Dynamic change){
{
		HX_SOURCE_PUSH("AssetReloading_obj::onChange")

		HX_BEGIN_LOCAL_FUNC_S0(hx::LocalFunc,_Function_1_1)
		::String run(Dynamic a){
{
				HX_SOURCE_POS("Source/AssetReloading.hx",13)
				return a->__Field(HX_CSTRING("id"));
			}
			return null();
		}
		HX_END_LOCAL_FUNC1(return)

		HX_SOURCE_POS("Source/AssetReloading.hx",12)
		::haxe::Log_obj::trace(::Lambda_obj::map(change, Dynamic(new _Function_1_1())),hx::SourceInfo(HX_CSTRING("AssetReloading.hx"),13,HX_CSTRING("AssetReloading"),HX_CSTRING("onChange")));
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(AssetReloading_obj,onChange,(void))


AssetReloading_obj::AssetReloading_obj()
{
}

void AssetReloading_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(AssetReloading);
	HX_MARK_END_CLASS();
}

Dynamic AssetReloading_obj::__Field(const ::String &inName)
{
	switch(inName.length) {
	case 8:
		if (HX_FIELD_EQ(inName,"onChange") ) { return onChange_dyn(); }
	}
	return super::__Field(inName);
}

Dynamic AssetReloading_obj::__SetField(const ::String &inName,const Dynamic &inValue)
{
	return super::__SetField(inName,inValue);
}

void AssetReloading_obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

static ::String sMemberFields[] = {
	HX_CSTRING("onChange"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
};

Class AssetReloading_obj::__mClass;

void AssetReloading_obj::__register()
{
	Static(__mClass) = hx::RegisterClass(HX_CSTRING("AssetReloading"), hx::TCanCast< AssetReloading_obj> ,sStaticFields,sMemberFields,
	&__CreateEmpty, &__Create,
	&super::__SGetClass(), 0, sMarkStatics);
}

void AssetReloading_obj::__boot()
{
}

