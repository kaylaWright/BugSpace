package  
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.display.Shape;
	import flash.events.Event;
	
	public class Star extends MovieClip
	{
		private var circle:Shape;
		private var isFade:Boolean = false;
		
		public function Star() 
		{
			this.alpha = Math.random();
			
			var colourArray:Array = new Array(0x000000, 0xFFFFCA, 0xCAE4FF, 0xFECBFD, 0xE6C5FA, 0xCFFAC5); 
			var colour:Number = Math.floor(Math.random() * colourArray.length); 
			
			circle = new Shape();
			circle.graphics.clear();
			circle.graphics.lineStyle(0, colourArray[colour], this.alpha);
			circle.graphics.beginFill(colourArray[colour], this.alpha);
			circle.graphics.drawCircle(x, y, Math.random() + 1);
			circle.graphics.endFill();
			addChild(circle);
			
			addEventListener(Event.ENTER_FRAME, Update, false, 0, true);
		}
		
		public function Update(e:Event)
		{
			if (isFade)
			{
				this.alpha -= 0.04;
				if (this.alpha <= 0)
				{
					isFade = false;
				}
			}
			else
			{
				this.alpha += 0.04;
				if (this.alpha >= 1)
				{
					isFade = true;
				}
			}
			
			
			
		}
		
	}

}