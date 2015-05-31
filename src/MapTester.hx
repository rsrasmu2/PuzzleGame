import starling.core.Starling;

typedef Point = { x : Int, y : Int }
typedef FoundObject = {x : Int, y : Int, type : Int }

class MapTester {

	private var mapArray: Array<Array<Int>>;
	private var checkedArray: Array<Array<Int>>; // an array to avoid endless loops. Can't check a location more than once
	
	public function new(str:String) {
		
		// reminder: accessing the map array is in [y][x] coordinates
		mapArray = LoadMap.load(str);
		
		trace(str + " loaded.");
		
		initializeChecked(); // initialize checkedArray
		
		var player = find(2); // find initial player
		if (player.x != -1 && player.y != -1) {
			trace("player found at " + player);
		}
		
		test(player); // initialize the test
	}
	
	private function test(position:Point){
		// this function is recursive
		
		/* ------- CHECK UP DIRECTION ------- */
		var upResponse = checkUp(position); 
		if (upResponse.type == 3) {
			trace("flag found");
			// win condition
		}
		else if (upResponse.type == 1) {
			// found obstacle
			var newPos = { y: upResponse.y + 1, x: upResponse.x };
			if (checkedArray[newPos.y][newPos.x] == 0) { // make sure we've never been here before
				checkedArray[newPos.y][newPos.x] = 1; // we've now checked this spot
				trace("[" + newPos.y + "][" + newPos.x + "] has now been checked.");
				test(newPos); // call the function on our new position
			}
		}
		
		/* ------- CHECK DOWN DIRECTION ------- */
		var downResponse = checkDown(position);
		if (downResponse.type == 3) {
			trace("flag found");
			// win condition
		}
		else if (downResponse.type == 1) {
			// found obstacle
			var newPos = { y: downResponse.y - 1, x: downResponse.x };
			if (checkedArray[newPos.y][newPos.x] == 0) { // make sure we've never been here before
				checkedArray[newPos.y][newPos.x] = 1; // we've now checked this spot
				trace("[" + newPos.y + "][" + newPos.x + "] has now been checked.");
				test(newPos); // call the function on our new position
			}
		}
		
		/* ------- CHECK LEFT DIRECTION ------- */
		var leftResponse = checkLeft(position);
		if (leftResponse.type == 3) {
			trace("flag found");
			// win condition
		}
		else if (leftResponse.type == 1) {
			// found obstacle
			var newPos = { y: leftResponse.y, x: leftResponse.x + 1 };
			if (checkedArray[newPos.y][newPos.x] == 0) { // make sure we've never been here before
				checkedArray[newPos.y][newPos.x] = 1; // we've now checked this spot
				trace("[" + newPos.y + "][" + newPos.x + "] has now been checked.");				
				test(newPos); // call the function on our new position
			}
		}
		
		/* ------- CHECK RIGHT DIRECTION ------- */
		var rightResponse = checkRight(position);
		if (rightResponse.type == 3) {
			trace("flag found at [" + rightResponse.y + "][" + rightResponse.x + "]");
			// win condition
		}
		else if (rightResponse.type == 1) {
			// found obstacle
			var newPos = { y: rightResponse.y, x: rightResponse.x - 1 };
			if (checkedArray[newPos.y][newPos.x] == 0) { // make sure we've never been here before
				checkedArray[newPos.y][newPos.x] = 1; // we've now checked this spot
				trace("[" + newPos.y + "][" + newPos.x + "] has now been checked.");				
				test(newPos); // call the function on our new position
			}
		}
	}
	
	private function checkRight(position:Point): FoundObject {
		var hit = 0;
		var xCoord = -1;
		for (i in 0...(mapArray.length - position.x)) {
			var test:Int = position.x + i + 1;
			if (mapArray[position.y][test] == 3) {
				hit = 3; // win condition
				xCoord = test;
				break;
			}
			else if (mapArray[position.y][test] == 1) {
				hit = 1;
				xCoord = test;
				break;
			}
		}
		var val = { x : xCoord, y : position.y, type : hit };
		trace("Right: Found a " + val.type + " at [" + val.y + "][" + val.x + "].");
		return val;
	}
	
	private function checkLeft(position:Point): FoundObject {
		var hit = 0;
		var xCoord = -1;
		for (i in 0...position.x) {
			var test:Int = position.x - i - 1;
			if (mapArray[position.y][test] == 3) {
				hit = 3; // win condition
				xCoord = test;
				break;
			}
			else if (mapArray[position.y][test] == 1) {
				hit = 1;
				xCoord = test;
				break;
			}
		}
		var val = { x : xCoord, y : position.y, type : hit };
		trace("Left: Found a " + val.type + " at [" + val.y + "][" + val.x + "].");
		return val;
	}
	
	private function checkDown(position:Point): FoundObject {
		var hit = 0;
		var yCoord = -1;
		for (i in 0...(mapArray.length - position.y - 1)) {
			var test:Int = position.y + i + 1;
			if (mapArray[test][position.x] == 3) {
				hit = 3; // win condition
				yCoord = test;
				break;
			}
			else if (mapArray[test][position.x] == 1) {
				hit = 1;
				yCoord = test;
				break;
			}
		}
		var val = { x : position.x, y : yCoord, type : hit };
		trace("Down: Found a " + val.type + " at [" + val.y + "][" + val.x + "].");
		return val;
	}
	
	private function checkUp(position:Point): FoundObject{
		var hit = 0;
		var yCoord = -1;
		for (i in 0...position.y) {
			var test:Int = position.y - i - 1;
			if (mapArray[test][position.x] == 3) {
				hit = 3; // win condition
				yCoord = test;
				break;
			}
			else if (mapArray[test][position.x] == 1) {
				hit = 1;
				yCoord = test;
				break;
			}
		}
		var val = { x : position.x, y : yCoord, type : hit };
		trace("Up: Found a " + val.type + " at [" + val.y + "][" + val.x + "].");
		return val;
	}
	
	
	private function find(thing:Int):Point {
		// 0 - space, 1 - obstacle, 2 - player, 3 - goal
		for (i in 0...mapArray.length) {
			var xCoord = mapArray[i].indexOf(thing); // search this row
			if (xCoord != -1) { // found it
				var point = { x : xCoord, y : i };
				return point;
			}
		}
		trace("no player found");
		var point = { x : -1, y : -1 };
		return point;
	}
	
	private function initializeChecked() {
		checkedArray = new Array<Array<Int>>();
		// copy mapArray's size and fill checkedArray with 0's.
		for (i in 0...mapArray.length){
			var array = new Array<Int>();
			for (x in 0...mapArray[0].length) {
				array.push(0);
			}
			checkedArray.push(array);
		}
		trace("checkedArray created.");
	}
	
}