#ifndef INCLUDED_com_ludamix_triad_cards_Hand
#define INCLUDED_com_ludamix_triad_cards_Hand

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS4(com,ludamix,triad,cards,Card)
HX_DECLARE_CLASS4(com,ludamix,triad,cards,Hand)
namespace com{
namespace ludamix{
namespace triad{
namespace cards{


class Hand_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Hand_obj OBJ_;
		Hand_obj();
		Void __construct(::String name);

	public:
		static hx::ObjectPtr< Hand_obj > __new(::String name);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		~Hand_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		::String __ToString() const { return HX_CSTRING("Hand"); }

		Array< ::com::ludamix::triad::cards::Card > cards; /* REM */ 
		::String name; /* REM */ 
		virtual Void insert( ::com::ludamix::triad::cards::Card card,int idx);
		Dynamic insert_dyn();

		virtual Void push( ::com::ludamix::triad::cards::Card card);
		Dynamic push_dyn();

		virtual Void pushBottom( ::com::ludamix::triad::cards::Card card);
		Dynamic pushBottom_dyn();

		virtual ::com::ludamix::triad::cards::Card draw( );
		Dynamic draw_dyn();

		virtual ::com::ludamix::triad::cards::Card drawBottom( );
		Dynamic drawBottom_dyn();

		virtual Void swap( ::com::ludamix::triad::cards::Card a,::com::ludamix::triad::cards::Card b);
		Dynamic swap_dyn();

		virtual Void swapIdx( int a,int b);
		Dynamic swapIdx_dyn();

		virtual Void shuffle( );
		Dynamic shuffle_dyn();

		virtual ::com::ludamix::triad::cards::Card remove( ::com::ludamix::triad::cards::Card card);
		Dynamic remove_dyn();

		virtual ::com::ludamix::triad::cards::Card removeIdx( int idx);
		Dynamic removeIdx_dyn();

		virtual ::String toString( );
		Dynamic toString_dyn();

		virtual ::com::ludamix::triad::cards::Card top( );
		Dynamic top_dyn();

		virtual ::com::ludamix::triad::cards::Card bottom( );
		Dynamic bottom_dyn();

};

} // end namespace com
} // end namespace ludamix
} // end namespace triad
} // end namespace cards

#endif /* INCLUDED_com_ludamix_triad_cards_Hand */ 
