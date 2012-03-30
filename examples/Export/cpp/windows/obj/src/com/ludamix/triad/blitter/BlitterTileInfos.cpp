#include <hxcpp.h>

#ifndef INCLUDED_com_ludamix_triad_blitter_BlitterTileInfos
#include <com/ludamix/triad/blitter/BlitterTileInfos.h>
#endif
#ifndef INCLUDED_nme_display_BitmapData
#include <nme/display/BitmapData.h>
#endif
#ifndef INCLUDED_nme_display_IBitmapDrawable
#include <nme/display/IBitmapDrawable.h>
#endif
#ifndef INCLUDED_nme_geom_Rectangle
#include <nme/geom/Rectangle.h>
#endif
namespace com{
namespace ludamix{
namespace triad{
namespace blitter{

Void BlitterTileInfos_obj::__construct(::nme::display::BitmapData bd,::nme::geom::Rectangle rect)
{
{
	HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/Blitter.hx",19)
	this->bd = bd;
	HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/Blitter.hx",19)
	this->rect = rect;
}
;
	return null();
}

BlitterTileInfos_obj::~BlitterTileInfos_obj() { }

Dynamic BlitterTileInfos_obj::__CreateEmpty() { return  new BlitterTileInfos_obj; }
hx::ObjectPtr< BlitterTileInfos_obj > BlitterTileInfos_obj::__new(::nme::display::BitmapData bd,::nme::geom::Rectangle rect)
{  hx::ObjectPtr< BlitterTileInfos_obj > result = new BlitterTileInfos_obj();
	result->__construct(bd,rect);
	return result;}

Dynamic BlitterTileInfos_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< BlitterTileInfos_obj > result = new BlitterTileInfos_obj();
	result->__construct(inArgs[0],inArgs[1]);
	return result;}


BlitterTileInfos_obj::BlitterTileInfos_obj()
{
}

void BlitterTileInfos_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(BlitterTileInfos);
	HX_MARK_MEMBER_NAME(bd,"bd");
	HX_MARK_MEMBER_NAME(rect,"rect");
	HX_MARK_END_CLASS();
}

Dynamic BlitterTileInfos_obj::__Field(const ::String &inName)
{
	switch(inName.length) {
	case 2:
		if (HX_FIELD_EQ(inName,"bd") ) { return bd; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"rect") ) { return rect; }
	}
	return super::__Field(inName);
}

Dynamic BlitterTileInfos_obj::__SetField(const ::String &inName,const Dynamic &inValue)
{
	switch(inName.length) {
	case 2:
		if (HX_FIELD_EQ(inName,"bd") ) { bd=inValue.Cast< ::nme::display::BitmapData >(); return inValue; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"rect") ) { rect=inValue.Cast< ::nme::geom::Rectangle >(); return inValue; }
	}
	return super::__SetField(inName,inValue);
}

void BlitterTileInfos_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("bd"));
	outFields->push(HX_CSTRING("rect"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

static ::String sMemberFields[] = {
	HX_CSTRING("bd"),
	HX_CSTRING("rect"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
};

Class BlitterTileInfos_obj::__mClass;

void BlitterTileInfos_obj::__register()
{
	Static(__mClass) = hx::RegisterClass(HX_CSTRING("com.ludamix.triad.blitter.BlitterTileInfos"), hx::TCanCast< BlitterTileInfos_obj> ,sStaticFields,sMemberFields,
	&__CreateEmpty, &__Create,
	&super::__SGetClass(), 0, sMarkStatics);
}

void BlitterTileInfos_obj::__boot()
{
}

} // end namespace com
} // end namespace ludamix
} // end namespace triad
} // end namespace blitter
