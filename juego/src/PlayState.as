package src

{

	import flash.filters.ConvolutionFilter;
	import org.flixel.*;
	import com.untoldentertainment.pathfinding.Pathfinder;
	



	public class PlayState extends FlxState

	{
		//embeber sonido
		//[Embed(source = 'cmp.mp3')] private var music:Class;
		//protected var musica:FlxSound;
		
		protected var coinGroup:FlxGroup;
		protected var nivel:Level_Nivel;
		protected var player:Player;
		
		protected var coin:Coin;
		protected var _oNode:Node;
		protected var _dNode:Node;
		protected var _path:Array = [];
		
		protected var _nodes:Array = [];

		override public function create():void
		{

			player = new Player(40, 40);
			nivel = new Level_Nivel(true, onSpriteAddedCallback);
			add(player);
			//musica = new FlxSound();
			FlxG.follow(player,2.5);
			FlxG.followAdjust(0.5, 0.2);
			FlxG.followBounds(nivel.mainLayer.left, nivel.mainLayer.top, nivel.mainLayer.right, nivel.mainLayer.bottom);
			FlxU.setWorldBounds(nivel.mainLayer.left, nivel.mainLayer.top, nivel.mainLayer.width, nivel.mainLayer.height);
			//FlxG.playMusic(music);
			
			/*_oNode = new Node(0,0);
			_dNode = new Node(0,0);*/

			
			//agregando moneda dummy
			coin = new Coin(150, 150);
			add(coin);
			createNodeArray();
			

		}
		
		protected function onSpriteAddedCallback(sprite:FlxSprite, group:FlxGroup):void
		{
		//	if (sprite is Player)
	//		{
//				player = sprite as Player;
			//}
			if (sprite is Coin)
			{
				coinGroup = group;
			}
			
			
		}

        override public function update():void
		{
			/*var i:int = 0;
			var sum:Number = 0;
			var cant:int = 0;
			var num:Number;*/
			super.update();
			nivel.mainLayer.collide(player);
			FlxU.overlap(player, coinGroup, coinCollected);
			if(FlxG.keys.G)
			{
				//tomar posision player y sacar tile donde esta
				if (_oNode == null && _dNode == null)
				{
					var row:int = player.x / 32;
					var col:int = player.y / 32;
					
					//trace(_nodes.length, "largo de ndoes");
					trace(row, col, "X e Y");
					trace(row + (col * Level_Nivel.TILES), "valor de [i] para _nodes")
					trace(_nodes[row + (col * Level_Nivel.TILES)].row, _nodes[row + (col * Level_Nivel.TILES)].col, "valor de [i] para _nodes");

					
					_oNode = _nodes[[row + (col * Level_Nivel.TILES)]];
					trace(_oNode.row, _oNode.col, "_oNode");
				}
				
				

				//tomar primer nodo
				//si ya hay primer nodo tomar segundo
				//si ya hay segundo nodo buscar path y dibujarlo
			}
			if (FlxG.keys.H)
			{
				if (_dNode == null && _oNode != null)
				{
					
					row = player.x / 32;
					col = player.y / 32;
					/*//trace(_nodes.length, "largo de ndoes");
					trace(row, col, "X e Y");
					trace(row + (col * Level_Nivel.TILES), "valor de [i] para _nodes")
					trace(_nodes[row + (col * Level_Nivel.TILES)].row, _nodes[row + (col * Level_Nivel.TILES)].col, "valor de [i] para _nodes");*/
					if (_oNode.row == int(player.x / 32) && _oNode.col == int(player.y / 32))
						_dNode = _oNode;
					_dNode = _nodes[[row + (col * Level_Nivel.TILES)]];
					//trace(_dNode.row, _dNode.col, "_dNode");
				}
			}
			if (FlxG.keys.I && _path.length <=0)
			{
				//trace(_path.length);
				if (_oNode != null && _dNode != null )
				{
					/*trace ("pathfinder");
					trace(_oNode.row, _oNode.col, "_oNode");
					trace(_dNode.row, _dNode.col, "_dNode");
					trace ("pathfinder");*/
					_path = Pathfinder.findPath(_oNode, _dNode, findConnectedNodes);
					for each (var p:Node in _path) 
					{
						/*trace(p.col, p.row, "dibujar sprite");
						trace(p.g, p.h, p.f, "G, H, F");*/
						add(new Invader(p.row * 32 +16 , p.col * 32 + 16));
					}
					_path = [];
					_oNode = null;
					_dNode = null;
				}
			}
			
			/*//for ( i = 200; i < 256; i++)
			//*{
				//num = FlxG.music.byteArray.readDouble()
				//if (num > 0 && num > sum)
				//{
					sum = num;
					cant++;
				}
			}
			sum = sum / cant;*/
            
            
			
			
			/*if ((sum * 10000) >** 1)
			{
				
				if ((sum * 10000) > 20)
				{
					//trace (sum * 10000);
					sum = 1;
					//trace (sum * 10000);
				}
				for each (var c:FlxSprite in coinGroup.members)
				{
					
					c.scale.x = sum +1;
					c.scale.y = sum +1;
				}
			}
			//coin
			else
				for each ( c in coinGroup.members)
				{
					c.scale.x = 1;
					c.scale.y = 1;
				}
			**/
			
			
        }
        public function createNodeArray():void
        {
        	//nivel.caveMatrix
			for (var y:int = 0; y < Level_Nivel.TILES; y++)
			{
				for (var x:int = 0; x < Level_Nivel.TILES; x++)
				{
					_nodes.push(new Node(x, y));
					_nodes[x + y * Level_Nivel.TILES].row = x;
					_nodes[x + y * Level_Nivel.TILES].col = y;
					//trace(nivel.caveMatrix[y][x], "valor en matrix de nivel");
					if (nivel.caveMatrix[y][x] != 0)
					{
						
						_nodes[x + y * Level_Nivel.TILES].traversable = false;
					}
					else
						_nodes[x + y * Level_Nivel.TILES].traversable = true;
					/*trace(x, y, "x e y");
					trace(x + y * 10, "valor en array");
					trace(_nodes[x + y * Level_Nivel.TILES].row, _nodes[x + y * Level_Nivel.TILES].col, "row y col para nodo");
					trace(_nodes[x + y * Level_Nivel.TILES].traversable);*/
				}
			}
			
        
        }
        
        public function findConnectedNodes( node:Node ):Array
		{
			var n:Node = node as Node;
			var connectedNodes:Array = [];			
			var testNode:Node;
			
			connectedNodes.push(_nodes[int((n.row - 1) + (n.col-1) * Level_Nivel.TILES)]);
			connectedNodes.push(_nodes[int((n.row) + (n.col-1) * Level_Nivel.TILES)]);
			connectedNodes.push(_nodes[int((n.row + 1) + (n.col - 1) * Level_Nivel.TILES)]);
			
			connectedNodes.push(_nodes[int((n.row - 1) + (n.col) * Level_Nivel.TILES)]);
			connectedNodes.push(_nodes[int((n.row + 1) + (n.col) * Level_Nivel.TILES)]);
			
			connectedNodes.push(_nodes[int((n.row - 1) + (n.col + 1) * Level_Nivel.TILES)]);
			connectedNodes.push(_nodes[int((n.row) + (n.col + 1) * Level_Nivel.TILES)]);
			connectedNodes.push(_nodes[int((n.row + 1) + (n.col + 1) * Level_Nivel.TILES)]);
			//trace(connectedNodes);
			
			/*for (var i:int = 0; i < Level_Nivel.TILES * Level_Nivel.TILES; i++) 
			{
				testNode = _nodes[i];
				
				if (testNode.row < n.row - 1 || testNode.row > n.row + 1) continue;
				if (testNode.col < n.col - 1 || testNode.col > n.col + 1) continue;
				
				connectedNodes.push( testNode );
			}*/
			
			return connectedNodes;
		}
		
		public function coinCollected (player:FlxSprite, coin:FlxSprite):void
		{
			coin.kill();
		}

	}

}

