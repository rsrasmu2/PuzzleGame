import starling.display.Sprite;
import starling.utils.AssetManager;
import starling.display.Image;
import starling.core.Starling;
import starling.animation.Transitions;

class Root extends Sprite {
	
	public static var assets:AssetManager;
	
	public function new() {
		super();
	}
	
	public function start(startup:Startup) {
		assets = new AssetManager();
		//assets.enqueue("assets/ninja.png");
		assets.loadQueue(function onProgress(ratio:Float) {
			if (ratio == 1) {
				Starling.juggler.tween(startup.loadingBitmap, 2.0, {
					transition:Transitions.EASE_OUT, delay:0, alpha: 0, onComplete: function(){
						startup.removeChild(startup.loadingBitmap);
					}
				});
			}
		});
	}
}