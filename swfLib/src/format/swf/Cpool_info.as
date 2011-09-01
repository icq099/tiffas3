package format.swf
{
	import flash.utils.ByteArray;

	public class Cpool_info extends ABCFileStructs
	{
		/* 
		cpool_info
		{
			u30 int_count
			s32 integer[int_count]
			u30 uint_count
			u32 uinteger[uint_count]
			u30 double_count
			d64 double[double_count]
			u30 string_count
			string_info string[string_count]
			u30 namespace_count
			namespace_info namespace[namespace_count]
			u30 ns_set_count
			ns_set_info ns_set[ns_set_count]
			u30 multiname_count
			multiname_info multiname[multiname_count]
		}	 
		*/
		public var int_count:uint;
		public var integer:Array;//<S32>[int_count]
		public var uint_count:uint;
		public var uinteger:Array;
		public var double_count:uint;
		public var double:Array;
		public var string_count:uint;
		public var string:Array;//<String_info>
		public var namespace_count:uint;
		public var namespace_abc:Array;
		public var ns_set_count:uint;
		public var ns_set:Array;
		public var multiname_count:uint;
		public var multiname:Array;

		public var int_offset:uint;
		public var uint_offset:uint;
		public var double_offset:uint;
		public var string_offset:uint;
		public var namespace_offset:uint;
		public var ns_set_offset:uint;
		public var multiname_offset:uint;
		
		public function Cpool_info(byte:ByteArray)
		{
			super(byte);
		}
		protected override function read():void
		{
			int_offset = byte.position;
			int_count=readUnsigned30();
			integer=new Array;
			integer.push(0);
			for(var i:int=1;i<int_count;i++)
				integer.push(readVariableLength32());
			
			uint_offset = byte.position;
			uint_count=readUnsigned30();
			uinteger=new Array;
			uinteger.push(0);
			for(i=0;i<uint_count;i++)
				uinteger.push(readVariableLengthUnsigned32());
			
			double_offset = byte.position;
			double_count=readUnsigned30();
			double=new Array;
			double.push(0);
			for(i=1;i<double_count;i++)
				double.push(byte.readDouble());
			
			string_offset = byte.position;
			string_count=readUnsigned30();
			string=new Array;
			string.push(new String_info(new ByteArray));
			for(i=1;i<string_count;i++)
				string.push(new String_info(byte));
			
			namespace_offset = byte.position;
			namespace_count=readUnsigned30();
			namespace_abc=new Array;
			namespace_abc.push(0);
			for(i=1;i<namespace_count;i++)
				namespace_abc.push(new Namespace_info(byte));
			
			ns_set_offset = byte.position;
			ns_set_count=readUnsigned30();
			ns_set=new Array;
			ns_set.push(0);
			for(i=1;i<ns_set_count;i++)
				ns_set.push(new Ns_set_info(byte));
			
			multiname_offset = byte.position;
			multiname_count=readUnsigned30();
			multiname=new Array;
			multiname.push(0);
			for(i=1;i<multiname_count;i++)
				multiname.push(new Multiname_info(byte));
		}
		
	}
}