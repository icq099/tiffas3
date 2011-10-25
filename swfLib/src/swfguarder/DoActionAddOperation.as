package swfguarder
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import format.swf.SwfFile;
	import format.swf.SwfTag;
	import format.swf.tag.FileAttributes;
	import format.swf.tag.TagOfSwf;
	import format.swf.writer.SwfWriter;

	public class DoActionAddOperation extends SwfGuarderOperation
	{
		[Embed(source="./asset/doaction",mimeType="application/octet-stream")]
		private var doactionClass:Class;
		
		[Embed(source="./asset/tag",mimeType="application/octet-stream")]
		private var tagClass:Class;

		private var data:ByteArray;
		
		public var finalData:ByteArray;
		
		private var addCodeSwf:ByteArray;
		
		public function DoActionAddOperation(data:ByteArray)
		{
			this.data = data;
		}
		
		public function doData():void
		{
			var swfFile:SwfFile = new SwfFile(data);
			addCodeSwf = swfFile.bytesUncompressWithOutHeader;
			
			var fileAttributeTag:FileAttributes = swfFile.tagReader.getTagReaderByType(TagOfSwf.FileAttributes)[0];
			var fileAttributeContextInt:uint = fileAttributeTag.context|(1<<27);
			
			addCodeSwf.position = fileAttributeTag.tag.offset + 2;
			addCodeSwf.endian = Endian.BIG_ENDIAN;
			addCodeSwf.writeInt(fileAttributeContextInt);
			addCodeSwf.endian = Endian.LITTLE_ENDIAN;
			
			var addBytes:ByteArray = new ByteArray;
			addBytes.endian = Endian.LITTLE_ENDIAN;
			addBytes.writeBytes(ByteArray(new doactionClass));
			addBytes.writeBytes(ByteArray(new tagClass));
			var tag_arr:Array = swfFile.tagReader.tagArray;
			var doactionOffset:uint = SwfTag(tag_arr[tag_arr.length - 2]).offset;
			SwfWriter.replayAndAddBytes(addCodeSwf,doactionOffset,0,addBytes);
			//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
			var header:ByteArray = swfFile.bytesHeaderTag;
			header.position = 4;
			header.writeInt(addCodeSwf.length + 8);
			finalData = SwfWriter.getSwfByteData(header,addCodeSwf);//生成新的swf
			onComplete.dispatch(finalData);
		}
	}
}