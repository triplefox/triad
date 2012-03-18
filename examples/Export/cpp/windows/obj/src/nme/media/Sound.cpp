#include <hxcpp.h>

#ifndef INCLUDED_nme_Loader
#include <nme/Loader.h>
#endif
#ifndef INCLUDED_nme_events_ErrorEvent
#include <nme/events/ErrorEvent.h>
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
#ifndef INCLUDED_nme_events_IOErrorEvent
#include <nme/events/IOErrorEvent.h>
#endif
#ifndef INCLUDED_nme_events_TextEvent
#include <nme/events/TextEvent.h>
#endif
#ifndef INCLUDED_nme_media_ID3Info
#include <nme/media/ID3Info.h>
#endif
#ifndef INCLUDED_nme_media_Sound
#include <nme/media/Sound.h>
#endif
#ifndef INCLUDED_nme_media_SoundChannel
#include <nme/media/SoundChannel.h>
#endif
#ifndef INCLUDED_nme_media_SoundLoaderContext
#include <nme/media/SoundLoaderContext.h>
#endif
#ifndef INCLUDED_nme_media_SoundTransform
#include <nme/media/SoundTransform.h>
#endif
#ifndef INCLUDED_nme_net_URLRequest
#include <nme/net/URLRequest.h>
#endif
namespace nme{
namespace media{

Void Sound_obj::__construct(::nme::net::URLRequest stream,::nme::media::SoundLoaderContext context,Dynamic __o_forcePlayAsMusic)
{
bool forcePlayAsMusic = __o_forcePlayAsMusic.Default(false);
{
	HX_SOURCE_POS("C:\\Motion-Twin\\haxe\\lib\\nme/3,2,0/nme/media/Sound.hx",27)
	super::__construct(null());
	HX_SOURCE_POS("C:\\Motion-Twin\\haxe\\lib\\nme/3,2,0/nme/media/Sound.hx",28)
	this->bytesLoaded = this->bytesTotal = (int)0;
	HX_SOURCE_POS("C:\\Motion-Twin\\haxe\\lib\\nme/3,2,0/nme/media/Sound.hx",29)
	this->nmeLoading = false;
	HX_SOURCE_POS("C:\\Motion-Twin\\haxe\\lib\\nme/3,2,0/nme/media/Sound.hx",30)
	if (((stream != null()))){
		HX_SOURCE_POS("C:\\Motion-Twin\\haxe\\lib\\nme/3,2,0/nme/media/Sound.hx",31)
		this->load(stream,context,forcePlayAsMusic);
	}
}
;
	return null();
}

Sound_obj::~Sound_obj() { }

Dynamic Sound_obj::__CreateEmpty() { return  new Sound_obj; }
hx::ObjectPtr< Sound_obj > Sound_obj::__new(::nme::net::URLRequest stream,::nme::media::SoundLoaderContext context,Dynamic __o_forcePlayAsMusic)
{  hx::ObjectPtr< Sound_obj > result = new Sound_obj();
	result->__construct(stream,context,__o_forcePlayAsMusic);
	return result;}

Dynamic Sound_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Sound_obj > result = new Sound_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2]);
	return result;}

Void Sound_obj::close( ){
{
		HX_SOURCE_PUSH("Sound_obj::close")
		HX_SOURCE_POS("C:\\Motion-Twin\\haxe\\lib\\nme/3,2,0/nme/media/Sound.hx",37)
		if (((this->nmeHandle != null()))){
			HX_SOURCE_POS("C:\\Motion-Twin\\haxe\\lib\\nme/3,2,0/nme/media/Sound.hx",38)
			::nme::media::Sound_obj::nme_sound_close(this->nmeHandle);
		}
		HX_SOURCE_POS("C:\\Motion-Twin\\haxe\\lib\\nme/3,2,0/nme/media/Sound.hx",39)
		this->nmeHandle = (int)0;
		HX_SOURCE_POS("C:\\Motion-Twin\\haxe\\lib\\nme/3,2,0/nme/media/Sound.hx",40)
		this->nmeLoading = false;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Sound_obj,close,(void))

Void Sound_obj::load( ::nme::net::URLRequest stream,::nme::media::SoundLoaderContext context,Dynamic __o_forcePlayAsMusic){
bool forcePlayAsMusic = __o_forcePlayAsMusic.Default(false);
	HX_SOURCE_PUSH("Sound_obj::load");
{
		HX_SOURCE_POS("C:\\Motion-Twin\\haxe\\lib\\nme/3,2,0/nme/media/Sound.hx",46)
		this->bytesLoaded = this->bytesTotal = (int)0;
		HX_SOURCE_POS("C:\\Motion-Twin\\haxe\\lib\\nme/3,2,0/nme/media/Sound.hx",47)
		this->nmeHandle = ::nme::media::Sound_obj::nme_sound_from_file(stream->url,forcePlayAsMusic);
		HX_SOURCE_POS("C:\\Motion-Twin\\haxe\\lib\\nme/3,2,0/nme/media/Sound.hx",48)
		if (((this->nmeHandle == null()))){
			HX_SOURCE_POS("C:\\Motion-Twin\\haxe\\lib\\nme/3,2,0/nme/media/Sound.hx",49)
			hx::Throw ((HX_CSTRING("Could not load:") + stream->url));
		}
		else{
			HX_SOURCE_POS("C:\\Motion-Twin\\haxe\\lib\\nme/3,2,0/nme/media/Sound.hx",54)
			this->nmeLoading = true;
			HX_SOURCE_POS("C:\\Motion-Twin\\haxe\\lib\\nme/3,2,0/nme/media/Sound.hx",55)
			this->nmeLoading = false;
			HX_SOURCE_POS("C:\\Motion-Twin\\haxe\\lib\\nme/3,2,0/nme/media/Sound.hx",56)
			this->nmeCheckLoading();
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC3(Sound_obj,load,(void))

Void Sound_obj::nmeCheckLoading( ){
{
		HX_SOURCE_PUSH("Sound_obj::nmeCheckLoading")
		HX_SOURCE_POS("C:\\Motion-Twin\\haxe\\lib\\nme/3,2,0/nme/media/Sound.hx",62)
		if (((bool(this->nmeLoading) && bool((this->nmeHandle != null()))))){
			HX_SOURCE_POS("C:\\Motion-Twin\\haxe\\lib\\nme/3,2,0/nme/media/Sound.hx",65)
			Dynamic status = ::nme::media::Sound_obj::nme_sound_get_status(this->nmeHandle);
			HX_SOURCE_POS("C:\\Motion-Twin\\haxe\\lib\\nme/3,2,0/nme/media/Sound.hx",66)
			if (((status == null()))){
				HX_SOURCE_POS("C:\\Motion-Twin\\haxe\\lib\\nme/3,2,0/nme/media/Sound.hx",67)
				hx::Throw (HX_CSTRING("Could not get sound status"));
			}
			HX_SOURCE_POS("C:\\Motion-Twin\\haxe\\lib\\nme/3,2,0/nme/media/Sound.hx",68)
			this->bytesLoaded = status->__Field(HX_CSTRING("bytesLoaded"));
			HX_SOURCE_POS("C:\\Motion-Twin\\haxe\\lib\\nme/3,2,0/nme/media/Sound.hx",69)
			this->bytesTotal = status->__Field(HX_CSTRING("bytesTotal"));
			HX_SOURCE_POS("C:\\Motion-Twin\\haxe\\lib\\nme/3,2,0/nme/media/Sound.hx",70)
			this->nmeLoading = (this->bytesLoaded < this->bytesTotal);
			HX_SOURCE_POS("C:\\Motion-Twin\\haxe\\lib\\nme/3,2,0/nme/media/Sound.hx",71)
			if (((status->__Field(HX_CSTRING("error")) != null()))){
				HX_SOURCE_POS("C:\\Motion-Twin\\haxe\\lib\\nme/3,2,0/nme/media/Sound.hx",72)
				hx::Throw (status->__Field(HX_CSTRING("error")));
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Sound_obj,nmeCheckLoading,(void))

Void Sound_obj::nmeOnError( ::String msg){
{
		HX_SOURCE_PUSH("Sound_obj::nmeOnError")
		HX_SOURCE_POS("C:\\Motion-Twin\\haxe\\lib\\nme/3,2,0/nme/media/Sound.hx",81)
		this->dispatchEvent(::nme::events::IOErrorEvent_obj::__new(::nme::events::IOErrorEvent_obj::IO_ERROR,true,false,msg,null()));
		HX_SOURCE_POS("C:\\Motion-Twin\\haxe\\lib\\nme/3,2,0/nme/media/Sound.hx",82)
		this->nmeHandle = null();
		HX_SOURCE_POS("C:\\Motion-Twin\\haxe\\lib\\nme/3,2,0/nme/media/Sound.hx",83)
		this->nmeLoading = true;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Sound_obj,nmeOnError,(void))

::nme::media::SoundChannel Sound_obj::play( Dynamic __o_startTime,Dynamic __o_loops,::nme::media::SoundTransform sndTransform){
double startTime = __o_startTime.Default(0);
int loops = __o_loops.Default(0);
	HX_SOURCE_PUSH("Sound_obj::play");
{
		HX_SOURCE_POS("C:\\Motion-Twin\\haxe\\lib\\nme/3,2,0/nme/media/Sound.hx",89)
		this->nmeCheckLoading();
		HX_SOURCE_POS("C:\\Motion-Twin\\haxe\\lib\\nme/3,2,0/nme/media/Sound.hx",90)
		if (((bool((this->nmeHandle == null())) || bool(this->nmeLoading)))){
			HX_SOURCE_POS("C:\\Motion-Twin\\haxe\\lib\\nme/3,2,0/nme/media/Sound.hx",91)
			return null();
		}
		HX_SOURCE_POS("C:\\Motion-Twin\\haxe\\lib\\nme/3,2,0/nme/media/Sound.hx",94)
		return ::nme::media::SoundChannel_obj::__new(this->nmeHandle,startTime,loops,sndTransform);
	}
}


HX_DEFINE_DYNAMIC_FUNC3(Sound_obj,play,return )

::nme::media::ID3Info Sound_obj::nmeGetID3( ){
	HX_SOURCE_PUSH("Sound_obj::nmeGetID3")
	HX_SOURCE_POS("C:\\Motion-Twin\\haxe\\lib\\nme/3,2,0/nme/media/Sound.hx",105)
	this->nmeCheckLoading();
	HX_SOURCE_POS("C:\\Motion-Twin\\haxe\\lib\\nme/3,2,0/nme/media/Sound.hx",106)
	if (((bool((this->nmeHandle == null())) || bool(this->nmeLoading)))){
		HX_SOURCE_POS("C:\\Motion-Twin\\haxe\\lib\\nme/3,2,0/nme/media/Sound.hx",107)
		return null();
	}
	HX_SOURCE_POS("C:\\Motion-Twin\\haxe\\lib\\nme/3,2,0/nme/media/Sound.hx",108)
	::nme::media::ID3Info id3 = ::nme::media::ID3Info_obj::__new();
	HX_SOURCE_POS("C:\\Motion-Twin\\haxe\\lib\\nme/3,2,0/nme/media/Sound.hx",109)
	::nme::media::Sound_obj::nme_sound_get_id3(this->nmeHandle,id3);
	HX_SOURCE_POS("C:\\Motion-Twin\\haxe\\lib\\nme/3,2,0/nme/media/Sound.hx",110)
	return id3;
}


HX_DEFINE_DYNAMIC_FUNC0(Sound_obj,nmeGetID3,return )

bool Sound_obj::nmeGetIsBuffering( ){
	HX_SOURCE_PUSH("Sound_obj::nmeGetIsBuffering")
	HX_SOURCE_POS("C:\\Motion-Twin\\haxe\\lib\\nme/3,2,0/nme/media/Sound.hx",116)
	this->nmeCheckLoading();
	HX_SOURCE_POS("C:\\Motion-Twin\\haxe\\lib\\nme/3,2,0/nme/media/Sound.hx",117)
	return (bool(this->nmeLoading) && bool((this->nmeHandle == null())));
}


HX_DEFINE_DYNAMIC_FUNC0(Sound_obj,nmeGetIsBuffering,return )

double Sound_obj::nmeGetLength( ){
	HX_SOURCE_PUSH("Sound_obj::nmeGetLength")
	HX_SOURCE_POS("C:\\Motion-Twin\\haxe\\lib\\nme/3,2,0/nme/media/Sound.hx",123)
	if (((bool((this->nmeHandle == null())) || bool(this->nmeLoading)))){
		HX_SOURCE_POS("C:\\Motion-Twin\\haxe\\lib\\nme/3,2,0/nme/media/Sound.hx",124)
		return (int)0;
	}
	HX_SOURCE_POS("C:\\Motion-Twin\\haxe\\lib\\nme/3,2,0/nme/media/Sound.hx",125)
	return ::nme::media::Sound_obj::nme_sound_get_length(this->nmeHandle);
}


HX_DEFINE_DYNAMIC_FUNC0(Sound_obj,nmeGetLength,return )

Dynamic Sound_obj::nme_sound_from_file;

Dynamic Sound_obj::nme_sound_get_id3;

Dynamic Sound_obj::nme_sound_get_length;

Dynamic Sound_obj::nme_sound_close;

Dynamic Sound_obj::nme_sound_get_status;


Sound_obj::Sound_obj()
{
}

void Sound_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Sound);
	HX_MARK_MEMBER_NAME(bytesLoaded,"bytesLoaded");
	HX_MARK_MEMBER_NAME(bytesTotal,"bytesTotal");
	HX_MARK_MEMBER_NAME(id3,"id3");
	HX_MARK_MEMBER_NAME(isBuffering,"isBuffering");
	HX_MARK_MEMBER_NAME(length,"length");
	HX_MARK_MEMBER_NAME(url,"url");
	HX_MARK_MEMBER_NAME(nmeHandle,"nmeHandle");
	HX_MARK_MEMBER_NAME(nmeLoading,"nmeLoading");
	super::__Mark(HX_MARK_ARG);
	HX_MARK_END_CLASS();
}

Dynamic Sound_obj::__Field(const ::String &inName)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"id3") ) { return nmeGetID3(); }
		if (HX_FIELD_EQ(inName,"url") ) { return url; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"load") ) { return load_dyn(); }
		if (HX_FIELD_EQ(inName,"play") ) { return play_dyn(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"close") ) { return close_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"length") ) { return nmeGetLength(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"nmeHandle") ) { return nmeHandle; }
		if (HX_FIELD_EQ(inName,"nmeGetID3") ) { return nmeGetID3_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"bytesTotal") ) { return bytesTotal; }
		if (HX_FIELD_EQ(inName,"nmeLoading") ) { return nmeLoading; }
		if (HX_FIELD_EQ(inName,"nmeOnError") ) { return nmeOnError_dyn(); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"bytesLoaded") ) { return bytesLoaded; }
		if (HX_FIELD_EQ(inName,"isBuffering") ) { return nmeGetIsBuffering(); }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"nmeGetLength") ) { return nmeGetLength_dyn(); }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"nme_sound_close") ) { return nme_sound_close; }
		if (HX_FIELD_EQ(inName,"nmeCheckLoading") ) { return nmeCheckLoading_dyn(); }
		break;
	case 17:
		if (HX_FIELD_EQ(inName,"nme_sound_get_id3") ) { return nme_sound_get_id3; }
		if (HX_FIELD_EQ(inName,"nmeGetIsBuffering") ) { return nmeGetIsBuffering_dyn(); }
		break;
	case 19:
		if (HX_FIELD_EQ(inName,"nme_sound_from_file") ) { return nme_sound_from_file; }
		break;
	case 20:
		if (HX_FIELD_EQ(inName,"nme_sound_get_length") ) { return nme_sound_get_length; }
		if (HX_FIELD_EQ(inName,"nme_sound_get_status") ) { return nme_sound_get_status; }
	}
	return super::__Field(inName);
}

Dynamic Sound_obj::__SetField(const ::String &inName,const Dynamic &inValue)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"id3") ) { id3=inValue.Cast< ::nme::media::ID3Info >(); return inValue; }
		if (HX_FIELD_EQ(inName,"url") ) { url=inValue.Cast< ::String >(); return inValue; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"length") ) { length=inValue.Cast< double >(); return inValue; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"nmeHandle") ) { nmeHandle=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"bytesTotal") ) { bytesTotal=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"nmeLoading") ) { nmeLoading=inValue.Cast< bool >(); return inValue; }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"bytesLoaded") ) { bytesLoaded=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"isBuffering") ) { isBuffering=inValue.Cast< bool >(); return inValue; }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"nme_sound_close") ) { nme_sound_close=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 17:
		if (HX_FIELD_EQ(inName,"nme_sound_get_id3") ) { nme_sound_get_id3=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 19:
		if (HX_FIELD_EQ(inName,"nme_sound_from_file") ) { nme_sound_from_file=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 20:
		if (HX_FIELD_EQ(inName,"nme_sound_get_length") ) { nme_sound_get_length=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"nme_sound_get_status") ) { nme_sound_get_status=inValue.Cast< Dynamic >(); return inValue; }
	}
	return super::__SetField(inName,inValue);
}

void Sound_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("bytesLoaded"));
	outFields->push(HX_CSTRING("bytesTotal"));
	outFields->push(HX_CSTRING("id3"));
	outFields->push(HX_CSTRING("isBuffering"));
	outFields->push(HX_CSTRING("length"));
	outFields->push(HX_CSTRING("url"));
	outFields->push(HX_CSTRING("nmeHandle"));
	outFields->push(HX_CSTRING("nmeLoading"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("nme_sound_from_file"),
	HX_CSTRING("nme_sound_get_id3"),
	HX_CSTRING("nme_sound_get_length"),
	HX_CSTRING("nme_sound_close"),
	HX_CSTRING("nme_sound_get_status"),
	String(null()) };

static ::String sMemberFields[] = {
	HX_CSTRING("bytesLoaded"),
	HX_CSTRING("bytesTotal"),
	HX_CSTRING("id3"),
	HX_CSTRING("isBuffering"),
	HX_CSTRING("length"),
	HX_CSTRING("url"),
	HX_CSTRING("nmeHandle"),
	HX_CSTRING("nmeLoading"),
	HX_CSTRING("close"),
	HX_CSTRING("load"),
	HX_CSTRING("nmeCheckLoading"),
	HX_CSTRING("nmeOnError"),
	HX_CSTRING("play"),
	HX_CSTRING("nmeGetID3"),
	HX_CSTRING("nmeGetIsBuffering"),
	HX_CSTRING("nmeGetLength"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Sound_obj::nme_sound_from_file,"nme_sound_from_file");
	HX_MARK_MEMBER_NAME(Sound_obj::nme_sound_get_id3,"nme_sound_get_id3");
	HX_MARK_MEMBER_NAME(Sound_obj::nme_sound_get_length,"nme_sound_get_length");
	HX_MARK_MEMBER_NAME(Sound_obj::nme_sound_close,"nme_sound_close");
	HX_MARK_MEMBER_NAME(Sound_obj::nme_sound_get_status,"nme_sound_get_status");
};

Class Sound_obj::__mClass;

void Sound_obj::__register()
{
	Static(__mClass) = hx::RegisterClass(HX_CSTRING("nme.media.Sound"), hx::TCanCast< Sound_obj> ,sStaticFields,sMemberFields,
	&__CreateEmpty, &__Create,
	&super::__SGetClass(), 0, sMarkStatics);
}

void Sound_obj::__boot()
{
	hx::Static(nme_sound_from_file) = ::nme::Loader_obj::load(HX_CSTRING("nme_sound_from_file"),(int)2);
	hx::Static(nme_sound_get_id3) = ::nme::Loader_obj::load(HX_CSTRING("nme_sound_get_id3"),(int)2);
	hx::Static(nme_sound_get_length) = ::nme::Loader_obj::load(HX_CSTRING("nme_sound_get_length"),(int)1);
	hx::Static(nme_sound_close) = ::nme::Loader_obj::load(HX_CSTRING("nme_sound_close"),(int)1);
	hx::Static(nme_sound_get_status) = ::nme::Loader_obj::load(HX_CSTRING("nme_sound_get_status"),(int)1);
}

} // end namespace nme
} // end namespace media
