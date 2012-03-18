#include <hxcpp.h>

#ifndef INCLUDED_Hash
#include <Hash.h>
#endif
#ifndef INCLUDED_hxMath
#include <hxMath.h>
#endif
#ifndef INCLUDED_Std
#include <Std.h>
#endif
#ifndef INCLUDED_com_ludamix_triad_blitter_Blitter
#include <com/ludamix/triad/blitter/Blitter.h>
#endif
#ifndef INCLUDED_com_ludamix_triad_cards_BlittableDeck52
#include <com/ludamix/triad/cards/BlittableDeck52.h>
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
#ifndef INCLUDED_com_ludamix_triad_geom_AABB
#include <com/ludamix/triad/geom/AABB.h>
#endif
#ifndef INCLUDED_com_ludamix_triad_geom_SubINode
#include <com/ludamix/triad/geom/SubINode.h>
#endif
#ifndef INCLUDED_com_ludamix_triad_geom_SubIPoint
#include <com/ludamix/triad/geom/SubIPoint.h>
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
#ifndef INCLUDED_nme_events_EventDispatcher
#include <nme/events/EventDispatcher.h>
#endif
#ifndef INCLUDED_nme_events_IEventDispatcher
#include <nme/events/IEventDispatcher.h>
#endif
#ifndef INCLUDED_nme_geom_Point
#include <nme/geom/Point.h>
#endif
namespace com{
namespace ludamix{
namespace triad{
namespace cards{

Void BlittableDeck52_obj::__construct(Dynamic hands,::com::ludamix::triad::cards::Deck deck,::com::ludamix::triad::geom::SubINode parent)
{
{
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",19)
	super::__construct((int)0,(int)0,parent);
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",21)
	this->hands = hands;
}
;
	return null();
}

BlittableDeck52_obj::~BlittableDeck52_obj() { }

Dynamic BlittableDeck52_obj::__CreateEmpty() { return  new BlittableDeck52_obj; }
hx::ObjectPtr< BlittableDeck52_obj > BlittableDeck52_obj::__new(Dynamic hands,::com::ludamix::triad::cards::Deck deck,::com::ludamix::triad::geom::SubINode parent)
{  hx::ObjectPtr< BlittableDeck52_obj > result = new BlittableDeck52_obj();
	result->__construct(hands,deck,parent);
	return result;}

Dynamic BlittableDeck52_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< BlittableDeck52_obj > result = new BlittableDeck52_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2]);
	return result;}

Void BlittableDeck52_obj::renderDeck( ::com::ludamix::triad::cards::Deck deck,::com::ludamix::triad::blitter::Blitter blitter,::com::ludamix::triad::geom::AABB cardRect){
{
		HX_SOURCE_PUSH("BlittableDeck52_obj::renderDeck")
		struct _Function_1_1{
			inline static ::com::ludamix::triad::geom::AABB Block( ::com::ludamix::triad::cards::BlittableDeck52_obj *__this,::com::ludamix::triad::geom::AABB &cardRect){
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",80)
				::com::ludamix::triad::geom::SubIPoint tmp = ::com::ludamix::triad::geom::SubIPoint_obj::__new(__this->x,__this->y);
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",80)
				::com::ludamix::triad::geom::AABB result = ::com::ludamix::triad::geom::AABB_obj::__new((int)0,(int)0,(int)0,(int)0);
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",80)
				{
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",80)
					{
						HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",80)
						::com::ludamix::triad::geom::SubINode cur = __this;
						HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",80)
						int x = cur->x;
						HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",80)
						int y = cur->y;
						HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",80)
						while(((cur->parent != null()))){
							HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",80)
							cur = cur->parent;
							HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",80)
							hx::AddEq(x,cur->x);
							HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",80)
							hx::AddEq(y,cur->y);
						}
						HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",80)
						tmp->x = x;
						HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",80)
						tmp->y = y;
					}
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",80)
					result->x = (tmp->x + cardRect->x);
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",80)
					result->y = (tmp->y + cardRect->y);
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",80)
					result->w = cardRect->w;
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",80)
					result->h = cardRect->h;
				}
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",80)
				return result;
			}
		};
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",80)
		::com::ludamix::triad::geom::AABB r = _Function_1_1::Block(this,cardRect);
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",81)
		{
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",81)
			int _g = (int)0;
			Dynamic _g1 = this->hands;
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",81)
			while(((_g < _g1->__Field(HX_CSTRING("length"))))){
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",81)
				Dynamic hdef = _g1->__GetItem(_g);
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",81)
				++(_g);
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",83)
				::com::ludamix::triad::cards::Hand hand = deck->hand(hdef->__Field(HX_CSTRING("hand")));
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",84)
				{
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",84)
					int _g3 = (int)0;
					int _g2 = hand->cards->length;
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",84)
					while(((_g3 < _g2))){
						HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",84)
						int n = (_g3)++;
						struct _Function_5_1{
							inline static ::com::ludamix::triad::geom::SubIPoint Block( Dynamic &hdef,int &n,::com::ludamix::triad::geom::AABB &cardRect,::com::ludamix::triad::cards::Hand &hand){
								HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",86)
								::nme::geom::Point fp = hdef->__Field(HX_CSTRING("func"))(n,hdef->__Field(HX_CSTRING("x")),hdef->__Field(HX_CSTRING("y")),hdef->__Field(HX_CSTRING("spacing")),hand->cards->length,hdef->__Field(HX_CSTRING("max")),cardRect);
								HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",86)
								return ::com::ludamix::triad::geom::SubIPoint_obj::__new(::Std_obj::_int((fp->x * (int)256)),::Std_obj::_int((fp->y * (int)256)));
							}
						};
						HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",86)
						::com::ludamix::triad::geom::SubIPoint spt = _Function_5_1::Block(hdef,n,cardRect,hand);
						HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",88)
						hx::AddEq(spt->x,(r->x + ::Std_obj::_int((double(r->w) / double((int)2)))));
						HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",89)
						hx::AddEq(spt->y,(r->y + ::Std_obj::_int((double(r->h) / double((int)2)))));
						HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",90)
						{
							HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",90)
							::com::ludamix::triad::cards::Card52 card = hx::TCast< com::ludamix::triad::cards::Card52 >::cast(hand->cards->__get(n));
							HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",90)
							::String name = HX_CSTRING("card_back");
							HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",90)
							if ((!(card->hidden))){
								HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",90)
								name = (HX_CSTRING("card_") + card->idx);
							}
							struct _Function_6_1{
								inline static Dynamic Block( ::com::ludamix::triad::blitter::Blitter &blitter,::com::ludamix::triad::geom::SubIPoint &spt,::String &name){
									hx::Anon __result = hx::Anon_obj::Create();
									__result->Add(HX_CSTRING("bd") , blitter->spriteCache->get(name),false);
									__result->Add(HX_CSTRING("x") , (int(spt->x) >> int((int)8)),false);
									__result->Add(HX_CSTRING("y") , (int(spt->y) >> int((int)8)),false);
									return __result;
								}
							};
							HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",90)
							blitter->spriteQueue->__GetItem(::Std_obj::_int(::Math_obj::min((blitter->spriteQueue->__Field(HX_CSTRING("length")) - (int)1),n)))->__Field(HX_CSTRING("push"))(_Function_6_1::Block(blitter,spt,name));
						}
					}
				}
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC3(BlittableDeck52_obj,renderDeck,(void))

Array< ::com::ludamix::triad::cards::Card > BlittableDeck52_obj::testCards( ::com::ludamix::triad::cards::Deck deck,::com::ludamix::triad::geom::AABB cardRect,::com::ludamix::triad::geom::SubIPoint mp){
	HX_SOURCE_PUSH("BlittableDeck52_obj::testCards")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",98)
	Array< ::com::ludamix::triad::cards::Card > results = Array_obj< ::com::ludamix::triad::cards::Card >::__new();
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",99)
	{
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",99)
		int _g = (int)0;
		Dynamic _g1 = this->hands;
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",99)
		while(((_g < _g1->__Field(HX_CSTRING("length"))))){
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",99)
			Dynamic hdef = _g1->__GetItem(_g);
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",99)
			++(_g);
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",101)
			::com::ludamix::triad::cards::Hand hand = deck->hand(hdef->__Field(HX_CSTRING("hand")));
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",102)
			{
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",102)
				int _g3 = (int)0;
				int _g2 = hand->cards->length;
				HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",102)
				while(((_g3 < _g2))){
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",102)
					int n = (_g3)++;
					struct _Function_5_1{
						inline static ::com::ludamix::triad::geom::SubIPoint Block( Dynamic &hdef,int &n,::com::ludamix::triad::geom::AABB &cardRect,::com::ludamix::triad::cards::Hand &hand){
							HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",104)
							::nme::geom::Point fp = hdef->__Field(HX_CSTRING("func"))(n,hdef->__Field(HX_CSTRING("x")),hdef->__Field(HX_CSTRING("y")),hdef->__Field(HX_CSTRING("spacing")),hand->cards->length,hdef->__Field(HX_CSTRING("max")),cardRect);
							HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",104)
							return ::com::ludamix::triad::geom::SubIPoint_obj::__new(::Std_obj::_int((fp->x * (int)256)),::Std_obj::_int((fp->y * (int)256)));
						}
					};
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",104)
					::com::ludamix::triad::geom::SubIPoint spt = _Function_5_1::Block(hdef,n,cardRect,hand);
					struct _Function_5_2{
						inline static ::com::ludamix::triad::geom::AABB Block( ::com::ludamix::triad::cards::BlittableDeck52_obj *__this,::com::ludamix::triad::geom::AABB &cardRect){
							HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",106)
							::com::ludamix::triad::geom::SubIPoint tmp = ::com::ludamix::triad::geom::SubIPoint_obj::__new(__this->x,__this->y);
							HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",106)
							::com::ludamix::triad::geom::AABB result = ::com::ludamix::triad::geom::AABB_obj::__new((int)0,(int)0,(int)0,(int)0);
							HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",106)
							{
								HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",106)
								{
									HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",106)
									::com::ludamix::triad::geom::SubINode cur = __this;
									HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",106)
									int x = cur->x;
									HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",106)
									int y = cur->y;
									HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",106)
									while(((cur->parent != null()))){
										HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",106)
										cur = cur->parent;
										HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",106)
										hx::AddEq(x,cur->x);
										HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",106)
										hx::AddEq(y,cur->y);
									}
									HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",106)
									tmp->x = x;
									HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",106)
									tmp->y = y;
								}
								HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",106)
								result->x = (tmp->x + cardRect->x);
								HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",106)
								result->y = (tmp->y + cardRect->y);
								HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",106)
								result->w = cardRect->w;
								HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",106)
								result->h = cardRect->h;
							}
							HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",106)
							return result;
						}
					};
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",106)
					::com::ludamix::triad::geom::AABB r = _Function_5_2::Block(this,cardRect);
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",107)
					r->x = (spt->x + ((r->x + ::Std_obj::_int((double(r->w) / double((int)2))))));
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",108)
					r->y = (spt->y + ((r->y + ::Std_obj::_int((double(r->h) / double((int)2))))));
					HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",109)
					if (((bool((bool((bool((mp->x >= r->x)) && bool((mp->x <= (r->x + r->w))))) && bool((mp->y >= r->y)))) && bool((mp->y <= (r->y + r->h)))))){
						HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",110)
						results->push(hand->cards->__get(n));
					}
				}
			}
		}
	}
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",113)
	return results;
}


HX_DEFINE_DYNAMIC_FUNC3(BlittableDeck52_obj,testCards,return )

Void BlittableDeck52_obj::renderCard( ::com::ludamix::triad::cards::Card52 card,::com::ludamix::triad::geom::SubIPoint spt,::com::ludamix::triad::blitter::Blitter blitter,int z){
{
		HX_SOURCE_PUSH("BlittableDeck52_obj::renderCard")
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",118)
		::String name = HX_CSTRING("card_back");
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",119)
		if ((!(card->hidden))){
			HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",120)
			name = (HX_CSTRING("card_") + card->idx);
		}
		struct _Function_1_1{
			inline static Dynamic Block( ::com::ludamix::triad::blitter::Blitter &blitter,::com::ludamix::triad::geom::SubIPoint &spt,::String &name){
				hx::Anon __result = hx::Anon_obj::Create();
				__result->Add(HX_CSTRING("bd") , blitter->spriteCache->get(name),false);
				__result->Add(HX_CSTRING("x") , (int(spt->x) >> int((int)8)),false);
				__result->Add(HX_CSTRING("y") , (int(spt->y) >> int((int)8)),false);
				return __result;
			}
		};
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",124)
		blitter->spriteQueue->__GetItem(z)->__Field(HX_CSTRING("push"))(_Function_1_1::Block(blitter,spt,name));
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC4(BlittableDeck52_obj,renderCard,(void))

double BlittableDeck52_obj::space( double spacing,double elements,double max){
	HX_SOURCE_PUSH("BlittableDeck52_obj::space")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",26)
	if ((((elements * spacing) > max))){
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",28)
		return (double(max) / double(elements));
	}
	else{
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",30)
		return spacing;
	}
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(BlittableDeck52_obj,space,return )

::nme::geom::Point BlittableDeck52_obj::render_pile( int idx,double x,double y,double spacing,int items,int max,::com::ludamix::triad::geom::AABB cardRect){
	HX_SOURCE_PUSH("BlittableDeck52_obj::render_pile")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",34)
	if (((idx < (int)8))){
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",35)
		return ::nme::geom::Point_obj::__new((x - (::Std_obj::_int((double(idx) / double((int)2))) * (int)2)),(y - (::Std_obj::_int((double(idx) / double((int)2))) * (int)2)));
	}
	else{
		HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",35)
		return ::nme::geom::Point_obj::__new((x - (int)8),(y - (int)8));
	}
}


STATIC_HX_DEFINE_DYNAMIC_FUNC7(BlittableDeck52_obj,render_pile,return )

::nme::geom::Point BlittableDeck52_obj::render_rowRight( int idx,double x,double y,double spacing,int items,int max,::com::ludamix::triad::geom::AABB cardRect){
	HX_SOURCE_PUSH("BlittableDeck52_obj::render_rowRight")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",40)
	double sp = ::com::ludamix::triad::cards::BlittableDeck52_obj::space((spacing + (double(cardRect->w) / double((int)256))),items,max);
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",41)
	return ::nme::geom::Point_obj::__new((x + (idx * sp)),y);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC7(BlittableDeck52_obj,render_rowRight,return )

::nme::geom::Point BlittableDeck52_obj::render_rowLeft( int idx,double x,double y,double spacing,int items,int max,::com::ludamix::triad::geom::AABB cardRect){
	HX_SOURCE_PUSH("BlittableDeck52_obj::render_rowLeft")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",46)
	double sp = ::com::ludamix::triad::cards::BlittableDeck52_obj::space((spacing + (double(cardRect->w) / double((int)256))),items,max);
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",47)
	return ::nme::geom::Point_obj::__new((x - (idx * sp)),y);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC7(BlittableDeck52_obj,render_rowLeft,return )

::nme::geom::Point BlittableDeck52_obj::render_rowCenter( int idx,double x,double y,double spacing,int items,int max,::com::ludamix::triad::geom::AABB cardRect){
	HX_SOURCE_PUSH("BlittableDeck52_obj::render_rowCenter")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",52)
	double sp = ::com::ludamix::triad::cards::BlittableDeck52_obj::space((spacing + (double(cardRect->w) / double((int)256))),items,max);
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",53)
	double basePos = (sp * idx);
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",54)
	double centerLine = (double((items * sp)) / double((int)2));
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",55)
	return ::nme::geom::Point_obj::__new(((x + basePos) - centerLine),y);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC7(BlittableDeck52_obj,render_rowCenter,return )

::nme::geom::Point BlittableDeck52_obj::render_colBottom( int idx,double x,double y,double spacing,int items,int max,::com::ludamix::triad::geom::AABB cardRect){
	HX_SOURCE_PUSH("BlittableDeck52_obj::render_colBottom")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",60)
	double sp = ::com::ludamix::triad::cards::BlittableDeck52_obj::space((spacing + (double(cardRect->h) / double((int)256))),items,max);
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",61)
	return ::nme::geom::Point_obj::__new(x,((-(idx) * sp) + y));
}


STATIC_HX_DEFINE_DYNAMIC_FUNC7(BlittableDeck52_obj,render_colBottom,return )

::nme::geom::Point BlittableDeck52_obj::render_colTop( int idx,double x,double y,double spacing,int items,int max,::com::ludamix::triad::geom::AABB cardRect){
	HX_SOURCE_PUSH("BlittableDeck52_obj::render_colTop")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",66)
	double sp = ::com::ludamix::triad::cards::BlittableDeck52_obj::space((spacing + (double(cardRect->h) / double((int)256))),items,max);
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",67)
	return ::nme::geom::Point_obj::__new(x,(((idx * sp) - (double(max) / double((int)2))) + y));
}


STATIC_HX_DEFINE_DYNAMIC_FUNC7(BlittableDeck52_obj,render_colTop,return )

::nme::geom::Point BlittableDeck52_obj::render_colCenter( int idx,double x,double y,double spacing,int items,int max,::com::ludamix::triad::geom::AABB cardRect){
	HX_SOURCE_PUSH("BlittableDeck52_obj::render_colCenter")
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",72)
	double sp = ::com::ludamix::triad::cards::BlittableDeck52_obj::space((spacing + (double(cardRect->h) / double((int)256))),items,max);
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",73)
	double basePos = (sp * idx);
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",74)
	double centerLine = (double((items * sp)) / double((int)2));
	HX_SOURCE_POS("/Dropbox/triad_dev/com/ludamix/triad/cards/BlittableDeck52.hx",75)
	return ::nme::geom::Point_obj::__new(x,((y + basePos) - centerLine));
}


STATIC_HX_DEFINE_DYNAMIC_FUNC7(BlittableDeck52_obj,render_colCenter,return )


BlittableDeck52_obj::BlittableDeck52_obj()
{
}

void BlittableDeck52_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(BlittableDeck52);
	HX_MARK_MEMBER_NAME(hands,"hands");
	super::__Mark(HX_MARK_ARG);
	HX_MARK_END_CLASS();
}

Dynamic BlittableDeck52_obj::__Field(const ::String &inName)
{
	switch(inName.length) {
	case 5:
		if (HX_FIELD_EQ(inName,"space") ) { return space_dyn(); }
		if (HX_FIELD_EQ(inName,"hands") ) { return hands; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"testCards") ) { return testCards_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"renderDeck") ) { return renderDeck_dyn(); }
		if (HX_FIELD_EQ(inName,"renderCard") ) { return renderCard_dyn(); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"render_pile") ) { return render_pile_dyn(); }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"render_colTop") ) { return render_colTop_dyn(); }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"render_rowLeft") ) { return render_rowLeft_dyn(); }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"render_rowRight") ) { return render_rowRight_dyn(); }
		break;
	case 16:
		if (HX_FIELD_EQ(inName,"render_rowCenter") ) { return render_rowCenter_dyn(); }
		if (HX_FIELD_EQ(inName,"render_colBottom") ) { return render_colBottom_dyn(); }
		if (HX_FIELD_EQ(inName,"render_colCenter") ) { return render_colCenter_dyn(); }
	}
	return super::__Field(inName);
}

Dynamic BlittableDeck52_obj::__SetField(const ::String &inName,const Dynamic &inValue)
{
	switch(inName.length) {
	case 5:
		if (HX_FIELD_EQ(inName,"hands") ) { hands=inValue.Cast< Dynamic >(); return inValue; }
	}
	return super::__SetField(inName,inValue);
}

void BlittableDeck52_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("hands"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("space"),
	HX_CSTRING("render_pile"),
	HX_CSTRING("render_rowRight"),
	HX_CSTRING("render_rowLeft"),
	HX_CSTRING("render_rowCenter"),
	HX_CSTRING("render_colBottom"),
	HX_CSTRING("render_colTop"),
	HX_CSTRING("render_colCenter"),
	String(null()) };

static ::String sMemberFields[] = {
	HX_CSTRING("hands"),
	HX_CSTRING("renderDeck"),
	HX_CSTRING("testCards"),
	HX_CSTRING("renderCard"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
};

Class BlittableDeck52_obj::__mClass;

void BlittableDeck52_obj::__register()
{
	Static(__mClass) = hx::RegisterClass(HX_CSTRING("com.ludamix.triad.cards.BlittableDeck52"), hx::TCanCast< BlittableDeck52_obj> ,sStaticFields,sMemberFields,
	&__CreateEmpty, &__Create,
	&super::__SGetClass(), 0, sMarkStatics);
}

void BlittableDeck52_obj::__boot()
{
}

} // end namespace com
} // end namespace ludamix
} // end namespace triad
} // end namespace cards
