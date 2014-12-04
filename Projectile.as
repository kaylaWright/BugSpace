package  
{
	import flash.display.MovieClip;
	import flash.events.Event;

	public class Projectile extends MovieClip
	{
		protected var speed:Number = 5.0;
		protected var vX:Number = 0;
		protected var vY:Number = 0;
		
		public function Projectile(_x:Number, _y:Number, _rot:Number) 
		{
			this.rotation = _rot;
			vX = Math.cos(DegToRad(rotation)) * speed;
			vY = Math.sin(DegToRad(rotation)) * speed;
			
			this.x = _x + vX * 2;
			this.y = _y + vY * 2;
		}
		
		protected function Destroy() : void
		{
			if (parent)
			{
				parent.removeChild(this);
			}
		}

		//helpers.
		protected function DegToRad(degrees:Number) : Number
		{
			return (degrees * Math.PI) / 180;
		}
	}

}