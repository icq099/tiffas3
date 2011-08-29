package format.swf
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	public class Method_body_info extends ABCFileStructs
	{
		/*  
		method_body_info
		{
			u30 method
			u30 max_stack
			u30 local_count
			u30 init_scope_depth
			u30 max_scope_depth
			u30 code_length
			u8 code[code_length]
			u30 exception_count
			exception_info exception[exception_count]
			u30 trait_count
			traits_info trait[trait_count]
		}
		*/
		
		public var method:uint;
		public var max_stack:uint;
		public var local_count:uint;
		public var init_scope_depth:uint;
		public var max_scope_depth:uint;
		public var code_length:uint;
//		public var code:Array=new Array;
		public var code:ByteArray = new ByteArray;
		public var exception_count:uint;
		public var exception:Array=new Array;
		public var trait_count:uint;
		public var trait:Array=new Array;
		public var opcodes:OpCodes;
		
		public function Method_body_info(byte:ByteArray)
		{
			super(byte);
		}
		protected override function read():void
		{
			method=readUnsigned30();
			max_stack=readUnsigned30();
			local_count=readUnsigned30();
			init_scope_depth=readUnsigned30();
			max_scope_depth=readUnsigned30();
			code_length=readUnsigned30();
			
			code.endian = Endian.LITTLE_ENDIAN;
			byte.readBytes(code,0,code_length);
			code.position = 0;
			
			opcodes = new OpCodes(code);
			
			var i:int;
//			for(i=0;i<code_length;i++)
//			{
//				code.push(byte.readUnsignedByte());
//			}
			exception_count=readUnsigned30();
			for(i=0;i<exception_count;i++)
			{
				exception.push(new Exception_info(byte));
			}
			trait_count=readUnsigned30();
			for(i=0;i<trait_count;i++)
			{
				trait.push(new Traits_info(byte));
			}
		}
		
	}
}