#include <hxcpp.h>

#ifndef INCLUDED_hxMath
#include <hxMath.h>
#endif
#ifndef INCLUDED_com_ludamix_triad_tools_MathTools
#include <com/ludamix/triad/tools/MathTools.h>
#endif
namespace com{
namespace ludamix{
namespace triad{
namespace tools{

Void MathTools_obj::__construct()
{
	return null();
}

MathTools_obj::~MathTools_obj() { }

Dynamic MathTools_obj::__CreateEmpty() { return  new MathTools_obj; }
hx::ObjectPtr< MathTools_obj > MathTools_obj::__new()
{  hx::ObjectPtr< MathTools_obj > result = new MathTools_obj();
	result->__construct();
	return result;}

Dynamic MathTools_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< MathTools_obj > result = new MathTools_obj();
	result->__construct();
	return result;}

int MathTools_obj::wraparound( int counter,int low,int high){
	HX_SOURCE_PUSH("MathTools_obj::wraparound")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/MathTools.hx",8)
	int dist = (high - low);
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/MathTools.hx",9)
	while(((counter < low))){
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/MathTools.hx",10)
		hx::AddEq(counter,dist);
	}
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/MathTools.hx",11)
	while(((counter >= high))){
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/MathTools.hx",12)
		hx::SubEq(counter,dist);
	}
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/MathTools.hx",13)
	return counter;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(MathTools_obj,wraparound,return )

double MathTools_obj::dist( double ax,double ay,double bx,double by){
	HX_SOURCE_PUSH("MathTools_obj::dist")
	struct _Function_1_1{
		inline static double Block( double &bx,double &ay,double &ax,double &by){
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/MathTools.hx",18)
			double x = (ax - bx);
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/MathTools.hx",18)
			double y = (ay - by);
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/MathTools.hx",18)
			return ((x * x) + (y * y));
		}
	};
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/MathTools.hx",17)
	return ::Math_obj::sqrt(_Function_1_1::Block(bx,ay,ax,by));
}


STATIC_HX_DEFINE_DYNAMIC_FUNC4(MathTools_obj,dist,return )

double MathTools_obj::distPt( Dynamic a,Dynamic b){
	HX_SOURCE_PUSH("MathTools_obj::distPt")
	struct _Function_1_1{
		inline static double Block( Dynamic &a,Dynamic &b){
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/MathTools.hx",23)
			double x = (a->__Field(HX_CSTRING("x")) - b->__Field(HX_CSTRING("x")));
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/MathTools.hx",23)
			double y = (a->__Field(HX_CSTRING("y")) - b->__Field(HX_CSTRING("y")));
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/MathTools.hx",23)
			return ((x * x) + (y * y));
		}
	};
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/MathTools.hx",22)
	return ::Math_obj::sqrt(_Function_1_1::Block(a,b));
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(MathTools_obj,distPt,return )

double MathTools_obj::sqrDist( double ax,double ay,double bx,double by){
	HX_SOURCE_PUSH("MathTools_obj::sqrDist")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/MathTools.hx",28)
	double x = (ax - bx);
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/MathTools.hx",29)
	double y = (ay - by);
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/MathTools.hx",30)
	return ((x * x) + (y * y));
}


STATIC_HX_DEFINE_DYNAMIC_FUNC4(MathTools_obj,sqrDist,return )

double MathTools_obj::sqrDistPt( Dynamic a,Dynamic b){
	HX_SOURCE_PUSH("MathTools_obj::sqrDistPt")
	struct _Function_1_1{
		inline static double Block( Dynamic &a,Dynamic &b){
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/MathTools.hx",35)
			double x = (a->__Field(HX_CSTRING("x")) - b->__Field(HX_CSTRING("x")));
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/MathTools.hx",35)
			double y = (a->__Field(HX_CSTRING("y")) - b->__Field(HX_CSTRING("y")));
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/MathTools.hx",35)
			return ((x * x) + (y * y));
		}
	};
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/MathTools.hx",34)
	return _Function_1_1::Block(a,b);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(MathTools_obj,sqrDistPt,return )

bool MathTools_obj::fequals( double a,double b){
	HX_SOURCE_PUSH("MathTools_obj::fequals")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/MathTools.hx",38)
	return (::Math_obj::abs((a - b)) < 0.000001);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(MathTools_obj,fequals,return )

double MathTools_obj::lerp( double fromI,double toI,double pct){
	HX_SOURCE_PUSH("MathTools_obj::lerp")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/MathTools.hx",40)
	return (fromI + (((toI - fromI)) * pct));
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(MathTools_obj,lerp,return )

Dynamic MathTools_obj::nearestOf( Dynamic positions,double x,double y){
	HX_SOURCE_PUSH("MathTools_obj::nearestOf")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/MathTools.hx",44)
	double best = 99999999999999.;
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/MathTools.hx",45)
	int bestpos = (int)0;
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/MathTools.hx",46)
	{
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/MathTools.hx",46)
		int _g1 = (int)0;
		int _g = positions->__Field(HX_CSTRING("length"));
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/MathTools.hx",46)
		while(((_g1 < _g))){
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/MathTools.hx",46)
			int n = (_g1)++;
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/MathTools.hx",48)
			Dynamic pos = positions->__GetItem(n);
			struct _Function_3_1{
				inline static double Block( Dynamic &pos,double &y,double &x){
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/MathTools.hx",49)
					double x1 = (pos->__Field(HX_CSTRING("x")) - x);
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/MathTools.hx",49)
					double y1 = (pos->__Field(HX_CSTRING("y")) - y);
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/MathTools.hx",49)
					return ((x1 * x1) + (y1 * y1));
				}
			};
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/MathTools.hx",49)
			double cur = _Function_3_1::Block(pos,y,x);
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/MathTools.hx",50)
			if (((cur < best))){
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/MathTools.hx",52)
				best = cur;
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/MathTools.hx",53)
				bestpos = n;
			}
		}
	}
	struct _Function_1_1{
		inline static Dynamic Block( int &bestpos,Dynamic &positions,double &best){
			hx::Anon __result = hx::Anon_obj::Create();
			__result->Add(HX_CSTRING("idx") , bestpos,false);
			__result->Add(HX_CSTRING("instance") , positions->__GetItem(bestpos),false);
			__result->Add(HX_CSTRING("dist") , ::Math_obj::sqrt(best),false);
			return __result;
		}
	};
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/MathTools.hx",56)
	return _Function_1_1::Block(bestpos,positions,best);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(MathTools_obj,nearestOf,return )

double MathTools_obj::limit( double min,double max,double val){
	HX_SOURCE_PUSH("MathTools_obj::limit")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/tools/MathTools.hx",60)
	return ::Math_obj::max(min,::Math_obj::min(max,val));
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(MathTools_obj,limit,return )


MathTools_obj::MathTools_obj()
{
}

void MathTools_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(MathTools);
	HX_MARK_END_CLASS();
}

Dynamic MathTools_obj::__Field(const ::String &inName)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"dist") ) { return dist_dyn(); }
		if (HX_FIELD_EQ(inName,"lerp") ) { return lerp_dyn(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"limit") ) { return limit_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"distPt") ) { return distPt_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"sqrDist") ) { return sqrDist_dyn(); }
		if (HX_FIELD_EQ(inName,"fequals") ) { return fequals_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"sqrDistPt") ) { return sqrDistPt_dyn(); }
		if (HX_FIELD_EQ(inName,"nearestOf") ) { return nearestOf_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"wraparound") ) { return wraparound_dyn(); }
	}
	return super::__Field(inName);
}

Dynamic MathTools_obj::__SetField(const ::String &inName,const Dynamic &inValue)
{
	return super::__SetField(inName,inValue);
}

void MathTools_obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("wraparound"),
	HX_CSTRING("dist"),
	HX_CSTRING("distPt"),
	HX_CSTRING("sqrDist"),
	HX_CSTRING("sqrDistPt"),
	HX_CSTRING("fequals"),
	HX_CSTRING("lerp"),
	HX_CSTRING("nearestOf"),
	HX_CSTRING("limit"),
	String(null()) };

static ::String sMemberFields[] = {
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
};

Class MathTools_obj::__mClass;

void MathTools_obj::__register()
{
	Static(__mClass) = hx::RegisterClass(HX_CSTRING("com.ludamix.triad.tools.MathTools"), hx::TCanCast< MathTools_obj> ,sStaticFields,sMemberFields,
	&__CreateEmpty, &__Create,
	&super::__SGetClass(), 0, sMarkStatics);
}

void MathTools_obj::__boot()
{
}

} // end namespace com
} // end namespace ludamix
} // end namespace triad
} // end namespace tools
