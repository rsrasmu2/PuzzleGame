import starling.display.Sprite;
import starling.display.Image;

class Obstacle extends Sprite {
	private var obstacleImage:Image;

	public function new(x:Int, y:Int) {
		super();
		
		this.x = x * 32;
		this.y = y * 32;
		
		obstacleImage = new Image(Root.assets.getTexture("Obstacle"));
		addChild(obstacleImage);
	}
}