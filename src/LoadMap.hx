/*
 * Create a map from a loaded text file. Map can be of varying sizes.
*/
class LoadMap
{
	private var map: Array<Array<Int>>;
	
	public function new() 
	{
	}
		
		
	public function load(name:String)
	{
		//Load in the level as a bytearray and conver to string
		var str: String = new String(Root.assets.getByteArray(name).toString());
		
		//Split the string at each new line as store it in an array
		var array = str.split("\n");
		
		//Initialize the map of a varying size
		map = [for (i in 0...array.length) [for (j in 0...array[i].length) 0]];
		
		//Create an integer map that represents the level
		for (i in 0...array.length) {
			for (j in 0...array[i].length) {
				map[i][j] = Std.parseInt(array[i].charAt(j));
			}
		}
		
		return map;
	}
}