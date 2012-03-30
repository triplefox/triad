#ifndef INCLUDED_com_ludamix_triad_grid_IntGrid
#define INCLUDED_com_ludamix_triad_grid_IntGrid

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <com/ludamix/triad/grid/AbstractGrid.h>
HX_DECLARE_CLASS4(com,ludamix,triad,grid,AbstractGrid)
HX_DECLARE_CLASS4(com,ludamix,triad,grid,IntGrid)
namespace com{
namespace ludamix{
namespace triad{
namespace grid{


class IntGrid_obj : public ::com::ludamix::triad::grid::AbstractGrid_obj{
	public:
		typedef ::com::ludamix::triad::grid::AbstractGrid_obj super;
		typedef IntGrid_obj OBJ_;
		IntGrid_obj();
		Void __construct(int worldw,int worldh,double twidth,double theight,Array< int > populate);

	public:
		static hx::ObjectPtr< IntGrid_obj > __new(int worldw,int worldh,double twidth,double theight,Array< int > populate);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		~IntGrid_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		::String __ToString() const { return HX_CSTRING("IntGrid"); }

		virtual Void copyTo( Dynamic _tmp_prev,int idx);
		Dynamic copyTo_dyn();

};

} // end namespace com
} // end namespace ludamix
} // end namespace triad
} // end namespace grid

#endif /* INCLUDED_com_ludamix_triad_grid_IntGrid */ 
