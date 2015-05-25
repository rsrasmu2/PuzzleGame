import starling.display.*;
import starling.utils.AssetManager;
import starling.core.Starling;
import starling.animation.Transitions;
import starling.events.*;
import flash.media.*;
import starling.display.Button;

class Root extends Sprite {

	public static var assets:AssetManager;

	public static var game:Game;

	public function new() {
		super();
	}

	public function start(startup:Startup) {
		assets = new AssetManager();
		assets.enqueue("assets/sprites.png", "assets/sprites.xml");
		assets.enqueue("assets/star_assets.png", "assets/star_assets.xml");
		assets.enqueue("assets/pixelu.fnt", "assets/pixelu_0.png");
		assets.enqueue("assets/8bitwonder.fnt", "assets/8bitwonder_0.png");
		assets.enqueue("assets/PuzzleGame.mp3");
		assets.enqueue("assets/Lose.mp3");
		assets.enqueue("assets/Win.mp3");
		assets.enqueue("assets/transButton.png");
		assets.enqueue("assets/holder.png");
		assets.enqueue("assets/unlocked.txt");
		
		assets.enqueue("assets/options_bg.png");
		assets.enqueue("assets/options_menu.png");

		//Load the level assets
		for (i in 0...Levels.level.length) {
			assets.enqueue("assets/Levels/" + Levels.level[i] + ".txt");
		}
		
		
		//Check for lost focus of game
		flash.Lib.current.stage.addEventListener(flash.events.Event.DEACTIVATE, lostFocus);
		
		
		
		
		

		assets.loadQueue(function onProgress(ratio:Float) {

			// animate the ship floating up
			Starling.juggler.tween(startup.crewBitmap, 2, {
				transition:Transitions.LINEAR, y: startup.crewBitmap.y - 18
			});

			// animate the ship floating down
			Starling.juggler.tween(startup.crewBitmap, 2, {
				transition:Transitions.LINEAR, delay:.1, y: startup.crewBitmap.y + 18
			});

			if (ratio == 1) {
				// animate the ship flying away
				Starling.juggler.tween(startup.crewBitmap, 1.8, {
					transition:Transitions.EASE_IN, delay:.5,
					x: Starling.current.stage.stageWidth + 2 * startup.crewBitmap.width
				});

				// fade the loading screen, start game
				Starling.juggler.tween(startup.loadingBitmap, 1.0, {
					transition:Transitions.EASE_OUT, delay:1.5, alpha: 0, onComplete: function(){
						startup.removeChild(startup.loadingBitmap);
						startup.removeChild(startup.crewBitmap);

						game = new Game();
						addChild(game);
						
						var options = new Button(Root.assets.getTexture("Button"), "Options");
						options.scaleX = options.scaleY = .5;
						options.fontName = "8bitwonder_0";
						options.x = Starling.current.stage.stageWidth - options.width - 5;
						options.y = 5;
						options.fontSize = 24;
						options.addEventListener(Event.TRIGGERED, function(e:Event)
						{
							game.addChild(new Options());
						});		
						addChild(options);
					}
				});
			}
		});
	}
	
	
	
	
	private function lostFocus(e:flash.events.Event)
	{
		game.setVol(0);
		flash.Lib.current.stage.addEventListener(flash.events.Event.ACTIVATE, onFocus);
		flash.Lib.current.stage.frameRate = 0;
		
		//var st : Starling = new Starling(Root, new flash.display.Stage());
		//st.stop();
	}
	 
	private function onFocus(e:flash.events.Event)
	{
		flash.Lib.current.stage.frameRate = 60;
		game.setVol(LoadStuff.loadVol());
		flash.Lib.current.stage.removeEventListener(flash.events.Event.ACTIVATE, onFocus);
	}
}