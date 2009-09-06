package yzhkof.file
{
	import flash.utils.ByteArray;
	
	public class SimpleEncoder
	{
		public function SimpleEncoder()
		{
		}
		public static function encode(byte:ByteArray):ByteArray{
			
			var re_byte:ByteArray=new ByteArray();
			re_byte.writeByte(0);
			re_byte.writeBytes(byte,0,byte.length);
			return re_byte;
		
		}

	}
}