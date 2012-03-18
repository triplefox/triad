#ifndef INCLUDED_com_ludamix_triad_cards_Card52
#define INCLUDED_com_ludamix_triad_cards_Card52

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <com/ludamix/triad/cards/Card.h>
HX_DECLARE_CLASS4(com,ludamix,triad,cards,Card)
HX_DECLARE_CLASS4(com,ludamix,triad,cards,Card52)
HX_DECLARE_CLASS4(com,ludamix,triad,cards,Deck)
namespace com{
namespace ludamix{
namespace triad{
namespace cards{


class Card52_obj : public ::com::ludamix::triad::cards::Card_obj{
	public:
		typedef ::com::ludamix::triad::cards::Card_obj super;
		typedef Card52_obj OBJ_;
		Card52_obj();
		Void __construct(int suit,int value,::String owner);

	public:
		static hx::ObjectPtr< Card52_obj > __new(int suit,int value,::String owner);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		~Card52_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		::String __ToString() const { return HX_CSTRING("Card52"); }

		int idx; /* REM */ 
		virtual int suit( );
		Dynamic suit_dyn();

		virtual int value( );
		Dynamic value_dyn();

		virtual ::String suitName( );
		Dynamic suitName_dyn();

		virtual ::String valueName( );
		Dynamic valueName_dyn();

		virtual ::String toString( );
		Dynamic toString_dyn();

		static Array< ::String > suitNames; /* REM */ 
		static Array< ::String > valueNames; /* REM */ 
		static ::com::ludamix::triad::cards::Deck deck( ::com::ludamix::triad::cards::Deck d);
		static Dynamic deck_dyn();

		static ::String spriteNaming( int idx);
		static Dynamic spriteNaming_dyn();

};

} // end namespace com
} // end namespace ludamix
} // end namespace triad
} // end namespace cards

#endif /* INCLUDED_com_ludamix_triad_cards_Card52 */ 
