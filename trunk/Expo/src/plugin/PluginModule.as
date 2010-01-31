package plugin
{
	import communication.IPlugin;
	import communication.MainSystem;
	
	import mx.modules.Module;
	
	import yzhkof.util.HashMap;

	public class PluginModule extends Module implements IPlugin
	{
		private var api_map:HashMap=new HashMap;
		public function PluginModule()
		{
			super();
		}
		public function addAPI(fun_name:String,fun:Function):void{
			MainSystem.getInstance().addAPI(fun_name,fun);
			api_map.put(fun_name,fun_name);
		}
		public function removeAPI(fun_name:String):void{
			MainSystem.getInstance().removeAPI(fun_name);
			api_map.remove(fun_name);
		}
		public function dispose():void{
			for each(var i:String in api_map.valueSet){
				MainSystem.getInstance().removeAPI(i);
			}
		}
		
	}
}