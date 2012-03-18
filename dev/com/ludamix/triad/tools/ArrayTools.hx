package com.ludamix.triad.tools;

class ArrayTools
{
	
	public static function transformNestedArray(expr : Array<Dynamic>, 
		?detectNesting : Dynamic->Bool, ?eachNode : Dynamic->Dynamic)
	{
		var result = new Array<Dynamic>();
		var cur = [result];
		
		function recurse(expr : Array<Dynamic>) {
			for (n in expr)
			{
				if (detectNesting(n)) 
				{ 
					var nar = new Array<Dynamic>();
					cur[cur.length-1].push(nar); 
					cur.push(nar);
					recurse(cast(n, Array<Dynamic>)); 
				}
				else
				{
					cur[cur.length-1].push(eachNode(n));
				}
			}
			cur.pop();
		}
		recurse(expr);
		
		return result;
		
	}

}