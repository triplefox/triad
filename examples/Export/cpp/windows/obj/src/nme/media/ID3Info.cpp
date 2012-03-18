#include <hxcpp.h>

#ifndef INCLUDED_nme_media_ID3Info
#include <nme/media/ID3Info.h>
#endif
namespace nme{
namespace media{

Void ID3Info_obj::__construct()
{
{
}
;
	return null();
}

ID3Info_obj::~ID3Info_obj() { }

Dynamic ID3Info_obj::__CreateEmpty() { return  new ID3Info_obj; }
hx::ObjectPtr< ID3Info_obj > ID3Info_obj::__new()
{  hx::ObjectPtr< ID3Info_obj > result = new ID3Info_obj();
	result->__construct();
	return result;}

Dynamic ID3Info_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< ID3Info_obj > result = new ID3Info_obj();
	result->__construct();
	return result;}


ID3Info_obj::ID3Info_obj()
{
}

void ID3Info_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(ID3Info);
	HX_MARK_MEMBER_NAME(album,"album");
	HX_MARK_MEMBER_NAME(artist,"artist");
	HX_MARK_MEMBER_NAME(comment,"comment");
	HX_MARK_MEMBER_NAME(genre,"genre");
	HX_MARK_MEMBER_NAME(songName,"songName");
	HX_MARK_MEMBER_NAME(track,"track");
	HX_MARK_MEMBER_NAME(year,"year");
	HX_MARK_END_CLASS();
}

Dynamic ID3Info_obj::__Field(const ::String &inName)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"year") ) { return year; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"album") ) { return album; }
		if (HX_FIELD_EQ(inName,"genre") ) { return genre; }
		if (HX_FIELD_EQ(inName,"track") ) { return track; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"artist") ) { return artist; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"comment") ) { return comment; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"songName") ) { return songName; }
	}
	return super::__Field(inName);
}

Dynamic ID3Info_obj::__SetField(const ::String &inName,const Dynamic &inValue)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"year") ) { year=inValue.Cast< ::String >(); return inValue; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"album") ) { album=inValue.Cast< ::String >(); return inValue; }
		if (HX_FIELD_EQ(inName,"genre") ) { genre=inValue.Cast< ::String >(); return inValue; }
		if (HX_FIELD_EQ(inName,"track") ) { track=inValue.Cast< ::String >(); return inValue; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"artist") ) { artist=inValue.Cast< ::String >(); return inValue; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"comment") ) { comment=inValue.Cast< ::String >(); return inValue; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"songName") ) { songName=inValue.Cast< ::String >(); return inValue; }
	}
	return super::__SetField(inName,inValue);
}

void ID3Info_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("album"));
	outFields->push(HX_CSTRING("artist"));
	outFields->push(HX_CSTRING("comment"));
	outFields->push(HX_CSTRING("genre"));
	outFields->push(HX_CSTRING("songName"));
	outFields->push(HX_CSTRING("track"));
	outFields->push(HX_CSTRING("year"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

static ::String sMemberFields[] = {
	HX_CSTRING("album"),
	HX_CSTRING("artist"),
	HX_CSTRING("comment"),
	HX_CSTRING("genre"),
	HX_CSTRING("songName"),
	HX_CSTRING("track"),
	HX_CSTRING("year"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
};

Class ID3Info_obj::__mClass;

void ID3Info_obj::__register()
{
	Static(__mClass) = hx::RegisterClass(HX_CSTRING("nme.media.ID3Info"), hx::TCanCast< ID3Info_obj> ,sStaticFields,sMemberFields,
	&__CreateEmpty, &__Create,
	&super::__SGetClass(), 0, sMarkStatics);
}

void ID3Info_obj::__boot()
{
}

} // end namespace nme
} // end namespace media
