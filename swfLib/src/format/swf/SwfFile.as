package format.swf
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	public class SwfFile
	{
		public var header:SwfHeader;
		public var tagReader:SwfTagReader;
		private var byte:ByteArray
		public function SwfFile(byte:ByteArray)
		{
			this.byte=BytesUtils.copyBytes(byte);
			this.byte.endian=Endian.LITTLE_ENDIAN;
			header=new SwfHeader(this.byte);
			tagReader=new SwfTagReader(header.tagBytes);
		}
		public function get bytesHeaderTag():ByteArray
		{
			return header.headerUncompressBytes;
		}
		public function get bytesUncompressWithOutHeader():ByteArray
		{
			return BytesUtils.snapShotBytes(header.uncompressBytes,header.uncompressBytes.length,0);
		}

	}
}