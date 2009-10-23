package lsd
{
	import flash.display.Sprite;

	import gs.TweenLite;

	import lsd.myview.NewMap;

	public class Map extends Sprite
	{
		public function Map()
		{
			var a:NewMap=new NewMap();
			TweenLite.from(a, 1, {alpha: 0});
			addChild(a);


		}
	}
}
