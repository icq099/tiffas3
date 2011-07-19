package format.swf
{
	import flash.utils.ByteArray;
	
	public class BytesUtils
	{
		public function BytesUtils()
		{
		}
		/**
		 *	获取字节数组快照 
		 * @param src_byte
		 * @param length 
		 * @param position 起始读取的位置，默认从当前位置开始读取
		 * @return 
		 * 
		 */		
		public static function snapShotBytes(src_byte:ByteArray,length:uint,start_position:int=-1):ByteArray
		{
			var old_pos:uint=src_byte.position;
			var re_byte:ByteArray=new ByteArray;
			if(start_position>=0)
			{
				src_byte.position=start_position;
			}
			src_byte.readBytes(re_byte,0,length);
			src_byte.position=old_pos;
			re_byte.endian=src_byte.endian;
			return re_byte;
		}
		public static function copyBytes(src_byte:ByteArray):ByteArray
		{
			var reBytes:ByteArray=new ByteArray;
			reBytes=snapShotBytes(src_byte,src_byte.length,0);
			return reBytes;
		}

	}
}