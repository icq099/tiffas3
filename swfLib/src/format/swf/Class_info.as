package format.swf
{
	import flash.utils.ByteArray;

	public class Class_info extends ABCFileStructs
	{
		/* 
		class_info
		{
			u30 cinit
			u30 trait_count
			traits_info traits[trait_count]
		}
		*/
		public var cinit:uint;
		public var trait_count:uint;
		public var traits:Array=new Array;
		public function Class_info(byte:ByteArray)
		{
			super(byte);
		}
		protected override function read():void
		{
			cinit=readUnsigned30();
			trait_count=readUnsigned30();
			var i:int;
			for(i=0;i<trait_count;i++)
			{
				traits.push(new Traits_info(byte));
			}
		}
		
	}
}