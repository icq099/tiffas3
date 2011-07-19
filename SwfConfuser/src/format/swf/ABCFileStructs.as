package format.swf
{
	import flash.utils.ByteArray;
	
	public class ABCFileStructs extends Reader
	{
		public function ABCFileStructs(byte:ByteArray)
		{
			super(byte);
		}
		public function readVariableLength32():int
		{
			var result:int = readVariableLengthUnsigned32();
			
            if( 0 != ( result & 0x80000000 ) )
            {
                result &= 0x7fffffff;
                result -= 0x80000000;
            }
            return result;
		}
		public function readVariableLengthUnsigned32():uint
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
//			var b:int = byte.readUnsignedByte();
//    
//            var u32:uint = b;
//			
//			var bytes_count:uint = 1;
//			
//			var bit_mask:uint ;
//			
//			var mask:uint = 1<<7;
//			
//			while(true)
//			{
//				bit_mask = 1<<(bytes_count*7);
//				if( !(b & mask) )
//				{
//					break;
//				}
//				b = byte.readUnsignedByte();
//				u32 = u32 & (bit_mask-1) | (b<<(bytes_count*7));
//				bytes_count++;
//				if(bytes_count>5)
//				{
//					break;
//				}
//			}
//			return u32;
    
            /*if( ! ( u32 & 0x00000080 ) )
            {
                return u32;
            }
    
            b = byte.readUnsignedByte();
    
            u32 = u32 & 0x0000007f | b <<7;
    
            if( !( u32 & 0x00004000 ) )
            {
                return u32;
            }
    
            b = byte.readUnsignedByte();
    
            u32 = u32 & 0x00003fff | b <<14;
    
            if( !( u32 & 0x00200000 ) )
            {
                return u32;
            }
    
            b = byte.readUnsignedByte();
    
            u32 = u32 & 0x001fffff | b <<21;
    
            if( !( u32 & 0x10000000 ) )
            {
                return u32;
            }
    
            b = byte.readUnsignedByte();
    
            u32 = u32 & 0x0fffffff | b <<28;
    
            return u32;*/

		}
		public function readUnsigned30():uint
		{
			return readVariableLengthUnsigned32()&0x3fffffff;
		}
		public function readS24():int
		{
			var b:int = byte.readUnsignedByte()
			b |= byte.readUnsignedByte()<<8
			b |= byte.readByte()<<16
			return b
		}

	}
}