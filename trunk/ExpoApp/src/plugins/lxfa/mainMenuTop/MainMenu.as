package plugins.lxfa.mainMenuTop
{
	import core.manager.MainSystem;
	
	import mx.core.UIComponent;
	
	import plugins.lxfa.mainMenuBottom.MainMenuStatic;
	
	public class MainMenu extends UIComponent
	{
		public function MainMenu()
		{
			super();
		}
		protected function customGoto3DScene(id:int):void
		{
			if(!MainSystem.getInstance().isBusy && MainMenuStatic.currentSceneId!=id)
			{
				MainMenuStatic.currentSceneId=id;
//				MainSystem.getInstance().enable360System();
//				MainSystem.getInstance().startRender();
//				MainSystem.getInstance().gotoScene(id);
			}
		}
		protected function customGoto2DScene(id:int,moduleName:String):void
		{
			if(!MainSystem.getInstance().isBusy && MainMenuStatic.currentSceneId!=id)
			{
				MainMenuStatic.currentSceneId=id;
				MainSystem.getInstance().currentScene=-1;
				MainSystem.getInstance().showPluginById(moduleName);
			}
		}
	}
}