package format.swf
{
	import flash.utils.ByteArray;

	public class Ns_set_info extends ABCFileStructs
	{
		/*
		ns_set_info
		{
			u30 count
			u30 ns[count]
		}
  		*/
  		public var count:uint;
  		public var ns:Array;
		public function Ns_set_info(byte:ByteArray)
		{
			super(byte);
		}
		protected override function read():void
		{
			count=readUnsigned30();
			ns=new Array;
			for(var i:int=0;i<count;i++)
			{
				ns.push(readUnsigned30());
			}
		}
		
	}
}