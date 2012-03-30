#ifndef INCLUDED_ASCIITest
#define INCLUDED_ASCIITest

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS0(ASCIITest)
HX_DECLARE_CLASS4(com,ludamix,triad,blitter,ASCIIMap)
HX_DECLARE_CLASS4(com,ludamix,triad,blitter,ASCIISheet)
HX_DECLARE_CLASS2(nme,display,Bitmap)
HX_DECLARE_CLASS2(nme,display,DisplayObject)
HX_DECLARE_CLASS2(nme,display,IBitmapDrawable)
HX_DECLARE_CLASS2(nme,events,EventDispatcher)
HX_DECLARE_CLASS2(nme,events,IEventDispatcher)


class ASCIITest_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef ASCIITest_obj OBJ_;
		ASCIITest_obj();
		Void __construct();

	public:
		static hx::ObjectPtr< ASCIITest_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		~ASCIITest_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		::String __ToString() const { return HX_CSTRING("ASCIITest"); }

		int ptr; /* REM */ 
		::com::ludamix::triad::blitter::ASCIIMap amap; /* REM */ 
		::com::ludamix::triad::blitter::ASCIISheet asheet; /* REM */ 
		virtual Void update( Dynamic _);
		Dynamic update_dyn();

};


#endif /* INCLUDED_ASCIITest */ 
