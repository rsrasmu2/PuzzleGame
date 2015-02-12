import starling.display.*;
import starling.utils.AssetManager;
import starling.core.Starling;
import starling.animation.Transitions;
import starling.events.*;
import flash.media.*;

class Root extends Sprite {

	public static var assets:AssetManager;

	public static var game:Game;
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
				Starling.juggler.tween(startup.crewBitmap, 1.8, {
					transition:Transitions.EASE_IN, delay:2, x: Starling.current.stage.stageWidth
				});
				
				// fade the loading screen, start game
				Starling.juggler.tween(startup.loadingBitmap, 1.0, {
					transition:Transitions.EASE_OUT, delay:3, alpha: 0, onComplete: function(){
						startup.removeChild(startup.loadingBitmap);
						startup.removeChild(startup.crewBitmap);
						
						game = new Game();
						addChild(game);
						music = assets.playSound("PuzzleGame");
						music.addEventListener(flash.events.Event.SOUND_COMPLETE, loopMusic);

						var dec = new Button(Root.assets.getTexture("Button"));
						dec.scaleX = dec.scaleY = 0.5;
						dec.color = 0x222222;
						dec.text = "<";
						dec.fontColor = 0xffff00;
						dec.fontSize = 30;
						dec.x = Starling.current.stage.stageWidth - dec.width * 2;
						dec.addEventListener(Event.TRIGGERED, function(e:Event)
						{
							music.soundTransform = new SoundTransform(music.soundTransform.volume-0.1);
							//trace("Volume: " + music.soundTransform.volume);
						});

						var inc = new Button(Root.assets.getTexture("Button"));
						inc.scaleX = inc.scaleY = 0.5;
						inc.color = 0x222222;
						inc.text = ">";
						inc.fontColor = 0xffff00;
						inc.fontSize = 30;
						inc.x = Starling.current.stage.stageWidth - dec.width;
						inc.addEventListener(Event.TRIGGERED, function(e:Event)
						{
							music.soundTransform = new SoundTransform(music.soundTransform.volume+0.1);
							//trace("Volume: " + music.soundTransform.volume);
						});
						addChild(inc);addChild(dec);
					}
				});
			}
		});
	}

	private function loopMusic(e:flash.events.Event)
	{
		var trans = music.soundTransform;
		music = assets.playSound("PuzzleGame");
		music.soundTransform = trans;
		if(!music.hasEventListener(flash.events.Event.SOUND_COMPLETE))
			music.addEventListener(flash.events.Event.SOUND_COMPLETE,loopMusic);
	}
}