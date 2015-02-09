import starling.display.Sprite;
import starling.display.Image;
import starling.events.*;
/**
 * ...
 * @author ...
 */
class BgLayer extends Sprite 
{
	
	private var image1:Image;
	private var image2:Image;
	
	private var layer:Int;
	private var parallax:Float;
	
	public function new(layer:Int) 
	{
		trace("b");
		super();
		this.layer = layer;
		this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
	}
	
	public function onAddedToStage(event:Event):Void {
		this.removeEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
		
		if (layer == 1){ 
			image1 = new Image(Root.assets.getTexture("star_background"));
			image2 = new Image(Root.assets.getTexture("star_background"));
			trace("starbackground loaded");
		}
		else {
			image1 = new Image(Root.assets.getTexture("star_foreground"));
			image2 = new Image(Root.assets.getTexture("star_foreground"));
			trace("starforeground loaded");
			
		}
		
		image1.x = 0;
		image2.x = image2.width;
		
		addChild(image1);
		addChild(image2);
	}

	public function getParallax():Float {
		
		return parallax;
	}
	
	public function setParallax(value:Float):Void {
		
		parallax = value;
	}
	
}