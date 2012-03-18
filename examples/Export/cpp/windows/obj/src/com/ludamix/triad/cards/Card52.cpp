#include <hxcpp.h>

#ifndef INCLUDED_Std
#include <Std.h>
#endif
#ifndef INCLUDED_com_ludamix_triad_cards_Card
#include <com/ludamix/triad/cards/Card.h>
#endif
#ifndef INCLUDED_com_ludamix_triad_cards_Card52
#include <com/ludamix/triad/cards/Card52.h>
#endif
#ifndef INCLUDED_com_ludamix_triad_cards_Deck
#include <com/ludamix/triad/cards/Deck.h>
#endif
namespace com{
namespace ludamix{
namespace triad{
namespace cards{

Void Card52_obj::__construct(int suit,int value,::String owner)
{
{
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Card52.hx",18)
	this->idx = ((value * (int)4) + suit);
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Card52.hx",19)
	super::__construct(owner,null());
}
;
	return null();
}

Card52_obj::~Card52_obj() { }

Dynamic Card52_obj::__CreateEmpty() { return  new Card52_obj; }
hx::ObjectPtr< Card52_obj > Card52_obj::__new(int suit,int value,::String owner)
{  hx::ObjectPtr< Card52_obj > result = new Card52_obj();
	result->__construct(suit,value,owner);
	return result;}

Dynamic Card52_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Card52_obj > result = new Card52_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2]);
	return result;}

int Card52_obj::suit( ){
	HX_SOURCE_PUSH("Card52_obj::suit")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Card52.hx",11)
	return ::Std_obj::_int(hx::Mod(this->idx,(int)4));
}


HX_DEFINE_DYNAMIC_FUNC0(Card52_obj,suit,return )

int Card52_obj::value( ){
	HX_SOURCE_PUSH("Card52_obj::value")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Card52.hx",12)
	return (::Std_obj::_int((double(this->idx) / double((int)4))) + (int)1);
}


HX_DEFINE_DYNAMIC_FUNC0(Card52_obj,value,return )

::String Card52_obj::suitName( ){
	HX_SOURCE_PUSH("Card52_obj::suitName")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Card52.hx",13)
	return Array_obj< ::String >::__new().Add(HX_CSTRING("Spades")).Add(HX_CSTRING("Hearts")).Add(HX_CSTRING("Diamonds")).Add(HX_CSTRING("Clubs"))->__get(::Std_obj::_int(hx::Mod(this->idx,(int)4)));
}


HX_DEFINE_DYNAMIC_FUNC0(Card52_obj,suitName,return )

::String Card52_obj::valueName( ){
	HX_SOURCE_PUSH("Card52_obj::valueName")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Card52.hx",14)
	return Array_obj< ::String >::__new().Add(HX_CSTRING("Ace")).Add(HX_CSTRING("2")).Add(HX_CSTRING("3")).Add(HX_CSTRING("4")).Add(HX_CSTRING("5")).Add(HX_CSTRING("6")).Add(HX_CSTRING("7")).Add(HX_CSTRING("8")).Add(HX_CSTRING("9")).Add(HX_CSTRING("10")).Add(HX_CSTRING("Jack")).Add(HX_CSTRING("Queen")).Add(HX_CSTRING("King"))->__get(::Std_obj::_int((double(this->idx) / double((int)4))));
}


HX_DEFINE_DYNAMIC_FUNC0(Card52_obj,valueName,return )

::String Card52_obj::toString( ){
	HX_SOURCE_PUSH("Card52_obj::toString")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Card52.hx",37)
	if ((this->hidden)){
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Card52.hx",39)
		return HX_CSTRING("Hidden");
	}
	else{
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Card52.hx",40)
		if (((this->idx == (int)52))){
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Card52.hx",41)
			return HX_CSTRING("Joker");
		}
		else{
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Card52.hx",43)
			return ((this->valueName() + HX_CSTRING(" of ")) + this->suitName());
		}
	}
}


HX_DEFINE_DYNAMIC_FUNC0(Card52_obj,toString,return )

Array< ::String > Card52_obj::suitNames;

Array< ::String > Card52_obj::valueNames;

::com::ludamix::triad::cards::Deck Card52_obj::deck( ::com::ludamix::triad::cards::Deck d){
	HX_SOURCE_PUSH("Card52_obj::deck")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Card52.hx",24)
	if (((d == null()))){
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Card52.hx",25)
		d = ::com::ludamix::triad::cards::Deck_obj::__new();
	}
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Card52.hx",26)
	{
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Card52.hx",26)
		int _g = (int)0;
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Card52.hx",26)
		while(((_g < (int)4))){
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Card52.hx",26)
			int s = (_g)++;
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Card52.hx",28)
			{
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Card52.hx",28)
				int _g1 = (int)0;
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Card52.hx",28)
				while(((_g1 < (int)13))){
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Card52.hx",28)
					int v = (_g1)++;
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Card52.hx",30)
					d->push(::com::ludamix::triad::cards::Card52_obj::__new(s,v,HX_CSTRING("deck")),HX_CSTRING("deck"));
				}
			}
		}
	}
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Card52.hx",33)
	return d;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Card52_obj,deck,return )

::String Card52_obj::spriteNaming( int idx){
	HX_SOURCE_PUSH("Card52_obj::spriteNaming")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Card52.hx",47)
	if (((idx < (int)53))){
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Card52.hx",48)
		return (HX_CSTRING("card_") + ::Std_obj::string(idx));
	}
	else{
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Card52.hx",49)
		return HX_CSTRING("card_back");
	}
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Card52_obj,spriteNaming,return )


Card52_obj::Card52_obj()
{
}

void Card52_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Card52);
	HX_MARK_MEMBER_NAME(idx,"idx");
	super::__Mark(HX_MARK_ARG);
	HX_MARK_END_CLASS();
}

Dynamic Card52_obj::__Field(const ::String &inName)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"idx") ) { return idx; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"deck") ) { return deck_dyn(); }
		if (HX_FIELD_EQ(inName,"suit") ) { return suit_dyn(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"value") ) { return value_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"suitName") ) { return suitName_dyn(); }
		if (HX_FIELD_EQ(inName,"toString") ) { return toString_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"suitNames") ) { return suitNames; }
		if (HX_FIELD_EQ(inName,"valueName") ) { return valueName_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"valueNames") ) { return valueNames; }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"spriteNaming") ) { return spriteNaming_dyn(); }
	}
	return super::__Field(inName);
}

Dynamic Card52_obj::__SetField(const ::String &inName,const Dynamic &inValue)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"idx") ) { idx=inValue.Cast< int >(); return inValue; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"suitNames") ) { suitNames=inValue.Cast< Array< ::String > >(); return inValue; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"valueNames") ) { valueNames=inValue.Cast< Array< ::String > >(); return inValue; }
	}
	return super::__SetField(inName,inValue);
}

void Card52_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("idx"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("suitNames"),
	HX_CSTRING("valueNames"),
	HX_CSTRING("deck"),
	HX_CSTRING("spriteNaming"),
	String(null()) };

static ::String sMemberFields[] = {
	HX_CSTRING("idx"),
	HX_CSTRING("suit"),
	HX_CSTRING("value"),
	HX_CSTRING("suitName"),
	HX_CSTRING("valueName"),
	HX_CSTRING("toString"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Card52_obj::suitNames,"suitNames");
	HX_MARK_MEMBER_NAME(Card52_obj::valueNames,"valueNames");
};

Class Card52_obj::__mClass;

void Card52_obj::__register()
{
	Static(__mClass) = hx::RegisterClass(HX_CSTRING("com.ludamix.triad.cards.Card52"), hx::TCanCast< Card52_obj> ,sStaticFields,sMemberFields,
	&__CreateEmpty, &__Create,
	&super::__SGetClass(), 0, sMarkStatics);
}

void Card52_obj::__boot()
{
	hx::Static(suitNames) = Array_obj< ::String >::__new().Add(HX_CSTRING("Spades")).Add(HX_CSTRING("Hearts")).Add(HX_CSTRING("Diamonds")).Add(HX_CSTRING("Clubs"));
	hx::Static(valueNames) = Array_obj< ::String >::__new().Add(HX_CSTRING("Ace")).Add(HX_CSTRING("2")).Add(HX_CSTRING("3")).Add(HX_CSTRING("4")).Add(HX_CSTRING("5")).Add(HX_CSTRING("6")).Add(HX_CSTRING("7")).Add(HX_CSTRING("8")).Add(HX_CSTRING("9")).Add(HX_CSTRING("10")).Add(HX_CSTRING("Jack")).Add(HX_CSTRING("Queen")).Add(HX_CSTRING("King"));
}

} // end namespace com
} // end namespace ludamix
} // end namespace triad
} // end namespace cards
