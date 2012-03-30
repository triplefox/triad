#include <hxcpp.h>

#ifndef INCLUDED_Std
#include <Std.h>
#endif
#ifndef INCLUDED_com_ludamix_triad_blitter_ASCIIMap
#include <com/ludamix/triad/blitter/ASCIIMap.h>
#endif
#ifndef INCLUDED_com_ludamix_triad_blitter_ASCIISheet
#include <com/ludamix/triad/blitter/ASCIISheet.h>
#endif
#ifndef INCLUDED_com_ludamix_triad_blitter_BlitterTileInfos
#include <com/ludamix/triad/blitter/BlitterTileInfos.h>
#endif
#ifndef INCLUDED_com_ludamix_triad_grid_AbstractGrid
#include <com/ludamix/triad/grid/AbstractGrid.h>
#endif
#ifndef INCLUDED_com_ludamix_triad_grid_IntGrid
#include <com/ludamix/triad/grid/IntGrid.h>
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

Void ASCIIMap_obj::__construct(::com::ludamix::triad::blitter::ASCIISheet sheet,int mapwidth,int mapheight)
{
{
	HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIIMap.hx",22)
	int vwidth = (sheet->twidth * mapwidth);
	HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIIMap.hx",23)
	int vheight = (sheet->theight * mapheight);
	HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIIMap.hx",25)
	super::__construct(::nme::display::BitmapData_obj::__new(vwidth,vheight,false,(int)16711935),null(),null());
	HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIIMap.hx",27)
	this->sheet = sheet;
	HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIIMap.hx",29)
	Array< int > ar = Array_obj< int >::__new();
	HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIIMap.hx",29)
	{
		HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIIMap.hx",29)
		int _g1 = (int)0;
		int _g = (mapwidth * mapheight);
		HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIIMap.hx",29)
		while(((_g1 < _g))){
			HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIIMap.hx",29)
			int n = (_g1)++;
			HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIIMap.hx",29)
			ar->push((int)0);
		}
	}
	HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIIMap.hx",30)
	Array< int > ar2 = Array_obj< int >::__new();
	HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIIMap.hx",30)
	{
		HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIIMap.hx",30)
		int _g1 = (int)0;
		int _g = (mapwidth * mapheight);
		HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIIMap.hx",30)
		while(((_g1 < _g))){
			HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIIMap.hx",30)
			int n = (_g1)++;
			HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIIMap.hx",30)
			ar->push((int)-1);
		}
	}
	HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIIMap.hx",32)
	this->_char = ::com::ludamix::triad::grid::IntGrid_obj::__new(mapwidth,mapheight,sheet->twidth,sheet->theight,ar);
	HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIIMap.hx",33)
	this->swap = ::com::ludamix::triad::grid::IntGrid_obj::__new(mapwidth,mapheight,sheet->twidth,sheet->theight,ar2);
}
;
	return null();
}

ASCIIMap_obj::~ASCIIMap_obj() { }

Dynamic ASCIIMap_obj::__CreateEmpty() { return  new ASCIIMap_obj; }
hx::ObjectPtr< ASCIIMap_obj > ASCIIMap_obj::__new(::com::ludamix::triad::blitter::ASCIISheet sheet,int mapwidth,int mapheight)
{  hx::ObjectPtr< ASCIIMap_obj > result = new ASCIIMap_obj();
	result->__construct(sheet,mapwidth,mapheight);
	return result;}

Dynamic ASCIIMap_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< ASCIIMap_obj > result = new ASCIIMap_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2]);
	return result;}

Void ASCIIMap_obj::update( ){
{
		HX_SOURCE_PUSH("ASCIIMap_obj::update")
		HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIIMap.hx",39)
		this->bitmapData->lock();
		HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIIMap.hx",40)
		::nme::geom::Point pt2 = ::nme::geom::Point_obj::__new(0.,0.);
		HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIIMap.hx",41)
		{
			HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIIMap.hx",41)
			int _g1 = (int)0;
			int _g = this->_char->world->__Field(HX_CSTRING("length"));
			HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIIMap.hx",41)
			while(((_g1 < _g))){
				HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIIMap.hx",41)
				int n = (_g1)++;
				HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIIMap.hx",43)
				if (((this->_char->world->__GetItem(n) != this->swap->world->__GetItem(n)))){
					struct _Function_4_1{
						inline static Dynamic Block( ::com::ludamix::triad::blitter::ASCIIMap_obj *__this,int &n){
							HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIIMap.hx",45)
							::com::ludamix::triad::grid::IntGrid _this = __this->_char;
							struct _Function_5_1{
								inline static Dynamic Block( int &n,::com::ludamix::triad::grid::AbstractGrid &_this){
									HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIIMap.hx",45)
									int x = hx::Mod(n,_this->worldW);
									struct _Function_6_1{
										inline static Dynamic Block( int &n,::com::ludamix::triad::grid::AbstractGrid &_this,int &x){
											hx::Anon __result = hx::Anon_obj::Create();
											__result->Add(HX_CSTRING("y") , ::Std_obj::_int((double(((n - x))) / double(_this->worldW))),false);
											__result->Add(HX_CSTRING("x") , x,false);
											return __result;
										}
									};
									HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIIMap.hx",45)
									return _Function_6_1::Block(n,_this,x);
								}
							};
							HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIIMap.hx",45)
							Dynamic p = _Function_5_1::Block(n,_this);
							struct _Function_5_2{
								inline static Dynamic Block( Dynamic &p,::com::ludamix::triad::grid::AbstractGrid &_this){
									hx::Anon __result = hx::Anon_obj::Create();
									__result->Add(HX_CSTRING("x") , (p->__Field(HX_CSTRING("x")) * _this->twidth),false);
									__result->Add(HX_CSTRING("y") , (p->__Field(HX_CSTRING("y")) * _this->theight),false);
									return __result;
								}
							};
							HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIIMap.hx",45)
							return _Function_5_2::Block(p,_this);
						}
					};
					HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIIMap.hx",45)
					Dynamic ppre = _Function_4_1::Block(this,n);
					HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIIMap.hx",46)
					::nme::geom::Point pt = ::nme::geom::Point_obj::__new(ppre->__Field(HX_CSTRING("x")),ppre->__Field(HX_CSTRING("y")));
					struct _Function_4_2{
						inline static Dynamic Block( ::com::ludamix::triad::blitter::ASCIIMap_obj *__this,int &n){
							HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIIMap.hx",47)
							int packed = __this->_char->world->__GetItem(n);
							struct _Function_5_1{
								inline static Dynamic Block( int &packed){
									hx::Anon __result = hx::Anon_obj::Create();
									__result->Add(HX_CSTRING("bg") , (int(packed) >> int((int)16)),false);
									__result->Add(HX_CSTRING("fg") , (int((int(packed) >> int((int)8))) & int((int)255)),false);
									__result->Add(HX_CSTRING("char") , (int(packed) & int((int)255)),false);
									return __result;
								}
							};
							HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIIMap.hx",47)
							return _Function_5_1::Block(packed);
						}
					};
					HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIIMap.hx",47)
					Dynamic dec = _Function_4_2::Block(this,n);
					HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIIMap.hx",48)
					::com::ludamix::triad::blitter::BlitterTileInfos tinfos = this->sheet->chars->__get(dec->__Field(HX_CSTRING("bg")))->__get(dec->__Field(HX_CSTRING("fg")))->__get(dec->__Field(HX_CSTRING("char")));
					HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIIMap.hx",49)
					this->bitmapData->copyPixels(tinfos->bd,tinfos->rect,pt,tinfos->bd,pt2,false);
				}
			}
		}
		HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIIMap.hx",52)
		this->bitmapData->unlock(null());
		HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIIMap.hx",53)
		this->swap->world = this->_char->world->__Field(HX_CSTRING("copy"))();
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(ASCIIMap_obj,update,(void))

int ASCIIMap_obj::encode( int bg_color,int fg_color,int _char){
	HX_SOURCE_PUSH("ASCIIMap_obj::encode")
	HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIIMap.hx",57)
	return ((((int(bg_color) << int((int)16))) + ((int(fg_color) << int((int)8)))) + _char);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(ASCIIMap_obj,encode,return )

Dynamic ASCIIMap_obj::decode( int packed){
	HX_SOURCE_PUSH("ASCIIMap_obj::decode")
	struct _Function_1_1{
		inline static Dynamic Block( int &packed){
			hx::Anon __result = hx::Anon_obj::Create();
			__result->Add(HX_CSTRING("bg") , (int(packed) >> int((int)16)),false);
			__result->Add(HX_CSTRING("fg") , (int((int(packed) >> int((int)8))) & int((int)255)),false);
			__result->Add(HX_CSTRING("char") , (int(packed) & int((int)255)),false);
			return __result;
		}
	};
	HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIIMap.hx",62)
	return _Function_1_1::Block(packed);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(ASCIIMap_obj,decode,return )


ASCIIMap_obj::ASCIIMap_obj()
{
}

void ASCIIMap_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(ASCIIMap);
	HX_MARK_MEMBER_NAME(sheet,"sheet");
	HX_MARK_MEMBER_NAME(_char,"char");
	HX_MARK_MEMBER_NAME(swap,"swap");
	super::__Mark(HX_MARK_ARG);
	HX_MARK_END_CLASS();
}

Dynamic ASCIIMap_obj::__Field(const ::String &inName)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"char") ) { return _char; }
		if (HX_FIELD_EQ(inName,"swap") ) { return swap; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"sheet") ) { return sheet; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"encode") ) { return encode_dyn(); }
		if (HX_FIELD_EQ(inName,"decode") ) { return decode_dyn(); }
		if (HX_FIELD_EQ(inName,"update") ) { return update_dyn(); }
	}
	return super::__Field(inName);
}

Dynamic ASCIIMap_obj::__SetField(const ::String &inName,const Dynamic &inValue)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"char") ) { _char=inValue.Cast< ::com::ludamix::triad::grid::IntGrid >(); return inValue; }
		if (HX_FIELD_EQ(inName,"swap") ) { swap=inValue.Cast< ::com::ludamix::triad::grid::IntGrid >(); return inValue; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"sheet") ) { sheet=inValue.Cast< ::com::ludamix::triad::blitter::ASCIISheet >(); return inValue; }
	}
	return super::__SetField(inName,inValue);
}

void ASCIIMap_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("sheet"));
	outFields->push(HX_CSTRING("char"));
	outFields->push(HX_CSTRING("swap"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("encode"),
	HX_CSTRING("decode"),
	String(null()) };

static ::String sMemberFields[] = {
	HX_CSTRING("sheet"),
	HX_CSTRING("char"),
	HX_CSTRING("swap"),
	HX_CSTRING("update"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
};

Class ASCIIMap_obj::__mClass;

void ASCIIMap_obj::__register()
{
	Static(__mClass) = hx::RegisterClass(HX_CSTRING("com.ludamix.triad.blitter.ASCIIMap"), hx::TCanCast< ASCIIMap_obj> ,sStaticFields,sMemberFields,
	&__CreateEmpty, &__Create,
	&super::__SGetClass(), 0, sMarkStatics);
}

void ASCIIMap_obj::__boot()
{
}

} // end namespace com
} // end namespace ludamix
} // end namespace triad
} // end namespace blitter
