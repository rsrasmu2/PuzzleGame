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
		trace("a");
		super();
		//this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
		trace("a");
		bgLayer1 = new BgLayer(1);
		bgLayer2.setParallax(2);
		addChild(bgLayer1);
		
		bgLayer2 = new BgLayer(2);
		bgLayer2.setParallax(0.02);
		addChild(bgLayer2);
		
		trace("both layers added");
		this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}
	
	public function onAddedToStage(event:Event):Void {
		/*this.removeEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
	
		bgLayer1 = new BgLayer(1);
		bgLayer2.setParallax(2);
		addChild(bgLayer1);
		
		bgLayer2 = new BgLayer(2);
		bgLayer2.setParallax(0.02);
		addChild(bgLayer2);
		
		this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		*/
	}
	
	public function onEnterFrame(event:Event):Void {
		
		bgLayer1.x -= Math.ceil(bgLayer1.getParallax());
		if (bgLayer1.x < -flash.Lib.current.stage.stageWidth) {
			bgLayer1.x = 0;
		}
		
		bgLayer2.x -= Math.ceil(bgLayer2.getParallax());
		if (bgLayer2.x < -flash.Lib.current.stage.stageWidth) {
			bgLayer2.x = 0;
		}
	}
	
}