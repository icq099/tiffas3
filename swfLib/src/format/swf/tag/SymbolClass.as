package format.swf.tag
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import format.swf.SwfTag;
	import format.swf.TagReader;
	
	public class SymbolClass extends TagReader
	{
		public var numSymbols:int;
		public var Tag:Array = [];
		public var name:Array = [];
		public var tagToNameMap:Dictionary = new Dictionary;
		
		public function SymbolClass(tag:SwfTag)
		{
			super(tag);
		}
		override protected function read():void
		{
			numSymbols = byte.readUnsignedShort();
			for (var i:int = 0; i < numSymbols; i++) 
			{
				var t:int = byte.readUnsignedShort();
				var n:String = readString();
				tagToNameMap[t] = n;
				Tag.push(t);
				name.push(n);
			}
		}
	}
}