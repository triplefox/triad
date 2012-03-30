#include <hxcpp.h>

#ifndef INCLUDED_com_ludamix_triad_blitter_BlitterQueueInfos
#include <com/ludamix/triad/blitter/BlitterQueueInfos.h>
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

Void BlitterQueueInfos_obj::__construct(::nme::display::BitmapData bd,::nme::geom::Rectangle rect,int x,int y)
{
{
	HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/Blitter.hx",13)
	this->bd = bd;
	HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/Blitter.hx",13)
	this->rect = rect;
	HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/Blitter.hx",13)
	this->x = x;
	HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/Blitter.hx",13)
	this->y = y;
}
;
	return null();
}

BlitterQueueInfos_obj::~BlitterQueueInfos_obj() { }

Dynamic BlitterQueueInfos_obj::__CreateEmpty() { return  new BlitterQueueInfos_obj; }
hx::ObjectPtr< BlitterQueueInfos_obj > BlitterQueueInfos_obj::__new(::nme::display::BitmapData bd,::nme::geom::Rectangle rect,int x,int y)
{  hx::ObjectPtr< BlitterQueueInfos_obj > result = new BlitterQueueInfos_obj();
	result->__construct(bd,rect,x,y);
	return result;}

Dynamic BlitterQueueInfos_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< BlitterQueueInfos_obj > result = new BlitterQueueInfos_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2],inArgs[3]);
	return result;}


BlitterQueueInfos_obj::BlitterQueueInfos_obj()
{
}

void BlitterQueueInfos_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(BlitterQueueInfos);
	HX_MARK_MEMBER_NAME(bd,"bd");
	HX_MARK_MEMBER_NAME(rect,"rect");
	HX_MARK_MEMBER_NAME(x,"x");
	HX_MARK_MEMBER_NAME(y,"y");
	HX_MARK_END_CLASS();
}

Dynamic BlitterQueueInfos_obj::__Field(const ::String &inName)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"x") ) { return x; }
		if (HX_FIELD_EQ(inName,"y") ) { return y; }
		break;
	case 2:
		if (HX_FIELD_EQ(inName,"bd") ) { return bd; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"rect") ) { return rect; }
	}
	return super::__Field(inName);
}

Dynamic BlitterQueueInfos_obj::__SetField(const ::String &inName,const Dynamic &inValue)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"x") ) { x=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"y") ) { y=inValue.Cast< int >(); return inValue; }
		break;
	case 2:
		if (HX_FIELD_EQ(inName,"bd") ) { bd=inValue.Cast< ::nme::display::BitmapData >(); return inValue; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"rect") ) { rect=inValue.Cast< ::nme::geom::Rectangle >(); return inValue; }
	}
	return super::__SetField(inName,inValue);
}

void BlitterQueueInfos_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("bd"));
	outFields->push(HX_CSTRING("rect"));
	outFields->push(HX_CSTRING("x"));
	outFields->push(HX_CSTRING("y"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

static ::String sMemberFields[] = {
	HX_CSTRING("bd"),
	HX_CSTRING("rect"),
	HX_CSTRING("x"),
	HX_CSTRING("y"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
};

Class BlitterQueueInfos_obj::__mClass;

void BlitterQueueInfos_obj::__register()
{
	Static(__mClass) = hx::RegisterClass(HX_CSTRING("com.ludamix.triad.blitter.BlitterQueueInfos"), hx::TCanCast< BlitterQueueInfos_obj> ,sStaticFields,sMemberFields,
	&__CreateEmpty, &__Create,
	&super::__SGetClass(), 0, sMarkStatics);
}

void BlitterQueueInfos_obj::__boot()
{
}

} // end namespace com
} // end namespace ludamix
} // end namespace triad
} // end namespace blitter
