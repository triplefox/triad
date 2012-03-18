#ifndef INCLUDED_nme_media_Sound
#define INCLUDED_nme_media_Sound

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <nme/events/EventDispatcher.h>
HX_DECLARE_CLASS2(nme,events,EventDispatcher)
HX_DECLARE_CLASS2(nme,events,IEventDispatcher)
HX_DECLARE_CLASS2(nme,media,ID3Info)
HX_DECLARE_CLASS2(nme,media,Sound)
HX_DECLARE_CLASS2(nme,media,SoundChannel)
HX_DECLARE_CLASS2(nme,media,SoundLoaderContext)
HX_DECLARE_CLASS2(nme,media,SoundTransform)
HX_DECLARE_CLASS2(nme,net,URLRequest)
namespace nme{
namespace media{


class Sound_obj : public ::nme::events::EventDispatcher_obj{
	public:
		typedef ::nme::events::EventDispatcher_obj super;
		typedef Sound_obj OBJ_;
		Sound_obj();
		Void __construct(::nme::net::URLRequest stream,::nme::media::SoundLoaderContext context,Dynamic __o_forcePlayAsMusic);

	public:
		static hx::ObjectPtr< Sound_obj > __new(::nme::net::URLRequest stream,::nme::media::SoundLoaderContext context,Dynamic __o_forcePlayAsMusic);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		~Sound_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		::String __ToString() const { return HX_CSTRING("Sound"); }

		int bytesLoaded; /* REM */ 
		int bytesTotal; /* REM */ 
		::nme::media::ID3Info id3; /* REM */ 
		bool isBuffering; /* REM */ 
		double length; /* REM */ 
		::String url; /* REM */ 
		Dynamic nmeHandle; /* REM */ 
		bool nmeLoading; /* REM */ 
		virtual Void close( );
		Dynamic close_dyn();

		virtual Void load( ::nme::net::URLRequest stream,::nme::media::SoundLoaderContext context,Dynamic forcePlayAsMusic);
		Dynamic load_dyn();

		virtual Void nmeCheckLoading( );
		Dynamic nmeCheckLoading_dyn();

		virtual Void nmeOnError( ::String msg);
		Dynamic nmeOnError_dyn();

		virtual ::nme::media::SoundChannel play( Dynamic startTime,Dynamic loops,::nme::media::SoundTransform sndTransform);
		Dynamic play_dyn();

		virtual ::nme::media::ID3Info nmeGetID3( );
		Dynamic nmeGetID3_dyn();

		virtual bool nmeGetIsBuffering( );
		Dynamic nmeGetIsBuffering_dyn();

		virtual double nmeGetLength( );
		Dynamic nmeGetLength_dyn();

		static Dynamic nme_sound_from_file; /* REM */ 
	Dynamic &nme_sound_from_file_dyn() { return nme_sound_from_file;}
		static Dynamic nme_sound_get_id3; /* REM */ 
	Dynamic &nme_sound_get_id3_dyn() { return nme_sound_get_id3;}
		static Dynamic nme_sound_get_length; /* REM */ 
	Dynamic &nme_sound_get_length_dyn() { return nme_sound_get_length;}
		static Dynamic nme_sound_close; /* REM */ 
	Dynamic &nme_sound_close_dyn() { return nme_sound_close;}
		static Dynamic nme_sound_get_status; /* REM */ 
	Dynamic &nme_sound_get_status_dyn() { return nme_sound_get_status;}
};

} // end namespace nme
} // end namespace media

#endif /* INCLUDED_nme_media_Sound */ 
