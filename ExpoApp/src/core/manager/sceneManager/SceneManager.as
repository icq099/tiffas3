package core.manager.sceneManager
{
	import core.manager.MainSystem;
	import core.manager.modelManager.ModelManager;
	import core.manager.sceneManager.event.SceneChangeEvent;
	import core.manager.scriptManager.ScriptManager;
	import core.manager.scriptManager.ScriptName;
	
	import flash.events.EventDispatcher;
	
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
			ScriptManager.getInstance().addApi(ScriptName.GOTOSCENE,gotoScene);   //添加更换场景的API
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
			dispacherSceneChangeInitEvent(sceneId);                       //抛出更换场景的事件
			MainSystem.getInstance().isBusy=true;                         //加锁，避免用户重复点击
			var oldSceneId:int=currentSceneId;                            //存储旧的场景ID
			currentSceneId=sceneId;                                       //更换场景ID
			//读取所要去的场景的数据库
			var currentSceneXmlData:XML=sceneXml.Travel.Scene[currentSceneId];
			var backGroundMusic:String=currentSceneXmlData.Music.BackgroundMusic?currentSceneXmlData.Music.BackgroundMusic:null;  
			var sceneInitScript:String;                                    //指定ID的脚本
			var sceneChangedScript:String;                               
			var defaultInitScript:String;                                 //默认的脚本
			var defaultChangedScript:String;           
			for(var i:int=0;i<currentSceneXmlData.Script.length();i++)
			{
				var tempId:int=int(currentSceneXmlData.Script[i].@fromId);   
				if(oldSceneId==tempId)
				{
					sceneInitScript=currentSceneXmlData.Script[i].@sceneInitScript;
					sceneChangedScript=currentSceneXmlData.Script[i].@sceneChangedScript;
				}else if(tempId==-1)
				{
					defaultInitScript=currentSceneXmlData.Script[i].@sceneInitScript;
					defaultChangedScript=currentSceneXmlData.Script[i].@sceneChangedScript;
				}
			}
			if(sceneInitScript!=null || sceneInitScript!="")
			{
				ScriptManager.getInstance().runScriptDirectly(sceneInitScript);
			}else
			{
				ScriptManager.getInstance().runScriptDirectly(defaultInitScript);
			}
			addEventListener(SceneChangeEvent.COMPLETE,function onComplete(e:SceneChangeEvent):void
			{
				MainSystem.getInstance().isBusy=false;
				if(e.id==sceneId)//如果完成加载的场景的编号为当前场景编号
				{
					if(sceneChangedScript!=null || sceneChangedScript!="")
					{
						ScriptManager.getInstance().runScriptDirectly(sceneChangedScript);
					}else
					{
						ScriptManager.getInstance().runScriptDirectly(defaultInitScript);
					}
					removeEventListener(SceneChangeEvent.COMPLETE,onComplete);
				}
			});
			return true;
		}
		public function dispacherSceneChangeInitEvent(id:int):void
		{
			dispatchEvent(new SceneChangeEvent(SceneChangeEvent.INIT,id));
		}
		public function dispacherChangeCompleteEvent(id:int):void
		{
			dispatchEvent(new SceneChangeEvent(SceneChangeEvent.COMPLETE,id));
		}
	}
}