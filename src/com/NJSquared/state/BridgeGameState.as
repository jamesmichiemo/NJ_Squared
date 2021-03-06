package com.NJSquared.state
{
	import citrus.core.CitrusEngine;
	import citrus.core.starling.StarlingState;
	import citrus.objects.platformer.box2d.Platform;
	import citrus.physics.box2d.Box2D;
	
	import com.NJSquared.gameCore.LivesManager;
	import com.NJSquared.gameCore.TileManager;
	
	import flash.events.Event;
	import flash.events.GameInputEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.GameInput;
	import flash.ui.GameInputControl;
	import flash.ui.GameInputDevice;
	import flash.ui.Keyboard;
	
	import starling.display.Image;
	import starling.events.KeyboardEvent;
	import starling.text.TextField;
	import starling.textures.Texture;

	

	public class BridgeGameState extends StarlingState
	{
		private var _citrusEngine:CitrusEngine;
		
		private var _bridgeFinished:Boolean = false;
		
		private var _tileXCount:uint = 0;
		private var _tileYCount:uint = 0;
		private var _tileYPos:uint = 595;
		private var _lastColor:uint;
		private var _currentColor:uint;
		
		private var _red:uint = 0xff0000;
		private var _yellow:uint = 0x00ff00;
		private var _blue:uint = 0x0000ff;
		
		private var _barrier:Platform;
		
		private var levelOneBridge:Array = [];
		private var _hero:ConcreteHero;
		
		[Embed(source = '../assets/images/groundTile.png')]
		private var ONE:Class;
		[Embed(source = '../assets/images/images_04.png')]
		private var FOUR:Class;
		[Embed(source = '../assets/images/grassTile.png')]
		private var FIVE:Class;
		[Embed(source = '../assets/images/waterTile.png')]
		private var EIGHT:Class;
		[Embed(source = '../assets/images/redTile.png')]
		private var NINE:Class;
		[Embed(source = '../assets/images/blockerMad.png')]
		private var SEVEN:Class;
		[Embed(source = '../assets/images/rightCornerGrassTile.png')]
		private var TEN:Class;
		[Embed(source = '../assets/images/leftCornerGrassTile.png')]
		private var ELEVEN:Class;
		[Embed(source = '../assets/images/portalTile.png')]
		private var TWELVE:Class;
		
		[Embed(source = '../assets/images/redBridgeTile.png')]
		private var RED:Class;
		[Embed(source = '../assets/images/blueBridgeTile.png')]
		private var BLUE:Class;
		[Embed(source = '../assets/images/yellowBridgeTile.png')]
		private var YELLOW:Class;
		
		[Embed(source = '../assets/images/livesText.png')] // lives text
		private var LIVES:Class;
		[Embed(source = '../assets/images/lifeHeart.png')] // lives text
		private var HEART:Class;
		
		[Embed(source = '../assets/images/blueTileDisplay.png')] // blue tile display
		private var BLUE_DISPLAY:Class;
		[Embed(source = '../assets/images/redTileDisplay.png')] // red tile display
		private var RED_DISPLAY:Class;
		[Embed(source = '../assets/images/yellowTileDisplay.png')] // blue tile display
		private var YELLOW_DISPLAY:Class;

		[Embed(source = '../assets/images/portalTile.png')] // portal
		private var FOURTEEN:Class;
		
		[Embed(source = '../assets/images/signBridgeGame.png')] // sign
		private var SIGN:Class;
		
		[Embed(source = '../assets/images/cloudOne.png')] // big cloud 
		private var CLOUDONE:Class;
		[Embed(source = '../assets/images/cloudTwo.png')] // small cloud
		private var CLOUDTWO:Class;
		
		private var _livesArray:Array = [];
		
		private var _yellowTileCount:TextField;
		private var _redTileCount:TextField;
		private var _blueTileCount:TextField;
		
		private var gameInput:GameInput;
		private var _device:GameInputDevice;
		
		public function BridgeGameState()
		{
			super();
			_citrusEngine = CitrusEngine.getInstance();
			_citrusEngine.sound.playSound("Puzzle");
			_ce.sound.setVolume("Puzzle", 0.5);
			
			trace(GameInput.isSupported);
			
			if(GameInput.isSupported){
				gameInput = new GameInput();
				gameInput.addEventListener(GameInputEvent.DEVICE_ADDED, handleDeviceAttached);
				gameInput.addEventListener(GameInputEvent.DEVICE_REMOVED, handleDeviceRemoved);
				trace("GameDevice Count:",GameInput.numDevices);
				if(GameInput.numDevices > 0){
					handleDeviceAttached(null);
				}
			}
		}
		
		protected function handleDeviceRemoved(event:GameInputEvent):void
		{
			trace("Device is removed");
		}
		
		protected function handleDeviceAttached(event:GameInputEvent):void
		{
			
			for(var k:Number=0;k<GameInput.numDevices;k++){
				_device = GameInput.getDeviceAt(k);
				GameInputControlName.initialize(_device);
				var _controls:Vector.<String> = new Vector.<String>;
				_device.enabled = true;
				
				for (var i:Number = 0; i < _device.numControls; i++) {
					var control:GameInputControl = _device.getControlAt(i);
					if(control.name == GameInputControlName.BUTTON_U){
						control.addEventListener(Event.CHANGE,onBlue);
					}
					if(control.name == GameInputControlName.BUTTON_Y){
						control.addEventListener(Event.CHANGE,onYellow);
					}
					if(control.name == GameInputControlName.BUTTON_A){
						control.addEventListener(Event.CHANGE,onRed);
					}
					_controls[i] = control.id;
				}
				
				//_device.startCachingSamples(30, _controls);
		    }
		
		    for(var j:int=0; j<_controls.length; j++)
		    {
			  trace(_controls[j]);
		    }

		}
		
		protected function onRed(event:Event):void
		{
			trace("A");
			buildBridge(_red);
			//_ce.sound.playSound("Pick");
		}
		
		protected function onYellow(event:Event):void
		{
			trace("Y");
			buildBridge(_yellow);
			//_ce.sound.playSound("Pick");
		}
		
		protected function onBlue(event:Event):void
		{
			trace("U");
			buildBridge(_blue);
			//_ce.sound.playSound("Pick");
		}		

		override public function initialize():void 
		{
			super.initialize();
			
			trace("bridge state");
			
			stage.color = 0xaedfe8;
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKey);
			
			var box2D:Box2D = new Box2D("box2D");
			//box2D.visible = true;
			add(box2D);
			
			levelOneBridge = [
				[01, 01, 01, 01, 01, 01, 01, 01, 01, 01, 01, 01, 01, 01, 01, 01, 01, 01, 01, 01, 01],
				[01, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 01, 01],
				[01, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 01, 01],
				[01, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 01, 01],
				[01, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 01, 01],
				[01, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 01, 01],
				[01, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 01, 01],
				[01, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 12, 01],
				[01, 05, 10, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 11, 05, 05, 01],
				[01, 01, 01, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 01, 01, 01, 01],
				[01, 01, 01, 08, 08, 08, 08, 08, 08, 08, 08, 08, 08, 08, 08, 08, 08, 01, 01, 01, 01],
			];
			
			createLevel();
		}
		
		private function createLevel():void
		{
			for(var i:int = 0; i < levelOneBridge.length; i++)
			{
				
				for(var j:int = 0; j < levelOneBridge[i].length; j++)
				{
					var image:Image;
					
					if(levelOneBridge[i][j] != 0)
					{
						if(levelOneBridge[i][j] == 1)
						{
							image = new Image(Texture.fromBitmap(new ONE()));
						}
						else if(levelOneBridge[i][j] == 5)
						{
							image = new Image(Texture.fromBitmap(new FIVE()));
						}
						else if(levelOneBridge[i][j] == 8)
						{
							image = new Image(Texture.fromBitmap(new EIGHT()));
						}
						else if(levelOneBridge[i][j] == 10)
						{
							image = new Image(Texture.fromBitmap(new TEN()));
						}
						else if(levelOneBridge[i][j] == 11)
						{
							image = new Image(Texture.fromBitmap(new ELEVEN()));
						}
						else if(levelOneBridge[i][j] == 12)
						{
							image = new Image(Texture.fromBitmap(new TWELVE()));
						}
						
						var platform:Platform = new Platform("platform", {x:j*70+35, y:i*70+35, height:70, width:70, view: image});
						add(platform);
					}
				}
			}
			
			_barrier = new Platform ("barrier", {x:245, y:525, height:1000, width:70});
			add(_barrier);
			
			var sign:Platform;
			var signImage:Image = new Image(Texture.fromBitmap(new SIGN()));
			sign = new Platform("cloud", {x:170, y:466, height:70, width:70, view:signImage, oneWay:true});
			add(sign);
			
			var cloudOne:Platform;
			var cloudOneImage:Image = new Image(Texture.fromBitmap(new CLOUDONE()));
			cloudOne = new Platform("cloud", {x:670, y:266, height:70, width:70, view: cloudOneImage, oneWay:true});
			add(cloudOne);
			
			var cloudTwoImage:Image = new Image(Texture.fromBitmap(new CLOUDTWO()));
			var cloudTwo:Platform = new Platform("cloud", {x:360, y:200, height:70, width:70, view: cloudTwoImage, oneWay:true});
			add(cloudTwo);
			
			var cloudThreeImage:Image = new Image(Texture.fromBitmap(new CLOUDTWO()));
			var cloudThree:Platform = new Platform("cloud", {x:980, y:160, height:70, width:70, view: cloudThreeImage, oneWay:true});
			add(cloudThree);
			
			addHud();
			addHero();
		}
		
		private function addHud():void
		{
			//lives displays
			var livesTexture:Texture = Texture.fromBitmap(new LIVES());
			var livesImage:Image = new Image(livesTexture);
			livesImage.x = 20;
			livesImage.y = 20;
			addChild(livesImage);
			
			var heartsTexture:Texture = Texture.fromBitmap(new HEART());
			if(LivesManager.livesCount >= 1)
			{
				var heartsImageOne:Image = new Image(heartsTexture);
				heartsImageOne.x = 140;
				heartsImageOne.y = 34;
				addChild(heartsImageOne);
				_livesArray.push(heartsImageOne);
			}
			if(LivesManager.livesCount >= 2)
			{
				var heartsImageTwo:Image = new Image(heartsTexture);
				heartsImageTwo.x = 200;
				heartsImageTwo.y = 34;
				addChild(heartsImageTwo);
				_livesArray.push(heartsImageTwo);
			}
			if(LivesManager.livesCount == 3)
			{
				var heartsImageThree:Image = new Image(heartsTexture);
				heartsImageThree.x = 260;
				heartsImageThree.y = 34;
				addChild(heartsImageThree);
				_livesArray.push(heartsImageThree);
			}

			// tile displays
			// yellow tiles
			var yellowDisplayTexture:Texture = Texture.fromBitmap(new YELLOW_DISPLAY());
			var yellowDisplayImage:Image = new Image(yellowDisplayTexture);
			yellowDisplayImage.x = 840;
			yellowDisplayImage.y = 20;
			addChild(yellowDisplayImage);
			
			_yellowTileCount = new TextField(100,100,"00", "Helvetica");
			_yellowTileCount.fontSize = 32;
			_yellowTileCount.color = 0x282828;
			_yellowTileCount.x = 885;
			_yellowTileCount.y = 10;
			addChild(_yellowTileCount);
			
			// red tiles
			var redDisplayTexture:Texture = Texture.fromBitmap(new RED_DISPLAY());
			var redDisplayImage:Image = new Image(redDisplayTexture);
			redDisplayImage.x = 980;
			redDisplayImage.y = 20;
			addChild(redDisplayImage);
			
			_redTileCount = new TextField(100,100,"00", "Helvetica");
			_redTileCount.fontSize = 32;
			_redTileCount.color = 0x282828;
			_redTileCount.x = 1025;
			_redTileCount.y = 10;
			addChild(_redTileCount);
			
			// blue tiles
			var blueDisplayTexture:Texture = Texture.fromBitmap(new BLUE_DISPLAY());
			var blueDisplayImage:Image = new Image(blueDisplayTexture);
			blueDisplayImage.x = 1120;
			blueDisplayImage.y = 20;
			addChild(blueDisplayImage);
			
			_blueTileCount = new TextField(100,100,"00", "Helvetica");
			_blueTileCount.fontSize = 32;
			_blueTileCount.color = 0x282828;
			_blueTileCount.x = 1165;
			_blueTileCount.y = 10;
			addChild(_blueTileCount);	
		}
		
		private function addHero():void
		{
			var heroImage:Image = new Image(starling.textures.Texture.fromBitmap(new FOUR()));
			
			_hero = new ConcreteHero("hero", {x:120, y:200, height:40, width:30, view: heroImage});
			add(_hero);

			view.camera.setUp(_hero, new Point(stage.stageWidth / 2, stage.stageHeight / 2), new Rectangle(0, 0, 1920, 1500), new Point(.25, .05));
		}
		
		private function onKey(event:KeyboardEvent):void
		{
		 	if(event.keyCode == 79)
			{
				trace("a");
				buildBridge(_red);
				_ce.sound.playSound("Pick");
			}
			else if(event.keyCode == 85)
			{
				trace("s");
				buildBridge(_blue);
				_ce.sound.playSound("Pick");
			}
			else if(event.keyCode == 89)
			{
				trace("d");
				buildBridge(_yellow);
				_ce.sound.playSound("Pick");
			}
		}
		
		private function buildBridge(color:uint):void
		{
			var redTile:Image = new Image(starling.textures.Texture.fromBitmap(new RED()));
			var blueTile:Image = new Image(starling.textures.Texture.fromBitmap(new BLUE()));
			var yellowTile:Image = new Image(starling.textures.Texture.fromBitmap(new YELLOW()));
			
			_currentColor = color;
			
			// if the first row of tiles have been placed
			if(_tileXCount == 14) 
			{
				_tileXCount = 0;
				_tileYCount++;
				_tileYPos = 595;
			}
			
			// if the bridge isn't finished
			if(_tileYCount < 1)
			{
				// first tile must be red
				if(_lastColor == 0 && _currentColor == _red && TileManager.redTileCount != 0)
				{	
					var tileOne:Platform = new Platform("platform", {x:245 + (70*_tileXCount), y:_tileYPos, height:70, width:70, view: redTile});
					add(tileOne);
				
					_tileXCount++;
					_lastColor = color;
					
					TileManager.decreaseTileCount("red");
					
					_ce.sound.playSound("Pick");
				}
				else if(_lastColor == 0 && (_currentColor == _blue || _currentColor == _yellow))
				{	
					//wrong tile used
					_ce.sound.playSound("Hurt");	
				}
				// blue can only go after red
				else if(_lastColor == _red && _currentColor == _blue && TileManager.blueTileCount != 0)
				{	
					var tileBlue:Platform = new Platform("platform", {x:245 + (70*_tileXCount), y:_tileYPos, height:70, width:70, view: blueTile});
					add(tileBlue);
					
					_tileXCount++;
					_lastColor = color;
					
					TileManager.decreaseTileCount("blue");
					
					_ce.sound.playSound("Pick");
				}
				else if(_lastColor == _red && (_currentColor == _yellow || _currentColor == _red))
				{	
					//wrong tile used
					_ce.sound.playSound("Hurt");
				}
				// yellow can only go after blue
				else if(_lastColor == _blue && _currentColor == _yellow && TileManager.yellowTileCount != 0)
				{	
					var tileyellow:Platform = new Platform("platform", {x:245 + (70*_tileXCount), y:_tileYPos, height:70, width:70, view: yellowTile});
					add(tileyellow);
					
					_tileXCount++;
					_lastColor = color;
					
					TileManager.decreaseTileCount("yellow");
					_ce.sound.playSound("Pick");
				}
				else if(_lastColor == _blue && (_currentColor == _blue || _currentColor == _red))
				{	
					//wrong tile used
					_ce.sound.playSound("Hurt");
				}
				// red can only go after yellow
				else if(_lastColor == _yellow && _currentColor == _red && TileManager.redTileCount != 0)
				{	
					var tileRed:Platform = new Platform("platform", {x:245 + (70*_tileXCount), y:_tileYPos, height:70, width:70, view: redTile});
					add(tileRed);
				
					_tileXCount++;
					_lastColor = color;
					
					TileManager.decreaseTileCount("red");
					_ce.sound.playSound("Pick");
				}
				else if(_lastColor == _yellow && (_currentColor == _blue || _currentColor == _yellow))
				{	
					//wrong tile used
					_ce.sound.playSound("Hurt");
				}
			}
			
			// if the bridge is finished	
			if(_tileYCount == 0 && _tileXCount == 14)
			{
				remove(_barrier);
				_ce.sound.playSound("Start");
				_bridgeFinished = true;
			}
		}
		
		override public function update(timeDelta:Number):void
		{
			super.update(timeDelta);
			
			_yellowTileCount.text = String(TileManager.yellowTileCount);
			_redTileCount.text = String(TileManager.redTileCount);
			_blueTileCount.text = String(TileManager.blueTileCount);

			if(_hero.x == 0 && _hero.y >= 560)
			{
				trace("startOver");
				destroy();
				_ce.state = new ArrayGameState();
			}
			
			if(_bridgeFinished == true && _hero.x >= 1290)
			{
				trace("game over");
				destroy();
				_ce.sound.playSound("Victory");
				_ce.state = new GameWin();
			}
		}
		
		override public function destroy():void
		{
			LivesManager.livesCount = 3;
			TileManager.yellowTileCount = 0;
			TileManager.blueTileCount = 0;
			TileManager.redTileCount = 0;
			
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKey);
			_ce.sound.removeSound("Puzzle");
		}
	}
}