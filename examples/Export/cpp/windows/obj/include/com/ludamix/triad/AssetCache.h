#ifndef INCLUDED_com_ludamix_triad_AssetCache
#define INCLUDED_com_ludamix_triad_AssetCache

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS0(Hash)
HX_DECLARE_CLASS3(com,ludamix,triad,AssetCache)
HX_DECLARE_CLASS2(haxe,io,Bytes)
HX_DECLARE_CLASS2(nme,display,BitmapData)
HX_DECLARE_CLASS2(nme,display,IBitmapDrawable)
HX_DECLARE_CLASS2(nme,events,EventDispatcher)
HX_DECLARE_CLASS2(nme,events,IEventDispatcher)
HX_DECLARE_CLASS2(nme,media,Sound)
HX_DECLARE_CLASS2(nme,text,Font)
HX_DECLARE_CLASS2(nme,utils,ByteArray)
HX_DECLARE_CLASS2(nme,utils,IDataInput)
HX_DECLARE_CLASS2(nme,utils,Timer)
namespace com{
namespace ludamix{
namespace triad{


class AssetCache_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef AssetCache_obj OBJ_;
		AssetCache_obj();
		Void __construct();

	public:
		static hx::ObjectPtr< AssetCache_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		~AssetCache_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		::String __ToString() const { return HX_CSTRING("AssetCache"); }

		static ::nme::utils::Timer t; /* REM */ 
		static ::Hash statCache; /* REM */ 
		static Dynamic onChange; /* REM */ 
	Dynamic &onChange_dyn() { return onChange;}
		static ::Hash resourceNames; /* REM */ 
		static ::Hash resourceTypes; /* REM */ 
		static Void initPoll( Dynamic onChange,::String src_pathname,::String rename_pathname);
		static Dynamic initPoll_dyn();

		static Void doPoll( Dynamic _);
		static Dynamic doPoll_dyn();

		static ::String getText( ::String id);
		static Dynamic getText_dyn();

		static ::nme::display::BitmapData getBitmapData( ::String id,Dynamic useCache);
		static Dynamic getBitmapData_dyn();

		static ::nme::utils::ByteArray getBytes( ::String id);
		static Dynamic getBytes_dyn();

		static ::nme::text::Font getFont( ::String id);
		static Dynamic getFont_dyn();

		static ::nme::media::Sound getSound( ::String id);
		static Dynamic getSound_dyn();

};

} // end namespace com
} // end namespace ludamix
} // end namespace triad

#endif /* INCLUDED_com_ludamix_triad_AssetCache */ 
