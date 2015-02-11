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
				obstacleImage = new Image(Root.assets.getTexture("jupiter1"));
			} else if (planet == "n") {
				obstacleImage = new Image(Root.assets.getTexture("neptune1"));
			} else if (planet == "s") {
				obstacleImage = new Image(Root.assets.getTexture("saturn1"));
			} else if (planet == "u") {
				obstacleImage = new Image(Root.assets.getTexture("uranus1"));
			} else {
				obstacleImage = new Image(Root.assets.getTexture("marsRock.png"));
			}
		} else {
			if (planet == "m") {
				obstacleImage = new Image(Root.assets.getTexture("marsCrater.png"));
			} else if (planet == "j") {
				obstacleImage = new Image(Root.assets.getTexture("jupiter2"));
			} else if (planet == "n") {
				obstacleImage = new Image(Root.assets.getTexture("neptune2"));
			} else if (planet == "s") {
				obstacleImage = new Image(Root.assets.getTexture("saturn2"));
			} else if (planet == "u") {
				obstacleImage = new Image(Root.assets.getTexture("uranus2"));
			} else {
				obstacleImage = new Image(Root.assets.getTexture("marsCrater.png"));
			}
		}
		addChild(obstacleImage);
		
		x = mapX * GameMap.SPRITE_WIDTH;
		y = mapY * GameMap.SPRITE_HEIGHT;
	}
}