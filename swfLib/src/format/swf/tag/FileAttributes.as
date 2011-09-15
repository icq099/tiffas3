package format.swf.tag
{
	import format.swf.SwfTag;
	import format.swf.TagReader;
	
	public class FileAttributes extends TagReader
	{
		public var context:uint;
		
		public function FileAttributes(tag:SwfTag)
		{
			super(tag);
		}
		
		override protected function read():void
		{
			context = byte.readUnsignedInt();
		}
	}
}