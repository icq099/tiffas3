package format.swf
{
	import flash.utils.ByteArray;

	public class Trait_function extends ABCFileStructs
	{
		/*
		trait_function
		{
			u30 slot_id
			u30 function
		}
		*/
		public var slot_id:uint;
		public var function_abc:uint;
		public function Trait_function(byte:ByteArray)
		{
			super(byte);
		}
		protected override function read():void
		{
			slot_id=readUnsigned30();
			function_abc=readUnsigned30();
		}
		
	}
}