package swfguarder
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import format.swf.SwfFile;
	import format.swf.writer.SwfWriter;

	public class ShellAddOperation extends SwfGuarderOperation
	{
		private var data:ByteArray;
		
		[Embed(source="./asset/DeEncryWithOutDataTag.swf",mimeType="application/octet-stream")]
		private var SwfLoaderData:Class;
		
		private var DATA_TAG_OFFSET:int = 0x218;
		
		private var loaderData:ByteArray;
		
		private var v1:int = 20;
		private var v2:int = 12;
		private var v3:int = 17;
		private var v4:int = 18;
		private var v5:int = 19;
		private var v6:int = 10;
		private var v7:int = 13;
		private var v8:int = 21;
		
		private var newData:ByteArray;
		
		private var compressData:ByteArray;
		
		private var restHeaderData:ByteArray;
		
		private var unComperssData:ByteArray;
		
		private var loaderHeaderLength:int;
		
		private var values:Array = [v3,v2,v1,v8,v4,v6,v7,v5];
		
		public var finalData:ByteArray;
		
		public function ShellAddOperation(data:ByteArray)
		{
			this.data = data;
		}
		
		public function doData():void
		{
			loaderData = ByteArray(new SwfLoaderData);
			loaderData.position = 8;
			loaderHeaderLength = getRestHeadLength(loaderData.readByte()) + 8;
			
			restHeaderData = new ByteArray;
			restHeaderData.endian = Endian.LITTLE_ENDIAN;
			
			unComperssData = new ByteArray;
			unComperssData.endian = Endian.LITTLE_ENDIAN;
			
			data.position = 8;
			data.readBytes(unComperssData,0,data.length-8);
			data.position = 0;
			unComperssData.position = 0;
			if(data.readUTFBytes(3) == "CWS")
			{
				unComperssData.uncompress();
			};
			
			unComperssData.position = 0;
			
			restHeaderData.writeBytes(unComperssData,0,getRestHeadLength(unComperssData.readUnsignedByte()));
			
			
			data.position = 0;
			newData = new ByteArray;
			compressData = new ByteArray;
			compressData.endian = Endian.LITTLE_ENDIAN;
			newData.endian = Endian.LITTLE_ENDIAN;
			newData.writeUTFBytes("CWS");//文件头;
			newData.writeBytes(data,3,1);//Player版本;
			
			encryData();
			compressData.writeBytes(restHeaderData);
			compressData.writeBytes(loaderData,loaderHeaderLength,DATA_TAG_OFFSET - loaderHeaderLength);
			SwfWriter.writeSwfTagCodeAndLength(compressData,87,6 + data.length);
			compressData.writeShort(1);
			compressData.writeInt(0);
			compressData.writeBytes(data);
			compressData.writeBytes(loaderData,DATA_TAG_OFFSET,loaderData.length - DATA_TAG_OFFSET);
			
			newData.writeUnsignedInt(compressData.length + 8);//文件大小
			compressData.compress();
			newData.writeBytes(compressData);
			
			finalData = newData;
			onComplete.dispatch(finalData);
		}
		
		private function encryData():void
		{
			for each (var i:int in values) 
			{
				data = reData(i);
			}
		}
		
		private function reData(count:int):ByteArray
		{
			var t_data:ByteArray = new ByteArray;
			t_data.endian = Endian.LITTLE_ENDIAN;
			data.readBytes(t_data,count,data.length - count);
			data.readBytes(t_data,0,count);
			return t_data;
		}
		
		private function getRestHeadLength(byte:int):int
		{
			var bl:int = byte;
			bl = bl>>>3;
			var headByteCount:int = Math.ceil((bl*4 + 5)/8);//rect的长度;
			headByteCount += 4;
			return headByteCount;
		}
		
	}
}