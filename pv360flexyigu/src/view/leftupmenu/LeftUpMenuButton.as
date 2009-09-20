package view.leftupmenu
{
	import flash.display.Sprite;
	
	import mx.core.UIComponent;
	
	import yzhkof.Toolyzhkof;

	public class LeftUpMenuButton extends UIComponent
	{
		private var btnBar:Sprite=new LeftUpMenuButtonBarYiGu();
		public function LeftUpMenuButton()
		{
			init();
		}
		private function init():void{
			
			addChild(Toolyzhkof.mcToUI(btnBar));
		
		}
		
	}
}