package src
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import org.flixel.*;
	
	public class Invader extends FlxSprite
	{
		public static const SIZE: FlxPoint = new FlxPoint(16, 16);
		
		private var sprite1:FlxSprite;
		
		private var frame1:Boolean = true;
		private var counter:Number = 0;
		
		private	var tPixels1:BitmapData;
		private	var tPixels2:BitmapData;
		
		public function Invader(X:Number=0,Y:Number=0):void
		{
			super(X, Y);
			
			generate();
			
			frame1 = false;
			pixels = tPixels1;
		}
		
		public function generate():void 
		{
			tPixels1 = new BitmapData(16, 16, true, 0xff0ff000);
			tPixels2 = new BitmapData(16, 16, true, 0xff0ff000);
			
			var show:uint = 0xFFFFFFFF;
			var hide:uint = 0xffff0000;
					
			//generate Invader body
			//temp Variables for iteration
			var iX:int = 0;
			var iY:int = 0;
			
			//find where the body is going to be
			var bodyTop:int = FlxU.random() * 6  + 4;// r.Next(4, 10);
			var bodyPad:int = FlxU.random() * 3  + 3;//r.Next(3, 6);
			var bodyHeight:int = FlxU.random() * 3 + 3;//r.Next(3, 6);
			
			//Fill in the body
			for (iY = bodyTop; iY < bodyTop + bodyHeight; iY++)
			{
				for (iX = bodyPad; iX  < 8; iX ++)
				{
					tPixels1.setPixel32(iX, iY, show);
					tPixels2.setPixel32(iX, iY, show);
				}
			}
			
			//indents
			if (FlxU.random() > 0.4)
			{
				tPixels1.setPixel32(bodyPad, bodyTop, hide);
				tPixels2.setPixel32(bodyPad, bodyTop, hide);
			}
			if (FlxU.random() > 0.4)
			{
				tPixels1.setPixel32(bodyPad, bodyTop + bodyHeight - 1, hide);
				tPixels2.setPixel32(bodyPad, bodyTop + bodyHeight - 1, hide);
			}
			
			 //animated appendages
			if (FlxU.random() > 0.5)
			{
				//legs
				var legp1Indent:int = FlxU.random() * 4 - 1;
				var legp2Indent:int = FlxU.random() * 5 - 2;
				
				tPixels1.setPixel32((bodyPad + legp1Indent), (bodyTop + bodyHeight), show);
				tPixels1.setPixel32((bodyPad + legp1Indent+ legp2Indent), (bodyTop + bodyHeight + 1), show);
				tPixels2.setPixel32((bodyPad + legp1Indent), (bodyTop + bodyHeight), show);
				tPixels2.setPixel32((bodyPad + legp1Indent - legp2Indent), (bodyTop + bodyHeight + 1), show);
				
			}
			else
			{
				//arms
				var armp1Indent:int = FlxU.random() * (bodyHeight + 1) - 1;
				var armp2Indent:int = FlxU.random() * 3 - 1;
				
				tPixels1.setPixel32(bodyPad - 1, bodyTop + armp1Indent, show);
				tPixels1.setPixel32(bodyPad - 2, bodyTop + armp1Indent + armp2Indent, show);
				tPixels2.setPixel32(bodyPad - 1, bodyTop + armp1Indent, show);
				tPixels2.setPixel32(bodyPad - 2, bodyTop + armp1Indent - armp2Indent, show);
			}
				
			//eyes
			if (FlxU.random() > 0.3)
			{
				var eyeIndent:int = FlxU.random() * 3 + 1;// (1, 3);
				tPixels1.setPixel32(bodyPad + eyeIndent, bodyTop + (bodyHeight / 2), hide);
				tPixels2.setPixel32(bodyPad + eyeIndent, bodyTop + (bodyHeight / 2), hide);
				
				if (FlxU.random() > 0.5)
				{ 
				tPixels2.setPixel32(bodyPad + eyeIndent, bodyTop + (bodyHeight / 2), show);
				}
			}
			
			for (iY = 0; iY < 16; iY++)
			{
				for (iX = 8; iX  < 16; iX++)
				{
					tPixels1.setPixel32(iX, iY, tPixels1.getPixel32(15 - iX, iY));
					tPixels2.setPixel32(iX, iY, tPixels2.getPixel32(15 - iX, iY));
				}
			}
		}
		
		override public function update():void
		{
			super.update();
			counter += FlxG.elapsed;
			if (counter >= 0.2)
			{
				counter = 0;
				if (frame1)
				{
					frame1 = false;
					pixels = tPixels1;
				}
				else 
				{
					frame1 = true;
					pixels = tPixels2;
				}
			}
		}
	}
}
