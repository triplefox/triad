#include <hxcpp.h>

#ifndef INCLUDED_Std
#include <Std.h>
#endif
#ifndef INCLUDED_com_ludamix_triad_geom_AABB
#include <com/ludamix/triad/geom/AABB.h>
#endif
#ifndef INCLUDED_com_ludamix_triad_geom_SubINode
#include <com/ludamix/triad/geom/SubINode.h>
#endif
#ifndef INCLUDED_com_ludamix_triad_geom_SubIPoint
#include <com/ludamix/triad/geom/SubIPoint.h>
#endif
namespace com{
namespace ludamix{
namespace triad{
namespace geom{

Void SubINode_obj::__construct(int x,int y,::com::ludamix::triad::geom::SubINode parent)
{
{
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubINode.hx",32)
	this->parent = parent;
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubINode.hx",33)
	super::__construct(x,y);
}
;
	return null();
}

SubINode_obj::~SubINode_obj() { }

Dynamic SubINode_obj::__CreateEmpty() { return  new SubINode_obj; }
hx::ObjectPtr< SubINode_obj > SubINode_obj::__new(int x,int y,::com::ludamix::triad::geom::SubINode parent)
{  hx::ObjectPtr< SubINode_obj > result = new SubINode_obj();
	result->__construct(x,y,parent);
	return result;}

Dynamic SubINode_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< SubINode_obj > result = new SubINode_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2]);
	return result;}

Void SubINode_obj::pos( ::com::ludamix::triad::geom::SubIPoint fp){
{
		HX_SOURCE_PUSH("SubINode_obj::pos")
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubINode.hx",48)
		::com::ludamix::triad::geom::SubINode cur = hx::ObjectPtr<OBJ_>(this);
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubINode.hx",49)
		int x = cur->x;
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubINode.hx",50)
		int y = cur->y;
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubINode.hx",51)
		while(((cur->parent != null()))){
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubINode.hx",53)
			cur = cur->parent;
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubINode.hx",54)
			hx::AddEq(x,cur->x);
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubINode.hx",55)
			hx::AddEq(y,cur->y);
		}
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubINode.hx",57)
		fp->x = x;
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubINode.hx",58)
		fp->y = y;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(SubINode_obj,pos,(void))

Void SubINode_obj::addpos( ::com::ludamix::triad::geom::SubIPoint fp){
{
		HX_SOURCE_PUSH("SubINode_obj::addpos")
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubINode.hx",63)
		::com::ludamix::triad::geom::SubINode cur = hx::ObjectPtr<OBJ_>(this);
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubINode.hx",64)
		int x = cur->x;
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubINode.hx",65)
		int y = cur->y;
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubINode.hx",66)
		while(((cur->parent != null()))){
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubINode.hx",68)
			cur = cur->parent;
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubINode.hx",69)
			hx::AddEq(x,cur->x);
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubINode.hx",70)
			hx::AddEq(y,cur->y);
		}
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubINode.hx",72)
		hx::AddEq(fp->x,x);
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubINode.hx",73)
		hx::AddEq(fp->y,y);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(SubINode_obj,addpos,(void))

Void SubINode_obj::rectNoAlloc( ::com::ludamix::triad::geom::AABB pivot,::com::ludamix::triad::geom::AABB result,::com::ludamix::triad::geom::SubIPoint tmp){
{
		HX_SOURCE_PUSH("SubINode_obj::rectNoAlloc")
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubINode.hx",78)
		{
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubINode.hx",78)
			::com::ludamix::triad::geom::SubINode cur = hx::ObjectPtr<OBJ_>(this);
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubINode.hx",78)
			int x = cur->x;
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubINode.hx",78)
			int y = cur->y;
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubINode.hx",78)
			while(((cur->parent != null()))){
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubINode.hx",78)
				cur = cur->parent;
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubINode.hx",78)
				hx::AddEq(x,cur->x);
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubINode.hx",78)
				hx::AddEq(y,cur->y);
			}
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubINode.hx",78)
			tmp->x = x;
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubINode.hx",78)
			tmp->y = y;
		}
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubINode.hx",79)
		result->x = (tmp->x + pivot->x);
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubINode.hx",80)
		result->y = (tmp->y + pivot->y);
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubINode.hx",81)
		result->w = pivot->w;
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubINode.hx",82)
		result->h = pivot->h;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC3(SubINode_obj,rectNoAlloc,(void))

::com::ludamix::triad::geom::AABB SubINode_obj::rect( ::com::ludamix::triad::geom::AABB pivot){
	HX_SOURCE_PUSH("SubINode_obj::rect")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubINode.hx",87)
	::com::ludamix::triad::geom::SubIPoint tmp = ::com::ludamix::triad::geom::SubIPoint_obj::__new(this->x,this->y);
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubINode.hx",88)
	::com::ludamix::triad::geom::AABB result = ::com::ludamix::triad::geom::AABB_obj::__new((int)0,(int)0,(int)0,(int)0);
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubINode.hx",89)
	{
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubINode.hx",89)
		{
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubINode.hx",89)
			::com::ludamix::triad::geom::SubINode cur = hx::ObjectPtr<OBJ_>(this);
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubINode.hx",89)
			int x = cur->x;
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubINode.hx",89)
			int y = cur->y;
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubINode.hx",89)
			while(((cur->parent != null()))){
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubINode.hx",89)
				cur = cur->parent;
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubINode.hx",89)
				hx::AddEq(x,cur->x);
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubINode.hx",89)
				hx::AddEq(y,cur->y);
			}
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubINode.hx",89)
			tmp->x = x;
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubINode.hx",89)
			tmp->y = y;
		}
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubINode.hx",89)
		result->x = (tmp->x + pivot->x);
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubINode.hx",89)
		result->y = (tmp->y + pivot->y);
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubINode.hx",89)
		result->w = pivot->w;
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubINode.hx",89)
		result->h = pivot->h;
	}
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubINode.hx",90)
	return result;
}


HX_DEFINE_DYNAMIC_FUNC1(SubINode_obj,rect,return )

Void SubINode_obj::hotpointNoAlloc( ::com::ludamix::triad::geom::SubIPoint pivot,::com::ludamix::triad::geom::SubIPoint result){
{
		HX_SOURCE_PUSH("SubINode_obj::hotpointNoAlloc")
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubINode.hx",95)
		{
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubINode.hx",95)
			::com::ludamix::triad::geom::SubINode cur = hx::ObjectPtr<OBJ_>(this);
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubINode.hx",95)
			int x = cur->x;
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubINode.hx",95)
			int y = cur->y;
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubINode.hx",95)
			while(((cur->parent != null()))){
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubINode.hx",95)
				cur = cur->parent;
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubINode.hx",95)
				hx::AddEq(x,cur->x);
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubINode.hx",95)
				hx::AddEq(y,cur->y);
			}
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubINode.hx",95)
			result->x = x;
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubINode.hx",95)
			result->y = y;
		}
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubINode.hx",96)
		{
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubINode.hx",96)
			hx::AddEq(result->x,pivot->x);
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubINode.hx",96)
			hx::AddEq(result->y,pivot->y);
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(SubINode_obj,hotpointNoAlloc,(void))

::com::ludamix::triad::geom::SubIPoint SubINode_obj::hotpoint( ::com::ludamix::triad::geom::SubIPoint pivot){
	HX_SOURCE_PUSH("SubINode_obj::hotpoint")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubINode.hx",101)
	::com::ludamix::triad::geom::SubIPoint result = ::com::ludamix::triad::geom::SubIPoint_obj::__new(pivot->x,pivot->y);
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubINode.hx",102)
	{
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubINode.hx",102)
		::com::ludamix::triad::geom::SubINode cur = hx::ObjectPtr<OBJ_>(this);
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubINode.hx",102)
		int x = cur->x;
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubINode.hx",102)
		int y = cur->y;
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubINode.hx",102)
		while(((cur->parent != null()))){
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubINode.hx",102)
			cur = cur->parent;
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubINode.hx",102)
			hx::AddEq(x,cur->x);
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubINode.hx",102)
			hx::AddEq(y,cur->y);
		}
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubINode.hx",102)
		hx::AddEq(result->x,x);
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubINode.hx",102)
		hx::AddEq(result->y,y);
	}
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubINode.hx",103)
	return result;
}


HX_DEFINE_DYNAMIC_FUNC1(SubINode_obj,hotpoint,return )

::com::ludamix::triad::geom::SubINode SubINode_obj::fromInt( int x,int y,::com::ludamix::triad::geom::SubINode parent){
	HX_SOURCE_PUSH("SubINode_obj::fromInt")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubINode.hx",37)
	return ::com::ludamix::triad::geom::SubINode_obj::__new((int(x) << int((int)8)),(int(y) << int((int)8)),parent);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(SubINode_obj,fromInt,return )

::com::ludamix::triad::geom::SubINode SubINode_obj::fromFloat( int x,int y,::com::ludamix::triad::geom::SubINode parent){
	HX_SOURCE_PUSH("SubINode_obj::fromFloat")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/geom/SubINode.hx",42)
	return ::com::ludamix::triad::geom::SubINode_obj::__new(::Std_obj::_int((x * (int)256)),::Std_obj::_int((y * (int)256)),parent);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(SubINode_obj,fromFloat,return )


SubINode_obj::SubINode_obj()
{
}

void SubINode_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(SubINode);
	HX_MARK_MEMBER_NAME(parent,"parent");
	super::__Mark(HX_MARK_ARG);
	HX_MARK_END_CLASS();
}

Dynamic SubINode_obj::__Field(const ::String &inName)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"pos") ) { return pos_dyn(); }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"rect") ) { return rect_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"parent") ) { return parent; }
		if (HX_FIELD_EQ(inName,"addpos") ) { return addpos_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"fromInt") ) { return fromInt_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"hotpoint") ) { return hotpoint_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"fromFloat") ) { return fromFloat_dyn(); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"rectNoAlloc") ) { return rectNoAlloc_dyn(); }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"hotpointNoAlloc") ) { return hotpointNoAlloc_dyn(); }
	}
	return super::__Field(inName);
}

Dynamic SubINode_obj::__SetField(const ::String &inName,const Dynamic &inValue)
{
	switch(inName.length) {
	case 6:
		if (HX_FIELD_EQ(inName,"parent") ) { parent=inValue.Cast< ::com::ludamix::triad::geom::SubINode >(); return inValue; }
	}
	return super::__SetField(inName,inValue);
}

void SubINode_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("parent"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("fromInt"),
	HX_CSTRING("fromFloat"),
	String(null()) };

static ::String sMemberFields[] = {
	HX_CSTRING("parent"),
	HX_CSTRING("pos"),
	HX_CSTRING("addpos"),
	HX_CSTRING("rectNoAlloc"),
	HX_CSTRING("rect"),
	HX_CSTRING("hotpointNoAlloc"),
	HX_CSTRING("hotpoint"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
};

Class SubINode_obj::__mClass;

void SubINode_obj::__register()
{
	Static(__mClass) = hx::RegisterClass(HX_CSTRING("com.ludamix.triad.geom.SubINode"), hx::TCanCast< SubINode_obj> ,sStaticFields,sMemberFields,
	&__CreateEmpty, &__Create,
	&super::__SGetClass(), 0, sMarkStatics);
}

void SubINode_obj::__boot()
{
}

} // end namespace com
} // end namespace ludamix
} // end namespace triad
} // end namespace geom
