package format.swf
{
	import flash.utils.ByteArray;

	public class String_info extends ABCFileStructs
	{
		/*
		 string_info
		{
			u30 size
			u8 utf8[size]
		} 
		*/
		public var size:uint;
		public var utf8:Array;
		public var utf8str:String;
		public function String_info(byte:ByteArray)
		{
			super(byte);
		}
		protected override function read():void
		{
			size=readUnsigned30();
//			utf8=new Array;
//			for(var i:int=0;i<size;i++)
//			{
//				utf8.push(byte.readUnsignedByte());
//			}
			utf8str=byte.readUTFBytes(size);
		}
		
	}
}