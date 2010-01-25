package view
{
	public class Pv3d360SceneCompass extends Pv3d360Scene
	{
		private var _compass_visible:Boolean;
		public function Pv3d360SceneCompass(czoom:Number=11, pdetail:Number=50)
		{
			super(czoom, pdetail);
			compass_visible=false;
		}
		public function set compass_visible(value:Boolean):void{
			_compass_visible=value
			layer_arrows.visible=false;
			layer_compass.visible=false;
		}
		public function get compass_visible():Boolean{
			layer_arrows.visible=true;
			layer_compass.visible=true;
			return _compass_visible;
		}
	}
}