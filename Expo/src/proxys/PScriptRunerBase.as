package proxys
{
	import communication.Event.ScriptAPIAddEvent;
	import communication.Event.ScriptEvent;
	import communication.MainSystem;
	
	import model.ScriptRuner;
	
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class PScriptRunerBase extends Proxy
	{
		public static var NAME:String="PScriptRuner";
		protected var runer:ScriptRuner=new ScriptRuner();
		
		public function PScriptRunerBase()
		{
			super(NAME, runer);
			init();
		}
		protected function init():void{
			MainSystem.getInstance().addEventListener(ScriptEvent.RUN,onPluginScriptRun);		
			MainSystem.getInstance().addEventListener(ScriptAPIAddEvent.ADD_API,onAPIAdd);
			MainSystem.getInstance().addEventListener(ScriptAPIAddEvent.REMOVE_API,onAPIRemove);
			MainSystem.getInstance().addEventListener(ScriptEvent.RUN_BY_FUNCTION,onScriptRunDirect);
		}
		protected function onPluginScriptRun(e:ScriptEvent):void{
			runScript(e.script);
		}
		protected function onAPIAdd(e:ScriptAPIAddEvent):void{
			addAPI(e.fun_name,e.fun);
		}
		protected function onAPIRemove(e:ScriptAPIAddEvent):void{
			removeAPI(e.fun_name);
		}
		protected function onScriptRunDirect(e:ScriptEvent):void{
			runer.runFunctionDirect(e.function_name,e.param);
		}
		public function addAPI(fun_name:String,fun:Function):void{
			runer.addAPI(fun_name,fun);	
		}
		public function removeAPI(fun_name:String):void{
			runer.removeAPI(fun_name);
		}
		public function runScript(script:String):void{
			runer.run(script);
		}
		
	}
}