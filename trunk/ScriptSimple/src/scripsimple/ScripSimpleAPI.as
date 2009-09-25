package scripsimple
{
	public class ScripSimpleAPI
	{
		private var fun_stirng:Array=new Array();
		private var out_fun:Array=new Array();
		
		public function ScripSimpleAPI()
		{
		}
		public function addAPI(fun_name:String,fun:Function):void{
			
			fun_stirng.push(fun_name);
			out_fun.push(fun);
		
		}
		internal function excuteFunctionByName(function_name:String,param:Array):*{
			
			var fun:Function=out_fun[fun_stirng.indexOf(function_name)];
			return fun.apply(NaN,param);		
		
		}

	}
}