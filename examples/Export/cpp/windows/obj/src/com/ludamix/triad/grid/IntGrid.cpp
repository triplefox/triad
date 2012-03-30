#include <hxcpp.h>

#ifndef INCLUDED_com_ludamix_triad_grid_AbstractGrid
#include <com/ludamix/triad/grid/AbstractGrid.h>
#endif
#ifndef INCLUDED_com_ludamix_triad_grid_IntGrid
#include <com/ludamix/triad/grid/IntGrid.h>
#endif
namespace com{
namespace ludamix{
namespace triad{
namespace grid{

Void IntGrid_obj::__construct(int worldw,int worldh,double twidth,double theight,Array< int > populate)
{
{
	HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/IntGrid.hx",3)
	super::__construct(worldw,worldh,twidth,theight,populate);
}
;
	return null();
}

IntGrid_obj::~IntGrid_obj() { }

Dynamic IntGrid_obj::__CreateEmpty() { return  new IntGrid_obj; }
hx::ObjectPtr< IntGrid_obj > IntGrid_obj::__new(int worldw,int worldh,double twidth,double theight,Array< int > populate)
{  hx::ObjectPtr< IntGrid_obj > result = new IntGrid_obj();
	result->__construct(worldw,worldh,twidth,theight,populate);
	return result;}

Dynamic IntGrid_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< IntGrid_obj > result = new IntGrid_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2],inArgs[3],inArgs[4]);
	return result;}

Void IntGrid_obj::copyTo( Dynamic _tmp_prev,int idx){
{
		HX_SOURCE_PUSH("IntGrid_obj::copyTo")
		HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/IntGrid.hx",7)
		int prev = _tmp_prev;
		HX_SOURCE_POS("\\Dropbox\\triad_git\\dev/com/ludamix/triad/grid/IntGrid.hx",7)
		hx::IndexRef((this->world).mPtr,idx) = prev;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(IntGrid_obj,copyTo,(void))


IntGrid_obj::IntGrid_obj()
{
}

void IntGrid_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(IntGrid);
	super::__Mark(HX_MARK_ARG);
	HX_MARK_END_CLASS();
}

Dynamic IntGrid_obj::__Field(const ::String &inName)
{
	switch(inName.length) {
	case 6:
		if (HX_FIELD_EQ(inName,"copyTo") ) { return copyTo_dyn(); }
	}
	return super::__Field(inName);
}

Dynamic IntGrid_obj::__SetField(const ::String &inName,const Dynamic &inValue)
{
	return super::__SetField(inName,inValue);
}

void IntGrid_obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

static ::String sMemberFields[] = {
	HX_CSTRING("copyTo"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
};

Class IntGrid_obj::__mClass;

void IntGrid_obj::__register()
{
	Static(__mClass) = hx::RegisterClass(HX_CSTRING("com.ludamix.triad.grid.IntGrid"), hx::TCanCast< IntGrid_obj> ,sStaticFields,sMemberFields,
	&__CreateEmpty, &__Create,
	&super::__SGetClass(), 0, sMarkStatics);
}

void IntGrid_obj::__boot()
{
}

} // end namespace com
} // end namespace ludamix
} // end namespace triad
} // end namespace grid
