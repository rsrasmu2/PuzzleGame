import flash.net.SharedObject;

class LoadUnlocked
{
	//Load the unlocked levels
	public static function load()
	{
		var so = SharedObject.getLocal("unlocked");
		
		return so.data.message;
	}
	
	//Save the unlocked levels
	public static function save(unlocked : Int)
	{
		var string = Std.string(unlocked);
		
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
	
	//Reset the unlocked levels
	public static function reset()
	{
		var so = SharedObject.getLocal("unlocked");
		var string = "0";
		so.data.message = string;
		so.flush();
	}
}