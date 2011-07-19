package format.swf
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	public class SymbolClass extends TagReader
	{
		public var numSymbols:int;
		public var tag:Array = [];
		public var name:Array = [];
		public var tagToNameMap:Dictionary = new Dictionary;
		
		public function SymbolClass(byte:ByteArray)
		{
			super(byte);
		}
		override protected function read():void
		{
			numSymbols = byte.readUnsignedShort();
			for (var i:int = 0; i < numSymbols; i++) 
			{
				var t:int = byte.readUnsignedShort();
				var n:String = readString();
				tagToNameMap[t] = n;
				tag.push(t);
				name.push(n);
			}
		}
	}
}