#ifndef INCLUDED_com_ludamix_triad_cards_BlittableDeck52
#define INCLUDED_com_ludamix_triad_cards_BlittableDeck52

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <com/ludamix/triad/geom/SubINode.h>
HX_DECLARE_CLASS4(com,ludamix,triad,blitter,Blitter)
HX_DECLARE_CLASS4(com,ludamix,triad,cards,BlittableDeck52)
HX_DECLARE_CLASS4(com,ludamix,triad,cards,Card)
HX_DECLARE_CLASS4(com,ludamix,triad,cards,Card52)
HX_DECLARE_CLASS4(com,ludamix,triad,cards,Deck)
HX_DECLARE_CLASS4(com,ludamix,triad,geom,AABB)
HX_DECLARE_CLASS4(com,ludamix,triad,geom,SubINode)
HX_DECLARE_CLASS4(com,ludamix,triad,geom,SubIPoint)
HX_DECLARE_CLASS2(nme,display,Bitmap)
HX_DECLARE_CLASS2(nme,display,DisplayObject)
HX_DECLARE_CLASS2(nme,display,IBitmapDrawable)
HX_DECLARE_CLASS2(nme,events,EventDispatcher)
HX_DECLARE_CLASS2(nme,events,IEventDispatcher)
HX_DECLARE_CLASS2(nme,geom,Point)
namespace com{
namespace ludamix{
namespace triad{
namespace cards{


class BlittableDeck52_obj : public ::com::ludamix::triad::geom::SubINode_obj{
	public:
		typedef ::com::ludamix::triad::geom::SubINode_obj super;
		typedef BlittableDeck52_obj OBJ_;
		BlittableDeck52_obj();
		Void __construct(Dynamic hands,::com::ludamix::triad::cards::Deck deck,::com::ludamix::triad::geom::SubINode parent);

	public:
		static hx::ObjectPtr< BlittableDeck52_obj > __new(Dynamic hands,::com::ludamix::triad::cards::Deck deck,::com::ludamix::triad::geom::SubINode parent);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		~BlittableDeck52_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		::String __ToString() const { return HX_CSTRING("BlittableDeck52"); }

		Dynamic hands; /* REM */ 
		virtual Void renderDeck( ::com::ludamix::triad::cards::Deck deck,::com::ludamix::triad::blitter::Blitter blitter,::com::ludamix::triad::geom::AABB cardRect);
		Dynamic renderDeck_dyn();

		virtual Array< ::com::ludamix::triad::cards::Card > testCards( ::com::ludamix::triad::cards::Deck deck,::com::ludamix::triad::geom::AABB cardRect,::com::ludamix::triad::geom::SubIPoint mp);
		Dynamic testCards_dyn();

		virtual Void renderCard( ::com::ludamix::triad::cards::Card52 card,::com::ludamix::triad::geom::SubIPoint spt,::com::ludamix::triad::blitter::Blitter blitter,int z);
		Dynamic renderCard_dyn();

		static double space( double spacing,double elements,double max);
		static Dynamic space_dyn();

		static ::nme::geom::Point render_pile( int idx,double x,double y,double spacing,int items,int max,::com::ludamix::triad::geom::AABB cardRect);
		static Dynamic render_pile_dyn();

		static ::nme::geom::Point render_rowRight( int idx,double x,double y,double spacing,int items,int max,::com::ludamix::triad::geom::AABB cardRect);
		static Dynamic render_rowRight_dyn();

		static ::nme::geom::Point render_rowLeft( int idx,double x,double y,double spacing,int items,int max,::com::ludamix::triad::geom::AABB cardRect);
		static Dynamic render_rowLeft_dyn();

		static ::nme::geom::Point render_rowCenter( int idx,double x,double y,double spacing,int items,int max,::com::ludamix::triad::geom::AABB cardRect);
		static Dynamic render_rowCenter_dyn();

		static ::nme::geom::Point render_colBottom( int idx,double x,double y,double spacing,int items,int max,::com::ludamix::triad::geom::AABB cardRect);
		static Dynamic render_colBottom_dyn();

		static ::nme::geom::Point render_colTop( int idx,double x,double y,double spacing,int items,int max,::com::ludamix::triad::geom::AABB cardRect);
		static Dynamic render_colTop_dyn();

		static ::nme::geom::Point render_colCenter( int idx,double x,double y,double spacing,int items,int max,::com::ludamix::triad::geom::AABB cardRect);
		static Dynamic render_colCenter_dyn();

};

} // end namespace com
} // end namespace ludamix
} // end namespace triad
} // end namespace cards

#endif /* INCLUDED_com_ludamix_triad_cards_BlittableDeck52 */ 
