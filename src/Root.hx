import starling.display.Sprite;
import starling.utils.AssetManager;
import starling.core.Starling;
import starling.animation.Transitions;

class Root extends Sprite {
	
	public static var assets:AssetManager;
	
	public var map:GameMap;
	public var game:Game;
	
	
	public function new() {
		super();
	}
	
	public function start(startup:Startup) {
		assets = new AssetManager();
		//assets.enqueue("assets/Player.png");
		assets.enqueue("assets/Obstacle.png", "assets/flag.png");
		
		assets.enqueue("assets/playerSprites.png", "assets/playerSprites.xml");
		
		assets.enqueue("assets/star_assets.png", "assets/star_assets.xml");
		
		assets.enqueue("assets/Mars/marsObstacles.png", "assets/Mars/marsObstacles.xml");
		assets.enqueue("assets/neptune2.png", "assets/neptune1.png");
		assets.enqueue("assets/saturn1.png", "assets/saturn2.png");
		
		
		assets.enqueue("assets/crew/bobby.png", "assets/crew/cherie.png", "assets/crew/jordan.png");
		assets.enqueue("assets/crew/nancy.png", "assets/crew/temitope.png", "assets/crew/shadow.png");
		
		assets.enqueue("assets/Button.png");
		
		//Load the level assets
		for (i in 0...Levels.level.length) {
			assets.enqueue("assets/Levels/" + Levels.level[i] + ".txt");
		}
		
		assets.loadQueue(function onProgress(ratio:Float) {
			if (ratio == 1) {
				Starling.juggler.tween(startup.loadingBitmap, 2.0, {
					transition:Transitions.EASE_OUT, delay:0, alpha: 0, onComplete: function(){
						startup.removeChild(startup.loadingBitmap);
						
						game = new Game();
						addChild(game);
					}
				});
			}
		});
	}
}