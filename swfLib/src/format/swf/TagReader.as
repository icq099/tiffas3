package format.swf
{
	import flash.utils.ByteArray;
	
	import yzhkof.util.BitReader;
	
	public class TagReader
	{
		protected var byte:ByteArray;
		public var tag:SwfTag;
		public function TagReader(tag:SwfTag)
		{
			this.byte = tag.data;
			this.tag = tag;
			
			var t:uint=byte.readUnsignedShort();
			var shortTagLength:int=BitReader.getBytesBits(t,16,10,16);
			
			if(shortTagLength>=0x3f)
			{
				byte.readInt();	
			}
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