#ifndef INCLUDED_com_ludamix_triad_cards_BlackjackGame
#define INCLUDED_com_ludamix_triad_cards_BlackjackGame

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <com/ludamix/triad/cards/Deck.h>
HX_DECLARE_CLASS4(com,ludamix,triad,cards,BlackjackGame)
HX_DECLARE_CLASS4(com,ludamix,triad,cards,Deck)
namespace com{
namespace ludamix{
namespace triad{
namespace cards{


class BlackjackGame_obj : public ::com::ludamix::triad::cards::Deck_obj{
	public:
		typedef ::com::ludamix::triad::cards::Deck_obj super;
		typedef BlackjackGame_obj OBJ_;
		BlackjackGame_obj();
		Void __construct();

	public:
		static hx::ObjectPtr< BlackjackGame_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		~BlackjackGame_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		::String __ToString() const { return HX_CSTRING("BlackjackGame"); }

		int state; /* REM */ 
		virtual int permutations( ::String hand);
		Dynamic permutations_dyn();

		virtual Void check( );
		Dynamic check_dyn();

		virtual Void stand( );
		Dynamic stand_dyn();

		virtual Void finalizeState( );
		Dynamic finalizeState_dyn();

		virtual Void start( );
		Dynamic start_dyn();

		virtual Void hit( );
		Dynamic hit_dyn();

		virtual Dynamic play( ::String command);
		Dynamic play_dyn();

		virtual ::String stateText( );
		Dynamic stateText_dyn();

		static int WIN; /* REM */ 
		static int LOSE; /* REM */ 
		static int PLAY; /* REM */ 
};

} // end namespace com
} // end namespace ludamix
} // end namespace triad
} // end namespace cards

#endif /* INCLUDED_com_ludamix_triad_cards_BlackjackGame */ 
