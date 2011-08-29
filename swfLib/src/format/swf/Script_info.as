package format.swf
{
	import flash.utils.ByteArray;

	public class Script_info extends ABCFileStructs
	{
		/*
		script_info
		{
			u30 init
			u30 trait_count
			traits_info trait[trait_count]
		}
		  
		*/
		public var init:uint;
		public var trait_count:uint;
		public var trait:Array=new Array;
		public function Script_info(byte:ByteArray)
		{
			super(byte);
		}
		protected override function read():void
		{
			init=readUnsigned30();
			trait_count=readUnsigned30();
			var i:int;
			for(i=0;i<trait_count;i++)
			{
				trait.push(new Traits_info(byte));
			}
		}
		
	}
}