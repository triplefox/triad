#include <hxcpp.h>

#ifndef INCLUDED_ApplicationMain
#include <ApplicationMain.h>
#endif
#ifndef INCLUDED_Main
#include <Main.h>
#endif
#ifndef INCLUDED_nme_Lib
#include <nme/Lib.h>
#endif
#ifndef INCLUDED_nme_display_BitmapData
#include <nme/display/BitmapData.h>
#endif
#ifndef INCLUDED_nme_display_IBitmapDrawable
#include <nme/display/IBitmapDrawable.h>
#endif
#ifndef INCLUDED_nme_installer_Assets
#include <nme/installer/Assets.h>
#endif

Void ApplicationMain_obj::__construct()
{
	return null();
}

ApplicationMain_obj::~ApplicationMain_obj() { }

Dynamic ApplicationMain_obj::__CreateEmpty() { return  new ApplicationMain_obj; }
hx::ObjectPtr< ApplicationMain_obj > ApplicationMain_obj::__new()
{  hx::ObjectPtr< ApplicationMain_obj > result = new ApplicationMain_obj();
	result->__construct();
	return result;}

Dynamic ApplicationMain_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< ApplicationMain_obj > result = new ApplicationMain_obj();
	result->__construct();
	return result;}

Void ApplicationMain_obj::main( ){
{
		HX_SOURCE_PUSH("ApplicationMain_obj::main")
		HX_SOURCE_POS("Export/cpp/windows/haxe/ApplicationMain.hx",14)
		::nme::Lib_obj::setPackage(HX_CSTRING("Ludamix"),HX_CSTRING("TriadNME"),HX_CSTRING("com.ludamix.triad.app"),HX_CSTRING("1.0.0"));

		HX_BEGIN_LOCAL_FUNC_S0(hx::LocalFunc,_Function_1_1)
		Void run(){
{
				HX_SOURCE_POS("Export/cpp/windows/haxe/ApplicationMain.hx",39)
				{
				}
				HX_SOURCE_POS("Export/cpp/windows/haxe/ApplicationMain.hx",45)
				::Main_obj::main();
			}
			return null();
		}
		HX_END_LOCAL_FUNC0((void))

		HX_SOURCE_POS("Export/cpp/windows/haxe/ApplicationMain.hx",37)
		::nme::Lib_obj::create( Dynamic(new _Function_1_1()),(int)512,(int)512,(int)60,(int)16777215,(int((int((int((int((int((int(::nme::Lib_obj::HARDWARE) | int(::nme::Lib_obj::RESIZABLE))) | int((int)0))) | int((int)0))) | int((int)0))) | int((int)0))) | int((int)0)),HX_CSTRING("TriadNME"),::ApplicationMain_obj::getAsset(HX_CSTRING("icon.png")));
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC0(ApplicationMain_obj,main,(void))

Dynamic ApplicationMain_obj::getAsset( ::String inName){
	HX_SOURCE_PUSH("ApplicationMain_obj::getAsset")
	HX_SOURCE_POS("Export/cpp/windows/haxe/ApplicationMain.hx",70)
	if (((inName == HX_CSTRING("assets/cards.png")))){
		HX_SOURCE_POS("Export/cpp/windows/haxe/ApplicationMain.hx",71)
		return ::nme::installer::Assets_obj::getBitmapData(HX_CSTRING("assets/cards.png"),null());
	}
	HX_SOURCE_POS("Export/cpp/windows/haxe/ApplicationMain.hx",77)
	if (((inName == HX_CSTRING("assets/frame.png")))){
		HX_SOURCE_POS("Export/cpp/windows/haxe/ApplicationMain.hx",78)
		return ::nme::installer::Assets_obj::getBitmapData(HX_CSTRING("assets/frame.png"),null());
	}
	HX_SOURCE_POS("Export/cpp/windows/haxe/ApplicationMain.hx",84)
	if (((inName == HX_CSTRING("assets/frame2.png")))){
		HX_SOURCE_POS("Export/cpp/windows/haxe/ApplicationMain.hx",85)
		return ::nme::installer::Assets_obj::getBitmapData(HX_CSTRING("assets/frame2.png"),null());
	}
	HX_SOURCE_POS("Export/cpp/windows/haxe/ApplicationMain.hx",91)
	if (((inName == HX_CSTRING("assets/slider.png")))){
		HX_SOURCE_POS("Export/cpp/windows/haxe/ApplicationMain.hx",92)
		return ::nme::installer::Assets_obj::getBitmapData(HX_CSTRING("assets/slider.png"),null());
	}
	HX_SOURCE_POS("Export/cpp/windows/haxe/ApplicationMain.hx",98)
	return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(ApplicationMain_obj,getAsset,return )


ApplicationMain_obj::ApplicationMain_obj()
{
}

void ApplicationMain_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(ApplicationMain);
	HX_MARK_END_CLASS();
}

Dynamic ApplicationMain_obj::__Field(const ::String &inName)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"main") ) { return main_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"getAsset") ) { return getAsset_dyn(); }
	}
	return super::__Field(inName);
}

Dynamic ApplicationMain_obj::__SetField(const ::String &inName,const Dynamic &inValue)
{
	return super::__SetField(inName,inValue);
}

void ApplicationMain_obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("main"),
	HX_CSTRING("getAsset"),
	String(null()) };

static ::String sMemberFields[] = {
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
};

Class ApplicationMain_obj::__mClass;

void ApplicationMain_obj::__register()
{
	Static(__mClass) = hx::RegisterClass(HX_CSTRING("ApplicationMain"), hx::TCanCast< ApplicationMain_obj> ,sStaticFields,sMemberFields,
	&__CreateEmpty, &__Create,
	&super::__SGetClass(), 0, sMarkStatics);
}

void ApplicationMain_obj::__boot()
{
}

