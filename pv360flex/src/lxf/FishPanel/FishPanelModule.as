package lxf.FishPanel
{
	import mx.modules.Module;
	
	import yzhkof.Toolyzhkof;

	public class FishPanelModule extends Module
	{
		public function FishPanelModule()
		{
			addChild(Toolyzhkof.mcToUI(new FishPanel()));
		}
		
	}
}