#include <hxcpp.h>

#ifndef INCLUDED_com_ludamix_triad_ui_Rect9
#include <com/ludamix/triad/ui/Rect9.h>
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
#ifndef INCLUDED_nme_display_Sprite
#include <nme/display/Sprite.h>
#endif
#ifndef INCLUDED_nme_events_EventDispatcher
#include <nme/events/EventDispatcher.h>
#endif
#ifndef INCLUDED_nme_events_IEventDispatcher
#include <nme/events/IEventDispatcher.h>
#endif
#ifndef INCLUDED_nme_geom_Matrix
#include <nme/geom/Matrix.h>
#endif
#ifndef INCLUDED_nme_geom_Point
#include <nme/geom/Point.h>
#endif
#ifndef INCLUDED_nme_geom_Rectangle
#include <nme/geom/Rectangle.h>
#endif
namespace com{
namespace ludamix{
namespace triad{
namespace ui{

Void Rect9_obj::__construct(::nme::display::BitmapData base,int rectx,int recty,int rectw,int recth)
{
{
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",18)
	Array< ::nme::display::BitmapData > slices = Array_obj< ::nme::display::BitmapData >::__new();
	struct _Function_1_1{
		inline static Dynamic Block( int &recty,Array< ::nme::display::BitmapData > &slices,int &rectx,int &rectw,int &recth,::nme::display::BitmapData &base){
			hx::Anon __result = hx::Anon_obj::Create();
			__result->Add(HX_CSTRING("slices") , slices,false);
			__result->Add(HX_CSTRING("x") , rectx,false);
			__result->Add(HX_CSTRING("y") , recty,false);
			__result->Add(HX_CSTRING("w") , rectw,false);
			__result->Add(HX_CSTRING("h") , recth,false);
			__result->Add(HX_CSTRING("szX") , base->nmeGetWidth(),false);
			__result->Add(HX_CSTRING("szY") , base->nmeGetHeight(),false);
			return __result;
		}
	};
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",19)
	this->repeaterRect = _Function_1_1::Block(recty,slices,rectx,rectw,recth,base);
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",21)
	{
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",21)
		int _g = (int)0;
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",21)
		while(((_g < (int)3))){
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",21)
			int y = (_g)++;
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",23)
			{
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",23)
				int _g1 = (int)0;
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",23)
				while(((_g1 < (int)3))){
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",23)
					int x = (_g1)++;
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",25)
					Dynamic tile = this->xyOf(x,y);
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",27)
					::nme::display::BitmapData bd = ::nme::display::BitmapData_obj::__new(tile->__Field(HX_CSTRING("w")),tile->__Field(HX_CSTRING("h")),true,(int)0);
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",29)
					bd->copyPixels(base,::nme::geom::Rectangle_obj::__new(tile->__Field(HX_CSTRING("x")),tile->__Field(HX_CSTRING("y")),tile->__Field(HX_CSTRING("w")),tile->__Field(HX_CSTRING("h"))),::nme::geom::Point_obj::__new((int)0,(int)0),base,::nme::geom::Point_obj::__new(tile->__Field(HX_CSTRING("x")),tile->__Field(HX_CSTRING("y"))),false);
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",31)
					slices->push(bd);
				}
			}
		}
	}
}
;
	return null();
}

Rect9_obj::~Rect9_obj() { }

Dynamic Rect9_obj::__CreateEmpty() { return  new Rect9_obj; }
hx::ObjectPtr< Rect9_obj > Rect9_obj::__new(::nme::display::BitmapData base,int rectx,int recty,int rectw,int recth)
{  hx::ObjectPtr< Rect9_obj > result = new Rect9_obj();
	result->__construct(base,rectx,recty,rectw,recth);
	return result;}

Dynamic Rect9_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Rect9_obj > result = new Rect9_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2],inArgs[3],inArgs[4]);
	return result;}

int Rect9_obj::leftX( ){
	HX_SOURCE_PUSH("Rect9_obj::leftX")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",37)
	return (int)0;
}


HX_DEFINE_DYNAMIC_FUNC0(Rect9_obj,leftX,return )

int Rect9_obj::topY( ){
	HX_SOURCE_PUSH("Rect9_obj::topY")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",38)
	return (int)0;
}


HX_DEFINE_DYNAMIC_FUNC0(Rect9_obj,topY,return )

int Rect9_obj::leftW( ){
	HX_SOURCE_PUSH("Rect9_obj::leftW")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",39)
	return this->repeaterRect->__Field(HX_CSTRING("x"));
}


HX_DEFINE_DYNAMIC_FUNC0(Rect9_obj,leftW,return )

int Rect9_obj::topH( ){
	HX_SOURCE_PUSH("Rect9_obj::topH")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",40)
	return this->repeaterRect->__Field(HX_CSTRING("y"));
}


HX_DEFINE_DYNAMIC_FUNC0(Rect9_obj,topH,return )

int Rect9_obj::midX( ){
	HX_SOURCE_PUSH("Rect9_obj::midX")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",42)
	return this->repeaterRect->__Field(HX_CSTRING("x"));
}


HX_DEFINE_DYNAMIC_FUNC0(Rect9_obj,midX,return )

int Rect9_obj::midY( ){
	HX_SOURCE_PUSH("Rect9_obj::midY")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",43)
	return this->repeaterRect->__Field(HX_CSTRING("y"));
}


HX_DEFINE_DYNAMIC_FUNC0(Rect9_obj,midY,return )

int Rect9_obj::midW( ){
	HX_SOURCE_PUSH("Rect9_obj::midW")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",44)
	return this->repeaterRect->__Field(HX_CSTRING("w"));
}


HX_DEFINE_DYNAMIC_FUNC0(Rect9_obj,midW,return )

int Rect9_obj::midH( ){
	HX_SOURCE_PUSH("Rect9_obj::midH")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",45)
	return this->repeaterRect->__Field(HX_CSTRING("h"));
}


HX_DEFINE_DYNAMIC_FUNC0(Rect9_obj,midH,return )

int Rect9_obj::rightX( ){
	HX_SOURCE_PUSH("Rect9_obj::rightX")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",47)
	return (this->repeaterRect->__Field(HX_CSTRING("x")) + this->repeaterRect->__Field(HX_CSTRING("w")));
}


HX_DEFINE_DYNAMIC_FUNC0(Rect9_obj,rightX,return )

int Rect9_obj::bottomY( ){
	HX_SOURCE_PUSH("Rect9_obj::bottomY")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",48)
	return (this->repeaterRect->__Field(HX_CSTRING("y")) + this->repeaterRect->__Field(HX_CSTRING("h")));
}


HX_DEFINE_DYNAMIC_FUNC0(Rect9_obj,bottomY,return )

int Rect9_obj::rightW( ){
	HX_SOURCE_PUSH("Rect9_obj::rightW")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",49)
	return (this->repeaterRect->__Field(HX_CSTRING("szX")) - ((this->repeaterRect->__Field(HX_CSTRING("x")) + this->repeaterRect->__Field(HX_CSTRING("w")))));
}


HX_DEFINE_DYNAMIC_FUNC0(Rect9_obj,rightW,return )

int Rect9_obj::bottomH( ){
	HX_SOURCE_PUSH("Rect9_obj::bottomH")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",50)
	return (this->repeaterRect->__Field(HX_CSTRING("szY")) - ((this->repeaterRect->__Field(HX_CSTRING("y")) + this->repeaterRect->__Field(HX_CSTRING("h")))));
}


HX_DEFINE_DYNAMIC_FUNC0(Rect9_obj,bottomH,return )

Dynamic Rect9_obj::xyOf( int x,int y){
	HX_SOURCE_PUSH("Rect9_obj::xyOf")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",54)
	int tileW = (int)0;
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",55)
	int tileX = (int)0;
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",56)
	int tileH = (int)0;
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",57)
	int tileY = (int)0;
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",58)
	switch( (int)(x)){
		case (int)0: {
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",60)
			tileW = this->repeaterRect->__Field(HX_CSTRING("x"));
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",60)
			tileX = (int)0;
		}
		;break;
		case (int)1: {
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",61)
			tileW = this->repeaterRect->__Field(HX_CSTRING("w"));
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",61)
			tileX = this->repeaterRect->__Field(HX_CSTRING("x"));
		}
		;break;
		case (int)2: {
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",62)
			tileW = (this->repeaterRect->__Field(HX_CSTRING("szX")) - ((this->repeaterRect->__Field(HX_CSTRING("x")) + this->repeaterRect->__Field(HX_CSTRING("w")))));
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",62)
			tileX = (this->repeaterRect->__Field(HX_CSTRING("x")) + this->repeaterRect->__Field(HX_CSTRING("w")));
		}
		;break;
	}
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",64)
	switch( (int)(y)){
		case (int)0: {
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",66)
			tileH = this->repeaterRect->__Field(HX_CSTRING("y"));
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",66)
			tileY = (int)0;
		}
		;break;
		case (int)1: {
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",67)
			tileH = this->repeaterRect->__Field(HX_CSTRING("h"));
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",67)
			tileY = this->repeaterRect->__Field(HX_CSTRING("y"));
		}
		;break;
		case (int)2: {
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",68)
			tileH = (this->repeaterRect->__Field(HX_CSTRING("szY")) - ((this->repeaterRect->__Field(HX_CSTRING("y")) + this->repeaterRect->__Field(HX_CSTRING("h")))));
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",68)
			tileY = (this->repeaterRect->__Field(HX_CSTRING("y")) + this->repeaterRect->__Field(HX_CSTRING("h")));
		}
		;break;
	}
	struct _Function_1_1{
		inline static Dynamic Block( int &tileX,int &tileW,int &tileH,int &tileY){
			hx::Anon __result = hx::Anon_obj::Create();
			__result->Add(HX_CSTRING("x") , tileX,false);
			__result->Add(HX_CSTRING("y") , tileY,false);
			__result->Add(HX_CSTRING("w") , tileW,false);
			__result->Add(HX_CSTRING("h") , tileH,false);
			return __result;
		}
	};
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",70)
	return _Function_1_1::Block(tileX,tileW,tileH,tileY);
}


HX_DEFINE_DYNAMIC_FUNC2(Rect9_obj,xyOf,return )

Dynamic Rect9_obj::modXYOf( int x,int y,int rectW,int rectH){
	HX_SOURCE_PUSH("Rect9_obj::modXYOf")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",75)
	int tileW = (int)0;
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",76)
	int tileX = (int)0;
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",77)
	int tileH = (int)0;
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",78)
	int tileY = (int)0;
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",79)
	switch( (int)(x)){
		case (int)0: {
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",81)
			tileW = this->repeaterRect->__Field(HX_CSTRING("x"));
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",81)
			tileX = (int)0;
		}
		;break;
		case (int)1: {
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",82)
			tileW = ((rectW - this->repeaterRect->__Field(HX_CSTRING("x"))) - ((this->repeaterRect->__Field(HX_CSTRING("szX")) - ((this->repeaterRect->__Field(HX_CSTRING("x")) + this->repeaterRect->__Field(HX_CSTRING("w")))))));
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",82)
			tileX = this->repeaterRect->__Field(HX_CSTRING("x"));
		}
		;break;
		case (int)2: {
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",83)
			tileW = (this->repeaterRect->__Field(HX_CSTRING("szX")) - ((this->repeaterRect->__Field(HX_CSTRING("x")) + this->repeaterRect->__Field(HX_CSTRING("w")))));
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",83)
			tileX = (rectW - ((this->repeaterRect->__Field(HX_CSTRING("szX")) - ((this->repeaterRect->__Field(HX_CSTRING("x")) + this->repeaterRect->__Field(HX_CSTRING("w")))))));
		}
		;break;
	}
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",85)
	switch( (int)(y)){
		case (int)0: {
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",87)
			tileH = this->repeaterRect->__Field(HX_CSTRING("y"));
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",87)
			tileY = (int)0;
		}
		;break;
		case (int)1: {
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",88)
			tileH = ((rectH - this->repeaterRect->__Field(HX_CSTRING("y"))) - ((this->repeaterRect->__Field(HX_CSTRING("szY")) - ((this->repeaterRect->__Field(HX_CSTRING("y")) + this->repeaterRect->__Field(HX_CSTRING("h")))))));
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",88)
			tileY = this->repeaterRect->__Field(HX_CSTRING("y"));
		}
		;break;
		case (int)2: {
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",89)
			tileH = (this->repeaterRect->__Field(HX_CSTRING("szY")) - ((this->repeaterRect->__Field(HX_CSTRING("y")) + this->repeaterRect->__Field(HX_CSTRING("h")))));
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",89)
			tileY = (rectH - ((this->repeaterRect->__Field(HX_CSTRING("szY")) - ((this->repeaterRect->__Field(HX_CSTRING("y")) + this->repeaterRect->__Field(HX_CSTRING("h")))))));
		}
		;break;
	}
	struct _Function_1_1{
		inline static Dynamic Block( int &tileX,int &tileW,int &tileH,int &tileY){
			hx::Anon __result = hx::Anon_obj::Create();
			__result->Add(HX_CSTRING("x") , tileX,false);
			__result->Add(HX_CSTRING("y") , tileY,false);
			__result->Add(HX_CSTRING("w") , tileW,false);
			__result->Add(HX_CSTRING("h") , tileH,false);
			return __result;
		}
	};
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",91)
	return _Function_1_1::Block(tileX,tileW,tileH,tileY);
}


HX_DEFINE_DYNAMIC_FUNC4(Rect9_obj,modXYOf,return )

Void Rect9_obj::draw( ::nme::display::Sprite sprite,int rectW,int rectH,bool scale){
{
		HX_SOURCE_PUSH("Rect9_obj::draw")
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",96)
		int pos = (int)0;
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",98)
		{
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",98)
			int _g = (int)0;
			Array< ::nme::display::BitmapData > _g1 = this->repeaterRect->__Field(HX_CSTRING("slices"));
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",98)
			while(((_g < _g1->length))){
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",98)
				::nme::display::BitmapData s = _g1->__get(_g);
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",98)
				++(_g);
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",100)
				bool widthLock = false;
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",101)
				bool heightLock = false;
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",103)
				Dynamic tile = null();
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",104)
				Dynamic modtile = null();
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",106)
				switch( (int)(pos)){
					case (int)0: {
						HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",108)
						tile = this->xyOf((int)0,(int)0);
						HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",108)
						modtile = this->modXYOf((int)0,(int)0,rectW,rectH);
					}
					;break;
					case (int)1: {
						HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",109)
						tile = this->xyOf((int)1,(int)0);
						HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",109)
						modtile = this->modXYOf((int)1,(int)0,rectW,rectH);
					}
					;break;
					case (int)2: {
						HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",110)
						tile = this->xyOf((int)2,(int)0);
						HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",110)
						modtile = this->modXYOf((int)2,(int)0,rectW,rectH);
					}
					;break;
					case (int)3: {
						HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",111)
						tile = this->xyOf((int)0,(int)1);
						HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",111)
						modtile = this->modXYOf((int)0,(int)1,rectW,rectH);
					}
					;break;
					case (int)4: {
						HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",112)
						tile = this->xyOf((int)1,(int)1);
						HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",112)
						modtile = this->modXYOf((int)1,(int)1,rectW,rectH);
					}
					;break;
					case (int)5: {
						HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",113)
						tile = this->xyOf((int)2,(int)1);
						HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",113)
						modtile = this->modXYOf((int)2,(int)1,rectW,rectH);
					}
					;break;
					case (int)6: {
						HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",114)
						tile = this->xyOf((int)0,(int)2);
						HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",114)
						modtile = this->modXYOf((int)0,(int)2,rectW,rectH);
					}
					;break;
					case (int)7: {
						HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",115)
						tile = this->xyOf((int)1,(int)2);
						HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",115)
						modtile = this->modXYOf((int)1,(int)2,rectW,rectH);
					}
					;break;
					case (int)8: {
						HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",116)
						tile = this->xyOf((int)2,(int)2);
						HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",116)
						modtile = this->modXYOf((int)2,(int)2,rectW,rectH);
					}
					;break;
				}
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",119)
				::nme::geom::Matrix mtx = ::nme::geom::Matrix_obj::__new(null(),null(),null(),null(),null(),null());
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",121)
				if ((scale)){
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",123)
					mtx->scale((double(modtile->__Field(HX_CSTRING("w"))) / double(tile->__Field(HX_CSTRING("w")))),(double(modtile->__Field(HX_CSTRING("h"))) / double(tile->__Field(HX_CSTRING("h")))));
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",124)
					mtx->translate(modtile->__Field(HX_CSTRING("x")),modtile->__Field(HX_CSTRING("y")));
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",125)
					sprite->nmeGetGraphics()->beginBitmapFill(s,mtx,false,true);
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",126)
					sprite->nmeGetGraphics()->drawRect(modtile->__Field(HX_CSTRING("x")),modtile->__Field(HX_CSTRING("y")),modtile->__Field(HX_CSTRING("w")),modtile->__Field(HX_CSTRING("h")));
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",127)
					sprite->nmeGetGraphics()->endFill();
				}
				else{
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",131)
					mtx->translate(modtile->__Field(HX_CSTRING("x")),modtile->__Field(HX_CSTRING("y")));
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",132)
					sprite->nmeGetGraphics()->beginBitmapFill(s,mtx,true,null());
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",133)
					sprite->nmeGetGraphics()->drawRect(modtile->__Field(HX_CSTRING("x")),modtile->__Field(HX_CSTRING("y")),modtile->__Field(HX_CSTRING("w")),modtile->__Field(HX_CSTRING("h")));
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",134)
					sprite->nmeGetGraphics()->endFill();
				}
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/ui/Rect9.hx",136)
				(pos)++;
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC4(Rect9_obj,draw,(void))


Rect9_obj::Rect9_obj()
{
}

void Rect9_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Rect9);
	HX_MARK_MEMBER_NAME(repeaterRect,"repeaterRect");
	HX_MARK_END_CLASS();
}

Dynamic Rect9_obj::__Field(const ::String &inName)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"topY") ) { return topY_dyn(); }
		if (HX_FIELD_EQ(inName,"topH") ) { return topH_dyn(); }
		if (HX_FIELD_EQ(inName,"midX") ) { return midX_dyn(); }
		if (HX_FIELD_EQ(inName,"midY") ) { return midY_dyn(); }
		if (HX_FIELD_EQ(inName,"midW") ) { return midW_dyn(); }
		if (HX_FIELD_EQ(inName,"midH") ) { return midH_dyn(); }
		if (HX_FIELD_EQ(inName,"xyOf") ) { return xyOf_dyn(); }
		if (HX_FIELD_EQ(inName,"draw") ) { return draw_dyn(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"leftX") ) { return leftX_dyn(); }
		if (HX_FIELD_EQ(inName,"leftW") ) { return leftW_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"rightX") ) { return rightX_dyn(); }
		if (HX_FIELD_EQ(inName,"rightW") ) { return rightW_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"bottomY") ) { return bottomY_dyn(); }
		if (HX_FIELD_EQ(inName,"bottomH") ) { return bottomH_dyn(); }
		if (HX_FIELD_EQ(inName,"modXYOf") ) { return modXYOf_dyn(); }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"repeaterRect") ) { return repeaterRect; }
	}
	return super::__Field(inName);
}

Dynamic Rect9_obj::__SetField(const ::String &inName,const Dynamic &inValue)
{
	switch(inName.length) {
	case 12:
		if (HX_FIELD_EQ(inName,"repeaterRect") ) { repeaterRect=inValue.Cast< Dynamic >(); return inValue; }
	}
	return super::__SetField(inName,inValue);
}

void Rect9_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("repeaterRect"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

static ::String sMemberFields[] = {
	HX_CSTRING("repeaterRect"),
	HX_CSTRING("leftX"),
	HX_CSTRING("topY"),
	HX_CSTRING("leftW"),
	HX_CSTRING("topH"),
	HX_CSTRING("midX"),
	HX_CSTRING("midY"),
	HX_CSTRING("midW"),
	HX_CSTRING("midH"),
	HX_CSTRING("rightX"),
	HX_CSTRING("bottomY"),
	HX_CSTRING("rightW"),
	HX_CSTRING("bottomH"),
	HX_CSTRING("xyOf"),
	HX_CSTRING("modXYOf"),
	HX_CSTRING("draw"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
};

Class Rect9_obj::__mClass;

void Rect9_obj::__register()
{
	Static(__mClass) = hx::RegisterClass(HX_CSTRING("com.ludamix.triad.ui.Rect9"), hx::TCanCast< Rect9_obj> ,sStaticFields,sMemberFields,
	&__CreateEmpty, &__Create,
	&super::__SGetClass(), 0, sMarkStatics);
}

void Rect9_obj::__boot()
{
}

} // end namespace com
} // end namespace ludamix
} // end namespace triad
} // end namespace ui
