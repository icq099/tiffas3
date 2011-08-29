package format.swf
{
	import flash.utils.ByteArray;

	public class Instance_info extends ABCFileStructs
	{
		/*
		instance_info
		{
			u30 name
			u30 super_name
			u8 flags
			u30 protectedNs
			u30 intrf_count
			u30 interface[intrf_count]
			u30 iinit
			u30 trait_count
			traits_info trait[trait_count]
		}
		  */
		public var name:uint
		public var super_name:uint;
		public var flags:uint;
		public var protectedNs:uint;
		public var intrf_count:uint
		public var interface_abc:Array=new Array;
		public var iinit:uint;
		public var trait_count:uint;
		public var trait:Array=new Array;
		public function Instance_info(byte:ByteArray)
		{
			super(byte);
		}
		protected override function read():void
		{
			name=readUnsigned30();
			super_name=readUnsigned30();
			flags=byte.readUnsignedByte();
			if((flags&0x08)!=0)
			{
				protectedNs=readUnsigned30();
			}
			intrf_count=readUnsigned30();
			for(var i:int=0;i<intrf_count;i++)
			{
				interface_abc.push(readUnsigned30());
			}
			iinit=readUnsigned30();
			trait_count=readUnsigned30();
			for(i=0;i<trait_count;i++)
			{
				trait.push(new Traits_info(byte));
			}
		}
		
	}
}