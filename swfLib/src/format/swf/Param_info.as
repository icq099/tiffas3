package format.swf
{
	import flash.utils.ByteArray;

	public class Param_info extends ABCFileStructs
	{
		/*
		param_info
		{
			u30 param_name[param_count]
		}
		  */
		public var param_name:Array=new Array;
		private var param_count:uint;
		public function Param_info(byte:ByteArray,param_count:uint)
		{
			this.param_count=param_count;
			super(byte);
		}
		protected override function read():void
		{
			for(var i:int=0;i<param_count;i++)
			{
				param_name.push(readUnsigned30());
			}
		}
		
	}
}