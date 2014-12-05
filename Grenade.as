package  {
	
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	
	public class Grenade extends Projectile
	{
		private const RANGE:Number = 150;
		
		private var startPos:Point = new Point();
		
		private var explosionTimer:Timer = new Timer(2000, 1);
		private var growth:Number = 2;
		private var isGrowing:Boolean = false;
		
		public function Grenade(_owner:MovieClip, _x:Number, _y:Number, _rot:Number) 
		{
			super(_owner, _x, _y, _rot);
			
			speed = 10.0;
			startPos.x = _x;
			startPos.y = _y;
			
			this.damage = 100;
			
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
			
			if (distance >= RANGE)
			{
				this.vX = 0;
				this.vY = 0;
				removeEventListener(Event.ENTER_FRAME, Update);
				
				explosionTimer.addEventListener(TimerEvent.TIMER, Explode, false, 0, true);
				explosionTimer.start();
			}
		}
		
		private function Explode(e:TimerEvent) : void
		{
			this.addEventListener(Event.ENTER_FRAME, AdjustExplosion);
			isGrowing = true;
		}
		
		private function AdjustExplosion(e:Event): void
		{
			if (isGrowing)
			{
				
				this.width += growth;
				this.height += growth;
				growth *= 1.5;
				if (growth > 100)
				{
					isGrowing = false;
				}
			}
			else 
			{
				this.width -= growth;
				this.height -= growth;
				growth /= 1.5;
				
			}
			
			if (growth < 2)
			{
				this.removeEventListener(Event.ENTER_FRAME, AdjustExplosion);
				Destroy();
			}
		}
	}
	
}
