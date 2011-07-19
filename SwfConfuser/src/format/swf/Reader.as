package format.swf
{
	import flash.utils.ByteArray;
	
	public class Reader
	{
		protected var byte:ByteArray
		protected var _offset:uint;
		protected var _length:uint=0;
		public function Reader(byte:ByteArray)
		{
			this.byte=byte;
			_offset=byte.position;
			if(byte.bytesAvailable>0)
			{
				read();
			}
			_length=byte.position-_offset;
		}
		public function get offset():uint
		{
			return _offset;
		}
		public function get length():uint
		{
			return _length;
		}
		public function getByteArray():ByteArray
		{
			return byte;
		}
		protected function read():void
		{
			
		}

	}
}