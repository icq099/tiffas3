package format.swf
{
	import flash.utils.ByteArray;

	public class DoABC extends TagReader
	{
		public var flags:uint;
		public var name:String;
		public var abcfile:ABCFile;
		public function DoABC(byte:ByteArray)
		{
			super(byte);
		}
		protected override function read():void
		{
			flags=byte.readUnsignedInt();
			name=readString();
			abcfile=new ABCFile(byte);
		}
		
	}
}