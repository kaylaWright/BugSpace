package  
{
	//imports
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	import flash.text.TextField;
	import flash.events.TimerEvent;
	import flash.events.Event;
	
	import com.freeactionscript.CollisionTest;
	
	public class BugSpaceMain extends MovieClip
	{
		//canvas. 
		public static var STAGE:Stage;
		
		//background.
		private var bg:Background = new Background();
		//player ship.
		private var player:Ship;
		//enemy vectors.
		private var pbVector:Vector.<Pillbug> = new Vector.<Pillbug>();
		private var wsVector:Vector.<WaterStrider> = new Vector.<WaterStrider>();
		private var sbVector:Vector.<StagBeetle> = new Vector.<StagBeetle>();
		private var test:WaterStrider;
		private var test2:Pillbug;
		private var test3:StagBeetle;
		
		//timers.
		//3min
		private var bossTimer:Timer = new Timer(180000, 1);
		//30s
		private var swarmTimer:Timer = new Timer(10000, 5);
		//1s
		private var bossCountdownTimer:Timer = new Timer(1000, 0);
		
		//text
		private var bossCountdownText:TextField = new TextField();
		private var playerHealthText:TextField = new TextField();
		private var endgameText:TextField = new TextField();
		private var introText:TextField = new TextField();
		private var textFormat:TextFormat;
		
		//collision.
		private var collisionTest:CollisionTest = new CollisionTest();
		
		public function BugSpaceMain() 
		{
			//global stage var. 
			STAGE = this.stage;

			//texts.
			textFormat = new TextFormat()
			with (textFormat)
			{
				size = 24;
				align = "left";
				font = "arial";
			}
			
			bossCountdownText.defaultTextFormat = textFormat;
			bossCountdownText.text = "Mysterious Countdown: 3:00";
			bossCountdownText.x = 50;
			bossCountdownText.width = 350;
			bossCountdownText.textColor = 0xFF80FF;
			
			playerHealthText.defaultTextFormat = textFormat;
			playerHealthText.text = "Player Health: 100";
			playerHealthText.x = 50;
			playerHealthText.y = 500;
			playerHealthText.width = 225;
			playerHealthText.textColor = 0xFF80FF;
			
			introText.defaultTextFormat = textFormat;
			introText.text = "turns out space is full of bugs\nwhat better way to become acquainted\nwith the universe than to kill them all?\n\n\na or left arrow = rotate left.\nd or right arrow = rotate right.\nspace to fire.\nx to lob a grenade.\n\n\n\nspace to start.";
			introText.x = 50;
			introText.y = 50;
			introText.width = 650;
			introText.height = 450;
			introText.textColor = 0xFF80FF;
			introText.wordWrap = true;
			
			endgameText.defaultTextFormat = textFormat;
			endgameText.text = "You should never see this.";
			endgameText.x = 50;
			endgameText.y = 50;
			endgameText.width = 650;
			endgameText.height = 450;
			endgameText.textColor = 0xFF80FF;
			
			Introduction();
		}
		
		private function Introduction():void
		{
			STAGE.addEventListener(KeyboardEvent.KEY_UP, OnKeyUp, false, 0, true);
			
			STAGE.addChild(bg);
			CreateStarField();
			STAGE.addChild(introText);
			
		}
		
		private function SetGame():void
		{			
			//initialization as needed.
			player = new Ship();
			player.x = STAGE.stageWidth / 2;
			player.y = STAGE.stageHeight / 2;
			
			test = new WaterStrider(player);
			test2 = new Pillbug(player);
			test3 = new StagBeetle(player);
			
			wsVector.push(test);
			pbVector.push(test2);
			sbVector.push(test3);
			pbVector.concat(test3.minions);
					
			//adding to stage.
			STAGE.addChild(bg);
			CreateStarField();
			STAGE.addChild(player);
			STAGE.addChild(test);
			STAGE.addChild(test2);
			
			STAGE.addChild(bossCountdownText);
			STAGE.addChild(playerHealthText);
			
			swarmTimer.addEventListener(TimerEvent.TIMER, SpawnSwarm, false, 0, true);
			swarmTimer.start();
			bossTimer.addEventListener(TimerEvent.TIMER_COMPLETE, SpawnBoss, false, 0, true);
			bossTimer.start();
			bossCountdownTimer.addEventListener(TimerEvent.TIMER, DisplayBossCountdown, false, 0, true);
			bossCountdownTimer.start();
			
			bossCountdownText.text = "Mysterious Countdown: 3:00";
			
			STAGE.addEventListener(Event.ENTER_FRAME, Update, false, 0, true);
		}
		
		//i hate this structure, don't even look at it .
		private function Update(e:Event):void
		{
			for (var i:int = 0; i < STAGE.numChildren; i++)
			{
				if (BugSpaceMain.STAGE.getChildAt(i) is Grenade)
				{
					for (var p:int = 0; p < pbVector.length; p++)
					{
						if (collisionTest.complex(pbVector[p], STAGE.getChildAt(i) as Grenade))
						{
							pbVector[p].TakeDamage((STAGE.getChildAt(i) as Grenade).damage);
							if (pbVector[p].currentHealth <= 0)
							{
								pbVector[p].Destroy();
								pbVector.splice(p, 1);
							}
							(STAGE.getChildAt(i) as Grenade).damage = 0;
							(STAGE.getChildAt(i) as Grenade).visible = false;
						}
					}
					
					for (var p:int = 0; p < wsVector.length; p++)
					{
						if (collisionTest.complex(wsVector[p], STAGE.getChildAt(i) as Grenade))
						{
							wsVector[p].TakeDamage((STAGE.getChildAt(i) as Grenade).damage);
							if (wsVector[p].currentHealth <= 0)
							{
								wsVector[p].Destroy();
								wsVector.splice(p, 1);
							}
							(STAGE.getChildAt(i) as Grenade).damage = 0;
							(STAGE.getChildAt(i) as Grenade).visible = false;
						}
					}
					
					for (var p:int = 0; p < sbVector.length; p++)
					{
						if (collisionTest.complex(sbVector[p], STAGE.getChildAt(i) as Grenade))
						{
							sbVector[p].TakeDamage((STAGE.getChildAt(i) as Grenade).damage);
							if (sbVector[p].currentHealth <= 0)
							{
								sbVector[p].Destroy();
								sbVector.splice(p, 1);
								GameOver(true);
							}
							(STAGE.getChildAt(i) as Grenade).damage = 0;
							(STAGE.getChildAt(i) as Grenade).visible = false;
						}
					}
				}
				
				if (BugSpaceMain.STAGE.getChildAt(i) is ShotgunBall)
				{
					if (collisionTest.complex(player, STAGE.getChildAt(i) as ShotgunBall))
					{
						player.TakeDamage((STAGE.getChildAt(i) as ShotgunBall).damage);
						playerHealthText.text = "Player Health: " + player.currentHealth;
						if (player.currentHealth <= 0)
						{
							GameOver(false);
						}
						(STAGE.getChildAt(i) as ShotgunBall).damage = 0;
						(STAGE.getChildAt(i) as ShotgunBall).visible = false;
					}
				}
				
				if (BugSpaceMain.STAGE.getChildAt(i) is LaserBall)
				{
					if ((STAGE.getChildAt(i) as LaserBall).owner != player)
					{
						if (collisionTest.complex(player, STAGE.getChildAt(i) as LaserBall))
						{
							player.TakeDamage((STAGE.getChildAt(i) as LaserBall).damage);
							playerHealthText.text = "Player Health: " + player.currentHealth;
							if (player.currentHealth <= 0)
							{
								GameOver(false);
							}
							(STAGE.getChildAt(i) as LaserBall).damage = 0;
							(STAGE.getChildAt(i) as LaserBall).visible = false;
						}
					}
					else
					{
						for (var p:int = 0; p < pbVector.length; p++)
						{
							if (collisionTest.complex(pbVector[p], STAGE.getChildAt(i) as LaserBall))
							{
								pbVector[p].TakeDamage((STAGE.getChildAt(i) as LaserBall).damage);
								if (pbVector[p].currentHealth <= 0)
								{
									pbVector[p].Destroy();
									pbVector.splice(p, 1);
								}
								(STAGE.getChildAt(i) as LaserBall).damage = 0;
								(STAGE.getChildAt(i) as LaserBall).visible = false;
							}
						}
						
						for (var p:int = 0; p < wsVector.length; p++)
						{
							if (collisionTest.complex(wsVector[p], STAGE.getChildAt(i) as LaserBall))
							{
								wsVector[p].TakeDamage((STAGE.getChildAt(i) as LaserBall).damage);
								if (wsVector[p].currentHealth <= 0)
								{
									wsVector[p].Destroy();
									wsVector.splice(p, 1);
								}
								(STAGE.getChildAt(i) as LaserBall).damage = 0;
								(STAGE.getChildAt(i) as LaserBall).visible = false;
							}
						}
						
						for (var p:int = 0; p < sbVector.length; p++)
						{
							if (collisionTest.complex(sbVector[p], STAGE.getChildAt(i) as LaserBall))
							{
								sbVector[p].TakeDamage((STAGE.getChildAt(i) as LaserBall).damage);
								if (sbVector[p].currentHealth <= 0)
								{
									sbVector[p].Destroy();
									sbVector.splice(p, 1);
									GameOver(true);
								}
								(STAGE.getChildAt(i) as LaserBall).damage = 0;
								(STAGE.getChildAt(i) as LaserBall).visible = false;
							}
						}
					}
				}
			}
		}
		
		private function ClearLevel()
		{
			while (STAGE.numChildren > 0) 
			{
				STAGE.removeChildAt(0);
			}
			
			for (var p:int = 0; p < pbVector.length; p++)
			{
				pbVector[p].Destroy();
				//pbVector[p] = null;
				pbVector.splice(p, 1);
			}
			pbVector = new Vector.<Pillbug>();
			
			for (var p:int = 0; p < wsVector.length; p++)
			{
				wsVector[p].Destroy();
				wsVector[p] = null;
				wsVector.splice(p, 1);
			}
			wsVector = new Vector.<WaterStrider>();
			
			for (var p:int = 0; p < sbVector.length; p++)
			{
				sbVector[p].Destroy();
				sbVector[p] = null;
				sbVector.splice(p, 1);
			}
			sbVector = new Vector.<StagBeetle>();
			
			player = null;
			test = null;
			test2 = null;
			test3 = null;
			
			bossCountdownTimer.reset();
			bossCountdownTimer.removeEventListener(TimerEvent.TIMER, DisplayBossCountdown, false);
			bossTimer.reset();
			bossTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, SpawnBoss, false);
			swarmTimer.reset();
			swarmTimer.removeEventListener(TimerEvent.TIMER, SpawnSwarm, false);
		}
		
		private function GameOver(_isWin:Boolean):void
		{
			STAGE.removeEventListener(Event.ENTER_FRAME, Update, false);
			
			ClearLevel();
			
			if (_isWin)
			{
				endgameText.text = "Congratulations.\nYou win.\nRevel in your victory.\n\n\nPress space to play again.";
			}
			else
			{
				endgameText.text = "Squashed!\nYou lose.\n\n\n\nPress space to play again.";
			}
			
			STAGE.addChild(bg);
			STAGE.addChild(endgameText);
			
			STAGE.addEventListener(KeyboardEvent.KEY_UP, OnKeyUp, false, 0, true);
		}
		
		private function OnKeyUp(e:KeyboardEvent):void
		{
	
			if (e.keyCode == Keyboard.SPACE)
			{
				STAGE.removeEventListener(KeyboardEvent.KEY_UP, OnKeyUp);
				ClearLevel();
				SetGame();
			}
		}
		
		//timer events.
		private function SpawnSwarm(e:TimerEvent):void
		{
			trace("SWARM.");
			var rnd:Number  = Math.floor(Math.random() * 9) + 3;
			
			for (var i:int = 0; i < rnd; i++)
			{
				var rnd2:Number = Math.floor(Math.random() * 5) + 1;
				switch(rnd2)
				{
					case 1:
						var ws:WaterStrider = new WaterStrider(player);
						STAGE.addChild(ws);
						wsVector.push(ws);
						break;
					default:
						var pb:Pillbug = new Pillbug(player);
						STAGE.addChild(pb);
						pbVector.push(pb);
						break;
				}
			}
		}
		
		private function SpawnBoss(e:TimerEvent):void
		{
			STAGE.addChild(test3);
		}
		
		private function  DisplayBossCountdown(e:TimerEvent):void
		{
			bossCountdownText.text = "Mysterious Countdown: " + (ConvertToTimeCode(bossTimer.delay - (bossCountdownTimer.currentCount * 1000)));
		}
		
		public static function ConvertToTimeCode(_m:int) : String 
		{
			if (_m < 0)
			{
				return "It's time.";
			}
			
			var temp:Number = _m;
			var seconds:Number = Math.floor( (_m / 1000) % 60);
			var secondsStr:String;
			if (seconds > 10)
			{
				secondsStr = seconds.toString();
			}
			else
			{
				secondsStr = "0" + seconds.toString();
			}
			
			var minutes:Number = Math.round(Math.floor((_m / 1000) / 60));
			var minutesStr:String;
			if (minutes >= 10)
			{
				minutesStr = minutes.toString();
			}
			else
			{
				minutesStr = "0" + minutes.toString();
			}
			
			var timeCode:String = minutesStr + ":" + secondsStr;
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