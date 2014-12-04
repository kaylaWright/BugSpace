//BOSS BUG: 

package  
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class StagBeetle extends Bug
	{
		public function StagBeetle(_target:MovieClip) 
		{
			super(_target);
			damageFactor = 5; 
			speed = 2;
			
			addEventListener(Event.ENTER_FRAME, Update, false, 0, true);
		}
		
		override public function Update(e:Event) : void
		{
			
		}
	}
}
