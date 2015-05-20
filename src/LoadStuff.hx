import flash.net.SharedObject;

class LoadStuff
{
	//Load the unlocked levels
	public static function loadLevel()
	{
		var so = SharedObject.getLocal("unlocked");
		
		return so.data.message;
	}
	
	public static function loadScores()
	{
		var so = SharedObject.getLocal("scores");
		
		return so.data.itemNumbers;
	}
	
	public static function saveLevel(stuff : Int)
	{
		var string = Std.string(stuff);
		
		var so = SharedObject.getLocal("unlocked");
		
		so.data.message = string;
		
		try
		{
			so.flush();
		}
		catch (e:Dynamic)
		{
			trace("Failed");
		}
	}
	
	public static function saveScores(items : Array<Int>)
	{
		
		var so = SharedObject.getLocal("scores");
		
		so.data.itemNumbers = items;
		
		try
		{
			so.flush();
		}
		catch (e:Dynamic)
		{
			trace("Failed");
		}
		
	}
	
	//Reset the unlocked levels
	public static function resetLevel()
	{
		var so = SharedObject.getLocal("unlocked");
		var string = "0";
		so.data.message = string;
		so.flush();
	}
	
	//Reset the high scores
	public static function resetScores()
	{
		var temp : Array<Int> = [for (i in 0...10) 0];
		var so = SharedObject.getLocal("scores");
		so.data.itemNumbers = temp;
		so.flush();
	}
}