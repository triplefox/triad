#include <hxcpp.h>

#ifndef INCLUDED_hxMath
#include <hxMath.h>
#endif
#ifndef INCLUDED_Std
#include <Std.h>
#endif
#ifndef INCLUDED_com_ludamix_triad_ui_HSlider5
#include <com/ludamix/triad/ui/HSlider5.h>
#endif
#ifndef INCLUDED_com_ludamix_triad_ui_SliderDrawMode
#include <com/ludamix/triad/ui/SliderDrawMode.h>
#endif
#ifndef INCLUDED_nme_Lib
#include <nme/Lib.h>
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
#ifndef INCLUDED_nme_display_Graphics
#include <nme/display/Graphics.h>
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
#ifndef INCLUDED_nme_events_MouseEvent
#include <nme/events/MouseEvent.h>
#endif
#ifndef INCLUDED_nme_geom_Matrix
#include <nme/geom/Matrix.h>
#endif
#ifndef INCLUDED_nme_geom_Point
#include <nme/geom/Point.h>
#endif
#ifndef INCLUDED_nme_geom_Rectangle
#include <nme/geom/Rectangle.h>
#endif
namespace com{
namespace ludamix{
namespace triad{
namespace ui{

Void HSlider5_obj::__construct(::nme::display::BitmapData base,int tileW,int tileH,int sliderW,double highlighted,::com::ludamix::triad::ui::SliderDrawMode drawmode,Dynamic onSet)
{
{
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/HSlider5.hx",48)
	super::__construct();
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/HSlider5.hx",50)
	this->slices = Array_obj< ::nme::display::BitmapData >::__new();
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/HSlider5.hx",51)
	{
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/HSlider5.hx",51)
		int _g = (int)0;
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/HSlider5.hx",51)
		while(((_g < (int)7))){
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/HSlider5.hx",51)
			int x = (_g)++;
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/HSlider5.hx",53)
			::nme::display::BitmapData bd = ::nme::display::BitmapData_obj::__new(tileW,tileH,true,(int)0);
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/HSlider5.hx",54)
			bd->copyPixels(base,::nme::geom::Rectangle_obj::__new((x * tileW),(int)0,tileW,tileH),::nme::geom::Point_obj::__new((int)0,(int)0),base,::nme::geom::Point_obj::__new((x * tileW),(int)0),false);
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/HSlider5.hx",56)
			this->slices->push(bd);
		}
	}
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/HSlider5.hx",59)
	this->tileW = tileW;
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/HSlider5.hx",60)
	this->tileH = tileH;
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/HSlider5.hx",61)
	this->sliderW = sliderW;
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/HSlider5.hx",62)
	this->onSet = onSet;
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/HSlider5.hx",63)
	this->drawMode = drawmode;
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/HSlider5.hx",65)
	this->draw(highlighted);
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/HSlider5.hx",67)
	this->addEventListener(::nme::events::MouseEvent_obj::MOUSE_DOWN,this->onDown_dyn(),null(),null(),null());
}
;
	return null();
}

HSlider5_obj::~HSlider5_obj() { }

Dynamic HSlider5_obj::__CreateEmpty() { return  new HSlider5_obj; }
hx::ObjectPtr< HSlider5_obj > HSlider5_obj::__new(::nme::display::BitmapData base,int tileW,int tileH,int sliderW,double highlighted,::com::ludamix::triad::ui::SliderDrawMode drawmode,Dynamic onSet)
{  hx::ObjectPtr< HSlider5_obj > result = new HSlider5_obj();
	result->__construct(base,tileW,tileH,sliderW,highlighted,drawmode,onSet);
	return result;}

Dynamic HSlider5_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< HSlider5_obj > result = new HSlider5_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2],inArgs[3],inArgs[4],inArgs[5],inArgs[6]);
	return result;}

Void HSlider5_obj::draw( double highlighted){
{
		HX_SOURCE_PUSH("HSlider5_obj::draw")
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/HSlider5.hx",73)
		this->nmeGetGraphics()->clear();
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/HSlider5.hx",75)
		int pos = (int)0;
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/HSlider5.hx",76)
		int allocBar = (this->sliderW - (this->tileW * (int)2));
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/HSlider5.hx",77)
		int allocHighlight = ::Std_obj::_int((((this->sliderW - this->tileW)) * highlighted));
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/HSlider5.hx",78)
		int allocHandle = (::Std_obj::_int((this->sliderW * highlighted)) - this->tileW);
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/HSlider5.hx",80)
		{
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/HSlider5.hx",80)
			int _g = (int)0;
			Array< ::nme::display::BitmapData > _g1 = this->slices;
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/HSlider5.hx",80)
			while(((_g < _g1->length))){
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/HSlider5.hx",80)
				::nme::display::BitmapData s = _g1->__get(_g);
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/HSlider5.hx",80)
				++(_g);
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/HSlider5.hx",82)
				if (((pos > (int)5))){
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/HSlider5.hx",82)
					break;
				}
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/HSlider5.hx",84)
				int xPos = (int)0;
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/HSlider5.hx",85)
				int mW = (int)0;
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/HSlider5.hx",86)
				bool display = true;
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/HSlider5.hx",88)
				switch( (int)(pos)){
					case (int)0: {
						HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/HSlider5.hx",90)
						mW = this->tileW;
					}
					;break;
					case (int)1: {
						HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/HSlider5.hx",91)
						xPos = this->tileW;
						HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/HSlider5.hx",91)
						mW = allocBar;
					}
					;break;
					case (int)2: {
						HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/HSlider5.hx",92)
						mW = this->tileW;
						HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/HSlider5.hx",92)
						xPos = (this->sliderW - this->tileW);
					}
					;break;
					case (int)3: {
						HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/HSlider5.hx",93)
						mW = ::Std_obj::_int(::Math_obj::max((int)0,::Math_obj::min(this->tileW,(allocHighlight + (double(this->tileW) / double((int)2))))));
					}
					;break;
					case (int)4: {
						HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/HSlider5.hx",94)
						xPos = this->tileW;
						HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/HSlider5.hx",94)
						mW = ::Std_obj::_int(::Math_obj::max((int)0,::Math_obj::min(allocBar,(allocHighlight - (double(this->tileW) / double((int)2))))));
					}
					;break;
					case (int)5: {
						HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/HSlider5.hx",95)
						xPos = (this->sliderW - this->tileW);
						HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/HSlider5.hx",95)
						mW = ::Std_obj::_int(::Math_obj::max((int)0,::Math_obj::min(this->tileW,((allocHighlight - (double(this->tileW) / double((int)2))) - allocBar))));
					}
					;break;
				}
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/HSlider5.hx",98)
				if (((mW > (int)0))){
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/HSlider5.hx",100)
					::nme::geom::Matrix mtx = ::nme::geom::Matrix_obj::__new(null(),null(),null(),null(),null(),null());
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/HSlider5.hx",101)
					if (((bool((pos == (int)1)) || bool((pos == (int)4))))){
						HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/HSlider5.hx",102)
						{
::com::ludamix::triad::ui::SliderDrawMode _switch_1 = (this->drawMode);
							switch((_switch_1)->GetIndex()){
								case 2: {
									HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/HSlider5.hx",106)
									double sX = (double(allocBar) / double(this->tileW));
									HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/HSlider5.hx",107)
									mtx->scale(sX,1.);
								}
								;break;
								case 1: {
								}
								;break;
								case 0: {
									HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/HSlider5.hx",110)
									double sX = (double(mW) / double(this->tileW));
									HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/HSlider5.hx",111)
									mtx->scale(sX,1.);
								}
								;break;
							}
						}
					}
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/HSlider5.hx",114)
					mtx->translate(xPos,(int)0);
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/HSlider5.hx",116)
					this->nmeGetGraphics()->beginBitmapFill(s,mtx,true,true);
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/HSlider5.hx",117)
					this->nmeGetGraphics()->drawRect(xPos,(int)0,mW,this->tileH);
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/HSlider5.hx",118)
					this->nmeGetGraphics()->endFill();
				}
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/HSlider5.hx",121)
				(pos)++;
			}
		}
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/HSlider5.hx",124)
		int xPos = allocHighlight;
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/HSlider5.hx",125)
		::nme::geom::Matrix mtx = ::nme::geom::Matrix_obj::__new(null(),null(),null(),null(),null(),null());
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/HSlider5.hx",126)
		mtx->translate(xPos,(int)0);
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/HSlider5.hx",130)
		this->nmeGetGraphics()->beginBitmapFill(this->slices->__get((int)6),mtx,null(),null());
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/HSlider5.hx",131)
		this->nmeGetGraphics()->drawRect(xPos,(int)0,this->tileW,this->tileH);
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/HSlider5.hx",132)
		this->nmeGetGraphics()->endFill();
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(HSlider5_obj,draw,(void))

Void HSlider5_obj::onFrame( ::nme::events::Event e){
{
		HX_SOURCE_PUSH("HSlider5_obj::onFrame")
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/HSlider5.hx",138)
		double pct = ::Math_obj::max(0.,::Math_obj::min(1.,(double(this->nmeGetMouseX()) / double(this->sliderW))));
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/HSlider5.hx",140)
		this->draw(pct);
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/HSlider5.hx",141)
		if (((this->onSet_dyn() != null()))){
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/HSlider5.hx",142)
			this->onSet(pct);
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(HSlider5_obj,onFrame,(void))

Void HSlider5_obj::onDown( ::nme::events::MouseEvent e){
{
		HX_SOURCE_PUSH("HSlider5_obj::onDown")
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/HSlider5.hx",148)
		::nme::Lib_obj::nmeGetCurrent()->nmeGetStage()->addEventListener(::nme::events::Event_obj::ENTER_FRAME,this->onFrame_dyn(),null(),null(),null());
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/HSlider5.hx",149)
		::nme::Lib_obj::nmeGetCurrent()->nmeGetStage()->addEventListener(::nme::events::MouseEvent_obj::MOUSE_UP,this->onUp_dyn(),null(),null(),null());
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(HSlider5_obj,onDown,(void))

Void HSlider5_obj::onUp( ::nme::events::MouseEvent e){
{
		HX_SOURCE_PUSH("HSlider5_obj::onUp")
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/HSlider5.hx",154)
		::nme::Lib_obj::nmeGetCurrent()->nmeGetStage()->removeEventListener(::nme::events::Event_obj::ENTER_FRAME,this->onFrame_dyn(),null());
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/HSlider5.hx",155)
		::nme::Lib_obj::nmeGetCurrent()->nmeGetStage()->removeEventListener(::nme::events::MouseEvent_obj::MOUSE_UP,this->onUp_dyn(),null());
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(HSlider5_obj,onUp,(void))

int HSlider5_obj::CLCAP;

int HSlider5_obj::CBAR;

int HSlider5_obj::CRCAP;

int HSlider5_obj::HLCAP;

int HSlider5_obj::HBAR;

int HSlider5_obj::HRCAP;

int HSlider5_obj::HANDLE;


HSlider5_obj::HSlider5_obj()
{
}

void HSlider5_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(HSlider5);
	HX_MARK_MEMBER_NAME(slices,"slices");
	HX_MARK_MEMBER_NAME(tileW,"tileW");
	HX_MARK_MEMBER_NAME(tileH,"tileH");
	HX_MARK_MEMBER_NAME(sliderW,"sliderW");
	HX_MARK_MEMBER_NAME(onSet,"onSet");
	HX_MARK_MEMBER_NAME(drawMode,"drawMode");
	super::__Mark(HX_MARK_ARG);
	HX_MARK_END_CLASS();
}

Dynamic HSlider5_obj::__Field(const ::String &inName)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"CBAR") ) { return CBAR; }
		if (HX_FIELD_EQ(inName,"HBAR") ) { return HBAR; }
		if (HX_FIELD_EQ(inName,"draw") ) { return draw_dyn(); }
		if (HX_FIELD_EQ(inName,"onUp") ) { return onUp_dyn(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"CLCAP") ) { return CLCAP; }
		if (HX_FIELD_EQ(inName,"CRCAP") ) { return CRCAP; }
		if (HX_FIELD_EQ(inName,"HLCAP") ) { return HLCAP; }
		if (HX_FIELD_EQ(inName,"HRCAP") ) { return HRCAP; }
		if (HX_FIELD_EQ(inName,"tileW") ) { return tileW; }
		if (HX_FIELD_EQ(inName,"tileH") ) { return tileH; }
		if (HX_FIELD_EQ(inName,"onSet") ) { return onSet; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"HANDLE") ) { return HANDLE; }
		if (HX_FIELD_EQ(inName,"slices") ) { return slices; }
		if (HX_FIELD_EQ(inName,"onDown") ) { return onDown_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"sliderW") ) { return sliderW; }
		if (HX_FIELD_EQ(inName,"onFrame") ) { return onFrame_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"drawMode") ) { return drawMode; }
	}
	return super::__Field(inName);
}

Dynamic HSlider5_obj::__SetField(const ::String &inName,const Dynamic &inValue)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"CBAR") ) { CBAR=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"HBAR") ) { HBAR=inValue.Cast< int >(); return inValue; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"CLCAP") ) { CLCAP=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"CRCAP") ) { CRCAP=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"HLCAP") ) { HLCAP=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"HRCAP") ) { HRCAP=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"tileW") ) { tileW=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"tileH") ) { tileH=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"onSet") ) { onSet=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"HANDLE") ) { HANDLE=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"slices") ) { slices=inValue.Cast< Array< ::nme::display::BitmapData > >(); return inValue; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"sliderW") ) { sliderW=inValue.Cast< int >(); return inValue; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"drawMode") ) { drawMode=inValue.Cast< ::com::ludamix::triad::ui::SliderDrawMode >(); return inValue; }
	}
	return super::__SetField(inName,inValue);
}

void HSlider5_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("slices"));
	outFields->push(HX_CSTRING("tileW"));
	outFields->push(HX_CSTRING("tileH"));
	outFields->push(HX_CSTRING("sliderW"));
	outFields->push(HX_CSTRING("drawMode"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("CLCAP"),
	HX_CSTRING("CBAR"),
	HX_CSTRING("CRCAP"),
	HX_CSTRING("HLCAP"),
	HX_CSTRING("HBAR"),
	HX_CSTRING("HRCAP"),
	HX_CSTRING("HANDLE"),
	String(null()) };

static ::String sMemberFields[] = {
	HX_CSTRING("slices"),
	HX_CSTRING("tileW"),
	HX_CSTRING("tileH"),
	HX_CSTRING("sliderW"),
	HX_CSTRING("onSet"),
	HX_CSTRING("drawMode"),
	HX_CSTRING("draw"),
	HX_CSTRING("onFrame"),
	HX_CSTRING("onDown"),
	HX_CSTRING("onUp"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(HSlider5_obj::CLCAP,"CLCAP");
	HX_MARK_MEMBER_NAME(HSlider5_obj::CBAR,"CBAR");
	HX_MARK_MEMBER_NAME(HSlider5_obj::CRCAP,"CRCAP");
	HX_MARK_MEMBER_NAME(HSlider5_obj::HLCAP,"HLCAP");
	HX_MARK_MEMBER_NAME(HSlider5_obj::HBAR,"HBAR");
	HX_MARK_MEMBER_NAME(HSlider5_obj::HRCAP,"HRCAP");
	HX_MARK_MEMBER_NAME(HSlider5_obj::HANDLE,"HANDLE");
};

Class HSlider5_obj::__mClass;

void HSlider5_obj::__register()
{
	Static(__mClass) = hx::RegisterClass(HX_CSTRING("com.ludamix.triad.ui.HSlider5"), hx::TCanCast< HSlider5_obj> ,sStaticFields,sMemberFields,
	&__CreateEmpty, &__Create,
	&super::__SGetClass(), 0, sMarkStatics);
}

void HSlider5_obj::__boot()
{
	hx::Static(CLCAP) = (int)0;
	hx::Static(CBAR) = (int)1;
	hx::Static(CRCAP) = (int)2;
	hx::Static(HLCAP) = (int)3;
	hx::Static(HBAR) = (int)4;
	hx::Static(HRCAP) = (int)5;
	hx::Static(HANDLE) = (int)6;
}

} // end namespace com
} // end namespace ludamix
} // end namespace triad
} // end namespace ui
