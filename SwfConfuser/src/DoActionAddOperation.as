package
{
	import flash.utils.ByteArray;
	
	import format.swf.SwfFile;
	import format.swf.SwfTag;
	import format.swf.writer.SwfWriter;

	public class DoActionAddOperation
	{
		[Embed(source="./bin-debug/doaction",mimeType="application/octet-stream")]
		private var doactionClass:Class;

		private var data:ByteArray;
		
		public var finalData:ByteArray;
		
		private var addCodeSwf:ByteArray;
		
		public function DoActionAddOperation(data:ByteArray)
		{
			this.data = data;
			doData();
		}
		
		private function doData():void
		{
			var swfFile:SwfFile = new SwfFile(data);
			addCodeSwf = swfFile.bytesUncompressWithOutHeader;
			var doactionBytes:ByteArray = ByteArray(new doactionClass);
			var doactionOffset:uint = SwfTag(swfFile.tagReader.tagArray[2]).offset;
			SwfWriter.replayAndAddBytes(addCodeSwf,doactionOffset,0,doactionBytes);
			//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
			var header:ByteArray = swfFile.bytesHeaderTag;
			header.position = 4;
			header.writeInt(addCodeSwf.length + 8);
			finalData = SwfWriter.getSwfByteData(header,addCodeSwf);//生成新的swf
		}
	}
}