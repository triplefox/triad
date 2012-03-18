#include <hxcpp.h>

#ifndef INCLUDED_hxMath
#include <hxMath.h>
#endif
#ifndef INCLUDED_Std
#include <Std.h>
#endif
#ifndef INCLUDED_com_ludamix_triad_tools_Color
#include <com/ludamix/triad/tools/Color.h>
#endif
#ifndef INCLUDED_com_ludamix_triad_tools_EColor
#include <com/ludamix/triad/tools/EColor.h>
#endif
namespace com{
namespace ludamix{
namespace triad{
namespace tools{

Void Color_obj::__construct()
{
	return null();
}

Color_obj::~Color_obj() { }

Dynamic Color_obj::__CreateEmpty() { return  new Color_obj; }
hx::ObjectPtr< Color_obj > Color_obj::__new()
{  hx::ObjectPtr< Color_obj > result = new Color_obj();
	result->__construct();
	return result;}

Dynamic Color_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Color_obj > result = new Color_obj();
	result->__construct();
	return result;}

int Color_obj::ARGB( int rgb,int alpha){
	HX_SOURCE_PUSH("Color_obj::ARGB")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",9)
	return (((int(alpha) << int((int)24))) + rgb);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Color_obj,ARGB,return )

int Color_obj::RGBofARGB( int argb){
	HX_SOURCE_PUSH("Color_obj::RGBofARGB")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",18)
	return (int(argb) | int((int)-16777216));
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Color_obj,RGBofARGB,return )

Dynamic Color_obj::RGBPx( int value){
	HX_SOURCE_PUSH("Color_obj::RGBPx")
	struct _Function_1_1{
		inline static Dynamic Block( int &value){
			hx::Anon __result = hx::Anon_obj::Create();
			__result->Add(HX_CSTRING("r") , (int(value) >> int((int)16)),false);
			__result->Add(HX_CSTRING("g") , (int((int(value) >> int((int)8))) & int((int)255)),false);
			__result->Add(HX_CSTRING("b") , (int(value) & int((int)255)),false);
			return __result;
		}
	};
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",27)
	return _Function_1_1::Block(value);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Color_obj,RGBPx,return )

int Color_obj::RGBred( int value){
	HX_SOURCE_PUSH("Color_obj::RGBred")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",29)
	return (int(value) >> int((int)16));
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Color_obj,RGBred,return )

int Color_obj::RGBgreen( int value){
	HX_SOURCE_PUSH("Color_obj::RGBgreen")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",31)
	return (int((int(value) >> int((int)8))) & int((int)255));
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Color_obj,RGBgreen,return )

int Color_obj::RGBblue( int value){
	HX_SOURCE_PUSH("Color_obj::RGBblue")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",33)
	return (int(value) & int((int)255));
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Color_obj,RGBblue,return )

int Color_obj::buildRGB( int r,int g,int b){
	HX_SOURCE_PUSH("Color_obj::buildRGB")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",36)
	return ((((int(r) << int((int)16))) + ((int(g) << int((int)8)))) + b);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(Color_obj,buildRGB,return )

Void Color_obj::RGBtoHSV( Dynamic RGB,Dynamic HSV){
{
		HX_SOURCE_PUSH("Color_obj::RGBtoHSV")
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",40)
		double r = (double(RGB->__Field(HX_CSTRING("r"))) / double(255.));
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",40)
		double g = (double(RGB->__Field(HX_CSTRING("g"))) / double(255.));
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",40)
		double b = (double(RGB->__Field(HX_CSTRING("b"))) / double(255.));
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",41)
		double minVal = ::Math_obj::min(::Math_obj::min(r,g),b);
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",42)
		double maxVal = ::Math_obj::max(::Math_obj::max(r,g),b);
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",43)
		double delta = (maxVal - minVal);
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",44)
		HSV->__FieldRef(HX_CSTRING("v")) = maxVal;
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",45)
		if (((delta == (int)0))){
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",46)
			HSV->__FieldRef(HX_CSTRING("h")) = (int)0;
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",47)
			HSV->__FieldRef(HX_CSTRING("s")) = (int)0;
		}
		else{
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",49)
			HSV->__FieldRef(HX_CSTRING("s")) = (double(delta) / double(maxVal));
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",50)
			double del_R = (double((((double(((maxVal - r))) / double(6.)) + (double(delta) / double(2.))))) / double(delta));
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",51)
			double del_G = (double((((double(((maxVal - g))) / double(6.)) + (double(delta) / double(2.))))) / double(delta));
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",52)
			double del_B = (double((((double(((maxVal - b))) / double(6.)) + (double(delta) / double(2.))))) / double(delta));
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",54)
			if (((r == maxVal))){
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",54)
				HSV->__FieldRef(HX_CSTRING("h")) = (del_B - del_G);
			}
			else{
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",55)
				if (((g == maxVal))){
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",55)
					HSV->__FieldRef(HX_CSTRING("h")) = (((double((int)1) / double((int)3)) + del_R) - del_B);
				}
				else{
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",56)
					if (((b == maxVal))){
						HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",56)
						HSV->__FieldRef(HX_CSTRING("h")) = (((double((int)2) / double((int)3)) + del_G) - del_R);
					}
				}
			}
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",58)
			if (((HSV->__Field(HX_CSTRING("h")) < (int)0))){
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",58)
				hx::AddEq(HSV->__FieldRef(HX_CSTRING("h")),(int)1);
			}
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",59)
			if (((HSV->__Field(HX_CSTRING("h")) > (int)1))){
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",59)
				hx::SubEq(HSV->__FieldRef(HX_CSTRING("h")),(int)1);
			}
		}
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Color_obj,RGBtoHSV,(void))

Void Color_obj::HSVtoRGB( Dynamic HSV,Dynamic RGB){
{
		HX_SOURCE_PUSH("Color_obj::HSVtoRGB")
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",67)
		double h = HSV->__Field(HX_CSTRING("h"));
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",67)
		double s = HSV->__Field(HX_CSTRING("s"));
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",67)
		double v = HSV->__Field(HX_CSTRING("v"));
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",69)
		if (((s == (int)0))){
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",70)
			RGB->__FieldRef(HX_CSTRING("r")) = ::Std_obj::_int((v * (int)255));
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",71)
			RGB->__FieldRef(HX_CSTRING("g")) = ::Std_obj::_int((v * (int)255));
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",72)
			RGB->__FieldRef(HX_CSTRING("b")) = ::Std_obj::_int((v * (int)255));
		}
		else{
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",75)
			double var_h = (h * (int)6);
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",76)
			int var_i = ::Std_obj::_int(var_h);
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",77)
			double var_1 = (v * ((1. - s)));
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",78)
			double var_2 = (v * ((1. - (s * ((var_h - var_i))))));
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",79)
			double var_3 = (v * ((1. - (s * (((int)1 - ((var_h - var_i))))))));
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",80)
			double var_r = 0.;
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",81)
			double var_g = 0.;
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",82)
			double var_b = 0.;
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",84)
			if (((var_i == (int)0))){
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",84)
				var_r = v;
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",84)
				var_g = var_3;
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",84)
				var_b = var_1;
			}
			else{
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",85)
				if (((var_i == (int)1))){
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",85)
					var_r = var_2;
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",85)
					var_g = v;
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",85)
					var_b = var_1;
				}
				else{
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",86)
					if (((var_i == (int)2))){
						HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",86)
						var_r = var_1;
						HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",86)
						var_g = v;
						HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",86)
						var_b = var_3;
					}
					else{
						HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",87)
						if (((var_i == (int)3))){
							HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",87)
							var_r = var_1;
							HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",87)
							var_g = var_2;
							HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",87)
							var_b = v;
						}
						else{
							HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",88)
							if (((var_i == (int)4))){
								HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",88)
								var_r = var_3;
								HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",88)
								var_g = var_1;
								HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",88)
								var_b = v;
							}
							else{
								HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",89)
								var_r = v;
								HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",89)
								var_g = var_1;
								HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",89)
								var_b = var_2;
							}
						}
					}
				}
			}
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",91)
			RGB->__FieldRef(HX_CSTRING("r")) = ::Std_obj::_int((var_r * (int)255));
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",92)
			RGB->__FieldRef(HX_CSTRING("g")) = ::Std_obj::_int((var_g * (int)255));
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",93)
			RGB->__FieldRef(HX_CSTRING("b")) = ::Std_obj::_int((var_b * (int)255));
		}
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Color_obj,HSVtoRGB,(void))

int Color_obj::getShifted( ::com::ludamix::triad::tools::EColor c,double hShift,double sShift,double vShift){
	HX_SOURCE_PUSH("Color_obj::getShifted")
	struct _Function_1_1{
		inline static Dynamic Block( ){
			hx::Anon __result = hx::Anon_obj::Create();
			__result->Add(HX_CSTRING("h") , 0.,false);
			__result->Add(HX_CSTRING("s") , 0.,false);
			__result->Add(HX_CSTRING("v") , 0.,false);
			return __result;
		}
	};
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",99)
	Dynamic hsv = _Function_1_1::Block();
	struct _Function_1_2{
		inline static Dynamic Block( ::com::ludamix::triad::tools::EColor &c){
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",100)
			int value = ::com::ludamix::triad::tools::Color_obj::get(c);
			struct _Function_2_1{
				inline static Dynamic Block( int &value){
					hx::Anon __result = hx::Anon_obj::Create();
					__result->Add(HX_CSTRING("r") , (int(value) >> int((int)16)),false);
					__result->Add(HX_CSTRING("g") , (int((int(value) >> int((int)8))) & int((int)255)),false);
					__result->Add(HX_CSTRING("b") , (int(value) & int((int)255)),false);
					return __result;
				}
			};
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",100)
			return _Function_2_1::Block(value);
		}
	};
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",100)
	Dynamic rgb = _Function_1_2::Block(c);
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",101)
	{
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",101)
		double r = (double(rgb->__Field(HX_CSTRING("r"))) / double(255.));
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",101)
		double g = (double(rgb->__Field(HX_CSTRING("g"))) / double(255.));
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",101)
		double b = (double(rgb->__Field(HX_CSTRING("b"))) / double(255.));
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",101)
		double minVal = ::Math_obj::min(::Math_obj::min(r,g),b);
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",101)
		double maxVal = ::Math_obj::max(::Math_obj::max(r,g),b);
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",101)
		double delta = (maxVal - minVal);
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",101)
		hsv->__FieldRef(HX_CSTRING("v")) = maxVal;
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",101)
		if (((delta == (int)0))){
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",101)
			hsv->__FieldRef(HX_CSTRING("h")) = (int)0;
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",101)
			hsv->__FieldRef(HX_CSTRING("s")) = (int)0;
		}
		else{
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",101)
			hsv->__FieldRef(HX_CSTRING("s")) = (double(delta) / double(maxVal));
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",101)
			double del_R = (double((((double(((maxVal - r))) / double(6.)) + (double(delta) / double(2.))))) / double(delta));
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",101)
			double del_G = (double((((double(((maxVal - g))) / double(6.)) + (double(delta) / double(2.))))) / double(delta));
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",101)
			double del_B = (double((((double(((maxVal - b))) / double(6.)) + (double(delta) / double(2.))))) / double(delta));
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",101)
			if (((r == maxVal))){
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",101)
				hsv->__FieldRef(HX_CSTRING("h")) = (del_B - del_G);
			}
			else{
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",101)
				if (((g == maxVal))){
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",101)
					hsv->__FieldRef(HX_CSTRING("h")) = (((double((int)1) / double((int)3)) + del_R) - del_B);
				}
				else{
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",101)
					if (((b == maxVal))){
						HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",101)
						hsv->__FieldRef(HX_CSTRING("h")) = (((double((int)2) / double((int)3)) + del_G) - del_R);
					}
				}
			}
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",101)
			if (((hsv->__Field(HX_CSTRING("h")) < (int)0))){
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",101)
				hx::AddEq(hsv->__FieldRef(HX_CSTRING("h")),(int)1);
			}
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",101)
			if (((hsv->__Field(HX_CSTRING("h")) > (int)1))){
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",101)
				hx::SubEq(hsv->__FieldRef(HX_CSTRING("h")),(int)1);
			}
		}
	}
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",102)
	hx::AddEq(hsv->__FieldRef(HX_CSTRING("v")),vShift);
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",103)
	hx::AddEq(hsv->__FieldRef(HX_CSTRING("s")),sShift);
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",104)
	hx::AddEq(hsv->__FieldRef(HX_CSTRING("h")),hShift);
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",105)
	{
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",105)
		double h = hsv->__Field(HX_CSTRING("h"));
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",105)
		double s = hsv->__Field(HX_CSTRING("s"));
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",105)
		double v = hsv->__Field(HX_CSTRING("v"));
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",105)
		if (((s == (int)0))){
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",105)
			rgb->__FieldRef(HX_CSTRING("r")) = ::Std_obj::_int((v * (int)255));
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",105)
			rgb->__FieldRef(HX_CSTRING("g")) = ::Std_obj::_int((v * (int)255));
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",105)
			rgb->__FieldRef(HX_CSTRING("b")) = ::Std_obj::_int((v * (int)255));
		}
		else{
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",105)
			double var_h = (h * (int)6);
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",105)
			int var_i = ::Std_obj::_int(var_h);
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",105)
			double var_1 = (v * ((1. - s)));
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",105)
			double var_2 = (v * ((1. - (s * ((var_h - var_i))))));
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",105)
			double var_3 = (v * ((1. - (s * (((int)1 - ((var_h - var_i))))))));
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",105)
			double var_r = 0.;
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",105)
			double var_g = 0.;
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",105)
			double var_b = 0.;
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",105)
			if (((var_i == (int)0))){
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",105)
				var_r = v;
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",105)
				var_g = var_3;
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",105)
				var_b = var_1;
			}
			else{
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",105)
				if (((var_i == (int)1))){
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",105)
					var_r = var_2;
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",105)
					var_g = v;
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",105)
					var_b = var_1;
				}
				else{
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",105)
					if (((var_i == (int)2))){
						HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",105)
						var_r = var_1;
						HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",105)
						var_g = v;
						HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",105)
						var_b = var_3;
					}
					else{
						HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",105)
						if (((var_i == (int)3))){
							HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",105)
							var_r = var_1;
							HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",105)
							var_g = var_2;
							HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",105)
							var_b = v;
						}
						else{
							HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",105)
							if (((var_i == (int)4))){
								HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",105)
								var_r = var_3;
								HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",105)
								var_g = var_1;
								HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",105)
								var_b = v;
							}
							else{
								HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",105)
								var_r = v;
								HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",105)
								var_g = var_1;
								HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",105)
								var_b = var_2;
							}
						}
					}
				}
			}
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",105)
			rgb->__FieldRef(HX_CSTRING("r")) = ::Std_obj::_int((var_r * (int)255));
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",105)
			rgb->__FieldRef(HX_CSTRING("g")) = ::Std_obj::_int((var_g * (int)255));
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",105)
			rgb->__FieldRef(HX_CSTRING("b")) = ::Std_obj::_int((var_b * (int)255));
		}
	}
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",106)
	return ((((int(rgb->__Field(HX_CSTRING("r"))) << int((int)16))) + ((int(rgb->__Field(HX_CSTRING("g"))) << int((int)8)))) + rgb->__Field(HX_CSTRING("b")));
}


STATIC_HX_DEFINE_DYNAMIC_FUNC4(Color_obj,getShifted,return )

int Color_obj::get( ::com::ludamix::triad::tools::EColor c){
	HX_SOURCE_PUSH("Color_obj::get")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",110)
	{
::com::ludamix::triad::tools::EColor _switch_1 = (c);
		switch((_switch_1)->GetIndex()){
			case 0: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",112)
				return (int)16711935;
			}
			;break;
			case 1: {
				int b = _switch_1->__Param(2);
				int g = _switch_1->__Param(1);
				int r = _switch_1->__Param(0);
{
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",113)
					return ((((int(r) << int((int)16))) + ((int(g) << int((int)8)))) + b);
				}
			}
			;break;
			case 2: {
				double v = _switch_1->__Param(2);
				double s = _switch_1->__Param(1);
				double h = _switch_1->__Param(0);
{
					struct _Function_2_1{
						inline static Dynamic Block( ){
							hx::Anon __result = hx::Anon_obj::Create();
							__result->Add(HX_CSTRING("r") , (int)0,false);
							__result->Add(HX_CSTRING("g") , (int)0,false);
							__result->Add(HX_CSTRING("b") , (int)0,false);
							return __result;
						}
					};
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",114)
					Dynamic t = _Function_2_1::Block();
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",115)
					{
						struct _Function_3_1{
							inline static Dynamic Block( double &h,double &s,double &v){
								hx::Anon __result = hx::Anon_obj::Create();
								__result->Add(HX_CSTRING("h") , h,false);
								__result->Add(HX_CSTRING("s") , s,false);
								__result->Add(HX_CSTRING("v") , v,false);
								return __result;
							}
						};
						HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",115)
						Dynamic HSV = _Function_3_1::Block(h,s,v);
						HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",115)
						double h1 = HSV->__Field(HX_CSTRING("h"));
						HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",115)
						double s1 = HSV->__Field(HX_CSTRING("s"));
						HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",115)
						double v1 = HSV->__Field(HX_CSTRING("v"));
						HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",115)
						if (((s1 == (int)0))){
							HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",115)
							t->__FieldRef(HX_CSTRING("r")) = ::Std_obj::_int((v1 * (int)255));
							HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",115)
							t->__FieldRef(HX_CSTRING("g")) = ::Std_obj::_int((v1 * (int)255));
							HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",115)
							t->__FieldRef(HX_CSTRING("b")) = ::Std_obj::_int((v1 * (int)255));
						}
						else{
							HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",115)
							double var_h = (h1 * (int)6);
							HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",115)
							int var_i = ::Std_obj::_int(var_h);
							HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",115)
							double var_1 = (v1 * ((1. - s1)));
							HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",115)
							double var_2 = (v1 * ((1. - (s1 * ((var_h - var_i))))));
							HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",115)
							double var_3 = (v1 * ((1. - (s1 * (((int)1 - ((var_h - var_i))))))));
							HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",115)
							double var_r = 0.;
							HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",115)
							double var_g = 0.;
							HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",115)
							double var_b = 0.;
							HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",115)
							if (((var_i == (int)0))){
								HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",115)
								var_r = v1;
								HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",115)
								var_g = var_3;
								HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",115)
								var_b = var_1;
							}
							else{
								HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",115)
								if (((var_i == (int)1))){
									HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",115)
									var_r = var_2;
									HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",115)
									var_g = v1;
									HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",115)
									var_b = var_1;
								}
								else{
									HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",115)
									if (((var_i == (int)2))){
										HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",115)
										var_r = var_1;
										HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",115)
										var_g = v1;
										HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",115)
										var_b = var_3;
									}
									else{
										HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",115)
										if (((var_i == (int)3))){
											HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",115)
											var_r = var_1;
											HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",115)
											var_g = var_2;
											HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",115)
											var_b = v1;
										}
										else{
											HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",115)
											if (((var_i == (int)4))){
												HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",115)
												var_r = var_3;
												HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",115)
												var_g = var_1;
												HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",115)
												var_b = v1;
											}
											else{
												HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",115)
												var_r = v1;
												HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",115)
												var_g = var_1;
												HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",115)
												var_b = var_2;
											}
										}
									}
								}
							}
							HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",115)
							t->__FieldRef(HX_CSTRING("r")) = ::Std_obj::_int((var_r * (int)255));
							HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",115)
							t->__FieldRef(HX_CSTRING("g")) = ::Std_obj::_int((var_g * (int)255));
							HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",115)
							t->__FieldRef(HX_CSTRING("b")) = ::Std_obj::_int((var_b * (int)255));
						}
					}
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",116)
					return ((((int(t->__Field(HX_CSTRING("r"))) << int((int)16))) + ((int(t->__Field(HX_CSTRING("g"))) << int((int)8)))) + t->__Field(HX_CSTRING("b")));
				}
			}
			;break;
			case 3: {
				int hv = _switch_1->__Param(0);
{
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",117)
					return hv;
				}
			}
			;break;
			case 4: {
				::String v = _switch_1->__Param(0);
{
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",118)
					return ::Std_obj::parseInt(v);
				}
			}
			;break;
			case 5: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",119)
				return (int)15792383;
			}
			;break;
			case 6: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",120)
				return (int)16444375;
			}
			;break;
			case 7: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",121)
				return (int)65535;
			}
			;break;
			case 8: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",122)
				return (int)8388564;
			}
			;break;
			case 9: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",123)
				return (int)15794175;
			}
			;break;
			case 10: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",124)
				return (int)16119260;
			}
			;break;
			case 11: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",125)
				return (int)16770244;
			}
			;break;
			case 12: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",126)
				return (int)0;
			}
			;break;
			case 13: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",127)
				return (int)16772045;
			}
			;break;
			case 14: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",128)
				return (int)255;
			}
			;break;
			case 15: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",129)
				return (int)9055202;
			}
			;break;
			case 16: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",130)
				return (int)10824234;
			}
			;break;
			case 17: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",131)
				return (int)14596231;
			}
			;break;
			case 18: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",132)
				return (int)6266528;
			}
			;break;
			case 19: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",133)
				return (int)8388352;
			}
			;break;
			case 20: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",134)
				return (int)13789470;
			}
			;break;
			case 21: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",135)
				return (int)16744272;
			}
			;break;
			case 22: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",136)
				return (int)6591981;
			}
			;break;
			case 23: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",137)
				return (int)16775388;
			}
			;break;
			case 24: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",138)
				return (int)14423100;
			}
			;break;
			case 25: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",139)
				return (int)65535;
			}
			;break;
			case 26: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",140)
				return (int)139;
			}
			;break;
			case 27: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",141)
				return (int)35723;
			}
			;break;
			case 28: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",142)
				return (int)12092939;
			}
			;break;
			case 29: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",143)
				return (int)11119017;
			}
			;break;
			case 30: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",144)
				return (int)11119017;
			}
			;break;
			case 31: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",145)
				return (int)25600;
			}
			;break;
			case 32: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",146)
				return (int)12433259;
			}
			;break;
			case 33: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",147)
				return (int)9109643;
			}
			;break;
			case 34: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",148)
				return (int)5597999;
			}
			;break;
			case 35: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",149)
				return (int)16747520;
			}
			;break;
			case 36: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",150)
				return (int)10040012;
			}
			;break;
			case 37: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",151)
				return (int)9109504;
			}
			;break;
			case 38: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",152)
				return (int)15308410;
			}
			;break;
			case 39: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",153)
				return (int)9419919;
			}
			;break;
			case 40: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",154)
				return (int)4734347;
			}
			;break;
			case 41: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",155)
				return (int)3100495;
			}
			;break;
			case 42: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",156)
				return (int)3100495;
			}
			;break;
			case 43: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",157)
				return (int)52945;
			}
			;break;
			case 44: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",158)
				return (int)9699539;
			}
			;break;
			case 45: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",159)
				return (int)16716947;
			}
			;break;
			case 46: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",160)
				return (int)49151;
			}
			;break;
			case 47: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",161)
				return (int)6908265;
			}
			;break;
			case 48: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",162)
				return (int)6908265;
			}
			;break;
			case 49: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",163)
				return (int)2003199;
			}
			;break;
			case 50: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",164)
				return (int)11674146;
			}
			;break;
			case 51: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",165)
				return (int)16775920;
			}
			;break;
			case 52: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",166)
				return (int)2263842;
			}
			;break;
			case 53: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",167)
				return (int)16711935;
			}
			;break;
			case 54: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",168)
				return (int)14474460;
			}
			;break;
			case 55: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",169)
				return (int)16316671;
			}
			;break;
			case 56: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",170)
				return (int)16766720;
			}
			;break;
			case 57: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",171)
				return (int)14329120;
			}
			;break;
			case 58: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",172)
				return (int)8421504;
			}
			;break;
			case 59: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",173)
				return (int)8421504;
			}
			;break;
			case 60: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",174)
				return (int)32768;
			}
			;break;
			case 61: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",175)
				return (int)11403055;
			}
			;break;
			case 62: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",176)
				return (int)15794160;
			}
			;break;
			case 63: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",177)
				return (int)16738740;
			}
			;break;
			case 64: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",178)
				return (int)13458524;
			}
			;break;
			case 65: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",179)
				return (int)4915330;
			}
			;break;
			case 66: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",180)
				return (int)16777200;
			}
			;break;
			case 67: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",181)
				return (int)15787660;
			}
			;break;
			case 68: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",182)
				return (int)15132410;
			}
			;break;
			case 69: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",183)
				return (int)16773365;
			}
			;break;
			case 70: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",184)
				return (int)8190976;
			}
			;break;
			case 71: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",185)
				return (int)16775885;
			}
			;break;
			case 72: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",186)
				return (int)11393254;
			}
			;break;
			case 73: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",187)
				return (int)15761536;
			}
			;break;
			case 74: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",188)
				return (int)14745599;
			}
			;break;
			case 75: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",189)
				return (int)16448210;
			}
			;break;
			case 76: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",190)
				return (int)13882323;
			}
			;break;
			case 77: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",191)
				return (int)13882323;
			}
			;break;
			case 78: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",192)
				return (int)9498256;
			}
			;break;
			case 79: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",193)
				return (int)16758465;
			}
			;break;
			case 80: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",194)
				return (int)16752762;
			}
			;break;
			case 81: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",195)
				return (int)2142890;
			}
			;break;
			case 82: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",196)
				return (int)8900346;
			}
			;break;
			case 83: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",197)
				return (int)7833753;
			}
			;break;
			case 84: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",198)
				return (int)7833753;
			}
			;break;
			case 85: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",199)
				return (int)11584734;
			}
			;break;
			case 86: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",200)
				return (int)16777184;
			}
			;break;
			case 87: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",201)
				return (int)65280;
			}
			;break;
			case 88: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",202)
				return (int)3329330;
			}
			;break;
			case 89: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",203)
				return (int)16445670;
			}
			;break;
			case 90: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",204)
				return (int)16711935;
			}
			;break;
			case 91: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",205)
				return (int)8388608;
			}
			;break;
			case 92: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",206)
				return (int)6737322;
			}
			;break;
			case 93: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",207)
				return (int)205;
			}
			;break;
			case 94: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",208)
				return (int)12211667;
			}
			;break;
			case 95: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",209)
				return (int)9662680;
			}
			;break;
			case 96: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",210)
				return (int)3978097;
			}
			;break;
			case 97: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",211)
				return (int)8087790;
			}
			;break;
			case 98: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",212)
				return (int)64154;
			}
			;break;
			case 99: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",213)
				return (int)4772300;
			}
			;break;
			case 100: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",214)
				return (int)13047173;
			}
			;break;
			case 101: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",215)
				return (int)1644912;
			}
			;break;
			case 102: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",216)
				return (int)16121850;
			}
			;break;
			case 103: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",217)
				return (int)16770273;
			}
			;break;
			case 104: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",218)
				return (int)16770229;
			}
			;break;
			case 105: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",219)
				return (int)16768685;
			}
			;break;
			case 106: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",220)
				return (int)128;
			}
			;break;
			case 107: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",221)
				return (int)16643558;
			}
			;break;
			case 108: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",222)
				return (int)8421376;
			}
			;break;
			case 109: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",223)
				return (int)7048739;
			}
			;break;
			case 110: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",224)
				return (int)16753920;
			}
			;break;
			case 111: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",225)
				return (int)16729344;
			}
			;break;
			case 112: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",226)
				return (int)14315734;
			}
			;break;
			case 113: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",227)
				return (int)15657130;
			}
			;break;
			case 114: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",228)
				return (int)10025880;
			}
			;break;
			case 115: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",229)
				return (int)11529966;
			}
			;break;
			case 116: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",230)
				return (int)14184595;
			}
			;break;
			case 117: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",231)
				return (int)16773077;
			}
			;break;
			case 118: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",232)
				return (int)16767673;
			}
			;break;
			case 119: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",233)
				return (int)13468991;
			}
			;break;
			case 120: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",234)
				return (int)16761035;
			}
			;break;
			case 121: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",235)
				return (int)14524637;
			}
			;break;
			case 122: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",236)
				return (int)11591910;
			}
			;break;
			case 123: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",237)
				return (int)8388736;
			}
			;break;
			case 124: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",238)
				return (int)16711680;
			}
			;break;
			case 125: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",239)
				return (int)12357519;
			}
			;break;
			case 126: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",240)
				return (int)4286945;
			}
			;break;
			case 127: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",241)
				return (int)9127187;
			}
			;break;
			case 128: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",242)
				return (int)16416882;
			}
			;break;
			case 129: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",243)
				return (int)16032864;
			}
			;break;
			case 130: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",244)
				return (int)3050327;
			}
			;break;
			case 131: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",245)
				return (int)16774638;
			}
			;break;
			case 132: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",246)
				return (int)10506797;
			}
			;break;
			case 133: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",247)
				return (int)12632256;
			}
			;break;
			case 134: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",248)
				return (int)8900331;
			}
			;break;
			case 135: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",249)
				return (int)6970061;
			}
			;break;
			case 136: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",250)
				return (int)7372944;
			}
			;break;
			case 137: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",251)
				return (int)7372944;
			}
			;break;
			case 138: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",252)
				return (int)16775930;
			}
			;break;
			case 139: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",253)
				return (int)65407;
			}
			;break;
			case 140: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",254)
				return (int)4620980;
			}
			;break;
			case 141: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",255)
				return (int)13808780;
			}
			;break;
			case 142: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",256)
				return (int)32896;
			}
			;break;
			case 143: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",257)
				return (int)14204888;
			}
			;break;
			case 144: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",258)
				return (int)16737095;
			}
			;break;
			case 145: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",259)
				return (int)4251856;
			}
			;break;
			case 146: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",260)
				return (int)15631086;
			}
			;break;
			case 147: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",261)
				return (int)16113331;
			}
			;break;
			case 148: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",262)
				return (int)16777215;
			}
			;break;
			case 149: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",263)
				return (int)16119285;
			}
			;break;
			case 150: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",264)
				return (int)16776960;
			}
			;break;
			case 151: {
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/Color.hx",265)
				return (int)10145074;
			}
			;break;
		}
	}
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Color_obj,get,return )


Color_obj::Color_obj()
{
}

void Color_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Color);
	HX_MARK_END_CLASS();
}

Dynamic Color_obj::__Field(const ::String &inName)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"get") ) { return get_dyn(); }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"ARGB") ) { return ARGB_dyn(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"RGBPx") ) { return RGBPx_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"RGBred") ) { return RGBred_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"RGBblue") ) { return RGBblue_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"RGBgreen") ) { return RGBgreen_dyn(); }
		if (HX_FIELD_EQ(inName,"buildRGB") ) { return buildRGB_dyn(); }
		if (HX_FIELD_EQ(inName,"RGBtoHSV") ) { return RGBtoHSV_dyn(); }
		if (HX_FIELD_EQ(inName,"HSVtoRGB") ) { return HSVtoRGB_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"RGBofARGB") ) { return RGBofARGB_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"getShifted") ) { return getShifted_dyn(); }
	}
	return super::__Field(inName);
}

Dynamic Color_obj::__SetField(const ::String &inName,const Dynamic &inValue)
{
	return super::__SetField(inName,inValue);
}

void Color_obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("ARGB"),
	HX_CSTRING("RGBofARGB"),
	HX_CSTRING("RGBPx"),
	HX_CSTRING("RGBred"),
	HX_CSTRING("RGBgreen"),
	HX_CSTRING("RGBblue"),
	HX_CSTRING("buildRGB"),
	HX_CSTRING("RGBtoHSV"),
	HX_CSTRING("HSVtoRGB"),
	HX_CSTRING("getShifted"),
	HX_CSTRING("get"),
	String(null()) };

static ::String sMemberFields[] = {
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
};

Class Color_obj::__mClass;

void Color_obj::__register()
{
	Static(__mClass) = hx::RegisterClass(HX_CSTRING("com.ludamix.triad.tools.Color"), hx::TCanCast< Color_obj> ,sStaticFields,sMemberFields,
	&__CreateEmpty, &__Create,
	&super::__SGetClass(), 0, sMarkStatics);
}

void Color_obj::__boot()
{
}

} // end namespace com
} // end namespace ludamix
} // end namespace triad
} // end namespace tools
