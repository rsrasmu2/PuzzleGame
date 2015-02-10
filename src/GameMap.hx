import haxe.io.Eof;
import starling.display.Sprite;
import starling.display.Image;
import starling.display.Quad;
import starling.events.*;
import flash.ui.Keyboard;
import starling.core.*;

class GameMap extends Sprite {
	public inline static var SPRITE_WIDTH = 32;
	public inline static var SPRITE_HEIGHT = 32;

	//for player movement event
	public inline static var MOVE_DONE = "playerMoveFinished";
	
	public var planet:String;

	//NOTE: The convention to access map coordinate from this array is mapArr[y][x], NOT mapArr[x][y]
	private var mapArr : Array<Array<Int>>;

	private var player : Player;

	public function new() {
		super();
		addEventListener(KeyboardEvent.KEY_DOWN, checkInput);
	}

	public function setMap(map : Array<Array<Int>>) {
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

		//generate grid
		var h = 0; var w = 0;
		while(h <= mapArr.length * SPRITE_HEIGHT)//horizontal lines
		{
			var line = new Quad(quad.width,2.5);
			line.y = h;
			h += SPRITE_HEIGHT;
			line.alpha = 0.5;
			addChild(line);
		}
		while(w <= mapArr[0].length * SPRITE_WIDTH)//vertical lines
		{
			var line = new Quad(2.5,quad.height);
			line.x = w;
			w += SPRITE_WIDTH;
			line.alpha = 0.5;
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
				player.restart();
		}
	}

	private function playerMovementScan(dirX:Int, dirY:Int) {
		var currentX:Int = player.mapX;
		var currentY:Int = player.mapY;
		var distance:Int = 0;

		/*This could be cleaned up a bit if anyone is bored. Makes sure we're within
		the map bounds and that the next space isn't an obstacle.*/
		while (currentX+dirX >= 0 && currentX+dirX < mapArr[currentY].length && currentY+dirY >= 0
		&& currentY+dirY < mapArr.length && mapArr[currentY+dirY][currentX+dirX] != 1) {
			currentX += dirX;
			currentY += dirY;
			++distance;

			//We've hit the goal!
			if (mapArr[currentY][currentX] == 3) {
				break;
			}
		}

		player.moveTo(currentX, currentY, distance);
	}

	private function onPlayerMoveFinished(e:Event) {
		if (mapArr[player.mapY][player.mapX] == 3) {
			dispatchEvent(new Event(Game.ON_COMPLETE));
		}
	}
}