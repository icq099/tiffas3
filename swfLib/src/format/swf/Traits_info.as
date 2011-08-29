package format.swf
{
	import flash.utils.ByteArray;
	
	import yzhkof.util.BitReader;

	public class Traits_info extends ABCFileStructs
	{
		/*
		traits_info
		{
			u30 name
			u8 kind
			u8 data[]
			u30 metadata_count
			u30 metadata[metadata_count]
		}
		  */
		public var name:uint;
		public var kind:uint
		public var data:ABCFileStructs;
		public var metadata_count:uint;
		public var metadata:Array=new Array;

		public var upper:uint;

		public var type:uint;
		public function Traits_info(byte:ByteArray)
		{
			super(byte);
		}
		protected override function read():void
		{
			name=readUnsigned30();
//			var string_index:uint=cpool_info.multiname[name].name; 
			//trace(cpool_info.string[string_index].utf8str);
			
			kind=byte.readUnsignedByte();
			
			upper= kind >> 4;
			type=kind&0xf;
			switch(type)
			{
				case 0:
					data=new Trait_Slot(byte);
				break;
				case 1:
				case 2:
					data=new Trait_method(byte);
				break;
				case 3:
					data=new Trait_method(byte);
				break;
				case 4:
					data=new Trait_class(byte);
				break;
				case 5:
					data=new Trait_function(byte);
				break;
				case 6:
					data=new Trait_Slot(byte);
				break;
			}
			if((upper&0x4)!=0){
				metadata_count=readUnsigned30();
				var i:int;
				for(i=0;i<metadata_count;i++)
				{
					metadata.push(readUnsigned30());
				}
			}
		}
		
	}
}