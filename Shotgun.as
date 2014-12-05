package  
{
	import flash.display.MovieClip;
	
	public class Shotgun extends Projectile
	{
		public function Shotgun(_owner:MovieClip, _x:Number, _y:Number, _rot:Number) 
		{
			super(_owner, _x, _y, _rot);
			
			for (var i:int = 0; i < 10; i++)
			{
				BugSpaceMain.STAGE.addChild(new ShotgunBall(_owner, _x, _y, _rot));
			}
		}
		
	}

}