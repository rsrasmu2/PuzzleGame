import starling.display.Sprite;
import starling.display.Image;

class Obstacle extends Sprite {
	private var obstacleImage:Image;

	public function new(mapX:Int, mapY:Int, planet:String) {
		super();
		
		var chance: Int = Std.random(10);
		if (chance > 4) {
			if (planet == "m") {
				obstacleImage = new Image(Root.assets.getTexture("marsRock.png"));
			} else if (planet == "j") {
				obstacleImage = new Image(Root.assets.getTexture("marsRock.png"));
			} else if (planet == "n") {
				obstacleImage = new Image(Root.assets.getTexture("neptObj"));
			} else if (planet == "s") {
				obstacleImage = new Image(Root.assets.getTexture("planet1"));
			} else if (planet == "u") {
				obstacleImage = new Image(Root.assets.getTexture("neptObj"));
			} else {
				obstacleImage = new Image(Root.assets.getTexture("Obstacle.png"));
			}
		} else {
			if (planet == "m") {
				obstacleImage = new Image(Root.assets.getTexture("marsCrater.png"));
			} else if (planet == "j") {
				obstacleImage = new Image(Root.assets.getTexture("marsCrater.png"));
			} else if (planet == "n") {
				obstacleImage = new Image(Root.assets.getTexture("neptObj2"));
			} else if (planet == "s") {
				obstacleImage = new Image(Root.assets.getTexture("planet2"));
			} else if (planet == "u") {
				obstacleImage = new Image(Root.assets.getTexture("neptObj2"));
			} else {
				obstacleImage = new Image(Root.assets.getTexture("Obstacle.png"));
			}
		}
		addChild(obstacleImage);
		
		x = mapX * GameMap.SPRITE_WIDTH;
		y = mapY * GameMap.SPRITE_HEIGHT;
	}
}