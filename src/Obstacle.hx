import starling.display.Sprite;
import starling.display.Image;

class Obstacle extends Sprite {
	private var obstacleImage:Image;

	public function new(mapX:Int, mapY:Int) {
		super();
		
		obstacleImage = new Image(Root.assets.getTexture("Obstacle"));
		addChild(obstacleImage);
		
		x = mapX * GameMap.SPRITE_WIDTH;
		y = mapY * GameMap.SPRITE_HEIGHT;
	}
}