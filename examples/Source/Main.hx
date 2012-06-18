//typedef MyExample = GUITests;
//typedef MyExample = Blackjack;
//typedef MyExample = ASCIITest;
//typedef MyExample = SynthTest;
typedef MyExample = Tilemapping;
//typedef MyExample = Keyjammer;
//typedef MyExample = AssetReloading;
//typedef MyExample = Assistant;
//typedef MyExample = Raycast;
//typedef MyExample = TriadConfigTest;

class Main
{
	
	public static var example : MyExample;
	
	public static inline var W = 720;
	public static inline var H = 400;
	
	public static function main()
	{
		example = new MyExample();		
	}
	
	
}