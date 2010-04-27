package plugins.yzhkof.pv3d.view
{
	public class Pv3d360SceneCompass extends Pv3d360Scene
	{
		private var _compass_visible:Boolean;
		public function Pv3d360SceneCompass(czoom:Number=13, pdetail:Number=50)
		{
			super(czoom, pdetail);
			compass_visible=true;
		}
		public function set compass_visible(value:Boolean):void{
			_compass_visible=value
		}
		public function get compass_visible():Boolean{
			return _compass_visible;
		}
	}
}