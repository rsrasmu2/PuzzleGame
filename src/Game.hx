import starling.display.*;
import starling.core.*;
import starling.textures.Texture;
import starling.events.*;

enum GameState
{
	Menu;
	Instructions;
	Credits;
	Level;
}

class Game extends Sprite
{
	public static var game : Game;
	public inline static var ON_COMPLETE = "LevelCompleted";
	
	private var map : GameMap;
	private var loadMap : LoadMap;
	private var currentLevel = 1;
	
	public function new()
	{
		super();
		game = this;
		map = new GameMap();
		loadMap = new LoadMap();
		
		map.addEventListener(ON_COMPLETE,
			function(){
				currentLevel++;
				//if (currentLevel > Levels.level.length) {
				if (currentLevel > Levels.level.length) {
					setStage(Menu);
				} else {
					setStage(Level);
				}
			});

		//based on game state
		setStage(Menu);
	}

	private function setStage(state : GameState)
	{
		removeChildren();
		switch(state)
		{
			case Menu:
				var title = new MenuText("Mission 1-1-3",300);
				title.fontSize = 50;
				title.y = 50;

				var play = new MenuText("Play", 200);
				play.y = title.y + 100;
				play.fontSize = 20;
				play.addEventListener(Event.TRIGGERED,
				function(){
					currentLevel = 1;
					setStage(Level);
				});

				var instr = new MenuText("Instructions",200);
				instr.y = play.y + 100;
				instr.fontSize = 20;
				instr.addEventListener(Event.TRIGGERED,
				function(){	setStage(Instructions);});

				var cred = new MenuText("Credits",200);
				cred.y = instr.y + 100;
				cred.fontSize = 20;
				cred.addEventListener(Event.TRIGGERED,
				function(){	setStage(Credits);});
				
			case Instructions:
				var title = new MenuText("How To Play",200,200);
				title.fontSize = 50;
				title.y = 50;

				var back = new MenuText("Back");
				back.y = title.y + 200;
				back.fontSize = 30;
				back.addEventListener(Event.TRIGGERED,
				function(){ setStage(Menu);});

				var instr = new MenuText("The goal of the game is to move the "+
				"player object to the finish object (tentative names). Use the "+
				"arrows keys to move the object. Once you pick a direction, the "+
				"player object continues to move in that direction until it hits "+
				"an object. Press R to restart current level if you're stuck.", 300, 200);
				instr.fontSize = 20;
				instr.y = back.y + 75;
				
			case Credits:
				var back = new MenuText("Back");
				back.fontSize = 20; back.y = 50;
				back.addEventListener(Event.TRIGGERED,
				function(){ setStage(Menu);});

				var cred = new MenuText("Credits\n--------"+
				"\nTemitope Alaga\nRobert Rasmussen\nJordan Harris\n(Add other members names later)",200,200);
				cred.fontSize = 30;
				cred.y = back.y + 200;
				
			case Level:
				addChild(map);
				map.setMap(loadMap.load(Levels.level[currentLevel-1]));	//Level 1 is array index 0.
		}
	}
}

class MenuText extends Button
{
	public function new(s:String,w:Int=100,h:Int=100)
	{
		super(Texture.empty(w,h));

		x = Starling.current.stage.stageWidth/2 - width/2;
		y = Starling.current.stage.stageHeight/2 - height/2;
		text = s;
		Game.game.addChild(this);
	}
}