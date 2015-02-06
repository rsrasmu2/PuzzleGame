import starling.display.Sprite;
import starling.display.Image;
import starling.core.Starling;
import starling.animation.Transitions;
import starling.animation.Tween;

class Player extends Sprite {
	//player's array coords
	public var mapX:Int;
	public var mapY:Int;
	
	public var movable = true;

	private var playerImage:Image;
	
	//the higher the speed, the faster the movement
	private inline static var PLAYER_SPEED = 6.0;
	
	private var gameMap:GameMap;
	
	public function new(mapX:Int, mapY:Int, gameMap:GameMap) {
		super();
	
		this.mapX = mapX;
		this.mapY = mapY;
		this.gameMap = gameMap;
		
		playerImage = new Image(Root.assets.getTexture("Player"));
		addChild(playerImage);
		
		x = getWorldX();
		y = getWorldY();
	}
	
	public function moveTo(mapX:Int, mapY:Int, time:Float) {
		this.mapX = mapX;
		this.mapY = mapY;
		updateWorldPosition(time / PLAYER_SPEED);
	}
	
	public function getWorldX() {
		return mapX * GameMap.SPRITE_WIDTH;
	}
	
	public function getWorldY() {
		return mapY * GameMap.SPRITE_HEIGHT;
	}
	
	private function updateWorldPosition(time:Float) {
		movable = false;
		Starling.juggler.tween(this, time, { transition: Transitions.LINEAR,
			x: getWorldX(),
			y: getWorldY(),
			onComplete: function() {
				gameMap.checkVictory();
				movable = true;
			}
		});
	}
}