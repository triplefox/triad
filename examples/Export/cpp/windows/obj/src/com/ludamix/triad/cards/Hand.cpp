#include <hxcpp.h>

#ifndef INCLUDED_hxMath
#include <hxMath.h>
#endif
#ifndef INCLUDED_Std
#include <Std.h>
#endif
#ifndef INCLUDED_com_ludamix_triad_cards_Card
#include <com/ludamix/triad/cards/Card.h>
#endif
#ifndef INCLUDED_com_ludamix_triad_cards_Hand
#include <com/ludamix/triad/cards/Hand.h>
#endif
namespace com{
namespace ludamix{
namespace triad{
namespace cards{

Void Hand_obj::__construct(::String name)
{
{
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Hand.hx",11)
	this->name = name;
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Hand.hx",12)
	this->cards = Array_obj< ::com::ludamix::triad::cards::Card >::__new();
}
;
	return null();
}

Hand_obj::~Hand_obj() { }

Dynamic Hand_obj::__CreateEmpty() { return  new Hand_obj; }
hx::ObjectPtr< Hand_obj > Hand_obj::__new(::String name)
{  hx::ObjectPtr< Hand_obj > result = new Hand_obj();
	result->__construct(name);
	return result;}

Dynamic Hand_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Hand_obj > result = new Hand_obj();
	result->__construct(inArgs[0]);
	return result;}

Void Hand_obj::insert( ::com::ludamix::triad::cards::Card card,int idx){
{
		HX_SOURCE_PUSH("Hand_obj::insert")
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Hand.hx",17)
		this->cards->insert(idx,card);
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Hand.hx",18)
		card->owner = this->name;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Hand_obj,insert,(void))

Void Hand_obj::push( ::com::ludamix::triad::cards::Card card){
{
		HX_SOURCE_PUSH("Hand_obj::push")
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Hand.hx",23)
		this->cards->push(card);
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Hand.hx",24)
		card->owner = this->name;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Hand_obj,push,(void))

Void Hand_obj::pushBottom( ::com::ludamix::triad::cards::Card card){
{
		HX_SOURCE_PUSH("Hand_obj::pushBottom")
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Hand.hx",29)
		this->cards->insert((int)0,card);
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Hand.hx",30)
		card->owner = this->name;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Hand_obj,pushBottom,(void))

::com::ludamix::triad::cards::Card Hand_obj::draw( ){
	HX_SOURCE_PUSH("Hand_obj::draw")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Hand.hx",35)
	::com::ludamix::triad::cards::Card card = this->cards->pop();
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Hand.hx",36)
	card->owner = null();
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Hand.hx",37)
	return card;
}


HX_DEFINE_DYNAMIC_FUNC0(Hand_obj,draw,return )

::com::ludamix::triad::cards::Card Hand_obj::drawBottom( ){
	HX_SOURCE_PUSH("Hand_obj::drawBottom")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Hand.hx",42)
	::com::ludamix::triad::cards::Card card = this->cards->pop();
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Hand.hx",43)
	card->owner = null();
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Hand.hx",44)
	return card;
}


HX_DEFINE_DYNAMIC_FUNC0(Hand_obj,drawBottom,return )

Void Hand_obj::swap( ::com::ludamix::triad::cards::Card a,::com::ludamix::triad::cards::Card b){
{
		HX_SOURCE_PUSH("Hand_obj::swap")
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Hand.hx",49)
		Array< ::com::ludamix::triad::cards::Card > nd = Array_obj< ::com::ludamix::triad::cards::Card >::__new();
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Hand.hx",51)
		{
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Hand.hx",51)
			int _g = (int)0;
			Array< ::com::ludamix::triad::cards::Card > _g1 = this->cards;
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Hand.hx",51)
			while(((_g < _g1->length))){
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Hand.hx",51)
				::com::ludamix::triad::cards::Card n = _g1->__get(_g);
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Hand.hx",51)
				++(_g);
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Hand.hx",53)
				if (((n == a))){
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Hand.hx",54)
					nd->push(b);
				}
				else{
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Hand.hx",57)
					if (((n == b))){
						HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Hand.hx",58)
						nd->push(a);
					}
					else{
						HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Hand.hx",61)
						nd->push(n);
					}
				}
			}
		}
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Hand.hx",63)
		this->cards = nd;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Hand_obj,swap,(void))

Void Hand_obj::swapIdx( int a,int b){
{
		HX_SOURCE_PUSH("Hand_obj::swapIdx")
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Hand.hx",67)
		this->swap(this->cards->__get(a),this->cards->__get(b));
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Hand_obj,swapIdx,(void))

Void Hand_obj::shuffle( ){
{
		HX_SOURCE_PUSH("Hand_obj::shuffle")
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Hand.hx",73)
		Array< ::com::ludamix::triad::cards::Card > nd = Array_obj< ::com::ludamix::triad::cards::Card >::__new();
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Hand.hx",74)
		while(((this->cards->length > (int)0))){
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Hand.hx",76)
			int z = ::Std_obj::_int((::Math_obj::random() * this->cards->length));
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Hand.hx",77)
			::com::ludamix::triad::cards::Card card = this->removeIdx(z);
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Hand.hx",78)
			nd->push(card);
		}
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Hand.hx",80)
		this->cards = nd;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Hand_obj,shuffle,(void))

::com::ludamix::triad::cards::Card Hand_obj::remove( ::com::ludamix::triad::cards::Card card){
	HX_SOURCE_PUSH("Hand_obj::remove")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Hand.hx",85)
	card->owner = null();
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Hand.hx",86)
	this->cards->remove(card);
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Hand.hx",87)
	return card;
}


HX_DEFINE_DYNAMIC_FUNC1(Hand_obj,remove,return )

::com::ludamix::triad::cards::Card Hand_obj::removeIdx( int idx){
	HX_SOURCE_PUSH("Hand_obj::removeIdx")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Hand.hx",92)
	::com::ludamix::triad::cards::Card card = this->cards->__get(idx);
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Hand.hx",93)
	card->owner = null();
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Hand.hx",94)
	this->cards->remove(card);
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Hand.hx",95)
	return card;
}


HX_DEFINE_DYNAMIC_FUNC1(Hand_obj,removeIdx,return )

::String Hand_obj::toString( ){
	HX_SOURCE_PUSH("Hand_obj::toString")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Hand.hx",100)
	Array< ::String > ar = Array_obj< ::String >::__new();
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Hand.hx",101)
	{
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Hand.hx",101)
		int _g = (int)0;
		Array< ::com::ludamix::triad::cards::Card > _g1 = this->cards;
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Hand.hx",101)
		while(((_g < _g1->length))){
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Hand.hx",101)
			::com::ludamix::triad::cards::Card c = _g1->__get(_g);
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Hand.hx",101)
			++(_g);
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Hand.hx",102)
			ar->push(::Std_obj::string(c));
		}
	}
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Hand.hx",103)
	return ::Std_obj::string(ar);
}


HX_DEFINE_DYNAMIC_FUNC0(Hand_obj,toString,return )

::com::ludamix::triad::cards::Card Hand_obj::top( ){
	HX_SOURCE_PUSH("Hand_obj::top")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Hand.hx",107)
	return this->cards->__get((this->cards->length - (int)1));
}


HX_DEFINE_DYNAMIC_FUNC0(Hand_obj,top,return )

::com::ludamix::triad::cards::Card Hand_obj::bottom( ){
	HX_SOURCE_PUSH("Hand_obj::bottom")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/Hand.hx",112)
	return this->cards->__get((int)0);
}


HX_DEFINE_DYNAMIC_FUNC0(Hand_obj,bottom,return )


Hand_obj::Hand_obj()
{
}

void Hand_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Hand);
	HX_MARK_MEMBER_NAME(cards,"cards");
	HX_MARK_MEMBER_NAME(name,"name");
	HX_MARK_END_CLASS();
}

Dynamic Hand_obj::__Field(const ::String &inName)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"top") ) { return top_dyn(); }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"name") ) { return name; }
		if (HX_FIELD_EQ(inName,"push") ) { return push_dyn(); }
		if (HX_FIELD_EQ(inName,"draw") ) { return draw_dyn(); }
		if (HX_FIELD_EQ(inName,"swap") ) { return swap_dyn(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"cards") ) { return cards; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"insert") ) { return insert_dyn(); }
		if (HX_FIELD_EQ(inName,"remove") ) { return remove_dyn(); }
		if (HX_FIELD_EQ(inName,"bottom") ) { return bottom_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"swapIdx") ) { return swapIdx_dyn(); }
		if (HX_FIELD_EQ(inName,"shuffle") ) { return shuffle_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"toString") ) { return toString_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"removeIdx") ) { return removeIdx_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"pushBottom") ) { return pushBottom_dyn(); }
		if (HX_FIELD_EQ(inName,"drawBottom") ) { return drawBottom_dyn(); }
	}
	return super::__Field(inName);
}

Dynamic Hand_obj::__SetField(const ::String &inName,const Dynamic &inValue)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"name") ) { name=inValue.Cast< ::String >(); return inValue; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"cards") ) { cards=inValue.Cast< Array< ::com::ludamix::triad::cards::Card > >(); return inValue; }
	}
	return super::__SetField(inName,inValue);
}

void Hand_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("cards"));
	outFields->push(HX_CSTRING("name"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

static ::String sMemberFields[] = {
	HX_CSTRING("cards"),
	HX_CSTRING("name"),
	HX_CSTRING("insert"),
	HX_CSTRING("push"),
	HX_CSTRING("pushBottom"),
	HX_CSTRING("draw"),
	HX_CSTRING("drawBottom"),
	HX_CSTRING("swap"),
	HX_CSTRING("swapIdx"),
	HX_CSTRING("shuffle"),
	HX_CSTRING("remove"),
	HX_CSTRING("removeIdx"),
	HX_CSTRING("toString"),
	HX_CSTRING("top"),
	HX_CSTRING("bottom"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
};

Class Hand_obj::__mClass;

void Hand_obj::__register()
{
	Static(__mClass) = hx::RegisterClass(HX_CSTRING("com.ludamix.triad.cards.Hand"), hx::TCanCast< Hand_obj> ,sStaticFields,sMemberFields,
	&__CreateEmpty, &__Create,
	&super::__SGetClass(), 0, sMarkStatics);
}

void Hand_obj::__boot()
{
}

} // end namespace com
} // end namespace ludamix
} // end namespace triad
} // end namespace cards
