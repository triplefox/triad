import com.ludamix.triad.AssetCache;

class AssetReloading
{
	
	public function new():Void 
	{
		AssetCache.initPoll(onChange);
	}
	
	public function onChange()
	{
		trace("change");
		trace(AssetCache.getText("README.txt"));
	}
	
}