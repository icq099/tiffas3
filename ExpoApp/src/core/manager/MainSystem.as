package core.manager
{
	import core.manager.pluginManager.PluginManager;
	import core.manager.scriptManager.ScriptManager;
	
	import flash.events.EventDispatcher;
	
	
	public class MainSystem extends EventDispatcher
	{
	    private static var instance:MainSystem
	    public var _isBusy:Boolean=false;
 	    public static const ENGLISH:String="ENGLISH";//英文
 	    public static const CHINESE:String="CHINESE";//中文
 	    public var language:String=CHINESE;          //默认是中文
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
		private var oldBusyState:Boolean=false;
		public function set isBusy(val:Boolean):void
		{
			_isBusy=val;
//			if(_isBusy && oldBusyState==false)
//			{
//				CursorManager.setBusyCursor();
//			}else if(!_isBusy && oldBusyState==true)
//			{
//				CursorManager.removeBusyCursor();
//			}
//			oldBusyState=_isBusy;
		}
		public function get isBusy():Boolean
		{
			return _isBusy;
		}
	}
}