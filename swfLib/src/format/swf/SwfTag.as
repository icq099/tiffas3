package format.swf
{
	import flash.utils.ByteArray;
	
	public class SwfTag
	{
		public var type:int;
		public var length:uint;
		public var offset:uint;
		
		private var byte:ByteArray;
		
		public function get data():ByteArray
		{
			byte.position=offset;
			return byte
		}
		public function SwfTag(byte:ByteArray)
		{
			this.byte=byte;
		}
		public function get cloneData():ByteArray
		{
			return BytesUtils.snapShotBytes(byte,length,offset);
		}

	}
}