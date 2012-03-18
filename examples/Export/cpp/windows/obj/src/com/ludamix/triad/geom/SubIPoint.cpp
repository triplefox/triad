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

Void SubIPoint_obj::__construct(Dynamic __o_x,Dynamic __o_y)
{
int x = __o_x.Default(0);
int y = __o_y.Default(0);
{
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubIPoint.hx",16)
	this->x = x;
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubIPoint.hx",17)
	this->y = y;
}
;
	return null();
}

SubIPoint_obj::~SubIPoint_obj() { }

Dynamic SubIPoint_obj::__CreateEmpty() { return  new SubIPoint_obj; }
hx::ObjectPtr< SubIPoint_obj > SubIPoint_obj::__new(Dynamic __o_x,Dynamic __o_y)
{  hx::ObjectPtr< SubIPoint_obj > result = new SubIPoint_obj();
	result->__construct(__o_x,__o_y);
	return result;}

Dynamic SubIPoint_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< SubIPoint_obj > result = new SubIPoint_obj();
	result->__construct(inArgs[0],inArgs[1]);
	return result;}

::String SubIPoint_obj::toString( ){
	HX_SOURCE_PUSH("SubIPoint_obj::toString")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubIPoint.hx",20)
	return ::Std_obj::string(Array_obj< double >::__new().Add((double(this->x) / double((int)256))).Add((double(this->y) / double((int)256))));
}


HX_DEFINE_DYNAMIC_FUNC0(SubIPoint_obj,toString,return )

int SubIPoint_obj::xi( ){
	HX_SOURCE_PUSH("SubIPoint_obj::xi")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubIPoint.hx",42)
	return (int(this->x) >> int((int)8));
}


HX_DEFINE_DYNAMIC_FUNC0(SubIPoint_obj,xi,return )

int SubIPoint_obj::yi( ){
	HX_SOURCE_PUSH("SubIPoint_obj::yi")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubIPoint.hx",43)
	return (int(this->y) >> int((int)8));
}


HX_DEFINE_DYNAMIC_FUNC0(SubIPoint_obj,yi,return )

double SubIPoint_obj::xf( ){
	HX_SOURCE_PUSH("SubIPoint_obj::xf")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubIPoint.hx",44)
	return (double(this->x) / double((int)256));
}


HX_DEFINE_DYNAMIC_FUNC0(SubIPoint_obj,xf,return )

double SubIPoint_obj::yf( ){
	HX_SOURCE_PUSH("SubIPoint_obj::yf")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubIPoint.hx",45)
	return (double(this->y) / double((int)256));
}


HX_DEFINE_DYNAMIC_FUNC0(SubIPoint_obj,yf,return )

::com::ludamix::triad::geom::SubIPoint SubIPoint_obj::clone( ){
	HX_SOURCE_PUSH("SubIPoint_obj::clone")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubIPoint.hx",48)
	return ::com::ludamix::triad::geom::SubIPoint_obj::__new(this->x,this->y);
}


HX_DEFINE_DYNAMIC_FUNC0(SubIPoint_obj,clone,return )

Void SubIPoint_obj::paste( ::com::ludamix::triad::geom::SubIPoint sp){
{
		HX_SOURCE_PUSH("SubIPoint_obj::paste")
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubIPoint.hx",54)
		this->x = sp->x;
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubIPoint.hx",55)
		this->y = sp->y;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(SubIPoint_obj,paste,(void))

Void SubIPoint_obj::add( ::com::ludamix::triad::geom::SubIPoint p){
{
		HX_SOURCE_PUSH("SubIPoint_obj::add")
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubIPoint.hx",60)
		hx::AddEq(this->x,p->x);
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubIPoint.hx",61)
		hx::AddEq(this->y,p->y);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(SubIPoint_obj,add,(void))

Void SubIPoint_obj::sub( ::com::ludamix::triad::geom::SubIPoint p){
{
		HX_SOURCE_PUSH("SubIPoint_obj::sub")
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubIPoint.hx",66)
		hx::SubEq(this->x,p->x);
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubIPoint.hx",67)
		hx::SubEq(this->y,p->y);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(SubIPoint_obj,sub,(void))

Void SubIPoint_obj::mul( ::com::ludamix::triad::geom::SubIPoint p){
{
		HX_SOURCE_PUSH("SubIPoint_obj::mul")
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubIPoint.hx",72)
		hx::MultEq(this->x,p->x);
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubIPoint.hx",73)
		hx::MultEq(this->y,p->y);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(SubIPoint_obj,mul,(void))

Void SubIPoint_obj::div( ::com::ludamix::triad::geom::SubIPoint p){
{
		HX_SOURCE_PUSH("SubIPoint_obj::div")
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubIPoint.hx",78)
		this->x = ::Std_obj::_int((double(this->x) / double(p->x)));
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubIPoint.hx",79)
		this->y = ::Std_obj::_int((double(this->y) / double(p->y)));
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(SubIPoint_obj,div,(void))

bool SubIPoint_obj::eqX( ::com::ludamix::triad::geom::SubIPoint p){
	HX_SOURCE_PUSH("SubIPoint_obj::eqX")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubIPoint.hx",83)
	return (this->x == p->x);
}


HX_DEFINE_DYNAMIC_FUNC1(SubIPoint_obj,eqX,return )

bool SubIPoint_obj::eqY( ::com::ludamix::triad::geom::SubIPoint p){
	HX_SOURCE_PUSH("SubIPoint_obj::eqY")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubIPoint.hx",88)
	return (this->y == p->y);
}


HX_DEFINE_DYNAMIC_FUNC1(SubIPoint_obj,eqY,return )

bool SubIPoint_obj::eq( ::com::ludamix::triad::geom::SubIPoint p){
	HX_SOURCE_PUSH("SubIPoint_obj::eq")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubIPoint.hx",93)
	return (bool((this->x == p->x)) && bool((this->y == p->y)));
}


HX_DEFINE_DYNAMIC_FUNC1(SubIPoint_obj,eq,return )

Void SubIPoint_obj::addI( ::com::ludamix::triad::geom::IPoint p){
{
		HX_SOURCE_PUSH("SubIPoint_obj::addI")
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubIPoint.hx",99)
		hx::AddEq(this->x,(int(p->x) << int((int)8)));
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubIPoint.hx",100)
		hx::AddEq(this->y,(int(p->y) << int((int)8)));
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(SubIPoint_obj,addI,(void))

Void SubIPoint_obj::subI( ::com::ludamix::triad::geom::IPoint p){
{
		HX_SOURCE_PUSH("SubIPoint_obj::subI")
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubIPoint.hx",105)
		hx::SubEq(this->x,(int(p->x) << int((int)8)));
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubIPoint.hx",106)
		hx::SubEq(this->y,(int(p->y) << int((int)8)));
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(SubIPoint_obj,subI,(void))

Void SubIPoint_obj::mulI( ::com::ludamix::triad::geom::IPoint p){
{
		HX_SOURCE_PUSH("SubIPoint_obj::mulI")
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubIPoint.hx",111)
		hx::MultEq(this->x,(int(p->x) << int((int)8)));
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubIPoint.hx",112)
		hx::MultEq(this->y,(int(p->y) << int((int)8)));
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(SubIPoint_obj,mulI,(void))

Void SubIPoint_obj::divI( ::com::ludamix::triad::geom::IPoint p){
{
		HX_SOURCE_PUSH("SubIPoint_obj::divI")
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubIPoint.hx",117)
		this->x = ::Std_obj::_int((double(this->x) / double(((int(p->x) << int((int)8))))));
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubIPoint.hx",118)
		this->y = ::Std_obj::_int((double(this->y) / double(((int(p->y) << int((int)8))))));
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(SubIPoint_obj,divI,(void))

bool SubIPoint_obj::eqXI( ::com::ludamix::triad::geom::IPoint p){
	HX_SOURCE_PUSH("SubIPoint_obj::eqXI")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubIPoint.hx",122)
	return (this->x == (int(p->x) << int((int)8)));
}


HX_DEFINE_DYNAMIC_FUNC1(SubIPoint_obj,eqXI,return )

bool SubIPoint_obj::eqYI( ::com::ludamix::triad::geom::IPoint p){
	HX_SOURCE_PUSH("SubIPoint_obj::eqYI")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubIPoint.hx",127)
	return (this->y == (int(p->y) << int((int)8)));
}


HX_DEFINE_DYNAMIC_FUNC1(SubIPoint_obj,eqYI,return )

bool SubIPoint_obj::eqI( ::com::ludamix::triad::geom::IPoint p){
	HX_SOURCE_PUSH("SubIPoint_obj::eqI")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubIPoint.hx",132)
	return (bool((this->x == (int(p->x) << int((int)8)))) && bool((this->y == (int(p->y) << int((int)8)))));
}


HX_DEFINE_DYNAMIC_FUNC1(SubIPoint_obj,eqI,return )

Void SubIPoint_obj::addF( ::nme::geom::Point p){
{
		HX_SOURCE_PUSH("SubIPoint_obj::addF")
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubIPoint.hx",138)
		hx::AddEq(this->x,::Std_obj::_int((p->x * (int)256)));
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubIPoint.hx",139)
		hx::AddEq(this->y,::Std_obj::_int((p->y * (int)256)));
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(SubIPoint_obj,addF,(void))

Void SubIPoint_obj::subF( ::nme::geom::Point p){
{
		HX_SOURCE_PUSH("SubIPoint_obj::subF")
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubIPoint.hx",144)
		hx::SubEq(this->x,::Std_obj::_int((p->x * (int)256)));
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubIPoint.hx",145)
		hx::SubEq(this->y,::Std_obj::_int((p->y * (int)256)));
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(SubIPoint_obj,subF,(void))

Void SubIPoint_obj::mulF( ::nme::geom::Point p){
{
		HX_SOURCE_PUSH("SubIPoint_obj::mulF")
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubIPoint.hx",150)
		hx::MultEq(this->x,::Std_obj::_int((p->x * (int)256)));
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubIPoint.hx",151)
		hx::MultEq(this->y,::Std_obj::_int((p->y * (int)256)));
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(SubIPoint_obj,mulF,(void))

Void SubIPoint_obj::divF( ::nme::geom::Point p){
{
		HX_SOURCE_PUSH("SubIPoint_obj::divF")
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubIPoint.hx",156)
		this->x = ::Std_obj::_int((double(this->x) / double(::Std_obj::_int((p->x * (int)256)))));
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubIPoint.hx",157)
		this->y = ::Std_obj::_int((double(this->y) / double(::Std_obj::_int((p->y * (int)256)))));
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(SubIPoint_obj,divF,(void))

bool SubIPoint_obj::eqXF( ::nme::geom::Point p){
	HX_SOURCE_PUSH("SubIPoint_obj::eqXF")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubIPoint.hx",161)
	return (this->x == ::Std_obj::_int((p->x * (int)256)));
}


HX_DEFINE_DYNAMIC_FUNC1(SubIPoint_obj,eqXF,return )

bool SubIPoint_obj::eqYF( ::nme::geom::Point p){
	HX_SOURCE_PUSH("SubIPoint_obj::eqYF")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubIPoint.hx",166)
	return (this->y == ::Std_obj::_int((p->y * (int)256)));
}


HX_DEFINE_DYNAMIC_FUNC1(SubIPoint_obj,eqYF,return )

bool SubIPoint_obj::eqF( ::nme::geom::Point p){
	HX_SOURCE_PUSH("SubIPoint_obj::eqF")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubIPoint.hx",171)
	return (bool((this->x == ::Std_obj::_int((p->x * (int)256)))) && bool((this->y == ::Std_obj::_int((p->y * (int)256)))));
}


HX_DEFINE_DYNAMIC_FUNC1(SubIPoint_obj,eqF,return )

::com::ludamix::triad::geom::IPoint SubIPoint_obj::genIPoint( ){
	HX_SOURCE_PUSH("SubIPoint_obj::genIPoint")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubIPoint.hx",175)
	return ::com::ludamix::triad::geom::IPoint_obj::__new((int(this->x) >> int((int)8)),(int(this->y) >> int((int)8)));
}


HX_DEFINE_DYNAMIC_FUNC0(SubIPoint_obj,genIPoint,return )

::nme::geom::Point SubIPoint_obj::genFPoint( ){
	HX_SOURCE_PUSH("SubIPoint_obj::genFPoint")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubIPoint.hx",176)
	return ::nme::geom::Point_obj::__new((double(this->x) / double((int)256)),(double(this->y) / double((int)256)));
}


HX_DEFINE_DYNAMIC_FUNC0(SubIPoint_obj,genFPoint,return )

int SubIPoint_obj::BITS;

::com::ludamix::triad::geom::SubIPoint SubIPoint_obj::fromInt( int x,int y){
	HX_SOURCE_PUSH("SubIPoint_obj::fromInt")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubIPoint.hx",23)
	return ::com::ludamix::triad::geom::SubIPoint_obj::__new((int(x) << int((int)8)),(int(y) << int((int)8)));
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(SubIPoint_obj,fromInt,return )

::com::ludamix::triad::geom::SubIPoint SubIPoint_obj::fromFloat( double x,double y){
	HX_SOURCE_PUSH("SubIPoint_obj::fromFloat")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubIPoint.hx",28)
	return ::com::ludamix::triad::geom::SubIPoint_obj::__new(::Std_obj::_int((x * (int)256)),::Std_obj::_int((y * (int)256)));
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(SubIPoint_obj,fromFloat,return )

::com::ludamix::triad::geom::SubIPoint SubIPoint_obj::fromIPoint( ::com::ludamix::triad::geom::IPoint ip){
	HX_SOURCE_PUSH("SubIPoint_obj::fromIPoint")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubIPoint.hx",33)
	return ::com::ludamix::triad::geom::SubIPoint_obj::__new((int(ip->x) << int((int)8)),(int(ip->y) << int((int)8)));
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(SubIPoint_obj,fromIPoint,return )

::com::ludamix::triad::geom::SubIPoint SubIPoint_obj::fromFPoint( ::nme::geom::Point fp){
	HX_SOURCE_PUSH("SubIPoint_obj::fromFPoint")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubIPoint.hx",38)
	return ::com::ludamix::triad::geom::SubIPoint_obj::__new(::Std_obj::_int((fp->x * (int)256)),::Std_obj::_int((fp->y * (int)256)));
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(SubIPoint_obj,fromFPoint,return )

int SubIPoint_obj::shiftF( double val){
	HX_SOURCE_PUSH("SubIPoint_obj::shiftF")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubIPoint.hx",178)
	return ::Std_obj::_int((val * (int)256));
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(SubIPoint_obj,shiftF,return )

int SubIPoint_obj::shift( int val){
	HX_SOURCE_PUSH("SubIPoint_obj::shift")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubIPoint.hx",179)
	return (int(val) << int((int)8));
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(SubIPoint_obj,shift,return )

int SubIPoint_obj::unshift( int val){
	HX_SOURCE_PUSH("SubIPoint_obj::unshift")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubIPoint.hx",180)
	return (int(val) >> int((int)8));
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(SubIPoint_obj,unshift,return )

double SubIPoint_obj::unshiftF( int val){
	HX_SOURCE_PUSH("SubIPoint_obj::unshiftF")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubIPoint.hx",181)
	return (double(val) / double((int)256));
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(SubIPoint_obj,unshiftF,return )


SubIPoint_obj::SubIPoint_obj()
{
}

void SubIPoint_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(SubIPoint);
	HX_MARK_MEMBER_NAME(x,"x");
	HX_MARK_MEMBER_NAME(y,"y");
	HX_MARK_END_CLASS();
}

Dynamic SubIPoint_obj::__Field(const ::String &inName)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"x") ) { return x; }
		if (HX_FIELD_EQ(inName,"y") ) { return y; }
		break;
	case 2:
		if (HX_FIELD_EQ(inName,"xi") ) { return xi_dyn(); }
		if (HX_FIELD_EQ(inName,"yi") ) { return yi_dyn(); }
		if (HX_FIELD_EQ(inName,"xf") ) { return xf_dyn(); }
		if (HX_FIELD_EQ(inName,"yf") ) { return yf_dyn(); }
		if (HX_FIELD_EQ(inName,"eq") ) { return eq_dyn(); }
		break;
	case 3:
		if (HX_FIELD_EQ(inName,"add") ) { return add_dyn(); }
		if (HX_FIELD_EQ(inName,"sub") ) { return sub_dyn(); }
		if (HX_FIELD_EQ(inName,"mul") ) { return mul_dyn(); }
		if (HX_FIELD_EQ(inName,"div") ) { return div_dyn(); }
		if (HX_FIELD_EQ(inName,"eqX") ) { return eqX_dyn(); }
		if (HX_FIELD_EQ(inName,"eqY") ) { return eqY_dyn(); }
		if (HX_FIELD_EQ(inName,"eqI") ) { return eqI_dyn(); }
		if (HX_FIELD_EQ(inName,"eqF") ) { return eqF_dyn(); }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"BITS") ) { return BITS; }
		if (HX_FIELD_EQ(inName,"addI") ) { return addI_dyn(); }
		if (HX_FIELD_EQ(inName,"subI") ) { return subI_dyn(); }
		if (HX_FIELD_EQ(inName,"mulI") ) { return mulI_dyn(); }
		if (HX_FIELD_EQ(inName,"divI") ) { return divI_dyn(); }
		if (HX_FIELD_EQ(inName,"eqXI") ) { return eqXI_dyn(); }
		if (HX_FIELD_EQ(inName,"eqYI") ) { return eqYI_dyn(); }
		if (HX_FIELD_EQ(inName,"addF") ) { return addF_dyn(); }
		if (HX_FIELD_EQ(inName,"subF") ) { return subF_dyn(); }
		if (HX_FIELD_EQ(inName,"mulF") ) { return mulF_dyn(); }
		if (HX_FIELD_EQ(inName,"divF") ) { return divF_dyn(); }
		if (HX_FIELD_EQ(inName,"eqXF") ) { return eqXF_dyn(); }
		if (HX_FIELD_EQ(inName,"eqYF") ) { return eqYF_dyn(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"shift") ) { return shift_dyn(); }
		if (HX_FIELD_EQ(inName,"clone") ) { return clone_dyn(); }
		if (HX_FIELD_EQ(inName,"paste") ) { return paste_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"shiftF") ) { return shiftF_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"fromInt") ) { return fromInt_dyn(); }
		if (HX_FIELD_EQ(inName,"unshift") ) { return unshift_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"unshiftF") ) { return unshiftF_dyn(); }
		if (HX_FIELD_EQ(inName,"toString") ) { return toString_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"fromFloat") ) { return fromFloat_dyn(); }
		if (HX_FIELD_EQ(inName,"genIPoint") ) { return genIPoint_dyn(); }
		if (HX_FIELD_EQ(inName,"genFPoint") ) { return genFPoint_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"fromIPoint") ) { return fromIPoint_dyn(); }
		if (HX_FIELD_EQ(inName,"fromFPoint") ) { return fromFPoint_dyn(); }
	}
	return super::__Field(inName);
}

Dynamic SubIPoint_obj::__SetField(const ::String &inName,const Dynamic &inValue)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"x") ) { x=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"y") ) { y=inValue.Cast< int >(); return inValue; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"BITS") ) { BITS=inValue.Cast< int >(); return inValue; }
	}
	return super::__SetField(inName,inValue);
}

void SubIPoint_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("x"));
	outFields->push(HX_CSTRING("y"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("BITS"),
	HX_CSTRING("fromInt"),
	HX_CSTRING("fromFloat"),
	HX_CSTRING("fromIPoint"),
	HX_CSTRING("fromFPoint"),
	HX_CSTRING("shiftF"),
	HX_CSTRING("shift"),
	HX_CSTRING("unshift"),
	HX_CSTRING("unshiftF"),
	String(null()) };

static ::String sMemberFields[] = {
	HX_CSTRING("x"),
	HX_CSTRING("y"),
	HX_CSTRING("toString"),
	HX_CSTRING("xi"),
	HX_CSTRING("yi"),
	HX_CSTRING("xf"),
	HX_CSTRING("yf"),
	HX_CSTRING("clone"),
	HX_CSTRING("paste"),
	HX_CSTRING("add"),
	HX_CSTRING("sub"),
	HX_CSTRING("mul"),
	HX_CSTRING("div"),
	HX_CSTRING("eqX"),
	HX_CSTRING("eqY"),
	HX_CSTRING("eq"),
	HX_CSTRING("addI"),
	HX_CSTRING("subI"),
	HX_CSTRING("mulI"),
	HX_CSTRING("divI"),
	HX_CSTRING("eqXI"),
	HX_CSTRING("eqYI"),
	HX_CSTRING("eqI"),
	HX_CSTRING("addF"),
	HX_CSTRING("subF"),
	HX_CSTRING("mulF"),
	HX_CSTRING("divF"),
	HX_CSTRING("eqXF"),
	HX_CSTRING("eqYF"),
	HX_CSTRING("eqF"),
	HX_CSTRING("genIPoint"),
	HX_CSTRING("genFPoint"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(SubIPoint_obj::BITS,"BITS");
};

Class SubIPoint_obj::__mClass;

void SubIPoint_obj::__register()
{
	Static(__mClass) = hx::RegisterClass(HX_CSTRING("com.ludamix.triad.geom.SubIPoint"), hx::TCanCast< SubIPoint_obj> ,sStaticFields,sMemberFields,
	&__CreateEmpty, &__Create,
	&super::__SGetClass(), 0, sMarkStatics);
}

void SubIPoint_obj::__boot()
{
	hx::Static(BITS) = (int)8;
}

} // end namespace com
} // end namespace ludamix
} // end namespace triad
} // end namespace geom
