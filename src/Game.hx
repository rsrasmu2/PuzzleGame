import flash.system.ImageDecodingPolicy;
import starling.display.*;
import starling.core.*;
import starling.textures.Texture;
import starling.events.*;
import starling.text.TextField;
import starling.animation.Transitions;
import starling.animation.Tween;

enum GameState
{
	Menu;
	Instructions;
	Credits;
	Level;
}

class Game extends Sprite
{
	public inline static var ON_COMPLETE = "LevelCompleted";
	public inline static var RESET_GAME = "ResetGame";

	private var map : GameMap;
	private var currentLevel = 1;
	private var bg:Background;

	//Hold the images of the crew members
	private static var crew : Array<Image>;

	public function new()
	{
		super();
		bg = new Background();
		addChild(bg);
		map = new GameMap();

		//Load the crew sprites
		crew = new Array();
		crew.push(new Image(Root.assets.getTexture("bobby")));
		crew.push(new Image(Root.assets.getTexture("cherie")));
		crew.push(new Image(Root.assets.getTexture("jordan")));
		crew.push(new Image(Root.assets.getTexture("nancy")));
		crew.push(new Image(Root.assets.getTexture("temitope")));

		map.addEventListener(ON_COMPLETE,
			function(){
				++currentLevel;
				//if (currentLevel > Levels.level.length) {
				if (currentLevel > Levels.level.length) {
					setStage(Menu);
				} else {
					setStage(Level);
				}
			});

		addEventListener(RESET_GAME, function(){ setStage(Menu);});

		//based on game state
		setStage(Menu);
	}

	private function setStage(state : GameState)
	{
		removeChildren(1);

		switch(state)
		{
			case Menu:
				var title = new MenuText(350,100,"Mission 1-1-3");
				title.fontSize = 50;
				title.y = 50;
				addChild(title);

				var play = new MenuButton("Play");
				play.y = title.y + 100;
				play.fontSize = 20;
				play.addEventListener(Event.TRIGGERED,
				function(){
					currentLevel = 1;
					setStage(Level);
				});
				addChild(play);

				var instr = new MenuButton("Instructions");
				instr.y = play.y + 100;
				instr.fontSize = 20;
				instr.addEventListener(Event.TRIGGERED,
				function(){	setStage(Instructions);});
				addChild(instr);

				var cred = new MenuButton("Credits");
				cred.y = instr.y + 100;
				cred.fontSize = 20;
				cred.addEventListener(Event.TRIGGERED,
				function(){	setStage(Credits);});
				addChild(cred);

			case Instructions:
				var title = new MenuText(200,200,"How To Play");
				title.fontSize = 50;
				title.y = 50;
				addChild(title);

				var back = new MenuButton("Back");
				back.y = title.y + 200;
				back.fontSize = 30;
				back.addEventListener(Event.TRIGGERED,
				function(){ setStage(Menu);});
				addChild(back);

				var instr = new MenuText(400,400,"The goal of the game is to move the "+
				"player object to the finish object (tentative names). Use the "+
				"arrows keys to move the object. Once you pick a direction, the "+
				"player object continues to move in that direction until it hits "+
				"an object. Press R to restart current level if you're stuck. "+
				"Press the Escape Key to reset the game while playing.");
				instr.fontSize = 18;
				instr.x = Starling.current.stage.stageWidth/2 - instr.width/2;
				instr.y = back.y + 75;
				addChild(instr);

			case Credits:
				var back = new MenuButton("Back");
				back.fontSize = 20; back.y = 50;
				back.addEventListener(Event.TRIGGERED,
				function(){ setStage(Menu);});
				addChild(back);

				var cred = new MenuText(300,300,"Credits\n--------"+
				"\nTemitope Alaga\nJordan Harris\nNancy McCollough\nCherie Parsons\nRobert Rasmussen");
				cred.fontSize = 20;
				cred.y = back.y + 200;
				cred.x = Starling.current.stage.stageWidth/2 - cred.width/2;
				addChild(cred);

			case Level:
				addChild(map);
				/*haxe.Log.clear();
				trace("Level: " + currentLevel);*/

				//Create the crew members and draw them to the screen in the correct spot
				for (i in 0...crew.length) {
					crew[i].x = i * 20;
					crew[i].y = -50;
					addChild(crew[i]);
				}
				map.planet = Levels.level[currentLevel-1].charAt(0);
				map.setMap(LoadMap.load(Levels.level[currentLevel-1]));	//Level 1 is array index 0.
		}
	}
	//Used to get the crew in the GameMap class
	public static function getCrew() : Array<Image> {
		return crew;
	}
}

class MenuText extends TextField
{
	public function new(w:Int,h:Int,s:String)
	{
		super(w,h,s,"Arial",12,0xffff00);
		x = Starling.current.stage.stageWidth/2 - w/2;
		y = Starling.current.stage.stageHeight/2 - h/2;

		addEventListener(Event.ADDED_TO_STAGE, function()
		{
			var tweenx = x;
			x -= 700;
			Starling.juggler.tween(this, 0.25,
			{
				transition: Transitions.LINEAR,
				x : tweenx
			});
		});
	}
}

class MenuButton extends Button
{
	public function new(s:String)
	{
		super(Root.assets.getTexture("Button"));

		x = Starling.current.stage.stageWidth/2 - width/2;
		y = Starling.current.stage.stageHeight/2 - height/2;
		text = s;
		color = 0;
		fontColor = 0xffff00;

		addEventListener(Event.ADDED_TO_STAGE, function()
		{
			var tweenx = x;
			x -= 700;
			Starling.juggler.tween(this, 0.25,
			{
				transition: Transitions.LINEAR,
				x : tweenx
			});
		});
	}
}