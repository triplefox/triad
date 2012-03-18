#ifndef INCLUDED_nme_media_ID3Info
#define INCLUDED_nme_media_ID3Info

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(nme,media,ID3Info)
namespace nme{
namespace media{


class ID3Info_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef ID3Info_obj OBJ_;
		ID3Info_obj();
		Void __construct();

	public:
		static hx::ObjectPtr< ID3Info_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		~ID3Info_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		::String __ToString() const { return HX_CSTRING("ID3Info"); }

		::String album; /* REM */ 
		::String artist; /* REM */ 
		::String comment; /* REM */ 
		::String genre; /* REM */ 
		::String songName; /* REM */ 
		::String track; /* REM */ 
		::String year; /* REM */ 
};

} // end namespace nme
} // end namespace media

#endif /* INCLUDED_nme_media_ID3Info */ 
