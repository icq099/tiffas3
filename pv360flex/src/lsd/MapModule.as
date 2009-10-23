package lsd
{
	import mx.modules.Module;
	
	import yzhkof.Toolyzhkof;

	public class MapModule extends Module
	{
		public function MapModule()
		{
			addChild(Toolyzhkof.mcToUI(new Map()));
		}
		
	}
}