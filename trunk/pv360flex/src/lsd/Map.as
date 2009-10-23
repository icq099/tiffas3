package lsd
{
	import communication.MainSystem;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import gs.TweenLite;
	
	import lsd.myview.NewMap;

	public class Map extends Sprite
	{
		private var a:NewMap;
		public function Map()
		{
			a=new NewMap();
			MainSystem.getInstance().addAPI("showMap",showMap);
			//MainSystem.getInstance().addAPI("removeMap",removeMap);
			a.addEventListener(Event.CLOSE,removeMap);
			
		}
		private function showMap(){
			addChild(a);
			TweenLite.from(a, 1, {alpha: 0});
		}
		private function removeMap(e:Event):void{
			
			TweenLite.to(a,0.5,{alpha:0,onComplete:remove});
		}
		
		
		private function remove():void{
                
               removeChild(a);

		   
		}
	}
}
