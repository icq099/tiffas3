package view.player
{
	import mx.core.UIComponent;

	public class FlvPlayerUICom extends UIComponent
	{
		public var api:FlvPlayer=new FlvPlayer();
		
		public function FlvPlayerUICom()
		{
			super();
			addChild(api);
		}
		
	}
}