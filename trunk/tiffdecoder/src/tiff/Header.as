package tiff
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	public class Header
	{
		public static const TIFF_VERSION:int=42; //0x2a
		public static const TIFF_BIGENDIAN:int=0x4d4d;
		public static const TIFF_LITTLEENDIAN:int=0x4949;
		public static const SIZE:int=8;
		
		public var byteOrder:int;
		public var id:int;
		public var offset:uint;
		
		public function Header()
		{
			init();
		}
		private function init():void{
			
			byteOrder=TIFF_LITTLEENDIAN;
			id=TIFF_VERSION;
			offset=10;
		
		}
		public function read(inb:ByteArray):void{
			
			byteOrder=inb.readUnsignedShort();
			inb.endian=(byteOrder==Header.TIFF_LITTLEENDIAN)?Endian.LITTLE_ENDIAN:Endian.BIG_ENDIAN;
			id=inb.readUnsignedShort();
			offset=inb.readInt();
		
		}
		

	}
}