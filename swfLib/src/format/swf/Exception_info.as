package format.swf
{
	import flash.utils.ByteArray;

	public class Exception_info extends ABCFileStructs
	{
		/*  
		exception_info
		{
			u30 from
			u30 to
			u30 target
			u30 exc_type
			u30 var_name
		}
		*/
		public var from:uint;
		public var to_abc:uint;
		public var target:uint;
		public var exc_type:uint;
		public var var_name:uint;
		public function Exception_info(byte:ByteArray)
		{
			super(byte);
		}
		protected override function read():void
		{
			from=readUnsigned30();
			to_abc=readUnsigned30();
			target=readUnsigned30();
			exc_type=readUnsigned30();
			var_name=readUnsigned30();
		}
		
	}
}