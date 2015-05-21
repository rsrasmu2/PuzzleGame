import starling.display.*;
import starling.core.*;
import starling.textures.Texture;
import starling.events.*;
import starling.text.TextField;
import starling.animation.Transitions;
import starling.animation.Tween;
import flash.utils.Timer;
import flash.events.TimerEvent;
import flash.media.*;

enum GameState
{
	Menu;
	Instructions;
	Credits;
	Highscore;
	LevelSelect;
	Mars;
	Jupiter;
	Saturn;
	Neptune;
	Uranus;
	Start;
}

class Game extends Sprite
{
	public var unlocked = 0;
	public var highscore = 0;
	private var scores : Array<Int>;
	public var currentLevel = 1;
	private var bg:Background;
	
	private var music:SoundChannel;
	private var vol:Float;

	//Hold the images of the crew members
	private var crew : Array<Image>;

	public function new()
	{
		super();
		bg = new Background();
		addChild(bg);
		
		unlocked = LoadStuff.loadLevel();
		scores = new Array();
		loadHighScores();

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
	

		vol = .5;
		music = Root.assets.playSound("PuzzleGame");
		music.soundTransform = new SoundTransform(vol);
		music.addEventListener(flash.events.Event.SOUND_COMPLETE, loopMusic);
		
		//based on game state
		setStage(Menu);
	}

	public function nextLevel()
	{
		++currentLevel;
		if (currentLevel >= Levels.level.length) {
			removeChildren(1);
			var win:TextField = new TextField(350, 50, "You Win!", "8bitwonder_0", 28, 0xffffff);
			win.x = Starling.current.stage.stageWidth/2 - win.width/2;  // horizontal alignment
			win.y = Starling.current.stage.stageHeight/2 - win.height/2;  // vertical alignment
			addChild(win);
			
			var score:TextField = new TextField(350, 50, "Score: " + Root.game.highscore, "8bitwonder_0", 35, 0xff0000);
			score.x = win.x;	// horizontal alignment
			score.y = win.y + win.height;	// vertical alignment
			addChild(score);
			
			addToHighScores();
			
			var timer = new Timer(1000,3);
			timer.start();
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, function(e:TimerEvent)
			{	reset();});
		} else {
			if (currentLevel > unlocked)
				unlocked = currentLevel;
				LoadStuff.saveLevel(unlocked);
			setStage(Start);
		}
	}

	public function reset()
	{
		highscore = 0;
		setStage(Menu);
	}

	private function setStage(state : GameState)
	{
		removeChildren();

		switch(state)
		{
			case Menu:
				var title = new MenuText(500,100,"Mission 1 1 3");
				title.fontSize = 50;
				title.y = 50;
				addChild(title);

				var play = new MenuButton("Play");
				play.y = title.y + 100;
				play.addEventListener(Event.TRIGGERED,
				function() {
					if (unlocked >= Levels.level.length)
						currentLevel = unlocked - 1;
					else
						currentLevel = unlocked;
					setStage(Start);
				});
				addChild(play);
				
				var levelSelect = new MenuButton("Levels");
				levelSelect.y = play.y + 100;
				levelSelect.addEventListener(Event.TRIGGERED,
				function(){
					setStage(LevelSelect);
				});
				addChild(levelSelect);

				var instr = new MenuButton("Instructions");
				instr.y = levelSelect.y + 100;
				instr.addEventListener(Event.TRIGGERED,
				function(){	setStage(Instructions);});
				addChild(instr);

				var cred = new MenuButton("Credits");
				cred.y = instr.y + 100;
				cred.addEventListener(Event.TRIGGERED,
				function(){	setStage(Credits);});
				addChild(cred);
				
				var list = new MenuButton("High Scores");
				list.y = cred.y + 100;
				list.addEventListener(Event.TRIGGERED,
				function() { setStage(Highscore); } );
				addChild(list);
				

			case Instructions:
				var title = new MenuText(600,200,"How To Play");
				title.fontSize = 50;
				title.y = 0;
				addChild(title);

				var back = new MenuButton("Back");
				back.y = title.y + 200;
				back.addEventListener(Event.TRIGGERED,
				function(){ setStage(Menu);});
				addChild(back);

				var instr = new MenuText(500,400,"The goal of the game is to move the "+
				"rover over to the flag \n Tap the sides of the screen to move the rover\n "+
				" Once you pick a direction the rover continues to move in that direction until it hits "+
				"an object \n Be careful not to go off the edge of the screen or else you will lose " +
				"one of your crew members \n If you lose them all you lose");
				//"Press R to restart the current level if you're stuck (This will cost you a crew member). "+
				//"Press the Escape Key to go back to the main menu.");
				instr.fontSize = 18;
				instr.x = Starling.current.stage.stageWidth/2 - instr.width/2;
				instr.y = back.y + 75;
				addChild(instr);

			case Credits:
				var title = new MenuText(500,200,"Credits");
				title.fontSize = 50;
				title.y = 0;
				addChild(title);
				
				var back = new MenuButton("Back");
				back.y = title.y + 200;
				back.addEventListener(Event.TRIGGERED,
				function(){ setStage(Menu);});
				addChild(back);

				var cred = new MenuText(500,300,"Jordan Harris\nNancy McCollough\nTemitope Alaga\nCherie Parsons\nRobert Rasmussen");
				cred.fontSize = 20;
				cred.y = back.y + 75;
				cred.x = Starling.current.stage.stageWidth/2 - cred.width/2;
				addChild(cred);
				
				
			case Highscore:
				var title = new MenuText(500,200,"High Scores");
				title.fontSize = 50;
				title.y = 0;
				addChild(title);
				
				var back = new MenuButton("Back");
				back.y = title.y + 200;
				back.addEventListener(Event.TRIGGERED,
				function(){ setStage(Menu);});
				addChild(back);
				
				var scores = new MenuText(500,500, getScores());
				scores.fontSize = 20;
				scores.y = back.y + 75;
				scores.x = (Starling.current.stage.stageWidth - scores.width) / 2;
				addChild(scores);
				
				
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
				
				var back = new MenuButton("Planets");
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
						//button.x = Starling.current.stage.stageWidth / 2 + (10 + button.width) * ((i % 4) - 2); Will do this when there are 4 levels per planet, don't for get to change the if statement above (i == y * #)
						button.y = back.y + 100 + (10 + button.height) * y;
						if (i > unlocked)
						{
							button.text = "Locked";
							button.fontColor = 0xff0000;
						}
						else
						{
							button.addEventListener(Event.TRIGGERED,
							function() { currentLevel = i; setStage(Start); } );
						}
						addChild(button);
					}
				}
				
			case Jupiter:
				
				var back = new MenuButton("Planets");
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
						//button.x = Starling.current.stage.stageWidth / 2 + (10 + button.width) * ((i % 4) - 2); Will do this when there are 4 levels per planet, don't for get to change the if statement above (i == y * #)
						button.y = back.y + 100 + (10 + button.height) * y;
						if (i > unlocked)
						{
							button.text = "Locked";
							button.fontColor = 0xff0000;
						}
						else
						{
							button.addEventListener(Event.TRIGGERED,
							function() { currentLevel = i; setStage(Start); } );
						}
						addChild(button);
					}
				}
				
			case Saturn:
				
				var back = new MenuButton("Planets");
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
						//button.x = Starling.current.stage.stageWidth / 2 + (10 + button.width) * ((i % 4) - 2); Will do this when there are 4 levels per planet, don't for get to change the if statement above (i == y * #)
						button.y = back.y + 100 + (10 + button.height) * y;
						if (i > unlocked)
						{
							button.text = "Locked";
							button.fontColor = 0xff0000;
						}
						else
						{
							button.addEventListener(Event.TRIGGERED,
							function() { currentLevel = i; setStage(Start); } );
						}
						addChild(button);
					}
				}
				
			case Neptune:
				
				var back = new MenuButton("Planets");
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
						//button.x = Starling.current.stage.stageWidth / 2 + (10 + button.width) * ((i % 4) - 2); Will do this when there are 4 levels per planet, don't for get to change the if statement above (i == y * #)
						button.y = back.y + 100 + (10 + button.height) * y;
						if (i > unlocked)
						{
							button.text = "Locked";
							button.fontColor = 0xff0000;
						}
						else
						{
							button.addEventListener(Event.TRIGGERED,
							function() { currentLevel = i; setStage(Start); } );
						}
						addChild(button);
					}
				}
				
			case Uranus:
				
				var back = new MenuButton("Planets");
				back.y = 50;
				back.addEventListener(Event.TRIGGERED,
				function(){ setStage(LevelSelect);});
				addChild(back);
				
				var y = 1;
				for (i in 0...Levels.level.length)
				{
					if (Levels.level[i].charAt(0) == 'u')
					{
						if (i == y * 3)
						{
							y++;
						}
						
						var button = new MenuButton("Level " + (i+1));
						button.x = (Starling.current.stage.stageWidth - button.width) / 2 + (10 + button.width) * ((i % 3) - 1);
						//button.x = Starling.current.stage.stageWidth / 2 + (10 + button.width) * ((i % 4) - 2); Will do this when there are 4 levels per planet, don't for get to change the if statement above (i == y * #)
						button.y = back.y + 100 + (10 + button.height) * y;
						if (i > unlocked)
						{
							button.text = "Locked";
							button.fontColor = 0xff0000;
						}
						else
						{
							button.addEventListener(Event.TRIGGERED,
							function() { currentLevel = i; setStage(Start); } );
						}
						addChild(button);
					}
				}

			case Start:
				//reset lives if starting at the first level
				//if (currentLevel == 0) GameMap.reset();

				//Level 1 is at array index 0.
				addChild(new GameMap(Levels.level[currentLevel]));
		}
	}
	//Used to get the crew in the GameMap class
	public function getCrew(?i:Int) : Dynamic{
		return i == null ? crew : crew[i];
	}
	
	public function getScores() : String
	{
		loadHighScores();
		
		var string = "";
		for (i in 0...scores.length)
		{
			string = string + Std.string(scores[i]) + "\n";
		}
		return string;
	}
	
	public function loadHighScores()
	{
		var temp = LoadStuff.loadScores();
		if (temp == null)
		{
			scores = [for (i in 0...10) 0];
		}
		else
		{
			scores = temp;
		}
	}
	
	public function addToHighScores()
	{
		if (highscore > scores[scores.length - 1])
		{
			scores[scores.length] = highscore;
			var outer = scores.length - 2;
			while (outer > -1)
			{
				if (scores[outer + 1] > scores[outer])
				{
					var temp = scores[outer];
					scores[outer] = scores[outer + 1];
					scores[outer + 1] = temp;
				}
				outer--;
			}
			LoadStuff.saveScores(scores);
		}
	}
	
	
	public function incVol()
	{
		if (vol < 1)
		{
			vol += 0.1;
			music.soundTransform = new SoundTransform(vol);
		}
	}
	public function decVol()
	{
		if(vol > 0)
		{
			vol -= 0.1;
			if (vol < 0) {
				vol = 0;
			}
			music.soundTransform = new SoundTransform(vol);
		}
	}

	private function loopMusic(e:flash.events.Event)
	{
		music = Root.assets.playSound("PuzzleGame");
		music.soundTransform = new SoundTransform(vol);
		if(!music.hasEventListener(flash.events.Event.SOUND_COMPLETE))
			music.addEventListener(flash.events.Event.SOUND_COMPLETE,loopMusic);
	}
}

class MenuText extends TextField
{
	public function new(w:Int,h:Int,s:String)
	{
		super(w,h,s,"8bitwonder_0",12,0xffff00);
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
		y = Starling.current.stage.stageHeight / 2 - height / 2;
		text = s;
		color = 0;
		fontColor = 0xFFFFFF;
		fontSize = 25;
		fontName = "8bitwonder_0";

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