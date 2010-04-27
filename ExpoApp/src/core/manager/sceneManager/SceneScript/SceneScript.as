package core.manager.sceneManager.SceneScript
{
	public class SceneScript
	{
		public static function runInitScript(currentId:int,toId:int):void
		{
			switch(toId)
			{
				case 0:Scene0Script.runSceneInitScript(currentId);break;
				case 1:Scene1Script.runSceneInitScript(currentId);break;
				case 2:Scene2Script.runSceneInitScript(currentId);break;
				case 3:Scene3Script.runSceneInitScript(currentId);break;
				case 4:Scene4Script.runSceneInitScript(currentId);break;
				case 5:Scene5Script.runSceneInitScript(currentId);break;
				case 6:Scene6Script.runSceneInitScript(currentId);break;
				case 7:Scene7Script.runSceneInitScript(currentId);break;
				case 8:Scene8Script.runSceneInitScript(currentId);break;
				case 9:Scene9Script.runSceneInitScript(currentId);break;
			}
		}
		public static function runJustCompleteScript(currentId:int,toId:int):void
		{
			switch(toId)
			{
				case 0:Scene0Script.runSceneJustCompleteScript(currentId);break;
				case 1:Scene1Script.runSceneJustCompleteScript(currentId);break;
				case 2:Scene2Script.runSceneJustCompleteScript(currentId);break;
				case 3:Scene3Script.runSceneJustCompleteScript(currentId);break;
				case 4:Scene4Script.runSceneJustCompleteScript(currentId);break;
				case 5:Scene5Script.runSceneJustCompleteScript(currentId);break;
				case 6:Scene6Script.runSceneJustCompleteScript(currentId);break;
				case 7:Scene7Script.runSceneJustCompleteScript(currentId);break;
				case 8:Scene8Script.runSceneJustCompleteScript(currentId);break;
				case 9:Scene9Script.runSceneJustCompleteScript(currentId);break;
			}
		}
	}
}