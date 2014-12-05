//easiest enemy; point a to point b, fires until dead. 

package 
{
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class Pillbug extends Bug
	{
		private var fireTimer:Timer = new Timer(2000, 0);
		
		private var flockingTarget:MovieClip;
		
		public function Pillbug(_target:MovieClip) 
		{
			super(_target);
			damageFactor = 20; 
			speed = 1;
			
			goalLocation.x = target.x;
			goalLocation.y = target.y;
			//FindClosestPointOnCircle(target.x, target.y, comfortZone);
			
			addEventListener(Event.ENTER_FRAME, Update, false, 0, true);
		}
		
		override public function Update(e:Event) : void
		{
			Move();
			FacePosition(target.x, target.y);
		}
		
		private function Move()
		{
			//the SIMPLEST arrive behaviour.
			//doesn't utilize the steering from class, just general math and logic. 
			var startX:Number = this.x;
			var startY:Number = this.y;
			
			goalLocation.x = target.x;
			goalLocation.y = target.y;
			
			var dX:Number = goalLocation.x - startX;
			var dY:Number = goalLocation.y - startY; 
			
			var distance:Number = Math.sqrt((dX * dX) + (dY * dY));
			
			if (distance > comfortZone)
			{
				this.x += Math.cos(DegToRad(rotation)) * speed;
				this.y += Math.sin(DegToRad(rotation)) * speed;
			}
			else
			{
				fireTimer.addEventListener(TimerEvent.TIMER, Fire, false, 0, true);
				fireTimer.start();
			}
		}
		
		override public function Fire(e:TimerEvent) : void
		{
			//fire a spitwad. 
			//change to spits. 
			if (!(target is Bug))
			{
				BugSpaceMain.STAGE.addChild(new LaserBall(this, this.x, this.y, this.rotation));
			}
			
			//slightly randomize the next firing.
			fireTimer.delay = Math.floor(Math.random() * 1000 + 1750);
		}
		
		override public function Destroy() : void
		{
			if (this.parent)
			{
				this.parent.removeChild(this);
			}
			
			fireTimer.stop();
			//ignored call if not there.
			removeEventListener(Event.ENTER_FRAME, Update);
			removeEventListener(TimerEvent.TIMER, Fire);
		}
	}
	
}
