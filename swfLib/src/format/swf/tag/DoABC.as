package format.swf.tag
{
	import flash.utils.ByteArray;
	
	import format.swf.ABCFile;
	import format.swf.SwfTag;
	import format.swf.TagReader;

	public class DoABC extends TagReader
	{
		public var flags:uint;
		public var name:String;
		public var abcfile:ABCFile;
		public function DoABC(tag:SwfTag)
		{
			super(tag);
		}
		protected override function read():void
		{
			flags=byte.readUnsignedInt();
			name=readString();
			abcfile=new ABCFile(byte);
		}
		
	}
}