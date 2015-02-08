import starling.display.Sprite;
import starling.display.Image;

class Obstacle extends Sprite {
	private var obstacleImage:Image;

	public function new(mapX:Int, mapY:Int) {
		super();
		
		var chance: Int = Std.random(10);
		if (chance > 4) {
			obstacleImage = new Image(Root.assets.getTexture("marsRock.png"));
		} else {
			obstacleImage = new Image(Root.assets.getTexture("marsCrater.png"));
		}
		addChild(obstacleImage);
		
		x = mapX * GameMap.SPRITE_WIDTH;
		y = mapY * GameMap.SPRITE_HEIGHT;
	}
}