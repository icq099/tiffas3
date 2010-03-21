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
				finalValue+=getByteBits(c_value,8,bitPosition,8);
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
				finalValue+=getByteBits(byte.readUnsignedByte(),8,bitPosition,8);		
			}else
			{
				finalValue+=getByteBits(byte.readUnsignedByte(),8,0,lastLength);
			}
			bitPosition=lastLength;
			return finalValue;
		}
		private function getByteBits(value:int,size:uint,start:int,end:int):int
		{
			var mask:int=(1<<(end-start))-1;
			return (value>>(size-end))&mask;
		}

	}
}