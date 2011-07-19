package format.swf
{
	import flash.utils.ByteArray;

	public class Metadata_info extends ABCFileStructs
	{
		/*
		metadata_info
		{
			u30 name
			u30 item_count
			item_info items[item_count]
		}
		*/
		public var name:uint;
		public var item_count:uint;
		public var items:Array=new Array;
		public function Metadata_info(byte:ByteArray)
		{
			super(byte);
		}
		protected override function read():void
		{
			name=readUnsigned30();
			item_count=readUnsigned30();
			for(var i:int=0;i<item_count;i++)
			{
				items.push(new Item_info(byte));	
			}
		}
		
	}
}