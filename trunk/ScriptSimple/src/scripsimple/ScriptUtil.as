package scripsimple
{	
	
	public class ScriptUtil
	{
		public function ScriptUtil()
		{
		}
		public static function isFunction(str:String):Boolean{
			
			var reg:RegExp=/\w*\(.*\)/;
			return reg.test(str);
		
		}
		public static function getSentence(str:String):Array{
			
			var sentence_array:Array=str.replace("\n","").split(";");
			sentence_array.pop();
			return sentence_array;
		
		}
		public static function getFunctionName(str:String):String{
			
			var fun_name:String;
			var reg:RegExp=/\w*(?=\(.*\))/;
			return fun_name=str.match(reg)[0];
		
		}
		/**
		 *	获得字符串方法参数 
		 * @param str
		 * @return 参数数组
		 * 
		 */		
		public static function getFunParam(str:String):Array{
			
			var reg:RegExp=/(?<=\().*(?=\))/;//去括号
			var re_array:Array=String(str.match(reg)[0]).split(",");
			//trace(str.match(reg)[0]);
			if((re_array.length==1)&&(re_array[0]=="")){
				return [];
			}
			return re_array;
		
		} 
		public static function isNum(str:String):Boolean{
			return true;
		}

	}
}