import flash.display.Stage;
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
	private var music:SoundChannel;
	private var vol:Float;
	
	public var down : Button;
	public var up : Button;
	public var left : Button;
	public var right : Button;

	public function new() {
		super();
		vol = 0.5;
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

		//Load the level assets
		for (i in 0...Levels.level.length) {
			assets.enqueue("assets/Levels/" + Levels.level[i] + ".txt");
		}
		
		
		//Check for lost focus of game
		//this.stage.addEventListener(flash.events.Event.DEACTIVATE, lostFocus);
		addEventListener(flash.events.Event.DEACTIVATE, lostFocus);
		
		
		
		
		

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
						music = assets.playSound("PuzzleGame");
						music.soundTransform = new SoundTransform(vol);
						music.addEventListener(flash.events.Event.SOUND_COMPLETE, loopMusic);
						
						var dec = new Button(Root.assets.getTexture("Button"));
						dec.scaleX = dec.scaleY = 0.5;
						dec.color = 0x222222;
						dec.text = "v";
						dec.fontColor = 0xffff00;
						dec.fontSize = 30;
						dec.x = Starling.current.stage.stageWidth - dec.width;
						dec.y = dec.height;
						dec.addEventListener(Event.TRIGGERED, function(e:Event)
						{
							if(vol > 0)
							{
								vol -= 0.1;
								if (vol < 0) {
									vol = 0;
								}
								music.soundTransform = new SoundTransform(vol);
							}
							//trace("Volume: " + music.soundTransform.volume);
						});						
						
						var inc = new Button(Root.assets.getTexture("Button"));
						inc.scaleX = inc.scaleY = 0.5;
						inc.color = 0x222222;
						inc.text = "^";
						inc.fontColor = 0xffff00;
						inc.fontSize = 30;
						inc.x = Starling.current.stage.stageWidth - dec.width;
						inc.addEventListener(Event.TRIGGERED, function(e:Event)
						{
							if (vol < 1) {
								vol += 0.1;
								music.soundTransform = new SoundTransform(vol);
							}
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
		music.soundTransform = new SoundTransform(vol);
		if(!music.hasEventListener(flash.events.Event.SOUND_COMPLETE))
			music.addEventListener(flash.events.Event.SOUND_COMPLETE,loopMusic);
	}
	
	
	
	
	public function lostFocus(e:flash.events.Event)
	{
		trace("This is being called");
		//var st : Starling = new Starling(Root, this);
		//st.stop();
		vol = 0;
		this.stage.addEventListener(flash.events.Event.ACTIVATE, onFocus);
	}
	 
	public function onFocus(e:flash.events.Event)
	{
		this.stage.removeEventListener(flash.events.Event.ACTIVATE, onFocus);
	}
}