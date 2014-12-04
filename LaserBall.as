package  
{
	import flash.events.Event;
	import flash.display.MovieClip;
	
	public class LaserBall extends Projectile
	{
		
		public function LaserBall(_x:Number, _y:Number, _rot:Number) 
		{	
			super(_x, _y, _rot);

			addEventListener(Event.ENTER_FRAME, Update, false, 0, true);
		}
		
		public function Update(e:Event) : void
		{
			this.x += this.vX;
			this.y += this.vY;
			
			if (this.x > 750 || this.x < 0 || this.y > 550 || this.y < 0)
			{
				Destroy();
			}
		}
		

	}
	
}
