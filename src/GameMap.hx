import haxe.io.Eof;
import starling.display.Sprite;
import starling.display.Image;
import starling.display.Quad;
import starling.events.*;
import starling.utils.AssetManager;
import flash.ui.Keyboard;
import starling.core.Starling;
import starling.text.TextField;
import flash.utils.Timer;
import flash.events.TimerEvent;

class GameMap extends Sprite {
	public inline static var SPRITE_WIDTH = 32;
	public inline static var SPRITE_HEIGHT = 32;

	//for player movement event
	public inline static var MOVE_DONE = "playerMoveFinished";

	//NOTE: The convention to access map coordinate from this array is mapArr[y][x], NOT mapArr[x][y]
	private var mapArr : Array<Array<Int>>;

	private var player : Player;

	private static var lives = 5;

	private var crew : Array<Image>;
	private var spaceship : Image;

	private var bg : Image;
	private var planet:String;

	public function new(s:String) {
		super();
		addEventListener(KeyboardEvent.KEY_DOWN, checkInput);
		planet = s.charAt(0);
		setMap(LoadMap.load(s));
	}

	public static function reset()
	{
		//resets lives if starting at level 1
		lives = 5;
	}

	private function setMap(map : Array<Array<Int>>) {
		removeChildren();
		mapArr = map;

		//Center the map
		var quad = new Quad(mapArr[0].length * SPRITE_WIDTH, mapArr.length * SPRITE_HEIGHT);
		x = Starling.current.stage.stageWidth / 2 - (quad.width / 2);
		y = Starling.current.stage.stageHeight / 2 - (quad.height / 2);

		//generate background
		quad.color = 0;
		quad.alpha = 0.5;
		addChild(quad);

		bg = getBG();
		bg.scaleX = 2.2;
		bg.scaleY = 2.2;
		bg.x = (quad.width/2) - (bg.width / 2);
		bg.y = (quad.height / 2) - (bg.height / 2);
		addChild(bg);


		//generate grid
		var h = 0; var w = 0;
		while(h <= mapArr.length * SPRITE_HEIGHT)//horizontal lines
		{
			var line = new Quad(quad.width,2.5);
			line.y = h;
			h += SPRITE_HEIGHT;
			line.color = 0;
			addChild(line);
		}
		while(w <= mapArr[0].length * SPRITE_WIDTH)//vertical lines
		{
			var line = new Quad(2.5,quad.height);
			line.x = w;
			w += SPRITE_WIDTH;
			line.color = 0;
			addChild(line);
		}

		generateSprites();
		//make sure your level has a player!!!
		if(player == null){
			trace("This level doesn't have a player! Error will occur if you try to move the player");
		}
	}

	private function generateSprites() {
		if (mapArr.length > 0 && mapArr[0].length > 0) {
			for (y in 0...mapArr.length) {
				for (x in 0...mapArr[0].length) {
					switch mapArr[y][x] {
						case 1:
							createObstacle(x, y);
						case 2:
							createPlayer(x, y);
						case 3:
							createFinish(x, y);
					}
				}
			}
		} else {
			trace("Error: mapArr dimensions must be greater than 0");
		}
		addChild(player); //Added at the end so it moves on top of everything else;

		//Add the spaceship behind the crew sprites
		spaceship = new Image(Root.assets.getTexture("spaceship"));
		spaceship.x = -50;
		spaceship.y = -85;
		addChild(spaceship);
		//Add the lives number of crew members
		for(i in 0...lives)
			addChild(Root.game.getCrew(i));
	}

	private function createPlayer(x:Int, y:Int) {
		player = new Player(x, y);
		addEventListener(MOVE_DONE, onPlayerMoveFinished);
	}

	private function createObstacle(x:Int, y:Int) {
		addChild(new Obstacle(x, y, planet));
	}

	private function createFinish(x:Int, y:Int) {
		addChild(new Finish(x, y));
	}

	private function checkInput(e:KeyboardEvent) {
		//ignore event if the player is in the middle of moving
		if(!player.movable) return;
		switch (e.keyCode)
		{
			case Keyboard.LEFT:
				playerMovementScan( -1, 0);
				player.changeTexture(3);
			case Keyboard.RIGHT:
				playerMovementScan(1, 0);
				player.changeTexture(1);
			case Keyboard.UP:
				playerMovementScan(0, -1);
				player.changeTexture(2);
			case Keyboard.DOWN:
				playerMovementScan(0, 1);
				player.changeTexture(0);
			case Keyboard.R:
				//restarts, but costs a life
				if(lives > 1) loseLife();
			case Keyboard.ESCAPE:
				Root.game.reset();
		}
	}

	var flag:Bool = false;

	private function playerMovementScan(dirX:Int, dirY:Int) {
		var currentX:Int = player.mapX;
		var currentY:Int = player.mapY;
		var distance:Int = 0;

		/*This could be cleaned up a bit if anyone is bored. Makes sure we're within
		the map bounds and that the next space isn't an obstacle.*/
		while (currentX+dirX >= 0 && currentY+dirY >= 0 && mapArr[currentY+dirY][currentX+dirX] != 1) {
			currentX += dirX;
			currentY += dirY;
			++distance;

			//We've hit an edge!
			if (currentX + dirX < 0 || currentY + dirY < 0 || currentX + dirX == mapArr[currentY].length || currentY + dirY == mapArr.length) {
				flag = true;
				break;
			}

			//We've hit the goal!
			if (mapArr[currentY][currentX] == 3) {
				break;
			}
		}

		if (flag) {
				player.moveTo(currentX, currentY, distance);
		} else {
			player.moveTo(currentX, currentY, distance);
		}
	}

	private function onPlayerMoveFinished(e:Event) {
		if (mapArr[player.mapY][player.mapX] == 3) {
			Root.game.nextLevel();
		}
		if (flag) {
			loseLife();
			flag = false;
		}
	}

	private function loseLife(){
		player.restart();
		--lives;
		if (lives == 0) {
			//Game Over
			removeChildren();
			removeEventListeners();
			var gameover:TextField =
			new TextField(200, 50, "Game Over", "Arial", 28, 0xff0000);
			gameover.x = Starling.current.stage.stageWidth/2 - gameover.width/2;  // horizontal alignment
			gameover.y = Starling.current.stage.stageHeight/2 - gameover.height/2;  // vertical alignment
			Root.game.addChild(gameover);
			var timer = new Timer(1000,3);
			timer.start();
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, function(e:TimerEvent)
			{	Root.game.reset();});
		}
		else {
			if(lives == 1){
				var text = new TextField(200,50,"One member left!!!","Arial",20,0xff0000);
				text.x = -(Starling.current.stage.stageWidth / 2 - (mapArr[0].length * SPRITE_WIDTH / 2));
				text.y = -(Starling.current.stage.stageHeight / 2 - (mapArr.length * SPRITE_HEIGHT / 2));
				addChild(text);
			}
			//remove the last crew member
			removeChild(Root.game.getCrew(lives));
		}
	}

	//Gets the background image depending on the current level
	//Needs to be updated with the new level backgrounds
	private function getBG() {
		switch (planet) {
			case 'm':
				return new Image(Root.assets.getTexture("mars_bg"));
			case 'j':
				return new Image(Root.assets.getTexture("jupiter_bg"));
			case 'n':
				return new Image(Root.assets.getTexture("neptune_bg"));
			case 's':
				return new Image(Root.assets.getTexture("saturn_bg"));
			case 'u':
				return new Image(Root.assets.getTexture("uranus_bg"));
		}
		return new Image(Root.assets.getTexture("mars_bg"));
	}
}