import starling.display.Sprite;
import starling.display.Image;
import starling.core.Starling;
import starling.animation.Transitions;
import starling.animation.Tween;
import starling.events.*;

class Player extends Sprite {
	//player's current array coords
	public var mapX:Int;
	public var mapY:Int;

	//player's initial array coords (for restarting)
	private var constX:Int;
	private var constY:Int;

	public var movable = true;

	private var playerImage:Image;

	//the higher the speed, the faster the movement
	private inline static var PLAYER_SPEED = 6.0;

	public function new(mapX:Int, mapY:Int) {
		super();

		this.mapX = mapX;
		this.mapY = mapY;
		this.mapX = constX = mapX;
		this.mapY = constY = mapY;

		playerImage = new Image(Root.assets.getTexture("Player"));
		addChild(playerImage);

		x = getWorldX();
		y = getWorldY();
	}

	public function moveTo(mapX:Int, mapY:Int, distance:Int) {
		if(distance == 0) {return;}

		this.mapX = mapX;
		this.mapY = mapY;

		//Slides the player to its mapX and mapY coords
		movable = false;
		Starling.juggler.tween(this, (distance / PLAYER_SPEED), { transition: Transitions.LINEAR,
			x: getWorldX(),
			y: getWorldY(),
			onComplete: function() {
				parent.dispatchEvent(new Event("playerMoveFinished"));
				movable = true;
			}
		});
	}

	public function getWorldX() {
		return mapX * GameMap.SPRITE_WIDTH;
	}

	public function getWorldY() {
		return mapY * GameMap.SPRITE_HEIGHT;
	}

	public function restart(){
		if(movable){
			mapX = constX;mapY = constY;
			x = getWorldX(); y = getWorldY();
		}
	}

}