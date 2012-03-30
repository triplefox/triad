#include <hxcpp.h>

#ifndef INCLUDED_ASCIITest
#include <ASCIITest.h>
#endif
#ifndef INCLUDED_com_ludamix_triad_blitter_ASCIIMap
#include <com/ludamix/triad/blitter/ASCIIMap.h>
#endif
#ifndef INCLUDED_com_ludamix_triad_blitter_ASCIISheet
#include <com/ludamix/triad/blitter/ASCIISheet.h>
#endif
#ifndef INCLUDED_com_ludamix_triad_grid_AbstractGrid
#include <com/ludamix/triad/grid/AbstractGrid.h>
#endif
#ifndef INCLUDED_com_ludamix_triad_grid_IntGrid
#include <com/ludamix/triad/grid/IntGrid.h>
#endif
#ifndef INCLUDED_nme_Lib
#include <nme/Lib.h>
#endif
#ifndef INCLUDED_nme_display_Bitmap
#include <nme/display/Bitmap.h>
#endif
#ifndef INCLUDED_nme_display_BitmapData
#include <nme/display/BitmapData.h>
#endif
#ifndef INCLUDED_nme_display_DisplayObject
#include <nme/display/DisplayObject.h>
#endif
#ifndef INCLUDED_nme_display_DisplayObjectContainer
#include <nme/display/DisplayObjectContainer.h>
#endif
#ifndef INCLUDED_nme_display_IBitmapDrawable
#include <nme/display/IBitmapDrawable.h>
#endif
#ifndef INCLUDED_nme_display_InteractiveObject
#include <nme/display/InteractiveObject.h>
#endif
#ifndef INCLUDED_nme_display_MovieClip
#include <nme/display/MovieClip.h>
#endif
#ifndef INCLUDED_nme_display_Sprite
#include <nme/display/Sprite.h>
#endif
#ifndef INCLUDED_nme_display_Stage
#include <nme/display/Stage.h>
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
#ifndef INCLUDED_nme_installer_Assets
#include <nme/installer/Assets.h>
#endif

Void ASCIITest_obj::__construct()
{
{
	HX_SOURCE_POS("Source/ASCIITest.hx",17)
	this->asheet = ::com::ludamix::triad::blitter::ASCIISheet_obj::__new(::nme::installer::Assets_obj::getBitmapData(HX_CSTRING("assets/VGA9x16.png"),false),(int)9,(int)16,Array_obj< int >::__new().Add((int)0).Add((int)170).Add((int)43520).Add((int)43690).Add((int)11141120).Add((int)11141290).Add((int)11162880).Add((int)11184810).Add((int)5592405).Add((int)5592575).Add((int)5635925).Add((int)5636095).Add((int)16733525).Add((int)16733695).Add((int)16777045).Add((int)16777215));
	HX_SOURCE_POS("Source/ASCIITest.hx",20)
	this->amap = ::com::ludamix::triad::blitter::ASCIIMap_obj::__new(this->asheet,(int)80,(int)25);
	HX_SOURCE_POS("Source/ASCIITest.hx",22)
	::nme::Lib_obj::nmeGetCurrent()->nmeGetStage()->addChild(this->amap);
	HX_SOURCE_POS("Source/ASCIITest.hx",24)
	::nme::Lib_obj::nmeGetCurrent()->addEventListener(::nme::events::Event_obj::ENTER_FRAME,this->update_dyn(),null(),null(),null());
	HX_SOURCE_POS("Source/ASCIITest.hx",26)
	this->ptr = (int)0;
	HX_SOURCE_POS("Source/ASCIITest.hx",27)
	this->update(null());
}
;
	return null();
}

ASCIITest_obj::~ASCIITest_obj() { }

Dynamic ASCIITest_obj::__CreateEmpty() { return  new ASCIITest_obj; }
hx::ObjectPtr< ASCIITest_obj > ASCIITest_obj::__new()
{  hx::ObjectPtr< ASCIITest_obj > result = new ASCIITest_obj();
	result->__construct();
	return result;}

Dynamic ASCIITest_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< ASCIITest_obj > result = new ASCIITest_obj();
	result->__construct();
	return result;}

Void ASCIITest_obj::update( Dynamic _){
{
		HX_SOURCE_PUSH("ASCIITest_obj::update")
		HX_SOURCE_POS("Source/ASCIITest.hx",33)
		{
			HX_SOURCE_POS("Source/ASCIITest.hx",33)
			int _g1 = (int)0;
			int _g = this->amap->_char->world->__Field(HX_CSTRING("length"));
			HX_SOURCE_POS("Source/ASCIITest.hx",33)
			while(((_g1 < _g))){
				HX_SOURCE_POS("Source/ASCIITest.hx",33)
				int n = (_g1)++;
				HX_SOURCE_POS("Source/ASCIITest.hx",36)
				hx::IndexRef((this->amap->_char->world).mPtr,n) = hx::Mod(((n + this->ptr)),(int)65536);
			}
		}
		HX_SOURCE_POS("Source/ASCIITest.hx",39)
		this->amap->update();
		HX_SOURCE_POS("Source/ASCIITest.hx",41)
		hx::AddEq(this->ptr,(int)1);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(ASCIITest_obj,update,(void))


ASCIITest_obj::ASCIITest_obj()
{
}

void ASCIITest_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(ASCIITest);
	HX_MARK_MEMBER_NAME(ptr,"ptr");
	HX_MARK_MEMBER_NAME(amap,"amap");
	HX_MARK_MEMBER_NAME(asheet,"asheet");
	HX_MARK_END_CLASS();
}

Dynamic ASCIITest_obj::__Field(const ::String &inName)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"ptr") ) { return ptr; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"amap") ) { return amap; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"asheet") ) { return asheet; }
		if (HX_FIELD_EQ(inName,"update") ) { return update_dyn(); }
	}
	return super::__Field(inName);
}

Dynamic ASCIITest_obj::__SetField(const ::String &inName,const Dynamic &inValue)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"ptr") ) { ptr=inValue.Cast< int >(); return inValue; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"amap") ) { amap=inValue.Cast< ::com::ludamix::triad::blitter::ASCIIMap >(); return inValue; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"asheet") ) { asheet=inValue.Cast< ::com::ludamix::triad::blitter::ASCIISheet >(); return inValue; }
	}
	return super::__SetField(inName,inValue);
}

void ASCIITest_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("ptr"));
	outFields->push(HX_CSTRING("amap"));
	outFields->push(HX_CSTRING("asheet"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

static ::String sMemberFields[] = {
	HX_CSTRING("ptr"),
	HX_CSTRING("amap"),
	HX_CSTRING("asheet"),
	HX_CSTRING("update"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
};

Class ASCIITest_obj::__mClass;

void ASCIITest_obj::__register()
{
	Static(__mClass) = hx::RegisterClass(HX_CSTRING("ASCIITest"), hx::TCanCast< ASCIITest_obj> ,sStaticFields,sMemberFields,
	&__CreateEmpty, &__Create,
	&super::__SGetClass(), 0, sMarkStatics);
}

void ASCIITest_obj::__boot()
{
}

