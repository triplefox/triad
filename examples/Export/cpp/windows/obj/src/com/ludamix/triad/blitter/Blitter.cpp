#include <hxcpp.h>

#ifndef INCLUDED_Hash
#include <Hash.h>
#endif
#ifndef INCLUDED_com_ludamix_triad_blitter_Blitter
#include <com/ludamix/triad/blitter/Blitter.h>
#endif
#ifndef INCLUDED_com_ludamix_triad_blitter_BlitterQueueInfos
#include <com/ludamix/triad/blitter/BlitterQueueInfos.h>
#endif
#ifndef INCLUDED_com_ludamix_triad_blitter_BlitterTileInfos
#include <com/ludamix/triad/blitter/BlitterTileInfos.h>
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
	HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/Blitter.hx",43)
	this->fillColor = color;
	HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/Blitter.hx",44)
	super::__construct(::nme::display::BitmapData_obj::__new(width,height,transparent,this->fillColor),null(),null());
	HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/Blitter.hx",45)
	this->spriteCache = ::Hash_obj::__new();
	HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/Blitter.hx",46)
	this->tileCache = ::Hash_obj::__new();
	HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/Blitter.hx",47)
	this->spriteQueue = Array_obj< Array< ::com::ludamix::triad::blitter::BlitterQueueInfos > >::__new();
	HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/Blitter.hx",48)
	this->eraseQueue = Array_obj< ::nme::geom::Rectangle >::__new();
	HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/Blitter.hx",49)
	{
		HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/Blitter.hx",49)
		int _g = (int)0;
		HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/Blitter.hx",49)
		while(((_g < zlevels))){
			HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/Blitter.hx",49)
			int n = (_g)++;
			HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/Blitter.hx",51)
			this->spriteQueue->push(Array_obj< ::com::ludamix::triad::blitter::BlitterQueueInfos >::__new());
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
	HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/Blitter.hx",33)
	return this->fillColor;
}


HX_DEFINE_DYNAMIC_FUNC0(Blitter_obj,getFillColor,return )

Void Blitter_obj::store( ::String name,::nme::display::BitmapData data){
{
		HX_SOURCE_PUSH("Blitter_obj::store")
		HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/Blitter.hx",56)
		this->spriteCache->set(name,data);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Blitter_obj,store,(void))

Void Blitter_obj::storeTiles( ::nme::display::BitmapData bd,int twidth,int theight,Dynamic naming){
{
		HX_SOURCE_PUSH("Blitter_obj::storeTiles")
		HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/Blitter.hx",62)
		int x = (int)0;
		HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/Blitter.hx",63)
		int y = (int)0;
		HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/Blitter.hx",65)
		int ct = (int)0;
		HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/Blitter.hx",67)
		while(((y < bd->nmeGetHeight()))){
			HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/Blitter.hx",69)
			while(((x < bd->nmeGetWidth()))){
				HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/Blitter.hx",71)
				this->tileCache->set(naming(ct).Cast< ::String >(),::com::ludamix::triad::blitter::BlitterTileInfos_obj::__new(bd,::nme::geom::Rectangle_obj::__new(x,y,twidth,theight)));
				HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/Blitter.hx",72)
				hx::AddEq(x,twidth);
				HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/Blitter.hx",73)
				(ct)++;
			}
			HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/Blitter.hx",75)
			x = (int)0;
			HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/Blitter.hx",76)
			hx::AddEq(y,theight);
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC4(Blitter_obj,storeTiles,(void))

Void Blitter_obj::queueName( ::String spr,int x,int y,int z){
{
		HX_SOURCE_PUSH("Blitter_obj::queueName")
		HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/Blitter.hx",82)
		if ((this->tileCache->exists(spr))){
			HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/Blitter.hx",85)
			::com::ludamix::triad::blitter::BlitterTileInfos tile = this->tileCache->get(spr);
			HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/Blitter.hx",86)
			this->spriteQueue->__get(z)->push(::com::ludamix::triad::blitter::BlitterQueueInfos_obj::__new(tile->bd,tile->rect,x,y));
		}
		else{
			HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/Blitter.hx",88)
			if ((this->spriteCache->exists(spr))){
				HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/Blitter.hx",90)
				::nme::display::BitmapData sprite = this->spriteCache->get(spr);
				HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/Blitter.hx",91)
				this->spriteQueue->__get(z)->push(::com::ludamix::triad::blitter::BlitterQueueInfos_obj::__new(sprite,sprite->nmeGetRect(),x,y));
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC4(Blitter_obj,queueName,(void))

Void Blitter_obj::queueBD( ::nme::display::BitmapData spr,int x,int y,int z){
{
		HX_SOURCE_PUSH("Blitter_obj::queueBD")
		HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/Blitter.hx",96)
		this->spriteQueue->__get(z)->push(::com::ludamix::triad::blitter::BlitterQueueInfos_obj::__new(spr,spr->nmeGetRect(),x,y));
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC4(Blitter_obj,queueBD,(void))

Void Blitter_obj::queueBDRect( ::nme::display::BitmapData spr,::nme::geom::Rectangle rect,int x,int y,int z){
{
		HX_SOURCE_PUSH("Blitter_obj::queueBDRect")
		HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/Blitter.hx",101)
		this->spriteQueue->__get(z)->push(::com::ludamix::triad::blitter::BlitterQueueInfos_obj::__new(spr,rect,x,y));
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC5(Blitter_obj,queueBDRect,(void))

Void Blitter_obj::update( ){
{
		HX_SOURCE_PUSH("Blitter_obj::update")
		HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/Blitter.hx",107)
		this->bitmapData->lock();
		HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/Blitter.hx",108)
		{
			HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/Blitter.hx",108)
			int _g = (int)0;
			Array< ::nme::geom::Rectangle > _g1 = this->eraseQueue;
			HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/Blitter.hx",108)
			while(((_g < _g1->length))){
				HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/Blitter.hx",108)
				::nme::geom::Rectangle n = _g1->__get(_g);
				HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/Blitter.hx",108)
				++(_g);
				HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/Blitter.hx",109)
				this->bitmapData->fillRect(n,this->fillColor);
			}
		}
		HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/Blitter.hx",110)
		this->eraseQueue = Array_obj< ::nme::geom::Rectangle >::__new();
		HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/Blitter.hx",111)
		::nme::geom::Point pt = ::nme::geom::Point_obj::__new(0.,0.);
		HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/Blitter.hx",112)
		::nme::geom::Point pt2 = ::nme::geom::Point_obj::__new(0.,0.);
		HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/Blitter.hx",113)
		{
			HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/Blitter.hx",113)
			int _g = (int)0;
			Array< Array< ::com::ludamix::triad::blitter::BlitterQueueInfos > > _g1 = this->spriteQueue;
			HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/Blitter.hx",113)
			while(((_g < _g1->length))){
				HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/Blitter.hx",113)
				Array< ::com::ludamix::triad::blitter::BlitterQueueInfos > layer = _g1->__get(_g);
				HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/Blitter.hx",113)
				++(_g);
				HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/Blitter.hx",115)
				while(((layer->length > (int)0))){
					HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/Blitter.hx",117)
					::com::ludamix::triad::blitter::BlitterQueueInfos n = layer->pop();
					HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/Blitter.hx",118)
					pt->x = n->x;
					HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/Blitter.hx",119)
					pt->y = n->y;
					HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/Blitter.hx",120)
					this->bitmapData->copyPixels(n->bd,n->rect,pt,n->bd,pt2,true);
					HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/Blitter.hx",121)
					this->eraseQueue->push(n->rect);
				}
			}
		}
		HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/Blitter.hx",124)
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
	HX_MARK_MEMBER_NAME(tileCache,"tileCache");
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
		if (HX_FIELD_EQ(inName,"tileCache") ) { return tileCache; }
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
		if (HX_FIELD_EQ(inName,"queueBDRect") ) { return queueBDRect_dyn(); }
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
		if (HX_FIELD_EQ(inName,"tileCache") ) { tileCache=inValue.Cast< ::Hash >(); return inValue; }
		if (HX_FIELD_EQ(inName,"fillColor") ) { fillColor=inValue.Cast< int >(); return inValue; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"eraseQueue") ) { eraseQueue=inValue.Cast< Array< ::nme::geom::Rectangle > >(); return inValue; }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"spriteCache") ) { spriteCache=inValue.Cast< ::Hash >(); return inValue; }
		if (HX_FIELD_EQ(inName,"spriteQueue") ) { spriteQueue=inValue.Cast< Array< Array< ::com::ludamix::triad::blitter::BlitterQueueInfos > > >(); return inValue; }
	}
	return super::__SetField(inName,inValue);
}

void Blitter_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("spriteCache"));
	outFields->push(HX_CSTRING("tileCache"));
	outFields->push(HX_CSTRING("spriteQueue"));
	outFields->push(HX_CSTRING("eraseQueue"));
	outFields->push(HX_CSTRING("fillColor"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

static ::String sMemberFields[] = {
	HX_CSTRING("spriteCache"),
	HX_CSTRING("tileCache"),
	HX_CSTRING("spriteQueue"),
	HX_CSTRING("eraseQueue"),
	HX_CSTRING("fillColor"),
	HX_CSTRING("getFillColor"),
	HX_CSTRING("store"),
	HX_CSTRING("storeTiles"),
	HX_CSTRING("queueName"),
	HX_CSTRING("queueBD"),
	HX_CSTRING("queueBDRect"),
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
