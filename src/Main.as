package 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent
	import flash.events.TimerEvent;
	import flash.filters.BlurFilter;
	import flash.utils.Timer;
	
	
	/**
	 * ...
	 * @author Leroy Smith
	 */
	public class Main extends MovieClip
	{
		//Movieclips
		private var pl:Player;
		private var bg:Background;
	    private var tr:Terrain;
		private var em:Enemy;
		private var bh:MovieClip;
		
		
		//Shooting
		private var _wind:Number = 0;
		private var _isLoaded:Boolean = true;		
		private var _isFiring:Boolean = false;
		private var _endX:Number;
		private var _endY:Number;
		private var _startX:Number;
		private var _startY:Number;
		private var _reloadTimer:Timer;
		private var _bullets:Array = [];
		
		private var _bulletSpeed:Number = 8;		
		private var _maxDistance:Number = 5;
		private var _reloadSpeed:Number = 250; 
		private var _barrelLength:Number = 20;
		private var _bulletSpread:Number = 5;
		
		private var _dx:Number;
		private var _dy:Number;
		private var _pcos:Number;
		private var _psin:Number;
		private var _trueRotation:Number;
		
		private var _solidObjects:Array = [];
		private var _gravity:Number = .68;
		
		
		//falling
		private var numOfObjects:int = 10;
		private var fallingObjectArray:Array = [];
		private var speed:Number = 0;
		private var traject:Number = 0;
		
		//others

		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			startGame();
			
			//addEventListener(MouseEvent.CLICK, onClick);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
			addEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
			addEventListener(Event.ENTER_FRAME, loop);
			
		}
		
		private function onMove():void
		{
			pl.rotation = (180*Math.atan2(mouseY-pl.y,mouseX-pl.x))/Math.PI + 90;
		}
		
		
		var Tick= 0;
		var MaxTick = 100
		
		
		public function loop(e:Event):void
		{
			onMove();
			updateBullets();
			fire();
			moveDown();
			
			
			Tick ++
			if (Tick % MaxTick == 0) {
				_wind = (Math.random() * 10 - (10 / 2) ) / 100;
				speed = (Math.random() * 15) / 20;
				traject = (Math.random() * 8- (8 / 2)) / 20;
			}
			//trace(_wind);
		}	 
			
		public function moveDown():void
		{
			
			for each(var fallingObject in fallingObjectArray) 
			{
			fallingObject.y += speed;
			fallingObject.x += traject;
			
      
			
				if (fallingObject.y + fallingObject.height >= stage.stageHeight)
			
		if(fallingObjectArray.length <= 0) {
		removeEventListener(Event.ENTER_FRAME, moveDown);
		}
		}
		}
		
		public function startGame():void
	    {			
			bg = new Background();
			addChild(bg);
			bg.width = 2400;
			bg.height = 1600;
			
			bh = new MovieClip();
			addChild(bh);
			
			pl = new Player();
			addChild(pl);
			pl.x = 350;
			pl.y = 580;
			
			tr = new Terrain();
			addChild(tr);
			tr.y = 600;
			tr.x = 350;
			tr.width = 2000;
			
			for (var i:int = 0; i < numOfObjects; i++) 
			{
			var fallingObject:MovieClip = new AsteroidArt();
			fallingObject.name = "Enemy";
			addChild(fallingObject);
   
			fallingObject.x = Math.random() * stage.stageWidth;
			fallingObjectArray.push(fallingObject);
			}
		}
		
		private function fire():void
		{
			
			if (!_isFiring) return;
			
			
			if (!_isLoaded) return;
			
			
			createBullet();
			
			
			_reloadTimer = new Timer(_reloadSpeed);
			_reloadTimer.addEventListener(TimerEvent.TIMER, reloadTimerHandler);
			_reloadTimer.start();
			trace('fire')
			
			_isLoaded = false;
		}
		

		private function createBullet():void
		{
			
			var targetAngle = (pl.rotation +90) * Math.PI / 180
			
			
			_pcos = Math.cos(targetAngle);
			_psin = Math.sin(targetAngle);
			
			
			_startX = pl.x - _barrelLength * _pcos;
			_startY = pl.y - _barrelLength * _psin;
			
			_endX = this.mouseX;
			_endY = this.mouseY;
			
			
			var tempBullet:MovieClip = new MissileArt();
			
			
			tempBullet.vx = -_bulletSpeed * _pcos;
			tempBullet.vy = -_bulletSpeed * _psin;
			
			
			tempBullet.x = _startX;
			tempBullet.y = _startY;
			
			
			tempBullet.startX = _startX;
			tempBullet.startY = _startY;
	
			
			var disX = (_endX - _startX)
			var disY = (_endY-_startY)
			
			tempBullet.maxDistance = Math.sqrt(disX * disX + disY * disY);
			
			_bullets.push(tempBullet);
			
			
			bh.addChild(tempBullet);
		}
		
	
		private function updateBullets():void
		{
			var i:int;
			var tempBullet:MovieClip;
			
			
			
			
			for (i = 0; i < _bullets.length; i++)
			{
				
				tempBullet = _bullets[i];
				
				
				tempBullet.vx += _wind;
				
				tempBullet.x += tempBullet.vx;
				tempBullet.y += tempBullet.vy;
				tempBullet.rotation = Math.atan2(tempBullet.vy, tempBullet.vx)  * (180/Math.PI)-90
				
				tempBullet.maxDistance -= _bulletSpeed
				
				if (tempBullet.maxDistance<=0)
				{
					destroyBullet(tempBullet);
				}
				
				
				if (checkCollisions(tempBullet.x, tempBullet.y))
				{
					destroyBullet(tempBullet);
				}
			}
		}
		

		private function destroyBullet(bullet:MovieClip):void
		{
			var i:int;
			var tempBullet:MovieClip;
			
			
			for (i = 0; i < _bullets.length; i++)
			{
				
				tempBullet = _bullets[i];
				
				
				if (tempBullet == bullet)
				{
					
					_bullets.splice(i, 1);
					
					
					bullet.parent.removeChild(bullet);
					
					
					return;
				}
			}
		}
		
		private function destroyAsteroid(asteroid:MovieClip):void
		{
			var i:int;
			var object:MovieClip;
			
			
			for (i = 0; i < fallingObjectArray.length; i++)
			{
				
				object = fallingObjectArray[i];
				
				
				if (_bullets.hitTestObject(object))
				{
					object.parent.removeChild(object);
					
					
					return;
				}
			}
		}
		
		
		private function reloadWeapon():void
		{
			_isLoaded = true;
		}
		
	/*	private function drivingCars();
		{
			
		}
		
		private function walkingPeople();
		{
			
		}
		
		private function buildingLocation();
		{
			
		}
		
		private function healthBars();
		{
		
		}
		
		private function clouds();
		{
			
		}
		
		private function trees();
		{
			
		}
		
		*/
		
		private function checkCollisions(testX:Number, testY:Number):Boolean
		{
			var i:int;
			var tempWall:MovieClip;
			
			
			for (i = 0; i < _solidObjects.length; i++)
			{
				
				tempWall = _solidObjects[i];
				
				
				if (tempWall.hitTestPoint(testX, testY, true))
				{
					return true;
					
					
					break;
				}
			}
			return false;	
			return false;	

		}
	
		
		private function onMouseUpHandler(event:MouseEvent):void 
		{
			_isFiring = false;
		}
		
		
		private function onMouseDownHandler(event:MouseEvent):void 
		{
			_isFiring = true;
		}
		
		
		private function reloadTimerHandler(e:TimerEvent):void 
		{
			
			e.target.stop();
			
			
			_reloadTimer = null;
			
			reloadWeapon();
		}
		
		
		public function getDistance(delta_x:Number, delta_y:Number):Number
		{
			return Math.sqrt((delta_x*delta_x)+(delta_y*delta_y));
		}
		
		
		public function getRadians(delta_x:Number, delta_y:Number):Number
		{
			var r:Number = Math.atan2(delta_y, delta_x);
			
			if (delta_y < 0)
			{
				r += (2 * Math.PI);
			}
			return r;
		}
		
		
		public function getDegrees(radians:Number):Number
		{
			return Math.floor(radians / (Math.PI / 180));
			
		}
		
		
	}
	
}