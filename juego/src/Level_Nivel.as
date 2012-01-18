//Code generated with DAME. http://www.dambots.com

package src
{
	import org.flixel.*;
	public class Level_Nivel extends BaseLevel
	{
		
		//Embedded media...
		//[Embed(source="../mapCSV_Group1_Map2.csv", mimeType="application/octet-stream")] public var CSV_Group1Map2:Class;
		[Embed(source="bgtiles.png")] public var Img_Group1Map2:Class;
		//[Embed(source="../mapCSV_Group1_Map1.csv", mimeType="application/octet-stream")] public var CSV_Group1Map1:Class;
		[Embed(source = "maintiles.png")] public var Img_Group1Map1:Class;
		
		public static const TILES:int = 50;

		//Tilemaps
		//public var layerGroup1Map2:FlxTilemap;
		public var layerGroup1Map1:FlxTilemap;

		//Sprites
		public var Group3Layer1Group:FlxGroup = new FlxGroup;
		public var Group2Layer1Group:FlxGroup = new FlxGroup;
		
		public var caveMatrix:Array = [];


		public function Level_Nivel(addToStage:Boolean = true, onAddSpritesCallback:Function = null)
		{
			
			// Create cave of size 200x100 tiles
			var cave:FlxCaveGenerator = new FlxCaveGenerator(TILES, TILES);
 
			// Generate the level and returns a matrix
			// 0 = empty, 1 = wall tile
			caveMatrix = cave.generateCaveLevel();
			caveMatrix = cave.autotileCave(caveMatrix);
 
			// Converts the matrix into a string that is readable by FlxTileMap
			var dataStr:String = FlxCaveGenerator.convertMatrixToStr( caveMatrix);
			
			// Generate maps.
			//layerGroup1Map2 = new FlxTilemap;
			//layerGroup1Map2.loadMap( new CSV_Group1Map2, Img_Group1Map2, 50,50 );
			//layerGroup1Map2.x = 0.000000;
			//layerGroup1Map2.y = 0.000000;
			//layerGroup1Map2.scrollFactor.x = 0.500000;
			//layerGroup1Map2.scrollFactor.y = 0.500000;
			//layerGroup1Map2.collideIndex = 1;
			//layerGroup1Map2.drawIndex = 1;
			layerGroup1Map1 = new FlxTilemap;
			//layerGroup1Map1.auto = FlxTilemap.AUTO;
			layerGroup1Map1.loadMap( dataStr, Img_Group1Map1, 32, 32 );
			
			layerGroup1Map1.x = 0.000000;
			layerGroup1Map1.y = 0.000000;
			layerGroup1Map1.scrollFactor.x = 1.000000;
			layerGroup1Map1.scrollFactor.y = 1.000000;
			layerGroup1Map1.collideIndex = 1;
			layerGroup1Map1.drawIndex = 1;

			//Add layers to the master group in correct order.
			//masterLayer.add(layerGroup1Map2);
			masterLayer.add(layerGroup1Map1);
			masterLayer.add(Group3Layer1Group);
			Group3Layer1Group.scrollFactor.x = 1.000000;
			Group3Layer1Group.scrollFactor.y = 1.000000;
			//masterLayer.add(Group2Layer1Group);
			//Group2Layer1Group.scrollFactor.x = 1.000000;
			//Group2Layer1Group.scrollFactor.y = 1.000000;


			if ( addToStage )
			{
				addSpritesForLayerGroup3Layer1(onAddSpritesCallback);
				addSpritesForLayerGroup2Layer1(onAddSpritesCallback);
				FlxG.state.add(masterLayer);
			}

			mainLayer = layerGroup1Map1;

			boundsMinX = 0;
			boundsMinY = 0;
			boundsMaxX = 768;
			boundsMaxY = 768;

		}

		override public function addSpritesForLayerGroup3Layer1(onAddCallback:Function = null):void
		{
			addSpriteToLayer(Coin, Group3Layer1Group , 199.000, 232.000, 0.000, false, onAddCallback );//"CoinSprite"
			addSpriteToLayer(Coin, Group3Layer1Group , 269.000, 461.000, 0.000, false, onAddCallback );//"CoinSprite"
			addSpriteToLayer(Coin, Group3Layer1Group , 232.000, 232.000, 0.000, false, onAddCallback );//"CoinSprite"
			addSpriteToLayer(Coin, Group3Layer1Group , 263.000, 712.000, 0.000, false, onAddCallback );//"CoinSprite"
			addSpriteToLayer(Coin, Group3Layer1Group , 233.000, 712.000, 0.000, false, onAddCallback );//"CoinSprite"
			addSpriteToLayer(Coin, Group3Layer1Group , 202.000, 712.000, 0.000, false, onAddCallback );//"CoinSprite"
			addSpriteToLayer(Coin, Group3Layer1Group , 293.000, 712.000, 0.000, false, onAddCallback );//"CoinSprite"
			addSpriteToLayer(Coin, Group3Layer1Group , 652.000, 591.000, 0.000, false, onAddCallback );//"CoinSprite"
			addSpriteToLayer(Coin, Group3Layer1Group , 681.000, 711.000, 0.000, false, onAddCallback );//"CoinSprite"
			addSpriteToLayer(Coin, Group3Layer1Group , 485.000, 107.000, 0.000, false, onAddCallback );//"CoinSprite"
			addSpriteToLayer(Coin, Group3Layer1Group , 562.000, 427.000, 0.000, false, onAddCallback );//"CoinSprite"
		}

		override public function addSpritesForLayerGroup2Layer1(onAddCallback:Function = null):void
		{
			addSpriteToLayer(Player, Group2Layer1Group , 32, 32, 0.000, false, onAddCallback );//"Player"
		}


	}
}
