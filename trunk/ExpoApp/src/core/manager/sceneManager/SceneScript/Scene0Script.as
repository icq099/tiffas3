package core.manager.sceneManager.SceneScript
{
	public class Scene0Script implements ISceneScript
	{
		public static function runSceneInitScript(fromId:int):void
		{
			switch(fromId)
			{
				case -1:runInitScriptFrom_1();break;
				case 0:runInitScriptFrom0();break;
				default:runInitScriptFromDefault();break;
			}
		}
		public static function runSceneJustCompleteScript(fromId:int):void
		{
			switch(fromId)
			{
				case -1:runCompleteScriptFrom_1();break;
				case 0:runCompleteScriptFrom0();break;
				default:runCompleteScriptFromDefault();break;
			}
		}
		private static function runInitScriptFrom_1():void
		{
			
		}
		private static function runInitScriptFrom0():void
		{
			
		}
		private static function runInitScriptFromDefault():void
		{
			
		}
		private static function runCompleteScriptFrom_1():void
		{
			
		}
		private static function runCompleteScriptFrom0():void
		{
			
		}
		private static function runCompleteScriptFromDefault():void
		{
			
		}
	}
}