package lsd
{
	import communication.MainSystem;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.DropShadowFilter;
	
	import gs.TweenLite;
	
	import lsd.myview.NewMap;

	public class Map extends Sprite
	{
		private var a:NewMap;
		public function Map()
		{
			this.filters=[new DropShadowFilter(10,45,0,0.5,10,10,1,3)];
			a=new NewMap();
			//addChild(a);
			MainSystem.getInstance().addAPI("showMap",showMap);
			MainSystem.getInstance().addAPI("removeMap",removeMap);
			a.addEventListener(Event.CLOSE,onClose);
			
		}
		
		private function onClose(e:Event):void{
			
			 removeMap();
		}
		private function showMap():void{
			
			addChild(a);
			a.alpha=0;
			TweenLite.to(a, 1, {alpha: 1});
			
		}
		private function removeMap():void{
			
			TweenLite.to(a,0.5,{alpha:0,onComplete:remove});
		}
		
		
		private function remove():void{
                
               removeChild(a);

		   
		}
	}
}
