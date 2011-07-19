package format.swf
{
	import flash.utils.ByteArray;
	
	public class TagReader
	{
		protected var byte:ByteArray;
		public function TagReader(byte:ByteArray)
		{
			this.byte=byte;
			read();
		}
		protected function read():void
		{
			
		}
		protected function readString():String
		{
			var text:String = "";
			
			try
			{
				var v:int = byte.readUnsignedByte();
				while (v)
				{
					text += String.fromCharCode(v);
					v = byte.readUnsignedByte();
				}
			}
			catch (e:Error)
			{};
			
			return text;
		}

	}
}