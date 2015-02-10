import starling.display.Image;
import starling.display.Sprite;
import starling.utils.AssetManager;
import starling.core.Starling;

import starling.events.Event;
/**
 * ...
 * @author Nancy McCollough
 */
class Background extends Sprite
{

	private var bgLayer1:BgLayer;
	private var bgLayer2:BgLayer;

	public function new()
	{
		super();
		this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
	}

	public function onAddedToStage(event:Event):Void {


		this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);


		bgLayer1 = new BgLayer(1);
		bgLayer1.setParallax(.1);
		addChild(bgLayer1);

		bgLayer2 = new BgLayer(2);
		bgLayer2.setParallax(.4);
		addChild(bgLayer2);

		this.addEventListener(Event.ENTER_FRAME, onEnterFrame);

	}

	public function onEnterFrame(event:Event):Void {

		bgLayer1.x -= bgLayer1.getParallax();
		if (bgLayer1.x < -bgLayer1.imageWidth) {
			bgLayer1.x = 0;
		}

		bgLayer2.x -= bgLayer2.getParallax();
		if (bgLayer2.x < -bgLayer2.imageWidth) {
			bgLayer2.x = 0;
		}
	}

}