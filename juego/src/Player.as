package src 
{
	import org.flixel.*;
	
	public class Player extends FlxSprite
	{
		[Embed(source='claws.png')]
        protected var ImgPlayer:Class;
		
		protected static const MOVE_SPEED:int = 300;
		protected static const JUMP_POWER:int = 230;
		
		public function Player(X:Number,Y:Number):void 
		{
			super(X, Y);
			loadGraphic(ImgPlayer, true, true, 32, 32 );
			
			maxVelocity.x = 300;
			maxVelocity.y = 300;
			//Set the player health
			health = 10;
			//Gravity
			
			//acceleration.y = 220;			
			//Friction
			drag.x = 150;
			drag.y = 150;
			//bounding box tweaks
			width = 32;
			height = 28;
			offset.x = 0;
			offset.y = 4;
			
			addAnimation("jump", [0, 1], 10);
			addAnimation("move", [0, 1], 10);	// For now move is same anim as jump.
			addAnimation("fall", [2, 3], 10);
			addAnimation("idle", [4, 5], 2);			
		}
		
		override public function update():void 
		{
			if ( FlxG.keys.LEFT )
			{
				facing = LEFT;
				velocity.x -= MOVE_SPEED * FlxG.elapsed;
				//this.x -= 8;
				
			}
			if (FlxG.keys.RIGHT )
			{
				facing = RIGHT;
				velocity.x += MOVE_SPEED * FlxG.elapsed;
				//this.x += 8;
			}
			if (FlxG.keys.UP )
			{
				//facing = UP;
				velocity.y -= MOVE_SPEED * FlxG.elapsed;
				//this.y -= 8;
			}
			if (FlxG.keys.DOWN )
			{
				//facing = DOWN;
				velocity.y += MOVE_SPEED * FlxG.elapsed;
				//this.y += 8;
			}
			
			//if (FlxG.keys.X && velocity.y == 0)
			//{
			//	velocity.y -= JUMP_POWER;
			//}
			
			if (velocity.y < 0)
			{
				play("jump");// Check old flixel and new flixel in case I fixed the play anim code if you're already playing.
			}
			else
			{
				if ( velocity.y > 0 )
				{
					play("fall");
				}
				else if (velocity.x == 0)
				{
					play("idle");
				}
				else
				{
					play("move");
				}
			}
			
			super.update();
			
			
		}
	
		
	}

}