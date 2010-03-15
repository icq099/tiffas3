package yzhkof
{
	import flash.utils.ByteArray;
	
	public class BytesUtil
	{
		public function BytesUtil()
		{
			throw new Error("Can't be new!");
		}
		public static function bytePerBit(byte:int):Array{
			
			var mask:uint=0x1;
			var re_array:Array=new Array();
			
			for(var i:int=0;i<8;i++){
				
				re_array.push(byte>>>(7-i)&mask);
			
			}
			return re_array;
		
		}
//		public static function readBytes(byte:int,isSign:Boolean=false):int{
//			var value:Array=new Array;
//			for(var i:int=0;i<byte.length-2;i++){
//				value.push(byte.readByte());
//			}
//			if(isSign){
//				value.push(byte.readByte();
//			}else{
//				value.push(byte.read
//			}
//			
//		}
		public static function readUnsignBits(bytes:int,length:int):uint{
			var mask:int=Math.pow(2,length)-1;
			var re_byte:int=bytes & mask;
			return re_byte;
		}
		public static function readBits(bytes:int,length:int):int{
			var re_byte:int=readUnsignBits(bytes,length);
			if(re_byte>(Math.pow(2,length-1)-1)){
				re_byte=~re_byte+1;
			}
			return re_byte;
		}
//		public static function readBits(byte:int,length:int):int{
//			
//		}
	}
}