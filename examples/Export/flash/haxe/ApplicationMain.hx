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
		
		
		if (inName=="assets/cards.png")
			 
            return Assets.getBitmapData ("assets/cards.png");
         
		
		if (inName=="assets/checkbox.png")
			 
            return Assets.getBitmapData ("assets/checkbox.png");
         
		
		if (inName=="assets/frame.png")
			 
            return Assets.getBitmapData ("assets/frame.png");
         
		
		if (inName=="assets/frame2.png")
			 
            return Assets.getBitmapData ("assets/frame2.png");
         
		
		if (inName=="assets/sfx_test.mp3")
			 
            return Assets.getSound ("assets/sfx_test.mp3");
		 
		
		if (inName=="assets/slider.png")
			 
            return Assets.getBitmapData ("assets/slider.png");
         
		
		if (inName=="assets/slider2.png")
			 
            return Assets.getBitmapData ("assets/slider2.png");
         
		
		if (inName=="assets/test_01.mid")
			 
            return Assets.getBytes ("assets/test_01.mid");
         
		
		if (inName=="assets/test_02.mid")
			 
            return Assets.getBytes ("assets/test_02.mid");
         
		
		if (inName=="assets/test_03.mid")
			 
            return Assets.getBytes ("assets/test_03.mid");
         
		
		if (inName=="assets/VGA9x16.png")
			 
            return Assets.getBitmapData ("assets/VGA9x16.png");
         
		
		
		return null;
		
	}
	
	
	private static function preloader_onComplete (event:Event):Void {
		
		mPreloader.removeEventListener (Event.COMPLETE, preloader_onComplete);
		
		nme.Lib.current.removeChild(mPreloader);
		mPreloader = null;
		
		Main.main ();
		
	}
	
}



	
		class NME_assets_cards_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
	

	
		class NME_assets_checkbox_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
	

	
		class NME_assets_frame_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
	

	
		class NME_assets_frame2_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
	

	
		class NME_assets_sfx_test_mp3 extends nme.media.Sound { }
	

	
		class NME_assets_slider_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
	

	
		class NME_assets_slider2_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
	

	
		class NME_assets_test_01_mid extends nme.utils.ByteArray { }
	

	
		class NME_assets_test_02_mid extends nme.utils.ByteArray { }
	

	
		class NME_assets_test_03_mid extends nme.utils.ByteArray { }
	

	
		class NME_assets_vga9x16_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
	
