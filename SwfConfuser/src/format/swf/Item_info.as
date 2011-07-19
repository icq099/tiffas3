package format.swf
{
	import flash.utils.ByteArray;

	public class Item_info extends ABCFileStructs
	{
		/* 
		item_info
		{
			u30 key
			u30 value
		}
		 */
		public var key:uint;
		public var value:uint;
		public function Item_info(byte:ByteArray)
		{
			super(byte);
		}
		protected override function read():void
		{
			key=readUnsigned30();
			value=readUnsigned30();
		}
		
	}
}