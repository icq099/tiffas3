package yzhkof.file
{
	import flash.utils.ByteArray;
	
	public class SimpleDecoder
	{
		public function SimpleDecoder()
		{
		}
		public static function decode(byte:ByteArray):ByteArray{
			
			var re_byte:ByteArray=new ByteArray();
			re_byte.writeBytes(byte,1,byte.length-1);
			return re_byte;
		
		}

	}
}