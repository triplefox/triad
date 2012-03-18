import com.ludamix.triad.entity.EDatabase;
import nme.geom.Point;

class MyDB extends EDatabase
{
	
	// example of a use of components to implement recursive position chains

	public var positions : Array<{ent:ERow,pt:Point,parent:Dynamic}>;
	
	public function new():Void 
	{
		super();
		positions = new Array();
	}
	
	public function add_point(db : MyDB, stack : Array<ERow>, 
		payload : {x:Int,y:Int,get:String,remove:String,ent:ERow,parent:{get:String,row:ERow}})
	{
		var data : Dynamic = { ent:stack[stack.length - 1], pt:new Point(payload.x, payload.y) }
		if (Reflect.hasField(payload, "parent"))
			data.parent = payload.parent;
		else
			data.parent = null;
		db.positions.push(data);
		
		var on_remove_point : Dynamic = null;
		var on_get : Dynamic = null;
		var on_get_raw = function(db, stack, payload) { return data.pt; };
		on_remove_point = function(db : MyDB, stack : Array<ERow>, _payload : Dynamic):Array<Dynamic>
		{
			stack[stack.length - 1].unlisten(payload.get,on_get);
			stack[stack.length - 1].unlisten(payload.get+"_raw",on_get_raw);
			stack[stack.length - 1].unlisten(payload.remove,on_remove_point);
			var tr = new Array<Dynamic>();
			for (n in db.positions)
			{
				if (stack[stack.length-1] == n.ent)
					tr.push(positions.remove(n));
			}
			return tr;
		}
		
		payload.ent.listen(payload.remove, on_remove_point);
		if (data.parent!=null)
			on_get = function(db : MyDB, stack : Array<ERow>, payload : Dynamic) { 
				var p = new Point(data.pt.x, data.pt.y); 
				var other = data.parent.row.call(db, stack, data.parent.method);
				p.x += other.x; p.y += other.y;
				return p; };
		else
			on_get = function(db : MyDB, stack : Array<ERow>, payload : Dynamic) { 
				return new Point(data.pt.x, data.pt.y); };
		payload.ent.listen(payload.get, on_get);
		payload.ent.listen(payload.get + "_raw", on_get_raw);
		
		return {on_get:on_get,on_get_raw:on_get_raw,on_remove_point:on_remove_point};
	}
	
}

class EntitySystem
{
	
	public function new()
	{
		var db = new MyDB();
		var row = db.spawn( { spawn:[db.add_point] } );
		var row2 = db.spawn( { spawn:[db.add_point] } );
		trace(db.call(row, "spawn", { ent:row, x:0, y:100, get:"point", remove:"despawn" } ));
		trace(db.call(row2, "spawn", { ent:row2, x:100, y:0, get:"point", remove:"despawn",parent:{row:row,method:"point"} } ));
		trace(db.call(row, "point"));
		trace(db.call(row, "point_raw"));
		trace(db.call(row2, "point"));
		trace(db.call(row2, "point_raw"));
		trace(db.call(row, "despawn"));
		trace(db.call(row2, "despawn"));
		trace(db.positions);
		
		row.listen("make_bag", db.bag);
		trace(db.call(row, "make_bag", { data:"hello", get:"get_bag", remove:"despawn" } ));
		trace(db.call(row, "get_bag"));
		trace(db.call(row, "despawn"));
		trace(db.call(row, "get_bag"));
		
		row.listen("make_tag", db.tag);
		trace(db.call(row, "make_tag", { name:"player", get:"get_tag", remove:"despawn" } ));
		trace(db.call(row, "get_tag"));
		trace(db.tags);
		trace(db.call(row, "despawn"));
		trace(db.call(row, "get_tag"));
		
		trace(row.listenerNames());
		
	}
	
}