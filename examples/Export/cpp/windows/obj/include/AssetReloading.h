#ifndef INCLUDED_AssetReloading
#define INCLUDED_AssetReloading

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS0(AssetReloading)


class AssetReloading_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef AssetReloading_obj OBJ_;
		AssetReloading_obj();
		Void __construct();

	public:
		static hx::ObjectPtr< AssetReloading_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		~AssetReloading_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		::String __ToString() const { return HX_CSTRING("AssetReloading"); }

		virtual Void onChange( Dynamic change);
		Dynamic onChange_dyn();

};


#endif /* INCLUDED_AssetReloading */ 
