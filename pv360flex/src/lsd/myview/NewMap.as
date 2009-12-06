package lsd.myview
{
	import communication.MainSystem;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import gs.TweenLite;
	
	import mx.effects.Tween;

	public class NewMap extends Sprite
	{
		private var fadeTween:Tween;
	    public var mapDirector:MapDirector=new MapDirector();
		private var mapFrist:MapFrist=new MapFrist();
		private var mapSecond:MapSecond=new MapSecond();
		private var mapThrid:MapThrid=new MapThrid();
		private const offset:Number=40;
		private var _forceWidth:Number=-1;
		private var _forceHeight:Number=-1;
		private var maskSprite:Sprite;
		private var show:Boolean=false;

		public function NewMap()
		{
			super();
			addChild(mapDirector);
			initListtener();
			this.dispatchEvent(new MapChangeEvent(MapChangeEvent.MAPCHANGEVENT, mapFrist))
			//trace(this.numChildren);
		}

		private function initListtener():void
		{


			mapDirector.frist.addEventListener(MouseEvent.CLICK, changeFristMap);
			mapDirector.second.addEventListener(MouseEvent.CLICK, changeSecondMap);
			mapDirector.thrid.addEventListener(MouseEvent.CLICK, changeThridMap);
			mapDirector.close.addEventListener(MouseEvent.CLICK, closeMap);
			mapDirector.frist.addEventListener(MapChangeEvent.MAPCHANGEVENT, showMap);
			mapDirector.second.addEventListener(MapChangeEvent.MAPCHANGEVENT, showMap);
			mapDirector.thrid.addEventListener(MapChangeEvent.MAPCHANGEVENT, showMap);
			this.addEventListener(MapChangeEvent.MAPCHANGEVENT, showMap);
			mapFrist.one.addEventListener(MouseEvent.CLICK, onechange);
			mapFrist.two.addEventListener(MouseEvent.CLICK, twochange);
			mapFrist.three.addEventListener(MouseEvent.CLICK, threechange);
			mapFrist.four.addEventListener(MouseEvent.CLICK, fourchange);
			mapFrist.five.addEventListener(MouseEvent.CLICK, fivechange);
			mapSecond.one.addEventListener(MouseEvent.CLICK, sixchange);
			mapSecond.two.addEventListener(MouseEvent.CLICK, sevenchange);
			mapSecond.three.addEventListener(MouseEvent.CLICK, eightchange);
			mapSecond.four.addEventListener(MouseEvent.CLICK, nightchange);
			mapSecond.five.addEventListener(MouseEvent.CLICK, tenchange);
			mapThrid.one.addEventListener(MouseEvent.CLICK, elevnchange);
			mapThrid.two.addEventListener(MouseEvent.CLICK, twelfchange);
			mapThrid.three.addEventListener(MouseEvent.CLICK, thirteenchange);
			mapThrid.four.addEventListener(MouseEvent.CLICK, fifteenchange);
			
		}

		private function changeFristMap(e:MouseEvent):void
		{

			mapDirector.frist.dispatchEvent(new MapChangeEvent(MapChangeEvent.MAPCHANGEVENT, mapFrist));

		}

		private function changeSecondMap(e:MouseEvent):void
		{

			mapDirector.second.dispatchEvent(new MapChangeEvent(MapChangeEvent.MAPCHANGEVENT, mapSecond));

		}

		private function changeThridMap(e:MouseEvent):void
		{

			mapDirector.thrid.dispatchEvent(new MapChangeEvent(MapChangeEvent.MAPCHANGEVENT, mapThrid));
		}

		private function closeMap(e:MouseEvent):void
		{

			dispatchEvent(new Event(Event.CLOSE));
		}







		private function onechange(e:MouseEvent):void
		{

			MainSystem.getInstance().gotoScene(2);
		}

		private function twochange(e:MouseEvent):void
		{

			MainSystem.getInstance().gotoScene(3);
		}

		private function threechange(e:MouseEvent):void
		{

			MainSystem.getInstance().gotoScene(4);
		}

		private function fourchange(e:MouseEvent):void
		{

			MainSystem.getInstance().gotoScene(1);
		}

		private function fivechange(e:MouseEvent):void
		{

			MainSystem.getInstance().gotoScene(3);
		}

		private function sixchange(e:MouseEvent):void
		{

			MainSystem.getInstance().gotoScene(8);
		}

		private function sevenchange(e:MouseEvent):void
		{

			MainSystem.getInstance().gotoScene(9);
		}

		private function eightchange(e:MouseEvent):void
		{

			MainSystem.getInstance().gotoScene(7);
		}

		private function nightchange(e:MouseEvent):void
		{

			MainSystem.getInstance().gotoScene(6);
		}

		private function tenchange(e:MouseEvent):void
		{

			MainSystem.getInstance().gotoScene(10);
		}

		private function elevnchange(e:MouseEvent):void
		{

			MainSystem.getInstance().gotoScene(11);
		}

		private function twelfchange(e:MouseEvent):void
		{

			MainSystem.getInstance().gotoScene(12);
		}

		private function thirteenchange(e:MouseEvent):void
		{

			MainSystem.getInstance().gotoScene(14);
		}

		private function fifteenchange(e:MouseEvent):void
		{

			MainSystem.getInstance().gotoScene(13);
		}






		public function showMap(e:MapChangeEvent):void
		{

			var d_width:Number=_forceWidth <= 0 ? e.sprite.width : _forceWidth;
			var d_height:Number=_forceHeight <= 0 ? e.sprite.height : _forceHeight;
			e.sprite.x=-d_width / 2+205;
            e.sprite.y=95;
			if (this.numChildren > 1)
			{
				removeChildAt(1);
				TweenLite.to(mapDirector.frist, 0.2, {x: -d_width / 2 + 225, y: 68});
				TweenLite.to(mapDirector.second, 0.2, {x: -d_width / 2 + 305, y: 68});
				TweenLite.to(mapDirector.thrid, 0.2, {x: -d_width / 2 + 385, y: 68});
				TweenLite.to(mapDirector.close, 0.2, {x: d_width / 2 + 190, y: 13});
				TweenLite.to(mapDirector.title, 0.2, {width: d_width + 40});
				TweenLite.to(mapDirector.mapback, 0.2, {height: d_height + 60, width: d_width +32, onComplete: function():void
					{


						addChild(e.sprite);
						e.sprite.alpha=0;
						TweenLite.to(e.sprite, 0.5, {alpha: 1});
					//e.sprite.alpha=1;

					}});

			}
			else
			{
				mapDirector.frist.x=-d_width / 2 + 225;
				mapDirector.frist.y=68;
				mapDirector.second.x=-d_width / 2 + 305;
				mapDirector.second.y=68;
				mapDirector.thrid.x=-d_width / 2 + 385;
				mapDirector.thrid.y=68;
				mapDirector.close.x=d_width / 2 + 190;
				mapDirector.close.y=13;
				mapDirector.title.width=d_width + 40;
				mapDirector.mapback.height=d_height +60;
				mapDirector.mapback.width=d_width +32;
				addChild(e.sprite);
			}

		}






	}
}