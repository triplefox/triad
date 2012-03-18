#ifndef INCLUDED_com_ludamix_triad_geom_IPoint
#define INCLUDED_com_ludamix_triad_geom_IPoint

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS4(com,ludamix,triad,geom,IPoint)
HX_DECLARE_CLASS4(com,ludamix,triad,geom,SubIPoint)
HX_DECLARE_CLASS2(nme,geom,Point)
namespace com{
namespace ludamix{
namespace triad{
namespace geom{


class IPoint_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef IPoint_obj OBJ_;
		IPoint_obj();
		Void __construct(Dynamic __o_x,Dynamic __o_y);

	public:
		static hx::ObjectPtr< IPoint_obj > __new(Dynamic __o_x,Dynamic __o_y);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		~IPoint_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		::String __ToString() const { return HX_CSTRING("IPoint"); }

		int x; /* REM */ 
		int y; /* REM */ 
		virtual ::com::ludamix::triad::geom::IPoint clone( );
		Dynamic clone_dyn();

		virtual Void add( ::com::ludamix::triad::geom::IPoint p);
		Dynamic add_dyn();

		virtual Void sub( ::com::ludamix::triad::geom::IPoint p);
		Dynamic sub_dyn();

		virtual Void mul( ::com::ludamix::triad::geom::IPoint p);
		Dynamic mul_dyn();

		virtual Void div( ::com::ludamix::triad::geom::IPoint p);
		Dynamic div_dyn();

		virtual bool eqX( ::com::ludamix::triad::geom::IPoint p);
		Dynamic eqX_dyn();

		virtual bool eqY( ::com::ludamix::triad::geom::IPoint p);
		Dynamic eqY_dyn();

		virtual bool eq( ::com::ludamix::triad::geom::IPoint p);
		Dynamic eq_dyn();

		virtual ::com::ludamix::triad::geom::SubIPoint genSubIPoint( );
		Dynamic genSubIPoint_dyn();

		virtual ::nme::geom::Point genFPoint( );
		Dynamic genFPoint_dyn();

};

} // end namespace com
} // end namespace ludamix
} // end namespace triad
} // end namespace geom

#endif /* INCLUDED_com_ludamix_triad_geom_IPoint */ 
