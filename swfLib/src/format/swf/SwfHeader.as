package format.swf
{
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import yzhkof.util.BitReader;
	
	public class SwfHeader
	{
		public var format:String;
		public var playerVersion:int;
		public var sizeAfterUncompress:uint;
		public var frameRate:uint;
		public var frameSize:Rectangle;
		public var frameCount:uint;
		public var headerLength:uint;
		
		private var byte:ByteArray;
		private var bitReader:BitReader;
		private var _uncompressBytes:ByteArray=new ByteArray;
		/**
		 *	传入byte字节数组，注意position的位置与endian(Endian.LITTLE_ENDIAN); 
		 * @param byte
		 * 
		 */		
		public function SwfHeader(byte:ByteArray)
		{
			this.byte=byte;
			read();
		}
		private function read():void
		{
			format=byte.readUTFBytes(3);
			playerVersion=byte.readUnsignedByte();
			sizeAfterUncompress=byte.readUnsignedInt();
			byte.readBytes(_uncompressBytes);
			_uncompressBytes.endian=Endian.LITTLE_ENDIAN;
			if(format=="CWS")
			{
				_uncompressBytes.uncompress();
			}else if(format!="FWS")			{
				throw new Error("不是swf文件");
			}
			
			bitReader=new BitReader(_uncompressBytes);
			var sb_length:uint=bitReader.readUnSignBits(5);
			/**
			 *	原单位为磅，所以除以20 
			 */			
			var Xmin:int=bitReader.readUnSignBits(sb_length)/20;
			var Xmax:int=bitReader.readUnSignBits(sb_length)/20;
			var Ymin:int=bitReader.readUnSignBits(sb_length)/20;
			var Ymax:int=bitReader.readUnSignBits(sb_length)/20;
			
			frameSize=new Rectangle(Xmax,Ymin,Xmax-Xmin,Ymax-Ymin);
			
			frameRate=_uncompressBytes.readUnsignedShort()/256;//此处似乎为BigEndian
			frameCount=_uncompressBytes.readUnsignedShort();
			/**
			*	未压缩的为头8字节 
			*/			
			headerLength=_uncompressBytes.position;
		}
		public function get tagBytes():ByteArray
		{
			_uncompressBytes.position=headerLength;
			return _uncompressBytes;
		}
		public function get uncompressBytes():ByteArray
		{
			_uncompressBytes.position=0;
			return _uncompressBytes;	
		}
		public function get headerUncompressBytes():ByteArray
		{
			return BytesUtils.snapShotBytes(byte,8,0);
		}

	}
}