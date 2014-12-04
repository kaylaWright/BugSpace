package  
{
	//imports
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	import flash.text.TextField;
	import flash.events.TimerEvent;

	public class BugSpaceMain extends MovieClip
	{
		//canvas. 
		public static var STAGE:Stage;
		
		//background.
		private var bg:Background = new Background();
		
		//player ship.
		private var player:Ship;
		
		//enemy vector.
		private var test:WaterStrider;
		private var test2:Pillbug;
		
		//bosstimer.
		//3min
		private var bossTimer:Timer = new Timer(180000, 1);
		//30s
		private var swarmTimer:Timer = new Timer(30000, 5);
		//1s
		private var bossCountdownTimer:Timer = new Timer(1000, 0);
		private var bossCountdownText:TextField = new TextField();
		private var bossCountdownTextFormat:TextFormat;
		
		public function BugSpaceMain() 
		{
			//global stage var. 
			STAGE = this.stage;
			
			//initialization as needed.
			player = new Ship();
			player.x = STAGE.stageWidth / 2;
			player.y = STAGE.stageHeight / 2;
			
			test = new WaterStrider(player);
			test2 = new Pillbug(player);
			
			//texts.
			bossCountdownTextFormat = new TextFormat()
			with (bossCountdownTextFormat)
			{
				size = 24;
				align = "left";
				font = "arial";
			}
			
			bossCountdownText.defaultTextFormat = bossCountdownTextFormat;
			bossCountdownText.text = "Mysterious Countdown: 3:00";
			bossCountdownText.x = 50;
			bossCountdownText.width = 350;
			bossCountdownText.textColor = 0xFF80FF;
			
		
			//adding to stage.
			STAGE.addChild(bg);
			
			CreateStarField();
			
			STAGE.addChild(player);
			STAGE.addChild(test);
			STAGE.addChild(test2);
			
			STAGE.addChild(bossCountdownText);
			
			swarmTimer.addEventListener(TimerEvent.TIMER, SpawnSwarm, false, 0, true);
			swarmTimer.start();
			
			bossTimer.addEventListener(TimerEvent.TIMER_COMPLETE, SpawnBoss, false, 0, true);
			bossTimer.start();
			
			bossCountdownTimer.addEventListener(TimerEvent.TIMER, DisplayBossCountdown, false, 0, true);
			bossCountdownTimer.start();
		}
		
		//timer events.
		private function SpawnSwarm(e:TimerEvent):void
		{
			
		}
		
		private function SpawnBoss(e:TimerEvent):void
		{
			
		}
		
		private function  DisplayBossCountdown(e:TimerEvent):void
		{
			bossCountdownText.text = "Mysterious Countdown: " + (ConvertToTimeCode(bossTimer.delay - (bossCountdownTimer.currentCount * 1000)));
		}
		
		public static function ConvertToTimeCode(_m:int) : String 
		{
			var temp:Number = _m;
			var seconds:Number = Math.floor( (_m / 1000) % 60);
			var minutes:Number = Math.round(Math.floor((_m / 1000) / 60));
			
			var timeCode:String = minutes.toString() + ":" + seconds.toString();
			return timeCode;
		}
		
		private function CreateStarField()
		{
			for (var i:int = 0; i < 80; i++)
			{
				var xPos:Number = Math.floor(Math.random() * 750);
				var yPos:Number = Math.floor(Math.random() * 550);
				
				var temp:Star = new Star();
				temp.x = xPos;
				temp.y = yPos;
				STAGE.addChild(temp);
			}
		}
	}
}

//KW