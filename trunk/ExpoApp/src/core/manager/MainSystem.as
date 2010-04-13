package core.manager
{
	import core.manager.pluginManager.PluginManager;
	import core.manager.sceneManager.event.SceneChangeEvent;
	import core.manager.scriptManager.ScriptManager;
	
	import flash.events.EventDispatcher;
	
	public class MainSystem extends EventDispatcher
	{
	    private static var instance:MainSystem
	    public var isBusy:Boolean=false;
	    public var currentScene:int;
	    public var currentHotpoint:*;
		public function MainSystem()
		{
		   if(instance==null)
			{
				super(this);
				instance=this;
			}else
			{
				throw new Error("ScriptManager不能被实例化");
			}
		}
		public static function getInstance():MainSystem
		{
			if(instance==null) return new MainSystem();
			return instance;
		}
		public function runScript(script:String):*
		{
			return ScriptManager.getInstance().runScriptDirectly(script);
		}
		public function runAPI(funName:String,param:Array=null):*
		{
			if(MainSystem.getInstance().isBusy)return;
			return ScriptManager.getInstance().runScriptByName(funName,param);
		}
		public function runAPIDirectDirectly(funName:String,param:Array=null):*
		{
			return ScriptManager.getInstance().runScriptByName(funName,param);
		}
		//显示插件
		public function showPluginById(id:String):void
		{
			PluginManager.getInstance().showPluginById(id);
		}
		//删除插件
		public function removePluginById(id:String):void
		{
			PluginManager.getInstance().removePluginById(id);
		}
		//给插件添加自动关闭的事件
		public function addSceneChangeInitHandler(fun:Function,param:Array=null):void
		{
			if(fun==null){
				throw new Error("自动关闭的方法不能为空");
			}else
			{
				getInstance().addEventListener(SceneChangeEvent.INIT,function on_scene_init(e:SceneChangeEvent):void{
					var re:*;
					re=fun.apply(NaN,param);	
					if(getInstance().hasEventListener(SceneChangeEvent.INIT)) getInstance().removeEventListener(SceneChangeEvent.INIT,on_scene_init);
				});
			}
		}
		//给插件添加自动关闭的事件
		public function addSceneChangeCompleteHandler(fun:Function,param:Array=null):void
		{
			if(fun==null){
				throw new Error("自动关闭的方法不能为空");
			}else
			{
				getInstance().addEventListener(SceneChangeEvent.COMPLETE,function on_scene_complete(e:SceneChangeEvent):void{
					var re:*;
					re=fun.apply(NaN,param);	
					if(getInstance().hasEventListener(SceneChangeEvent.COMPLETE)) getInstance().removeEventListener(SceneChangeEvent.COMPLETE,on_scene_complete);
				});
			}
		}
	}
}