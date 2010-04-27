package core.manager.sceneManager.SceneScript
{
	public interface ISceneScript
	{
		function runSceneInitScript(id:int):void;
		function runSceneJustCompleteScript(id:int):void;
	}
}