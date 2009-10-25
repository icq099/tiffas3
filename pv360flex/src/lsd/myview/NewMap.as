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
		private var mapDirector:MapDirector=new MapDirector();
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
			mapDirector.thrid.addEventListener(MouseEvent.CLICK,changeThridMap);
			mapDirector.close.addEventListener(MouseEvent.CLICK,closeMap);
			mapDirector.frist.addEventListener(MapChangeEvent.MAPCHANGEVENT, showMap);
			mapDirector.second.addEventListener(MapChangeEvent.MAPCHANGEVENT, showMap);
			mapDirector.thrid.addEventListener(MapChangeEvent.MAPCHANGEVENT, showMap);
			this.addEventListener(MapChangeEvent.MAPCHANGEVENT, showMap);
			
			mapFrist.three.addEventListener(MouseEvent.CLICK, onechange);
			mapSecond.two.addEventListener(MouseEvent.CLICK, twochange);
			mapSecond.three.addEventListener(MouseEvent.CLICK,threechange);
			mapSecond.four.addEventListener(MouseEvent.CLICK,fourchange);
			mapSecond.five.addEventListener(MouseEvent.CLICK,fivechange);
			mapThrid.one.addEventListener(MouseEvent.CLICK,sixchange);
			mapThrid.two.addEventListener(MouseEvent.CLICK,sevenchange);
			mapThrid.three.addEventListener(MouseEvent.CLICK,eightchange);

		}

		private function changeFristMap(e:MouseEvent):void
		{

			mapDirector.frist.dispatchEvent(new MapChangeEvent(MapChangeEvent.MAPCHANGEVENT, mapFrist));

		}

		private function changeSecondMap(e:MouseEvent):void
		{

			mapDirector.second.dispatchEvent(new MapChangeEvent(MapChangeEvent.MAPCHANGEVENT, mapSecond));

		}
		
		private function changeThridMap(e:MouseEvent):void{
			
			mapDirector.thrid.dispatchEvent(new MapChangeEvent(MapChangeEvent.MAPCHANGEVENT, mapThrid));
		}
		
		private function closeMap(e:MouseEvent):void{
			
			dispatchEvent(new Event(Event.CLOSE));
		}
		
		
		
		



		private function onechange(e:MouseEvent):void
		{

			 MainSystem.getInstance().gotoScene(0);
		}

		private function twochange(e:MouseEvent):void
		{

			 MainSystem.getInstance().gotoScene(4);
		}
		
		private function threechange(e:MouseEvent):void{
			
			 MainSystem.getInstance().gotoScene(2);
		}
		
		private function fourchange(e:MouseEvent):void{
			
			MainSystem.getInstance().gotoScene(1);
		}
		private function fivechange(e:MouseEvent):void{
			
			MainSystem.getInstance().gotoScene(3);
		}
		
		private function sixchange(e:MouseEvent):void{
			
			MainSystem.getInstance().gotoScene(5);
		}
		
		private function sevenchange(e:MouseEvent):void{
			
			MainSystem.getInstance().gotoScene(6);
		}
		
		private function eightchange(e:MouseEvent):void{
			
			MainSystem.getInstance().gotoScene(7);
		}





		public function showMap(e:MapChangeEvent):void
		{
			
			var d_width:Number=_forceWidth <= 0 ? e.sprite.width : _forceWidth;
		    var d_height:Number=_forceHeight <= 0 ? e.sprite.height : _forceHeight;
		    e.sprite.x=-d_width/2+135
			e.sprite.y=69;
			if (this.numChildren > 1)
			{
				removeChildAt(1);
				TweenLite.to(mapDirector.frist,0.2,{x:-d_width/2+125,y:50});
				TweenLite.to(mapDirector.second,0.2,{x:-d_width/2+150,y:51});
				TweenLite.to(mapDirector.thrid,0.2,{x:-d_width/2+175,y:50});
				TweenLite.to(mapDirector.close,0.2,{x:d_width/2+125,y:16});
				TweenLite.to(mapDirector.title,0.2,{width:d_width + 38});
			    TweenLite.to(mapDirector.mapback,0.2,{height:d_height + 40,width:d_width + 42,onComplete:function():void{
			 
			 	
			 	addChild(e.sprite);
                
			 
		 }});

			}
			else
			{   mapDirector.frist.x=-d_width/2+125;
			    mapDirector.frist.y=50;
			    mapDirector.second.x=-d_width/2+150;
			    mapDirector.second.y=51;
			    mapDirector.thrid.x=-d_width/2+175;
			    mapDirector.thrid.y=50
                mapDirector.close.x=d_width/2+125;
				mapDirector.close.y=16;
				mapDirector.title.width=d_width + 38;
				mapDirector.mapback.height=d_height + 40;
				mapDirector.mapback.width=d_width + 42;
				addChild(e.sprite);
			}

		}






	}
}