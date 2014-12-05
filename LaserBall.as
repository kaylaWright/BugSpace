package  
{
	import flash.events.Event;
	import flash.display.MovieClip;
	
	public class LaserBall extends Projectile
	{
		
		public function LaserBall(_owner:MovieClip, _x:Number, _y:Number, _rot:Number) 
		{
			super(_owner, _x, _y, _rot);
			
			this.damage = 5;

			addEventListener(Event.ENTER_FRAME, Update, false, 0, true);
		}
		
		override public function Update(e:Event) : void
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
