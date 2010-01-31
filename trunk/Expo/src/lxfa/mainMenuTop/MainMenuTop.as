package lxfa.mainMenuTop
{
	import flash.display.Sprite;
	
	import mx.core.UIComponent;
	
	public class MainMenuTop extends Sprite
	{
		private var top:MainMenuTop;
		public function MainMenuTop()
		{
			top=new MainMenuTop();
			var ui:UIComponent=new UIComponent();
			ui.addChild(top);
		}
	}
}