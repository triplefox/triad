#ifndef INCLUDED_Blackjack
#define INCLUDED_Blackjack

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS0(Blackjack)
HX_DECLARE_CLASS4(com,ludamix,triad,blitter,Blitter)
HX_DECLARE_CLASS4(com,ludamix,triad,cards,BlackjackGame)
HX_DECLARE_CLASS4(com,ludamix,triad,cards,BlittableDeck52)
HX_DECLARE_CLASS4(com,ludamix,triad,cards,Deck)
HX_DECLARE_CLASS4(com,ludamix,triad,geom,AABB)
HX_DECLARE_CLASS4(com,ludamix,triad,geom,SubINode)
HX_DECLARE_CLASS4(com,ludamix,triad,geom,SubIPoint)
HX_DECLARE_CLASS4(com,ludamix,triad,ui,RoundRectButton)
HX_DECLARE_CLASS4(com,ludamix,triad,ui,StyledText)
HX_DECLARE_CLASS2(nme,display,Bitmap)
HX_DECLARE_CLASS2(nme,display,DisplayObject)
HX_DECLARE_CLASS2(nme,display,DisplayObjectContainer)
HX_DECLARE_CLASS2(nme,display,IBitmapDrawable)
HX_DECLARE_CLASS2(nme,display,InteractiveObject)
HX_DECLARE_CLASS2(nme,display,Sprite)
HX_DECLARE_CLASS2(nme,events,Event)
HX_DECLARE_CLASS2(nme,events,EventDispatcher)
HX_DECLARE_CLASS2(nme,events,IEventDispatcher)
HX_DECLARE_CLASS2(nme,events,MouseEvent)
HX_DECLARE_CLASS2(nme,text,TextField)


class Blackjack_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Blackjack_obj OBJ_;
		Blackjack_obj();
		Void __construct();

	public:
		static hx::ObjectPtr< Blackjack_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		~Blackjack_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		::String __ToString() const { return HX_CSTRING("Blackjack"); }

		::com::ludamix::triad::blitter::Blitter blitter; /* REM */ 
		::com::ludamix::triad::geom::AABB cardRect; /* REM */ 
		::com::ludamix::triad::cards::BlackjackGame game; /* REM */ 
		::com::ludamix::triad::cards::BlittableDeck52 deck; /* REM */ 
		::com::ludamix::triad::ui::RoundRectButton hit; /* REM */ 
		::com::ludamix::triad::ui::RoundRectButton stand; /* REM */ 
		::com::ludamix::triad::ui::RoundRectButton restart; /* REM */ 
		::com::ludamix::triad::ui::StyledText message; /* REM */ 
		virtual Void onFrame( ::nme::events::Event ev);
		Dynamic onFrame_dyn();

		virtual Void updateDisplay( );
		Dynamic updateDisplay_dyn();

		virtual Void onHit( ::nme::events::MouseEvent ev);
		Dynamic onHit_dyn();

		virtual Void onStand( ::nme::events::MouseEvent ev);
		Dynamic onStand_dyn();

		virtual Void onRestart( ::nme::events::MouseEvent ev);
		Dynamic onRestart_dyn();

		static int SPRW; /* REM */ 
		static int SPRH; /* REM */ 
};


#endif /* INCLUDED_Blackjack */ 
