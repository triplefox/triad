#ifndef INCLUDED_com_ludamix_triad_cards_Card
#define INCLUDED_com_ludamix_triad_cards_Card

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS4(com,ludamix,triad,cards,Card)
namespace com{
namespace ludamix{
namespace triad{
namespace cards{


class Card_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Card_obj OBJ_;
		Card_obj();
		Void __construct(::String owner,Dynamic __o_hidden);

	public:
		static hx::ObjectPtr< Card_obj > __new(::String owner,Dynamic __o_hidden);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		~Card_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		::String __ToString() const { return HX_CSTRING("Card"); }

		::String owner; /* REM */ 
		bool hidden; /* REM */ 
};

} // end namespace com
} // end namespace ludamix
} // end namespace triad
} // end namespace cards

#endif /* INCLUDED_com_ludamix_triad_cards_Card */ 
