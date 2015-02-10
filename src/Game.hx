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
		bg = new Background();
		addChild(bg);
		map = new GameMap();
		addChild(map);
		
	}
	
}