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
		
		public function Pillbug(_target:MovieClip) 
		{
			super(_target);
			damageFactor = 5; 
			speed = 1;
			
			goalLocation.x = target.x;
			goalLocation.y = target.y;
			//FindClosestPointOnCircle(target.x, target.y, comfortZone);
			
			addEventListener(Event.ENTER_FRAME, Update, false, 0, true);
		}
		
		override public function Update(e:Event) : void
		{
			Move();
		}
		
		private function Move()
		{
			//the SIMPLEST arrive behaviour.
			//doesn't utilize the steering from class, just general math and logic. 
			var startX:Number = this.x;
			var startY:Number = this.y;
			
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
				FacePosition(target.x, target.y);
				removeEventListener(Event.ENTER_FRAME, Update, false);
				
				fireTimer.addEventListener(TimerEvent.TIMER, Fire, false, 0, true);
				fireTimer.start();
			}
		}
		
		override public function Fire(e:TimerEvent) : void
		{
			//fire a spitwad. 
			//change to spits. 
			BugSpaceMain.STAGE.addChild(new LaserBall(this.x, this.y, this.rotation));
			
			//slightly randomize the next firing.
			fireTimer.delay = Math.floor(Math.random() * 1000 + 1750);
		}
	}
	
}
