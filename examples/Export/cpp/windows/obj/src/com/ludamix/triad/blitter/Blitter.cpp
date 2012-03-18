#include <hxcpp.h>

#ifndef INCLUDED_Hash
#include <Hash.h>
#endif
#ifndef INCLUDED_com_ludamix_triad_blitter_Blitter
#include <com/ludamix/triad/blitter/Blitter.h>
#endif
#ifndef INCLUDED_nme_display_Bitmap
#include <nme/display/Bitmap.h>
#endif
#ifndef INCLUDED_nme_display_BitmapData
#include <nme/display/BitmapData.h>
#endif
#ifndef INCLUDED_nme_display_DisplayObject
#include <nme/display/DisplayObject.h>
#endif
#ifndef INCLUDED_nme_display_IBitmapDrawable
#include <nme/display/IBitmapDrawable.h>
#endif
#ifndef INCLUDED_nme_display_PixelSnapping
#include <nme/display/PixelSnapping.h>
#endif
#ifndef INCLUDED_nme_events_EventDispatcher
#include <nme/events/EventDispatcher.h>
#endif
#ifndef INCLUDED_nme_events_IEventDispatcher
#include <nme/events/IEventDispatcher.h>
#endif
#ifndef INCLUDED_nme_geom_ColorTransform
#include <nme/geom/ColorTransform.h>
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
namespace blitter{

Void Blitter_obj::__construct(int width,int height,bool transparent,int color,Dynamic __o_zlevels)
{
int zlevels = __o_zlevels.Default(32);
{
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/blitter/Blitter.hx",30)
	this->fillColor = color;
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/blitter/Blitter.hx",31)
	super::__construct(::nme::display::BitmapData_obj::__new(width,height,transparent,this->fillColor),null(),null());
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/blitter/Blitter.hx",32)
	this->spriteCache = ::Hash_obj::__new();
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/blitter/Blitter.hx",33)
	this->spriteQueue = Dynamic( Array_obj<Dynamic>::__new() );
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/blitter/Blitter.hx",34)
	this->eraseQueue = Array_obj< ::nme::geom::Rectangle >::__new();
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/blitter/Blitter.hx",35)
	{
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/blitter/Blitter.hx",35)
		int _g = (int)0;
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/blitter/Blitter.hx",35)
		while(((_g < zlevels))){
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/blitter/Blitter.hx",35)
			int n = (_g)++;
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/blitter/Blitter.hx",37)
			this->spriteQueue->__Field(HX_CSTRING("push"))(Dynamic( Array_obj<Dynamic>::__new() ));
		}
	}
}
;
	return null();
}

Blitter_obj::~Blitter_obj() { }

Dynamic Blitter_obj::__CreateEmpty() { return  new Blitter_obj; }
hx::ObjectPtr< Blitter_obj > Blitter_obj::__new(int width,int height,bool transparent,int color,Dynamic __o_zlevels)
{  hx::ObjectPtr< Blitter_obj > result = new Blitter_obj();
	result->__construct(width,height,transparent,color,__o_zlevels);
	return result;}

Dynamic Blitter_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Blitter_obj > result = new Blitter_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2],inArgs[3],inArgs[4]);
	return result;}

int Blitter_obj::getFillColor( ){
	HX_SOURCE_PUSH("Blitter_obj::getFillColor")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/blitter/Blitter.hx",20)
	return this->fillColor;
}


HX_DEFINE_DYNAMIC_FUNC0(Blitter_obj,getFillColor,return )

Void Blitter_obj::store( ::String name,::nme::display::BitmapData data){
{
		HX_SOURCE_PUSH("Blitter_obj::store")
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/blitter/Blitter.hx",42)
		this->spriteCache->set(name,data);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Blitter_obj,store,(void))

Void Blitter_obj::storeTiles( ::nme::display::BitmapData bd,int twidth,int theight,Dynamic naming){
{
		HX_SOURCE_PUSH("Blitter_obj::storeTiles")
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/blitter/Blitter.hx",48)
		int x = (int)0;
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/blitter/Blitter.hx",49)
		int y = (int)0;
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/blitter/Blitter.hx",51)
		int ct = (int)0;
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/blitter/Blitter.hx",53)
		while(((y < bd->nmeGetHeight()))){
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/blitter/Blitter.hx",55)
			while(((x < bd->nmeGetWidth()))){
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/blitter/Blitter.hx",57)
				::nme::display::BitmapData nt = ::nme::display::BitmapData_obj::__new(twidth,theight,true,(int)0);
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/blitter/Blitter.hx",58)
				::nme::geom::Matrix mtx = ::nme::geom::Matrix_obj::__new(null(),null(),null(),null(),null(),null());
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/blitter/Blitter.hx",59)
				mtx->translate(-(x),-(y));
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/blitter/Blitter.hx",60)
				nt->draw(bd,mtx,null(),null(),null(),null());
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/blitter/Blitter.hx",61)
				this->spriteCache->set(naming(ct).Cast< ::String >(),nt);
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/blitter/Blitter.hx",62)
				hx::AddEq(x,twidth);
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/blitter/Blitter.hx",63)
				(ct)++;
			}
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/blitter/Blitter.hx",65)
			x = (int)0;
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/blitter/Blitter.hx",66)
			hx::AddEq(y,theight);
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC4(Blitter_obj,storeTiles,(void))

Void Blitter_obj::queueName( ::String spr,int x,int y,int z){
{
		HX_SOURCE_PUSH("Blitter_obj::queueName")
		struct _Function_1_1{
			inline static Dynamic Block( ::com::ludamix::triad::blitter::Blitter_obj *__this,::String &spr,int &y,int &x){
				hx::Anon __result = hx::Anon_obj::Create();
				__result->Add(HX_CSTRING("bd") , __this->spriteCache->get(spr),false);
				__result->Add(HX_CSTRING("x") , x,false);
				__result->Add(HX_CSTRING("y") , y,false);
				return __result;
			}
		};
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/blitter/Blitter.hx",72)
		this->spriteQueue->__GetItem(z)->__Field(HX_CSTRING("push"))(_Function_1_1::Block(this,spr,y,x));
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC4(Blitter_obj,queueName,(void))

Void Blitter_obj::queueBD( ::nme::display::BitmapData spr,int x,int y,int z){
{
		HX_SOURCE_PUSH("Blitter_obj::queueBD")
		struct _Function_1_1{
			inline static Dynamic Block( ::nme::display::BitmapData &spr,int &y,int &x){
				hx::Anon __result = hx::Anon_obj::Create();
				__result->Add(HX_CSTRING("bd") , spr,false);
				__result->Add(HX_CSTRING("x") , x,false);
				__result->Add(HX_CSTRING("y") , y,false);
				return __result;
			}
		};
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/blitter/Blitter.hx",77)
		this->spriteQueue->__GetItem(z)->__Field(HX_CSTRING("push"))(_Function_1_1::Block(spr,y,x));
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC4(Blitter_obj,queueBD,(void))

Void Blitter_obj::update( ){
{
		HX_SOURCE_PUSH("Blitter_obj::update")
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/blitter/Blitter.hx",83)
		this->bitmapData->lock();
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/blitter/Blitter.hx",84)
		{
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/blitter/Blitter.hx",84)
			int _g = (int)0;
			Array< ::nme::geom::Rectangle > _g1 = this->eraseQueue;
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/blitter/Blitter.hx",84)
			while(((_g < _g1->length))){
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/blitter/Blitter.hx",84)
				::nme::geom::Rectangle n = _g1->__get(_g);
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/blitter/Blitter.hx",84)
				++(_g);
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/blitter/Blitter.hx",85)
				this->bitmapData->fillRect(n,this->fillColor);
			}
		}
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/blitter/Blitter.hx",86)
		this->eraseQueue = Array_obj< ::nme::geom::Rectangle >::__new();
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/blitter/Blitter.hx",87)
		::nme::geom::Point pt = ::nme::geom::Point_obj::__new(0.,0.);
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/blitter/Blitter.hx",88)
		::nme::geom::Point pt2 = ::nme::geom::Point_obj::__new(0.,0.);
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/blitter/Blitter.hx",89)
		{
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/blitter/Blitter.hx",89)
			int _g = (int)0;
			Dynamic _g1 = this->spriteQueue;
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/blitter/Blitter.hx",89)
			while(((_g < _g1->__Field(HX_CSTRING("length"))))){
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/blitter/Blitter.hx",89)
				Dynamic layer = _g1->__GetItem(_g);
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/blitter/Blitter.hx",89)
				++(_g);
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/blitter/Blitter.hx",91)
				while(((layer->__Field(HX_CSTRING("length")) > (int)0))){
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/blitter/Blitter.hx",93)
					Dynamic n = layer->__Field(HX_CSTRING("pop"))();
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/blitter/Blitter.hx",94)
					pt->x = n->__Field(HX_CSTRING("x"));
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/blitter/Blitter.hx",95)
					pt->y = n->__Field(HX_CSTRING("y"));
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/blitter/Blitter.hx",96)
					this->bitmapData->copyPixels(n->__Field(HX_CSTRING("bd")),n->__Field(HX_CSTRING("bd"))->__Field(HX_CSTRING("nmeGetRect"))(),pt,n->__Field(HX_CSTRING("bd")),pt2,true);
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/blitter/Blitter.hx",97)
					this->eraseQueue->push(::nme::geom::Rectangle_obj::__new(pt->x,pt->y,n->__Field(HX_CSTRING("bd"))->__Field(HX_CSTRING("nmeGetWidth"))(),n->__Field(HX_CSTRING("bd"))->__Field(HX_CSTRING("nmeGetHeight"))()));
				}
			}
		}
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/blitter/Blitter.hx",100)
		this->bitmapData->unlock(null());
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Blitter_obj,update,(void))


Blitter_obj::Blitter_obj()
{
}

void Blitter_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Blitter);
	HX_MARK_MEMBER_NAME(spriteCache,"spriteCache");
	HX_MARK_MEMBER_NAME(spriteQueue,"spriteQueue");
	HX_MARK_MEMBER_NAME(eraseQueue,"eraseQueue");
	HX_MARK_MEMBER_NAME(fillColor,"fillColor");
	super::__Mark(HX_MARK_ARG);
	HX_MARK_END_CLASS();
}

Dynamic Blitter_obj::__Field(const ::String &inName)
{
	switch(inName.length) {
	case 5:
		if (HX_FIELD_EQ(inName,"store") ) { return store_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"update") ) { return update_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"queueBD") ) { return queueBD_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"fillColor") ) { return fillColor; }
		if (HX_FIELD_EQ(inName,"queueName") ) { return queueName_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"eraseQueue") ) { return eraseQueue; }
		if (HX_FIELD_EQ(inName,"storeTiles") ) { return storeTiles_dyn(); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"spriteCache") ) { return spriteCache; }
		if (HX_FIELD_EQ(inName,"spriteQueue") ) { return spriteQueue; }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"getFillColor") ) { return getFillColor_dyn(); }
	}
	return super::__Field(inName);
}

Dynamic Blitter_obj::__SetField(const ::String &inName,const Dynamic &inValue)
{
	switch(inName.length) {
	case 9:
		if (HX_FIELD_EQ(inName,"fillColor") ) { fillColor=inValue.Cast< int >(); return inValue; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"eraseQueue") ) { eraseQueue=inValue.Cast< Array< ::nme::geom::Rectangle > >(); return inValue; }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"spriteCache") ) { spriteCache=inValue.Cast< ::Hash >(); return inValue; }
		if (HX_FIELD_EQ(inName,"spriteQueue") ) { spriteQueue=inValue.Cast< Dynamic >(); return inValue; }
	}
	return super::__SetField(inName,inValue);
}

void Blitter_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("spriteCache"));
	outFields->push(HX_CSTRING("spriteQueue"));
	outFields->push(HX_CSTRING("eraseQueue"));
	outFields->push(HX_CSTRING("fillColor"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

static ::String sMemberFields[] = {
	HX_CSTRING("spriteCache"),
	HX_CSTRING("spriteQueue"),
	HX_CSTRING("eraseQueue"),
	HX_CSTRING("fillColor"),
	HX_CSTRING("getFillColor"),
	HX_CSTRING("store"),
	HX_CSTRING("storeTiles"),
	HX_CSTRING("queueName"),
	HX_CSTRING("queueBD"),
	HX_CSTRING("update"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
};

Class Blitter_obj::__mClass;

void Blitter_obj::__register()
{
	Static(__mClass) = hx::RegisterClass(HX_CSTRING("com.ludamix.triad.blitter.Blitter"), hx::TCanCast< Blitter_obj> ,sStaticFields,sMemberFields,
	&__CreateEmpty, &__Create,
	&super::__SGetClass(), 0, sMarkStatics);
}

void Blitter_obj::__boot()
{
}

} // end namespace com
} // end namespace ludamix
} // end namespace triad
} // end namespace blitter
