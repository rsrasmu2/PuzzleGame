/*
 * Create a map from a loaded text file. Map can be of varying sizes.
*/
class LoadMap
{
	public static function load(name:String) : Array<Array<Int>>
	{
		//Load in the level as a bytearray and conver to string
		var str: String = new String(Root.assets.getByteArray(name).toString());

		//Split the string at each new line as store it in an array
		var array = str.split("\n");

		//Create an integer map that represents the level
		var map : Array<Array<Int>> = new Array();
		for (i in 0...array.length) {
			map[i] = new Array();
			for (j in 0...array[i].length) {
				//make sure null isn't being pushed into the map
				var val = Std.parseInt(array[i].charAt(j));
				if(val != null)
					map[i].push(val);
			}
		}

		return map;
	}
}