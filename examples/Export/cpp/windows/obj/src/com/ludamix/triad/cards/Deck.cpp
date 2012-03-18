#include <hxcpp.h>

#ifndef INCLUDED_Hash
#include <Hash.h>
#endif
#ifndef INCLUDED_com_ludamix_triad_cards_Card
#include <com/ludamix/triad/cards/Card.h>
#endif
#ifndef INCLUDED_com_ludamix_triad_cards_Deck
#include <com/ludamix/triad/cards/Deck.h>
#endif
#ifndef INCLUDED_com_ludamix_triad_cards_Hand
#include <com/ludamix/triad/cards/Hand.h>
#endif
namespace com{
namespace ludamix{
namespace triad{
namespace cards{

Void Deck_obj::__construct()
{
{
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Deck.hx",11)
	this->cards = Array_obj< ::com::ludamix::triad::cards::Card >::__new();
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Deck.hx",12)
	this->hands = ::Hash_obj::__new();
}
;
	return null();
}

Deck_obj::~Deck_obj() { }

Dynamic Deck_obj::__CreateEmpty() { return  new Deck_obj; }
hx::ObjectPtr< Deck_obj > Deck_obj::__new()
{  hx::ObjectPtr< Deck_obj > result = new Deck_obj();
	result->__construct();
	return result;}

Dynamic Deck_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Deck_obj > result = new Deck_obj();
	result->__construct();
	return result;}

::com::ludamix::triad::cards::Hand Deck_obj::hand( ::String name){
	HX_SOURCE_PUSH("Deck_obj::hand")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Deck.hx",16)
	if ((this->hands->exists(name))){
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Deck.hx",17)
		return this->hands->get(name);
	}
	else{
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Deck.hx",18)
		this->hands->set(name,::com::ludamix::triad::cards::Hand_obj::__new(name));
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Deck.hx",18)
		return this->hands->get(name);
	}
}


HX_DEFINE_DYNAMIC_FUNC1(Deck_obj,hand,return )

Void Deck_obj::push( ::com::ludamix::triad::cards::Card card,::String handName){
{
		HX_SOURCE_PUSH("Deck_obj::push")
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Deck.hx",23)
		this->cards->push(card);
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Deck.hx",24)
		if (((handName != null()))){
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Deck.hx",25)
			this->hand(handName)->push(card);
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Deck_obj,push,(void))

::com::ludamix::triad::cards::Card Deck_obj::drawAndMove( ::String handFrom,::String handTo,Dynamic __o_position){
int position = __o_position.Default(-1);
	HX_SOURCE_PUSH("Deck_obj::drawAndMove");
{
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Deck.hx",30)
		::com::ludamix::triad::cards::Card c = this->hand(handFrom)->draw();
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Deck.hx",31)
		this->moveCard(c,handTo,position);
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Deck.hx",32)
		return c;
	}
}


HX_DEFINE_DYNAMIC_FUNC3(Deck_obj,drawAndMove,return )

Void Deck_obj::moveCard( ::com::ludamix::triad::cards::Card card,::String handTo,Dynamic __o_position){
int position = __o_position.Default(-1);
	HX_SOURCE_PUSH("Deck_obj::moveCard");
{
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Deck.hx",37)
		for(::cpp::FastIterator_obj< ::com::ludamix::triad::cards::Hand > *__it = ::cpp::CreateFastIterator< ::com::ludamix::triad::cards::Hand >(this->hands->iterator());  __it->hasNext(); ){
			::com::ludamix::triad::cards::Hand h = __it->next();
			h->remove(card);
		}
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Deck.hx",39)
		if (((position == (int)-1))){
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Deck.hx",40)
			this->hand(handTo)->insert(card,this->hand(handTo)->cards->length);
		}
		else{
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Deck.hx",42)
			this->hand(handTo)->insert(card,position);
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC3(Deck_obj,moveCard,(void))

Void Deck_obj::withAllCards( Dynamic func){
{
		HX_SOURCE_PUSH("Deck_obj::withAllCards")
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Deck.hx",47)
		int _g = (int)0;
		Array< ::com::ludamix::triad::cards::Card > _g1 = this->cards;
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Deck.hx",47)
		while(((_g < _g1->length))){
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Deck.hx",47)
			::com::ludamix::triad::cards::Card n = _g1->__get(_g);
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Deck.hx",47)
			++(_g);
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Deck.hx",49)
			func(n).Cast< Void >();
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Deck_obj,withAllCards,(void))

Void Deck_obj::withCardsIn( ::String handName,Dynamic func){
{
		HX_SOURCE_PUSH("Deck_obj::withCardsIn")
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Deck.hx",55)
		int _g = (int)0;
		Array< ::com::ludamix::triad::cards::Card > _g1 = this->hand(handName)->cards->copy();
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Deck.hx",55)
		while(((_g < _g1->length))){
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Deck.hx",55)
			::com::ludamix::triad::cards::Card n = _g1->__get(_g);
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Deck.hx",55)
			++(_g);
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Deck.hx",57)
			func(n).Cast< Void >();
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Deck_obj,withCardsIn,(void))


Deck_obj::Deck_obj()
{
}

void Deck_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Deck);
	HX_MARK_MEMBER_NAME(cards,"cards");
	HX_MARK_MEMBER_NAME(hands,"hands");
	HX_MARK_END_CLASS();
}

Dynamic Deck_obj::__Field(const ::String &inName)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"hand") ) { return hand_dyn(); }
		if (HX_FIELD_EQ(inName,"push") ) { return push_dyn(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"cards") ) { return cards; }
		if (HX_FIELD_EQ(inName,"hands") ) { return hands; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"moveCard") ) { return moveCard_dyn(); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"drawAndMove") ) { return drawAndMove_dyn(); }
		if (HX_FIELD_EQ(inName,"withCardsIn") ) { return withCardsIn_dyn(); }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"withAllCards") ) { return withAllCards_dyn(); }
	}
	return super::__Field(inName);
}

Dynamic Deck_obj::__SetField(const ::String &inName,const Dynamic &inValue)
{
	switch(inName.length) {
	case 5:
		if (HX_FIELD_EQ(inName,"cards") ) { cards=inValue.Cast< Array< ::com::ludamix::triad::cards::Card > >(); return inValue; }
		if (HX_FIELD_EQ(inName,"hands") ) { hands=inValue.Cast< ::Hash >(); return inValue; }
	}
	return super::__SetField(inName,inValue);
}

void Deck_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("cards"));
	outFields->push(HX_CSTRING("hands"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

static ::String sMemberFields[] = {
	HX_CSTRING("cards"),
	HX_CSTRING("hands"),
	HX_CSTRING("hand"),
	HX_CSTRING("push"),
	HX_CSTRING("drawAndMove"),
	HX_CSTRING("moveCard"),
	HX_CSTRING("withAllCards"),
	HX_CSTRING("withCardsIn"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
};

Class Deck_obj::__mClass;

void Deck_obj::__register()
{
	Static(__mClass) = hx::RegisterClass(HX_CSTRING("com.ludamix.triad.cards.Deck"), hx::TCanCast< Deck_obj> ,sStaticFields,sMemberFields,
	&__CreateEmpty, &__Create,
	&super::__SGetClass(), 0, sMarkStatics);
}

void Deck_obj::__boot()
{
}

} // end namespace com
} // end namespace ludamix
} // end namespace triad
} // end namespace cards
