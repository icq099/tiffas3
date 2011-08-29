package format.swf
{
	import flash.utils.ByteArray;

	public class Option_detail extends ABCFileStructs
	{
		/*
		option_detail
		{
			u30 val
			u8 kind
		}
		 */
		public var val:uint;
		public var kind:uint;
		public function Option_detail(byte:ByteArray)
		{
			super(byte);
		}
		protected override function read():void
		{
			val=readUnsigned30();
			kind=byte.readUnsignedByte();
		}
		
	}
}