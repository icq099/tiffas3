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
		private var doabcType:int = 0;
		/**
		 * 
		 * @param tag
		 * @param type 为0时代表正常DoABC标签，为1时代表特殊DoABC标签;
		 * 
		 */		
		public function DoABC(tag:SwfTag,doabcType:int = 0)
		{
			this.doabcType = doabcType;
			super(tag);
		}
		protected override function read():void
		{
			if(doabcType == 0)
			{
				flags=byte.readUnsignedInt();
				name=readString();
			}
			abcfile=new ABCFile(byte);
		}
		
	}
}