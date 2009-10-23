package lxf.CenterPanel
{
	import mx.modules.Module;
	
	import yzhkof.Toolyzhkof;

	public class CenterPanelModule extends Module
	{
		public function CenterPanelModule()
		{
			addChild(Toolyzhkof.mcToUI(new CenterPanel()));
		}
		
	}
}