class ApplicationMain
{

	#if waxe
	static public var frame : wx.Frame;
	static public var autoShowFrame : Bool = true;
	#if nme
	static public var nmeStage : wx.NMEStage;
	#end
	#end
	
	public static function main()
	{
		nme.Lib.setPackage("Ludamix", "TriadNME", "com.ludamix.triad.app", "1.0.0");
		
		
		#if waxe
		wx.App.boot(function()
		{
			
			frame = wx.Frame.create(null, null, "TriadNME", null, { width: 512, height: 512 });
			
			#if nme
			var stage = wx.NMEStage.create(frame, null, null, { width: 512, height: 512 });
			#end
			
			Main.main();
			
			if (autoShowFrame)
			{
				wx.App.setTopWindow(frame);
				frame.shown = true;
			}
		});
		#else
		
		nme.Lib.create(function()
			{ 
				if (512 == 0 && 512 == 0)
				{
					nme.Lib.current.stage.align = nme.display.StageAlign.TOP_LEFT;
					nme.Lib.current.stage.scaleMode = nme.display.StageScaleMode.NO_SCALE;
				}
				
				Main.main(); 
			},
			512, 512, 
			60, 
			0xffffff,
			(true ? nme.Lib.HARDWARE : 0) |
			(true ? nme.Lib.RESIZABLE : 0) |
			(false ? nme.Lib.BORDERLESS : 0) |
			(false ? nme.Lib.VSYNC : 0) |
			(false ? nme.Lib.FULLSCREEN : 0) |
			(1 == 4 ? nme.Lib.HW_AA_HIRES : 0) |
			(1 == 2 ? nme.Lib.HW_AA : 0),
			"TriadNME"
			
			, getAsset("icon.png")
			
		);
		#end
		
	}
	
	
	public static function getAsset(inName:String):Dynamic
	{
		
		if (inName == "assets/cards.png")
		{
			
			return nme.Assets.getBitmapData ("assets/cards.png");
			
		}
		
		if (inName == "assets/frame.png")
		{
			
			return nme.Assets.getBitmapData ("assets/frame.png");
			
		}
		
		if (inName == "assets/frame2.png")
		{
			
			return nme.Assets.getBitmapData ("assets/frame2.png");
			
		}
		
		if (inName == "assets/slider.png")
		{
			
			return nme.Assets.getBitmapData ("assets/slider.png");
			
		}
		
		return null;
	}
	
	
}