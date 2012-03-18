#include <hxcpp.h>

#ifndef INCLUDED_Std
#include <Std.h>
#endif
#ifndef INCLUDED_com_ludamix_triad_geom_AABB
#include <com/ludamix/triad/geom/AABB.h>
#endif
#ifndef INCLUDED_com_ludamix_triad_geom_SubIPoint
#include <com/ludamix/triad/geom/SubIPoint.h>
#endif
namespace com{
namespace ludamix{
namespace triad{
namespace geom{

Void AABB_obj::__construct(int x,int y,int w,int h)
{
{
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/AABB.hx",13)
	this->x = x;
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/AABB.hx",14)
	this->y = y;
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/AABB.hx",15)
	this->w = w;
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/AABB.hx",16)
	this->h = h;
}
;
	return null();
}

AABB_obj::~AABB_obj() { }

Dynamic AABB_obj::__CreateEmpty() { return  new AABB_obj; }
hx::ObjectPtr< AABB_obj > AABB_obj::__new(int x,int y,int w,int h)
{  hx::ObjectPtr< AABB_obj > result = new AABB_obj();
	result->__construct(x,y,w,h);
	return result;}

Dynamic AABB_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< AABB_obj > result = new AABB_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2],inArgs[3]);
	return result;}

int AABB_obj::xi( ){
	HX_SOURCE_PUSH("AABB_obj::xi")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/AABB.hx",39)
	return (int(this->x) >> int((int)8));
}


HX_DEFINE_DYNAMIC_FUNC0(AABB_obj,xi,return )

int AABB_obj::yi( ){
	HX_SOURCE_PUSH("AABB_obj::yi")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/AABB.hx",40)
	return (int(this->y) >> int((int)8));
}


HX_DEFINE_DYNAMIC_FUNC0(AABB_obj,yi,return )

int AABB_obj::wi( ){
	HX_SOURCE_PUSH("AABB_obj::wi")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/AABB.hx",41)
	return (int(this->w) >> int((int)8));
}


HX_DEFINE_DYNAMIC_FUNC0(AABB_obj,wi,return )

int AABB_obj::hi( ){
	HX_SOURCE_PUSH("AABB_obj::hi")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/AABB.hx",42)
	return (int(this->h) >> int((int)8));
}


HX_DEFINE_DYNAMIC_FUNC0(AABB_obj,hi,return )

double AABB_obj::xf( ){
	HX_SOURCE_PUSH("AABB_obj::xf")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/AABB.hx",44)
	return (double(this->x) / double((int)256));
}


HX_DEFINE_DYNAMIC_FUNC0(AABB_obj,xf,return )

double AABB_obj::yf( ){
	HX_SOURCE_PUSH("AABB_obj::yf")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/AABB.hx",45)
	return (double(this->y) / double((int)256));
}


HX_DEFINE_DYNAMIC_FUNC0(AABB_obj,yf,return )

double AABB_obj::wf( ){
	HX_SOURCE_PUSH("AABB_obj::wf")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/AABB.hx",46)
	return (double(this->w) / double((int)256));
}


HX_DEFINE_DYNAMIC_FUNC0(AABB_obj,wf,return )

double AABB_obj::hf( ){
	HX_SOURCE_PUSH("AABB_obj::hf")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/AABB.hx",47)
	return (double(this->h) / double((int)256));
}


HX_DEFINE_DYNAMIC_FUNC0(AABB_obj,hf,return )

int AABB_obj::l( Dynamic __o_plus){
int plus = __o_plus.Default(0);
	HX_SOURCE_PUSH("AABB_obj::l");
{
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/AABB.hx",51)
		return (this->x + plus);
	}
}


HX_DEFINE_DYNAMIC_FUNC1(AABB_obj,l,return )

int AABB_obj::r( Dynamic __o_plus){
int plus = __o_plus.Default(0);
	HX_SOURCE_PUSH("AABB_obj::r");
{
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/AABB.hx",52)
		return ((this->x + this->w) + plus);
	}
}


HX_DEFINE_DYNAMIC_FUNC1(AABB_obj,r,return )

int AABB_obj::t( Dynamic __o_plus){
int plus = __o_plus.Default(0);
	HX_SOURCE_PUSH("AABB_obj::t");
{
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/AABB.hx",53)
		return (this->y + plus);
	}
}


HX_DEFINE_DYNAMIC_FUNC1(AABB_obj,t,return )

int AABB_obj::b( Dynamic __o_plus){
int plus = __o_plus.Default(0);
	HX_SOURCE_PUSH("AABB_obj::b");
{
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/AABB.hx",54)
		return ((this->y + this->h) + plus);
	}
}


HX_DEFINE_DYNAMIC_FUNC1(AABB_obj,b,return )

int AABB_obj::li( Dynamic __o_plus){
int plus = __o_plus.Default(0);
	HX_SOURCE_PUSH("AABB_obj::li");
{
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/AABB.hx",56)
		return (int((this->x + ((int(plus) << int((int)8))))) >> int((int)8));
	}
}


HX_DEFINE_DYNAMIC_FUNC1(AABB_obj,li,return )

int AABB_obj::ri( Dynamic __o_plus){
int plus = __o_plus.Default(0);
	HX_SOURCE_PUSH("AABB_obj::ri");
{
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/AABB.hx",57)
		return (int(((this->x + this->w) + ((int(plus) << int((int)8))))) >> int((int)8));
	}
}


HX_DEFINE_DYNAMIC_FUNC1(AABB_obj,ri,return )

int AABB_obj::ti( Dynamic __o_plus){
int plus = __o_plus.Default(0);
	HX_SOURCE_PUSH("AABB_obj::ti");
{
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/AABB.hx",58)
		return (int((this->y + ((int(plus) << int((int)8))))) >> int((int)8));
	}
}


HX_DEFINE_DYNAMIC_FUNC1(AABB_obj,ti,return )

int AABB_obj::bi( Dynamic __o_plus){
int plus = __o_plus.Default(0);
	HX_SOURCE_PUSH("AABB_obj::bi");
{
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/AABB.hx",59)
		return (int(((this->y + this->h) + ((int(plus) << int((int)8))))) >> int((int)8));
	}
}


HX_DEFINE_DYNAMIC_FUNC1(AABB_obj,bi,return )

double AABB_obj::lf( Dynamic __o_plus){
double plus = __o_plus.Default(0.);
	HX_SOURCE_PUSH("AABB_obj::lf");
{
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/AABB.hx",61)
		return (double(((this->x + ::Std_obj::_int((plus * (int)256))))) / double((int)256));
	}
}


HX_DEFINE_DYNAMIC_FUNC1(AABB_obj,lf,return )

double AABB_obj::rf( Dynamic __o_plus){
double plus = __o_plus.Default(0.);
	HX_SOURCE_PUSH("AABB_obj::rf");
{
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/AABB.hx",62)
		return (double((((this->x + this->w) + ::Std_obj::_int((plus * (int)256))))) / double((int)256));
	}
}


HX_DEFINE_DYNAMIC_FUNC1(AABB_obj,rf,return )

double AABB_obj::tf( Dynamic __o_plus){
double plus = __o_plus.Default(0.);
	HX_SOURCE_PUSH("AABB_obj::tf");
{
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/AABB.hx",63)
		return (double(((this->y + ::Std_obj::_int((plus * (int)256))))) / double((int)256));
	}
}


HX_DEFINE_DYNAMIC_FUNC1(AABB_obj,tf,return )

double AABB_obj::bf( Dynamic __o_plus){
double plus = __o_plus.Default(0.);
	HX_SOURCE_PUSH("AABB_obj::bf");
{
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/AABB.hx",64)
		return (double((((this->y + this->h) + ::Std_obj::_int((plus * (int)256))))) / double((int)256));
	}
}


HX_DEFINE_DYNAMIC_FUNC1(AABB_obj,bf,return )

int AABB_obj::lp( Dynamic __o_pct){
double pct = __o_pct.Default(0.);
	HX_SOURCE_PUSH("AABB_obj::lp");
{
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/AABB.hx",68)
		return (this->x + ::Std_obj::_int((pct * this->w)));
	}
}


HX_DEFINE_DYNAMIC_FUNC1(AABB_obj,lp,return )

int AABB_obj::rp( Dynamic __o_pct){
double pct = __o_pct.Default(0.);
	HX_SOURCE_PUSH("AABB_obj::rp");
{
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/AABB.hx",69)
		return (this->x + ::Std_obj::_int((this->w + (pct * this->w))));
	}
}


HX_DEFINE_DYNAMIC_FUNC1(AABB_obj,rp,return )

int AABB_obj::tp( Dynamic __o_pct){
double pct = __o_pct.Default(0.);
	HX_SOURCE_PUSH("AABB_obj::tp");
{
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/AABB.hx",70)
		return (this->y + ::Std_obj::_int((pct * this->h)));
	}
}


HX_DEFINE_DYNAMIC_FUNC1(AABB_obj,tp,return )

int AABB_obj::bp( Dynamic __o_pct){
double pct = __o_pct.Default(0.);
	HX_SOURCE_PUSH("AABB_obj::bp");
{
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/AABB.hx",71)
		return (this->y + ::Std_obj::_int((this->h + (pct * this->h))));
	}
}


HX_DEFINE_DYNAMIC_FUNC1(AABB_obj,bp,return )

int AABB_obj::lpi( Dynamic __o_pct){
double pct = __o_pct.Default(0.);
	HX_SOURCE_PUSH("AABB_obj::lpi");
{
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/AABB.hx",73)
		return (int((this->x + ::Std_obj::_int((pct * this->w)))) >> int((int)8));
	}
}


HX_DEFINE_DYNAMIC_FUNC1(AABB_obj,lpi,return )

int AABB_obj::rpi( Dynamic __o_pct){
double pct = __o_pct.Default(0.);
	HX_SOURCE_PUSH("AABB_obj::rpi");
{
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/AABB.hx",74)
		return (int((this->x + ::Std_obj::_int((this->w + (pct * this->w))))) >> int((int)8));
	}
}


HX_DEFINE_DYNAMIC_FUNC1(AABB_obj,rpi,return )

int AABB_obj::tpi( Dynamic __o_pct){
double pct = __o_pct.Default(0.);
	HX_SOURCE_PUSH("AABB_obj::tpi");
{
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/AABB.hx",75)
		return (int((this->y + ::Std_obj::_int((pct * this->h)))) >> int((int)8));
	}
}


HX_DEFINE_DYNAMIC_FUNC1(AABB_obj,tpi,return )

int AABB_obj::bpi( Dynamic __o_pct){
double pct = __o_pct.Default(0.);
	HX_SOURCE_PUSH("AABB_obj::bpi");
{
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/AABB.hx",76)
		return (int((this->y + ::Std_obj::_int((this->h + (pct * this->h))))) >> int((int)8));
	}
}


HX_DEFINE_DYNAMIC_FUNC1(AABB_obj,bpi,return )

double AABB_obj::lpf( Dynamic __o_pct){
double pct = __o_pct.Default(0.);
	HX_SOURCE_PUSH("AABB_obj::lpf");
{
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/AABB.hx",78)
		return (double(((this->x + ::Std_obj::_int((pct * this->w))))) / double((int)256));
	}
}


HX_DEFINE_DYNAMIC_FUNC1(AABB_obj,lpf,return )

double AABB_obj::rpf( Dynamic __o_pct){
double pct = __o_pct.Default(0.);
	HX_SOURCE_PUSH("AABB_obj::rpf");
{
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/AABB.hx",79)
		return (double(((this->x + ::Std_obj::_int((this->w + (pct * this->w)))))) / double((int)256));
	}
}


HX_DEFINE_DYNAMIC_FUNC1(AABB_obj,rpf,return )

double AABB_obj::tpf( Dynamic __o_pct){
double pct = __o_pct.Default(0.);
	HX_SOURCE_PUSH("AABB_obj::tpf");
{
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/AABB.hx",80)
		return (double(((this->y + ::Std_obj::_int((pct * this->h))))) / double((int)256));
	}
}


HX_DEFINE_DYNAMIC_FUNC1(AABB_obj,tpf,return )

double AABB_obj::bpf( Dynamic __o_pct){
double pct = __o_pct.Default(0.);
	HX_SOURCE_PUSH("AABB_obj::bpf");
{
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/AABB.hx",81)
		return (double(((this->y + ::Std_obj::_int((this->h + (pct * this->h)))))) / double((int)256));
	}
}


HX_DEFINE_DYNAMIC_FUNC1(AABB_obj,bpf,return )

Void AABB_obj::tl( ::com::ludamix::triad::geom::SubIPoint v){
{
		HX_SOURCE_PUSH("AABB_obj::tl")
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/AABB.hx",85)
		v->x = this->x;
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/AABB.hx",85)
		v->y = this->y;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(AABB_obj,tl,(void))

Void AABB_obj::tr( ::com::ludamix::triad::geom::SubIPoint v){
{
		HX_SOURCE_PUSH("AABB_obj::tr")
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/AABB.hx",86)
		v->x = (this->x + this->w);
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/AABB.hx",86)
		v->y = this->y;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(AABB_obj,tr,(void))

Void AABB_obj::bl( ::com::ludamix::triad::geom::SubIPoint v){
{
		HX_SOURCE_PUSH("AABB_obj::bl")
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/AABB.hx",87)
		v->x = this->x;
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/AABB.hx",87)
		v->y = (this->y + this->h);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(AABB_obj,bl,(void))

Void AABB_obj::br( ::com::ludamix::triad::geom::SubIPoint v){
{
		HX_SOURCE_PUSH("AABB_obj::br")
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/AABB.hx",88)
		v->x = (this->x + this->w);
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/AABB.hx",88)
		v->y = (this->y + this->h);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(AABB_obj,br,(void))

::com::ludamix::triad::geom::SubIPoint AABB_obj::tlGen( ){
	HX_SOURCE_PUSH("AABB_obj::tlGen")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/AABB.hx",90)
	return ::com::ludamix::triad::geom::SubIPoint_obj::__new(this->x,this->y);
}


HX_DEFINE_DYNAMIC_FUNC0(AABB_obj,tlGen,return )

::com::ludamix::triad::geom::SubIPoint AABB_obj::trGen( ){
	HX_SOURCE_PUSH("AABB_obj::trGen")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/AABB.hx",91)
	return ::com::ludamix::triad::geom::SubIPoint_obj::__new((this->x + this->w),this->y);
}


HX_DEFINE_DYNAMIC_FUNC0(AABB_obj,trGen,return )

::com::ludamix::triad::geom::SubIPoint AABB_obj::blGen( ){
	HX_SOURCE_PUSH("AABB_obj::blGen")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/AABB.hx",92)
	return ::com::ludamix::triad::geom::SubIPoint_obj::__new(this->x,(this->y + this->h));
}


HX_DEFINE_DYNAMIC_FUNC0(AABB_obj,blGen,return )

::com::ludamix::triad::geom::SubIPoint AABB_obj::brGen( ){
	HX_SOURCE_PUSH("AABB_obj::brGen")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/AABB.hx",93)
	return ::com::ludamix::triad::geom::SubIPoint_obj::__new((this->x + this->w),(this->y + this->h));
}


HX_DEFINE_DYNAMIC_FUNC0(AABB_obj,brGen,return )

int AABB_obj::cx( Dynamic __o_plus){
int plus = __o_plus.Default(0);
	HX_SOURCE_PUSH("AABB_obj::cx");
{
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/AABB.hx",97)
		return ((this->x + ::Std_obj::_int((double(this->w) / double((int)2)))) + plus);
	}
}


HX_DEFINE_DYNAMIC_FUNC1(AABB_obj,cx,return )

int AABB_obj::cy( Dynamic __o_plus){
int plus = __o_plus.Default(0);
	HX_SOURCE_PUSH("AABB_obj::cy");
{
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/AABB.hx",98)
		return ((this->y + ::Std_obj::_int((double(this->h) / double((int)2)))) + plus);
	}
}


HX_DEFINE_DYNAMIC_FUNC1(AABB_obj,cy,return )

int AABB_obj::cxi( Dynamic __o_plus){
int plus = __o_plus.Default(0);
	HX_SOURCE_PUSH("AABB_obj::cxi");
{
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/AABB.hx",100)
		return (int(((this->x + ::Std_obj::_int((double(this->w) / double((int)2)))) + ((int(plus) << int((int)8))))) >> int((int)8));
	}
}


HX_DEFINE_DYNAMIC_FUNC1(AABB_obj,cxi,return )

int AABB_obj::cyi( Dynamic __o_plus){
int plus = __o_plus.Default(0);
	HX_SOURCE_PUSH("AABB_obj::cyi");
{
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/AABB.hx",101)
		return (int(((this->y + ::Std_obj::_int((double(this->h) / double((int)2)))) + ((int(plus) << int((int)8))))) >> int((int)8));
	}
}


HX_DEFINE_DYNAMIC_FUNC1(AABB_obj,cyi,return )

double AABB_obj::cxf( Dynamic __o_plus){
double plus = __o_plus.Default(0.);
	HX_SOURCE_PUSH("AABB_obj::cxf");
{
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/AABB.hx",103)
		return (double((((this->x + ::Std_obj::_int((double(this->w) / double((int)2)))) + ::Std_obj::_int((plus * (int)256))))) / double((int)256));
	}
}


HX_DEFINE_DYNAMIC_FUNC1(AABB_obj,cxf,return )

double AABB_obj::cyf( Dynamic __o_plus){
double plus = __o_plus.Default(0.);
	HX_SOURCE_PUSH("AABB_obj::cyf");
{
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/AABB.hx",104)
		return (double((((this->y + ::Std_obj::_int((double(this->h) / double((int)2)))) + ::Std_obj::_int((plus * (int)256))))) / double((int)256));
	}
}


HX_DEFINE_DYNAMIC_FUNC1(AABB_obj,cyf,return )

int AABB_obj::cxp( Dynamic __o_pct){
double pct = __o_pct.Default(0.);
	HX_SOURCE_PUSH("AABB_obj::cxp");
{
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/AABB.hx",108)
		return (this->x + ::Std_obj::_int(((double(this->w) / double((int)2)) + (pct * this->w))));
	}
}


HX_DEFINE_DYNAMIC_FUNC1(AABB_obj,cxp,return )

int AABB_obj::cyp( Dynamic __o_pct){
double pct = __o_pct.Default(0.);
	HX_SOURCE_PUSH("AABB_obj::cyp");
{
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/AABB.hx",109)
		return (this->y + ::Std_obj::_int(((double(this->h) / double((int)2)) + (pct * this->h))));
	}
}


HX_DEFINE_DYNAMIC_FUNC1(AABB_obj,cyp,return )

int AABB_obj::cxpi( Dynamic __o_pct){
double pct = __o_pct.Default(0.);
	HX_SOURCE_PUSH("AABB_obj::cxpi");
{
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/AABB.hx",111)
		return (int((this->x + ::Std_obj::_int(((double(this->w) / double((int)2)) + (pct * this->w))))) >> int((int)8));
	}
}


HX_DEFINE_DYNAMIC_FUNC1(AABB_obj,cxpi,return )

int AABB_obj::cypi( Dynamic __o_pct){
double pct = __o_pct.Default(0.);
	HX_SOURCE_PUSH("AABB_obj::cypi");
{
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/AABB.hx",112)
		return (int((this->y + ::Std_obj::_int(((double(this->h) / double((int)2)) + (pct * this->h))))) >> int((int)8));
	}
}


HX_DEFINE_DYNAMIC_FUNC1(AABB_obj,cypi,return )

double AABB_obj::cxpf( Dynamic __o_pct){
double pct = __o_pct.Default(0.);
	HX_SOURCE_PUSH("AABB_obj::cxpf");
{
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/AABB.hx",114)
		return (double(((this->x + ::Std_obj::_int(((double(this->w) / double((int)2)) + (pct * this->w)))))) / double((int)256));
	}
}


HX_DEFINE_DYNAMIC_FUNC1(AABB_obj,cxpf,return )

double AABB_obj::cypf( Dynamic __o_pct){
double pct = __o_pct.Default(0.);
	HX_SOURCE_PUSH("AABB_obj::cypf");
{
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/AABB.hx",115)
		return (double(((this->y + ::Std_obj::_int(((double(this->h) / double((int)2)) + (pct * this->h)))))) / double((int)256));
	}
}


HX_DEFINE_DYNAMIC_FUNC1(AABB_obj,cypf,return )

Void AABB_obj::resizeCenter( double pct){
{
		HX_SOURCE_PUSH("AABB_obj::resizeCenter")
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/AABB.hx",119)
		int nw = ::Std_obj::_int((this->w * pct));
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/AABB.hx",120)
		this->x = (this->x + ::Std_obj::_int(((double(this->w) / double((int)2)) + ((double(-(pct)) / double((int)2)) * this->w))));
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/AABB.hx",121)
		this->w = nw;
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/AABB.hx",123)
		int nh = ::Std_obj::_int((this->h * pct));
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/AABB.hx",124)
		this->y = (this->y + ::Std_obj::_int(((double(this->h) / double((int)2)) + ((double(-(pct)) / double((int)2)) * this->h))));
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/AABB.hx",125)
		this->h = nh;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(AABB_obj,resizeCenter,(void))

Void AABB_obj::paste( ::com::ludamix::triad::geom::AABB aabb){
{
		HX_SOURCE_PUSH("AABB_obj::paste")
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/AABB.hx",128)
		aabb->x = this->x;
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/AABB.hx",128)
		aabb->y = this->y;
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/AABB.hx",128)
		aabb->w = this->w;
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/AABB.hx",128)
		aabb->h = this->h;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(AABB_obj,paste,(void))

::com::ludamix::triad::geom::AABB AABB_obj::clone( ){
	HX_SOURCE_PUSH("AABB_obj::clone")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/AABB.hx",129)
	return ::com::ludamix::triad::geom::AABB_obj::__new(this->x,this->y,this->w,this->h);
}


HX_DEFINE_DYNAMIC_FUNC0(AABB_obj,clone,return )

::String AABB_obj::toString( ){
	HX_SOURCE_PUSH("AABB_obj::toString")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/AABB.hx",132)
	return ::Std_obj::string(Dynamic( Array_obj<Dynamic>::__new().Add(HX_CSTRING("rect")).Add((double(this->x) / double((int)256))).Add((double(this->y) / double((int)256))).Add((double(this->w) / double((int)256))).Add((double(this->h) / double((int)256)))));
}


HX_DEFINE_DYNAMIC_FUNC0(AABB_obj,toString,return )

bool AABB_obj::containsPoint( ::com::ludamix::triad::geom::SubIPoint pt){
	HX_SOURCE_PUSH("AABB_obj::containsPoint")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/AABB.hx",137)
	return (bool((bool((bool((pt->x >= this->x)) && bool((pt->x <= (this->x + this->w))))) && bool((pt->y >= this->y)))) && bool((pt->y <= (this->y + this->h))));
}


HX_DEFINE_DYNAMIC_FUNC1(AABB_obj,containsPoint,return )

bool AABB_obj::intersectsAABB( ::com::ludamix::triad::geom::AABB other){
	HX_SOURCE_PUSH("AABB_obj::intersectsAABB")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/AABB.hx",142)
	return !(((bool((bool((bool(((this->x + this->w) < other->x)) || bool((this->x > (other->x + other->w))))) || bool(((this->y + this->h) < other->y)))) || bool((this->y > (other->y + other->h))))));
}


HX_DEFINE_DYNAMIC_FUNC1(AABB_obj,intersectsAABB,return )

::com::ludamix::triad::geom::AABB AABB_obj::fromInt( int x,int y,int w,int h){
	HX_SOURCE_PUSH("AABB_obj::fromInt")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/AABB.hx",20)
	return ::com::ludamix::triad::geom::AABB_obj::__new((int(x) << int((int)8)),(int(y) << int((int)8)),(int(w) << int((int)8)),(int(h) << int((int)8)));
}


STATIC_HX_DEFINE_DYNAMIC_FUNC4(AABB_obj,fromInt,return )

::com::ludamix::triad::geom::AABB AABB_obj::fromFloat( double x,double y,double w,double h){
	HX_SOURCE_PUSH("AABB_obj::fromFloat")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/AABB.hx",25)
	return ::com::ludamix::triad::geom::AABB_obj::__new(::Std_obj::_int((x * (int)256)),::Std_obj::_int((y * (int)256)),::Std_obj::_int((w * (int)256)),::Std_obj::_int((h * (int)256)));
}


STATIC_HX_DEFINE_DYNAMIC_FUNC4(AABB_obj,fromFloat,return )

::com::ludamix::triad::geom::AABB AABB_obj::centerFromInt( int w,int h,Dynamic __o_x,Dynamic __o_y){
int x = __o_x.Default(0);
int y = __o_y.Default(0);
	HX_SOURCE_PUSH("AABB_obj::centerFromInt");
{
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/AABB.hx",30)
		return ::com::ludamix::triad::geom::AABB_obj::__new((int((x + ::Std_obj::_int((double(-(w)) / double((int)2))))) << int((int)8)),(int((y + ::Std_obj::_int((double(-(h)) / double((int)2))))) << int((int)8)),(int(w) << int((int)8)),(int(h) << int((int)8)));
	}
}


STATIC_HX_DEFINE_DYNAMIC_FUNC4(AABB_obj,centerFromInt,return )

::com::ludamix::triad::geom::AABB AABB_obj::centerFromFloat( double w,double h,Dynamic __o_x,Dynamic __o_y){
double x = __o_x.Default(0);
double y = __o_y.Default(0);
	HX_SOURCE_PUSH("AABB_obj::centerFromFloat");
{
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/AABB.hx",35)
		return ::com::ludamix::triad::geom::AABB_obj::__new(::Std_obj::_int((((x + (double(-(w)) / double((int)2)))) * (int)256)),::Std_obj::_int((((y + (double(-(h)) / double((int)2)))) * (int)256)),::Std_obj::_int((w * (int)256)),::Std_obj::_int((h * (int)256)));
	}
}


STATIC_HX_DEFINE_DYNAMIC_FUNC4(AABB_obj,centerFromFloat,return )


AABB_obj::AABB_obj()
{
}

void AABB_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(AABB);
	HX_MARK_MEMBER_NAME(x,"x");
	HX_MARK_MEMBER_NAME(y,"y");
	HX_MARK_MEMBER_NAME(w,"w");
	HX_MARK_MEMBER_NAME(h,"h");
	HX_MARK_END_CLASS();
}

Dynamic AABB_obj::__Field(const ::String &inName)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"x") ) { return x; }
		if (HX_FIELD_EQ(inName,"y") ) { return y; }
		if (HX_FIELD_EQ(inName,"w") ) { return w; }
		if (HX_FIELD_EQ(inName,"h") ) { return h; }
		if (HX_FIELD_EQ(inName,"l") ) { return l_dyn(); }
		if (HX_FIELD_EQ(inName,"r") ) { return r_dyn(); }
		if (HX_FIELD_EQ(inName,"t") ) { return t_dyn(); }
		if (HX_FIELD_EQ(inName,"b") ) { return b_dyn(); }
		break;
	case 2:
		if (HX_FIELD_EQ(inName,"xi") ) { return xi_dyn(); }
		if (HX_FIELD_EQ(inName,"yi") ) { return yi_dyn(); }
		if (HX_FIELD_EQ(inName,"wi") ) { return wi_dyn(); }
		if (HX_FIELD_EQ(inName,"hi") ) { return hi_dyn(); }
		if (HX_FIELD_EQ(inName,"xf") ) { return xf_dyn(); }
		if (HX_FIELD_EQ(inName,"yf") ) { return yf_dyn(); }
		if (HX_FIELD_EQ(inName,"wf") ) { return wf_dyn(); }
		if (HX_FIELD_EQ(inName,"hf") ) { return hf_dyn(); }
		if (HX_FIELD_EQ(inName,"li") ) { return li_dyn(); }
		if (HX_FIELD_EQ(inName,"ri") ) { return ri_dyn(); }
		if (HX_FIELD_EQ(inName,"ti") ) { return ti_dyn(); }
		if (HX_FIELD_EQ(inName,"bi") ) { return bi_dyn(); }
		if (HX_FIELD_EQ(inName,"lf") ) { return lf_dyn(); }
		if (HX_FIELD_EQ(inName,"rf") ) { return rf_dyn(); }
		if (HX_FIELD_EQ(inName,"tf") ) { return tf_dyn(); }
		if (HX_FIELD_EQ(inName,"bf") ) { return bf_dyn(); }
		if (HX_FIELD_EQ(inName,"lp") ) { return lp_dyn(); }
		if (HX_FIELD_EQ(inName,"rp") ) { return rp_dyn(); }
		if (HX_FIELD_EQ(inName,"tp") ) { return tp_dyn(); }
		if (HX_FIELD_EQ(inName,"bp") ) { return bp_dyn(); }
		if (HX_FIELD_EQ(inName,"tl") ) { return tl_dyn(); }
		if (HX_FIELD_EQ(inName,"tr") ) { return tr_dyn(); }
		if (HX_FIELD_EQ(inName,"bl") ) { return bl_dyn(); }
		if (HX_FIELD_EQ(inName,"br") ) { return br_dyn(); }
		if (HX_FIELD_EQ(inName,"cx") ) { return cx_dyn(); }
		if (HX_FIELD_EQ(inName,"cy") ) { return cy_dyn(); }
		break;
	case 3:
		if (HX_FIELD_EQ(inName,"lpi") ) { return lpi_dyn(); }
		if (HX_FIELD_EQ(inName,"rpi") ) { return rpi_dyn(); }
		if (HX_FIELD_EQ(inName,"tpi") ) { return tpi_dyn(); }
		if (HX_FIELD_EQ(inName,"bpi") ) { return bpi_dyn(); }
		if (HX_FIELD_EQ(inName,"lpf") ) { return lpf_dyn(); }
		if (HX_FIELD_EQ(inName,"rpf") ) { return rpf_dyn(); }
		if (HX_FIELD_EQ(inName,"tpf") ) { return tpf_dyn(); }
		if (HX_FIELD_EQ(inName,"bpf") ) { return bpf_dyn(); }
		if (HX_FIELD_EQ(inName,"cxi") ) { return cxi_dyn(); }
		if (HX_FIELD_EQ(inName,"cyi") ) { return cyi_dyn(); }
		if (HX_FIELD_EQ(inName,"cxf") ) { return cxf_dyn(); }
		if (HX_FIELD_EQ(inName,"cyf") ) { return cyf_dyn(); }
		if (HX_FIELD_EQ(inName,"cxp") ) { return cxp_dyn(); }
		if (HX_FIELD_EQ(inName,"cyp") ) { return cyp_dyn(); }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"cxpi") ) { return cxpi_dyn(); }
		if (HX_FIELD_EQ(inName,"cypi") ) { return cypi_dyn(); }
		if (HX_FIELD_EQ(inName,"cxpf") ) { return cxpf_dyn(); }
		if (HX_FIELD_EQ(inName,"cypf") ) { return cypf_dyn(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"tlGen") ) { return tlGen_dyn(); }
		if (HX_FIELD_EQ(inName,"trGen") ) { return trGen_dyn(); }
		if (HX_FIELD_EQ(inName,"blGen") ) { return blGen_dyn(); }
		if (HX_FIELD_EQ(inName,"brGen") ) { return brGen_dyn(); }
		if (HX_FIELD_EQ(inName,"paste") ) { return paste_dyn(); }
		if (HX_FIELD_EQ(inName,"clone") ) { return clone_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"fromInt") ) { return fromInt_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"toString") ) { return toString_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"fromFloat") ) { return fromFloat_dyn(); }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"resizeCenter") ) { return resizeCenter_dyn(); }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"centerFromInt") ) { return centerFromInt_dyn(); }
		if (HX_FIELD_EQ(inName,"containsPoint") ) { return containsPoint_dyn(); }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"intersectsAABB") ) { return intersectsAABB_dyn(); }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"centerFromFloat") ) { return centerFromFloat_dyn(); }
	}
	return super::__Field(inName);
}

Dynamic AABB_obj::__SetField(const ::String &inName,const Dynamic &inValue)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"x") ) { x=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"y") ) { y=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"w") ) { w=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"h") ) { h=inValue.Cast< int >(); return inValue; }
	}
	return super::__SetField(inName,inValue);
}

void AABB_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("x"));
	outFields->push(HX_CSTRING("y"));
	outFields->push(HX_CSTRING("w"));
	outFields->push(HX_CSTRING("h"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("fromInt"),
	HX_CSTRING("fromFloat"),
	HX_CSTRING("centerFromInt"),
	HX_CSTRING("centerFromFloat"),
	String(null()) };

static ::String sMemberFields[] = {
	HX_CSTRING("x"),
	HX_CSTRING("y"),
	HX_CSTRING("w"),
	HX_CSTRING("h"),
	HX_CSTRING("xi"),
	HX_CSTRING("yi"),
	HX_CSTRING("wi"),
	HX_CSTRING("hi"),
	HX_CSTRING("xf"),
	HX_CSTRING("yf"),
	HX_CSTRING("wf"),
	HX_CSTRING("hf"),
	HX_CSTRING("l"),
	HX_CSTRING("r"),
	HX_CSTRING("t"),
	HX_CSTRING("b"),
	HX_CSTRING("li"),
	HX_CSTRING("ri"),
	HX_CSTRING("ti"),
	HX_CSTRING("bi"),
	HX_CSTRING("lf"),
	HX_CSTRING("rf"),
	HX_CSTRING("tf"),
	HX_CSTRING("bf"),
	HX_CSTRING("lp"),
	HX_CSTRING("rp"),
	HX_CSTRING("tp"),
	HX_CSTRING("bp"),
	HX_CSTRING("lpi"),
	HX_CSTRING("rpi"),
	HX_CSTRING("tpi"),
	HX_CSTRING("bpi"),
	HX_CSTRING("lpf"),
	HX_CSTRING("rpf"),
	HX_CSTRING("tpf"),
	HX_CSTRING("bpf"),
	HX_CSTRING("tl"),
	HX_CSTRING("tr"),
	HX_CSTRING("bl"),
	HX_CSTRING("br"),
	HX_CSTRING("tlGen"),
	HX_CSTRING("trGen"),
	HX_CSTRING("blGen"),
	HX_CSTRING("brGen"),
	HX_CSTRING("cx"),
	HX_CSTRING("cy"),
	HX_CSTRING("cxi"),
	HX_CSTRING("cyi"),
	HX_CSTRING("cxf"),
	HX_CSTRING("cyf"),
	HX_CSTRING("cxp"),
	HX_CSTRING("cyp"),
	HX_CSTRING("cxpi"),
	HX_CSTRING("cypi"),
	HX_CSTRING("cxpf"),
	HX_CSTRING("cypf"),
	HX_CSTRING("resizeCenter"),
	HX_CSTRING("paste"),
	HX_CSTRING("clone"),
	HX_CSTRING("toString"),
	HX_CSTRING("containsPoint"),
	HX_CSTRING("intersectsAABB"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
};

Class AABB_obj::__mClass;

void AABB_obj::__register()
{
	Static(__mClass) = hx::RegisterClass(HX_CSTRING("com.ludamix.triad.geom.AABB"), hx::TCanCast< AABB_obj> ,sStaticFields,sMemberFields,
	&__CreateEmpty, &__Create,
	&super::__SGetClass(), 0, sMarkStatics);
}

void AABB_obj::__boot()
{
}

} // end namespace com
} // end namespace ludamix
} // end namespace triad
} // end namespace geom
