package format.swf
{
	import flash.utils.ByteArray;

	public class Trait_method extends ABCFileStructs
	{
		/*
		trait_method
		{
			u30 disp_id
			u30 method
		}
		*/
		public var disp_id:uint;
		public var method:uint;
		public function Trait_method(byte:ByteArray)
		{
			super(byte);
		}
		protected override function read():void
		{
			disp_id=readUnsigned30();
			method=readUnsigned30();
		}
		
	}
}