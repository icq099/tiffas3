package proxys
{
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
		}
		protected function onPluginScriptRun(e:ScriptEvent):void{
			runScript(e.script);
		}
		public function addAPI(fun_name:String,fun:Function):void{
			runer.addAPI(fun_name,fun);		
		}
		public function runScript(script:String):void{
			runer.run(script);
		}
		
	}
}