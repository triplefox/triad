#include <hxcpp.h>

#ifndef INCLUDED_Std
#include <Std.h>
#endif
#ifndef INCLUDED_com_ludamix_triad_grid_AbstractGrid
#include <com/ludamix/triad/grid/AbstractGrid.h>
#endif
namespace com{
namespace ludamix{
namespace triad{
namespace grid{

Void AbstractGrid_obj::__construct(int worldw,int worldh,double twidth,double theight,Dynamic populate)
{
{
	HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",80)
	this->twidth = twidth;
	HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",81)
	this->theight = theight;
	HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",83)
	this->worldW = worldw;
	HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",84)
	this->worldH = worldh;
	HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",86)
	this->world = Dynamic( Array_obj<Dynamic>::__new() );
	HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",87)
	Dynamic pop = populate->__Field(HX_CSTRING("copy"))();
	HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",89)
	int ct = (int)0;
	HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",90)
	{
		HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",90)
		int _g1 = (int)0;
		int _g = (this->worldH * this->worldW);
		HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",90)
		while(((_g1 < _g))){
			HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",90)
			int ct1 = (_g1)++;
			HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",92)
			this->world->__Field(HX_CSTRING("push"))(pop->__GetItem(ct1));
		}
	}
}
;
	return null();
}

AbstractGrid_obj::~AbstractGrid_obj() { }

Dynamic AbstractGrid_obj::__CreateEmpty() { return  new AbstractGrid_obj; }
hx::ObjectPtr< AbstractGrid_obj > AbstractGrid_obj::__new(int worldw,int worldh,double twidth,double theight,Dynamic populate)
{  hx::ObjectPtr< AbstractGrid_obj > result = new AbstractGrid_obj();
	result->__construct(worldw,worldh,twidth,theight,populate);
	return result;}

Dynamic AbstractGrid_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< AbstractGrid_obj > result = new AbstractGrid_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2],inArgs[3],inArgs[4]);
	return result;}

Void AbstractGrid_obj::copyTo( Dynamic prev,int idx){
{
		HX_SOURCE_PUSH("AbstractGrid_obj::copyTo")
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(AbstractGrid_obj,copyTo,(void))

int AbstractGrid_obj::c21( int x,int y){
	HX_SOURCE_PUSH("AbstractGrid_obj::c21")
	HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",28)
	return ((y * this->worldW) + x);
}


HX_DEFINE_DYNAMIC_FUNC2(AbstractGrid_obj,c21,return )

Dynamic AbstractGrid_obj::c1p( int idx){
	HX_SOURCE_PUSH("AbstractGrid_obj::c1p")
	HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",31)
	int x = hx::Mod(idx,this->worldW);
	struct _Function_1_1{
		inline static Dynamic Block( ::com::ludamix::triad::grid::AbstractGrid_obj *__this,int &idx,int &x){
			hx::Anon __result = hx::Anon_obj::Create();
			__result->Add(HX_CSTRING("y") , ::Std_obj::_int((double(((idx - x))) / double(__this->worldW))),false);
			__result->Add(HX_CSTRING("x") , x,false);
			return __result;
		}
	};
	HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",31)
	return _Function_1_1::Block(this,idx,x);
}


HX_DEFINE_DYNAMIC_FUNC1(AbstractGrid_obj,c1p,return )

Dynamic AbstractGrid_obj::c1x( int idx){
	HX_SOURCE_PUSH("AbstractGrid_obj::c1x")
	struct _Function_1_1{
		inline static Dynamic Block( int &idx,::com::ludamix::triad::grid::AbstractGrid_obj *__this){
			HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",34)
			int x = hx::Mod(idx,__this->worldW);
			struct _Function_2_1{
				inline static Dynamic Block( ::com::ludamix::triad::grid::AbstractGrid_obj *__this,int &idx,int &x){
					hx::Anon __result = hx::Anon_obj::Create();
					__result->Add(HX_CSTRING("y") , ::Std_obj::_int((double(((idx - x))) / double(__this->worldW))),false);
					__result->Add(HX_CSTRING("x") , x,false);
					return __result;
				}
			};
			HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",34)
			return _Function_2_1::Block(__this,idx,x);
		}
	};
	HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",34)
	Dynamic p = _Function_1_1::Block(idx,this);
	struct _Function_1_2{
		inline static Dynamic Block( Dynamic &p,::com::ludamix::triad::grid::AbstractGrid_obj *__this){
			hx::Anon __result = hx::Anon_obj::Create();
			__result->Add(HX_CSTRING("x") , (p->__Field(HX_CSTRING("x")) * __this->twidth),false);
			__result->Add(HX_CSTRING("y") , (p->__Field(HX_CSTRING("y")) * __this->theight),false);
			return __result;
		}
	};
	HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",34)
	return _Function_1_2::Block(p,this);
}


HX_DEFINE_DYNAMIC_FUNC1(AbstractGrid_obj,c1x,return )

Dynamic AbstractGrid_obj::c1t( int idx){
	HX_SOURCE_PUSH("AbstractGrid_obj::c1t")
	HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",37)
	return this->world->__GetItem(idx);
}


HX_DEFINE_DYNAMIC_FUNC1(AbstractGrid_obj,c1t,return )

Dynamic AbstractGrid_obj::c2tU( int x,int y){
	HX_SOURCE_PUSH("AbstractGrid_obj::c2tU")
	HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",40)
	return this->world->__GetItem(((y * this->worldW) + x));
}


HX_DEFINE_DYNAMIC_FUNC2(AbstractGrid_obj,c2tU,return )

Dynamic AbstractGrid_obj::c2t( int x,int y){
	HX_SOURCE_PUSH("AbstractGrid_obj::c2t")
	HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",43)
	if (((bool((bool((bool((x >= (int)0)) && bool((x < this->worldW)))) && bool((y >= (int)0)))) && bool((y < this->worldH))))){
		HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",43)
		return this->world->__GetItem(((y * this->worldW) + x));
	}
	else{
		HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",43)
		return null();
	}
}


HX_DEFINE_DYNAMIC_FUNC2(AbstractGrid_obj,c2t,return )

int AbstractGrid_obj::cp1( Dynamic p){
	HX_SOURCE_PUSH("AbstractGrid_obj::cp1")
	HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",46)
	return ((p->__Field(HX_CSTRING("y")) * this->worldW) + p->__Field(HX_CSTRING("x")));
}


HX_DEFINE_DYNAMIC_FUNC1(AbstractGrid_obj,cp1,return )

Dynamic AbstractGrid_obj::cptU( Dynamic p){
	HX_SOURCE_PUSH("AbstractGrid_obj::cptU")
	HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",49)
	return this->world->__GetItem(((p->__Field(HX_CSTRING("y")) * this->worldW) + p->__Field(HX_CSTRING("x"))));
}


HX_DEFINE_DYNAMIC_FUNC1(AbstractGrid_obj,cptU,return )

Dynamic AbstractGrid_obj::cpt( Dynamic p){
	HX_SOURCE_PUSH("AbstractGrid_obj::cpt")
	struct _Function_1_1{
		inline static Dynamic Block( Dynamic &p,::com::ludamix::triad::grid::AbstractGrid_obj *__this){
			HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",52)
			int x = p->__Field(HX_CSTRING("x"));
			int y = p->__Field(HX_CSTRING("y"));
			HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",52)
			return (  (((bool((bool((bool((x >= (int)0)) && bool((x < __this->worldW)))) && bool((y >= (int)0)))) && bool((y < __this->worldH))))) ? Dynamic(__this->world->__GetItem(((y * __this->worldW) + x))) : Dynamic(null()) );
		}
	};
	HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",52)
	return _Function_1_1::Block(p,this);
}


HX_DEFINE_DYNAMIC_FUNC1(AbstractGrid_obj,cpt,return )

Dynamic AbstractGrid_obj::cffp( double x,double y){
	HX_SOURCE_PUSH("AbstractGrid_obj::cffp")
	struct _Function_1_1{
		inline static Dynamic Block( ::com::ludamix::triad::grid::AbstractGrid_obj *__this,double &y,double &x){
			hx::Anon __result = hx::Anon_obj::Create();
			__result->Add(HX_CSTRING("x") , ::Std_obj::_int((double(x) / double(__this->twidth))),false);
			__result->Add(HX_CSTRING("y") , ::Std_obj::_int((double(y) / double(__this->theight))),false);
			return __result;
		}
	};
	HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",55)
	return _Function_1_1::Block(this,y,x);
}


HX_DEFINE_DYNAMIC_FUNC2(AbstractGrid_obj,cffp,return )

Dynamic AbstractGrid_obj::cxp( Dynamic p){
	HX_SOURCE_PUSH("AbstractGrid_obj::cxp")
	struct _Function_1_1{
		inline static Dynamic Block( Dynamic &p,::com::ludamix::triad::grid::AbstractGrid_obj *__this){
			hx::Anon __result = hx::Anon_obj::Create();
			__result->Add(HX_CSTRING("x") , ::Std_obj::_int((double(p->__Field(HX_CSTRING("x"))) / double(__this->twidth))),false);
			__result->Add(HX_CSTRING("y") , ::Std_obj::_int((double(p->__Field(HX_CSTRING("y"))) / double(__this->theight))),false);
			return __result;
		}
	};
	HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",58)
	return _Function_1_1::Block(p,this);
}


HX_DEFINE_DYNAMIC_FUNC1(AbstractGrid_obj,cxp,return )

Dynamic AbstractGrid_obj::cpx( Dynamic p){
	HX_SOURCE_PUSH("AbstractGrid_obj::cpx")
	struct _Function_1_1{
		inline static Dynamic Block( Dynamic &p,::com::ludamix::triad::grid::AbstractGrid_obj *__this){
			hx::Anon __result = hx::Anon_obj::Create();
			__result->Add(HX_CSTRING("x") , (p->__Field(HX_CSTRING("x")) * __this->twidth),false);
			__result->Add(HX_CSTRING("y") , (p->__Field(HX_CSTRING("y")) * __this->theight),false);
			return __result;
		}
	};
	HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",61)
	return _Function_1_1::Block(p,this);
}


HX_DEFINE_DYNAMIC_FUNC1(AbstractGrid_obj,cpx,return )

Dynamic AbstractGrid_obj::c2x( int x,int y){
	HX_SOURCE_PUSH("AbstractGrid_obj::c2x")
	struct _Function_1_1{
		inline static Dynamic Block( ::com::ludamix::triad::grid::AbstractGrid_obj *__this,int &y,int &x){
			hx::Anon __result = hx::Anon_obj::Create();
			__result->Add(HX_CSTRING("x") , (x * __this->twidth),false);
			__result->Add(HX_CSTRING("y") , (y * __this->theight),false);
			return __result;
		}
	};
	HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",64)
	return _Function_1_1::Block(this,y,x);
}


HX_DEFINE_DYNAMIC_FUNC2(AbstractGrid_obj,c2x,return )

int AbstractGrid_obj::cff1( double x,double y){
	HX_SOURCE_PUSH("AbstractGrid_obj::cff1")
	HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",67)
	return ((::Std_obj::_int((double(y) / double(this->theight))) * this->worldW) + ::Std_obj::_int((double(x) / double(this->twidth))));
}


HX_DEFINE_DYNAMIC_FUNC2(AbstractGrid_obj,cff1,return )

int AbstractGrid_obj::cx1( Dynamic p){
	HX_SOURCE_PUSH("AbstractGrid_obj::cx1")
	HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",70)
	return ((::Std_obj::_int((double(p->__Field(HX_CSTRING("y"))) / double(this->theight))) * this->worldW) + ::Std_obj::_int((double(p->__Field(HX_CSTRING("x"))) / double(this->twidth))));
}


HX_DEFINE_DYNAMIC_FUNC1(AbstractGrid_obj,cx1,return )

Dynamic AbstractGrid_obj::cfft( double x,double y){
	HX_SOURCE_PUSH("AbstractGrid_obj::cfft")
	HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",73)
	return this->world->__GetItem(((::Std_obj::_int((double(y) / double(this->theight))) * this->worldW) + ::Std_obj::_int((double(x) / double(this->twidth)))));
}


HX_DEFINE_DYNAMIC_FUNC2(AbstractGrid_obj,cfft,return )

Dynamic AbstractGrid_obj::cxt( Dynamic p){
	HX_SOURCE_PUSH("AbstractGrid_obj::cxt")
	HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",76)
	return this->world->__GetItem(((::Std_obj::_int((double(p->__Field(HX_CSTRING("y"))) / double(this->theight))) * this->worldW) + ::Std_obj::_int((double(p->__Field(HX_CSTRING("x"))) / double(this->twidth)))));
}


HX_DEFINE_DYNAMIC_FUNC1(AbstractGrid_obj,cxt,return )

int AbstractGrid_obj::rotW( int x){
	HX_SOURCE_PUSH("AbstractGrid_obj::rotW")
	HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",97)
	return (  (((x >= (int)0))) ? int(hx::Mod(x,this->worldW)) : int((x + this->worldW)) );
}


HX_DEFINE_DYNAMIC_FUNC1(AbstractGrid_obj,rotW,return )

int AbstractGrid_obj::rotH( int y){
	HX_SOURCE_PUSH("AbstractGrid_obj::rotH")
	HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",98)
	return (  (((y >= (int)0))) ? int(hx::Mod(y,this->worldH)) : int((y + this->worldH)) );
}


HX_DEFINE_DYNAMIC_FUNC1(AbstractGrid_obj,rotH,return )

Void AbstractGrid_obj::shiftL( ){
{
		HX_SOURCE_PUSH("AbstractGrid_obj::shiftL")
		HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",102)
		int _g1 = (int)0;
		int _g = this->worldW;
		HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",102)
		while(((_g1 < _g))){
			HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",102)
			int icol = (_g1)++;
			HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",104)
			int x = ((this->worldW - (int)1) - icol);
			HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",105)
			{
				HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",105)
				int _g3 = (int)0;
				int _g2 = this->worldH;
				HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",105)
				while(((_g3 < _g2))){
					HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",105)
					int y = (_g3)++;
					struct _Function_4_1{
						inline static Dynamic Block( ::com::ludamix::triad::grid::AbstractGrid_obj *__this,int &y,int &x){
							struct _Function_5_1{
								inline static int Block( int &x,::com::ludamix::triad::grid::AbstractGrid_obj *__this){
									HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",107)
									int x1 = (x - (int)1);
									HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",107)
									return (  (((x1 >= (int)0))) ? int(hx::Mod(x1,__this->worldW)) : int((x1 + __this->worldW)) );
								}
							};
							HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",107)
							int x1 = _Function_5_1::Block(x,__this);
							HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",107)
							return (  (((bool((bool((bool((x1 >= (int)0)) && bool((x1 < __this->worldW)))) && bool((y >= (int)0)))) && bool((y < __this->worldH))))) ? Dynamic(__this->world->__GetItem(((y * __this->worldW) + x1))) : Dynamic(null()) );
						}
					};
					HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",107)
					this->copyTo(_Function_4_1::Block(this,y,x),((y * this->worldW) + x));
				}
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(AbstractGrid_obj,shiftL,(void))

Void AbstractGrid_obj::shiftR( ){
{
		HX_SOURCE_PUSH("AbstractGrid_obj::shiftR")
		HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",114)
		int _g1 = (int)0;
		int _g = this->worldW;
		HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",114)
		while(((_g1 < _g))){
			HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",114)
			int x = (_g1)++;
			HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",116)
			{
				HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",116)
				int _g3 = (int)0;
				int _g2 = this->worldH;
				HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",116)
				while(((_g3 < _g2))){
					HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",116)
					int y = (_g3)++;
					struct _Function_4_1{
						inline static Dynamic Block( ::com::ludamix::triad::grid::AbstractGrid_obj *__this,int &y,int &x){
							struct _Function_5_1{
								inline static int Block( int &x,::com::ludamix::triad::grid::AbstractGrid_obj *__this){
									HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",118)
									int x1 = (x + (int)1);
									HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",118)
									return (  (((x1 >= (int)0))) ? int(hx::Mod(x1,__this->worldW)) : int((x1 + __this->worldW)) );
								}
							};
							HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",118)
							int x1 = _Function_5_1::Block(x,__this);
							HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",118)
							return (  (((bool((bool((bool((x1 >= (int)0)) && bool((x1 < __this->worldW)))) && bool((y >= (int)0)))) && bool((y < __this->worldH))))) ? Dynamic(__this->world->__GetItem(((y * __this->worldW) + x1))) : Dynamic(null()) );
						}
					};
					HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",118)
					this->copyTo(_Function_4_1::Block(this,y,x),((y * this->worldW) + x));
				}
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(AbstractGrid_obj,shiftR,(void))

Void AbstractGrid_obj::shiftU( ){
{
		HX_SOURCE_PUSH("AbstractGrid_obj::shiftU")
		HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",125)
		int _g1 = (int)0;
		int _g = this->worldH;
		HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",125)
		while(((_g1 < _g))){
			HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",125)
			int y = (_g1)++;
			HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",127)
			{
				HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",127)
				int _g3 = (int)0;
				int _g2 = this->worldW;
				HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",127)
				while(((_g3 < _g2))){
					HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",127)
					int x = (_g3)++;
					struct _Function_4_1{
						inline static Dynamic Block( ::com::ludamix::triad::grid::AbstractGrid_obj *__this,int &y,int &x){
							struct _Function_5_1{
								inline static int Block( int &y,::com::ludamix::triad::grid::AbstractGrid_obj *__this){
									HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",129)
									int y1 = (y + (int)1);
									HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",129)
									return (  (((y1 >= (int)0))) ? int(hx::Mod(y1,__this->worldH)) : int((y1 + __this->worldH)) );
								}
							};
							HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",129)
							int y1 = _Function_5_1::Block(y,__this);
							HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",129)
							return (  (((bool((bool((bool((x >= (int)0)) && bool((x < __this->worldW)))) && bool((y1 >= (int)0)))) && bool((y1 < __this->worldH))))) ? Dynamic(__this->world->__GetItem(((y1 * __this->worldW) + x))) : Dynamic(null()) );
						}
					};
					HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",129)
					this->copyTo(_Function_4_1::Block(this,y,x),((y * this->worldW) + x));
				}
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(AbstractGrid_obj,shiftU,(void))

Void AbstractGrid_obj::shiftD( ){
{
		HX_SOURCE_PUSH("AbstractGrid_obj::shiftD")
		HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",136)
		int _g1 = (int)0;
		int _g = this->worldH;
		HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",136)
		while(((_g1 < _g))){
			HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",136)
			int irow = (_g1)++;
			HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",138)
			int y = ((this->worldH - (int)1) - irow);
			HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",139)
			{
				HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",139)
				int _g3 = (int)0;
				int _g2 = this->worldW;
				HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",139)
				while(((_g3 < _g2))){
					HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",139)
					int x = (_g3)++;
					struct _Function_4_1{
						inline static Dynamic Block( ::com::ludamix::triad::grid::AbstractGrid_obj *__this,int &y,int &x){
							struct _Function_5_1{
								inline static int Block( int &y,::com::ludamix::triad::grid::AbstractGrid_obj *__this){
									HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",141)
									int y1 = (y - (int)1);
									HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",141)
									return (  (((y1 >= (int)0))) ? int(hx::Mod(y1,__this->worldH)) : int((y1 + __this->worldH)) );
								}
							};
							HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",141)
							int y1 = _Function_5_1::Block(y,__this);
							HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",141)
							return (  (((bool((bool((bool((x >= (int)0)) && bool((x < __this->worldW)))) && bool((y1 >= (int)0)))) && bool((y1 < __this->worldH))))) ? Dynamic(__this->world->__GetItem(((y1 * __this->worldW) + x))) : Dynamic(null()) );
						}
					};
					HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",141)
					this->copyTo(_Function_4_1::Block(this,y,x),((y * this->worldW) + x));
				}
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(AbstractGrid_obj,shiftD,(void))

bool AbstractGrid_obj::tileInBounds( double x,double y){
	HX_SOURCE_PUSH("AbstractGrid_obj::tileInBounds")
	HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",147)
	return (bool((bool((bool((x >= (int)0)) && bool((y >= (int)0)))) && bool((x < this->worldW)))) && bool((y < this->worldH)));
}


HX_DEFINE_DYNAMIC_FUNC2(AbstractGrid_obj,tileInBounds,return )

bool AbstractGrid_obj::pixelInBounds( double x,double y){
	HX_SOURCE_PUSH("AbstractGrid_obj::pixelInBounds")
	HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/AbstractGrid.hx",152)
	return (bool((bool((bool((x >= (int)0)) && bool((y >= (int)0)))) && bool((x < (this->worldW * this->twidth))))) && bool((y < (this->worldH * this->theight))));
}


HX_DEFINE_DYNAMIC_FUNC2(AbstractGrid_obj,pixelInBounds,return )


AbstractGrid_obj::AbstractGrid_obj()
{
}

void AbstractGrid_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(AbstractGrid);
	HX_MARK_MEMBER_NAME(world,"world");
	HX_MARK_MEMBER_NAME(worldW,"worldW");
	HX_MARK_MEMBER_NAME(worldH,"worldH");
	HX_MARK_MEMBER_NAME(twidth,"twidth");
	HX_MARK_MEMBER_NAME(theight,"theight");
	HX_MARK_END_CLASS();
}

Dynamic AbstractGrid_obj::__Field(const ::String &inName)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"c21") ) { return c21_dyn(); }
		if (HX_FIELD_EQ(inName,"c1p") ) { return c1p_dyn(); }
		if (HX_FIELD_EQ(inName,"c1x") ) { return c1x_dyn(); }
		if (HX_FIELD_EQ(inName,"c1t") ) { return c1t_dyn(); }
		if (HX_FIELD_EQ(inName,"c2t") ) { return c2t_dyn(); }
		if (HX_FIELD_EQ(inName,"cp1") ) { return cp1_dyn(); }
		if (HX_FIELD_EQ(inName,"cpt") ) { return cpt_dyn(); }
		if (HX_FIELD_EQ(inName,"cxp") ) { return cxp_dyn(); }
		if (HX_FIELD_EQ(inName,"cpx") ) { return cpx_dyn(); }
		if (HX_FIELD_EQ(inName,"c2x") ) { return c2x_dyn(); }
		if (HX_FIELD_EQ(inName,"cx1") ) { return cx1_dyn(); }
		if (HX_FIELD_EQ(inName,"cxt") ) { return cxt_dyn(); }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"c2tU") ) { return c2tU_dyn(); }
		if (HX_FIELD_EQ(inName,"cptU") ) { return cptU_dyn(); }
		if (HX_FIELD_EQ(inName,"cffp") ) { return cffp_dyn(); }
		if (HX_FIELD_EQ(inName,"cff1") ) { return cff1_dyn(); }
		if (HX_FIELD_EQ(inName,"cfft") ) { return cfft_dyn(); }
		if (HX_FIELD_EQ(inName,"rotW") ) { return rotW_dyn(); }
		if (HX_FIELD_EQ(inName,"rotH") ) { return rotH_dyn(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"world") ) { return world; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"worldW") ) { return worldW; }
		if (HX_FIELD_EQ(inName,"worldH") ) { return worldH; }
		if (HX_FIELD_EQ(inName,"copyTo") ) { return copyTo_dyn(); }
		if (HX_FIELD_EQ(inName,"twidth") ) { return twidth; }
		if (HX_FIELD_EQ(inName,"shiftL") ) { return shiftL_dyn(); }
		if (HX_FIELD_EQ(inName,"shiftR") ) { return shiftR_dyn(); }
		if (HX_FIELD_EQ(inName,"shiftU") ) { return shiftU_dyn(); }
		if (HX_FIELD_EQ(inName,"shiftD") ) { return shiftD_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"theight") ) { return theight; }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"tileInBounds") ) { return tileInBounds_dyn(); }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"pixelInBounds") ) { return pixelInBounds_dyn(); }
	}
	return super::__Field(inName);
}

Dynamic AbstractGrid_obj::__SetField(const ::String &inName,const Dynamic &inValue)
{
	switch(inName.length) {
	case 5:
		if (HX_FIELD_EQ(inName,"world") ) { world=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"worldW") ) { worldW=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"worldH") ) { worldH=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"twidth") ) { twidth=inValue.Cast< double >(); return inValue; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"theight") ) { theight=inValue.Cast< double >(); return inValue; }
	}
	return super::__SetField(inName,inValue);
}

void AbstractGrid_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("world"));
	outFields->push(HX_CSTRING("worldW"));
	outFields->push(HX_CSTRING("worldH"));
	outFields->push(HX_CSTRING("twidth"));
	outFields->push(HX_CSTRING("theight"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

static ::String sMemberFields[] = {
	HX_CSTRING("world"),
	HX_CSTRING("worldW"),
	HX_CSTRING("worldH"),
	HX_CSTRING("copyTo"),
	HX_CSTRING("twidth"),
	HX_CSTRING("theight"),
	HX_CSTRING("c21"),
	HX_CSTRING("c1p"),
	HX_CSTRING("c1x"),
	HX_CSTRING("c1t"),
	HX_CSTRING("c2tU"),
	HX_CSTRING("c2t"),
	HX_CSTRING("cp1"),
	HX_CSTRING("cptU"),
	HX_CSTRING("cpt"),
	HX_CSTRING("cffp"),
	HX_CSTRING("cxp"),
	HX_CSTRING("cpx"),
	HX_CSTRING("c2x"),
	HX_CSTRING("cff1"),
	HX_CSTRING("cx1"),
	HX_CSTRING("cfft"),
	HX_CSTRING("cxt"),
	HX_CSTRING("rotW"),
	HX_CSTRING("rotH"),
	HX_CSTRING("shiftL"),
	HX_CSTRING("shiftR"),
	HX_CSTRING("shiftU"),
	HX_CSTRING("shiftD"),
	HX_CSTRING("tileInBounds"),
	HX_CSTRING("pixelInBounds"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
};

Class AbstractGrid_obj::__mClass;

void AbstractGrid_obj::__register()
{
	Static(__mClass) = hx::RegisterClass(HX_CSTRING("com.ludamix.triad.grid.AbstractGrid"), hx::TCanCast< AbstractGrid_obj> ,sStaticFields,sMemberFields,
	&__CreateEmpty, &__Create,
	&super::__SGetClass(), 0, sMarkStatics);
}

void AbstractGrid_obj::__boot()
{
}

} // end namespace com
} // end namespace ludamix
} // end namespace triad
} // end namespace grid
