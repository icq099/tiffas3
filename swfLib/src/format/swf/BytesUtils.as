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
		
		public static function ToHexDump(description:String,dump:ByteArray, start:int, count:int):String
		{
			var hexDump:String = "";
			if (description != null)
			{
				hexDump += description;
				hexDump += "\n";
			}
			var end:int = start + count;
			for (var i:int = start; i < end; i += 16)
			{
				var text:String = "";
				var hex:String = "";
				
				for (var j:int = 0; j < 16; j++)
				{
					if (j + i < end)
					{
						var val:Number = dump[j + i];
						if(val < 16)
						{
							hex += "0" + val.toString(16)+" ";
						}
						else
						{
							hex += val.toString(16) + " ";
						}
						
						if (val >= 32 && val <= 127)
						{
							text += String.fromCharCode(val);
						}
						else
						{
							text += ".";
						}
					}
					else
					{
						hex += "   ";
						text += " ";
					}
				}
				hex +="  ";
				hex += text;
				hex += '\n';
				hexDump += hex;
			}
			return hexDump;
		}

	}
}