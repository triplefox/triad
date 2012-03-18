#include <hxcpp.h>

#ifndef INCLUDED_com_ludamix_triad_tools_Color
#include <com/ludamix/triad/tools/Color.h>
#endif
#ifndef INCLUDED_com_ludamix_triad_tools_EColor
#include <com/ludamix/triad/tools/EColor.h>
#endif
#ifndef INCLUDED_com_ludamix_triad_ui_StyledFontDef
#include <com/ludamix/triad/ui/StyledFontDef.h>
#endif
#ifndef INCLUDED_com_ludamix_triad_ui_StyledText
#include <com/ludamix/triad/ui/StyledText.h>
#endif
#ifndef INCLUDED_com_ludamix_triad_ui_StyledTextDef
#include <com/ludamix/triad/ui/StyledTextDef.h>
#endif
#ifndef INCLUDED_com_ludamix_triad_ui_TextAlign
#include <com/ludamix/triad/ui/TextAlign.h>
#endif
#ifndef INCLUDED_nme_display_DisplayObject
#include <nme/display/DisplayObject.h>
#endif
#ifndef INCLUDED_nme_display_IBitmapDrawable
#include <nme/display/IBitmapDrawable.h>
#endif
#ifndef INCLUDED_nme_display_InteractiveObject
#include <nme/display/InteractiveObject.h>
#endif
#ifndef INCLUDED_nme_events_EventDispatcher
#include <nme/events/EventDispatcher.h>
#endif
#ifndef INCLUDED_nme_events_IEventDispatcher
#include <nme/events/IEventDispatcher.h>
#endif
#ifndef INCLUDED_nme_geom_Point
#include <nme/geom/Point.h>
#endif
#ifndef INCLUDED_nme_text_TextField
#include <nme/text/TextField.h>
#endif
#ifndef INCLUDED_nme_text_TextFieldAutoSize
#include <nme/text/TextFieldAutoSize.h>
#endif
#ifndef INCLUDED_nme_text_TextFormat
#include <nme/text/TextFormat.h>
#endif
#ifndef INCLUDED_nme_text_TextFormatAlign
#include <nme/text/TextFormatAlign.h>
#endif
namespace com{
namespace ludamix{
namespace triad{
namespace ui{

Void StyledText_obj::__construct(::nme::geom::Point center,double w,double h,::String text,::com::ludamix::triad::ui::StyledTextDef def,Dynamic selectable)
{
{
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/StyledText.hx",40)
	this->center = center;
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/StyledText.hx",41)
	this->bw = w;
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/StyledText.hx",42)
	this->bh = h;
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/StyledText.hx",44)
	super::__construct();
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/StyledText.hx",46)
	this->nmeSetWidth(this->bw);
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/StyledText.hx",47)
	this->nmeSetHeight(this->bh);

	HX_BEGIN_LOCAL_FUNC_S0(hx::LocalFunc,_Function_1_1)
	Void run(::com::ludamix::triad::ui::StyledFontDef d,Dynamic concrete){
{
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/StyledText.hx",50)
			{
::com::ludamix::triad::ui::StyledFontDef _switch_1 = (d);
				switch((_switch_1)->GetIndex()){
					case 0: {
						::String typeface = _switch_1->__Param(0);
{
							HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/StyledText.hx",52)
							concrete->__FieldRef(HX_CSTRING("embed")) = false;
							HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/StyledText.hx",52)
							concrete->__FieldRef(HX_CSTRING("typeface")) = typeface;
						}
					}
					;break;
					case 1: {
						::String typeface = _switch_1->__Param(0);
{
							HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/StyledText.hx",53)
							concrete->__FieldRef(HX_CSTRING("embed")) = true;
							HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/StyledText.hx",53)
							concrete->__FieldRef(HX_CSTRING("typeface")) = typeface;
						}
					}
					;break;
				}
			}
		}
		return null();
	}
	HX_END_LOCAL_FUNC2((void))

	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/StyledText.hx",49)
	Dynamic getFace =  Dynamic(new _Function_1_1());
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/StyledText.hx",57)
	Dynamic concrete = null();
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/StyledText.hx",59)
	{
::com::ludamix::triad::ui::StyledTextDef _switch_2 = (def);
		switch((_switch_2)->GetIndex()){
			case 0: {
				struct _Function_2_1{
					inline static Dynamic Block( ){
						hx::Anon __result = hx::Anon_obj::Create();
						__result->Add(HX_CSTRING("size") , 12.,false);
						__result->Add(HX_CSTRING("embed") , false,false);
						__result->Add(HX_CSTRING("typeface") , null(),false);
						__result->Add(HX_CSTRING("color") , ::com::ludamix::triad::tools::EColor_obj::AntiqueWhite_dyn(),false);
						__result->Add(HX_CSTRING("wordwrap") , true,false);
						__result->Add(HX_CSTRING("align") , ::com::ludamix::triad::ui::TextAlign_obj::TACenter_dyn(),false);
						__result->Add(HX_CSTRING("autosize") , ::nme::text::TextFieldAutoSize_obj::NONE_dyn(),false);
						return __result;
					}
				};
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/StyledText.hx",62)
				concrete = _Function_2_1::Block();
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/StyledText.hx",64)
				getFace(::com::ludamix::triad::ui::StyledFontDef_obj::SFSystem(HX_CSTRING("Arial")),concrete).Cast< Void >();
			}
			;break;
			case 1: {
				struct _Function_2_1{
					inline static Dynamic Block( ){
						hx::Anon __result = hx::Anon_obj::Create();
						__result->Add(HX_CSTRING("size") , 12.,false);
						__result->Add(HX_CSTRING("embed") , false,false);
						__result->Add(HX_CSTRING("typeface") , null(),false);
						__result->Add(HX_CSTRING("color") , ::com::ludamix::triad::tools::EColor_obj::AntiqueWhite_dyn(),false);
						__result->Add(HX_CSTRING("wordwrap") , true,false);
						__result->Add(HX_CSTRING("align") , ::com::ludamix::triad::ui::TextAlign_obj::TACenter_dyn(),false);
						__result->Add(HX_CSTRING("autosize") , ::nme::text::TextFieldAutoSize_obj::LEFT_dyn(),false);
						return __result;
					}
				};
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/StyledText.hx",66)
				concrete = _Function_2_1::Block();
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/StyledText.hx",68)
				getFace(::com::ludamix::triad::ui::StyledFontDef_obj::SFSystem(HX_CSTRING("Arial")),concrete).Cast< Void >();
			}
			;break;
			case 2: {
				::com::ludamix::triad::ui::TextAlign align = _switch_2->__Param(4);
				bool wordwrap = _switch_2->__Param(3);
				::com::ludamix::triad::tools::EColor color = _switch_2->__Param(2);
				::com::ludamix::triad::ui::StyledFontDef font = _switch_2->__Param(1);
				double size = _switch_2->__Param(0);
{
					struct _Function_2_1{
						inline static Dynamic Block( double &size,bool &wordwrap,::com::ludamix::triad::ui::TextAlign &align,::com::ludamix::triad::tools::EColor &color){
							hx::Anon __result = hx::Anon_obj::Create();
							__result->Add(HX_CSTRING("size") , size,false);
							__result->Add(HX_CSTRING("embed") , false,false);
							__result->Add(HX_CSTRING("typeface") , null(),false);
							__result->Add(HX_CSTRING("color") , color,false);
							__result->Add(HX_CSTRING("wordwrap") , wordwrap,false);
							__result->Add(HX_CSTRING("align") , align,false);
							__result->Add(HX_CSTRING("autosize") , ::nme::text::TextFieldAutoSize_obj::NONE_dyn(),false);
							return __result;
						}
					};
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/StyledText.hx",70)
					concrete = _Function_2_1::Block(size,wordwrap,align,color);
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/StyledText.hx",72)
					getFace(font,concrete).Cast< Void >();
				}
			}
			;break;
			case 3: {
				::nme::text::TextFieldAutoSize autosize = _switch_2->__Param(5);
				::com::ludamix::triad::ui::TextAlign align = _switch_2->__Param(4);
				bool wordwrap = _switch_2->__Param(3);
				::com::ludamix::triad::tools::EColor color = _switch_2->__Param(2);
				::com::ludamix::triad::ui::StyledFontDef font = _switch_2->__Param(1);
				double size = _switch_2->__Param(0);
{
					struct _Function_2_1{
						inline static Dynamic Block( double &size,bool &wordwrap,::com::ludamix::triad::ui::TextAlign &align,::com::ludamix::triad::tools::EColor &color,::nme::text::TextFieldAutoSize &autosize){
							hx::Anon __result = hx::Anon_obj::Create();
							__result->Add(HX_CSTRING("size") , size,false);
							__result->Add(HX_CSTRING("embed") , false,false);
							__result->Add(HX_CSTRING("typeface") , null(),false);
							__result->Add(HX_CSTRING("color") , color,false);
							__result->Add(HX_CSTRING("wordwrap") , wordwrap,false);
							__result->Add(HX_CSTRING("align") , align,false);
							__result->Add(HX_CSTRING("autosize") , autosize,false);
							return __result;
						}
					};
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/StyledText.hx",74)
					concrete = _Function_2_1::Block(size,wordwrap,align,color,autosize);
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/StyledText.hx",76)
					getFace(font,concrete).Cast< Void >();
				}
			}
			;break;
		}
	}
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/StyledText.hx",79)
	this->nmeSetEmbedFonts(concrete->__Field(HX_CSTRING("embed")));
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/StyledText.hx",80)
	::nme::text::TextFormat tf = ::nme::text::TextFormat_obj::__new(null(),null(),null(),null(),null(),null(),null(),null(),null(),null(),null(),null(),null());
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/StyledText.hx",81)
	tf->color = ::com::ludamix::triad::tools::Color_obj::get(concrete->__Field(HX_CSTRING("color")));
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/StyledText.hx",82)
	tf->font = concrete->__Field(HX_CSTRING("typeface"));
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/StyledText.hx",83)
	tf->size = concrete->__Field(HX_CSTRING("size"));
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/StyledText.hx",84)
	{
::com::ludamix::triad::ui::TextAlign _switch_3 = (concrete->__Field(HX_CSTRING("align")));
		switch((_switch_3)->GetIndex()){
			case 0: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/StyledText.hx",86)
				tf->align = ::nme::text::TextFormatAlign_obj::LEFT;
			}
			;break;
			case 1: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/StyledText.hx",87)
				tf->align = ::nme::text::TextFormatAlign_obj::RIGHT;
			}
			;break;
			case 2: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/StyledText.hx",88)
				tf->align = ::nme::text::TextFormatAlign_obj::CENTER;
			}
			;break;
			case 3: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/StyledText.hx",89)
				tf->align = ::nme::text::TextFormatAlign_obj::JUSTIFY;
			}
			;break;
		}
	}
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/StyledText.hx",91)
	this->nmeSetDefaultTextFormat(tf);
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/StyledText.hx",92)
	this->nmeSetWordWrap(concrete->__Field(HX_CSTRING("wordwrap")));
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/StyledText.hx",93)
	this->nmeSetText(text);
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/StyledText.hx",94)
	if ((selectable)){
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/StyledText.hx",96)
		this->nmeSetSelectable(true);
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/StyledText.hx",97)
		this->nmeSetMouseEnabled(true);
	}
	else{
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/StyledText.hx",101)
		this->nmeSetSelectable(false);
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/StyledText.hx",102)
		this->nmeSetMouseEnabled(false);
	}
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/StyledText.hx",104)
	this->nmeSetAutoSize(concrete->__Field(HX_CSTRING("autosize")));
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/StyledText.hx",106)
	this->reposition();
}
;
	return null();
}

StyledText_obj::~StyledText_obj() { }

Dynamic StyledText_obj::__CreateEmpty() { return  new StyledText_obj; }
hx::ObjectPtr< StyledText_obj > StyledText_obj::__new(::nme::geom::Point center,double w,double h,::String text,::com::ludamix::triad::ui::StyledTextDef def,Dynamic selectable)
{  hx::ObjectPtr< StyledText_obj > result = new StyledText_obj();
	result->__construct(center,w,h,text,def,selectable);
	return result;}

Dynamic StyledText_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< StyledText_obj > result = new StyledText_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2],inArgs[3],inArgs[4],inArgs[5]);
	return result;}

Void StyledText_obj::reposition( ){
{
		HX_SOURCE_PUSH("StyledText_obj::reposition")
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/StyledText.hx",111)
		this->nmeSetX((this->center->x - (double(this->bw) / double((int)2))));
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/StyledText.hx",112)
		this->nmeSetY((this->center->y - (double(this->bh) / double((int)2))));
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(StyledText_obj,reposition,(void))

::com::ludamix::triad::ui::StyledText StyledText_obj::topleft( ::nme::geom::Point tl,double w,double h,::String text,::com::ludamix::triad::ui::StyledTextDef def){
	HX_SOURCE_PUSH("StyledText_obj::topleft")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/StyledText.hx",19)
	return ::com::ludamix::triad::ui::StyledText_obj::__new(::nme::geom::Point_obj::__new((tl->x + (double(w) / double((int)2))),(tl->y + (double(h) / double((int)2)))),w,h,text,def,null());
}


STATIC_HX_DEFINE_DYNAMIC_FUNC5(StyledText_obj,topleft,return )

::com::ludamix::triad::ui::StyledText StyledText_obj::bottomleft( ::nme::geom::Point bl,double w,double h,::String text,::com::ludamix::triad::ui::StyledTextDef def){
	HX_SOURCE_PUSH("StyledText_obj::bottomleft")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/StyledText.hx",24)
	return ::com::ludamix::triad::ui::StyledText_obj::__new(::nme::geom::Point_obj::__new((bl->x + (double(w) / double((int)2))),(bl->y - (double(h) / double((int)2)))),w,h,text,def,null());
}


STATIC_HX_DEFINE_DYNAMIC_FUNC5(StyledText_obj,bottomleft,return )

::com::ludamix::triad::ui::StyledText StyledText_obj::bottomright( ::nme::geom::Point br,double w,double h,::String text,::com::ludamix::triad::ui::StyledTextDef def){
	HX_SOURCE_PUSH("StyledText_obj::bottomright")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/StyledText.hx",29)
	return ::com::ludamix::triad::ui::StyledText_obj::__new(::nme::geom::Point_obj::__new((br->x - (double(w) / double((int)2))),(br->y - (double(h) / double((int)2)))),w,h,text,def,null());
}


STATIC_HX_DEFINE_DYNAMIC_FUNC5(StyledText_obj,bottomright,return )

::com::ludamix::triad::ui::StyledText StyledText_obj::topright( ::nme::geom::Point br,double w,double h,::String text,::com::ludamix::triad::ui::StyledTextDef def){
	HX_SOURCE_PUSH("StyledText_obj::topright")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/StyledText.hx",34)
	return ::com::ludamix::triad::ui::StyledText_obj::__new(::nme::geom::Point_obj::__new((br->x - (double(w) / double((int)2))),(br->y + (double(h) / double((int)2)))),w,h,text,def,null());
}


STATIC_HX_DEFINE_DYNAMIC_FUNC5(StyledText_obj,topright,return )


StyledText_obj::StyledText_obj()
{
}

void StyledText_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(StyledText);
	HX_MARK_MEMBER_NAME(center,"center");
	HX_MARK_MEMBER_NAME(bw,"bw");
	HX_MARK_MEMBER_NAME(bh,"bh");
	super::__Mark(HX_MARK_ARG);
	HX_MARK_END_CLASS();
}

Dynamic StyledText_obj::__Field(const ::String &inName)
{
	switch(inName.length) {
	case 2:
		if (HX_FIELD_EQ(inName,"bw") ) { return bw; }
		if (HX_FIELD_EQ(inName,"bh") ) { return bh; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"center") ) { return center; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"topleft") ) { return topleft_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"topright") ) { return topright_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"bottomleft") ) { return bottomleft_dyn(); }
		if (HX_FIELD_EQ(inName,"reposition") ) { return reposition_dyn(); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"bottomright") ) { return bottomright_dyn(); }
	}
	return super::__Field(inName);
}

Dynamic StyledText_obj::__SetField(const ::String &inName,const Dynamic &inValue)
{
	switch(inName.length) {
	case 2:
		if (HX_FIELD_EQ(inName,"bw") ) { bw=inValue.Cast< double >(); return inValue; }
		if (HX_FIELD_EQ(inName,"bh") ) { bh=inValue.Cast< double >(); return inValue; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"center") ) { center=inValue.Cast< ::nme::geom::Point >(); return inValue; }
	}
	return super::__SetField(inName,inValue);
}

void StyledText_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("center"));
	outFields->push(HX_CSTRING("bw"));
	outFields->push(HX_CSTRING("bh"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("topleft"),
	HX_CSTRING("bottomleft"),
	HX_CSTRING("bottomright"),
	HX_CSTRING("topright"),
	String(null()) };

static ::String sMemberFields[] = {
	HX_CSTRING("center"),
	HX_CSTRING("bw"),
	HX_CSTRING("bh"),
	HX_CSTRING("reposition"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
};

Class StyledText_obj::__mClass;

void StyledText_obj::__register()
{
	Static(__mClass) = hx::RegisterClass(HX_CSTRING("com.ludamix.triad.ui.StyledText"), hx::TCanCast< StyledText_obj> ,sStaticFields,sMemberFields,
	&__CreateEmpty, &__Create,
	&super::__SGetClass(), 0, sMarkStatics);
}

void StyledText_obj::__boot()
{
}

} // end namespace com
} // end namespace ludamix
} // end namespace triad
} // end namespace ui
