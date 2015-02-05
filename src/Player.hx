import starling.display.Sprite;
import starling.display.Image;

class Player extends Sprite {
	//player's array coords
	public var mapX:Int;
	public var mapY:Int;

	private var playerImage:Image;
	
	public function new(mapX:Int, mapY:Int) {
		super();
	
		this.mapX = mapX;
		this.mapY = mapY;
		
		playerImage = new Image(Root.assets.getTexture("Player"));
		addChild(playerImage);
		
		updateWorldCoords();
	}
	
	public function moveTo(mapX:Int, mapY:Int) {
		this.mapX = mapX;
		this.mapY = mapY;
		updateWorldCoords();
	}
	
	private function updateWorldCoords() {
		x = mapX * width;
		y = mapY * height;
	}
}