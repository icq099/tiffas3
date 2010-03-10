package lxfa.No5.view
{
	import communication.MainSystem;
	
	public class No5Base
	{
		public function No5Base()
		{
			initAPI();
		}
		private function initAPI():void
		{
			MainSystem.getInstance().addAPI("gggg",gotoStep6);
		}
		public function gotoStep6():void
		{
			
		}
	}
}