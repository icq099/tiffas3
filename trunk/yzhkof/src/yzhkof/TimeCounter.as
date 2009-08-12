package yzhkof
{
	public class TimeCounter
	{
		private static var count:Number=0;
		public function TimeCounter()
		{
		}
		public static function init():void{
			
			count=0;
		
		}
		public static function add(value:Number):void{
			
			count+=value;
		
		}
		public static function result():Number{
			
			return count;
		
		}
		public static function traceResult():void{
			
			trace(result());
		
		}

	}
}