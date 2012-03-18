#ifndef INCLUDED_nme_text_Font
#define INCLUDED_nme_text_Font

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(nme,text,Font)
HX_DECLARE_CLASS2(nme,text,FontStyle)
HX_DECLARE_CLASS2(nme,text,FontType)
namespace nme{
namespace text{


class Font_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Font_obj OBJ_;
		Font_obj();
		Void __construct(::String inFilename);

	public:
		static hx::ObjectPtr< Font_obj > __new(::String inFilename);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		~Font_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		::String __ToString() const { return HX_CSTRING("Font"); }

		::String fontName; /* REM */ 
		::nme::text::FontStyle fontStyle; /* REM */ 
		::nme::text::FontType fontType; /* REM */ 
		static Dynamic load( ::String inFilename);
		static Dynamic load_dyn();

		static Dynamic freetype_import_font; /* REM */ 
	Dynamic &freetype_import_font_dyn() { return freetype_import_font;}
};

} // end namespace nme
} // end namespace text

#endif /* INCLUDED_nme_text_Font */ 
