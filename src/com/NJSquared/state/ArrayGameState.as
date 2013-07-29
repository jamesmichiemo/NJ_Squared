package com.NJSquared.state
{	
	import com.NJSquared.gameCore.Assets;
	import com.citrusengine.core.CitrusEngine;
	import com.citrusengine.core.CitrusObject;
	import com.citrusengine.core.StarlingState;
	import com.citrusengine.math.MathVector;
	import com.citrusengine.objects.platformer.box2d.Coin;
	import com.citrusengine.objects.platformer.box2d.Enemy;
	import com.citrusengine.objects.platformer.box2d.Hero;
	import com.citrusengine.objects.platformer.box2d.Platform;
	import com.citrusengine.physics.box2d.Box2D;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import flashx.textLayout.formats.BackgroundColor;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public class ArrayGameState extends StarlingState
	{
		private var _levelOne:Array = [];
		private var _levelOneBit:BitmapData;
		private var _hero:Hero;
		
		
		[Embed(source = '../assets/images/images_01.png')]
		private var ONE:Class;
		[Embed(source = '../assets/images/images_04.png')]
		private var FOUR:Class;
		[Embed(source = '../assets/images/images_05.png')]
		private var FIVE:Class;
		[Embed(source = '../assets/images/images_06.png')]
		private var SIX:Class;
		[Embed(source = '../assets/images/images_08.png')]
		private var EIGHT:Class;
		[Embed(source = '../assets/images/keyYellow.png')]
		private var NINE:Class;
		[Embed(source = '../assets/images/blockerMad.png')]
		private var SEVEN:Class;

		private var _citrusEngine:CitrusEngine;

		private var _height2:uint;

		private var _width2:uint;

		

		
		public function ArrayGameState()
		{
			super();
			
			_citrusEngine = CitrusEngine.getInstance();
			_citrusEngine.sound.playSound("Song");
			
		}
		
		override public function initialize():void 
		{
			
			super.initialize();
		
			
			Assets.init();
			stage.color = 0x8becfb;
			
			var box2D:Box2D = new Box2D("box2D");
//			box2D.visible = true;
			add(box2D);
			
//			_levelOne = [
//				[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
//				[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
//				[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
//				[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
//				[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 5, 5, 5, 0, 8, 8, 0, 5, 5, 5, 5, 5, 5, 5, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 5, 5, 5, 5, 5, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
//				[1, 0, 0, 7, 7, 0, 0, 0, 0, 0, 0, 0, 5, 1, 1, 1, 1, 5, 5, 5, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 5, 5, 5, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
//				[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 5, 0, 0, 5, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 5, 5, 5, 1],
//				[1, 0, 0, 0, 0, 0, 0, 5, 5, 5, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 5, 5, 5, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 5, 1, 1, 8, 8, 1, 1, 7, 0, 0, 0, 0, 0, 0, 0, 0, 5, 5, 5, 5, 5, 1, 1, 1, 1],
//				[1, 5, 5, 5, 5, 8, 8, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 5, 5, 5, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
//				[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 5, 5, 5, 5, 5, 1, 1, 1, 1, 1, 0, 0, 5, 5, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
//				[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 8, 8, 1, 1, 1, 5, 5, 5, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
//				[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 5, 5, 5, 5, 0, 0, 0, 0, 0, 5, 5, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
//				[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 1, 1, 1, 1, 1, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 5, 5, 5, 5, 6, 6, 0, 0, 0, 0, 0, 0, 0, 0, 1],
//				[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 5, 5, 1, 1, 1, 1, 1, 5, 5, 5, 5, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 5, 5, 0, 0, 0, 0, 0, 0, 0, 0, 1],
//				[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 5, 5, 5, 5, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
//				[1, 0, 0, 5, 5, 5, 5, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 5, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 9, 1],
//				[1, 0, 0, 0, 9, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 5, 5, 0, 0, 0, 0, 5, 5, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 5, 5, 5, 5, 0, 0, 5, 5, 5, 5],
//				[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 5, 5, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 5, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1],
//				[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 5, 5, 5, 5, 5, 5, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1],
//				[1, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 5, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 5, 5, 5, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1],
//				[1, 5, 5, 5, 5, 5, 5, 5, 0, 0, 5, 5, 5, 5, 5, 0, 0, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 5, 5, 5, 0, 0, 5, 5, 5, 5, 5, 5, 1, 1, 1, 1, 1, 5, 5, 5, 5, 0, 0, 5, 5, 5, 5, 5, 5, 5, 5, 1, 1, 1, 1],
//				[1, 1, 1, 1, 1, 1, 1, 8, 8, 8, 8, 1, 1, 1, 1, 6, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 8, 8, 8, 8, 8, 8, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 6, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
//			];
			
			_levelOne = [
				[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
				[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
				[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
				[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
				[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
				[1, 0, 0, 7, 7, 0, 0, 0, 0, 0, 1],
				[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
				[1, 0, 0, 0, 0, 0, 0, 5, 5, 5, 1],
				[1, 5, 5, 5, 5, 8, 8, 1, 1, 1, 1],
				[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
				[1, 5, 5, 5, 5, 5, 5, 5, 0, 0, 1],
				[1, 1, 1, 1, 1, 1, 1, 8, 8, 8, 1]
			];
			
			placeTiles();
		}	
		
		private function placeTiles():void
		{
			_width2 = _levelOne[0].length * 70;
			_height2 = _levelOne.length * 70;
			
			trace(_width2);
			
			var bd1:BitmapData=new BitmapData(_width2,_height2, false, 0x000000);
			
			for(var i:int = 0; i < _levelOne.length; i++)
			{
				
				for(var j:int = 0; j < _levelOne[i].length; j++)
				{
					var image:Bitmap;
					
					if(_levelOne[i][j] != 0)
					{
						if(_levelOne[i][j] == 1)
						{
//							image = new Image(starling.textures.Texture.fromBitmap(new ONE()));
							image = new ONE();
						}
						else if(_levelOne[i][j] == 5)
						{
//							image = new Image(starling.textures.Texture.fromBitmap(new FIVE()));
							image = new FIVE();
						}
						else if(_levelOne[i][j] == 6)
						{
//							image = new Image(starling.textures.Texture.fromBitmap(new SIX()));
							image = new SIX();
						}
						else if(_levelOne[i][j] == 7)
						{
//							image = new Image(starling.textures.Texture.fromBitmap(new SEVEN()));
							image = new SEVEN();
						}
						else if(_levelOne[i][j] == 8)
						{
//							image = new Image(starling.textures.Texture.fromBitmap(new EIGHT()));
							image = new EIGHT();
						}
						else if(_levelOne[i][j] == 9)
						{
//							image = new Image(starling.textures.Texture.fromBitmap(new NINE()));
							image = new NINE();
						}
					
					 	if(_levelOne[i][j] == 9)
						{
							var coin:Coin = new Coin("coin", {x:j*70+90, y:i*70+35, height:70, width:70, view: image});
							add(coin);
						}
						else if(_levelOne[i][j] == 7)
						{
							var enemy:Enemy = new Enemy("enemy", {x:j*70+140, y:i*70+35, height:70, width:70, view: image, leftBound:0});
							add(enemy);
						}
						
						else
						{
							var platform:Platform = new Platform("platform", {x:j*70+35, y:i*70+35, height:70, width:70});
							
							
							bd1.draw(image, new Matrix(1, 0, 0, 1, j*70+35, i*70+35));
					
						} 
					}
				}
			}
			 
			var bitmapImage:Bitmap = new Bitmap(bd1);

			var bg:Platform = new Platform("platform", {x:0, y:0, height:_height2, width:_width2, view:bitmapImage, oneWay:true});
			bg.x = _width2 / 2 - 35;
			bg.y = _height2 / 2 - 3;

			add(bg);
			

			addHero();
		}
		
		private function addHero():void
		{
			
			var heroImage:Image = new Image(starling.textures.Texture.fromBitmap(new FOUR()));


			_hero = new Hero("hero", {x:200, y:300, height:40, width:30, view: heroImage});

			add(_hero);
			_hero.onGiveDamage.add(handleHeroGiveDamage);
			_hero.onTakeDamage.add(handleHeroTakeDamage);
			
			view.setupCamera(_hero, new MathVector(stage.stageWidth / 2, stage.stageHeight / 2), new Rectangle(0, 0, 5040, 1540), new MathVector(.25, .05));
			
			_hero = new Hero("hero", {x:200, y:300, height:40, width:30, view: heroImage});

			add(_hero);
			view.setupCamera(_hero, new MathVector(stage.stageWidth / 2, stage.stageHeight / 2), new Rectangle(0, 0, _width2, _height2), new MathVector(.25, .05));

		}
		
		private function handleHeroGiveDamage():void {
			_citrusEngine.sound.playSound("Kill", 11, 0);
		}
		
		private function handleHeroTakeDamage():void {
			_citrusEngine.sound.playSound("Hurt", 11, 0);
		}
		
	}
}