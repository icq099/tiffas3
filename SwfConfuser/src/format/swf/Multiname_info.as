package format.swf
{
	import flash.utils.ByteArray;

	public class Multiname_info extends ABCFileStructs
	{
		/*
		multiname_info
		{
			u8 kind
			u8 data[]
		} 
		multiname_kind_QName
		{
			u30 ns
			u30 name
		} 
		multiname_kind_RTQName
		{
			u30 name
		}
		multiname_kind_Multiname
		{
			u30 name
			u30 ns_set
		}
		multiname_kind_MultinameL
		{
			u30 ns_set
		}
		*/
		public var kind:uint;
		public var ns:uint;
		public var name:uint;
		public var ns_set:uint;
		public function Multiname_info(byte:ByteArray)
		{
			super(byte);
		}
		protected override function read():void
		{
			kind=byte.readUnsignedByte();
			readData();	
		}
		private function readData():void
		{
			switch(kind)
			{
				case 0x07:
				case 0x0d:
					ns=readUnsigned30();
					name=readUnsigned30();
				break;
				case 0x0f:
				case 0x10:
					name=readUnsigned30();
				break;
				case 0x11:
				case 0x12:
					name=0;
				break;
				case 0x09:
				case 0x0e:
					name=readUnsigned30();
					ns_set=readUnsigned30();
				break;
				case 0x1b:
				case 0x1c:
					ns_set=readUnsigned30();
				break;
				case 0x1d:
					ns=readUnsigned30();
					name=readUnsigned30();
					ns_set=readUnsigned30(); 
				break;
				default:
					throw new Error("unknown:" + kind.toString(16));
				break;
			}
			//byte.position+=passLength;
		}
		
	}
}