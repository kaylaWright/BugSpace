package  
{
	import flash.display.MovieClip;
	
	public class Shotgun extends Projectile
	{
		public function Shotgun(_x:Number, _y:Number, _rot:Number) 
		{
			super(_x, _y, _rot);
			
			for (var i:int = 0; i < 10; i++)
			{
				BugSpaceMain.STAGE.addChild(new ShotgunBall(_x, _y, _rot));
			}
		}
		
	}

}