package format.swf.writer
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import flashx.textLayout.formats.WhiteSpaceCollapse;
	
	import format.swf.BytesUtils;
	import format.swf.Script_info;
	import format.swf.String_info;
	
	public class SwfWriter
	{
		public function SwfWriter()
		{
		}
		public static function getSwfByteData(headerTag:ByteArray,uncompressBytes:ByteArray):ByteArray
		{
			var headerTag_c:ByteArray=BytesUtils.copyBytes(headerTag);
			var uncompressBytes_c:ByteArray=BytesUtils.copyBytes(uncompressBytes);
			var swf:ByteArray=new ByteArray;
			headerTag_c.position = 0;
			if(headerTag_c.readUTFBytes(3) == "CWS")
			{
				uncompressBytes_c.compress();
				uncompressBytes_c.position=0;
			}
			
			swf.writeBytes(headerTag_c);
			swf.writeBytes(uncompressBytes_c);
			swf.position=0;
			return swf;
		}
		
		public static function writeSwfTagCodeAndLength(byte:ByteArray,tagCode:int,length:int):void
		{
			byte.endian = Endian.LITTLE_ENDIAN;
			var firstuint16:int;
			if(length>=0x3f)
			{
				firstuint16 = (tagCode<<6) + 0x3f;
				byte.writeShort(firstuint16);
				byte.writeInt(length);
			}
			else
			{
				firstuint16 = (tagCode<<6) + length;
				byte.writeShort(firstuint16);
			}
		}
		/**
		 * 把src里的position位置的length长度的字节替换成byte,替换后指针偏移至添加的byte后; 
		 * @param src
		 * @param position
		 * @param length
		 * @param byte
		 * 
		 */		
		public static function replayAndAddBytes(src:ByteArray,position:int,length:int,byte:ByteArray):void
		{
			var tailByte:ByteArray = new ByteArray;
			tailByte.endian = src.endian;
//			trace(BytesUtils.ToHexDump("src",src,position,20));
			src.position = position + length;
			src.readBytes(tailByte,0,src.length - position - length);
//			trace(BytesUtils.ToHexDump("tailByte",tailByte,0,tailByte.length));
			src.position = position;
			src.writeBytes(byte);
			src.writeBytes(tailByte);
			src.position = position + byte.length;
		}
		
		public static function writeMultiName(byte:ByteArray,kind:uint,ns:uint = 0 ,name:uint = 0):void//未完成
		{
			byte.writeByte(kind);
			writeVU32(byte,ns);
			writeVU32(byte,name);
		}
		
		public static function writeNameSpaceInfo(byte:ByteArray,kind:uint,name:uint):void
		{
			byte.writeByte(kind);
			writeVU32(byte,name);
		}
		
		public static function writeVU32(byte:ByteArray,value:uint):int
		{
			var mask:uint = 0x7f;
			var flag:uint = 0x80;
			var bit_length:uint = value.toString(2).length;
			var for_count:uint = Math.ceil(bit_length / 7);
			var t_value:uint;
			
			for(var i:int = 0;i<for_count;i++)
			{
				t_value = (value>>>(i*7))&mask;
				if(i < (for_count-1))
					t_value |= flag;
				byte.writeByte(t_value);
			}
			return for_count;
		}
		
		public static function writeStringInfo(byte:ByteArray,str:String):void
		{
			writeVU32(byte,str.length);
			byte.writeUTFBytes(str);
		}
		
		public static function writeMethodBody(byte:ByteArray,method:uint,max_stack:uint,local_count:uint,
											   init_scope_depth:uint,max_scope_depth:uint,code_length:uint,
											   opcodeBytes:ByteArray):void
		{
			writeVU32(byte,method);
			writeVU32(byte,max_stack);
			writeVU32(byte,local_count);
			writeVU32(byte,init_scope_depth);
			writeVU32(byte,max_scope_depth);
			writeVU32(byte,code_length);
			byte.writeBytes(opcodeBytes);
			writeVU32(byte,0);//exception_count
			writeVU32(byte,0);//trait_count
		}
		
		public static function writeMethod(byte:ByteArray,param_count:uint,return_type:uint,param_type:Array,name:uint,
										   flags:int):void
		{
			writeVU32(byte,param_count);
			writeVU32(byte,return_type);
			var i:int;
			for(i=0;i<param_count;i++)
			{
				writeVU32(byte,param_type[i]);
			}
			writeVU32(byte,name);
			writeVU32(byte,flags);
		}
		
//		public static function writeTrait(byte:ByteArray):void
//		{
//			
//		}
		public static function readS24(byte:ByteArray):int
		{
			var b:int = byte.readUnsignedByte()
			b |= byte.readUnsignedByte()<<8
			b |= byte.readByte()<<16
			return b
		}
		
		public static function readVariableLengthUnsigned32(byte:ByteArray):uint
		{
			var result:int = byte.readUnsignedByte();
			if (!(result & 0x00000080))
				return result;
			result = result & 0x0000007f | byte.readUnsignedByte()<<7;
			if (!(result & 0x00004000))
				return result;
			result = result & 0x00003fff | byte.readUnsignedByte()<<14;
			if (!(result & 0x00200000))
				return result;
			result = result & 0x001fffff | byte.readUnsignedByte()<<21;
			if (!(result & 0x10000000))
				return result;
			return   result & 0x0fffffff | byte.readUnsignedByte()<<28;
		}
		
		public static function replayVU32(src:ByteArray,value:uint):int
		{
			var oldPosition:int = src.position;
			var result:int = src.readUnsignedByte();
			var length:int = 1;
			var lengthDelta:int = 0;
			if (result & 0x00000080)
			{
				result = result & 0x0000007f | src.readUnsignedByte()<<7;
				length++;
			}
			if (result & 0x00004000)
			{
				result = result & 0x00003fff | src.readUnsignedByte()<<14;
				length++;
			}
			if (result & 0x00200000)
			{
				result = result & 0x001fffff | src.readUnsignedByte()<<21;
				length++;
			}
			if (result & 0x10000000)
			{
				result =  result & 0x0fffffff | src.readUnsignedByte()<<28;
				length++;
			}
			
			var newVU32Byte:ByteArray = new ByteArray;
			lengthDelta = writeVU32(newVU32Byte,value) - length;
			replayAndAddBytes(src,oldPosition,length,newVU32Byte);
			return lengthDelta;
		}
	}
}