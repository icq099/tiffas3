package assets.model
{
	import flash.utils.ByteArray;
	
	[RemoteClass(alias="HotPointStruct")]
	public class HotPointStruct
	{
		public var xml:ByteArray;
		public var imageName:Array;//type Sting
		public var image:Array;//type bytearray;
		public var soundName:String;
		public var sound:ByteArray;
		public var textName:String;
		public var text:ByteArray;
		public var videoName:String;
		public var video:ByteArray;
	}
}