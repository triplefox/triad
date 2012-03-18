#include <hxcpp.h>

#ifndef INCLUDED_com_ludamix_triad_cards_BlackjackGame
#include <com/ludamix/triad/cards/BlackjackGame.h>
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
#ifndef INCLUDED_com_ludamix_triad_cards_Hand
#include <com/ludamix/triad/cards/Hand.h>
#endif
namespace com{
namespace ludamix{
namespace triad{
namespace cards{

Void BlackjackGame_obj::__construct()
{
{
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",14)
	this->state = (int)2;
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",15)
	super::__construct();
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",16)
	::com::ludamix::triad::cards::Card52_obj::deck(hx::ObjectPtr<OBJ_>(this));
}
;
	return null();
}

BlackjackGame_obj::~BlackjackGame_obj() { }

Dynamic BlackjackGame_obj::__CreateEmpty() { return  new BlackjackGame_obj; }
hx::ObjectPtr< BlackjackGame_obj > BlackjackGame_obj::__new()
{  hx::ObjectPtr< BlackjackGame_obj > result = new BlackjackGame_obj();
	result->__construct();
	return result;}

Dynamic BlackjackGame_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< BlackjackGame_obj > result = new BlackjackGame_obj();
	result->__construct();
	return result;}

int BlackjackGame_obj::permutations( ::String hand){
	HX_SOURCE_PUSH("BlackjackGame_obj::permutations")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",21)
	Array< int > tot = Array_obj< int >::__new().Add((int)0);
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",22)
	Array< int > aces = Array_obj< int >::__new().Add((int)0);

	HX_BEGIN_LOCAL_FUNC_S2(hx::LocalFunc,_Function_1_1,Array< int >,aces,Array< int >,tot)
	Void run(::com::ludamix::triad::cards::Card52 card){
{
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",24)
			int val = card->value();
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",24)
			if (((val == (int)1))){
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",24)
				(aces[(int)0])++;
			}
			else{
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",24)
				hx::AddEq(tot[(int)0],val);
			}
		}
		return null();
	}
	HX_END_LOCAL_FUNC1((void))

	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",23)
	this->withCardsIn(hand, Dynamic(new _Function_1_1(aces,tot)));
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",27)
	if (((aces->__get((int)0) == (int)0))){
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",27)
		return tot->__get((int)0);
	}
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",29)
	int best = (int)99999;
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",30)
	int ct = aces->__get((int)0);
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",31)
	while(((ct > (int)0))){
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",33)
		int result = ((tot->__get((int)0) + ((aces->__get((int)0) - ct))) + (ct * (int)13));
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",34)
		if (((bool((bool((result < best)) && bool((best > (int)21)))) || bool((bool((bool((result > best)) && bool((best <= (int)21)))) && bool((result <= (int)21))))))){
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",35)
			best = result;
		}
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",36)
		(ct)--;
	}
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",38)
	return best;
}


HX_DEFINE_DYNAMIC_FUNC1(BlackjackGame_obj,permutations,return )

Void BlackjackGame_obj::check( ){
{
		HX_SOURCE_PUSH("BlackjackGame_obj::check")
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",43)
		int minVal = this->permutations(HX_CSTRING("player"));
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",44)
		int dealerVal = this->permutations(HX_CSTRING("dealer"));
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",46)
		if (((minVal == (int)21))){
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",46)
			this->state = (int)0;
		}
		else{
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",47)
			if (((dealerVal == (int)21))){
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",47)
				this->state = (int)1;
			}
			else{
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",48)
				if (((minVal > (int)21))){
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",48)
					this->state = (int)1;
				}
				else{
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",49)
					if (((dealerVal > (int)21))){
						HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",49)
						this->state = (int)0;
					}
					else{
						HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",50)
						this->state = (int)2;
					}
				}
			}
		}
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",52)
		this->finalizeState();
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(BlackjackGame_obj,check,(void))

Void BlackjackGame_obj::stand( ){
{
		HX_SOURCE_PUSH("BlackjackGame_obj::stand")
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",57)
		if (((this->state != (int)2))){
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",57)
			return null();
		}
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",59)
		int minVal = this->permutations(HX_CSTRING("player"));
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",60)
		int dealerVal = this->permutations(HX_CSTRING("dealer"));
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",62)
		if (((minVal == (int)21))){
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",62)
			this->state = (int)0;
		}
		else{
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",63)
			if (((dealerVal == (int)21))){
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",63)
				this->state = (int)1;
			}
			else{
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",64)
				if (((minVal > (int)21))){
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",64)
					this->state = (int)1;
				}
				else{
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",65)
					if (((minVal > dealerVal))){
						HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",65)
						this->state = (int)0;
					}
					else{
						HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",66)
						if (((dealerVal > (int)21))){
							HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",66)
							this->state = (int)0;
						}
						else{
							HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",67)
							this->state = (int)1;
						}
					}
				}
			}
		}
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",69)
		this->finalizeState();
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(BlackjackGame_obj,stand,(void))

Void BlackjackGame_obj::finalizeState( ){
{
		HX_SOURCE_PUSH("BlackjackGame_obj::finalizeState")
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",73)
		if (((this->state != (int)2))){

			HX_BEGIN_LOCAL_FUNC_S0(hx::LocalFunc,_Function_2_1)
			Void run(::com::ludamix::triad::cards::Card52 card){
{
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",76)
					card->hidden = false;
				}
				return null();
			}
			HX_END_LOCAL_FUNC1((void))

			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",76)
			this->withCardsIn(HX_CSTRING("dealer"), Dynamic(new _Function_2_1()));

			HX_BEGIN_LOCAL_FUNC_S0(hx::LocalFunc,_Function_2_2)
			Void run(::com::ludamix::triad::cards::Card52 card){
{
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",80)
					card->hidden = false;
				}
				return null();
			}
			HX_END_LOCAL_FUNC1((void))

			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",80)
			this->withCardsIn(HX_CSTRING("deck"), Dynamic(new _Function_2_2()));
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(BlackjackGame_obj,finalizeState,(void))

Void BlackjackGame_obj::start( ){
{
		HX_SOURCE_PUSH("BlackjackGame_obj::start")
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",86)
		Array< ::com::ludamix::triad::cards::BlackjackGame > me = Array_obj< ::com::ludamix::triad::cards::BlackjackGame >::__new().Add(hx::ObjectPtr<OBJ_>(this));
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",88)
		this->state = (int)2;

		HX_BEGIN_LOCAL_FUNC_S1(hx::LocalFunc,_Function_1_1,Array< ::com::ludamix::triad::cards::BlackjackGame >,me)
		Void run(::com::ludamix::triad::cards::Card52 card){
{
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",90)
				me->__get((int)0)->moveCard(card,HX_CSTRING("deck"),null());
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",90)
				card->hidden = true;
			}
			return null();
		}
		HX_END_LOCAL_FUNC1((void))

		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",90)
		this->withAllCards( Dynamic(new _Function_1_1(me)));
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",91)
		this->hand(HX_CSTRING("deck"))->shuffle();
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",93)
		{
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",93)
			int _g = (int)0;
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",93)
			while(((_g < (int)2))){
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",93)
				int n = (_g)++;
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",95)
				::com::ludamix::triad::cards::Card c = this->drawAndMove(HX_CSTRING("deck"),HX_CSTRING("player"),null());
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",95)
				c->hidden = false;
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",96)
				::com::ludamix::triad::cards::Card c1 = this->drawAndMove(HX_CSTRING("deck"),HX_CSTRING("dealer"),null());
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",96)
				c1->hidden = true;
			}
		}
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",98)
		this->check();
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(BlackjackGame_obj,start,(void))

Void BlackjackGame_obj::hit( ){
{
		HX_SOURCE_PUSH("BlackjackGame_obj::hit")
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",103)
		if (((this->state != (int)2))){
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",103)
			return null();
		}
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",104)
		::com::ludamix::triad::cards::Card c = this->drawAndMove(HX_CSTRING("deck"),HX_CSTRING("player"),null());
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",105)
		c->hidden = false;
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",106)
		this->check();
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(BlackjackGame_obj,hit,(void))

Dynamic BlackjackGame_obj::play( ::String command){
	HX_SOURCE_PUSH("BlackjackGame_obj::play")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",110)
	::String _switch_1 = (command);
	if (  ( _switch_1==HX_CSTRING("start"))){
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",115)
		return Dynamic( Array_obj<Dynamic>::__new().Add(this->hand(HX_CSTRING("player"))).Add(this->hand(HX_CSTRING("dealer"))).Add(this->start()));
	}
	else if (  ( _switch_1==HX_CSTRING("hit"))){
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",117)
		return Dynamic( Array_obj<Dynamic>::__new().Add(this->hand(HX_CSTRING("player"))).Add(this->hand(HX_CSTRING("dealer"))).Add(this->hit()));
	}
	else if (  ( _switch_1==HX_CSTRING("stand"))){
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",119)
		return Dynamic( Array_obj<Dynamic>::__new().Add(this->hand(HX_CSTRING("player"))).Add(this->hand(HX_CSTRING("dealer"))).Add(this->stand()));
	}
	else  {
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",121)
		return Array_obj< ::String >::__new().Add(HX_CSTRING("start,hit,stand"));
	}
;
;
}


HX_DEFINE_DYNAMIC_FUNC1(BlackjackGame_obj,play,return )

::String BlackjackGame_obj::stateText( ){
	HX_SOURCE_PUSH("BlackjackGame_obj::stateText")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",128)
	switch( (int)(this->state)){
		case (int)2: {
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",131)
			return HX_CSTRING("Try to get 21");
		}
		;break;
		case (int)0: {
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",132)
			return HX_CSTRING("You Win");
		}
		;break;
		case (int)1: {
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",133)
			return HX_CSTRING("You Lose");
		}
		;break;
		default: {
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlackjackGame.hx",134)
			return HX_CSTRING("");
		}
	}
}


HX_DEFINE_DYNAMIC_FUNC0(BlackjackGame_obj,stateText,return )

int BlackjackGame_obj::WIN;

int BlackjackGame_obj::LOSE;

int BlackjackGame_obj::PLAY;


BlackjackGame_obj::BlackjackGame_obj()
{
}

void BlackjackGame_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(BlackjackGame);
	HX_MARK_MEMBER_NAME(state,"state");
	super::__Mark(HX_MARK_ARG);
	HX_MARK_END_CLASS();
}

Dynamic BlackjackGame_obj::__Field(const ::String &inName)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"WIN") ) { return WIN; }
		if (HX_FIELD_EQ(inName,"hit") ) { return hit_dyn(); }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"LOSE") ) { return LOSE; }
		if (HX_FIELD_EQ(inName,"PLAY") ) { return PLAY; }
		if (HX_FIELD_EQ(inName,"play") ) { return play_dyn(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"state") ) { return state; }
		if (HX_FIELD_EQ(inName,"check") ) { return check_dyn(); }
		if (HX_FIELD_EQ(inName,"stand") ) { return stand_dyn(); }
		if (HX_FIELD_EQ(inName,"start") ) { return start_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"stateText") ) { return stateText_dyn(); }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"permutations") ) { return permutations_dyn(); }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"finalizeState") ) { return finalizeState_dyn(); }
	}
	return super::__Field(inName);
}

Dynamic BlackjackGame_obj::__SetField(const ::String &inName,const Dynamic &inValue)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"WIN") ) { WIN=inValue.Cast< int >(); return inValue; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"LOSE") ) { LOSE=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"PLAY") ) { PLAY=inValue.Cast< int >(); return inValue; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"state") ) { state=inValue.Cast< int >(); return inValue; }
	}
	return super::__SetField(inName,inValue);
}

void BlackjackGame_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("state"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("WIN"),
	HX_CSTRING("LOSE"),
	HX_CSTRING("PLAY"),
	String(null()) };

static ::String sMemberFields[] = {
	HX_CSTRING("state"),
	HX_CSTRING("permutations"),
	HX_CSTRING("check"),
	HX_CSTRING("stand"),
	HX_CSTRING("finalizeState"),
	HX_CSTRING("start"),
	HX_CSTRING("hit"),
	HX_CSTRING("play"),
	HX_CSTRING("stateText"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(BlackjackGame_obj::WIN,"WIN");
	HX_MARK_MEMBER_NAME(BlackjackGame_obj::LOSE,"LOSE");
	HX_MARK_MEMBER_NAME(BlackjackGame_obj::PLAY,"PLAY");
};

Class BlackjackGame_obj::__mClass;

void BlackjackGame_obj::__register()
{
	Static(__mClass) = hx::RegisterClass(HX_CSTRING("com.ludamix.triad.cards.BlackjackGame"), hx::TCanCast< BlackjackGame_obj> ,sStaticFields,sMemberFields,
	&__CreateEmpty, &__Create,
	&super::__SGetClass(), 0, sMarkStatics);
}

void BlackjackGame_obj::__boot()
{
	hx::Static(WIN) = (int)0;
	hx::Static(LOSE) = (int)1;
	hx::Static(PLAY) = (int)2;
}

} // end namespace com
} // end namespace ludamix
} // end namespace triad
} // end namespace cards
