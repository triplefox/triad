#include <hxcpp.h>

#ifndef INCLUDED_GUITests
#include <GUITests.h>
#endif
#ifndef INCLUDED_com_ludamix_triad_ui_HSlider5
#include <com/ludamix/triad/ui/HSlider5.h>
#endif
#ifndef INCLUDED_com_ludamix_triad_ui_Rect9
#include <com/ludamix/triad/ui/Rect9.h>
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
#ifndef INCLUDED_nme_installer_Assets
#include <nme/installer/Assets.h>
#endif

Void GUITests_obj::__construct()
{
{
	HX_SOURCE_POS("Source/GUITests.hx",16)
	::nme::display::Sprite bg = ::nme::display::Sprite_obj::__new();
	HX_SOURCE_POS("Source/GUITests.hx",17)
	bg->nmeGetGraphics()->beginFill((int)16711935,1.0);
	HX_SOURCE_POS("Source/GUITests.hx",18)
	bg->nmeGetGraphics()->drawRect((int)0,(int)0,::nme::Lib_obj::nmeGetCurrent()->nmeGetStage()->nmeGetStageWidth(),::nme::Lib_obj::nmeGetCurrent()->nmeGetStage()->nmeGetStageHeight());
	HX_SOURCE_POS("Source/GUITests.hx",19)
	bg->nmeGetGraphics()->endFill();
	HX_SOURCE_POS("Source/GUITests.hx",20)
	::nme::Lib_obj::nmeGetCurrent()->nmeGetStage()->addChild(bg);
	HX_SOURCE_POS("Source/GUITests.hx",22)
	::com::ludamix::triad::ui::Rect9 rr = ::com::ludamix::triad::ui::Rect9_obj::__new(::nme::installer::Assets_obj::getBitmapData(HX_CSTRING("assets/frame.png"),null()),(int)8,(int)8,(int)32,(int)32);
	HX_SOURCE_POS("Source/GUITests.hx",23)
	::com::ludamix::triad::ui::Rect9 rrDown = ::com::ludamix::triad::ui::Rect9_obj::__new(::nme::installer::Assets_obj::getBitmapData(HX_CSTRING("assets/frame2.png"),null()),(int)8,(int)8,(int)32,(int)32);
	HX_SOURCE_POS("Source/GUITests.hx",24)
	::nme::display::Sprite spr = ::nme::display::Sprite_obj::__new();
	HX_SOURCE_POS("Source/GUITests.hx",25)
	rr->draw(spr,(int)150,(int)200,true);
	HX_SOURCE_POS("Source/GUITests.hx",27)
	spr->nmeSetX((int)200);
	HX_SOURCE_POS("Source/GUITests.hx",28)
	spr->nmeSetY((int)200);
	HX_SOURCE_POS("Source/GUITests.hx",30)
	::nme::Lib_obj::nmeGetCurrent()->nmeGetStage()->addChild(spr);
	HX_SOURCE_POS("Source/GUITests.hx",32)
	Array< ::nme::display::Sprite > btnUp = Array_obj< ::nme::display::Sprite >::__new().Add(::nme::display::Sprite_obj::__new());
	HX_SOURCE_POS("Source/GUITests.hx",33)
	rr->draw(btnUp->__get((int)0),(int)70,(int)32,true);
	HX_SOURCE_POS("Source/GUITests.hx",34)
	Array< ::nme::display::Sprite > btnDown = Array_obj< ::nme::display::Sprite >::__new().Add(::nme::display::Sprite_obj::__new());
	HX_SOURCE_POS("Source/GUITests.hx",35)
	rrDown->draw(btnDown->__get((int)0),(int)70,(int)32,true);
	HX_SOURCE_POS("Source/GUITests.hx",36)
	::nme::display::Sprite btn = ::nme::display::Sprite_obj::__new();
	HX_SOURCE_POS("Source/GUITests.hx",37)
	btn->nmeSetMouseChildren(false);
	HX_SOURCE_POS("Source/GUITests.hx",38)
	btn->addChild(btnUp->__get((int)0));
	HX_SOURCE_POS("Source/GUITests.hx",39)
	btn->addChild(btnDown->__get((int)0));
	HX_SOURCE_POS("Source/GUITests.hx",40)
	btnDown->__get((int)0)->nmeSetVisible(false);

	HX_BEGIN_LOCAL_FUNC_S2(hx::LocalFunc,_Function_1_1,Array< ::nme::display::Sprite >,btnDown,Array< ::nme::display::Sprite >,btnUp)
	Void run(Dynamic _){
{
			HX_SOURCE_POS("Source/GUITests.hx",43)
			btnDown->__get((int)0)->nmeSetVisible(true);
			HX_SOURCE_POS("Source/GUITests.hx",43)
			btnUp->__get((int)0)->nmeSetVisible(false);
		}
		return null();
	}
	HX_END_LOCAL_FUNC1((void))

	HX_SOURCE_POS("Source/GUITests.hx",43)
	Dynamic btnOnDown =  Dynamic(new _Function_1_1(btnDown,btnUp));

	HX_BEGIN_LOCAL_FUNC_S2(hx::LocalFunc,_Function_1_2,Array< ::nme::display::Sprite >,btnDown,Array< ::nme::display::Sprite >,btnUp)
	Void run(Dynamic _){
{
			HX_SOURCE_POS("Source/GUITests.hx",44)
			btnDown->__get((int)0)->nmeSetVisible(false);
			HX_SOURCE_POS("Source/GUITests.hx",44)
			btnUp->__get((int)0)->nmeSetVisible(true);
		}
		return null();
	}
	HX_END_LOCAL_FUNC1((void))

	HX_SOURCE_POS("Source/GUITests.hx",44)
	Dynamic btnOnUp =  Dynamic(new _Function_1_2(btnDown,btnUp));
	HX_SOURCE_POS("Source/GUITests.hx",45)
	btn->addEventListener(::nme::events::MouseEvent_obj::MOUSE_DOWN,btnOnDown,null(),null(),null());
	HX_SOURCE_POS("Source/GUITests.hx",46)
	btn->addEventListener(::nme::events::MouseEvent_obj::MOUSE_UP,btnOnUp,null(),null(),null());
	HX_SOURCE_POS("Source/GUITests.hx",47)
	btn->addEventListener(::nme::events::MouseEvent_obj::MOUSE_OUT,btnOnUp,null(),null(),null());
	HX_SOURCE_POS("Source/GUITests.hx",49)
	btn->nmeSetX((int)220);
	HX_SOURCE_POS("Source/GUITests.hx",50)
	btn->nmeSetY((int)250);
	HX_SOURCE_POS("Source/GUITests.hx",51)
	::nme::Lib_obj::nmeGetCurrent()->nmeGetStage()->addChild(btn);
	HX_SOURCE_POS("Source/GUITests.hx",53)
	::com::ludamix::triad::ui::HSlider5 hs = ::com::ludamix::triad::ui::HSlider5_obj::__new(::nme::installer::Assets_obj::getBitmapData(HX_CSTRING("assets/slider.png"),null()),(int)16,(int)16,(int)120,0.5,::com::ludamix::triad::ui::SliderDrawMode_obj::SliderRepeat_dyn(),null());
	HX_SOURCE_POS("Source/GUITests.hx",54)
	::nme::Lib_obj::nmeGetCurrent()->nmeGetStage()->addChild(hs);
	HX_SOURCE_POS("Source/GUITests.hx",55)
	hs->nmeSetX((int)220);
	HX_SOURCE_POS("Source/GUITests.hx",56)
	hs->nmeSetY((int)220);
}
;
	return null();
}

GUITests_obj::~GUITests_obj() { }

Dynamic GUITests_obj::__CreateEmpty() { return  new GUITests_obj; }
hx::ObjectPtr< GUITests_obj > GUITests_obj::__new()
{  hx::ObjectPtr< GUITests_obj > result = new GUITests_obj();
	result->__construct();
	return result;}

Dynamic GUITests_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< GUITests_obj > result = new GUITests_obj();
	result->__construct();
	return result;}


GUITests_obj::GUITests_obj()
{
}

void GUITests_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(GUITests);
	HX_MARK_END_CLASS();
}

Dynamic GUITests_obj::__Field(const ::String &inName)
{
	return super::__Field(inName);
}

Dynamic GUITests_obj::__SetField(const ::String &inName,const Dynamic &inValue)
{
	return super::__SetField(inName,inValue);
}

void GUITests_obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

static ::String sMemberFields[] = {
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
};

Class GUITests_obj::__mClass;

void GUITests_obj::__register()
{
	Static(__mClass) = hx::RegisterClass(HX_CSTRING("GUITests"), hx::TCanCast< GUITests_obj> ,sStaticFields,sMemberFields,
	&__CreateEmpty, &__Create,
	&super::__SGetClass(), 0, sMarkStatics);
}

void GUITests_obj::__boot()
{
}

