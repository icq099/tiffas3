package format.swf.writer
{
	import flash.utils.ByteArray;
	
	import format.swf.BytesUtils;
	
	public class SwfWriter
	{
		public function SwfWriter()
		{
		}
		public static function getSwfByteData(headerTag:ByteArray,uncompressBytes:ByteArray):ByteArray
		{
			var headerTag_c:ByteArray=BytesUtils.copyBytes(headerTag);
			var uncompressBytes_c:ByteArray=BytesUtils.copyBytes(uncompressBytes);
			var swf:ByteArray=new ByteArray;
			uncompressBytes_c.compress();
			uncompressBytes_c.position=0;
			swf.writeBytes(headerTag_c);
			swf.writeBytes(uncompressBytes_c);
			swf.position=0;
			return swf;
		}

	}
}