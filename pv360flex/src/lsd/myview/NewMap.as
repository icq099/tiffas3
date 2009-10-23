package lsd.myview
{
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
			trace(this.numChildren);
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
			mapFrist.one.addEventListener(MouseEvent.CLICK, onechange);
			mapSecond.three.addEventListener(MouseEvent.CLICK, twochange);

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
			
			TweenLite.to(this,0.5,{alpha:0,onComplete:remove});
		}
		
		
		
		private function remove():void{
			
			if(parent!=null){
                
                parent.removeChild(this);

		   }
		    dispatchEvent(new Event(Event.CLOSE));
		}




		private function onechange(e:MouseEvent):void
		{

			trace("fuck");
		}

		private function twochange(e:MouseEvent):void
		{

			trace("fuck you");
		}





		public function showMap(e:MapChangeEvent):void
		{
			e.sprite.x=22;
			e.sprite.y=69;
			var d_width:Number=_forceWidth <= 0 ? e.sprite.width : _forceWidth;
		    var d_height:Number=_forceHeight <= 0 ? e.sprite.height : _forceHeight;
			if (this.numChildren > 1)
			{
				removeChildAt(1);
				TweenLite.to(mapDirector.close,0.2,{x:d_width + 9,y:16});
				TweenLite.to(mapDirector.title,0.2,{width:d_width + 38});
			    TweenLite.to(mapDirector.mapback,0.2,{height:d_height + 40,width:d_width + 42,onComplete:function():void{
			 
			 	//TweenLite.from(e.sprite,0.5,{alpha:0})
			 	addChild(e.sprite);
                
			 
		 }});

			}
			else
			{

				mapDirector.close.x=d_width + 9;
				mapDirector.close.y=16;
				mapDirector.title.width=d_width + 38;
				mapDirector.mapback.height=d_height + 40;
				mapDirector.mapback.width=d_width + 42;
				addChild(e.sprite);
			}

		}






	}
}