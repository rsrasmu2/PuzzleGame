import starling.display.Sprite;
import starling.display.Image;
import starling.display.Quad;
import starling.events.*;
import flash.ui.Keyboard;


class GameMap extends Sprite {
	public inline static var SPRITE_WIDTH = 32;
	public inline static var SPRITE_HEIGHT = 32;

	//NOTE: The convention to access map coordinate from this array is mapArr[y][x], NOT mapArr[x][y] 
	private var mapArr : Array<Array<Int>>;
	
	private var player : Player;
	
	public function new() {
		super();
		
		addEventListener(KeyboardEvent.KEY_DOWN, checkInput);
		
		//0 = empty
		//1 = obstacle
		//2 = player
		mapArr = [[1,0,0,0,0,0,0,0,0,0,1],
				  [0,0,0,0,0,0,0,0,0,0,0],
				  [0,2,0,0,0,1,0,0,0,0,0],
				  [0,0,0,0,0,0,0,0,0,0,0],
				  [0,0,0,0,1,0,0,0,0,0,0],
				  [0,0,0,0,0,0,0,0,0,0,0],
				  [0,0,0,0,0,0,0,0,0,0,0],
				  [0,0,0,0,0,0,0,0,0,0,0],
				  [0,0,0,0,0,0,0,0,0,0,0],
				  [0,0,0,0,0,0,0,0,0,0,0],
                  [0,0,0,0,0,0,0,0,0,0,0],
                  [1,0,0,0,0,0,0,0,0,0,1]];
				  
		//Center the map
		var quad = new Quad(mapArr[0].length * SPRITE_WIDTH, mapArr.length * SPRITE_HEIGHT, 0xffffff);
		x = flash.Lib.current.stage.stageWidth / 2 - (quad.width / 2);
		y = flash.Lib.current.stage.stageHeight / 2 - (quad.height / 2);
				  
		generateSprites();
		}
	
	public function generateSprites() {
		removeChildren();
		
		if (mapArr.length > 0 && mapArr[0].length > 0) {
			for (y in 0...mapArr.length) {
				for (x in 0...mapArr[0].length) {
					switch mapArr[y][x] {
						case 1:
							createObstacle(x, y);
						case 2:
							createPlayer(x, y);
					}
				}
			}
		} else {
			trace("Error: mapArr dimensions must be greater than 0");
		}
	}
	
	private function createPlayer(x:Int, y:Int) {
		player = new Player(x, y);
		addChild(player);
	}
	
	private function createObstacle(x:Int, y:Int) {
		addChild(new Obstacle(x, y));
	}
	
	private function checkInput(e:KeyboardEvent) {
		if (e.keyCode == Keyboard.LEFT) {
			playerMovementScan(-1, 0);
		}
	
		if (e.keyCode == Keyboard.RIGHT) {
			playerMovementScan(1, 0);
		}
		
		if (e.keyCode == Keyboard.UP) {
			playerMovementScan(0, -1);
		}
		
		if (e.keyCode == Keyboard.DOWN) {
			playerMovementScan(0, 1);
		}
	}
	
	private function playerMovementScan(dirX:Int, dirY:Int) {
		var currentX:Int = player.mapX;
		var currentY:Int = player.mapY;
		
		//This could be cleaned up a bit if anyone is bored. Makes sure we're within the map bounds and that the next space is empty.
		while (currentX+dirX >= 0 && currentX+dirX < mapArr[currentY].length && currentY+dirY >= 0 && currentY+dirY < mapArr.length && mapArr[currentY+dirY][currentX+dirX] == 0) {
			currentX += dirX;
			currentY += dirY;
		}
		
		movePlayer(currentX, currentY);
	}
	
	private function movePlayer(mapX:Int, mapY:Int) {
		//player's previous position is set to 0 and its new position is set to 2.
		mapArr[player.mapY][player.mapX] = 0;
		mapArr[mapY][mapX] = 2;
		player.moveTo(mapX, mapY);
	}
}