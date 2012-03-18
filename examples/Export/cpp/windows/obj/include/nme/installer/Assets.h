#ifndef INCLUDED_nme_installer_Assets
#define INCLUDED_nme_installer_Assets

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS0(Hash)
HX_DECLARE_CLASS2(haxe,io,Bytes)
HX_DECLARE_CLASS2(nme,display,BitmapData)
HX_DECLARE_CLASS2(nme,display,IBitmapDrawable)
HX_DECLARE_CLASS2(nme,events,EventDispatcher)
HX_DECLARE_CLASS2(nme,events,IEventDispatcher)
HX_DECLARE_CLASS2(nme,installer,Assets)
HX_DECLARE_CLASS2(nme,media,Sound)
HX_DECLARE_CLASS2(nme,text,Font)
HX_DECLARE_CLASS2(nme,utils,ByteArray)
HX_DECLARE_CLASS2(nme,utils,IDataInput)
namespace nme{
namespace installer{


class Assets_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Assets_obj OBJ_;
		Assets_obj();
		Void __construct();

	public:
		static hx::ObjectPtr< Assets_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		~Assets_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		::String __ToString() const { return HX_CSTRING("Assets"); }

		static ::Hash cachedBitmapData; /* REM */ 
		static bool initialized; /* REM */ 
		static ::Hash resourceNames; /* REM */ 
		static ::Hash resourceTypes; /* REM */ 
		static Void initialize( );
		static Dynamic initialize_dyn();

		static ::String getResourceName( ::String id);
		static Dynamic getResourceName_dyn();

		static ::nme::display::BitmapData getBitmapData( ::String id,Dynamic useCache);
		static Dynamic getBitmapData_dyn();

		static ::nme::utils::ByteArray getBytes( ::String id);
		static Dynamic getBytes_dyn();

		static ::nme::text::Font getFont( ::String id);
		static Dynamic getFont_dyn();

		static ::nme::media::Sound getSound( ::String id);
		static Dynamic getSound_dyn();

		static ::String getText( ::String id);
		static Dynamic getText_dyn();

};

} // end namespace nme
} // end namespace installer

#endif /* INCLUDED_nme_installer_Assets */ 
