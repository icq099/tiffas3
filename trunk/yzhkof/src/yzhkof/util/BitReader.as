package yzhkof.util
{
	import flash.utils.ByteArray;
	
	public class BitReader
	{
		private var byte:ByteArray;
		private var bitPosition:int=0;
		public function BitReader(byte:ByteArray)
		{
			this.byte=byte;
		}
		public function resetBitPosition():void
		{
			bitPosition=0;
		}
		/**
		 *	从字节数组里读取一无符号的值
		 * 	
		 * 	当位数不足8的倍数时，会忽略余下的位
		 * 	
		 * 	例如：1001 1001 0110 1000
		 * 
		 * 		使用readUnSignBits(10)后，传入的byte字节数组position将增加2(Math.ceil(10/8)=2)
		 * 
		 * @param num	要读取的位长
		 * @return	
		 * 
		 */		
		public function readUnSignBits(num:uint):uint
		{
			var lastLength:int=(bitPosition+num)%8;
			var byteLength:int=Math.ceil((bitPosition+num)/8);
			var whileCount:int=byteLength;
			var finalValue:uint=0;
			
			if(bitPosition>0)
				byte.position--;
			
			
			while(whileCount>1)
			{
				var c_value:int=byte.readUnsignedByte();
				finalValue+=getBytesBits(c_value,8,bitPosition,8);
				whileCount--;
				if(whileCount>1)
				{
					finalValue=finalValue<<8;
				}else
				{
					finalValue=finalValue<<(lastLength==0?8:lastLength);
				}
				bitPosition=0;
			}
			if((lastLength==0)&&(num>0))
			{
				finalValue+=getBytesBits(byte.readUnsignedByte(),8,bitPosition,8);		
			}else
			{
				finalValue+=getBytesBits(byte.readUnsignedByte(),8,0,lastLength);
			}
			bitPosition=lastLength;
			return finalValue;
		}
		/**
		 *	截取bytes里的某些位
		 * @param value	输入的字节
		 * @param size	字节的大小（单位：位）
		 * @param start	开始截取的位数
		 * @param end	结束截取的位数
		 * @return 	所截取的位值
		 * 
		 */		
		public static function getBytesBits(value:int,size:uint,start:int,end:int):int
		{
			var mask:int=(1<<(end-start))-1;
			return (value>>(size-end))&mask;
		}

	}
}