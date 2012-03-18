#include <hxcpp.h>

#ifndef INCLUDED_Blackjack
#include <Blackjack.h>
#endif
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
#ifndef INCLUDED_com_ludamix_triad_cards_BlackjackGame
#include <com/ludamix/triad/cards/BlackjackGame.h>
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
#ifndef INCLUDED_com_ludamix_triad_tools_EColor
#include <com/ludamix/triad/tools/EColor.h>
#endif
#ifndef INCLUDED_com_ludamix_triad_ui_BorderDef
#include <com/ludamix/triad/ui/BorderDef.h>
#endif
#ifndef INCLUDED_com_ludamix_triad_ui_HighlightingColorDef
#include <com/ludamix/triad/ui/HighlightingColorDef.h>
#endif
#ifndef INCLUDED_com_ludamix_triad_ui_RoundRectButton
#include <com/ludamix/triad/ui/RoundRectButton.h>
#endif
#ifndef INCLUDED_com_ludamix_triad_ui_RoundRectButtonDef
#include <com/ludamix/triad/ui/RoundRectButtonDef.h>
#endif
#ifndef INCLUDED_com_ludamix_triad_ui_StyledText
#include <com/ludamix/triad/ui/StyledText.h>
#endif
#ifndef INCLUDED_com_ludamix_triad_ui_StyledTextDef
#include <com/ludamix/triad/ui/StyledTextDef.h>
#endif
#ifndef INCLUDED_nme_Lib
#include <nme/Lib.h>
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
#ifndef INCLUDED_nme_display_DisplayObjectContainer
#include <nme/display/DisplayObjectContainer.h>
#endif
#ifndef INCLUDED_nme_display_IBitmapDrawable
#include <nme/display/IBitmapDrawable.h>
#endif
#ifndef INCLUDED_nme_display_InteractiveObject
#include <nme/display/InteractiveObject.h>
#endif
#ifndef INCLUDED_nme_display_MovieClip
#include <nme/display/MovieClip.h>
#endif
#ifndef INCLUDED_nme_display_Sprite
#include <nme/display/Sprite.h>
#endif
#ifndef INCLUDED_nme_display_Stage
#include <nme/display/Stage.h>
#endif
#ifndef INCLUDED_nme_events_Event
#include <nme/events/Event.h>
#endif
#ifndef INCLUDED_nme_events_EventDispatcher
#include <nme/events/EventDispatcher.h>
#endif
#ifndef INCLUDED_nme_events_IEventDispatcher
#include <nme/events/IEventDispatcher.h>
#endif
#ifndef INCLUDED_nme_events_MouseEvent
#include <nme/events/MouseEvent.h>
#endif
#ifndef INCLUDED_nme_geom_Point
#include <nme/geom/Point.h>
#endif
#ifndef INCLUDED_nme_installer_Assets
#include <nme/installer/Assets.h>
#endif
#ifndef INCLUDED_nme_text_TextField
#include <nme/text/TextField.h>
#endif

Void Blackjack_obj::__construct()
{
{
	HX_SOURCE_POS("Source/Blackjack.hx",37)
	this->blitter = ::com::ludamix::triad::blitter::Blitter_obj::__new((int)512,(int)512,false,(int)2263091,null());
	HX_SOURCE_POS("Source/Blackjack.hx",38)
	::nme::Lib_obj::nmeGetCurrent()->addChild(this->blitter);
	HX_SOURCE_POS("Source/Blackjack.hx",40)
	this->cardRect = ::com::ludamix::triad::geom::AABB_obj::__new((int(::Std_obj::_int((double((int)-74) / double((int)2)))) << int((int)8)),(int(::Std_obj::_int((double((int)-98) / double((int)2)))) << int((int)8)),(int)18944,(int)25088);
	HX_SOURCE_POS("Source/Blackjack.hx",42)
	this->blitter->storeTiles(::nme::installer::Assets_obj::getBitmapData(HX_CSTRING("assets/cards.png"),null()),(int)74,(int)98,::com::ludamix::triad::cards::Card52_obj::spriteNaming_dyn());
	HX_SOURCE_POS("Source/Blackjack.hx",44)
	this->game = ::com::ludamix::triad::cards::BlackjackGame_obj::__new();
	struct _Function_1_1{
		inline static Dynamic Block( ){
			hx::Anon __result = hx::Anon_obj::Create();
			__result->Add(HX_CSTRING("hand") , HX_CSTRING("deck"),false);
			__result->Add(HX_CSTRING("x") , 64.,false);
			__result->Add(HX_CSTRING("y") , (20. + (double((int)98) / double((int)2))),false);
			__result->Add(HX_CSTRING("spacing") , 0.,false);
			__result->Add(HX_CSTRING("max") , 0.,false);
			__result->Add(HX_CSTRING("func") , ::com::ludamix::triad::cards::BlittableDeck52_obj::render_pile_dyn(),false);
			return __result;
		}
	};
	struct _Function_1_2{
		inline static Dynamic Block( ){
			hx::Anon __result = hx::Anon_obj::Create();
			__result->Add(HX_CSTRING("hand") , HX_CSTRING("player"),false);
			__result->Add(HX_CSTRING("x") , 64.,false);
			__result->Add(HX_CSTRING("y") , (128. + (double((int)98) / double((int)2))),false);
			__result->Add(HX_CSTRING("spacing") , 8.,false);
			__result->Add(HX_CSTRING("max") , ((int)512 - 128.),false);
			__result->Add(HX_CSTRING("func") , ::com::ludamix::triad::cards::BlittableDeck52_obj::render_rowRight_dyn(),false);
			return __result;
		}
	};
	struct _Function_1_3{
		inline static Dynamic Block( ){
			hx::Anon __result = hx::Anon_obj::Create();
			__result->Add(HX_CSTRING("hand") , HX_CSTRING("dealer"),false);
			__result->Add(HX_CSTRING("x") , 64.,false);
			__result->Add(HX_CSTRING("y") , (228. + (double((int)98) / double((int)2))),false);
			__result->Add(HX_CSTRING("spacing") , 8.,false);
			__result->Add(HX_CSTRING("max") , ((int)512 - 128.),false);
			__result->Add(HX_CSTRING("func") , ::com::ludamix::triad::cards::BlittableDeck52_obj::render_rowRight_dyn(),false);
			return __result;
		}
	};
	HX_SOURCE_POS("Source/Blackjack.hx",45)
	this->deck = ::com::ludamix::triad::cards::BlittableDeck52_obj::__new(Dynamic( Array_obj<Dynamic>::__new().Add(_Function_1_1::Block()).Add(_Function_1_2::Block()).Add(_Function_1_3::Block())),this->game,null());
	HX_SOURCE_POS("Source/Blackjack.hx",51)
	::com::ludamix::triad::ui::RoundRectButtonDef style = ::com::ludamix::triad::ui::RoundRectButtonDef_obj::RRBorderSimple(::com::ludamix::triad::ui::BorderDef_obj::BDColorThickness(::com::ludamix::triad::tools::EColor_obj::White_dyn(),2.),::com::ludamix::triad::ui::HighlightingColorDef_obj::HCValShift(::com::ludamix::triad::tools::EColor_obj::SlateGray_dyn(),0.2),::com::ludamix::triad::ui::StyledTextDef_obj::STPlaceholder_dyn(),(int)16);
	HX_SOURCE_POS("Source/Blackjack.hx",55)
	this->hit = ::com::ludamix::triad::ui::RoundRectButton_obj::__new(::nme::geom::Point_obj::__new((int)156,(int)432),(int)100,(int)22,HX_CSTRING("Hit"),style);
	HX_SOURCE_POS("Source/Blackjack.hx",56)
	this->stand = ::com::ludamix::triad::ui::RoundRectButton_obj::__new(::nme::geom::Point_obj::__new((int)356,(int)432),(int)100,(int)22,HX_CSTRING("Stand"),style);
	HX_SOURCE_POS("Source/Blackjack.hx",57)
	this->restart = ::com::ludamix::triad::ui::RoundRectButton_obj::__new(::nme::geom::Point_obj::__new((int)256,(int)462),(int)100,(int)22,HX_CSTRING("Restart"),style);
	HX_SOURCE_POS("Source/Blackjack.hx",58)
	this->message = ::com::ludamix::triad::ui::StyledText_obj::__new(::nme::geom::Point_obj::__new((int)256,(int)400),(int)300,(int)22,HX_CSTRING("Message"),::com::ludamix::triad::ui::StyledTextDef_obj::STPlaceholder_dyn(),null());
	HX_SOURCE_POS("Source/Blackjack.hx",59)
	this->hit->addEventListener(::nme::events::MouseEvent_obj::CLICK,this->onHit_dyn(),null(),null(),null());
	HX_SOURCE_POS("Source/Blackjack.hx",60)
	this->stand->addEventListener(::nme::events::MouseEvent_obj::CLICK,this->onStand_dyn(),null(),null(),null());
	HX_SOURCE_POS("Source/Blackjack.hx",61)
	this->restart->addEventListener(::nme::events::MouseEvent_obj::CLICK,this->onRestart_dyn(),null(),null(),null());
	HX_SOURCE_POS("Source/Blackjack.hx",63)
	::nme::Lib_obj::nmeGetCurrent()->addChild(this->hit);
	HX_SOURCE_POS("Source/Blackjack.hx",64)
	::nme::Lib_obj::nmeGetCurrent()->addChild(this->stand);
	HX_SOURCE_POS("Source/Blackjack.hx",65)
	::nme::Lib_obj::nmeGetCurrent()->addChild(this->restart);
	HX_SOURCE_POS("Source/Blackjack.hx",66)
	::nme::Lib_obj::nmeGetCurrent()->addChild(this->message);
	HX_SOURCE_POS("Source/Blackjack.hx",68)
	this->game->start();
	HX_SOURCE_POS("Source/Blackjack.hx",69)
	this->updateDisplay();
	HX_SOURCE_POS("Source/Blackjack.hx",71)
	::nme::Lib_obj::nmeGetCurrent()->nmeGetStage()->addEventListener(::nme::events::Event_obj::ENTER_FRAME,this->onFrame_dyn(),null(),null(),null());
}
;
	return null();
}

Blackjack_obj::~Blackjack_obj() { }

Dynamic Blackjack_obj::__CreateEmpty() { return  new Blackjack_obj; }
hx::ObjectPtr< Blackjack_obj > Blackjack_obj::__new()
{  hx::ObjectPtr< Blackjack_obj > result = new Blackjack_obj();
	result->__construct();
	return result;}

Dynamic Blackjack_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Blackjack_obj > result = new Blackjack_obj();
	result->__construct();
	return result;}

Void Blackjack_obj::onFrame( ::nme::events::Event ev){
{
		HX_SOURCE_PUSH("Blackjack_obj::onFrame")
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Blackjack_obj,onFrame,(void))

Void Blackjack_obj::updateDisplay( ){
{
		HX_SOURCE_PUSH("Blackjack_obj::updateDisplay")
		HX_SOURCE_POS("Source/Blackjack.hx",80)
		{
			HX_SOURCE_POS("Source/Blackjack.hx",80)
			::com::ludamix::triad::cards::BlittableDeck52 _this = this->deck;
			::com::ludamix::triad::cards::Deck deck = this->game;
			::com::ludamix::triad::blitter::Blitter blitter = this->blitter;
			::com::ludamix::triad::geom::AABB cardRect = this->cardRect;
			struct _Function_2_1{
				inline static ::com::ludamix::triad::geom::AABB Block( ::com::ludamix::triad::cards::BlittableDeck52 &_this,::com::ludamix::triad::geom::AABB &cardRect){
					HX_SOURCE_POS("Source/Blackjack.hx",80)
					::com::ludamix::triad::geom::SubIPoint tmp = ::com::ludamix::triad::geom::SubIPoint_obj::__new(_this->x,_this->y);
					HX_SOURCE_POS("Source/Blackjack.hx",80)
					::com::ludamix::triad::geom::AABB result = ::com::ludamix::triad::geom::AABB_obj::__new((int)0,(int)0,(int)0,(int)0);
					HX_SOURCE_POS("Source/Blackjack.hx",80)
					{
						HX_SOURCE_POS("Source/Blackjack.hx",80)
						{
							HX_SOURCE_POS("Source/Blackjack.hx",80)
							::com::ludamix::triad::geom::SubINode cur = _this;
							HX_SOURCE_POS("Source/Blackjack.hx",80)
							int x = cur->x;
							HX_SOURCE_POS("Source/Blackjack.hx",80)
							int y = cur->y;
							HX_SOURCE_POS("Source/Blackjack.hx",80)
							while(((cur->parent != null()))){
								HX_SOURCE_POS("Source/Blackjack.hx",80)
								cur = cur->parent;
								HX_SOURCE_POS("Source/Blackjack.hx",80)
								hx::AddEq(x,cur->x);
								HX_SOURCE_POS("Source/Blackjack.hx",80)
								hx::AddEq(y,cur->y);
							}
							HX_SOURCE_POS("Source/Blackjack.hx",80)
							tmp->x = x;
							HX_SOURCE_POS("Source/Blackjack.hx",80)
							tmp->y = y;
						}
						HX_SOURCE_POS("Source/Blackjack.hx",80)
						result->x = (tmp->x + cardRect->x);
						HX_SOURCE_POS("Source/Blackjack.hx",80)
						result->y = (tmp->y + cardRect->y);
						HX_SOURCE_POS("Source/Blackjack.hx",80)
						result->w = cardRect->w;
						HX_SOURCE_POS("Source/Blackjack.hx",80)
						result->h = cardRect->h;
					}
					HX_SOURCE_POS("Source/Blackjack.hx",80)
					return result;
				}
			};
			HX_SOURCE_POS("Source/Blackjack.hx",80)
			::com::ludamix::triad::geom::AABB r = _Function_2_1::Block(_this,cardRect);
			HX_SOURCE_POS("Source/Blackjack.hx",80)
			{
				HX_SOURCE_POS("Source/Blackjack.hx",80)
				int _g = (int)0;
				Dynamic _g1 = _this->hands;
				HX_SOURCE_POS("Source/Blackjack.hx",80)
				while(((_g < _g1->__Field(HX_CSTRING("length"))))){
					HX_SOURCE_POS("Source/Blackjack.hx",80)
					Dynamic hdef = _g1->__GetItem(_g);
					HX_SOURCE_POS("Source/Blackjack.hx",80)
					++(_g);
					HX_SOURCE_POS("Source/Blackjack.hx",80)
					::com::ludamix::triad::cards::Hand hand = deck->hand(hdef->__Field(HX_CSTRING("hand")));
					HX_SOURCE_POS("Source/Blackjack.hx",80)
					{
						HX_SOURCE_POS("Source/Blackjack.hx",80)
						int _g3 = (int)0;
						int _g2 = hand->cards->length;
						HX_SOURCE_POS("Source/Blackjack.hx",80)
						while(((_g3 < _g2))){
							HX_SOURCE_POS("Source/Blackjack.hx",80)
							int n = (_g3)++;
							struct _Function_6_1{
								inline static ::com::ludamix::triad::geom::SubIPoint Block( Dynamic &hdef,int &n,::com::ludamix::triad::geom::AABB &cardRect,::com::ludamix::triad::cards::Hand &hand){
									HX_SOURCE_POS("Source/Blackjack.hx",80)
									::nme::geom::Point fp = hdef->__Field(HX_CSTRING("func"))(n,hdef->__Field(HX_CSTRING("x")),hdef->__Field(HX_CSTRING("y")),hdef->__Field(HX_CSTRING("spacing")),hand->cards->length,hdef->__Field(HX_CSTRING("max")),cardRect);
									HX_SOURCE_POS("Source/Blackjack.hx",80)
									return ::com::ludamix::triad::geom::SubIPoint_obj::__new(::Std_obj::_int((fp->x * (int)256)),::Std_obj::_int((fp->y * (int)256)));
								}
							};
							HX_SOURCE_POS("Source/Blackjack.hx",80)
							::com::ludamix::triad::geom::SubIPoint spt = _Function_6_1::Block(hdef,n,cardRect,hand);
							HX_SOURCE_POS("Source/Blackjack.hx",80)
							hx::AddEq(spt->x,(r->x + ::Std_obj::_int((double(r->w) / double((int)2)))));
							HX_SOURCE_POS("Source/Blackjack.hx",80)
							hx::AddEq(spt->y,(r->y + ::Std_obj::_int((double(r->h) / double((int)2)))));
							HX_SOURCE_POS("Source/Blackjack.hx",80)
							{
								HX_SOURCE_POS("Source/Blackjack.hx",80)
								::com::ludamix::triad::cards::Card52 card = hx::TCast< com::ludamix::triad::cards::Card52 >::cast(hand->cards->__get(n));
								HX_SOURCE_POS("Source/Blackjack.hx",80)
								::String name = HX_CSTRING("card_back");
								HX_SOURCE_POS("Source/Blackjack.hx",80)
								if ((!(card->hidden))){
									HX_SOURCE_POS("Source/Blackjack.hx",80)
									name = (HX_CSTRING("card_") + card->idx);
								}
								struct _Function_7_1{
									inline static Dynamic Block( ::com::ludamix::triad::blitter::Blitter &blitter,::com::ludamix::triad::geom::SubIPoint &spt,::String &name){
										hx::Anon __result = hx::Anon_obj::Create();
										__result->Add(HX_CSTRING("bd") , blitter->spriteCache->get(name),false);
										__result->Add(HX_CSTRING("x") , (int(spt->x) >> int((int)8)),false);
										__result->Add(HX_CSTRING("y") , (int(spt->y) >> int((int)8)),false);
										return __result;
									}
								};
								HX_SOURCE_POS("Source/Blackjack.hx",80)
								blitter->spriteQueue->__GetItem(::Std_obj::_int(::Math_obj::min((blitter->spriteQueue->__Field(HX_CSTRING("length")) - (int)1),n)))->__Field(HX_CSTRING("push"))(_Function_7_1::Block(blitter,spt,name));
							}
						}
					}
				}
			}
		}
		HX_SOURCE_POS("Source/Blackjack.hx",81)
		this->blitter->update();
		HX_SOURCE_POS("Source/Blackjack.hx",82)
		this->message->nmeSetText(this->game->stateText());
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Blackjack_obj,updateDisplay,(void))

Void Blackjack_obj::onHit( ::nme::events::MouseEvent ev){
{
		HX_SOURCE_PUSH("Blackjack_obj::onHit")
		HX_SOURCE_POS("Source/Blackjack.hx",85)
		this->game->hit();
		HX_SOURCE_POS("Source/Blackjack.hx",85)
		this->updateDisplay();
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Blackjack_obj,onHit,(void))

Void Blackjack_obj::onStand( ::nme::events::MouseEvent ev){
{
		HX_SOURCE_PUSH("Blackjack_obj::onStand")
		HX_SOURCE_POS("Source/Blackjack.hx",87)
		this->game->stand();
		HX_SOURCE_POS("Source/Blackjack.hx",87)
		this->updateDisplay();
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Blackjack_obj,onStand,(void))

Void Blackjack_obj::onRestart( ::nme::events::MouseEvent ev){
{
		HX_SOURCE_PUSH("Blackjack_obj::onRestart")
		HX_SOURCE_POS("Source/Blackjack.hx",89)
		this->game->start();
		HX_SOURCE_POS("Source/Blackjack.hx",89)
		this->updateDisplay();
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Blackjack_obj,onRestart,(void))

int Blackjack_obj::SPRW;

int Blackjack_obj::SPRH;


Blackjack_obj::Blackjack_obj()
{
}

void Blackjack_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Blackjack);
	HX_MARK_MEMBER_NAME(blitter,"blitter");
	HX_MARK_MEMBER_NAME(cardRect,"cardRect");
	HX_MARK_MEMBER_NAME(game,"game");
	HX_MARK_MEMBER_NAME(deck,"deck");
	HX_MARK_MEMBER_NAME(hit,"hit");
	HX_MARK_MEMBER_NAME(stand,"stand");
	HX_MARK_MEMBER_NAME(restart,"restart");
	HX_MARK_MEMBER_NAME(message,"message");
	HX_MARK_END_CLASS();
}

Dynamic Blackjack_obj::__Field(const ::String &inName)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"hit") ) { return hit; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"SPRW") ) { return SPRW; }
		if (HX_FIELD_EQ(inName,"SPRH") ) { return SPRH; }
		if (HX_FIELD_EQ(inName,"game") ) { return game; }
		if (HX_FIELD_EQ(inName,"deck") ) { return deck; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"stand") ) { return stand; }
		if (HX_FIELD_EQ(inName,"onHit") ) { return onHit_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"blitter") ) { return blitter; }
		if (HX_FIELD_EQ(inName,"restart") ) { return restart; }
		if (HX_FIELD_EQ(inName,"message") ) { return message; }
		if (HX_FIELD_EQ(inName,"onFrame") ) { return onFrame_dyn(); }
		if (HX_FIELD_EQ(inName,"onStand") ) { return onStand_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"cardRect") ) { return cardRect; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"onRestart") ) { return onRestart_dyn(); }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"updateDisplay") ) { return updateDisplay_dyn(); }
	}
	return super::__Field(inName);
}

Dynamic Blackjack_obj::__SetField(const ::String &inName,const Dynamic &inValue)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"hit") ) { hit=inValue.Cast< ::com::ludamix::triad::ui::RoundRectButton >(); return inValue; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"SPRW") ) { SPRW=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"SPRH") ) { SPRH=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"game") ) { game=inValue.Cast< ::com::ludamix::triad::cards::BlackjackGame >(); return inValue; }
		if (HX_FIELD_EQ(inName,"deck") ) { deck=inValue.Cast< ::com::ludamix::triad::cards::BlittableDeck52 >(); return inValue; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"stand") ) { stand=inValue.Cast< ::com::ludamix::triad::ui::RoundRectButton >(); return inValue; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"blitter") ) { blitter=inValue.Cast< ::com::ludamix::triad::blitter::Blitter >(); return inValue; }
		if (HX_FIELD_EQ(inName,"restart") ) { restart=inValue.Cast< ::com::ludamix::triad::ui::RoundRectButton >(); return inValue; }
		if (HX_FIELD_EQ(inName,"message") ) { message=inValue.Cast< ::com::ludamix::triad::ui::StyledText >(); return inValue; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"cardRect") ) { cardRect=inValue.Cast< ::com::ludamix::triad::geom::AABB >(); return inValue; }
	}
	return super::__SetField(inName,inValue);
}

void Blackjack_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("blitter"));
	outFields->push(HX_CSTRING("cardRect"));
	outFields->push(HX_CSTRING("game"));
	outFields->push(HX_CSTRING("deck"));
	outFields->push(HX_CSTRING("hit"));
	outFields->push(HX_CSTRING("stand"));
	outFields->push(HX_CSTRING("restart"));
	outFields->push(HX_CSTRING("message"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("SPRW"),
	HX_CSTRING("SPRH"),
	String(null()) };

static ::String sMemberFields[] = {
	HX_CSTRING("blitter"),
	HX_CSTRING("cardRect"),
	HX_CSTRING("game"),
	HX_CSTRING("deck"),
	HX_CSTRING("hit"),
	HX_CSTRING("stand"),
	HX_CSTRING("restart"),
	HX_CSTRING("message"),
	HX_CSTRING("onFrame"),
	HX_CSTRING("updateDisplay"),
	HX_CSTRING("onHit"),
	HX_CSTRING("onStand"),
	HX_CSTRING("onRestart"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Blackjack_obj::SPRW,"SPRW");
	HX_MARK_MEMBER_NAME(Blackjack_obj::SPRH,"SPRH");
};

Class Blackjack_obj::__mClass;

void Blackjack_obj::__register()
{
	Static(__mClass) = hx::RegisterClass(HX_CSTRING("Blackjack"), hx::TCanCast< Blackjack_obj> ,sStaticFields,sMemberFields,
	&__CreateEmpty, &__Create,
	&super::__SGetClass(), 0, sMarkStatics);
}

void Blackjack_obj::__boot()
{
	hx::Static(SPRW) = (int)74;
	hx::Static(SPRH) = (int)98;
}

