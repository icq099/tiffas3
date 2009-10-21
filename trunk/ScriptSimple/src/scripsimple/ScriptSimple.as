package scripsimple
{
	public class ScriptSimple
	{
		private var script:String;
		private var _api:ScripSimpleAPI;
		
		
		
		public function ScriptSimple(api:ScripSimpleAPI)
		{
			_api=api;
		}
		public function run(script:String):*{
			
			if(script!=null){
				this.script=script;
				return excute();
			}
			return null;
		
		}
		public function runFunctionDirect(function_name:String,param:Array=null):*{
			return _api.excuteFunctionByName(function_name,param);
		}
		private function excute():*{
			
			var sentence_array:Array=ScriptUtil.getSentence(script);
			var k:int=0
			for each(var i:String in sentence_array){
			
				ScriptUtil.isFunction(i)?excuteFunction(i):executeError(0,sentence_array.indexOf(i)+1);
				k++
			
			}
			return 0;
		}
		/**
		 *	执行ScriptSimple方法 
		 * @param str
		 * @return 
		 * 
		 */		
		private function excuteFunction(str:String):*{
			
			var fun_name:String=ScriptUtil.getFunctionName(str);
			var param_array:Array=ScriptUtil.getFunParam(str);
			for(var i:int=0;i<param_array.length;i++){
				if(ScriptUtil.isFunction(param_array[i])){
					param_array[i]=excuteFunction(param_array[i]);				
				}			
			}
			return _api.excuteFunctionByName(fun_name,param_array);	
		
		}
		private function executeError(num:int,line:int):void{
			
			throw new Error("ScriptSimple语法错误！在程序第"+line+"行。");
		
		}
	}
}