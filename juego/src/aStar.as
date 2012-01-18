package 
{
	
	/**
	 * ...
	 * @author Hard Haiku
	 */
	public class Astar 
	{
		
		protected const mapWidth:int = 80, mapHeight:int = 60, tileSize:int = 10, numberPeople:int = 3;
		protected var onClosedList:int = 10;
		protected const notfinished:int = 0, notStarted:int = 0;
		// path-related constants
		protected const found:int = 1, nonexistent:int = 2;
		protected const walkable:int = 0, unwalkable:int = 1;
		// walkability array constants
		//Create needed arrays
		protected var walkability:array;// [mapWidth][mapHeight];
		protected var openList:array = new Array(mapWidth*mapHeight+2);
		//1 dimensional array holding ID# of open list items
		protected var whichList:array; // mapWidth + 1][mapHeight + 1;
		//2 dimensional array used to record 
		//whether a cell is on the open list or on the closed list.
		protected var openX:array = new Array(mapWidth*mapHeight+2);
		//1d array stores the x location of an item on the open list
		protected var openY:array = new Array(mapWidth*mapHeight+2);
		//1d array stores the y location of an item on the open list
		protected var parentX:array; // [mapWidth + 1][mapHeight + 1];
		//2d array to store parent of each cell (x)
		protected var parentY:Array; // [mapWidth + 1][mapHeight + 1];
		//2d array to store parent of each cell (y)
		protected var Fcost:Array = new Array(mapWidth*mapHeight+2);
		//1d array to store F cost of a cell on the open list
		protected var Gcost:Array;// [mapWidth + 1][mapHeight + 1];
		//2d array to store G cost for each cell.
		protected var Hcost:Array = new Array(mapWidth*mapHeight+2);
		//1d array to store H cost of a cell on the open list
		protected var pathLength:Array = new Array(numberPeople+1);
		//stores length of the found path for critter
		protected var pathLocation:Array = new Array(numberPeople+1);
		//stores current position along the chosen path for critter		
		protected var pathBank:Array;// [numberPeople + 1];
		//Path reading variables
		protected var pathStatus:Array = new Array(numberPeople+1);
		protected var xPath:Array = new Array(numberPeople+1);
		protected var yPath:Array = new Array(numberPeople+1);
		
		
		public static function findPath (startX:int, startY:int, startY:int, endX:int, map:Array):Array
		{
			var startingX:int = map.length; 
			var startingY:int = map[0].length;
			var targetX:int = map.length;
			var targetY:int = map[o].length;
			
			
			
			
		}
		
		
	}
	
}