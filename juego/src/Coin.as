package src

{

	import org.flixel.*;

	public class Coin extends FlxSprite

	{

	[Embed(source = 'coin.png')] private var ImgCoin1:Class;

	public function Coin(X:Number,Y:Number):void

	{

		super(X, Y);

		loadGraphic(ImgCoin1, true, true, 16, 16 );

		addAnimation("spin", [0, 1, 2, 3], 10);

		play("spin");

		}

	}
	
}


