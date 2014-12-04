//lieutenant.

package  
{
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class WaterStrider extends Bug
	{
		private const TIMESTEP:Number = 1 / 32;
		
		//static.position = this.x, this.y
		//static.orientation = rotation.
		private var velocity:Vector2D = new Vector2D();
		private var rotate:Number = 0;
		private var linearAccel:Vector2D = new Vector2D();
		private var angularAccel:Number = 0;
		
		private var angle = 0;
		private var pixSpeed = 4;
		private var orbitSpeed = 0.75;
		
		//retains player while bug is afraid of grenades. 
		private var primaryTarget:MovieClip;
		
		private var fireTimer:Timer = new Timer(1000, 0);
		
		public function WaterStrider(_target:MovieClip) 
		{
			super(_target);
			primaryTarget = _target;
			
			damageFactor = 2; 
			speed = 50;
			
			goalLocation.x = target.x;
			goalLocation.y = target.y;
			
			addEventListener(Event.ENTER_FRAME, Update, false, 0, true);
		}
		
		override public function Update(e:Event) : void
		{
			Move();
			
			this.x += velocity.x * TIMESTEP;
			this.y += velocity.y * TIMESTEP;
			this.rotation += rotate * TIMESTEP;
			
			velocity.x += linearAccel.x * TIMESTEP;
			velocity.y += linearAccel.y * TIMESTEP;
			rotate += angularAccel * TIMESTEP;
		}
		
		private function Move()
		{
			if (CheckForGrenades())
			{
				speed = 200;
				
				fireTimer.removeEventListener(TimerEvent.TIMER, Fire, false);
				fireTimer.stop();
				
				Flee();
				FacePosition(this.x + velocity.x, this.y + velocity.y);
			}
			else
			{
				//also arrive. 
				speed = 50;
				Arrive();
				FacePosition(target.x, target.y);
				
				if (velocity.GetLength() < 5)
				{
					CircleTarget();
					
					fireTimer.addEventListener(TimerEvent.TIMER, Fire, false, 0, true);
					fireTimer.start();
				}
			}
		}
		
		private function CircleTarget()
		{
			if (Math.random() < 0.05)
			{
				orbitSpeed *= -1;
			}
			
			angle += orbitSpeed;
			
			var radians:Number = DegToRad(angle);
			this.x = target.x + comfortZone * Math.cos(radians);
			this.y = target.y + comfortZone * Math.sin(radians);
		}
		
		private function Arrive()
		{
			velocity.x = target.x - this.x;
			velocity.y = target.y - this.y;
			
			if (velocity.GetLength() < comfortZone)
			{
				velocity.x = 0;
				velocity.y = 0;
				return;
			}
			
			velocity.Normalize();
			velocity.x *= speed;
			velocity.y *= speed;
			
			this.rotation = GetNewOrientation(velocity);
			rotate = 0;
		}
		
		private function Flee()
		{
			velocity.x = this.x - target.x;
			velocity.y = this.y - target.y;
			velocity.Normalize();
			velocity.x *= speed;
			velocity.y *= speed;
			
			this.rotation = GetNewOrientation(velocity);
			
			rotate = 0;
		}
		
		private function GetNewOrientation(_new:Vector2D) : Number
		{
			if (_new.GetLength() > 0)
			{
				return Math.atan2( -this.x, this.y);
			}
			else
			{
				return this.rotation;
			}
		}
		
		override public function Fire(e:TimerEvent) : void
		{
			var rnd:Number = Math.floor(Math.random() * 15) + 1;
			
			if (rnd == 1)
			{
				BugSpaceMain.STAGE.addChild(new Shotgun(this.x, this.y, this.rotation));
			}
			else
			{
				BugSpaceMain.STAGE.addChild(new ShotgunBall(this.x, this.y, this.rotation));
			}
			
		}
		
		private function CheckForGrenades() : Boolean
		{
			for (var i:int = 0; i < BugSpaceMain.STAGE.numChildren; i++)
			{
				if (BugSpaceMain.STAGE.getChildAt(i) is Grenade)
				{
					SetTarget(BugSpaceMain.STAGE.getChildAt(i) as MovieClip);
					return true;
				}
			}
			
			SetTarget(primaryTarget);
			
			return false;
		}
	}
}
