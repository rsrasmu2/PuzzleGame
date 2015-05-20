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

		this.mapX = this.constX = mapX;
		this.mapY = this.constY = mapY;

		playerImage = new Image(Root.assets.getTexture("playerDown"));
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
				parent.dispatchEvent(new Event(GameMap.MOVE_DONE, true));
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
		mapX = constX;
		mapY = constY;
		x = getWorldX();
		y = getWorldY();
	}

	//Change the player image depending on the direction going. 0:Down, 1:Right, 2:Up, 3:Left
	//This should only happen when the player starts to move and not while it is moving
	public function changeTexture(choice:Int) {
		removeChild(playerImage);
		switch (choice) {
			case 0:
				playerImage = new Image(Root.assets.getTexture("playerDown"));
			case 1:
				playerImage = new Image(Root.assets.getTexture("playerRight"));
			case 2:
				playerImage = new Image(Root.assets.getTexture("playerUp"));
			case 3:
				playerImage = new Image(Root.assets.getTexture("playerLeft"));
		}
		addChild(playerImage);
	}
}