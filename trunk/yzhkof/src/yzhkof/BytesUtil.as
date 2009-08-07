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
	}
}