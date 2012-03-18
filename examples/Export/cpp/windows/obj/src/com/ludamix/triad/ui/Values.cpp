#include <hxcpp.h>

#ifndef INCLUDED_com_ludamix_triad_tools_Color
#include <com/ludamix/triad/tools/Color.h>
#endif
#ifndef INCLUDED_com_ludamix_triad_tools_EColor
#include <com/ludamix/triad/tools/EColor.h>
#endif
#ifndef INCLUDED_com_ludamix_triad_ui_BorderDef
#include <com/ludamix/triad/ui/BorderDef.h>
#endif
#ifndef INCLUDED_com_ludamix_triad_ui_HighlightingColorDef
#include <com/ludamix/triad/ui/HighlightingColorDef.h>
#endif
#ifndef INCLUDED_com_ludamix_triad_ui_Values
#include <com/ludamix/triad/ui/Values.h>
#endif
namespace com{
namespace ludamix{
namespace triad{
namespace ui{

Void Values_obj::__construct()
{
	return null();
}

Values_obj::~Values_obj() { }

Dynamic Values_obj::__CreateEmpty() { return  new Values_obj; }
hx::ObjectPtr< Values_obj > Values_obj::__new()
{  hx::ObjectPtr< Values_obj > result = new Values_obj();
	result->__construct();
	return result;}

Dynamic Values_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Values_obj > result = new Values_obj();
	result->__construct();
	return result;}

Dynamic Values_obj::highlightingColor( ::com::ludamix::triad::ui::HighlightingColorDef hc){
	HX_SOURCE_PUSH("Values_obj::highlightingColor")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Values.hx",8)
	{
::com::ludamix::triad::ui::HighlightingColorDef _switch_1 = (hc);
		switch((_switch_1)->GetIndex()){
			case 0: {
				struct _Function_2_1{
					inline static Dynamic Block( ){
						hx::Anon __result = hx::Anon_obj::Create();
						__result->Add(HX_CSTRING("off") , ::com::ludamix::triad::tools::Color_obj::get(::com::ludamix::triad::tools::EColor_obj::DarkSlateGray_dyn()),false);
						__result->Add(HX_CSTRING("highlighted") , ::com::ludamix::triad::tools::Color_obj::get(::com::ludamix::triad::tools::EColor_obj::SlateGray_dyn()),false);
						__result->Add(HX_CSTRING("down") , ::com::ludamix::triad::tools::Color_obj::get(::com::ludamix::triad::tools::EColor_obj::Black_dyn()),false);
						return __result;
					}
				};
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Values.hx",11)
				return _Function_2_1::Block();
			}
			;break;
			case 1: {
				double strength = _switch_1->__Param(1);
				::com::ludamix::triad::tools::EColor primary = _switch_1->__Param(0);
{
					struct _Function_2_1{
						inline static Dynamic Block( ::com::ludamix::triad::tools::EColor &primary,double &strength){
							hx::Anon __result = hx::Anon_obj::Create();
							__result->Add(HX_CSTRING("off") , ::com::ludamix::triad::tools::Color_obj::getShifted(primary,(int)0,(int)0,(int)0),false);
							__result->Add(HX_CSTRING("highlighted") , ::com::ludamix::triad::tools::Color_obj::getShifted(primary,strength,(int)0,(int)0),false);
							__result->Add(HX_CSTRING("down") , ::com::ludamix::triad::tools::Color_obj::getShifted(primary,-(strength),(int)0,(int)0),false);
							return __result;
						}
					};
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Values.hx",13)
					return _Function_2_1::Block(primary,strength);
				}
			}
			;break;
			case 2: {
				double strength = _switch_1->__Param(1);
				::com::ludamix::triad::tools::EColor primary = _switch_1->__Param(0);
{
					struct _Function_2_1{
						inline static Dynamic Block( ::com::ludamix::triad::tools::EColor &primary,double &strength){
							hx::Anon __result = hx::Anon_obj::Create();
							__result->Add(HX_CSTRING("off") , ::com::ludamix::triad::tools::Color_obj::getShifted(primary,(int)0,(int)0,(int)0),false);
							__result->Add(HX_CSTRING("highlighted") , ::com::ludamix::triad::tools::Color_obj::getShifted(primary,(int)0,strength,(int)0),false);
							__result->Add(HX_CSTRING("down") , ::com::ludamix::triad::tools::Color_obj::getShifted(primary,(int)0,-(strength),(int)0),false);
							return __result;
						}
					};
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Values.hx",18)
					return _Function_2_1::Block(primary,strength);
				}
			}
			;break;
			case 3: {
				double strength = _switch_1->__Param(1);
				::com::ludamix::triad::tools::EColor primary = _switch_1->__Param(0);
{
					struct _Function_2_1{
						inline static Dynamic Block( ::com::ludamix::triad::tools::EColor &primary,double &strength){
							hx::Anon __result = hx::Anon_obj::Create();
							__result->Add(HX_CSTRING("off") , ::com::ludamix::triad::tools::Color_obj::getShifted(primary,(int)0,(int)0,(int)0),false);
							__result->Add(HX_CSTRING("highlighted") , ::com::ludamix::triad::tools::Color_obj::getShifted(primary,(int)0,(int)0,strength),false);
							__result->Add(HX_CSTRING("down") , ::com::ludamix::triad::tools::Color_obj::getShifted(primary,(int)0,(int)0,-(strength)),false);
							return __result;
						}
					};
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Values.hx",23)
					return _Function_2_1::Block(primary,strength);
				}
			}
			;break;
			case 4: {
				double strength = _switch_1->__Param(1);
				::com::ludamix::triad::tools::EColor primary = _switch_1->__Param(0);
{
					struct _Function_2_1{
						inline static Dynamic Block( ::com::ludamix::triad::tools::EColor &primary,double &strength){
							hx::Anon __result = hx::Anon_obj::Create();
							__result->Add(HX_CSTRING("off") , ::com::ludamix::triad::tools::Color_obj::getShifted(primary,(int)0,(int)0,(int)0),false);
							__result->Add(HX_CSTRING("highlighted") , ::com::ludamix::triad::tools::Color_obj::getShifted(primary,strength,strength,(int)0),false);
							__result->Add(HX_CSTRING("down") , ::com::ludamix::triad::tools::Color_obj::getShifted(primary,-(strength),-(strength),(int)0),false);
							return __result;
						}
					};
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Values.hx",28)
					return _Function_2_1::Block(primary,strength);
				}
			}
			;break;
			case 6: {
				double strength = _switch_1->__Param(1);
				::com::ludamix::triad::tools::EColor primary = _switch_1->__Param(0);
{
					struct _Function_2_1{
						inline static Dynamic Block( ::com::ludamix::triad::tools::EColor &primary,double &strength){
							hx::Anon __result = hx::Anon_obj::Create();
							__result->Add(HX_CSTRING("off") , ::com::ludamix::triad::tools::Color_obj::getShifted(primary,(int)0,(int)0,(int)0),false);
							__result->Add(HX_CSTRING("highlighted") , ::com::ludamix::triad::tools::Color_obj::getShifted(primary,(int)0,strength,strength),false);
							__result->Add(HX_CSTRING("down") , ::com::ludamix::triad::tools::Color_obj::getShifted(primary,(int)0,-(strength),-(strength)),false);
							return __result;
						}
					};
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Values.hx",33)
					return _Function_2_1::Block(primary,strength);
				}
			}
			;break;
			case 5: {
				double strength = _switch_1->__Param(1);
				::com::ludamix::triad::tools::EColor primary = _switch_1->__Param(0);
{
					struct _Function_2_1{
						inline static Dynamic Block( ::com::ludamix::triad::tools::EColor &primary,double &strength){
							hx::Anon __result = hx::Anon_obj::Create();
							__result->Add(HX_CSTRING("off") , ::com::ludamix::triad::tools::Color_obj::getShifted(primary,(int)0,(int)0,(int)0),false);
							__result->Add(HX_CSTRING("highlighted") , ::com::ludamix::triad::tools::Color_obj::getShifted(primary,strength,(int)0,strength),false);
							__result->Add(HX_CSTRING("down") , ::com::ludamix::triad::tools::Color_obj::getShifted(primary,-(strength),(int)0,-(strength)),false);
							return __result;
						}
					};
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Values.hx",38)
					return _Function_2_1::Block(primary,strength);
				}
			}
			;break;
			case 7: {
				double strength = _switch_1->__Param(1);
				::com::ludamix::triad::tools::EColor primary = _switch_1->__Param(0);
{
					struct _Function_2_1{
						inline static Dynamic Block( ::com::ludamix::triad::tools::EColor &primary,double &strength){
							hx::Anon __result = hx::Anon_obj::Create();
							__result->Add(HX_CSTRING("off") , ::com::ludamix::triad::tools::Color_obj::getShifted(primary,(int)0,(int)0,(int)0),false);
							__result->Add(HX_CSTRING("highlighted") , ::com::ludamix::triad::tools::Color_obj::getShifted(primary,strength,strength,strength),false);
							__result->Add(HX_CSTRING("down") , ::com::ludamix::triad::tools::Color_obj::getShifted(primary,-(strength),-(strength),-(strength)),false);
							return __result;
						}
					};
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Values.hx",43)
					return _Function_2_1::Block(primary,strength);
				}
			}
			;break;
			case 8: {
				::com::ludamix::triad::tools::EColor down = _switch_1->__Param(2);
				::com::ludamix::triad::tools::EColor highlighted = _switch_1->__Param(1);
				::com::ludamix::triad::tools::EColor off = _switch_1->__Param(0);
{
					struct _Function_2_1{
						inline static Dynamic Block( ::com::ludamix::triad::tools::EColor &highlighted,::com::ludamix::triad::tools::EColor &down,::com::ludamix::triad::tools::EColor &off){
							hx::Anon __result = hx::Anon_obj::Create();
							__result->Add(HX_CSTRING("off") , ::com::ludamix::triad::tools::Color_obj::get(off),false);
							__result->Add(HX_CSTRING("highlighted") , ::com::ludamix::triad::tools::Color_obj::get(highlighted),false);
							__result->Add(HX_CSTRING("down") , ::com::ludamix::triad::tools::Color_obj::get(down),false);
							return __result;
						}
					};
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Values.hx",48)
					return _Function_2_1::Block(highlighted,down,off);
				}
			}
			;break;
			case 9: {
				::com::ludamix::triad::tools::EColor down = _switch_1->__Param(1);
				::com::ludamix::triad::tools::EColor off = _switch_1->__Param(0);
{
					struct _Function_2_1{
						inline static Dynamic Block( ::com::ludamix::triad::tools::EColor &off,::com::ludamix::triad::tools::EColor &down){
							hx::Anon __result = hx::Anon_obj::Create();
							__result->Add(HX_CSTRING("off") , ::com::ludamix::triad::tools::Color_obj::get(off),false);
							__result->Add(HX_CSTRING("highlighted") , ::com::ludamix::triad::tools::Color_obj::get(off),false);
							__result->Add(HX_CSTRING("down") , ::com::ludamix::triad::tools::Color_obj::get(down),false);
							return __result;
						}
					};
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Values.hx",53)
					return _Function_2_1::Block(off,down);
				}
			}
			;break;
			case 10: {
				::com::ludamix::triad::tools::EColor c = _switch_1->__Param(0);
{
					struct _Function_2_1{
						inline static Dynamic Block( ::com::ludamix::triad::tools::EColor &c){
							hx::Anon __result = hx::Anon_obj::Create();
							__result->Add(HX_CSTRING("off") , ::com::ludamix::triad::tools::Color_obj::get(c),false);
							__result->Add(HX_CSTRING("highlighted") , ::com::ludamix::triad::tools::Color_obj::get(c),false);
							__result->Add(HX_CSTRING("down") , ::com::ludamix::triad::tools::Color_obj::get(c),false);
							return __result;
						}
					};
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Values.hx",58)
					return _Function_2_1::Block(c);
				}
			}
			;break;
		}
	}
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Values_obj,highlightingColor,return )

Dynamic Values_obj::border( ::com::ludamix::triad::ui::BorderDef b){
	HX_SOURCE_PUSH("Values_obj::border")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Values.hx",67)
	{
::com::ludamix::triad::ui::BorderDef _switch_2 = (b);
		switch((_switch_2)->GetIndex()){
			case 0: {
				struct _Function_2_1{
					inline static Dynamic Block( ){
						hx::Anon __result = hx::Anon_obj::Create();
						__result->Add(HX_CSTRING("color") , ::com::ludamix::triad::ui::Values_obj::highlightingColor(::com::ludamix::triad::ui::HighlightingColorDef_obj::HCHueSatValShift(::com::ludamix::triad::tools::EColor_obj::LightSeaGreen_dyn(),0.1)),false);
						__result->Add(HX_CSTRING("thickness") , 2.,false);
						return __result;
					}
				};
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Values.hx",70)
				return _Function_2_1::Block();
			}
			;break;
			case 1: {
				::com::ludamix::triad::tools::EColor col = _switch_2->__Param(0);
{
					struct _Function_2_1{
						inline static Dynamic Block( ::com::ludamix::triad::tools::EColor &col){
							hx::Anon __result = hx::Anon_obj::Create();
							__result->Add(HX_CSTRING("color") , ::com::ludamix::triad::ui::Values_obj::highlightingColor(::com::ludamix::triad::ui::HighlightingColorDef_obj::HCMono(col)),false);
							__result->Add(HX_CSTRING("thickness") , 2.,false);
							return __result;
						}
					};
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Values.hx",71)
					return _Function_2_1::Block(col);
				}
			}
			;break;
			case 2: {
				double thickness = _switch_2->__Param(1);
				::com::ludamix::triad::tools::EColor col = _switch_2->__Param(0);
{
					struct _Function_2_1{
						inline static Dynamic Block( ::com::ludamix::triad::tools::EColor &col,double &thickness){
							hx::Anon __result = hx::Anon_obj::Create();
							__result->Add(HX_CSTRING("color") , ::com::ludamix::triad::ui::Values_obj::highlightingColor(::com::ludamix::triad::ui::HighlightingColorDef_obj::HCMono(col)),false);
							__result->Add(HX_CSTRING("thickness") , thickness,false);
							return __result;
						}
					};
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Values.hx",72)
					return _Function_2_1::Block(col,thickness);
				}
			}
			;break;
			case 3: {
				double thickness = _switch_2->__Param(1);
				::com::ludamix::triad::ui::HighlightingColorDef col = _switch_2->__Param(0);
{
					struct _Function_2_1{
						inline static Dynamic Block( ::com::ludamix::triad::ui::HighlightingColorDef &col,double &thickness){
							hx::Anon __result = hx::Anon_obj::Create();
							__result->Add(HX_CSTRING("color") , ::com::ludamix::triad::ui::Values_obj::highlightingColor(col),false);
							__result->Add(HX_CSTRING("thickness") , thickness,false);
							return __result;
						}
					};
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Values.hx",73)
					return _Function_2_1::Block(col,thickness);
				}
			}
			;break;
		}
	}
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Values_obj,border,return )


Values_obj::Values_obj()
{
}

void Values_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Values);
	HX_MARK_END_CLASS();
}

Dynamic Values_obj::__Field(const ::String &inName)
{
	switch(inName.length) {
	case 6:
		if (HX_FIELD_EQ(inName,"border") ) { return border_dyn(); }
		break;
	case 17:
		if (HX_FIELD_EQ(inName,"highlightingColor") ) { return highlightingColor_dyn(); }
	}
	return super::__Field(inName);
}

Dynamic Values_obj::__SetField(const ::String &inName,const Dynamic &inValue)
{
	return super::__SetField(inName,inValue);
}

void Values_obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("highlightingColor"),
	HX_CSTRING("border"),
	String(null()) };

static ::String sMemberFields[] = {
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
};

Class Values_obj::__mClass;

void Values_obj::__register()
{
	Static(__mClass) = hx::RegisterClass(HX_CSTRING("com.ludamix.triad.ui.Values"), hx::TCanCast< Values_obj> ,sStaticFields,sMemberFields,
	&__CreateEmpty, &__Create,
	&super::__SGetClass(), 0, sMarkStatics);
}

void Values_obj::__boot()
{
}

} // end namespace com
} // end namespace ludamix
} // end namespace triad
} // end namespace ui
