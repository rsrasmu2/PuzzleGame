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
	// the parallax is the speed of the background layer. Bigger number = faster speed.
	private var parallax:Float;
	
	public function new(layer:Int) 
	{
		super();
		this.layer = layer;
		this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
	}
	
	public function onAddedToStage(event:Event):Void {
		this.removeEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
		
		if (layer == 1){ 
			image1 = new Image(Root.assets.getTexture("star_background"));
			image2 = new Image(Root.assets.getTexture("star_background"));
		}
		else {
			image1 = new Image(Root.assets.getTexture("star_foreground"));
			image2 = new Image(Root.assets.getTexture("star_foreground"));
			
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