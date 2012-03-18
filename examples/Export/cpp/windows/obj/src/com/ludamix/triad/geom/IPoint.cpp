#include <hxcpp.h>

#ifndef INCLUDED_Std
#include <Std.h>
#endif
#ifndef INCLUDED_com_ludamix_triad_geom_IPoint
#include <com/ludamix/triad/geom/IPoint.h>
#endif
#ifndef INCLUDED_com_ludamix_triad_geom_SubIPoint
#include <com/ludamix/triad/geom/SubIPoint.h>
#endif
#ifndef INCLUDED_nme_geom_Point
#include <nme/geom/Point.h>
#endif
namespace com{
namespace ludamix{
namespace triad{
namespace geom{

Void IPoint_obj::__construct(Dynamic __o_x,Dynamic __o_y)
{
int x = __o_x.Default(0);
int y = __o_y.Default(0);
{
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/IPoint.hx",12)
	this->x = x;
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/IPoint.hx",13)
	this->y = y;
}
;
	return null();
}

IPoint_obj::~IPoint_obj() { }

Dynamic IPoint_obj::__CreateEmpty() { return  new IPoint_obj; }
hx::ObjectPtr< IPoint_obj > IPoint_obj::__new(Dynamic __o_x,Dynamic __o_y)
{  hx::ObjectPtr< IPoint_obj > result = new IPoint_obj();
	result->__construct(__o_x,__o_y);
	return result;}

Dynamic IPoint_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< IPoint_obj > result = new IPoint_obj();
	result->__construct(inArgs[0],inArgs[1]);
	return result;}

::com::ludamix::triad::geom::IPoint IPoint_obj::clone( ){
	HX_SOURCE_PUSH("IPoint_obj::clone")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/IPoint.hx",17)
	return ::com::ludamix::triad::geom::IPoint_obj::__new(this->x,this->y);
}


HX_DEFINE_DYNAMIC_FUNC0(IPoint_obj,clone,return )

Void IPoint_obj::add( ::com::ludamix::triad::geom::IPoint p){
{
		HX_SOURCE_PUSH("IPoint_obj::add")
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/IPoint.hx",23)
		hx::AddEq(this->x,p->x);
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/IPoint.hx",24)
		hx::AddEq(this->y,p->y);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(IPoint_obj,add,(void))

Void IPoint_obj::sub( ::com::ludamix::triad::geom::IPoint p){
{
		HX_SOURCE_PUSH("IPoint_obj::sub")
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/IPoint.hx",29)
		hx::SubEq(this->x,p->x);
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/IPoint.hx",30)
		hx::SubEq(this->y,p->y);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(IPoint_obj,sub,(void))

Void IPoint_obj::mul( ::com::ludamix::triad::geom::IPoint p){
{
		HX_SOURCE_PUSH("IPoint_obj::mul")
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/IPoint.hx",35)
		hx::MultEq(this->x,p->x);
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/IPoint.hx",36)
		hx::MultEq(this->y,p->y);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(IPoint_obj,mul,(void))

Void IPoint_obj::div( ::com::ludamix::triad::geom::IPoint p){
{
		HX_SOURCE_PUSH("IPoint_obj::div")
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/IPoint.hx",41)
		this->x = ::Std_obj::_int((double(this->x) / double(p->x)));
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/IPoint.hx",42)
		this->y = ::Std_obj::_int((double(this->y) / double(p->y)));
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(IPoint_obj,div,(void))

bool IPoint_obj::eqX( ::com::ludamix::triad::geom::IPoint p){
	HX_SOURCE_PUSH("IPoint_obj::eqX")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/IPoint.hx",46)
	return (this->x == p->x);
}


HX_DEFINE_DYNAMIC_FUNC1(IPoint_obj,eqX,return )

bool IPoint_obj::eqY( ::com::ludamix::triad::geom::IPoint p){
	HX_SOURCE_PUSH("IPoint_obj::eqY")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/IPoint.hx",51)
	return (this->y == p->y);
}


HX_DEFINE_DYNAMIC_FUNC1(IPoint_obj,eqY,return )

bool IPoint_obj::eq( ::com::ludamix::triad::geom::IPoint p){
	HX_SOURCE_PUSH("IPoint_obj::eq")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/IPoint.hx",56)
	return (bool((this->x == p->x)) && bool((this->y == p->y)));
}


HX_DEFINE_DYNAMIC_FUNC1(IPoint_obj,eq,return )

::com::ludamix::triad::geom::SubIPoint IPoint_obj::genSubIPoint( ){
	HX_SOURCE_PUSH("IPoint_obj::genSubIPoint")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/IPoint.hx",60)
	return ::com::ludamix::triad::geom::SubIPoint_obj::__new((int(this->x) << int((int)8)),(int(this->y) << int((int)8)));
}


HX_DEFINE_DYNAMIC_FUNC0(IPoint_obj,genSubIPoint,return )

::nme::geom::Point IPoint_obj::genFPoint( ){
	HX_SOURCE_PUSH("IPoint_obj::genFPoint")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/IPoint.hx",61)
	return ::nme::geom::Point_obj::__new(this->x,this->y);
}


HX_DEFINE_DYNAMIC_FUNC0(IPoint_obj,genFPoint,return )


IPoint_obj::IPoint_obj()
{
}

void IPoint_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(IPoint);
	HX_MARK_MEMBER_NAME(x,"x");
	HX_MARK_MEMBER_NAME(y,"y");
	HX_MARK_END_CLASS();
}

Dynamic IPoint_obj::__Field(const ::String &inName)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"x") ) { return x; }
		if (HX_FIELD_EQ(inName,"y") ) { return y; }
		break;
	case 2:
		if (HX_FIELD_EQ(inName,"eq") ) { return eq_dyn(); }
		break;
	case 3:
		if (HX_FIELD_EQ(inName,"add") ) { return add_dyn(); }
		if (HX_FIELD_EQ(inName,"sub") ) { return sub_dyn(); }
		if (HX_FIELD_EQ(inName,"mul") ) { return mul_dyn(); }
		if (HX_FIELD_EQ(inName,"div") ) { return div_dyn(); }
		if (HX_FIELD_EQ(inName,"eqX") ) { return eqX_dyn(); }
		if (HX_FIELD_EQ(inName,"eqY") ) { return eqY_dyn(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"clone") ) { return clone_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"genFPoint") ) { return genFPoint_dyn(); }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"genSubIPoint") ) { return genSubIPoint_dyn(); }
	}
	return super::__Field(inName);
}

Dynamic IPoint_obj::__SetField(const ::String &inName,const Dynamic &inValue)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"x") ) { x=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"y") ) { y=inValue.Cast< int >(); return inValue; }
	}
	return super::__SetField(inName,inValue);
}

void IPoint_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("x"));
	outFields->push(HX_CSTRING("y"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

static ::String sMemberFields[] = {
	HX_CSTRING("x"),
	HX_CSTRING("y"),
	HX_CSTRING("clone"),
	HX_CSTRING("add"),
	HX_CSTRING("sub"),
	HX_CSTRING("mul"),
	HX_CSTRING("div"),
	HX_CSTRING("eqX"),
	HX_CSTRING("eqY"),
	HX_CSTRING("eq"),
	HX_CSTRING("genSubIPoint"),
	HX_CSTRING("genFPoint"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
};

Class IPoint_obj::__mClass;

void IPoint_obj::__register()
{
	Static(__mClass) = hx::RegisterClass(HX_CSTRING("com.ludamix.triad.geom.IPoint"), hx::TCanCast< IPoint_obj> ,sStaticFields,sMemberFields,
	&__CreateEmpty, &__Create,
	&super::__SGetClass(), 0, sMarkStatics);
}

void IPoint_obj::__boot()
{
}

} // end namespace com
} // end namespace ludamix
} // end namespace triad
} // end namespace geom
