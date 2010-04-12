package core.manager.sceneManager
{
	import flash.events.EventDispatcher;
	
	public class SceneManager extends EventDispatcher
	{
		private static var instance:SceneManager;
		public function SceneManager()
		{
		   if(instance==null)
			{
				instance=this;
			}else
			{
				throw new Error("不能实例化");
			}
		}
		public static function getInstance():SceneManager
		{
			if(instance==null) return new SceneManager();
			return instance;
		}
	}
}