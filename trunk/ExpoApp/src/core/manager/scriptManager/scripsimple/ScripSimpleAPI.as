package core.manager.scriptManager.scripsimple
{
	public class ScripSimpleAPI
	{
		private var out_fun:Object=new Object();
		
		public function ScripSimpleAPI()
		{
		}
		public function addAPI(fun_name:String,fun:Function):void{
			out_fun[fun_name]=fun;
		}
		public function removeAPI(fun_name:String):void{
			delete out_fun[fun_name];
		}
		internal function excuteFunctionByName(function_name:String,param:Array=null):*{
			var fun:Function=out_fun[function_name];
			if(fun==null){
				trace(function_name+"方法当前为空！");
				return null;
			}
			var re:*;
			re=fun.apply(NaN,param);
			return re;
		}
	}
}