import flash.system.ImageDecodingPolicy;
import starling.display.*;
import starling.core.*;
import starling.textures.Texture;
import starling.events.*;
import starling.text.TextField;
import starling.animation.Transitions;
import starling.animation.Tween;
import flash.utils.Timer;
import flash.events.TimerEvent;

enum GameState
{
	Menu;
	Instructions;
	Credits;
	LevelSelect;
	Mars;
	Jupiter;
	Saturn;
	Neptune;
	Uranus;
	Level;
}

class Game extends Sprite
{
	private var unlocked = 0;
	private var currentLevel = 1;
	private var bg:Background;

	//Hold the images of the crew members
	private var crew : Array<Image>;

	public function new(root : Root )
	{
		super();
		bg = new Background();
		addChild(bg);
		
		unlocked = LoadUnlocked.load();

		//Load the crew sprites
		crew = new Array();
		crew.push(new Image(Root.assets.getTexture("bobby")));
		crew.push(new Image(Root.assets.getTexture("cherie")));
		crew.push(new Image(Root.assets.getTexture("jordan")));
		crew.push(new Image(Root.assets.getTexture("nancy")));
		crew.push(new Image(Root.assets.getTexture("temitope")));

		//Create the crew members and draw them to the screen in the correct spot
		for (i in 0...crew.length) {
			crew[i].x = i * 20 + 50;
			crew[i].y = 35;
		}

		//based on game state
		setStage(Menu);
	}

	public function nextLevel()
	{
		++currentLevel;
		if (currentLevel > Levels.level.length) {
			removeChildren(1);
			var Win:TextField =
			new TextField(200, 50, "You Win!", "Arial", 28, 0xffffff);
			Win.x = Starling.current.stage.stageWidth/2 - Win.width/2;  // horizontal alignment
			Win.y = Starling.current.stage.stageHeight/2 - Win.height/2;  // vertical alignment
			addChild(Win);
			var timer = new Timer(1000,3);
			timer.start();
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, function(e:TimerEvent)
			{	reset();});
		} else {
			if (currentLevel > unlocked)
				unlocked = currentLevel;
				LoadUnlocked.save(unlocked);
			setStage(Level);
		}
	}

	public function reset()
	{	setStage(Menu);}

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
				play.addEventListener(Event.TRIGGERED,
				function(){
					setStage(LevelSelect);
				});
				addChild(play);

				var instr = new MenuButton("Instructions");
				instr.y = play.y + 100;
				instr.addEventListener(Event.TRIGGERED,
				function(){	setStage(Instructions);});
				addChild(instr);

				var cred = new MenuButton("Credits");
				cred.y = instr.y + 100;
				cred.addEventListener(Event.TRIGGERED,
				function(){	setStage(Credits);});
				addChild(cred);

			case Instructions:
				var title = new MenuText(200,200,"How To Play");
				title.fontSize = 50;
				title.y = 0;
				addChild(title);

				var back = new MenuButton("Back");
				back.y = title.y + 200;
				back.addEventListener(Event.TRIGGERED,
				function(){ setStage(Menu);});
				addChild(back);

				var instr = new MenuText(400,400,"The goal of the game is to move the "+
				"rover over to the flag. Tap the sides of the screen to move the rover. "+
				" Once you pick a direction, the rover continues to move in that direction until it hits "+
				"an object. But, be careful not to go off the edge of the screen or else you'll lose " +
				"one of your crew members. If you lose them all, it's game over. ");
				//"Press R to restart the current level if you're stuck (This will cost you a crew member). "+
				//"Press the Escape Key to go back to the main menu.");
				instr.fontSize = 18;
				instr.x = Starling.current.stage.stageWidth/2 - instr.width/2;
				instr.y = back.y + 75;
				addChild(instr);

			case Credits:
				var title = new MenuText(200,200,"Credits");
				title.fontSize = 50;
				title.y = 0;
				addChild(title);
				
				var back = new MenuButton("Back");
				back.y = title.y + 200;
				back.addEventListener(Event.TRIGGERED,
				function(){ setStage(Menu);});
				addChild(back);

				var cred = new MenuText(300,300,"\nTemitope Alaga\nJordan Harris\nNancy McCollough\nCherie Parsons\nRobert Rasmussen");
				cred.fontSize = 20;
				cred.y = back.y + 75;
				cred.x = Starling.current.stage.stageWidth/2 - cred.width/2;
				addChild(cred);
				
				
			case LevelSelect:
				
				var back = new MenuButton("Back");
				back.y = 50;
				back.addEventListener(Event.TRIGGERED,
				function(){ setStage(Menu);});
				addChild(back);
				
				var x = 0;
				var y = 0;
				
				var mars = new MenuButton("Mars");
				mars.x = (Starling.current.stage.stageWidth - mars.width)/2 - mars.width - 5;
				mars.y = (Starling.current.stage.stageHeight - mars.height) / 2;
				mars.addEventListener(Event.TRIGGERED,
				function(){ setStage(Mars);});
				addChild(mars);
				
				var jupiter = new MenuButton("Jupiter");
				jupiter.x = (Starling.current.stage.stageWidth - jupiter.width) / 2;
				jupiter.y = (Starling.current.stage.stageHeight - jupiter.height) / 2;
				jupiter.addEventListener(Event.TRIGGERED,
				function(){ setStage(Jupiter);});
				addChild(jupiter);
				
				var saturn = new MenuButton("Saturn");
				saturn.x = (Starling.current.stage.stageWidth - saturn.width) / 2 + saturn.width + 5;
				saturn.y = (Starling.current.stage.stageHeight - saturn.height) / 2;
				saturn.addEventListener(Event.TRIGGERED,
				function(){ setStage(Saturn);});
				addChild(saturn);
				
				var neptune = new MenuButton("Neptune");
				neptune.x = (Starling.current.stage.stageWidth) / 2 - neptune.width - 2.5;
				neptune.y = (Starling.current.stage.stageHeight + neptune.height) / 2 + 5;
				neptune.addEventListener(Event.TRIGGERED,
				function(){ setStage(Neptune);});
				addChild(neptune);
				
				var uranus = new MenuButton("Uranus");
				uranus.x = (Starling.current.stage.stageWidth) / 2 + 2.5;
				uranus.y = (Starling.current.stage.stageHeight + uranus.height) / 2 + 5;
				uranus.addEventListener(Event.TRIGGERED,
				function(){ setStage(Uranus);});
				addChild(uranus);
				
				
			case Mars:
				
				var back = new MenuButton("Back");
				back.y = 50;
				back.addEventListener(Event.TRIGGERED,
				function(){ setStage(LevelSelect);});
				addChild(back);
				
				var y = 1;
				for (i in 0...Levels.level.length)
				{
					if (Levels.level[i].charAt(0) == 'm')
					{
						if (i == y * 3)
						{
							y++;
						}
						
						var button = new MenuButton("Level " + (i+1));
						button.x = (Starling.current.stage.stageWidth - button.width) / 2 + (10 + button.width) * ((i % 3) - 1);
						button.y = back.y + 100 + (10 + button.height) * y;
						if (i > unlocked)
						{
							button.text = "Locked";
						}
						else
						{
							button.addEventListener(Event.TRIGGERED,
							function() { currentLevel = i; setStage(Level); } );
						}
						addChild(button);
					}
				}
				
			case Jupiter:
				
				var back = new MenuButton("Back");
				back.y = 50;
				back.addEventListener(Event.TRIGGERED,
				function(){ setStage(LevelSelect);});
				addChild(back);
				
				var y = 1;
				for (i in 0...Levels.level.length)
				{
					if (Levels.level[i].charAt(0) == 'j')
					{
						if (i == y * 3)
						{
							y++;
						}
						
						var button = new MenuButton("Level " + (i+1));
						button.x = (Starling.current.stage.stageWidth - button.width) / 2 + (10 + button.width) * ((i % 3) - 1);
						button.y = back.y + 100 + (10 + button.height) * y;
						if (i > unlocked)
						{
							button.text = "Locked";
						}
						else
						{
							button.addEventListener(Event.TRIGGERED,
							function() { currentLevel = i; setStage(Level); } );
						}
						addChild(button);
					}
				}
				
			case Saturn:
				
				var back = new MenuButton("Back");
				back.y = 50;
				back.addEventListener(Event.TRIGGERED,
				function(){ setStage(LevelSelect);});
				addChild(back);
				
				var y = 1;
				for (i in 0...Levels.level.length)
				{
					if (Levels.level[i].charAt(0) == 's')
					{
						if (i == y * 3)
						{
							y++;
						}
						
						var button = new MenuButton("Level " + (i+1));
						button.x = (Starling.current.stage.stageWidth - button.width) / 2 + (10 + button.width) * ((i % 3) - 1);
						button.y = back.y + 100 + (10 + button.height) * y;
						if (i > unlocked)
						{
							button.text = "Locked";
						}
						else
						{
							button.addEventListener(Event.TRIGGERED,
							function() { currentLevel = i; setStage(Level); } );
						}
						addChild(button);
					}
				}
				
			case Neptune:
				
				var back = new MenuButton("Back");
				back.y = 50;
				back.addEventListener(Event.TRIGGERED,
				function(){ setStage(LevelSelect);});
				addChild(back);
				
				var y = 1;
				for (i in 0...Levels.level.length)
				{
					if (Levels.level[i].charAt(0) == 'n')
					{
						if (i == y * 3)
						{
							y++;
						}
						
						var button = new MenuButton("Level " + (i+1));
						button.x = (Starling.current.stage.stageWidth - button.width) / 2 + (10 + button.width) * ((i % 3) - 1);
						button.y = back.y + 100 + (10 + button.height) * y;
						if (i > unlocked)
						{
							button.text = "Locked";
						}
						else
						{
							button.addEventListener(Event.TRIGGERED,
							function() { currentLevel = i; setStage(Level); } );
						}
						addChild(button);
					}
				}
				
			case Uranus:
				
				var back = new MenuButton("Back");
				back.y = 50;
				back.addEventListener(Event.TRIGGERED,
				function(){ setStage(LevelSelect);});
				addChild(back);
				
				var y = 1;
				for (i in 0...Levels.level.length)
				{
					if (Levels.level[i].charAt(0) == 'u')
					{
						trace(i);
						if (i == y * 3)
						{
							y++;
						}
						
						var button = new MenuButton("Level " + (i+1));
						button.x = (Starling.current.stage.stageWidth - button.width) / 2 + (10 + button.width) * ((i % 3) - 1);
						button.y = back.y + 100 + (10 + button.height) * y;
						if (i > unlocked)
						{
							button.text = "Locked";
						}
						else
						{
							button.addEventListener(Event.TRIGGERED,
							function() { currentLevel = i; setStage(Level); } );
						}
						addChild(button);
					}
				}

			case Level:
				//reset lives if starting at the first level
				if (currentLevel == 0) GameMap.reset();

				//Level 1 is at array index 0.
				addChild(new GameMap(Levels.level[currentLevel]));
		}
	}
	//Used to get the crew in the GameMap class
	public function getCrew(?i:Int) : Dynamic{
		return i == null ? crew : crew[i];
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
		
		scaleX = .75;
		scaleY = .75;
		
		x = Starling.current.stage.stageWidth/2 - width/2;
		y = Starling.current.stage.stageHeight / 2 - height / 2;
		text = s;
		color = 0;
		fontColor = 0xffff00;
		fontSize = 25;

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