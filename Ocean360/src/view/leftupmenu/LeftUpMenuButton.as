package view.leftupmenu
{
	import mx.core.UIComponent;
	
	import yzhkof.Toolyzhkof;

	public class LeftUpMenuButton extends UIComponent
	{
		private var btnBar:LeftUpMenuButtonBar=new LeftUpMenuButtonBar();
		public function LeftUpMenuButton()
		{
			init();
		}
		private function init():void{
			
			addChild(Toolyzhkof.mcToUI(btnBar));
		
		}
		
	}
}