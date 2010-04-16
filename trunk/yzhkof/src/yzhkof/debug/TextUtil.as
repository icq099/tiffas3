package yzhkof.debug
{
	import flash.utils.ByteArray;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import yzhkof.util.XmlUtil;
	
	public class TextUtil
	{
		public function TextUtil()
		{
		}
		public static function objToTextTrace(obj:*,showFunctionReturn:Boolean=false):String
		{
			var final_text:String="";
			var title_text:String="";
			var objname:String;
			
			if((obj!=null)&&(obj!=undefined))
			{
				var xml:XML=describeType(getDefinitionByName(getQualifiedClassName(obj)));
				var isClass:Boolean=obj is Class;
				
				if(!isSimple(obj))
				{
					var accessor_xmllist:XMLList=getAccessProperty(xml,isClass);				
					
					for each(var x:XML in accessor_xmllist)
					{
						try
						{
							if(!(obj[x.@name] is ByteArray))
							{
								final_text+=addSpace("{"+x.@name+"} = "+obj[x.@name])+"\n";
								if(x.@name=="name")
									objname=obj.name;
							}else
							{
								final_text+=addSpace("{"+x.@name+"} = [Type ByteArray]\n");
							}
						}catch(e:Error)
						{
							
						}
						
					}
					
					if(xml.@isDynamic=="true")
					{
						for(var ob_p:Object in obj)
						{
							if(!(obj[ob_p] is ByteArray))
							{
								final_text+=addSpace("{"+ob_p+"} = "+obj[ob_p])+"\n";
							}else
							{
								final_text+=addSpace("{"+ob_p+"} = [Type ByteArray]\n");
							}
						}
					}
					if(showFunctionReturn)
					{
						var method_xmllist:XMLList=getReturnOnlyMethod(xml,isClass);
						for each(var xx:XML in method_xmllist)
						{
							final_text+=addSpace("["+xx.@name+"()] : "+obj[xx.@name]())+"\n";
						}
					}else
					{
						final_text+=addSpace("[toString()] : "+obj.toString())+"\n";
					}
				}else
				{
					final_text+=addSpace(obj.toString())+"\n";
				}
				
				title_text="Type : "+xml.@name;
			}else
			{
				final_text+=obj+"\n";
			}
			if(objname)
				title_text+="(name:"+objname+")";
			title_text+="**************************\n";
			final_text+="**********************************************\n";
			final_text=title_text+final_text;
			
			return final_text;
		}
		public static function getMethod(xml:XML,isClass:Boolean=false):XMLList
		{
			var method_xmllist:XMLList;
			if(!isClass)
			{ 
				method_xmllist=xml.factory.method;
			}
			else
			{
				method_xmllist=xml.method;
			}
			return method_xmllist;
		}
		public static function getReturnOnlyMethod(xml:XML,isClass:Boolean=false):XMLList
		{
			var method_xmllist:XMLList=getMethod(xml,isClass);
			var return_only_method_xmllist:XMLList=new XMLList();
			for each(var x:XML in method_xmllist.(@returnType!="void"))
			{
				if(!x.hasOwnProperty("parameter"))
					return_only_method_xmllist+=x;
			}
			return return_only_method_xmllist;
		}
		public static function getAccessProperty(xml:XML,isClass:Boolean=false):XMLList
		{
			var accessor_xmllist:XMLList;
			if(!isClass)
			{
				accessor_xmllist=xml.factory.accessor.(@access!="writeonly");
				accessor_xmllist+=xml.factory.variable;
			}
			else
			{
				accessor_xmllist=xml.accessor.(@access!="writeonly")
				accessor_xmllist+=xml.variable;
			}
			accessor_xmllist=XmlUtil.sortOnXMLList(accessor_xmllist,"@name");
			return accessor_xmllist;
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