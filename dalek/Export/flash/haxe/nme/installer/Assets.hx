package nme.installer;


import nme.display.BitmapData;
import nme.media.Sound;
import nme.net.URLRequest;
import nme.text.Font;
import nme.utils.ByteArray;
import ApplicationMain;


/**
 * ...
 * @author Joshua Granick
 */

class Assets {

	
	public static var cachedBitmapData:Hash<BitmapData> = new Hash<BitmapData>();
	
	private static var initialized:Bool = false;
	private static var resourceClasses:Hash <Dynamic> = new Hash <Dynamic> ();
	private static var resourceTypes:Hash <String> = new Hash <String> ();
	
	
	private static function initialize ():Void {
		
		if (!initialized) {
			
			resourceClasses.set ("assets/checkbox.png", NME_assets_checkbox_png);
			resourceTypes.set ("assets/checkbox.png", "image");
			resourceClasses.set ("assets/exterminate_trim.mp3", NME_assets_exterminate_trim_mp3);
			resourceTypes.set ("assets/exterminate_trim.mp3", "music");
			resourceClasses.set ("assets/frame.png", NME_assets_frame_png);
			resourceTypes.set ("assets/frame.png", "image");
			resourceClasses.set ("assets/frame2.png", NME_assets_frame2_png);
			resourceTypes.set ("assets/frame2.png", "image");
			resourceClasses.set ("assets/instructions.xb", NME_assets_instructions_xb);
			resourceTypes.set ("assets/instructions.xb", "asset");
			resourceClasses.set ("assets/sfx_boom.mid", NME_assets_sfx_boom_mid);
			resourceTypes.set ("assets/sfx_boom.mid", "asset");
			resourceClasses.set ("assets/sfx_food.mid", NME_assets_sfx_food_mid);
			resourceTypes.set ("assets/sfx_food.mid", "asset");
			resourceClasses.set ("assets/sfx_laser.mid", NME_assets_sfx_laser_mid);
			resourceTypes.set ("assets/sfx_laser.mid", "asset");
			resourceClasses.set ("assets/sfx_test.mp3", NME_assets_sfx_test_mp3);
			resourceTypes.set ("assets/sfx_test.mp3", "music");
			resourceClasses.set ("assets/slider.png", NME_assets_slider_png);
			resourceTypes.set ("assets/slider.png", "image");
			resourceClasses.set ("assets/theme.mid", NME_assets_theme_mid);
			resourceTypes.set ("assets/theme.mid", "asset");
			resourceClasses.set ("assets/VGA8x16.png", NME_assets_vga8x16_png);
			resourceTypes.set ("assets/VGA8x16.png", "image");
			
			initialized = true;
			
		}
		
	}
	
	
	public static function getBitmapData (id:String, useCache:Bool = true):BitmapData {
		
		initialize ();
		
		if (resourceTypes.exists (id) && resourceTypes.get (id) == "image") {
			
			if (useCache && cachedBitmapData.exists (id)) {
				
				return cachedBitmapData.get (id);
				
			} else {
				
				var data = cast (Type.createInstance (resourceClasses.get (id), []), BitmapData);
				
				if (useCache) {
					
					cachedBitmapData.set (id, data);
					
				}
				
				return data;
				
			}
			
		} else {
			
			trace ("[nme.Assets] There is no BitmapData asset with an ID of \"" + id + "\"");
			
			return null;
			
		}
		
	}
	
	
	public static function getBytes (id:String):ByteArray {
		
		initialize ();
		
		if (resourceClasses.exists (id)) {
			
			return cast (Type.createInstance (resourceClasses.get (id), []), ByteArray);
			
		} else {
			
			trace ("[nme.Assets] There is no String or ByteArray asset with an ID of \"" + id + "\"");
			
			return null;
			
		}
		
	}
	
	
	public static function getFont (id:String):Font {
		
		initialize ();
		
		if (resourceTypes.exists (id) && resourceTypes.get (id) == "font") {
			
			return cast (Type.createInstance (resourceClasses.get (id), []), Font);
			
		} else {
			
			trace ("[nme.Assets] There is no Font asset with an ID of \"" + id + "\"");
			
			return null;
			
		}
		
	}
	
	
	public static function getSound (id:String):Sound {
		
		initialize ();
		
		if (resourceTypes.exists (id)) {
			
			if (resourceTypes.get (id) == "sound" || resourceTypes.get (id) == "music") {
				
				return cast (Type.createInstance (resourceClasses.get (id), []), Sound);
				
			}
			
		}
		
		trace ("[nme.Assets] There is no Sound asset with an ID of \"" + id + "\"");
		
		return null;
		
	}
	
	
	public static function getText (id:String):String {
		
		var bytes = getBytes (id);
		
		if (bytes == null) {
			
			return null;
			
		} else {
			
			return bytes.readUTFBytes (bytes.length);
			
		}
		
	}
	
	
}