#include <hxcpp.h>

#ifndef INCLUDED_Date
#include <Date.h>
#endif
#ifndef INCLUDED_Hash
#include <Hash.h>
#endif
#ifndef INCLUDED_Reflect
#include <Reflect.h>
#endif
#ifndef INCLUDED_StringTools
#include <StringTools.h>
#endif
#ifndef INCLUDED_com_ludamix_triad_AssetCache
#include <com/ludamix/triad/AssetCache.h>
#endif
#ifndef INCLUDED_cpp_FileSystem
#include <cpp/FileSystem.h>
#endif
#ifndef INCLUDED_haxe_io_Bytes
#include <haxe/io/Bytes.h>
#endif
#ifndef INCLUDED_nme_display_BitmapData
#include <nme/display/BitmapData.h>
#endif
#ifndef INCLUDED_nme_display_IBitmapDrawable
#include <nme/display/IBitmapDrawable.h>
#endif
#ifndef INCLUDED_nme_events_Event
#include <nme/events/Event.h>
#endif
#ifndef INCLUDED_nme_events_EventDispatcher
#include <nme/events/EventDispatcher.h>
#endif
#ifndef INCLUDED_nme_events_IEventDispatcher
#include <nme/events/IEventDispatcher.h>
#endif
#ifndef INCLUDED_nme_events_TimerEvent
#include <nme/events/TimerEvent.h>
#endif
#ifndef INCLUDED_nme_installer_Assets
#include <nme/installer/Assets.h>
#endif
#ifndef INCLUDED_nme_media_Sound
#include <nme/media/Sound.h>
#endif
#ifndef INCLUDED_nme_text_Font
#include <nme/text/Font.h>
#endif
#ifndef INCLUDED_nme_utils_ByteArray
#include <nme/utils/ByteArray.h>
#endif
#ifndef INCLUDED_nme_utils_IDataInput
#include <nme/utils/IDataInput.h>
#endif
#ifndef INCLUDED_nme_utils_Timer
#include <nme/utils/Timer.h>
#endif
namespace com{
namespace ludamix{
namespace triad{

Void AssetCache_obj::__construct()
{
	return null();
}

AssetCache_obj::~AssetCache_obj() { }

Dynamic AssetCache_obj::__CreateEmpty() { return  new AssetCache_obj; }
hx::ObjectPtr< AssetCache_obj > AssetCache_obj::__new()
{  hx::ObjectPtr< AssetCache_obj > result = new AssetCache_obj();
	result->__construct();
	return result;}

Dynamic AssetCache_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< AssetCache_obj > result = new AssetCache_obj();
	result->__construct();
	return result;}

::nme::utils::Timer AssetCache_obj::t;

::Hash AssetCache_obj::statCache;

Dynamic AssetCache_obj::onChange;

::Hash AssetCache_obj::resourceNames;

::Hash AssetCache_obj::resourceTypes;

Void AssetCache_obj::initPoll( Dynamic onChange,::String src_pathname,::String rename_pathname){
{
		HX_SOURCE_PUSH("AssetCache_obj::initPoll")
		HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/AssetCache.hx",46)
		::Reflect_obj::field(hx::ClassOf< ::nme::installer::Assets >(),HX_CSTRING("initialize"))();
		HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/AssetCache.hx",47)
		::com::ludamix::triad::AssetCache_obj::resourceNames = ::Reflect_obj::field(hx::ClassOf< ::nme::installer::Assets >(),HX_CSTRING("resourceNames"));
		HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/AssetCache.hx",48)
		::com::ludamix::triad::AssetCache_obj::resourceTypes = ::Reflect_obj::field(hx::ClassOf< ::nme::installer::Assets >(),HX_CSTRING("resourceTypes"));
		HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/AssetCache.hx",49)
		::com::ludamix::triad::AssetCache_obj::onChange = onChange;
		HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/AssetCache.hx",50)
		::com::ludamix::triad::AssetCache_obj::t = ::nme::utils::Timer_obj::__new((int)100,null());
		HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/AssetCache.hx",51)
		::com::ludamix::triad::AssetCache_obj::t->addEventListener(::nme::events::TimerEvent_obj::TIMER,::com::ludamix::triad::AssetCache_obj::doPoll_dyn(),null(),null(),null());
		HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/AssetCache.hx",52)
		::com::ludamix::triad::AssetCache_obj::t->start();
		HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/AssetCache.hx",53)
		::com::ludamix::triad::AssetCache_obj::statCache = ::Hash_obj::__new();
		HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/AssetCache.hx",54)
		for(::cpp::FastIterator_obj< ::String > *__it = ::cpp::CreateFastIterator< ::String >(::com::ludamix::triad::AssetCache_obj::resourceNames->keys());  __it->hasNext(); ){
			::String id = __it->next();
			{
				HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/AssetCache.hx",56)
				::String path = ::com::ludamix::triad::AssetCache_obj::resourceNames->get(id);
				HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/AssetCache.hx",57)
				path = ::StringTools_obj::replace(path,src_pathname,rename_pathname);
				HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/AssetCache.hx",58)
				::com::ludamix::triad::AssetCache_obj::resourceNames->set(id,path);
				struct _Function_2_1{
					inline static Dynamic Block( ::String &id,::String &path){
						hx::Anon __result = hx::Anon_obj::Create();
						__result->Add(HX_CSTRING("id") , id,false);
						__result->Add(HX_CSTRING("path") , path,false);
						__result->Add(HX_CSTRING("type") , ::com::ludamix::triad::AssetCache_obj::resourceTypes->get(id),false);
						__result->Add(HX_CSTRING("stat") , ::cpp::FileSystem_obj::stat(path),false);
						return __result;
					}
				};
				HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/AssetCache.hx",59)
				::com::ludamix::triad::AssetCache_obj::statCache->set(id,_Function_2_1::Block(id,path));
			}
;
		}
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(AssetCache_obj,initPoll,(void))

Void AssetCache_obj::doPoll( Dynamic _){
{
		HX_SOURCE_PUSH("AssetCache_obj::doPoll")
		HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/AssetCache.hx",65)
		Dynamic change = Dynamic( Array_obj<Dynamic>::__new() );
		HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/AssetCache.hx",66)
		for(::cpp::FastIterator_obj< Dynamic > *__it = ::cpp::CreateFastIterator< Dynamic >(::com::ludamix::triad::AssetCache_obj::statCache->iterator());  __it->hasNext(); ){
			Dynamic n = __it->next();
			{
				HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/AssetCache.hx",68)
				Dynamic check = ::cpp::FileSystem_obj::stat(n->__Field(HX_CSTRING("path")));
				HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/AssetCache.hx",69)
				if (((check->__Field(HX_CSTRING("mtime"))->__Field(HX_CSTRING("getTime"))() != n->__Field(HX_CSTRING("stat"))->__Field(HX_CSTRING("mtime"))->__Field(HX_CSTRING("getTime"))()))){
					HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/AssetCache.hx",70)
					n->__FieldRef(HX_CSTRING("stat")) = check;
					HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/AssetCache.hx",70)
					change->__Field(HX_CSTRING("push"))(n);
				}
			}
;
		}
		HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/AssetCache.hx",72)
		if (((change->__Field(HX_CSTRING("length")) > (int)0))){
			HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/AssetCache.hx",72)
			::com::ludamix::triad::AssetCache_obj::onChange(change);
		}
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(AssetCache_obj,doPoll,(void))

::String AssetCache_obj::getText( ::String id){
	HX_SOURCE_PUSH("AssetCache_obj::getText")
	HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/AssetCache.hx",77)
	return ::nme::installer::Assets_obj::getText(id);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(AssetCache_obj,getText,return )

::nme::display::BitmapData AssetCache_obj::getBitmapData( ::String id,Dynamic __o_useCache){
bool useCache = __o_useCache.Default(true);
	HX_SOURCE_PUSH("AssetCache_obj::getBitmapData");
{
		HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/AssetCache.hx",82)
		return ::nme::installer::Assets_obj::getBitmapData(id,false);
	}
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(AssetCache_obj,getBitmapData,return )

::nme::utils::ByteArray AssetCache_obj::getBytes( ::String id){
	HX_SOURCE_PUSH("AssetCache_obj::getBytes")
	HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/AssetCache.hx",87)
	return ::nme::installer::Assets_obj::getBytes(id);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(AssetCache_obj,getBytes,return )

::nme::text::Font AssetCache_obj::getFont( ::String id){
	HX_SOURCE_PUSH("AssetCache_obj::getFont")
	HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/AssetCache.hx",92)
	return ::nme::installer::Assets_obj::getFont(id);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(AssetCache_obj,getFont,return )

::nme::media::Sound AssetCache_obj::getSound( ::String id){
	HX_SOURCE_PUSH("AssetCache_obj::getSound")
	HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/AssetCache.hx",97)
	return ::nme::installer::Assets_obj::getSound(id);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(AssetCache_obj,getSound,return )


AssetCache_obj::AssetCache_obj()
{
}

void AssetCache_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(AssetCache);
	HX_MARK_END_CLASS();
}

Dynamic AssetCache_obj::__Field(const ::String &inName)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"t") ) { return t; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"doPoll") ) { return doPoll_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"getText") ) { return getText_dyn(); }
		if (HX_FIELD_EQ(inName,"getFont") ) { return getFont_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"onChange") ) { return onChange; }
		if (HX_FIELD_EQ(inName,"initPoll") ) { return initPoll_dyn(); }
		if (HX_FIELD_EQ(inName,"getBytes") ) { return getBytes_dyn(); }
		if (HX_FIELD_EQ(inName,"getSound") ) { return getSound_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"statCache") ) { return statCache; }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"resourceNames") ) { return resourceNames; }
		if (HX_FIELD_EQ(inName,"resourceTypes") ) { return resourceTypes; }
		if (HX_FIELD_EQ(inName,"getBitmapData") ) { return getBitmapData_dyn(); }
	}
	return super::__Field(inName);
}

Dynamic AssetCache_obj::__SetField(const ::String &inName,const Dynamic &inValue)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"t") ) { t=inValue.Cast< ::nme::utils::Timer >(); return inValue; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"onChange") ) { onChange=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"statCache") ) { statCache=inValue.Cast< ::Hash >(); return inValue; }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"resourceNames") ) { resourceNames=inValue.Cast< ::Hash >(); return inValue; }
		if (HX_FIELD_EQ(inName,"resourceTypes") ) { resourceTypes=inValue.Cast< ::Hash >(); return inValue; }
	}
	return super::__SetField(inName,inValue);
}

void AssetCache_obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("t"),
	HX_CSTRING("statCache"),
	HX_CSTRING("onChange"),
	HX_CSTRING("resourceNames"),
	HX_CSTRING("resourceTypes"),
	HX_CSTRING("initPoll"),
	HX_CSTRING("doPoll"),
	HX_CSTRING("getText"),
	HX_CSTRING("getBitmapData"),
	HX_CSTRING("getBytes"),
	HX_CSTRING("getFont"),
	HX_CSTRING("getSound"),
	String(null()) };

static ::String sMemberFields[] = {
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(AssetCache_obj::t,"t");
	HX_MARK_MEMBER_NAME(AssetCache_obj::statCache,"statCache");
	HX_MARK_MEMBER_NAME(AssetCache_obj::onChange,"onChange");
	HX_MARK_MEMBER_NAME(AssetCache_obj::resourceNames,"resourceNames");
	HX_MARK_MEMBER_NAME(AssetCache_obj::resourceTypes,"resourceTypes");
};

Class AssetCache_obj::__mClass;

void AssetCache_obj::__register()
{
	Static(__mClass) = hx::RegisterClass(HX_CSTRING("com.ludamix.triad.AssetCache"), hx::TCanCast< AssetCache_obj> ,sStaticFields,sMemberFields,
	&__CreateEmpty, &__Create,
	&super::__SGetClass(), 0, sMarkStatics);
}

void AssetCache_obj::__boot()
{
	hx::Static(t);
	hx::Static(statCache);
	hx::Static(onChange);
	hx::Static(resourceNames);
	hx::Static(resourceTypes);
}

} // end namespace com
} // end namespace ludamix
} // end namespace triad
