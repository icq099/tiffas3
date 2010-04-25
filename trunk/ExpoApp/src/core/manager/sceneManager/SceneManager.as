package core.manager.sceneManager
{
	import core.manager.MainSystem;
	import core.manager.modelManager.ModelManager;
	import core.manager.sceneManager.SceneChangeEvent;
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
		public function gotoScene(sceneId:int):Boolean
		{
			if(sceneId>maxSceneNum || currentSceneId==sceneId || MainSystem.getInstance().isBusy)//场景没变化或者主系统处于繁忙状态
			{
				return false;
			}
			BrowserManager.getInstance().setFragment("scene="+sceneId);   //修改地址栏的地址
			dispacherSceneChangeInitEvent(sceneId);                       //抛出更换场景的事件
			MainSystem.getInstance().isBusy=true;                         //加锁，避免用户重复点击
			var oldSceneId:int=currentSceneId;                            //存储旧的场景ID
			currentSceneId=sceneId;                                       //更换场景ID
			//读取所要去的场景的数据库
			var currentSceneXmlData:XML=sceneXml.Travel.Scene[currentSceneId];
			var sceneInitScript:String;                                    //指定ID的脚本
			var sceneJustBeforeCompleteScript:String;                               
			var defaultInitScript:String;                                 //默认的脚本
			var defaultJustBeforeCompleteScript:String;           
			for(var j:int=0;j<currentSceneXmlData.Script.length();j++)    //搜索默认的脚本,其他场景跳到当前场景，如果没有匹配的ID，就采用默认的脚本
			{
				if(currentSceneXmlData.Script[j].@fromId=="default")
				{
					defaultInitScript=currentSceneXmlData.Script[j].@sceneInitScript;
					defaultJustBeforeCompleteScript=currentSceneXmlData.Script[j].@sceneJustBeforeCompleteScript;
				}
			}
			for(var i:int=0;i<currentSceneXmlData.Script.length();i++)    //搜索匹配ID的脚本
			{
				var tempId:int=int(currentSceneXmlData.Script[i].@fromId);   
				if(oldSceneId==tempId)
				{
					sceneInitScript=currentSceneXmlData.Script[i].@sceneInitScript;
					sceneJustBeforeCompleteScript=currentSceneXmlData.Script[i].@sceneJustBeforeCompleteScript;
					break;
				}
			}
			if(i==currentSceneXmlData.Script.length())                    //找不到匹配的ID,就采用默认的脚本
			{
				sceneInitScript=defaultInitScript;
				sceneJustBeforeCompleteScript=defaultJustBeforeCompleteScript;
			}
			ScriptManager.getInstance().runScriptDirectly(sceneInitScript);
			addEventListener(SceneChangeEvent.JUST_BEFORE_COMPLETE,function onComplete(e:SceneChangeEvent):void
			{
				if(e.id==sceneId)//如果完成加载的场景的编号为当前场景编号
				{
					ScriptManager.getInstance().runScriptDirectly(sceneJustBeforeCompleteScript);
					removeEventListener(SceneChangeEvent.JUST_BEFORE_COMPLETE,onComplete);
					MainSystem.getInstance().isBusy=false;
					dispacherChangeCompleteEvent(e.id);
				}
			});
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