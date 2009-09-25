package scripsimple
{	
	
	public class ScriptUntil
	{
		public function ScriptUntil()
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
		public static function getFunParam(str:String):Array{
			
			var reg:RegExp=/(?<=\().*(?=\))/;
			var re_array:Array=String(str.match(reg)[0]).split(",");
			if((re_array.length==1)&&(re_array[0]=="")){
				return [];
			}
			return re_array;
		
		}

	}
}