//typedef MyExample = GUITests;
//typedef MyExample = Blackjack;
//typedef MyExample = ASCIITest;
//typedef MyExample = SynthTest;
//typedef MyExample = CompressedSynthTest;
//typedef MyExample = Tilemapping;
//typedef MyExample = SpritePacking;
//typedef MyExample = Keyjammer;
//typedef MyExample = AssetReloading;
//typedef MyExample = Assistant;
//typedef MyExample = Raycast;
//typedef MyExample = TriadConfigTest;
typedef MyExample = Stage3DTest;

class Main
{
	
	public static var example : MyExample;
	
	public static var W = 720;
	public static var H = 400;
	
	public static function main()
	{
		W = nme.Lib.current.stage.stageWidth;
		H = nme.Lib.current.stage.stageHeight;
		example = new MyExample();		
	}
	
	
}