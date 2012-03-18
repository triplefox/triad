#include <hxcpp.h>

#ifndef INCLUDED_com_ludamix_triad_cards_Card
#include <com/ludamix/triad/cards/Card.h>
#endif
namespace com{
namespace ludamix{
namespace triad{
namespace cards{

Void Card_obj::__construct(::String owner,Dynamic __o_hidden)
{
bool hidden = __o_hidden.Default(false);
{
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Card.hx",11)
	this->owner = owner;
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Card.hx",12)
	this->hidden = hidden;
}
;
	return null();
}

Card_obj::~Card_obj() { }

Dynamic Card_obj::__CreateEmpty() { return  new Card_obj; }
hx::ObjectPtr< Card_obj > Card_obj::__new(::String owner,Dynamic __o_hidden)
{  hx::ObjectPtr< Card_obj > result = new Card_obj();
	result->__construct(owner,__o_hidden);
	return result;}

Dynamic Card_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Card_obj > result = new Card_obj();
	result->__construct(inArgs[0],inArgs[1]);
	return result;}


Card_obj::Card_obj()
{
}

void Card_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Card);
	HX_MARK_MEMBER_NAME(owner,"owner");
	HX_MARK_MEMBER_NAME(hidden,"hidden");
	HX_MARK_END_CLASS();
}

Dynamic Card_obj::__Field(const ::String &inName)
{
	switch(inName.length) {
	case 5:
		if (HX_FIELD_EQ(inName,"owner") ) { return owner; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"hidden") ) { return hidden; }
	}
	return super::__Field(inName);
}

Dynamic Card_obj::__SetField(const ::String &inName,const Dynamic &inValue)
{
	switch(inName.length) {
	case 5:
		if (HX_FIELD_EQ(inName,"owner") ) { owner=inValue.Cast< ::String >(); return inValue; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"hidden") ) { hidden=inValue.Cast< bool >(); return inValue; }
	}
	return super::__SetField(inName,inValue);
}

void Card_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("owner"));
	outFields->push(HX_CSTRING("hidden"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

static ::String sMemberFields[] = {
	HX_CSTRING("owner"),
	HX_CSTRING("hidden"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
};

Class Card_obj::__mClass;

void Card_obj::__register()
{
	Static(__mClass) = hx::RegisterClass(HX_CSTRING("com.ludamix.triad.cards.Card"), hx::TCanCast< Card_obj> ,sStaticFields,sMemberFields,
	&__CreateEmpty, &__Create,
	&super::__SGetClass(), 0, sMarkStatics);
}

void Card_obj::__boot()
{
}

} // end namespace com
} // end namespace ludamix
} // end namespace triad
} // end namespace cards
