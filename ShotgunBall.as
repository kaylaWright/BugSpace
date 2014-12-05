package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class ShotgunBall extends Projectile
	{
		private var range:Number;
		
		private var startPos:Point = new Point();
		
		public function ShotgunBall(_owner:MovieClip, _x:Number, _y:Number, _rot:Number) 
		{
			this.rotation = _rot + ((Math.random() - Math.random()) * 20);
			super(_owner, _x, _y, this.rotation);
			
			this.speed = Math.floor(Math.random() * 9) + 3;
			this.range = Math.floor(Math.random() * 100) + 250;
			this.scaleX = this.scaleY = Math.floor(Math.random() * 1.5) + 1;
			
			damage = this.scaleX * 10;
			
			startPos.x = _x;
			startPos.y = _y;
			
			//randoming up some shotgun values.
			
			addEventListener(Event.ENTER_FRAME, Update, false, 0, true);
		}
		
		override public function Update(e:Event) : void
		{
			this.x += this.vX;
			this.y += this.vY;
			
			CheckRangeReached();
		}
		
		public function CheckRangeReached()
		{
			var startX:Number = startPos.x;
			var startY:Number = startPos.y;
			
			var dX:Number = this.x - startX;
			var dY:Number = this.y - startY; 
			
			var distance:Number = Math.sqrt((dX * dX) + (dY * dY));
			
			if (distance >= range)
			{
				removeEventListener(Event.ENTER_FRAME, Update);
				Destroy();
			}
		}
	}
	
}
