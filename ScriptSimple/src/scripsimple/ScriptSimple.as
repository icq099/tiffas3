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
			
			this.script=script;
			return excute();
		
		}
		private function excute():*{
			
			var sentence_array:Array=ScriptUntil.getSentence(script);
			var k:int=0
			for each(var i:String in sentence_array){
			
				ScriptUntil.isFunction(i)?excuteFunction(i):executeError(0,sentence_array.indexOf(i)+1);
				k++
			
			}
			return 0;
		}
		private function excuteFunction(str:String):*{
			
			var fun_name:String=ScriptUntil.getFunctionName(str);
			var param_array:Array=ScriptUntil.getFunParam(str);
			for(var i:int=0;i<param_array.length;i++){
				if(ScriptUntil.isFunction(param_array[i])){
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