package swfguarder
{
	import flash.display.Loader;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import format.swf.BytesUtils;
	import format.swf.Instance_info;
	import format.swf.Method_body_info;
	import format.swf.Method_info;
	import format.swf.OpCodes;
	import format.swf.Script_info;
	import format.swf.Trait_class;
	import format.swf.Traits_info;
	import format.swf.tag.DoABC;
	import format.swf.tag.TagOfSwf;
	import format.swf.utils.SwfFileCode;
	import format.swf.writer.SwfWriter;
	
	import mx.rpc.mxml.Concurrency;

	public class AddJumpOperation extends SwfGuarderOperation
	{
		private var data:ByteArray;
		
		public var finalData:ByteArray;
		
		private var addCodeSwf:ByteArray;

		private var methodBody:Method_body_info;
		
//		[Embed(source="./bin-debug/switchcode",mimeType="application/octet-stream")]
//		private var switchcode:Class;
		
		public function AddJumpOperation(data:ByteArray)
		{
			this.data = data;
			finalData = data;
		}
		
		public function doData():void
		{
			var totalLengthDelta:uint = 0;
			var swfFile:SwfFileCode = new SwfFileCode(data);
			var addCodeSwf:ByteArray = swfFile.bytesUncompressWithOutHeader;
			
			var jumpCode:ByteArray = getJumpCode();
//			var startCode:ByteArray = getStartCode();
			var methodBody_arr:Array;
			
			if(swfFile.documentDoabc == null)
			{
				onComplete.dispatch(finalData);
				return;
			}
			
			var doabc_arr:Array = swfFile.doabc_array;
			for each (var doabc:DoABC in doabc_arr) 
			{
				var lengthDelta:uint = 0;
				var instance_arr:Array = [];
				methodBody_arr = doabc.abcfile.method_body;
				instance_arr = doabc.abcfile.instance;
				
				var classInitMethodBodyArr:Array = [];
				
				for each (var instanceInfo:Instance_info in instance_arr) 
				{
					var initMethodBody:Method_body_info = methodBody_arr[instanceInfo.iinit];
					if(initMethodBody)
						classInitMethodBodyArr.push(initMethodBody);
				}
				
				for(var i:int = 0;i < classInitMethodBodyArr.length;i++)
				{
					methodBody = classInitMethodBodyArr[i] as Method_body_info;
					
					var code:ByteArray = BytesUtils.copyBytes(methodBody.code);
						
					addCodeSwf.position = methodBody.code_length_offset + lengthDelta +totalLengthDelta;
					lengthDelta += SwfWriter.replayVU32(addCodeSwf,jumpCode.length + methodBody.code_length /*+ startCode.length*/);
					
//					lengthDelta += SwfWriter.replayAndAddBytes(addCodeSwf,methodBody.code_offset + lengthDelta + totalLengthDelta ,0,startCode);
					lengthDelta += SwfWriter.replayAndAddBytes(addCodeSwf,methodBody.code_offset + lengthDelta + totalLengthDelta + methodBody.code.length,0,jumpCode);
				}
				
				var addTagLengthByte:ByteArray = new ByteArray;
				var oldTagHeaderLength:int = (doabc.tag.length >= 0x3f)?6:2;
				SwfWriter.writeSwfTagCodeAndLength(addTagLengthByte,swfFile.documentDoabcTag,doabc.tag.length + lengthDelta);
				totalLengthDelta += SwfWriter.replayAndAddBytes(addCodeSwf,doabc.tag.offset + totalLengthDelta,oldTagHeaderLength,addTagLengthByte);//新的DoABC tag Header写进swf;
				totalLengthDelta += lengthDelta;
			}
			
			
			var header:ByteArray = swfFile.bytesHeaderTag;
			header.position = 4;
			header.writeInt(addCodeSwf.length + 8);
			finalData = SwfWriter.getSwfByteData(header,addCodeSwf);//生成新的swf
			
			onComplete.dispatch(finalData);
		}
		
		private function getStartCode():ByteArray
		{
			var byte:ByteArray = new ByteArray;
			byte.endian = Endian.LITTLE_ENDIAN;
			
			return byte;
		}
		
		private function getJumpCode():ByteArray
		{
			var byte:ByteArray = new ByteArray;
			byte.endian = Endian.LITTLE_ENDIAN;
//			var byte:ByteArray = ByteArray(new switchcode);
//			byte.endian = Endian.LITTLE_ENDIAN;
//			byte.position = 119 + 4;
//			SwfWriter.replayVU32(byte,0x12222222);
//			byte.position = 53 + 4;
//			SwfWriter.replayVU32(byte,0x12222222);
			
//			byte.writeByte(0x09);//lab
			
//			byte.writeByte(0x40);
//			SwfWriter.writeVU32(byte,1);
			
//			byte.writeByte(0x00);
//			byte.writeByte(0x10);//jump
//			SwfWriter.writeS24(byte,9);
			byte.writeByte(0x1b);
			SwfWriter.writeS24(byte,-1);
			SwfWriter.writeVU32(byte,0x10000000);
			
			return byte;
		}
		
	}
}