#include <hxcpp.h>

#ifndef INCLUDED_Lambda
#include <Lambda.h>
#endif
#ifndef INCLUDED_List
#include <List.h>
#endif

Void Lambda_obj::__construct()
{
	return null();
}

Lambda_obj::~Lambda_obj() { }

Dynamic Lambda_obj::__CreateEmpty() { return  new Lambda_obj; }
hx::ObjectPtr< Lambda_obj > Lambda_obj::__new()
{  hx::ObjectPtr< Lambda_obj > result = new Lambda_obj();
	result->__construct();
	return result;}

Dynamic Lambda_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Lambda_obj > result = new Lambda_obj();
	result->__construct();
	return result;}

Dynamic Lambda_obj::array( Dynamic it){
	HX_SOURCE_PUSH("Lambda_obj::array")
	HX_SOURCE_POS("C:\\Motion-Twin\\haxe/std/Lambda.hx",36)
	Dynamic a = Dynamic( Array_obj<Dynamic>::__new() );
	HX_SOURCE_POS("C:\\Motion-Twin\\haxe/std/Lambda.hx",37)
	for(::cpp::FastIterator_obj< Dynamic > *__it = ::cpp::CreateFastIterator< Dynamic >(it->__Field(HX_CSTRING("iterator"))());  __it->hasNext(); ){
		Dynamic i = __it->next();
		a->__Field(HX_CSTRING("push"))(i);
	}
	HX_SOURCE_POS("C:\\Motion-Twin\\haxe/std/Lambda.hx",39)
	return a;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Lambda_obj,array,return )

::List Lambda_obj::list( Dynamic it){
	HX_SOURCE_PUSH("Lambda_obj::list")
	HX_SOURCE_POS("C:\\Motion-Twin\\haxe/std/Lambda.hx",46)
	::List l = ::List_obj::__new();
	HX_SOURCE_POS("C:\\Motion-Twin\\haxe/std/Lambda.hx",47)
	for(::cpp::FastIterator_obj< Dynamic > *__it = ::cpp::CreateFastIterator< Dynamic >(it->__Field(HX_CSTRING("iterator"))());  __it->hasNext(); ){
		Dynamic i = __it->next();
		l->add(i);
	}
	HX_SOURCE_POS("C:\\Motion-Twin\\haxe/std/Lambda.hx",49)
	return l;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Lambda_obj,list,return )

::List Lambda_obj::map( Dynamic it,Dynamic f){
	HX_SOURCE_PUSH("Lambda_obj::map")
	HX_SOURCE_POS("C:\\Motion-Twin\\haxe/std/Lambda.hx",57)
	::List l = ::List_obj::__new();
	HX_SOURCE_POS("C:\\Motion-Twin\\haxe/std/Lambda.hx",58)
	for(::cpp::FastIterator_obj< Dynamic > *__it = ::cpp::CreateFastIterator< Dynamic >(it->__Field(HX_CSTRING("iterator"))());  __it->hasNext(); ){
		Dynamic x = __it->next();
		l->add(f(x));
	}
	HX_SOURCE_POS("C:\\Motion-Twin\\haxe/std/Lambda.hx",60)
	return l;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Lambda_obj,map,return )

::List Lambda_obj::mapi( Dynamic it,Dynamic f){
	HX_SOURCE_PUSH("Lambda_obj::mapi")
	HX_SOURCE_POS("C:\\Motion-Twin\\haxe/std/Lambda.hx",67)
	::List l = ::List_obj::__new();
	HX_SOURCE_POS("C:\\Motion-Twin\\haxe/std/Lambda.hx",68)
	int i = (int)0;
	HX_SOURCE_POS("C:\\Motion-Twin\\haxe/std/Lambda.hx",69)
	for(::cpp::FastIterator_obj< Dynamic > *__it = ::cpp::CreateFastIterator< Dynamic >(it->__Field(HX_CSTRING("iterator"))());  __it->hasNext(); ){
		Dynamic x = __it->next();
		l->add(f((i)++,x));
	}
	HX_SOURCE_POS("C:\\Motion-Twin\\haxe/std/Lambda.hx",71)
	return l;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Lambda_obj,mapi,return )

bool Lambda_obj::has( Dynamic it,Dynamic elt,Dynamic cmp){
	HX_SOURCE_PUSH("Lambda_obj::has")
	HX_SOURCE_POS("C:\\Motion-Twin\\haxe/std/Lambda.hx",82)
	if (((cmp == null()))){
		HX_SOURCE_POS("C:\\Motion-Twin\\haxe/std/Lambda.hx",82)
		for(::cpp::FastIterator_obj< Dynamic > *__it = ::cpp::CreateFastIterator< Dynamic >(it->__Field(HX_CSTRING("iterator"))());  __it->hasNext(); ){
			Dynamic x = __it->next();
			if (((x == elt))){
				HX_SOURCE_POS("C:\\Motion-Twin\\haxe/std/Lambda.hx",85)
				return true;
			}
;
		}
	}
	else{
		HX_SOURCE_POS("C:\\Motion-Twin\\haxe/std/Lambda.hx",86)
		for(::cpp::FastIterator_obj< Dynamic > *__it = ::cpp::CreateFastIterator< Dynamic >(it->__Field(HX_CSTRING("iterator"))());  __it->hasNext(); ){
			Dynamic x = __it->next();
			if ((cmp(x,elt).Cast< bool >())){
				HX_SOURCE_POS("C:\\Motion-Twin\\haxe/std/Lambda.hx",89)
				return true;
			}
;
		}
	}
	HX_SOURCE_POS("C:\\Motion-Twin\\haxe/std/Lambda.hx",91)
	return false;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(Lambda_obj,has,return )

bool Lambda_obj::exists( Dynamic it,Dynamic f){
	HX_SOURCE_PUSH("Lambda_obj::exists")
	HX_SOURCE_POS("C:\\Motion-Twin\\haxe/std/Lambda.hx",98)
	for(::cpp::FastIterator_obj< Dynamic > *__it = ::cpp::CreateFastIterator< Dynamic >(it->__Field(HX_CSTRING("iterator"))());  __it->hasNext(); ){
		Dynamic x = __it->next();
		if ((f(x).Cast< bool >())){
			HX_SOURCE_POS("C:\\Motion-Twin\\haxe/std/Lambda.hx",100)
			return true;
		}
;
	}
	HX_SOURCE_POS("C:\\Motion-Twin\\haxe/std/Lambda.hx",101)
	return false;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Lambda_obj,exists,return )

bool Lambda_obj::foreach( Dynamic it,Dynamic f){
	HX_SOURCE_PUSH("Lambda_obj::foreach")
	HX_SOURCE_POS("C:\\Motion-Twin\\haxe/std/Lambda.hx",108)
	for(::cpp::FastIterator_obj< Dynamic > *__it = ::cpp::CreateFastIterator< Dynamic >(it->__Field(HX_CSTRING("iterator"))());  __it->hasNext(); ){
		Dynamic x = __it->next();
		if ((!(f(x).Cast< bool >()))){
			HX_SOURCE_POS("C:\\Motion-Twin\\haxe/std/Lambda.hx",110)
			return false;
		}
;
	}
	HX_SOURCE_POS("C:\\Motion-Twin\\haxe/std/Lambda.hx",111)
	return true;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Lambda_obj,foreach,return )

Void Lambda_obj::iter( Dynamic it,Dynamic f){
{
		HX_SOURCE_PUSH("Lambda_obj::iter")
		HX_SOURCE_POS("C:\\Motion-Twin\\haxe/std/Lambda.hx",117)
		for(::cpp::FastIterator_obj< Dynamic > *__it = ::cpp::CreateFastIterator< Dynamic >(it->__Field(HX_CSTRING("iterator"))());  __it->hasNext(); ){
			Dynamic x = __it->next();
			f(x).Cast< Void >();
		}
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Lambda_obj,iter,(void))

::List Lambda_obj::filter( Dynamic it,Dynamic f){
	HX_SOURCE_PUSH("Lambda_obj::filter")
	HX_SOURCE_POS("C:\\Motion-Twin\\haxe/std/Lambda.hx",126)
	::List l = ::List_obj::__new();
	HX_SOURCE_POS("C:\\Motion-Twin\\haxe/std/Lambda.hx",127)
	for(::cpp::FastIterator_obj< Dynamic > *__it = ::cpp::CreateFastIterator< Dynamic >(it->__Field(HX_CSTRING("iterator"))());  __it->hasNext(); ){
		Dynamic x = __it->next();
		if ((f(x).Cast< bool >())){
			HX_SOURCE_POS("C:\\Motion-Twin\\haxe/std/Lambda.hx",129)
			l->add(x);
		}
;
	}
	HX_SOURCE_POS("C:\\Motion-Twin\\haxe/std/Lambda.hx",130)
	return l;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Lambda_obj,filter,return )

Dynamic Lambda_obj::fold( Dynamic it,Dynamic f,Dynamic first){
	HX_SOURCE_PUSH("Lambda_obj::fold")
	HX_SOURCE_POS("C:\\Motion-Twin\\haxe/std/Lambda.hx",137)
	for(::cpp::FastIterator_obj< Dynamic > *__it = ::cpp::CreateFastIterator< Dynamic >(it->__Field(HX_CSTRING("iterator"))());  __it->hasNext(); ){
		Dynamic x = __it->next();
		first = f(x,first);
	}
	HX_SOURCE_POS("C:\\Motion-Twin\\haxe/std/Lambda.hx",139)
	return first;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(Lambda_obj,fold,return )

int Lambda_obj::count( Dynamic it,Dynamic pred){
	HX_SOURCE_PUSH("Lambda_obj::count")
	HX_SOURCE_POS("C:\\Motion-Twin\\haxe/std/Lambda.hx",146)
	int n = (int)0;
	HX_SOURCE_POS("C:\\Motion-Twin\\haxe/std/Lambda.hx",147)
	if (((pred == null()))){
		HX_SOURCE_POS("C:\\Motion-Twin\\haxe/std/Lambda.hx",148)
		for(::cpp::FastIterator_obj< Dynamic > *__it = ::cpp::CreateFastIterator< Dynamic >(it->__Field(HX_CSTRING("iterator"))());  __it->hasNext(); ){
			Dynamic _ = __it->next();
			(n)++;
		}
	}
	else{
		HX_SOURCE_POS("C:\\Motion-Twin\\haxe/std/Lambda.hx",151)
		for(::cpp::FastIterator_obj< Dynamic > *__it = ::cpp::CreateFastIterator< Dynamic >(it->__Field(HX_CSTRING("iterator"))());  __it->hasNext(); ){
			Dynamic x = __it->next();
			if ((pred(x).Cast< bool >())){
				HX_SOURCE_POS("C:\\Motion-Twin\\haxe/std/Lambda.hx",153)
				(n)++;
			}
;
		}
	}
	HX_SOURCE_POS("C:\\Motion-Twin\\haxe/std/Lambda.hx",154)
	return n;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Lambda_obj,count,return )

bool Lambda_obj::empty( Dynamic it){
	HX_SOURCE_PUSH("Lambda_obj::empty")
	HX_SOURCE_POS("C:\\Motion-Twin\\haxe/std/Lambda.hx",160)
	return !(it->__Field(HX_CSTRING("iterator"))()->__Field(HX_CSTRING("hasNext"))());
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Lambda_obj,empty,return )

int Lambda_obj::indexOf( Dynamic it,Dynamic v){
	HX_SOURCE_PUSH("Lambda_obj::indexOf")
	HX_SOURCE_POS("C:\\Motion-Twin\\haxe/std/Lambda.hx",169)
	int i = (int)0;
	HX_SOURCE_POS("C:\\Motion-Twin\\haxe/std/Lambda.hx",170)
	for(::cpp::FastIterator_obj< Dynamic > *__it = ::cpp::CreateFastIterator< Dynamic >(it->__Field(HX_CSTRING("iterator"))());  __it->hasNext(); ){
		Dynamic v2 = __it->next();
		{
			HX_SOURCE_POS("C:\\Motion-Twin\\haxe/std/Lambda.hx",171)
			if (((v == v2))){
				HX_SOURCE_POS("C:\\Motion-Twin\\haxe/std/Lambda.hx",172)
				return i;
			}
			HX_SOURCE_POS("C:\\Motion-Twin\\haxe/std/Lambda.hx",173)
			(i)++;
		}
;
	}
	HX_SOURCE_POS("C:\\Motion-Twin\\haxe/std/Lambda.hx",175)
	return (int)-1;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Lambda_obj,indexOf,return )

::List Lambda_obj::concat( Dynamic a,Dynamic b){
	HX_SOURCE_PUSH("Lambda_obj::concat")
	HX_SOURCE_POS("C:\\Motion-Twin\\haxe/std/Lambda.hx",182)
	::List l = ::List_obj::__new();
	HX_SOURCE_POS("C:\\Motion-Twin\\haxe/std/Lambda.hx",183)
	for(::cpp::FastIterator_obj< Dynamic > *__it = ::cpp::CreateFastIterator< Dynamic >(a->__Field(HX_CSTRING("iterator"))());  __it->hasNext(); ){
		Dynamic x = __it->next();
		l->add(x);
	}
	HX_SOURCE_POS("C:\\Motion-Twin\\haxe/std/Lambda.hx",185)
	for(::cpp::FastIterator_obj< Dynamic > *__it = ::cpp::CreateFastIterator< Dynamic >(b->__Field(HX_CSTRING("iterator"))());  __it->hasNext(); ){
		Dynamic x = __it->next();
		l->add(x);
	}
	HX_SOURCE_POS("C:\\Motion-Twin\\haxe/std/Lambda.hx",187)
	return l;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Lambda_obj,concat,return )


Lambda_obj::Lambda_obj()
{
}

void Lambda_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Lambda);
	HX_MARK_END_CLASS();
}

Dynamic Lambda_obj::__Field(const ::String &inName)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"map") ) { return map_dyn(); }
		if (HX_FIELD_EQ(inName,"has") ) { return has_dyn(); }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"list") ) { return list_dyn(); }
		if (HX_FIELD_EQ(inName,"mapi") ) { return mapi_dyn(); }
		if (HX_FIELD_EQ(inName,"iter") ) { return iter_dyn(); }
		if (HX_FIELD_EQ(inName,"fold") ) { return fold_dyn(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"array") ) { return array_dyn(); }
		if (HX_FIELD_EQ(inName,"count") ) { return count_dyn(); }
		if (HX_FIELD_EQ(inName,"empty") ) { return empty_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"exists") ) { return exists_dyn(); }
		if (HX_FIELD_EQ(inName,"filter") ) { return filter_dyn(); }
		if (HX_FIELD_EQ(inName,"concat") ) { return concat_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"foreach") ) { return foreach_dyn(); }
		if (HX_FIELD_EQ(inName,"indexOf") ) { return indexOf_dyn(); }
	}
	return super::__Field(inName);
}

Dynamic Lambda_obj::__SetField(const ::String &inName,const Dynamic &inValue)
{
	return super::__SetField(inName,inValue);
}

void Lambda_obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("array"),
	HX_CSTRING("list"),
	HX_CSTRING("map"),
	HX_CSTRING("mapi"),
	HX_CSTRING("has"),
	HX_CSTRING("exists"),
	HX_CSTRING("foreach"),
	HX_CSTRING("iter"),
	HX_CSTRING("filter"),
	HX_CSTRING("fold"),
	HX_CSTRING("count"),
	HX_CSTRING("empty"),
	HX_CSTRING("indexOf"),
	HX_CSTRING("concat"),
	String(null()) };

static ::String sMemberFields[] = {
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
};

Class Lambda_obj::__mClass;

void Lambda_obj::__register()
{
	Static(__mClass) = hx::RegisterClass(HX_CSTRING("Lambda"), hx::TCanCast< Lambda_obj> ,sStaticFields,sMemberFields,
	&__CreateEmpty, &__Create,
	&super::__SGetClass(), 0, sMarkStatics);
}

void Lambda_obj::__boot()
{
}

