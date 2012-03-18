#ifndef INCLUDED_com_ludamix_triad_geom_AABB
#define INCLUDED_com_ludamix_triad_geom_AABB

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS4(com,ludamix,triad,geom,AABB)
HX_DECLARE_CLASS4(com,ludamix,triad,geom,SubIPoint)
namespace com{
namespace ludamix{
namespace triad{
namespace geom{


class AABB_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef AABB_obj OBJ_;
		AABB_obj();
		Void __construct(int x,int y,int w,int h);

	public:
		static hx::ObjectPtr< AABB_obj > __new(int x,int y,int w,int h);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		~AABB_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		::String __ToString() const { return HX_CSTRING("AABB"); }

		int x; /* REM */ 
		int y; /* REM */ 
		int w; /* REM */ 
		int h; /* REM */ 
		virtual int xi( );
		Dynamic xi_dyn();

		virtual int yi( );
		Dynamic yi_dyn();

		virtual int wi( );
		Dynamic wi_dyn();

		virtual int hi( );
		Dynamic hi_dyn();

		virtual double xf( );
		Dynamic xf_dyn();

		virtual double yf( );
		Dynamic yf_dyn();

		virtual double wf( );
		Dynamic wf_dyn();

		virtual double hf( );
		Dynamic hf_dyn();

		virtual int l( Dynamic plus);
		Dynamic l_dyn();

		virtual int r( Dynamic plus);
		Dynamic r_dyn();

		virtual int t( Dynamic plus);
		Dynamic t_dyn();

		virtual int b( Dynamic plus);
		Dynamic b_dyn();

		virtual int li( Dynamic plus);
		Dynamic li_dyn();

		virtual int ri( Dynamic plus);
		Dynamic ri_dyn();

		virtual int ti( Dynamic plus);
		Dynamic ti_dyn();

		virtual int bi( Dynamic plus);
		Dynamic bi_dyn();

		virtual double lf( Dynamic plus);
		Dynamic lf_dyn();

		virtual double rf( Dynamic plus);
		Dynamic rf_dyn();

		virtual double tf( Dynamic plus);
		Dynamic tf_dyn();

		virtual double bf( Dynamic plus);
		Dynamic bf_dyn();

		virtual int lp( Dynamic pct);
		Dynamic lp_dyn();

		virtual int rp( Dynamic pct);
		Dynamic rp_dyn();

		virtual int tp( Dynamic pct);
		Dynamic tp_dyn();

		virtual int bp( Dynamic pct);
		Dynamic bp_dyn();

		virtual int lpi( Dynamic pct);
		Dynamic lpi_dyn();

		virtual int rpi( Dynamic pct);
		Dynamic rpi_dyn();

		virtual int tpi( Dynamic pct);
		Dynamic tpi_dyn();

		virtual int bpi( Dynamic pct);
		Dynamic bpi_dyn();

		virtual double lpf( Dynamic pct);
		Dynamic lpf_dyn();

		virtual double rpf( Dynamic pct);
		Dynamic rpf_dyn();

		virtual double tpf( Dynamic pct);
		Dynamic tpf_dyn();

		virtual double bpf( Dynamic pct);
		Dynamic bpf_dyn();

		virtual Void tl( ::com::ludamix::triad::geom::SubIPoint v);
		Dynamic tl_dyn();

		virtual Void tr( ::com::ludamix::triad::geom::SubIPoint v);
		Dynamic tr_dyn();

		virtual Void bl( ::com::ludamix::triad::geom::SubIPoint v);
		Dynamic bl_dyn();

		virtual Void br( ::com::ludamix::triad::geom::SubIPoint v);
		Dynamic br_dyn();

		virtual ::com::ludamix::triad::geom::SubIPoint tlGen( );
		Dynamic tlGen_dyn();

		virtual ::com::ludamix::triad::geom::SubIPoint trGen( );
		Dynamic trGen_dyn();

		virtual ::com::ludamix::triad::geom::SubIPoint blGen( );
		Dynamic blGen_dyn();

		virtual ::com::ludamix::triad::geom::SubIPoint brGen( );
		Dynamic brGen_dyn();

		virtual int cx( Dynamic plus);
		Dynamic cx_dyn();

		virtual int cy( Dynamic plus);
		Dynamic cy_dyn();

		virtual int cxi( Dynamic plus);
		Dynamic cxi_dyn();

		virtual int cyi( Dynamic plus);
		Dynamic cyi_dyn();

		virtual double cxf( Dynamic plus);
		Dynamic cxf_dyn();

		virtual double cyf( Dynamic plus);
		Dynamic cyf_dyn();

		virtual int cxp( Dynamic pct);
		Dynamic cxp_dyn();

		virtual int cyp( Dynamic pct);
		Dynamic cyp_dyn();

		virtual int cxpi( Dynamic pct);
		Dynamic cxpi_dyn();

		virtual int cypi( Dynamic pct);
		Dynamic cypi_dyn();

		virtual double cxpf( Dynamic pct);
		Dynamic cxpf_dyn();

		virtual double cypf( Dynamic pct);
		Dynamic cypf_dyn();

		virtual Void resizeCenter( double pct);
		Dynamic resizeCenter_dyn();

		virtual Void paste( ::com::ludamix::triad::geom::AABB aabb);
		Dynamic paste_dyn();

		virtual ::com::ludamix::triad::geom::AABB clone( );
		Dynamic clone_dyn();

		virtual ::String toString( );
		Dynamic toString_dyn();

		virtual bool containsPoint( ::com::ludamix::triad::geom::SubIPoint pt);
		Dynamic containsPoint_dyn();

		virtual bool intersectsAABB( ::com::ludamix::triad::geom::AABB other);
		Dynamic intersectsAABB_dyn();

		static ::com::ludamix::triad::geom::AABB fromInt( int x,int y,int w,int h);
		static Dynamic fromInt_dyn();

		static ::com::ludamix::triad::geom::AABB fromFloat( double x,double y,double w,double h);
		static Dynamic fromFloat_dyn();

		static ::com::ludamix::triad::geom::AABB centerFromInt( int w,int h,Dynamic x,Dynamic y);
		static Dynamic centerFromInt_dyn();

		static ::com::ludamix::triad::geom::AABB centerFromFloat( double w,double h,Dynamic x,Dynamic y);
		static Dynamic centerFromFloat_dyn();

};

} // end namespace com
} // end namespace ludamix
} // end namespace triad
} // end namespace geom

#endif /* INCLUDED_com_ludamix_triad_geom_AABB */ 
