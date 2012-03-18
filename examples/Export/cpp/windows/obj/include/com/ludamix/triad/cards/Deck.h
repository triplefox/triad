#ifndef INCLUDED_com_ludamix_triad_cards_Deck
#define INCLUDED_com_ludamix_triad_cards_Deck

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS0(Hash)
HX_DECLARE_CLASS4(com,ludamix,triad,cards,Card)
HX_DECLARE_CLASS4(com,ludamix,triad,cards,Deck)
HX_DECLARE_CLASS4(com,ludamix,triad,cards,Hand)
namespace com{
namespace ludamix{
namespace triad{
namespace cards{


class Deck_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Deck_obj OBJ_;
		Deck_obj();
		Void __construct();

	public:
		static hx::ObjectPtr< Deck_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		~Deck_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		::String __ToString() const { return HX_CSTRING("Deck"); }

		Array< ::com::ludamix::triad::cards::Card > cards; /* REM */ 
		::Hash hands; /* REM */ 
		virtual ::com::ludamix::triad::cards::Hand hand( ::String name);
		Dynamic hand_dyn();

		virtual Void push( ::com::ludamix::triad::cards::Card card,::String handName);
		Dynamic push_dyn();

		virtual ::com::ludamix::triad::cards::Card drawAndMove( ::String handFrom,::String handTo,Dynamic position);
		Dynamic drawAndMove_dyn();

		virtual Void moveCard( ::com::ludamix::triad::cards::Card card,::String handTo,Dynamic position);
		Dynamic moveCard_dyn();

		virtual Void withAllCards( Dynamic func);
		Dynamic withAllCards_dyn();

		virtual Void withCardsIn( ::String handName,Dynamic func);
		Dynamic withCardsIn_dyn();

};

} // end namespace com
} // end namespace ludamix
} // end namespace triad
} // end namespace cards

#endif /* INCLUDED_com_ludamix_triad_cards_Deck */ 
