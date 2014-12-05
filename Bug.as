package  
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.events.Event;
	import flash.events.TimerEvent;

	public class Bug extends MovieClip
	{
		//health.
		public const FULLHEALTH:Number = 100;
		public var currentHealth:Number = 100;
		public var damageFactor:Number;

		//movement. 
		public var speed:Number; 

		//locomotives.
		protected var target:MovieClip;
		protected var goalLocation:Point = new Point();
		protected var comfortZone:Number = 200;

		//want the enemies to spawn offscreen. Two rectangles; spawn space and excluded space.
		private var spawnRect:Rectangle = new Rectangle(0, 0, 750, 550);

		//want them to have a target point on the circle.

		public function Bug(_target:MovieClip) 
		{
			target = _target;
			Spawn();
			FacePosition(target.x, target.y);
		}

		//spawns the bug somewhere off the screen.
		public function Spawn() : void 
		{
			var xSpawn:Number;
			var ySpawn:Number;

			//random x.
			if (Math.random() > 0.5) 
			{
			//top.
			if (Math.random() > 0.5)
			{
			ySpawn = spawnRect.y - this.height;
			}
			//bottom.
			else
			{
			ySpawn = spawnRect.height;
			}

			xSpawn = RandomInRange(0, 750);
			}
			//random y.
			else
			{
			//left
			if (Math.random() > 0.5)
			{
			xSpawn  = spawnRect.x - this.width;
			}
			//right
			else
			{
			xSpawn = spawnRect.width;
			}

			ySpawn = RandomInRange(0, 550);
			}

			this.x = xSpawn;
			this.y = ySpawn;
		}

		//useful for killing bugs later.
		public function Destroy() : void
		{
			if (this.parent)
			{
				this.parent.removeChild(this);
			}
			
			//ignored call if not there.
			removeEventListener(Event.ENTER_FRAME, Update);
			removeEventListener(TimerEvent.TIMER, Fire);
		}
		
		public function Update(e:Event):void
		{

		}

		public function Fire(e:TimerEvent) : void
		{

		}

		public function TakeDamage(_damage:Number)
		{
			currentHealth -= _damage * damageFactor;
		}

		//getsets.
		public function GetTarget(): MovieClip
		{ return target; }
		public function SetTarget(_new:MovieClip) : void
		{ target = _new; }
		public function GetGoalPosition(): Point
		{ return goalLocation; }
		public function SetGoalPosition(_new:Point)
		{ goalLocation = _new; }
		public function SetComfortZone(_new:Number):void
		{ comfortZone = _new; }
		public function GetComfortZone() : Number
		{ return comfortZone; }

		protected function GetNewOrientation(_new:Vector2D) : Number
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

		public function FacePosition(_x:Number, _y:Number)
		{
			var facing:Point = new Point();
			facing.x = _x - x;
			facing.y = _y - y;
			this.rotation = RadToDeg(Math.atan2(facing.y, facing.x));	
		}

		//have the bug move to the closest point on the circle.
		protected function FindClosestPointOnCircle(_x:Number, _y:Number, rad:Number)
		{
			var vecX:Number = x - _x;
			var vecY:Number = y - _y;
			var mag:Number = Math.sqrt((vecX * vecX) + (vecY * vecY));

			var goal:Point = new Point();
			goal.x = _x + vecX / mag * rad;
			goal.y = _y + vecY / mag * rad;

			goalLocation = goal;
		}

		protected function RadToDeg(_rad:Number):Number
		{
			return (_rad * (180 / Math.PI));
		}

		protected function DegToRad(degrees:Number) : Number
		{
			return (degrees * Math.PI) / 180;
		}

		protected function RandomInRange(_min:Number, _max:Number) : Number
		{
			return Math.floor(Math.random() * (_max - _min) + _min);
		}
	}
}
