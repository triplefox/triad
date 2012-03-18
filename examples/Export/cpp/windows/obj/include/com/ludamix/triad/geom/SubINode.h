#ifndef INCLUDED_com_ludamix_triad_geom_SubINode
#define INCLUDED_com_ludamix_triad_geom_SubINode

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <com/ludamix/triad/geom/SubIPoint.h>
HX_DECLARE_CLASS4(com,ludamix,triad,geom,AABB)
HX_DECLARE_CLASS4(com,ludamix,triad,geom,SubINode)
HX_DECLARE_CLASS4(com,ludamix,triad,geom,SubIPoint)
namespace com{
namespace ludamix{
namespace triad{
namespace geom{


class SubINode_obj : public ::com::ludamix::triad::geom::SubIPoint_obj{
	public:
		typedef ::com::ludamix::triad::geom::SubIPoint_obj super;
		typedef SubINode_obj OBJ_;
		SubINode_obj();
		Void __construct(int x,int y,::com::ludamix::triad::geom::SubINode parent);

	public:
		static hx::ObjectPtr< SubINode_obj > __new(int x,int y,::com::ludamix::triad::geom::SubINode parent);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		~SubINode_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		::String __ToString() const { return HX_CSTRING("SubINode"); }

		::com::ludamix::triad::geom::SubINode parent; /* REM */ 
		virtual Void pos( ::com::ludamix::triad::geom::SubIPoint fp);
		Dynamic pos_dyn();

		virtual Void addpos( ::com::ludamix::triad::geom::SubIPoint fp);
		Dynamic addpos_dyn();

		virtual Void rectNoAlloc( ::com::ludamix::triad::geom::AABB pivot,::com::ludamix::triad::geom::AABB result,::com::ludamix::triad::geom::SubIPoint tmp);
		Dynamic rectNoAlloc_dyn();

		virtual ::com::ludamix::triad::geom::AABB rect( ::com::ludamix::triad::geom::AABB pivot);
		Dynamic rect_dyn();

		virtual Void hotpointNoAlloc( ::com::ludamix::triad::geom::SubIPoint pivot,::com::ludamix::triad::geom::SubIPoint result);
		Dynamic hotpointNoAlloc_dyn();

		virtual ::com::ludamix::triad::geom::SubIPoint hotpoint( ::com::ludamix::triad::geom::SubIPoint pivot);
		Dynamic hotpoint_dyn();

		static ::com::ludamix::triad::geom::SubINode fromInt( int x,int y,::com::ludamix::triad::geom::SubINode parent);
		static Dynamic fromInt_dyn();

		static ::com::ludamix::triad::geom::SubINode fromFloat( int x,int y,::com::ludamix::triad::geom::SubINode parent);
		static Dynamic fromFloat_dyn();

};

} // end namespace com
} // end namespace ludamix
} // end namespace triad
} // end namespace geom

#endif /* INCLUDED_com_ludamix_triad_geom_SubINode */ 
