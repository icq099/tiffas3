package format.swf
{
	import flash.utils.ByteArray;

	public class Trait_class extends ABCFileStructs
	{
		/*
		trait_class
		{
			u30 slot_id
			u30 classi
		}  
		*/
		public var slot_id:uint;
		public var classi:uint;
		public function Trait_class(byte:ByteArray)
		{
			super(byte);
		}
		protected override function read():void
		{
			slot_id=readUnsigned30();
			classi=readUnsigned30();
		}
		
	}
}