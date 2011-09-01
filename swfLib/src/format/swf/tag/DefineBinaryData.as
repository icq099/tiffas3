package format.swf.tag
{
	import flash.utils.ByteArray;
	
	import format.swf.SwfTag;
	import format.swf.TagReader;
	
	public class DefineBinaryData extends TagReader
	{
		public var Tag:int;
		public var Reserved:int;
		public var Data:ByteArray;
		
		public function DefineBinaryData(tag:SwfTag)
		{
			super(tag);
		}
		
		override protected function read():void
		{
			Tag = byte.readShort();
			Reserved = byte.readInt();
			Data = new ByteArray;
			byte.readBytes(Data,0,tag.length - 6);
		}
	}
}