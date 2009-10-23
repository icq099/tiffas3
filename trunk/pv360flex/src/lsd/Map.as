package lsd
{
	import communication.MainSystem;
	
	import flash.display.Sprite;
	
	import gs.TweenLite;
	
	import lsd.myview.NewMap;

	public class Map extends Sprite
	{
		var a:NewMap;
		public function Map()
		{
			a=new NewMap();
			//addChild(a);
			MainSystem.getInstance().addAPI("showMap",showMap);
			MainSystem.getInstance().addAPI("removeMap",removeMap);
			
		}
		private function showMap():Boolean{
			addChild(a);
			TweenLite.from(a, 1, {alpha: 0});
			return true;
		}
		private function removeMap():void{
			removeChild(a);
			TweenLite.to(a, 1, {alpha: 0});
		}
	}
}
