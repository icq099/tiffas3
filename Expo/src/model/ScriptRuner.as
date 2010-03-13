package model
{
	import scripsimple.ScripSimpleAPI;
	import scripsimple.ScriptSimple;

	public class ScriptRuner extends ScriptSimple
	{
		private var api:ScripSimpleAPI=new ScripSimpleAPI()
		public function ScriptRuner()
		{
			super(api);
		}
		public function addAPI(fun_name:String,fun:Function):void{
			api.addAPI(fun_name,fun);
		}
		public function removeAPI(fun_name:String):void{
//			api.removeAPI(fun_name);
		}
	}
}