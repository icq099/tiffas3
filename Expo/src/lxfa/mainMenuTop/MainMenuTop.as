package lxfa.mainMenuTop
{
	import flash.display.Sprite;
	
	public class MainMenuTop extends Sprite
	{
		private var top:MainMenuSwcTop;
		public function MainMenuTop()
		{
			top=new MainMenuSwcTop();
			this.addChild(top);
		}
	}
}