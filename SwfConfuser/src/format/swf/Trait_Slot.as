package format.swf
{
	import flash.utils.ByteArray;

	public class Trait_Slot extends ABCFileStructs
	{
		/*
		trait_slot
		{
			u30 slot_id
			u30 type_name
			u30 vindex
			u8 vkind
		}
		 */
		public var slot_id:uint;
		public var type_name:uint;
		public var vindex:uint;
		public var vkind:uint;
		public function Trait_Slot(byte:ByteArray)
		{
			super(byte);
		}
		protected override function read():void
		{
			slot_id=readUnsigned30();
			type_name=readUnsigned30();
			vindex=readUnsigned30();
			if(vindex!=0)
			{
				vkind=byte.readUnsignedByte();
			}
		}
		
	}
}