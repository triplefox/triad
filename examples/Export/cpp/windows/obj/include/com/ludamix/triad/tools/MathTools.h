#ifndef INCLUDED_com_ludamix_triad_tools_MathTools
#define INCLUDED_com_ludamix_triad_tools_MathTools

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS4(com,ludamix,triad,tools,MathTools)
namespace com{
namespace ludamix{
namespace triad{
namespace tools{


class MathTools_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef MathTools_obj OBJ_;
		MathTools_obj();
		Void __construct();

	public:
		static hx::ObjectPtr< MathTools_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		~MathTools_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		::String __ToString() const { return HX_CSTRING("MathTools"); }

		static int wraparound( int counter,int low,int high);
		static Dynamic wraparound_dyn();

		static double dist( double ax,double ay,double bx,double by);
		static Dynamic dist_dyn();

		static double distPt( Dynamic a,Dynamic b);
		static Dynamic distPt_dyn();

		static double sqrDist( double ax,double ay,double bx,double by);
		static Dynamic sqrDist_dyn();

		static double sqrDistPt( Dynamic a,Dynamic b);
		static Dynamic sqrDistPt_dyn();

		static bool fequals( double a,double b);
		static Dynamic fequals_dyn();

		static double lerp( double fromI,double toI,double pct);
		static Dynamic lerp_dyn();

		static Dynamic nearestOf( Dynamic positions,double x,double y);
		static Dynamic nearestOf_dyn();

		static double limit( double min,double max,double val);
		static Dynamic limit_dyn();

};

} // end namespace com
} // end namespace ludamix
} // end namespace triad
} // end namespace tools

#endif /* INCLUDED_com_ludamix_triad_tools_MathTools */ 
