import starling.display.Sprite;
import starling.utils.AssetManager;
import starling.core.Starling;
import starling.animation.Transitions;
import flash.media.SoundChannel;
import flash.events.Event;

class Root extends Sprite {

	public static var assets:AssetManager;

	public var map:GameMap;
	public var game:Game;
	public var music:SoundChannel;

	public function new() {
		super();
	}

	public function start(startup:Startup) {
		assets = new AssetManager();
		
		assets.enqueue("assets/sprites.png", "assets/sprites.xml");
		assets.enqueue("assets/star_assets.png", "assets/star_assets.xml");
		assets.enqueue("assets/PuzzleGame.mp3");

		//Load the level assets
		for (i in 0...Levels.level.length) {
			assets.enqueue("assets/Levels/" + Levels.level[i] + ".txt");
		}

		assets.loadQueue(function onProgress(ratio:Float) {
			// animate the ship floating up
			Starling.juggler.tween(startup.crewBitmap, 2, {
				transition:Transitions.LINEAR, delay:.2, y: startup.crewBitmap.y - 18
			});
			
			// animate the ship floating down
			Starling.juggler.tween(startup.crewBitmap, 2, {
				transition:Transitions.LINEAR, delay:1.2, y: startup.crewBitmap.y + 18
			});
			
			if (ratio == 1) {
				// animate the ship flying away
				Starling.juggler.tween(startup.crewBitmap, 2, {
					transition:Transitions.EASE_IN, delay:2, x: Starling.current.stage.stageWidth
				});
				
				// fade the loading screen, start game
				Starling.juggler.tween(startup.loadingBitmap, 1.6, {
					transition:Transitions.EASE_OUT, delay:3, alpha:0, onComplete: function() {
						startup.removeChild(startup.loadingBitmap);
						startup.removeChild(startup.crewBitmap);

						game = new Game();
						addChild(game);
						music = assets.playSound("PuzzleGame");
						music.addEventListener(Event.SOUND_COMPLETE, loopMusic);
					}
				});
			
				
				
		} });
	}

	private function loopMusic(e:Event)
	{
		music = assets.playSound("PuzzleGame");
		if(!music.hasEventListener(Event.SOUND_COMPLETE))
			music.addEventListener(Event.SOUND_COMPLETE,loopMusic);
	}
}