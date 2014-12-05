//BOSS BUG: 

package  
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
		
	public class StagBeetle extends Bug
	{
		private const TIMESTEP:Number = 1 / 32;
		
		//locomoootion
		//static.position = this.x, this.y
		//static.orientation = rotation.
		private var velocity:Vector2D = new Vector2D();
		private var rotate:Number = 0;
		private var linearAccel:Vector2D = new Vector2D();
		private var angularAccel:Number = 0;
		
		private var maxRotation = 5;
		private var hasArrived:Boolean = false;
		
		private var forwardRay:Vector2D = new Vector2D();
		
		//keeps track of the boss minions.
		public var minions:Vector.<Bug> = new Vector.<Bug>();
		
		public function StagBeetle(_target:MovieClip) 
		{
			super(_target);
			damageFactor = 5; 
			speed = 20;
			
			this.addEventListener(Event.ADDED_TO_STAGE, SpawnMinions, false, 0, true);
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
			//make sure it doesn't wander TOO far away.
			var dX:Number = target.x - this.x;
			var dY:Number = target.y - this.y; 
			var distance:Number = Math.sqrt((dX * dX) + (dY * dY));
			
			if (distance > 300)
			{
				hasArrived = false;
			}
			
			if (hasArrived && Math.random() < 0.1)
			{
				//shoot something at the player, alongside with minions. 
				//FacePosition(target.x, target.y);
				Fire(new TimerEvent(TimerEvent.TIMER, false, false));
				
				
			}
			else
			{
				if (!hasArrived)
				{
					Arrive();
					FacePosition(target.x, target.y);
				}
				
				if (velocity.GetLength() < 5)
				{
					hasArrived = true;
					Wander();
					//FacePosition(this.x + velocity.x, this.y + velocity.y);
				}
			}
		}
		
		private function Arrive():void
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
		
		//wander with some punk ass collision avoidance.
		private function Wander():void
		{
			this.rotation += maxRotation * (Math.random() - Math.random());
			
			velocity.x = Math.cos(DegToRad(rotation));//new position just in front.
			velocity.y = Math.sin(DegToRad(rotation));
			
			forwardRay.x = this.x + velocity.x * 50;
			forwardRay.y = this.y + velocity.y * 50;
			
			if (!RayIntersectsObject(forwardRay, target.x, target.y, target.width / 1.5))
			{
				this.x += Math.cos(DegToRad(rotation)) * 2;
				this.y += Math.sin(DegToRad(rotation)) * 2;
			}
		}
		
		override public function Fire(e:TimerEvent) : void
		{
			for each(var minion:Bug in minions)
			{
				minion.SetTarget(target);
				minion.FacePosition(target.x, target.y);
				minion.Fire(new TimerEvent(TimerEvent.TIMER, false, false));
				
				minion.SetTarget(this);
			}
		}
		
		private function RayIntersectsObject(_ray:Vector2D, _obstacleX:Number, _obstacleY:Number, _rad:Number) : Boolean
		{
			var dX:Number = _obstacleX - _ray.x;
			var dY:Number = _obstacleY - _ray.y; 
			var distance:Number = Math.sqrt((dX * dX) + (dY * dY));
			
			return (distance <= _rad);
		}
		
		private function SpawnMinions(e:Event)
		{
			addEventListener(Event.ENTER_FRAME, Update, false, 0, true);
			
			var rndAngle:Number;
			for (var i:int = 0; i < 3; i++)
			{
				var temp:Pillbug = new Pillbug(this);
				temp.SetComfortZone(80);
				rndAngle = Math.random() * Math.PI * 2;
				temp.speed = 5;
				
				temp.x = this.x + (Math.sin(rndAngle) * temp.GetComfortZone());
				temp.y = this.y + (Math.cos(rndAngle) * temp.GetComfortZone());
				
				minions.push(temp);
				BugSpaceMain.STAGE.addChild(temp);
			}
		}
		
	}
}
