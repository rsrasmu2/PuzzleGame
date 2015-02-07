import starling.display.Sprite;
import starling.display.Image;
import starling.display.Quad;
import starling.events.*;
import flash.ui.Keyboard;
import starling.core.*;

class GameMap extends Sprite {
	public inline static var SPRITE_WIDTH = 32;
	public inline static var SPRITE_HEIGHT = 32;

	//NOTE: The convention to access map coordinate from this array is mapArr[y][x], NOT mapArr[x][y]
	private var mapArr : Array<Array<Int>>;

	private var player : Player;

	public function new(?map : Array<Array<Int>>) {
		super();

		addEventListener(KeyboardEvent.KEY_DOWN, checkInput);

		//0 = empty
		//1 = obstacle
		//2 = player
		//3 = finish
		mapArr = (map == null) ? [
		[0,0,0,0,0,0,0,1,0,0,0],
		[0,0,3,0,0,0,0,0,0,0,0],
		[0,2,0,0,0,1,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,1,0,0],
		[0,0,0,0,1,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0,0]] : map;

		//Center the map
		var quad = new Quad(mapArr[0].length * SPRITE_WIDTH, mapArr.length * SPRITE_HEIGHT);
		x = Starling.current.stage.stageWidth / 2 - (quad.width / 2);
		y = Starling.current.stage.stageHeight / 2 - (quad.height / 2);

		//generate background
		quad.color = 0;
		quad.alpha = 0.75;
		addChild(quad);

		//generate grid
		var h = 0; var w = 0;
		while(h <= mapArr.length * SPRITE_HEIGHT)//horizontal lines
		{
			var line = new Quad(quad.width,2.5);
			line.y = h;
			h += SPRITE_HEIGHT;
			line.alpha = 0.75;
			addChild(line);
		}
		while(w <= mapArr[0].length * SPRITE_WIDTH)//vertical lines
		{
			var line = new Quad(2.5,quad.height);
			line.x = w;
			w += SPRITE_WIDTH;
			line.alpha = 0.75;
			addChild(line);
		}

		generateSprites();
		//make sure your level has a player!!!
		if(player == null){
			trace("This level doens't have a player! Error will occur if you try to move the player");
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
	}

	private function createPlayer(x:Int, y:Int) {
		player = new Player(x, y);
		addEventListener("playerMoveFinished", onPlayerMoveFinished);
		addChild(player);
	}

	private function createObstacle(x:Int, y:Int) {
		addChild(new Obstacle(x, y));
	}

	private function createFinish(x:Int, y:Int) {
		addChild(new Finish(x, y));
	}

	private function checkInput(e:KeyboardEvent) {
		switch (e.keyCode)
		{
			case Keyboard.LEFT:
				playerMovementScan(-1, 0);
			case Keyboard.RIGHT:
				playerMovementScan(1, 0);
			case Keyboard.UP:
				playerMovementScan(0, -1);
			case Keyboard.DOWN:
				playerMovementScan(0, 1);
			case Keyboard.R:
				player.restart();
		}
	}

	private function playerMovementScan(dirX:Int, dirY:Int) {
		if (player.movable) {
			var currentX:Int = player.mapX;
			var currentY:Int = player.mapY;
			var distance:Int = 0;

			/*This could be cleaned up a bit if anyone is bored. Makes sure we're within
			the map bounds and that the next space isn't an obstacle.*/
			while (currentX+dirX >= 0 && currentX+dirX < mapArr[currentY].length && currentY+dirY >= 0
			&& currentY+dirY < mapArr.length && mapArr[currentY+dirY][currentX+dirX] != 1) {
				currentX += dirX;
				currentY += dirY;
				distance += 1;

				//We've hit the goal!
				if (mapArr[currentY][currentX] == 3) {
					break;
				}
			}

			player.moveTo(currentX, currentY, distance);
		}
	}

	private function onPlayerMoveFinished(e:Event) {
		if (mapArr[player.mapY][player.mapX] == 3) {
			trace("Victory!");
			dispatchEvent(new Event(Game.ON_COMPLETE));
		}
	}
}