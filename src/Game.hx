import starling.display.Sprite;

/**
 * ...
 * @author ...
 */
class Game extends Sprite
{
	public var map:GameMap;
	
	private var bg:Background;

	public function new() 
	{
		super();
		trace("3");
		bg = new Background();
		trace("4");
		addChild(bg);
		trace("5");
		map = new GameMap();
		addChild(map);
		
	}
	
}