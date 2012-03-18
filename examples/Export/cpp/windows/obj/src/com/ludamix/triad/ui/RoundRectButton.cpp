#include <hxcpp.h>

#ifndef INCLUDED_com_ludamix_triad_ui_BorderDef
#include <com/ludamix/triad/ui/BorderDef.h>
#endif
#ifndef INCLUDED_com_ludamix_triad_ui_HighlightingColorDef
#include <com/ludamix/triad/ui/HighlightingColorDef.h>
#endif
#ifndef INCLUDED_com_ludamix_triad_ui_RoundRectButton
#include <com/ludamix/triad/ui/RoundRectButton.h>
#endif
#ifndef INCLUDED_com_ludamix_triad_ui_RoundRectButtonDef
#include <com/ludamix/triad/ui/RoundRectButtonDef.h>
#endif
#ifndef INCLUDED_com_ludamix_triad_ui_StyledText
#include <com/ludamix/triad/ui/StyledText.h>
#endif
#ifndef INCLUDED_com_ludamix_triad_ui_StyledTextDef
#include <com/ludamix/triad/ui/StyledTextDef.h>
#endif
#ifndef INCLUDED_com_ludamix_triad_ui_Values
#include <com/ludamix/triad/ui/Values.h>
#endif
#ifndef INCLUDED_nme_display_CapsStyle
#include <nme/display/CapsStyle.h>
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
#ifndef INCLUDED_nme_display_JointStyle
#include <nme/display/JointStyle.h>
#endif
#ifndef INCLUDED_nme_display_LineScaleMode
#include <nme/display/LineScaleMode.h>
#endif
#ifndef INCLUDED_nme_display_Sprite
#include <nme/display/Sprite.h>
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
#ifndef INCLUDED_nme_geom_Point
#include <nme/geom/Point.h>
#endif
#ifndef INCLUDED_nme_text_TextField
#include <nme/text/TextField.h>
#endif
namespace com{
namespace ludamix{
namespace triad{
namespace ui{

Void RoundRectButton_obj::__construct(::nme::geom::Point center,double w,double h,::String text,::com::ludamix::triad::ui::RoundRectButtonDef def)
{
{
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/RoundRectButton.hx",17)
	super::__construct();
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/RoundRectButton.hx",22)
	this->bw = w;
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/RoundRectButton.hx",23)
	this->bh = h;
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/RoundRectButton.hx",25)
	this->nmeSetX(center->x);
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/RoundRectButton.hx",26)
	this->nmeSetY(center->y);
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/RoundRectButton.hx",28)
	{
::com::ludamix::triad::ui::RoundRectButtonDef _switch_1 = (def);
		switch((_switch_1)->GetIndex()){
			case 0: {
				struct _Function_2_1{
					inline static Dynamic Block( ){
						hx::Anon __result = hx::Anon_obj::Create();
						__result->Add(HX_CSTRING("border") , ::com::ludamix::triad::ui::Values_obj::border(::com::ludamix::triad::ui::BorderDef_obj::BDPlaceholder_dyn()),false);
						__result->Add(HX_CSTRING("color") , ::com::ludamix::triad::ui::Values_obj::highlightingColor(::com::ludamix::triad::ui::HighlightingColorDef_obj::HCPlaceholder_dyn()),false);
						__result->Add(HX_CSTRING("text") , ::com::ludamix::triad::ui::StyledTextDef_obj::STPlaceholder_dyn(),false);
						__result->Add(HX_CSTRING("roundnessX") , 16.,false);
						__result->Add(HX_CSTRING("roundnessY") , 16.,false);
						return __result;
					}
				};
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/RoundRectButton.hx",30)
				this->def = _Function_2_1::Block();
			}
			;break;
			case 1: {
				double roundness = _switch_1->__Param(3);
				::com::ludamix::triad::ui::StyledTextDef text1 = _switch_1->__Param(2);
				::com::ludamix::triad::ui::HighlightingColorDef color = _switch_1->__Param(1);
				::com::ludamix::triad::ui::BorderDef border = _switch_1->__Param(0);
{
					struct _Function_2_1{
						inline static Dynamic Block( ::com::ludamix::triad::ui::BorderDef &border,double &roundness,::com::ludamix::triad::ui::StyledTextDef &text1,::com::ludamix::triad::ui::HighlightingColorDef &color){
							hx::Anon __result = hx::Anon_obj::Create();
							__result->Add(HX_CSTRING("border") , ::com::ludamix::triad::ui::Values_obj::border(border),false);
							__result->Add(HX_CSTRING("color") , ::com::ludamix::triad::ui::Values_obj::highlightingColor(color),false);
							__result->Add(HX_CSTRING("text") , text1,false);
							__result->Add(HX_CSTRING("roundnessX") , roundness,false);
							__result->Add(HX_CSTRING("roundnessY") , roundness,false);
							return __result;
						}
					};
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/RoundRectButton.hx",31)
					this->def = _Function_2_1::Block(border,roundness,text1,color);
				}
			}
			;break;
			case 2: {
				double roundnessY = _switch_1->__Param(4);
				double roundnessX = _switch_1->__Param(3);
				::com::ludamix::triad::ui::StyledTextDef text1 = _switch_1->__Param(2);
				::com::ludamix::triad::ui::HighlightingColorDef color = _switch_1->__Param(1);
				::com::ludamix::triad::ui::BorderDef border = _switch_1->__Param(0);
{
					struct _Function_2_1{
						inline static Dynamic Block( ::com::ludamix::triad::ui::BorderDef &border,::com::ludamix::triad::ui::StyledTextDef &text1,double &roundnessY,::com::ludamix::triad::ui::HighlightingColorDef &color,double &roundnessX){
							hx::Anon __result = hx::Anon_obj::Create();
							__result->Add(HX_CSTRING("border") , ::com::ludamix::triad::ui::Values_obj::border(border),false);
							__result->Add(HX_CSTRING("color") , ::com::ludamix::triad::ui::Values_obj::highlightingColor(color),false);
							__result->Add(HX_CSTRING("text") , text1,false);
							__result->Add(HX_CSTRING("roundnessX") , roundnessX,false);
							__result->Add(HX_CSTRING("roundnessY") , roundnessY,false);
							return __result;
						}
					};
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/RoundRectButton.hx",33)
					this->def = _Function_2_1::Block(border,text1,roundnessY,color,roundnessX);
				}
			}
			;break;
		}
	}
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/RoundRectButton.hx",37)
	this->header = ::com::ludamix::triad::ui::StyledText_obj::__new(::nme::geom::Point_obj::__new(0.,0.),w,h,text,this->def->__Field(HX_CSTRING("text")),null());
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/RoundRectButton.hx",38)
	this->addChild(this->header);
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/RoundRectButton.hx",40)
	this->onOff(null());
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/RoundRectButton.hx",42)
	this->addEventListener(::nme::events::MouseEvent_obj::MOUSE_MOVE,this->onOver_dyn(),null(),null(),null());
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/RoundRectButton.hx",43)
	this->addEventListener(::nme::events::MouseEvent_obj::MOUSE_OVER,this->onOver_dyn(),null(),null(),null());
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/RoundRectButton.hx",44)
	this->addEventListener(::nme::events::MouseEvent_obj::MOUSE_OUT,this->onOff_dyn(),null(),null(),null());
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/RoundRectButton.hx",45)
	this->addEventListener(::nme::events::MouseEvent_obj::MOUSE_UP,this->onOver_dyn(),null(),null(),null());
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/RoundRectButton.hx",46)
	this->addEventListener(::nme::events::MouseEvent_obj::MOUSE_DOWN,this->onDown_dyn(),null(),null(),null());
}
;
	return null();
}

RoundRectButton_obj::~RoundRectButton_obj() { }

Dynamic RoundRectButton_obj::__CreateEmpty() { return  new RoundRectButton_obj; }
hx::ObjectPtr< RoundRectButton_obj > RoundRectButton_obj::__new(::nme::geom::Point center,double w,double h,::String text,::com::ludamix::triad::ui::RoundRectButtonDef def)
{  hx::ObjectPtr< RoundRectButton_obj > result = new RoundRectButton_obj();
	result->__construct(center,w,h,text,def);
	return result;}

Dynamic RoundRectButton_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< RoundRectButton_obj > result = new RoundRectButton_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2],inArgs[3],inArgs[4]);
	return result;}

Void RoundRectButton_obj::onOff( ::nme::events::MouseEvent ev){
{
		HX_SOURCE_PUSH("RoundRectButton_obj::onOff")
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/RoundRectButton.hx",51)
		this->nmeGetGraphics()->clear();
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/RoundRectButton.hx",52)
		this->nmeGetGraphics()->lineStyle(this->def->__Field(HX_CSTRING("border"))->__Field(HX_CSTRING("thickness")),this->def->__Field(HX_CSTRING("border"))->__Field(HX_CSTRING("color"))->__Field(HX_CSTRING("off")),null(),null(),null(),null(),null(),null());
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/RoundRectButton.hx",53)
		this->nmeGetGraphics()->beginFill(this->def->__Field(HX_CSTRING("color"))->__Field(HX_CSTRING("off")),null());
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/RoundRectButton.hx",54)
		this->nmeGetGraphics()->drawRoundRect((double(-(this->bw)) / double((int)2)),(double(-(this->bh)) / double((int)2)),this->bw,this->bh,this->def->__Field(HX_CSTRING("roundnessX")),this->def->__Field(HX_CSTRING("roundnessY")));
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/RoundRectButton.hx",55)
		this->nmeGetGraphics()->endFill();
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(RoundRectButton_obj,onOff,(void))

Void RoundRectButton_obj::onOver( ::nme::events::MouseEvent ev){
{
		HX_SOURCE_PUSH("RoundRectButton_obj::onOver")
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/RoundRectButton.hx",59)
		if ((!(ev->buttonDown))){
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/RoundRectButton.hx",62)
			this->nmeGetGraphics()->clear();
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/RoundRectButton.hx",63)
			this->nmeGetGraphics()->lineStyle(this->def->__Field(HX_CSTRING("border"))->__Field(HX_CSTRING("thickness")),this->def->__Field(HX_CSTRING("border"))->__Field(HX_CSTRING("color"))->__Field(HX_CSTRING("highlighted")),null(),null(),null(),null(),null(),null());
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/RoundRectButton.hx",64)
			this->nmeGetGraphics()->beginFill(this->def->__Field(HX_CSTRING("color"))->__Field(HX_CSTRING("highlighted")),null());
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/RoundRectButton.hx",65)
			this->nmeGetGraphics()->drawRoundRect((double(-(this->bw)) / double((int)2)),(double(-(this->bh)) / double((int)2)),this->bw,this->bh,this->def->__Field(HX_CSTRING("roundnessX")),this->def->__Field(HX_CSTRING("roundnessY")));
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/RoundRectButton.hx",66)
			this->nmeGetGraphics()->endFill();
		}
		else{
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/RoundRectButton.hx",68)
			this->onDown(ev);
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(RoundRectButton_obj,onOver,(void))

Void RoundRectButton_obj::onDown( ::nme::events::MouseEvent ev){
{
		HX_SOURCE_PUSH("RoundRectButton_obj::onDown")
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/RoundRectButton.hx",73)
		this->nmeGetGraphics()->clear();
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/RoundRectButton.hx",74)
		this->nmeGetGraphics()->lineStyle(this->def->__Field(HX_CSTRING("border"))->__Field(HX_CSTRING("thickness")),this->def->__Field(HX_CSTRING("border"))->__Field(HX_CSTRING("color"))->__Field(HX_CSTRING("down")),null(),null(),null(),null(),null(),null());
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/RoundRectButton.hx",75)
		this->nmeGetGraphics()->beginFill(this->def->__Field(HX_CSTRING("color"))->__Field(HX_CSTRING("down")),null());
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/RoundRectButton.hx",76)
		this->nmeGetGraphics()->drawRoundRect((double(-(this->bw)) / double((int)2)),(double(-(this->bh)) / double((int)2)),this->bw,this->bh,this->def->__Field(HX_CSTRING("roundnessX")),this->def->__Field(HX_CSTRING("roundnessY")));
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/RoundRectButton.hx",77)
		this->nmeGetGraphics()->endFill();
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(RoundRectButton_obj,onDown,(void))


RoundRectButton_obj::RoundRectButton_obj()
{
}

void RoundRectButton_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(RoundRectButton);
	HX_MARK_MEMBER_NAME(def,"def");
	HX_MARK_MEMBER_NAME(bw,"bw");
	HX_MARK_MEMBER_NAME(bh,"bh");
	HX_MARK_MEMBER_NAME(header,"header");
	super::__Mark(HX_MARK_ARG);
	HX_MARK_END_CLASS();
}

Dynamic RoundRectButton_obj::__Field(const ::String &inName)
{
	switch(inName.length) {
	case 2:
		if (HX_FIELD_EQ(inName,"bw") ) { return bw; }
		if (HX_FIELD_EQ(inName,"bh") ) { return bh; }
		break;
	case 3:
		if (HX_FIELD_EQ(inName,"def") ) { return def; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"onOff") ) { return onOff_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"header") ) { return header; }
		if (HX_FIELD_EQ(inName,"onOver") ) { return onOver_dyn(); }
		if (HX_FIELD_EQ(inName,"onDown") ) { return onDown_dyn(); }
	}
	return super::__Field(inName);
}

Dynamic RoundRectButton_obj::__SetField(const ::String &inName,const Dynamic &inValue)
{
	switch(inName.length) {
	case 2:
		if (HX_FIELD_EQ(inName,"bw") ) { bw=inValue.Cast< double >(); return inValue; }
		if (HX_FIELD_EQ(inName,"bh") ) { bh=inValue.Cast< double >(); return inValue; }
		break;
	case 3:
		if (HX_FIELD_EQ(inName,"def") ) { def=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"header") ) { header=inValue.Cast< ::com::ludamix::triad::ui::StyledText >(); return inValue; }
	}
	return super::__SetField(inName,inValue);
}

void RoundRectButton_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("def"));
	outFields->push(HX_CSTRING("bw"));
	outFields->push(HX_CSTRING("bh"));
	outFields->push(HX_CSTRING("header"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

static ::String sMemberFields[] = {
	HX_CSTRING("def"),
	HX_CSTRING("bw"),
	HX_CSTRING("bh"),
	HX_CSTRING("header"),
	HX_CSTRING("onOff"),
	HX_CSTRING("onOver"),
	HX_CSTRING("onDown"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
};

Class RoundRectButton_obj::__mClass;

void RoundRectButton_obj::__register()
{
	Static(__mClass) = hx::RegisterClass(HX_CSTRING("com.ludamix.triad.ui.RoundRectButton"), hx::TCanCast< RoundRectButton_obj> ,sStaticFields,sMemberFields,
	&__CreateEmpty, &__Create,
	&super::__SGetClass(), 0, sMarkStatics);
}

void RoundRectButton_obj::__boot()
{
}

} // end namespace com
} // end namespace ludamix
} // end namespace triad
} // end namespace ui
