import com.ludamix.triad.format.TriadConfig;
import nme.Assets;
import nme.Lib;
import nme.text.TextField;

class TriadConfigTest
{
	
	public function new()
	{
		var result = TriadConfig.parse(Assets.getText("assets/test.tc"), TCPTable);
		//var list : Array<Dynamic> = result.list;
		//for (n in list) trace(n);
		//var dict : Dynamic = result.dict;
		//for (n in Reflect.fields(dict)) trace(n+" : "+Std.string(Reflect.field(dict,n)));
		var pairs : Array<Dynamic> = result.pairs;
		for (n in pairs) trace(n);
	}
	
}