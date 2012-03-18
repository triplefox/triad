#ifndef INCLUDED_GUITests
#define INCLUDED_GUITests

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS0(GUITests)


class GUITests_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef GUITests_obj OBJ_;
		GUITests_obj();
		Void __construct();

	public:
		static hx::ObjectPtr< GUITests_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		~GUITests_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		::String __ToString() const { return HX_CSTRING("GUITests"); }

};


#endif /* INCLUDED_GUITests */ 
