package format.swf
{
	import flash.utils.ByteArray;

	public class Option_info extends ABCFileStructs
	{
		/*
		option_info
		{
			u30 option_count
			option_detail option[option_count]
		}
		
		*/
		public var option_count:uint;
		public var option:Array;
		public function Option_info(byte:ByteArray)
		{
			super(byte);
		}
		protected override function read():void
		{
			option_count=readUnsigned30();
			//debug;
			if(option_count==0)
			{
				trace(this);	
			}
			option=new Array;
			for(var i:int=0;i<option_count;i++)
			{
				option.push(new Option_detail(byte));
			}
		}
		
	}
}