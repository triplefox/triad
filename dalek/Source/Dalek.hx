import com.ludamix.triad.ascii.XBIN;
import com.ludamix.triad.ascii.ASCIIMap;
import com.ludamix.triad.ascii.ASCIISheet;
import com.ludamix.triad.io.AssetCache;
import com.ludamix.triad.audio.Audio;
import com.ludamix.triad.audio.Sequencer;
import com.ludamix.triad.audio.SMFParser;
import com.ludamix.triad.audio.TableSynth;
import com.ludamix.triad.entity.EDatabase;
import com.ludamix.triad.grid.RogueBoard;
import com.ludamix.triad.io.ButtonManager;
import haxe.io.Bytes;
import nme.Assets;
import nme.events.Event;
import nme.events.KeyboardEvent;
import nme.Lib;
import nme.ui.Keyboard;

class DalekGamestate extends EDatabase
{
	
	public var board : RogueBoard;
	public var amap : ASCIIMap;
	public var seq : Sequencer;
	public var buttonmanager : ButtonManager;
	public var game_global : Dalek;
	
	public var level_count : Int;
	
	public function init(seq, amap, buttonmanager, game_global)
	{
		this.game_global = game_global;
		this.seq = seq;
		this.amap = amap;
		this.buttonmanager = buttonmanager;
		level_count = 1;
		
		spawnLevel();
		
		board.cameraTL(0, 0, 80, 25, amap);
		amap.update();
	}
	
	public function randPos()
	{
		return {x:Std.int(Math.random() * 80), y:Std.int(Math.random() * 25)};
	}
	
	public function endLevel()
	{
		for (e in rows.keys())
		{
			call(rows.get(e), "despawn");
		}
		flushEntities();
		
		game_global.playSampledSound();
		level_count++;
		spawnLevel();
	}
	
	public function spawnLevel()
	{
		var ar = new Array();
		for (n in 0...80 * 25) ar.push({solid:false, repr: new RogueRepr(0xB0,2,5,0)});
		board = new RogueBoard(80, 25, ar, 2, new RogueRepr(0,0,0,0));
		
		for (n in 0...500)
		{
			var pos = randPos();
			board.setTile(pos.x,pos.y, 1, 
				{solid:true,repr:new RogueRepr(6,-1,10,1)} );
		}
		
		for (n in 0...level_count)
		{
			var pos = randPos();
			spawnFood(pos.x,pos.y);
			board.setTile(pos.x,pos.y, 1, emptyTile());
		}
		var pos = randPos();
		spawnPlayer(pos.x,pos.y);
		board.setTile(pos.x,pos.y, 1, emptyTile());
		
	}
	
	public inline function emptyTile()
	{
		return {solid:false, repr: new RogueRepr(-1,-1,-1,0)};
	}
	
	public function playSound(name : String, ?priority : Int = 1)
	{
		var events = SMFParser.load(seq, Assets.getBytes(name));
		for (e in events)
		{
			e.channel = 0;
			e.priority = priority; // 0 = music, 1+ = sounds
		}
		seq.pushEvents(events.copy());		
	}
	
	public inline function solid( x : Int, y : Int ) : Bool
	{
		if (board.outOfBounds(x, y)) return true;
		else return (board.layer(0).c2t(x, y).solid || board.layer(1).c2t(x, y).solid);
	}
	
	public function spawnPlayer(x,y)
	{
		var laser = { x:0, y:0, xv:0, yv:0, time:0 };
		var repr = new RogueRepr(1, -1, 15, 2);
		var actor = board.createActor(x, y, function(a) { return repr;} );
		var behavior = {
			if_unlocked:[function(db : DalekGamestate, stack : EStack, payload : Dynamic)
				{ if (laser.time<1) 
					stack.last().call(db, stack, payload[0], payload[1]); } ],
			position_free:[function(db : EDatabase, stack : EStack, payload : Dynamic)
				{ var pos = call(stack.last(), "position"); pos.x += payload.x; pos.y += payload.y;
					return !solid(pos.x, pos.y); } ],					
			try_direction:[function(db : EDatabase, stack : EStack, payload : Dynamic)
				{ if (call(stack.last(), "position_free", payload))
					call(stack.last(), "move", payload); } ],
			do_fire:[function(db : EDatabase, stack : EStack, payload : Dynamic)
				{ laser.xv = payload.xv; laser.yv = payload.yv; laser.time = 3; 
					playSound("assets/sfx_laser.mid");  } ],
			laser_info:[function(db : EDatabase, stack : EStack, payload : Dynamic)
				{ var pos = call(stack.last(), "position");
				  laser.x = pos.x+laser.xv; laser.y = pos.y+laser.yv; return Reflect.copy(laser); } ],
			laser_tick:[function(db : EDatabase, stack : EStack, payload : Dynamic)
				{ laser.time-=1; } ]
			};
		var ent = spawn([createDespawnable(),createTags(["player"]),actor,behavior]);
	}
	
	public function spawnFood(x,y)
	{
		var repr = new RogueRepr(7, -1, 15, 1);
		var actor = board.createActor(x, y, function(a) { return repr; } );
		var behavior = {
			eat:[function(db : EDatabase, stack : EStack, payload : Dynamic)
				{ stack.last().call(db, stack, "despawn"); 
					playSound("assets/sfx_food.mid"); } ] };
		var ent = spawn([createDespawnable(), actor, createTags(["food"]), behavior]);
	}
	
	public function spawnFire(x,y)
	{
		board.setTile(x, y, 1, emptyTile());
		var repr = [new RogueRepr(176, 4, 12, 1), new RogueRepr(177, 4, 12, 1), 
			new RogueRepr(178, 4, 12, 1), new RogueRepr(219, 4, 12, 1)];
		var actor = board.createActor(x, y, function(a) { return repr[Std.int(Math.random()*4)]; } );
		var ent = spawn([createDespawnable(), actor, createTags(["fire"])]);
	}
	
	public function updateGameplay(_)
	{
		
		var moved = false; // when holding down the buttons it's possible to send multiple input events.
		for (event in buttonmanager.events)
		{
			if (event.state == ButtonManager.DOWN && !moved)
			{
				switch(event.button)
				{
					case "Up": moved = true;
						for (n in tags.get("player")) call(n, "if_unlocked", ["try_direction", { x:0, y: -1 } ]);
					case "Down": moved = true;
						for (n in tags.get("player")) call(n, "if_unlocked", ["try_direction", { x:0, y: 1 } ]);
					case "Left": moved = true;
						for (n in tags.get("player")) call(n, "if_unlocked", ["try_direction", { x: -1, y: 0 } ]);
					case "Right": moved = true;
						for (n in tags.get("player")) call(n, "if_unlocked", ["try_direction", { x:1, y: 0 } ]);
					case "Fire Up": moved = true;
						for (n in tags.get("player")) call(n, "if_unlocked", ["do_fire", { xv:0, yv: -1 } ]);						
					case "Fire Down": moved = true;
						for (n in tags.get("player")) call(n, "if_unlocked", ["do_fire", { xv:0, yv: 1 } ]);
					case "Fire Left": moved = true;
						for (n in tags.get("player")) call(n, "if_unlocked", ["do_fire", { xv:-1, yv: 0 } ]);						
					case "Fire Right": moved = true;
						for (n in tags.get("player")) call(n, "if_unlocked", ["do_fire", { xv:1, yv: 0 } ]);						
				}
			}
		}
		
		for (player in tags.get("player"))
		{
			var pos = call(player, "position");
			for (act in board.infos(pos.x, pos.y).actors)
			{
				call(act.id, "eat");
			}
		}
		
		if (tags.exists("fire"))
		for (ent in tags.get("fire"))
		{
			var pos = call(ent, "position");
			board.setDirty(pos.x, pos.y);
		}
		
		board.cameraTL(0, 0, 80, 25, amap);
		if (tags.exists("player"))
		for (player in tags.get("player"))
		{
			var vec : Dynamic = call(player, "laser_info");
			if (vec.time > 0)
			{
				while (!board.outOfBounds(vec.x, vec.y) && (vec.xv!=0 || vec.yv!=0) && !solid(vec.x,vec.y))
				{
					if (vec.xv!=0)
						amap.spriteMono(String.fromCharCode(196), 1, vec.x, vec.y, 11, -1);
					else
						amap.spriteMono(String.fromCharCode(179), 1, vec.x, vec.y, 11, -1);
					board.setDirty(vec.x, vec.y);
					var infos = (board.infos(vec.x, vec.y));
					for (a in infos.actors)
					{
						call(a.id, "eat");
					}
					vec.x += vec.xv;
					vec.y += vec.yv;
				}
				if (!board.outOfBounds(vec.x, vec.y))
				{
					playSound("assets/sfx_boom.mid",2);
					spawnFire(vec.x, vec.y);
				}
			}
			call(player, "laser_tick");			
		}
		
		amap.update();
		flushEntities();
		
		if (!tags.exists("food") || tags.get("food").length<1)
		{
			endLevel();
		}
	}
	
}

class Dalek
{
	
	// Discover and eliminate foods - horse_ebooks
	// The Dalek Starvation Challenge
	
	public var amap : ASCIIMap;
	public var asheet : ASCIISheet;
	public var buttonmanager : ButtonManager;
	public var seq : Sequencer;
	
	public var db : DalekGamestate;

	public function new()
	{
		makeSettings();
	}
	
	public function makeSettings()
	{
		Audio.init({Volume:{vol:1.0,on:true}},true);
		Audio.SFXCHANNEL = "Volume";
		Audio.BGMCHANNEL = "Volume";
		buttonmanager = 
		new ButtonManager([ { name:"Up", code:{keyCode:Keyboard.UP,charCode:0}, group:"Movement" },
							{ name:"Down", code:{keyCode:Keyboard.DOWN,charCode:0}, group:"Movement" },
							{ name:"Left", code:{keyCode:Keyboard.LEFT,charCode:0}, group:"Movement" },
							{ name:"Right", code:{keyCode:Keyboard.RIGHT,charCode:0}, group:"Movement" },
							{ name:"Fire Left", code: { keyCode:65, charCode:97 }, group:"Shooting" },
							{ name:"Fire Up", code: { keyCode:87, charCode:119 }, group:"Shooting" },
							{ name:"Fire Down", code: { keyCode:83, charCode:115 }, group:"Shooting" },
							{ name:"Fire Right", code: { keyCode:68, charCode:100 }, group:"Shooting" },
							],
							3);
							
		CommonStyle.init(buttonmanager);
		
		Lib.current.stage.addChild(CommonStyle.settings);
		
		CommonStyle.settings.onClose = function() { makeTitle(); };
		
		seq = new Sequencer();
		for (n in 0...1)
			seq.addSynth(new TableSynth());
		for (n in 0...16)
			seq.addChannel(seq.synths);
		
	}
	
	public function makeTitle()
	{
		asheet = new ASCIISheet(AssetCache.getBitmapData("assets/VGA8x16.png"), 8, 16,
			[0x000000, 0x0000AA, 0x00AA00, 0x00AAAA, 0xAA0000, 0xAA00AA, 0xAA5500, 0xAAAAAA, 0x555555, 0x5555FF,
			0x55FF55,0x55FFFF,0xFF5555,0xFF55FF,0xFFFF55,0xFFFFFF]);
		amap = new ASCIIMap(asheet, 80, 25);
		
		Lib.current.stage.addChild(amap);
		
		seq.play("synth", "Volume");
		
		var events = SMFParser.load(seq, Assets.getBytes("assets/theme.mid"));
		for (e in events)
		{
			e.channel = 0;
			e.priority = 0;
		}
		
		seq.pushEvents(events.copy());		
		
		titlepos = 0;
		
		stars = new Array();
		for (n in 0...100)
			stars.push( { ang:Math.random() * Math.PI * 2, dist:Math.random() * 80 } );
		titletimer = 0;
		
		Lib.current.addEventListener(Event.ENTER_FRAME, doTitle);
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, titleAdvance);
	}
	
	public var titlepos : Int;
	public var titletimer : Int;
	
	public var stars : Array<{ang:Float,dist:Float}>;
	
	public inline function starPos(star : {ang:Float,dist:Float})
	{
		var x = Math.sin(star.ang) * star.dist;
		var y = Math.cos(star.ang) * star.dist;
		return { x:Std.int(x),y:Std.int(y) };
	}
	
	public inline function starDraw(star : {ang:Float,dist:Float})
	{
		var pos = starPos(star);
		if (star.dist<8)
			amap.spriteMono(".", 1, Std.int(pos.x + 80 >> 1), Std.int(pos.y + 25 >> 1), 8, 0);
		else if (star.dist<20)
			amap.spriteMono(".", 1, Std.int(pos.x + 80 >> 1), Std.int(pos.y + 25 >> 1), 7, 0);
		else
			amap.spriteMono(".", 1, Std.int(pos.x + 80>>1), Std.int(pos.y + 25>>1), 15, 0);
	}
	
	public function doTitle(_)
	{
		// display the title and then instructions...
		// last things to do before I ship - 1. compact assets 2. make the title starfield animate...
		
		if (titlepos == 0)
		{
			for (x in 0...amap.char.worldW)
			{
				for (y in 0...amap.char.worldH)
					amap.spriteMono(" ", 1, x,y, 0, 0);
			}
			for (s in stars)
			{
				s.dist += 1.0;
				s.ang += 0.1;
				if (s.dist > 80) s.dist = 0.;
				starDraw(s);
			}
			var str = "DALEK STARVATION CHALLENGE";
			amap.text(str, (80 >> 1) - (str.length >> 1), 25 >> 1, Std.int(Math.random() * 15), 0);
			
			titletimer = (titletimer + 1) % 160;
			if (titletimer < 80)
			{
				str = "2012 Triplefox";
			}
			else
			{
				str = "Press any key to continue";
			}
			amap.text(str, (80 >> 1) - (str.length >> 1), 24, Std.int(Math.random()*15), 0);
		}
		else
		{
			var xb = XBIN.load(Bytes.ofData(Assets.getBytes("assets/instructions.xb")));
			amap.blit(xb.image24());
		}
		
		amap.update();
		
	}
	
	public function playSampledSound()
	{
		seq.stop();
		var xsnd = Audio.play("assets/exterminate_trim.mp3");
		xsnd.addEventListener(Event.SOUND_COMPLETE, function(_) { seq.play("synth", "Volume"); } );		
	}
	
	public function titleAdvance(_)
	{
		playSampledSound();
		
		titlepos++;
		if (titlepos >= 2)
		{
			Lib.current.removeEventListener(Event.ENTER_FRAME, doTitle);
			Lib.current.stage.removeEventListener(KeyboardEvent.KEY_DOWN, titleAdvance);
			makeGame();
		}
	}
	
	public function makeGame()
	{
		
		db = new DalekGamestate();
		db.init(seq, amap, buttonmanager, this);
		
		Lib.current.addEventListener(Event.ENTER_FRAME, db.updateGameplay);
		
	}
	
}