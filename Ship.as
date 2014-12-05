package  
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	public class Ship extends MovieClip 
	{
		//game vars.
		public const FULLHEATH:Number = 100;
		public var currentHealth:Number = 100;
		
		//movement vars. 
		private var maxRotationSpeed:Number = 3.0;
		private var hangRotate:Number = 0; 
		private var friction:Number = 0.9; 
		private var isRotating:Boolean = false;
		
		private var isLeft:Boolean = false; 
		private var isRight:Boolean = false; 
		
		//the bullets.
		//constructor
		public function Ship()
		{
			name = "Player.";
			
			BugSpaceMain.STAGE.addEventListener(KeyboardEvent.KEY_DOWN, OnKeyDown, false, 0, true);
			BugSpaceMain.STAGE.addEventListener(KeyboardEvent.KEY_UP, OnKeyUp, false, 0, true);
			BugSpaceMain.STAGE.addEventListener(Event.ENTER_FRAME, Update, false, 0, true);
		}
		
		//events
		public function Update(e:Event) : void 
		{
			if (isLeft)
			{
				this.rotation -= maxRotationSpeed;
				this.hangRotate = -maxRotationSpeed;
			}
			
			if (isRight)
			{
				this.rotation += maxRotationSpeed;
				this.hangRotate = maxRotationSpeed;
			}
			
			if (isRotating)
			{
				this.rotation += this.hangRotate;
				this.hangRotate *= friction;
			}
				
		}
		
		public function OnKeyDown(e:KeyboardEvent) : void
		{
			switch(e.keyCode)
			{
				//rotate according to direction pressed.
				case Keyboard.RIGHT:
				case Keyboard.D:
					isRight =  true;
					isRotating = false;
					break;
				case Keyboard.LEFT:
				case Keyboard.A:
					isLeft = true;
					isRotating = false;
					break;
				case Keyboard.SPACE:
					FireLaser();
				//?
				default:
					break;
			}
			

			
		}
		
		public function OnKeyUp(e:KeyboardEvent) : void
		{
		
			
			switch(e.keyCode)
			{
				//incur slowdown.
				case Keyboard.RIGHT:
				case Keyboard.D:
					isRight = false;
					isRotating = true;
					break;
				case Keyboard.LEFT:
				case Keyboard.A:
					isLeft = false;
					isRotating = true;
					break;
				case Keyboard.X:
					BugSpaceMain.STAGE.addChild(new Grenade(this, this.x, this.y, this.rotation));
					break;
				//?
				default:
					break;
			}
		}
		
		//general
		private function FireLaser()
		{
			BugSpaceMain.STAGE.addChild(new LaserBall(this, this.x, this.y, this.rotation));
		}
		
		public function TakeDamage(_damage:Number)
		{
			currentHealth -= _damage;
		}
		
		public function Die()
		{
			
		}
		
		//helpers.
		private function DegToRad(degrees:Number) : Number
		{
			return (degrees * Math.PI) / 180;
		}
		
		public function Destroy() : void
		{
			if (this.parent)
			{
				parent.removeChild(this);
			}
			
			this.removeEventListener(Event.ENTER_FRAME, Update, false);
		}
	}
	
}
