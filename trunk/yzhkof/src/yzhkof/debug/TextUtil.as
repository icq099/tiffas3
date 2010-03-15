package yzhkof.debug
{
	import flash.utils.describeType;
	
	import yzhkof.util.XmlUtil;
	
	public class TextUtil
	{
		public function TextUtil()
		{
		}
		public static function objToTextTrace(obj:Object):String
		{
			var final_text:String="";
			var title_text:String="";
			var objname:String;
			var xml:XML=describeType(obj);
			
			if(!isSimple(obj))
			{
				var accessor_xmllist:XMLList;
				accessor_xmllist=xml.accessor.(@access!="writeonly");
				accessor_xmllist=XmlUtil.sortOnXMLList(accessor_xmllist,"@name");
				
				for each(var x:XML in accessor_xmllist)
				{
					final_text+=addSpace("<"+x.@name+"> : "+obj[x.@name])+"\n";
					if(x.@name=="name")
						objname=obj.name;
				}
				
				if(xml.@isDynamic=="true")
				{
					for(var ob_p:Object in obj)
					{
						final_text+=addSpace("<"+ob_p+"> : "+obj[ob_p])+"\n";	
					}
				}
			}else
			{
				final_text+=addSpace(obj.toString())+"\n";
			}
			
			title_text="Type : "+xml.@name;
			if(objname)
				title_text+="(name:"+objname+")";
			title_text+="**************************\n";
			final_text+="**********************************************\n";
			final_text=title_text+final_text;
			
			return final_text;
		}
		private static function isSimple(obj:Object):Boolean
		{
			var type:String = typeof(obj);
	        switch (type)
	        {
	            case "number":
	            case "string":
	            case "boolean":
	            {
	                return true;
	            }
	        }
	
	        return false;
		}
		private static function addSpace(str:String):String{
			return "	"+str;
		}
		

	}
}