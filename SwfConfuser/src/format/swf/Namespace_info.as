package format.swf
{
	import flash.utils.ByteArray;

	public class Namespace_info extends ABCFileStructs
	{
		/* 
		namespace_info
		{
			u8 kind
			u30 name
		}
 		*/
		public var kind:uint;
		public var name:uint;
		public function Namespace_info(byte:ByteArray)
		{
			super(byte);
		}
		protected override function read():void
		{
			kind=byte.readUnsignedByte();
			name=readUnsigned30();
		}
		
	}
}