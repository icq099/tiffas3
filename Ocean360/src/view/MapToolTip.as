package view
{
	import flash.display.Sprite;

	public class MapToolTip extends TextContainer
	{
		[Embed (source="asset/Map.swf",symbol="MapToolTip")]
		private static var MapToolTipMc:Class;
		
		public function MapToolTip()
		{
			PanelClass=MapToolTipMc;
			super();
			
		}
		
	}
}