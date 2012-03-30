#ifndef INCLUDED_com_ludamix_triad_grid_AbstractGrid
#define INCLUDED_com_ludamix_triad_grid_AbstractGrid

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS4(com,ludamix,triad,grid,AbstractGrid)
namespace com{
namespace ludamix{
namespace triad{
namespace grid{


class AbstractGrid_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef AbstractGrid_obj OBJ_;
		AbstractGrid_obj();
		Void __construct(int worldw,int worldh,double twidth,double theight,Dynamic populate);

	public:
		static hx::ObjectPtr< AbstractGrid_obj > __new(int worldw,int worldh,double twidth,double theight,Dynamic populate);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		~AbstractGrid_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		::String __ToString() const { return HX_CSTRING("AbstractGrid"); }

		Dynamic world; /* REM */ 
		int worldW; /* REM */ 
		int worldH; /* REM */ 
		virtual Void copyTo( Dynamic prev,int idx);
		Dynamic copyTo_dyn();

		double twidth; /* REM */ 
		double theight; /* REM */ 
		virtual int c21( int x,int y);
		Dynamic c21_dyn();

		virtual Dynamic c1p( int idx);
		Dynamic c1p_dyn();

		virtual Dynamic c1x( int idx);
		Dynamic c1x_dyn();

		virtual Dynamic c1t( int idx);
		Dynamic c1t_dyn();

		virtual Dynamic c2tU( int x,int y);
		Dynamic c2tU_dyn();

		virtual Dynamic c2t( int x,int y);
		Dynamic c2t_dyn();

		virtual int cp1( Dynamic p);
		Dynamic cp1_dyn();

		virtual Dynamic cptU( Dynamic p);
		Dynamic cptU_dyn();

		virtual Dynamic cpt( Dynamic p);
		Dynamic cpt_dyn();

		virtual Dynamic cffp( double x,double y);
		Dynamic cffp_dyn();

		virtual Dynamic cxp( Dynamic p);
		Dynamic cxp_dyn();

		virtual Dynamic cpx( Dynamic p);
		Dynamic cpx_dyn();

		virtual Dynamic c2x( int x,int y);
		Dynamic c2x_dyn();

		virtual int cff1( double x,double y);
		Dynamic cff1_dyn();

		virtual int cx1( Dynamic p);
		Dynamic cx1_dyn();

		virtual Dynamic cfft( double x,double y);
		Dynamic cfft_dyn();

		virtual Dynamic cxt( Dynamic p);
		Dynamic cxt_dyn();

		virtual int rotW( int x);
		Dynamic rotW_dyn();

		virtual int rotH( int y);
		Dynamic rotH_dyn();

		virtual Void shiftL( );
		Dynamic shiftL_dyn();

		virtual Void shiftR( );
		Dynamic shiftR_dyn();

		virtual Void shiftU( );
		Dynamic shiftU_dyn();

		virtual Void shiftD( );
		Dynamic shiftD_dyn();

		virtual bool tileInBounds( double x,double y);
		Dynamic tileInBounds_dyn();

		virtual bool pixelInBounds( double x,double y);
		Dynamic pixelInBounds_dyn();

};

} // end namespace com
} // end namespace ludamix
} // end namespace triad
} // end namespace grid

#endif /* INCLUDED_com_ludamix_triad_grid_AbstractGrid */ 
