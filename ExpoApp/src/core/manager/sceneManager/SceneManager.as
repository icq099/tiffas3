package core.manager.sceneManager
{
	import core.manager.MainSystem;
	import core.manager.modelManager.ModelManager;
	import core.manager.sceneManager.SceneScript.SceneScript;
	import core.manager.scriptManager.ScriptManager;
	import core.manager.scriptManager.ScriptName;
	
	import flash.events.EventDispatcher;
	
	import mx.managers.BrowserManager;
	[Event(name="init", type="manager.sceneManager.event.SceneChangeEvent")]
	[Event(name="complete", type="manager.sceneManager.event.SceneChangeEvent")]
	public class SceneManager extends EventDispatcher
	{
		private static var instance:SceneManager; //单例。。。
		public var currentSceneId:int=-1;         //当前场景的ID
		private var maxSceneNum:int=-1;           //场景的总数目
		private var sceneXml:XML;                 //场景的配置数据
		public function SceneManager()
		{
		   if(instance==null)
			{
				instance=this;
			}else
			{
				throw new Error("不能实例化");
			}
			init();
		}
		private function init():void
		{
			sceneXml=ModelManager.getInstance().xmlBasic;                         //存储的引用
			maxSceneNum=sceneXml.Travel.Scene.length();                           //存储最大场景数目
			ScriptManager.getInstance().addApi(ScriptName.GO_TO_SCENE,gotoScene);   //添加更换场景的API
		}
		public static function getInstance():SceneManager
		{
			if(instance==null) return new SceneManager();
			return instance;
		}
		public function gotoScene(toId:int):Boolean
		{
			if(toId>maxSceneNum || currentSceneId==toId || MainSystem.getInstance().isBusy)//场景没变化或者主系统处于繁忙状态
			{
				return false;
			}
			BrowserManager.getInstance().setFragment("scene="+toId);   //修改地址栏的地址
			dispacherSceneChangeInitEvent(toId);                       //抛出更换场景的事件
			MainSystem.getInstance().isBusy=true;                         //加锁，避免用户重复点击
			SceneScript.runInitScript(currentSceneId,toId);
			if(!hasEventListener(SceneChangeEvent.JUST_BEFORE_COMPLETE))
			{
				addEventListener(SceneChangeEvent.JUST_BEFORE_COMPLETE,function onComplete(e:SceneChangeEvent):void
				{
					SceneScript.runJustCompleteScript(currentSceneId,toId);
					removeEventListener(SceneChangeEvent.JUST_BEFORE_COMPLETE,onComplete);
					currentSceneId=toId;                                       //全部完成了才更换场景ID
					MainSystem.getInstance().isBusy=false;
					dispacherChangeCompleteEvent(e.id);
				});
			}
			return true;
		}
		public function dispacherSceneChangeInitEvent(id:int):void
		{
			dispatchEvent(new SceneChangeEvent(SceneChangeEvent.INIT,id));
		}
		public function dispacherJustBeforeCompleteEvent(id:int):void
		{
			dispatchEvent(new SceneChangeEvent(SceneChangeEvent.JUST_BEFORE_COMPLETE,id));
		}
		public function dispacherChangeCompleteEvent(id:int):void
		{
			dispatchEvent(new SceneChangeEvent(SceneChangeEvent.COMPLETE,id));
		}
	}
}