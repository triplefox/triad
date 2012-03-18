#ifndef INCLUDED_com_ludamix_triad_geom_SubIPoint
#define INCLUDED_com_ludamix_triad_geom_SubIPoint

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


class SubIPoint_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef SubIPoint_obj OBJ_;
		SubIPoint_obj();
		Void __construct(Dynamic __o_x,Dynamic __o_y);

	public:
		static hx::ObjectPtr< SubIPoint_obj > __new(Dynamic __o_x,Dynamic __o_y);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		~SubIPoint_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		::String __ToString() const { return HX_CSTRING("SubIPoint"); }

		int x; /* REM */ 
		int y; /* REM */ 
		virtual ::String toString( );
		Dynamic toString_dyn();

		virtual int xi( );
		Dynamic xi_dyn();

		virtual int yi( );
		Dynamic yi_dyn();

		virtual double xf( );
		Dynamic xf_dyn();

		virtual double yf( );
		Dynamic yf_dyn();

		virtual ::com::ludamix::triad::geom::SubIPoint clone( );
		Dynamic clone_dyn();

		virtual Void paste( ::com::ludamix::triad::geom::SubIPoint sp);
		Dynamic paste_dyn();

		virtual Void add( ::com::ludamix::triad::geom::SubIPoint p);
		Dynamic add_dyn();

		virtual Void sub( ::com::ludamix::triad::geom::SubIPoint p);
		Dynamic sub_dyn();

		virtual Void mul( ::com::ludamix::triad::geom::SubIPoint p);
		Dynamic mul_dyn();

		virtual Void div( ::com::ludamix::triad::geom::SubIPoint p);
		Dynamic div_dyn();

		virtual bool eqX( ::com::ludamix::triad::geom::SubIPoint p);
		Dynamic eqX_dyn();

		virtual bool eqY( ::com::ludamix::triad::geom::SubIPoint p);
		Dynamic eqY_dyn();

		virtual bool eq( ::com::ludamix::triad::geom::SubIPoint p);
		Dynamic eq_dyn();

		virtual Void addI( ::com::ludamix::triad::geom::IPoint p);
		Dynamic addI_dyn();

		virtual Void subI( ::com::ludamix::triad::geom::IPoint p);
		Dynamic subI_dyn();

		virtual Void mulI( ::com::ludamix::triad::geom::IPoint p);
		Dynamic mulI_dyn();

		virtual Void divI( ::com::ludamix::triad::geom::IPoint p);
		Dynamic divI_dyn();

		virtual bool eqXI( ::com::ludamix::triad::geom::IPoint p);
		Dynamic eqXI_dyn();

		virtual bool eqYI( ::com::ludamix::triad::geom::IPoint p);
		Dynamic eqYI_dyn();

		virtual bool eqI( ::com::ludamix::triad::geom::IPoint p);
		Dynamic eqI_dyn();

		virtual Void addF( ::nme::geom::Point p);
		Dynamic addF_dyn();

		virtual Void subF( ::nme::geom::Point p);
		Dynamic subF_dyn();

		virtual Void mulF( ::nme::geom::Point p);
		Dynamic mulF_dyn();

		virtual Void divF( ::nme::geom::Point p);
		Dynamic divF_dyn();

		virtual bool eqXF( ::nme::geom::Point p);
		Dynamic eqXF_dyn();

		virtual bool eqYF( ::nme::geom::Point p);
		Dynamic eqYF_dyn();

		virtual bool eqF( ::nme::geom::Point p);
		Dynamic eqF_dyn();

		virtual ::com::ludamix::triad::geom::IPoint genIPoint( );
		Dynamic genIPoint_dyn();

		virtual ::nme::geom::Point genFPoint( );
		Dynamic genFPoint_dyn();

		static int BITS; /* REM */ 
		static ::com::ludamix::triad::geom::SubIPoint fromInt( int x,int y);
		static Dynamic fromInt_dyn();

		static ::com::ludamix::triad::geom::SubIPoint fromFloat( double x,double y);
		static Dynamic fromFloat_dyn();

		static ::com::ludamix::triad::geom::SubIPoint fromIPoint( ::com::ludamix::triad::geom::IPoint ip);
		static Dynamic fromIPoint_dyn();

		static ::com::ludamix::triad::geom::SubIPoint fromFPoint( ::nme::geom::Point fp);
		static Dynamic fromFPoint_dyn();

		static int shiftF( double val);
		static Dynamic shiftF_dyn();

		static int shift( int val);
		static Dynamic shift_dyn();

		static int unshift( int val);
		static Dynamic unshift_dyn();

		static double unshiftF( int val);
		static Dynamic unshiftF_dyn();

};

} // end namespace com
} // end namespace ludamix
} // end namespace triad
} // end namespace geom

#endif /* INCLUDED_com_ludamix_triad_geom_SubIPoint */ 
