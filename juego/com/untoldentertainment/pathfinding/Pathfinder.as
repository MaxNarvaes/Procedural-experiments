package com.untoldentertainment.pathfinding 
{
	/**
	 * ...
	 * @author Phillip Chertok
	 */
	import src.Node;

	public class Pathfinder
	{
		public static var heuristic:Function = Pathfinder.manhattanHeuristic;			
		
		public static function findPath( firstNode:Node, destinationNode:Node, connectedNodeFunction:Function ):Array 
		{
			var openNodes:Array = [];
			var closedNodes:Array = [];			
			
			var currentNode:Node = firstNode;
			var testNode:Node;
			
			var l:int;
			var i:int;
		
			var connectedNodes:Array;
			var travelCost:Number = 1.0;
			
			var g:Number;
			var h:Number;
			var f:Number;
			
			currentNode.g = 0;
			currentNode.h = Pathfinder.heuristic(currentNode, destinationNode, travelCost);
			currentNode.f = currentNode.g + currentNode.h;
			//trace("curr", currentNode.col, currentNode.row, "des", destinationNode.col, destinationNode.row);
			//trace(currentNode.row != destinationNode.row && currentNode.col != destinationNode.col, "antes while");
			//while (currentNode.row != destinationNode.row && currentNode.col != destinationNode.col  ) {
			while (currentNode != destinationNode) {
				//trace(currentNode.col, currentNode.row, "entrando al while");
				connectedNodes = connectedNodeFunction( currentNode );			
				//connectedNodes.forEach( function() { trace("en for each de connected ndoes");} );
				l = connectedNodes.length;
				//trace(connectedNodes.length, " connectedNodeFunction lenght");
				
				for (i = 0; i < l; ++i) {
					//trace(currentNode.row, currentNode.col, "testnode en el for");
					//trace(connectedNodes[i].row, connectedNodes[i].col, "conected[i] en el for");
					testNode = connectedNodes[i];
					
					if (testNode == currentNode || testNode.traversable == false) continue;					
					
					//For our example we will test just highlight all the tested nodes
					//Node(testNode).highlight(0xFF80C0);
					
					//g = currentNode.g + Pathfinder.heuristic( currentNode, testNode, travelCost); //This is what we had to use here at Untold for our situation.
					//If you have a world where diagonal movements cost more than regular movements then you would need to determine if a movement is diagonal and then adjust
					//the value of travel cost accordingly here.
					
					g = currentNode.g + travelCost;
					h = Pathfinder.heuristic( testNode, destinationNode, travelCost);
					f = g + h;
					
					if ( Pathfinder.isOpen(testNode, openNodes) || Pathfinder.isClosed( testNode, closedNodes) )
					{
						if(testNode.f > f)
						{
							testNode.f = f;
							testNode.g = g;
							testNode.h = h;
							testNode.parentNode = currentNode;
						}
					}
					else {
						testNode.f = f;
						testNode.g = g;
						testNode.h = h;
						testNode.parentNode = currentNode;
						openNodes.push(testNode);
					}
					
				}
				closedNodes.push( currentNode );
				
				if (openNodes.length == 0) {
					return null;
				}
				openNodes.sortOn('f', Array.NUMERIC);
				/*for each(var n:Node in openNodes)
				{
					//trace(n.g, n.h, n.f, n.row, n.col, "F, row, col, sorted despues del for")
				}*/
				currentNode = openNodes.shift() as Node;
				//trace(currentNode.g, currentNode.h, currentNode.f, currentNode.row, currentNode.col, "current node despues de sort");
			}
			
			return Pathfinder.buildPath(destinationNode, firstNode);
		}
		
		
		public static function buildPath(destinationNode:Node, startNode:Node):Array {			
			var path:Array = [];
			var node:Node = new Node(0, 0);
			//trace(node);
			node = destinationNode;
			path.push(node);
			while (node != startNode ) {
				node = node.parentNode;
				path.unshift( node );
			}
			
			return path;			
		}
		
		public static function isOpen(node:Node, openNodes:Array):Boolean {
			
			var l:int = openNodes.length;
			for (var i:int = 0; i < l; ++i) {
				if ( openNodes[i] == node ) return true;
			}
			
			return false;			
		}
		
		public static function isClosed(node:Node, closedNodes:Array):Boolean {
			
			var l:int = closedNodes.length;
			for (var i:int = 0; i < l; ++i) {
				if (closedNodes[i] == node ) return true;
			}
			
			return false;
		}
		
		/****************************************************************************** 
		*
		*	These are our avaailable heuristics 
		*
		******************************************************************************/		
		public static function euclidianHeuristic(node:Node, destinationNode:Node, cost:Number = 1.0):Number
		{
			var dx:Number = node.row - destinationNode.row;
			var dy:Number = node.col - destinationNode.col;
			
			return Math.sqrt( dx * dx + dy * dy ) * cost;
		}
		
		public static function manhattanHeuristic(node:Node, destinationNode:Node, cost:Number = 1.0):Number
		{
			//trace(Math.abs(node.row - destinationNode.row) * cost,  
			//	   Math.abs(node.col - destinationNode.col) * cost, "heuristica para",  node.row, node.col, destinationNode.row, destinationNode.col)
			return (Math.abs(node.row - destinationNode.row) * cost + 
				   Math.abs(node.col - destinationNode.col) * cost);
		}
		
		public static function diagonalHeuristic(node:Node, destinationNode:Node, cost:Number = 1.0, diagonalCost:Number = 1.0):Number
		{
			var dx:Number = Math.abs(node.row - destinationNode.row);
			var dy:Number = Math.abs(node.col - destinationNode.col);
			
			var diag:Number = Math.min( dx, dy );
			var straight:Number = dx + dy;
			
			return diagonalCost * diag + cost * (straight - 2 * diag);
		}
		

	}

}
