package core.manager.scriptManager
{
	import core.manager.scriptManager.event.ScriptEvent;
	import core.manager.scriptManager.scripsimple.ScripSimpleAPI;
	import core.manager.scriptManager.scripsimple.ScriptSimple;
	import core.manager.scriptManager.scripsimple.ScriptUtil;
	
	import flash.events.EventDispatcher;
	[Event(name="addapi", type="scriptManager.event.ScriptEvent")]
	[Event(name="removeapi", type="scriptManager.event.ScriptEvent")]
	[Event(name="runapi", type="scriptManager.event.ScriptEvent")]
	[Event(name="runscript", type="scriptManager.event.ScriptEvent")]
	public class ScriptManager extends EventDispatcher
	{
	    private static var instance:ScriptManager
	    private var api:ScripSimpleAPI=new ScripSimpleAPI()
	    private var scriptSimple:ScriptSimple=new ScriptSimple(api);
		public function ScriptManager()
		{
		   if(instance==null)
			{
				instance=this;
			}else
			{
				throw new Error("ScriptManager不能被实例化");
			}
			ScriptManager.getInstance().addApi(ScriptName.RUNSCRIPTUNTILSCRIPTEXIST,runScriptUntilScriptExist);
		}
		public static function getInstance():ScriptManager
		{
			if(instance==null) return new ScriptManager();
			return instance;
		}
		//把XML中的脚本转换成ScriptManager所识别的脚本,例如,showPluginById[YangMengBaGuiModule]---->showPluginById(YangMengBaGuiModule);
		public function filterScript(xmlScript:String):String
		{
			if(xmlScript!=null)
			{
				xmlScript=xmlScript.replace("[","(");
				xmlScript=xmlScript.replace("]",")");
				xmlScript+=";";
			}
			return xmlScript;
		}
		//添加API
		public function addApi(fun_name:String,fun:Function):void
		{
			api.addAPI(fun_name,fun);
			ScriptManager.getInstance().dispatchEvent(new ScriptEvent(ScriptEvent.ADDAPI,fun_name,fun));
		}
		//删除API
		public function removeApi(fun_name:String):void
		{
			api.removeAPI(fun_name);
			ScriptManager.getInstance().dispatchEvent(new ScriptEvent(ScriptEvent.REMOVEAPI,fun_name));
		}
		
		public function runScriptUntilScriptExist(script:String):*
		{
			script=filterScript(script);
			var funName:String=ScriptUtil.getFunctionName(script);
			if(api.apiExist(funName))
			{
				return scriptSimple.run(script);
			}else
			{
				addEventListener(ScriptEvent.ADDAPI,function on_api_add(e:ScriptEvent):void
				{
					if(e.funName==funName)
					{
						removeEventListener(ScriptEvent.ADDAPI,on_api_add);
						scriptSimple.run(script);
					}
				});
			}
		}
		//直接运行脚本
		public function runScriptDirectly(script:String):*
		{
			ScriptManager.getInstance().dispatchEvent(new ScriptEvent(ScriptEvent.RUNSCRIPT,null,null,script));
			return scriptSimple.run(script);
		}
		//跳过函数名运行已经注册的API,API没注册就输出函数为空的警告
		public function runScriptByName(function_name:String,param:Array=null):*
		{
			return scriptSimple.runFunctionDirect(function_name,param);
			ScriptManager.getInstance().dispatchEvent(new ScriptEvent(ScriptEvent.RUNAPI,function_name));
		}
	}
}