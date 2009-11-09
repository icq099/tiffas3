package scripsimple
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
		internal function excuteFunctionByName(function_name:String,param:Array=null):*{
			var fun:Function=out_fun[function_name];
			var re:*;
			try{
				re=fun.apply(NaN,param);
			}catch(e:Error){
				trace(function_name+"方法当前为空！");
			}
			return re;
		}
	}
}