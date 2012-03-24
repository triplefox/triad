import com.ludamix.triad.AssetCache;

class AssetReloading
{
	
	public function new():Void 
	{
		AssetCache.initPoll(onChange, "assets","../../../../Assets");
	}
	
	public function onChange(change : Array<ChangedAsset>)
	{
		trace(Lambda.map(change, function(a:ChangedAsset) { return a.id; } ));
	}
	
}