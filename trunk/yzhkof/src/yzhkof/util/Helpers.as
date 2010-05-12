package yzhkof.util
{
	public class Helpers
	{
		public static function copyProperty(from_obja:Object,to_objb:Object,propertiy:Array=null):void
		{
			for each(var i:String in propertiy)
			{
				to_objb[i]=from_obja[i];
			}
		}
	}
}