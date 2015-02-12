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
		//assets.enqueue("assets/Player.png");

		assets.enqueue("assets/sprites.png", "assets/sprites.xml");

		//assets.enqueue("assets/Obstacle.png", "assets/flag.png");

		//assets.enqueue("assets/playerSprites.png", "assets/playerSprites.xml");

		assets.enqueue("assets/star_assets.png", "assets/star_assets.xml");

		/*
		assets.enqueue("assets/Mars/marsObstacles.png", "assets/Mars/marsObstacles.xml");
		assets.enqueue("assets/neptune2.png", "assets/neptune1.png");
		assets.enqueue("assets/saturn1.png", "assets/saturn2.png");
		assets.enqueue("assets/jupiter1.png", "assets/jupiter2.png");
		assets.enqueue("assets/uranus1.png", "assets/uranus2.png");

		assets.enqueue("assets/Crew/bobby.png", "assets/Crew/cherie.png", "assets/Crew/jordan.png");
		assets.enqueue("assets/Crew/nancy.png", "assets/Crew/temitope.png", "assets/Crew/shadow.png");

		assets.enqueue("assets/spaceship.png");


		assets.enqueue("assets/Button.png");
		*/
		assets.enqueue("assets/PuzzleGame.mp3");

		//Load the level assets
		for (i in 0...Levels.level.length) {
			assets.enqueue("assets/Levels/" + Levels.level[i] + ".txt");
		}

		assets.loadQueue(function onProgress(ratio:Float) {
			if (ratio == 1) {
				Starling.juggler.tween(startup.loadingBitmap, 1.0, {
					transition:Transitions.EASE_OUT, delay:0, alpha: 0, onComplete: function(){
						startup.removeChild(startup.loadingBitmap);

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
		music = assets.playSound("PuzzleGame");
		if(!music.hasEventListener(flash.events.Event.SOUND_COMPLETE))
			music.addEventListener(flash.events.Event.SOUND_COMPLETE,loopMusic);
	}
}