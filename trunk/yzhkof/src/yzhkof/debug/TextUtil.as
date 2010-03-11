package yzhkof.debug
{
	import flash.utils.describeType;
	
	public class TextUtil
	{
		public function TextUtil()
		{
		}
		public static function objToTextTrace(obj:Object):String
		{
			var final_text:String="";
			var xml:XML=describeType(obj);
			var accessor_xmllist:XMLList;
			accessor_xmllist=xml.accessor.(@access!="writeonly");
			
			final_text+="Type : "+xml.@name+"**************************\n";
			//final_text+=addSpace()+"\n"
			for each(var x:XML in accessor_xmllist)
			{
				final_text+=addSpace(x.@name+" : "+obj[x.@name])+"\n";
			}
			final_text+="**********************************************\n";
			return final_text;
		}
		private static function addSpace(str:String):String{
			return "	"+str;
		}
		

	}
}