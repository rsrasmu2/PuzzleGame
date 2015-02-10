import starling.display.*;
import starling.core.*;
import starling.textures.Texture;
import starling.events.*;
import starling.text.TextField;

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

	public function new()
	{
		super();
		bg = new Background();
		addChild(bg);
		map = new GameMap();

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

		addEventListener(RESET_GAME,
		function(){ setStage(Menu);});

		//based on game state
		setStage(Menu);
	}

	private function setStage(state : GameState)
	{
		removeChildren(1);

		switch(state)
		{
			case Menu:
				var title = new MenuText(this,"Mission 1-1-3");
				title.fontSize = 50;
				title.y = 50;

				var play = new MenuText(this,"Play");
				play.y = title.y + 100;
				play.fontSize = 20;
				play.addEventListener(Event.TRIGGERED,
				function(){
					currentLevel = 1;
					setStage(Level);
				});

				var instr = new MenuText(this,"Instructions");
				instr.y = play.y + 100;
				instr.fontSize = 20;
				instr.addEventListener(Event.TRIGGERED,
				function(){	setStage(Instructions);});

				var cred = new MenuText(this,"Credits");
				cred.y = instr.y + 100;
				cred.fontSize = 20;
				cred.addEventListener(Event.TRIGGERED,
				function(){	setStage(Credits);});

			case Instructions:
				var title = new MenuText(this,"How To Play");
				title.fontSize = 50;
				title.y = 50;

				var back = new MenuText(this,"Back");
				back.y = title.y + 150;
				back.fontSize = 30;
				back.addEventListener(Event.TRIGGERED,
				function(){ setStage(Menu);});

				var instr = new TextField(400,400,"The goal of the game is to move the "+
				"player object to the finish object (tentative names). Use the "+
				"arrows keys to move the object. Once you pick a direction, the "+
				"player object continues to move in that direction until it hits "+
				"an object. Press R to restart current level if you're stuck. Press Escape"+
				" to go back to the main menu while playing the game.");
				instr.fontSize = 18;
				instr.color = 0xffff00;
				instr.x = Starling.current.stage.stageWidth/2 - instr.width/2;
				instr.y = back.y + 75;
				addChild(instr);

			case Credits:
				var back = new MenuText(this,"Back");
				back.fontSize = 20; back.y = 50;
				back.addEventListener(Event.TRIGGERED,
				function(){ setStage(Menu);});

				var cred = new TextField(300,300,"Credits\n--------"+
				"\nTemitope Alaga\nJordan Harris\nNancy McCollough\nCherie Parsons\nRobert Rasmussen");
				cred.color = 0xffff00;
				cred.fontSize = 20;
				cred.y = back.y + 200;
				cred.x = Starling.current.stage.stageWidth/2 - cred.width/2;
				addChild(cred);

			case Level:
				addChild(map);
				/*haxe.Log.clear();
				trace("Level: " + currentLevel);*/
				map.setMap(LoadMap.load(Levels.level[currentLevel-1]));	//Level 1 is array index 0.
		}
	}
}

class MenuText extends Button
{
	public function new(game:Game,s:String)
	{
		super(Root.assets.getTexture("Button"));

		x = Starling.current.stage.stageWidth/2 - width/2;
		y = Starling.current.stage.stageHeight/2 - height/2;
		text = s;
		color = 0;
		fontColor = 0xffff00;
		game.addChild(this);
	}
}