package yzhkof.util
{
	public class StringUtil
	{
		public function StringUtil()
		{
		}
		public static function addString(str:String,strAdd:String,index:uint):String
		{
			return str.substring(0,index)+strAdd+str.substring(index);
		}

	}
}