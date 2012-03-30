#include <hxcpp.h>

#ifndef INCLUDED_com_ludamix_triad_blitter_ASCIISheet
#include <com/ludamix/triad/blitter/ASCIISheet.h>
#endif
#ifndef INCLUDED_com_ludamix_triad_blitter_BlitterTileInfos
#include <com/ludamix/triad/blitter/BlitterTileInfos.h>
#endif
#ifndef INCLUDED_nme_display_BitmapData
#include <nme/display/BitmapData.h>
#endif
#ifndef INCLUDED_nme_display_IBitmapDrawable
#include <nme/display/IBitmapDrawable.h>
#endif
#ifndef INCLUDED_nme_geom_ColorTransform
#include <nme/geom/ColorTransform.h>
#endif
#ifndef INCLUDED_nme_geom_Matrix
#include <nme/geom/Matrix.h>
#endif
#ifndef INCLUDED_nme_geom_Rectangle
#include <nme/geom/Rectangle.h>
#endif
namespace com{
namespace ludamix{
namespace triad{
namespace blitter{

Void ASCIISheet_obj::__construct(::nme::display::BitmapData sheet,int twidth,int theight,Array< int > palette)
{
{
	HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIISheet.hx",46)
	this->palette = palette;
	HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIISheet.hx",48)
	this->chars = Array_obj< Array< Array< ::com::ludamix::triad::blitter::BlitterTileInfos > > >::__new();
	HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIISheet.hx",50)
	int fct = (int)0;
	HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIISheet.hx",51)
	{
		HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIISheet.hx",51)
		int _g = (int)0;
		HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIISheet.hx",51)
		while(((_g < palette->length))){
			HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIISheet.hx",51)
			int fg_color = palette->__get(_g);
			HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIISheet.hx",51)
			++(_g);
			HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIISheet.hx",53)
			this->chars->push(Array_obj< Array< ::com::ludamix::triad::blitter::BlitterTileInfos > >::__new());
			struct _Function_3_1{
				inline static Dynamic Block( int &fg_color){
					hx::Anon __result = hx::Anon_obj::Create();
					__result->Add(HX_CSTRING("r") , (int(fg_color) >> int((int)16)),false);
					__result->Add(HX_CSTRING("g") , (int((int(fg_color) >> int((int)8))) & int((int)255)),false);
					__result->Add(HX_CSTRING("b") , (int(fg_color) & int((int)255)),false);
					return __result;
				}
			};
			HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIISheet.hx",55)
			Dynamic rgb = _Function_3_1::Block(fg_color);
			HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIISheet.hx",56)
			{
				HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIISheet.hx",56)
				int _g1 = (int)0;
				HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIISheet.hx",56)
				while(((_g1 < palette->length))){
					HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIISheet.hx",56)
					int bg_color = palette->__get(_g1);
					HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIISheet.hx",56)
					++(_g1);
					HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIISheet.hx",61)
					::nme::display::BitmapData modsheet = ::nme::display::BitmapData_obj::__new(sheet->nmeGetWidth(),sheet->nmeGetHeight(),false,bg_color);
					HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIISheet.hx",63)
					modsheet->draw(sheet,::nme::geom::Matrix_obj::__new(null(),null(),null(),null(),null(),null()),::nme::geom::ColorTransform_obj::__new(1.0,1.0,1.0,1.0,rgb->__Field(HX_CSTRING("r")),rgb->__Field(HX_CSTRING("g")),rgb->__Field(HX_CSTRING("b")),(int)0),null(),null(),null());
					HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIISheet.hx",64)
					{
						HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIISheet.hx",64)
						int x = (int)0;
						HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIISheet.hx",64)
						int y = (int)0;
						HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIISheet.hx",64)
						int ct = (int)0;
						HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIISheet.hx",64)
						Array< ::com::ludamix::triad::blitter::BlitterTileInfos > bctarray = Array_obj< ::com::ludamix::triad::blitter::BlitterTileInfos >::__new();
						HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIISheet.hx",64)
						this->chars->__get(fct)->push(bctarray);
						HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIISheet.hx",64)
						while(((y < modsheet->nmeGetHeight()))){
							HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIISheet.hx",64)
							while(((x < modsheet->nmeGetWidth()))){
								HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIISheet.hx",64)
								bctarray->push(::com::ludamix::triad::blitter::BlitterTileInfos_obj::__new(modsheet,::nme::geom::Rectangle_obj::__new(x,y,twidth,theight)));
								HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIISheet.hx",64)
								hx::AddEq(x,twidth);
								HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIISheet.hx",64)
								(ct)++;
							}
							HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIISheet.hx",64)
							x = (int)0;
							HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIISheet.hx",64)
							hx::AddEq(y,theight);
						}
					}
				}
			}
			HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIISheet.hx",66)
			(fct)++;
		}
	}
	HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIISheet.hx",69)
	this->twidth = twidth;
	HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIISheet.hx",70)
	this->theight = theight;
}
;
	return null();
}

ASCIISheet_obj::~ASCIISheet_obj() { }

Dynamic ASCIISheet_obj::__CreateEmpty() { return  new ASCIISheet_obj; }
hx::ObjectPtr< ASCIISheet_obj > ASCIISheet_obj::__new(::nme::display::BitmapData sheet,int twidth,int theight,Array< int > palette)
{  hx::ObjectPtr< ASCIISheet_obj > result = new ASCIISheet_obj();
	result->__construct(sheet,twidth,theight,palette);
	return result;}

Dynamic ASCIISheet_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< ASCIISheet_obj > result = new ASCIISheet_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2],inArgs[3]);
	return result;}

Void ASCIISheet_obj::storeTiles( ::nme::display::BitmapData bd,int twidth,int theight,int fct){
{
		HX_SOURCE_PUSH("ASCIISheet_obj::storeTiles")
		HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIISheet.hx",22)
		int x = (int)0;
		HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIISheet.hx",23)
		int y = (int)0;
		HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIISheet.hx",25)
		int ct = (int)0;
		HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIISheet.hx",27)
		Array< ::com::ludamix::triad::blitter::BlitterTileInfos > bctarray = Array_obj< ::com::ludamix::triad::blitter::BlitterTileInfos >::__new();
		HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIISheet.hx",28)
		this->chars->__get(fct)->push(bctarray);
		HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIISheet.hx",30)
		while(((y < bd->nmeGetHeight()))){
			HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIISheet.hx",32)
			while(((x < bd->nmeGetWidth()))){
				HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIISheet.hx",34)
				bctarray->push(::com::ludamix::triad::blitter::BlitterTileInfos_obj::__new(bd,::nme::geom::Rectangle_obj::__new(x,y,twidth,theight)));
				HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIISheet.hx",35)
				hx::AddEq(x,twidth);
				HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIISheet.hx",36)
				(ct)++;
			}
			HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIISheet.hx",38)
			x = (int)0;
			HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/blitter/ASCIISheet.hx",39)
			hx::AddEq(y,theight);
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC4(ASCIISheet_obj,storeTiles,(void))


ASCIISheet_obj::ASCIISheet_obj()
{
}

void ASCIISheet_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(ASCIISheet);
	HX_MARK_MEMBER_NAME(chars,"chars");
	HX_MARK_MEMBER_NAME(palette,"palette");
	HX_MARK_MEMBER_NAME(twidth,"twidth");
	HX_MARK_MEMBER_NAME(theight,"theight");
	HX_MARK_END_CLASS();
}

Dynamic ASCIISheet_obj::__Field(const ::String &inName)
{
	switch(inName.length) {
	case 5:
		if (HX_FIELD_EQ(inName,"chars") ) { return chars; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"twidth") ) { return twidth; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"palette") ) { return palette; }
		if (HX_FIELD_EQ(inName,"theight") ) { return theight; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"storeTiles") ) { return storeTiles_dyn(); }
	}
	return super::__Field(inName);
}

Dynamic ASCIISheet_obj::__SetField(const ::String &inName,const Dynamic &inValue)
{
	switch(inName.length) {
	case 5:
		if (HX_FIELD_EQ(inName,"chars") ) { chars=inValue.Cast< Array< Array< Array< ::com::ludamix::triad::blitter::BlitterTileInfos > > > >(); return inValue; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"twidth") ) { twidth=inValue.Cast< int >(); return inValue; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"palette") ) { palette=inValue.Cast< Array< int > >(); return inValue; }
		if (HX_FIELD_EQ(inName,"theight") ) { theight=inValue.Cast< int >(); return inValue; }
	}
	return super::__SetField(inName,inValue);
}

void ASCIISheet_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("chars"));
	outFields->push(HX_CSTRING("palette"));
	outFields->push(HX_CSTRING("twidth"));
	outFields->push(HX_CSTRING("theight"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

static ::String sMemberFields[] = {
	HX_CSTRING("chars"),
	HX_CSTRING("palette"),
	HX_CSTRING("twidth"),
	HX_CSTRING("theight"),
	HX_CSTRING("storeTiles"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
};

Class ASCIISheet_obj::__mClass;

void ASCIISheet_obj::__register()
{
	Static(__mClass) = hx::RegisterClass(HX_CSTRING("com.ludamix.triad.blitter.ASCIISheet"), hx::TCanCast< ASCIISheet_obj> ,sStaticFields,sMemberFields,
	&__CreateEmpty, &__Create,
	&super::__SGetClass(), 0, sMarkStatics);
}

void ASCIISheet_obj::__boot()
{
}

} // end namespace com
} // end namespace ludamix
} // end namespace triad
} // end namespace blitter
