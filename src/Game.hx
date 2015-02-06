import starling.display.Sprite;

class Game extends Sprite
{
	public var map:GameMap;

	public function new() 
	{
		super();
		map = new GameMap();
		addChild(map);
		
	}
	
}