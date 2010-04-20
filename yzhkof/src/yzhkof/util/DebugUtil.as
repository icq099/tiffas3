package yzhkof.util
{
	import flash.events.EventDispatcher;
	import flash.utils.getQualifiedClassName;
	
	public class DebugUtil
	{
		public function DebugUtil()
		{
		}
		public static function analyseInstance(obj:Object):String
		{
			var re_text:String="*********************************\n";
			if(obj==null)
			{
				re_text+="null\n";
			}else
			{ 
				re_text+=analyseMenbers(obj);
			}
			re_text+="**********************************\n";
			return re_text;
		}
		private static function analyseMenbers(obj:Object):String
		{
			var re_text:String="";
			if(obj is EventDispatcher)
			{
				var listener_arr:Array=obj[QNameUtil.getObjectQname(obj,QNameUtil.LISTENERS)];
				var length:int=listener_arr?listener_arr.length:0;
				re_text+="监听器数 ： "+length+"\n";
				for(var i:int=0;i<length;i++)
				{
					var fun:Object=listener_arr[i];
					if(fun is Function)
					{
						re_text+="	"+i+" ： 监听器this指向["+fun[QNameUtil.getObjectQname(fun,QNameUtil.SAVEDTHIS)]+"]\n";
					}
					else
					{
						re_text+="	"+i+" ： 监听器为 "+getQualifiedClassName(fun)+"\n";
					}
				}
			}
			return re_text;
		}

	}
}