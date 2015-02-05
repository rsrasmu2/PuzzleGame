import starling.display.Sprite;
import starling.display.Image;
import starling.events.*;
import flash.ui.Keyboard;


class GameMap extends Sprite {
	private var mapArr : Array<Array<Int>>;
	
	private var player : Player;
	
	public function new() {
		super();
		
		addEventListener(KeyboardEvent.KEY_DOWN, checkInput);
		
		//0 = empty
		//1 = obstacle
		//2 = player
		mapArr = [[0,0,0,0,0,0,0],
				  [0,0,0,0,0,0,0],
				  [0,2,0,0,0,1,0],
				  [0,0,0,0,0,0,0],
				  [0,0,0,0,1,0,0]];
				  
		generateSprites();
	}
	
	public function generateSprites() {
		removeChildren();
	
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
		
		while (currentX+dirX >= 0 && currentX+dirX < mapArr[currentY].length && currentY+dirY >= 0 && currentY+dirY < mapArr.length && mapArr[currentY+dirY][currentX+dirX] == 0) {
			currentX += dirX;
			currentY += dirY;
		}
		
		movePlayer(currentX, currentY);
	}
	
	private function movePlayer(mapX:Int, mapY:Int) {
		mapArr[player.mapY][player.mapX] = 0;
		mapArr[mapY][mapX] = 2;
		player.moveTo(mapX, mapY);
	}
}