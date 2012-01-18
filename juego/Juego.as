package 

{

	import org.flixel.*;
	import src.*;

	[SWF(width="640", height="480", backgroundColor="#000000")]

	[Frame(factoryClass="Preloader")]



	public class Juego extends FlxGame

	{

		public function Juego()

		{

			super(320,240,MenuState,2);

		}

	}

}

