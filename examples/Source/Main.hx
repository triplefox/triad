//typedef MyExample = GUITests;
//typedef MyExample = Blackjack;
//typedef MyExample = Invaders;
typedef MyExample = EntitySystem;

class Main
{
	
	public static var example : MyExample;
	
	public static inline var W = 512;
	public static inline var H = 512;
	
	public static function main()
	{
		example = new MyExample();		
	}
	
	
}