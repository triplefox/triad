import Main;
import nme.Assets;
import nme.events.Event;


class ApplicationMain {
	
	static var mPreloader:NMEPreloader;

	public static function main () {
		
		var call_real = true;
		
		
		var loaded:Int = nme.Lib.current.loaderInfo.bytesLoaded;
		var total:Int = nme.Lib.current.loaderInfo.bytesTotal;
		
		if (loaded < total || true) /* Always wait for event */ {
			
			call_real = false;
			mPreloader = new NMEPreloader();
			nme.Lib.current.addChild(mPreloader);
			mPreloader.onInit();
			mPreloader.onUpdate(loaded,total);
			nme.Lib.current.addEventListener (nme.events.Event.ENTER_FRAME, onEnter);
			
		}
		
		
		if (call_real)
			Main.main();
	}

	static function onEnter (_) {
		
		var loaded:Int = nme.Lib.current.loaderInfo.bytesLoaded;
		var total:Int = nme.Lib.current.loaderInfo.bytesTotal;
		mPreloader.onUpdate(loaded,total);
		
		if (loaded >= total) {
			
			nme.Lib.current.removeEventListener(nme.events.Event.ENTER_FRAME, onEnter);
			mPreloader.addEventListener (Event.COMPLETE, preloader_onComplete);
			mPreloader.onLoaded();
			
		}
		
	}

	public static function getAsset (inName:String):Dynamic {
		
		
		if (inName=="assets/checkbox.png")
			 
            return Assets.getBitmapData ("assets/checkbox.png");
         
		
		if (inName=="assets/exterminate_trim.mp3")
			 
            return Assets.getSound ("assets/exterminate_trim.mp3");
		 
		
		if (inName=="assets/frame.png")
			 
            return Assets.getBitmapData ("assets/frame.png");
         
		
		if (inName=="assets/frame2.png")
			 
            return Assets.getBitmapData ("assets/frame2.png");
         
		
		if (inName=="assets/instructions.xb")
			 
            return Assets.getBytes ("assets/instructions.xb");
         
		
		if (inName=="assets/sfx_boom.mid")
			 
            return Assets.getBytes ("assets/sfx_boom.mid");
         
		
		if (inName=="assets/sfx_food.mid")
			 
            return Assets.getBytes ("assets/sfx_food.mid");
         
		
		if (inName=="assets/sfx_laser.mid")
			 
            return Assets.getBytes ("assets/sfx_laser.mid");
         
		
		if (inName=="assets/sfx_test.mp3")
			 
            return Assets.getSound ("assets/sfx_test.mp3");
		 
		
		if (inName=="assets/slider.png")
			 
            return Assets.getBitmapData ("assets/slider.png");
         
		
		if (inName=="assets/theme.mid")
			 
            return Assets.getBytes ("assets/theme.mid");
         
		
		if (inName=="assets/VGA8x16.png")
			 
            return Assets.getBitmapData ("assets/VGA8x16.png");
         
		
		
		return null;
		
	}
	
	
	private static function preloader_onComplete (event:Event):Void {
		
		mPreloader.removeEventListener (Event.COMPLETE, preloader_onComplete);
		
		nme.Lib.current.removeChild(mPreloader);
		mPreloader = null;
		
		Main.main ();
		
	}
	
}



	
		class NME_assets_checkbox_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
	

	
		class NME_assets_exterminate_trim_mp3 extends nme.media.Sound { }
	

	
		class NME_assets_frame_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
	

	
		class NME_assets_frame2_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
	

	
		class NME_assets_instructions_xb extends nme.utils.ByteArray { }
	

	
		class NME_assets_sfx_boom_mid extends nme.utils.ByteArray { }
	

	
		class NME_assets_sfx_food_mid extends nme.utils.ByteArray { }
	

	
		class NME_assets_sfx_laser_mid extends nme.utils.ByteArray { }
	

	
		class NME_assets_sfx_test_mp3 extends nme.media.Sound { }
	

	
		class NME_assets_slider_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
	

	
		class NME_assets_theme_mid extends nme.utils.ByteArray { }
	

	
		class NME_assets_vga8x16_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
	
